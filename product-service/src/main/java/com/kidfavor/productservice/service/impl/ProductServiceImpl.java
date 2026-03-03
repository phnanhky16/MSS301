package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.client.InventoryServiceClient;
import com.kidfavor.productservice.client.dto.ApiResponseDto;
import com.kidfavor.productservice.client.dto.StoreInventoryDto;
import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.dto.response.StoreStockInfo;
import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.entity.Category;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.enums.EntityStatus;
import com.kidfavor.productservice.exception.ResourceNotFoundException;
import com.kidfavor.productservice.mapper.ProductMapper;
import com.kidfavor.productservice.repository.BrandRepository;
import com.kidfavor.productservice.repository.CategoryRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import com.kidfavor.productservice.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.HashSet;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class ProductServiceImpl implements ProductService {
    
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final BrandRepository brandRepository;
    private final ProductMapper productMapper;
    private final InventoryServiceClient inventoryServiceClient;
    

    @Override
    @Transactional(readOnly = true)
        public org.springframework.data.domain.Page<ProductResponse> listProducts(
            org.springframework.data.domain.Pageable pageable,
            String keyword,
            Long categoryId,
            Long brandId,
            String status) {
        // build dynamic specification
        org.springframework.data.jpa.domain.Specification<Product> spec = (root, query, cb) -> {
            java.util.List<jakarta.persistence.criteria.Predicate> preds = new java.util.ArrayList<>();
            // by default (no status param) we only return ACTIVE products to
            // mimic original behaviour. if the caller passes "ALL" (case-
            // insensitive) we omit the status predicate entirely. if a
            // specific status value is provided we filter accordingly. this
            // allows the admin UI to request all entries while public
            // consumers can still ask for active-only.
            if (status == null) {
                preds.add(cb.equal(root.get("status"), EntityStatus.ACTIVE));
            } else if (!"ALL".equalsIgnoreCase(status)) {
                try {
                    EntityStatus s = EntityStatus.valueOf(status.toUpperCase());
                    preds.add(cb.equal(root.get("status"), s));
                } catch (IllegalArgumentException ignored) {
                    // unknown status string; ignore predicate so query returns
                    // everything. validation is performed on the client side.
                }
            }
            if (keyword != null && !keyword.isEmpty()) {
                String pattern = "%" + keyword.toLowerCase() + "%";
                preds.add(cb.or(
                        cb.like(cb.lower(root.get("name")), pattern),
                        cb.like(cb.lower(root.get("description")), pattern)
                ));
            }
            if (categoryId != null) {
                preds.add(cb.equal(root.get("category").get("id"), categoryId));
            }
            if (brandId != null) {
                preds.add(cb.equal(root.get("brand").get("id"), brandId));
            }
            return preds.isEmpty() ? null : cb.and(preds.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };
        // if the caller requested all statuses we want a totally stable order
        // that doesn't change when a product flips between ACTIVE/INACTIVE.
        // using the provided `pageable` sort may put items in a different page
        // once their `createdAt`/`updatedAt` fields change, so we override it
        // when status=ALL and the sort is unspecified or includes mutable
        // columns. here we simply sort by `id` ascending which is fixed.
        org.springframework.data.domain.Pageable effective = pageable;
        // when the admin requests ALL statuses but doesn't supply any sort
        // criteria we fall back to a deterministic `id` sort so that paging
        // doesn't jump as rows change status. if the client explicitly
        // asked for a sort (price, createdAt, etc.) we respect it instead.
        if (status != null && status.equalsIgnoreCase("ALL") && !pageable.getSort().isSorted()) {
            effective = org.springframework.data.domain.PageRequest.of(
                pageable.getPageNumber(),
                pageable.getPageSize(),
                org.springframework.data.domain.Sort.by("id").ascending()
            );
        }
        return productRepository.findAll(spec, effective)
            .map(productMapper::toResponse);
    }
    
    @Override
    public Optional<ProductResponse> getProductById(Long id) {
        return productRepository.findById(id)
                .map(product -> {
                    ProductResponse response = productMapper.toResponse(product);
                    
                    // Fetch stock information from inventory service
                    try {
                        ApiResponseDto<List<StoreInventoryDto>> inventoryResponse = 
                                inventoryServiceClient.getProductInventoryAllStores(id);
                        
                        if (inventoryResponse != null && inventoryResponse.getStatus() == 200 && inventoryResponse.getData() != null) {
                            List<StoreStockInfo> storeStocks = inventoryResponse.getData().stream()
                                    .map(inv -> StoreStockInfo.builder()
                                            .storeId(inv.getStoreId())
                                            .storeName(inv.getStoreName())
                                        .address(inv.getAddress())
                                        .city(inv.getCity())
                                            .quantity(inv.getQuantity())
                                            .minStockLevel(inv.getMinStockLevel())
                                            .stockStatus(calculateStockStatus(inv.getQuantity(), inv.getMinStockLevel()))
                                            .shelfLocation(inv.getShelfLocation())
                                            .lastUpdated(inv.getLastUpdated())
                                            .build())
                                    .collect(Collectors.toList());
                            
                            response.setStoreStocks(storeStocks);
                            response.setTotalStock(storeStocks.stream()
                                    .mapToInt(s -> s.getQuantity() != null ? s.getQuantity() : 0)
                                    .sum());
                        }
                    } catch (Exception e) {
                        log.warn("Failed to fetch stock information for product {}: {}", id, e.getMessage());
                        // Continue without stock info if inventory service is unavailable
                    }
                    
                    return response;
                });
    }
    
    /**
     * Calculate stock status based on quantity and min stock level.
     */
    private String calculateStockStatus(Integer quantity, Integer minStockLevel) {
        if (quantity == null || quantity <= 0) {
            return "OUT_OF_STOCK";
        } else if (minStockLevel != null && quantity <= minStockLevel) {
            return "LOW_STOCK";
        } else {
            return "IN_STOCK";
        }
    }
    
    @Override
    public ProductResponse createProduct(ProductCreateRequest request) {
        Category category = categoryRepository.findByIdAndStatus(request.getCategoryId(), EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + request.getCategoryId()));
        
        Brand brand = brandRepository.findByIdAndStatus(request.getBrandId(), EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + request.getBrandId()));
        
        Product product = productMapper.toEntity(request, category, brand);
        Product savedProduct = productRepository.save(product);
        return productMapper.toResponse(savedProduct);
    }
    
    @Override
    public ProductResponse updateProduct(Long id, ProductUpdateRequest request) {
        Product product = productRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + id));
        
        Category category = null;
        if (request.getCategoryId() != null) {
            category = categoryRepository.findByIdAndStatus(request.getCategoryId(), EntityStatus.ACTIVE)
                    .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + request.getCategoryId()));
        }
        
        Brand brand = null;
        if (request.getBrandId() != null) {
            brand = brandRepository.findByIdAndStatus(request.getBrandId(), EntityStatus.ACTIVE)
                    .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + request.getBrandId()));
        }
        
        productMapper.updateEntity(product, request, category, brand);
        Product updatedProduct = productRepository.save(product);
        return productMapper.toResponse(updatedProduct);
    }
    
    @Override
    public void deleteProduct(Long id) {
        Product product = productRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + id));
        
        product.setStatus(EntityStatus.DELETED);
        product.setStatusChangedAt(LocalDateTime.now());
        productRepository.save(product);
    }
    
    @Override
    public ProductResponse updateProductStatus(Long id, StatusUpdateRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + id));
        
        product.setStatus(request.getStatus());
        product.setStatusChangedAt(LocalDateTime.now());
        Product updatedProduct = productRepository.save(product);
        return productMapper.toResponse(updatedProduct);
    }
    
    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<ProductResponse> listProductsSortedByStock(
            org.springframework.data.domain.Pageable pageable,
            String keyword,
            Long categoryId,
            Long brandId,
            String status) {
        
        // Get product IDs with stock from inventory service
        Set<Long> productIdsWithStock = new HashSet<>();
        try {
            var response = inventoryServiceClient.getAllProductIdsWithStock();
            if (response != null && response.getData() != null) {
                productIdsWithStock.addAll(response.getData());
            }
        } catch (Exception e) {
            // If inventory service is down, continue without stock info
            // Products will be sorted only by other criteria
        }
        
        // Build dynamic specification
        org.springframework.data.jpa.domain.Specification<Product> spec = (root, query, cb) -> {
            java.util.List<jakarta.persistence.criteria.Predicate> preds = new java.util.ArrayList<>();
            
            if (status == null) {
                preds.add(cb.equal(root.get("status"), EntityStatus.ACTIVE));
            } else if (!"ALL".equalsIgnoreCase(status)) {
                try {
                    EntityStatus s = EntityStatus.valueOf(status.toUpperCase());
                    preds.add(cb.equal(root.get("status"), s));
                } catch (IllegalArgumentException ignored) {
                }
            }
            if (keyword != null && !keyword.isEmpty()) {
                String pattern = "%" + keyword.toLowerCase() + "%";
                preds.add(cb.or(
                        cb.like(cb.lower(root.get("name")), pattern),
                        cb.like(cb.lower(root.get("description")), pattern)
                ));
            }
            if (categoryId != null) {
                preds.add(cb.equal(root.get("category").get("id"), categoryId));
            }
            if (brandId != null) {
                preds.add(cb.equal(root.get("brand").get("id"), brandId));
            }
            return preds.isEmpty() ? null : cb.and(preds.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };
        
        // Get all products matching the filters
        List<Product> allProducts = productRepository.findAll(spec);
        
        // Sort products: with stock first, then without stock
        final Set<Long> stockSet = productIdsWithStock;
        List<Product> sortedProducts = allProducts.stream()
                .sorted((p1, p2) -> {
                    boolean p1HasStock = stockSet.contains(p1.getId());
                    boolean p2HasStock = stockSet.contains(p2.getId());
                    
                    if (p1HasStock && !p2HasStock) return -1;
                    if (!p1HasStock && p2HasStock) return 1;
                    
                    // If both have same stock status, sort by ID
                    return p1.getId().compareTo(p2.getId());
                })
                .collect(Collectors.toList());
        
        // Manual pagination
        int start = (int) pageable.getOffset();
        int end = Math.min(start + pageable.getPageSize(), sortedProducts.size());
        
        List<Product> pageContent = start < sortedProducts.size() 
                ? sortedProducts.subList(start, end) 
                : List.of();
        
        List<ProductResponse> responseList = pageContent.stream()
                .map(productMapper::toResponse)
                .collect(Collectors.toList());
        
        return new org.springframework.data.domain.PageImpl<>(
                responseList,
                pageable,
                sortedProducts.size()
        );
    }
}
