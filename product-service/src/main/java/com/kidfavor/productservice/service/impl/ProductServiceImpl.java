package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.client.InventoryServiceClient;
import com.kidfavor.productservice.client.dto.ApiResponseDto;
import com.kidfavor.productservice.client.dto.StoreInventoryDto;
import com.kidfavor.productservice.document.ProductDocument;
import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.SetSalePriceRequest;
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
import com.kidfavor.productservice.service.ProductSearchService;
import com.kidfavor.productservice.service.ProductSearchSyncService;
import com.kidfavor.productservice.service.ProductService;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.*;

import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
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
    private final ProductSearchSyncService productSearchSyncService;
    private final ProductSearchService productSearchService;

    @Override
    @Transactional(readOnly = true)
    public Page<ProductResponse> listProducts(
            Pageable pageable,
            String keyword,
            Long categoryId,
            Long brandId,
            String status) {
        // build dynamic specification
       Specification<Product> spec = (root, query, cb) -> {
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
                        cb.like(cb.lower(root.get("description")), pattern)));
            }
            if (categoryId != null) {
                preds.add(cb.equal(root.get("category").get("id"), categoryId));
            }
            if (brandId != null) {
                preds.add(cb.equal(root.get("brand").get("id"), brandId));
            }
            return preds.isEmpty() ? null : cb.and(preds.toArray(new Predicate[0]));
        };
        Pageable effective = pageable;

        if (status != null && status.equalsIgnoreCase("ALL") && !pageable.getSort().isSorted()) {
            effective = PageRequest.of(
                    pageable.getPageNumber(),
                    pageable.getPageSize(),
                    Sort.by("id").ascending());
        }

        // Use Elasticsearch if keyword is provided
        if (keyword != null && !keyword.trim().isEmpty()) {
            String sortField = null;
            String sortDir = null;
            if (effective.getSort().isSorted()) {
                org.springframework.data.domain.Sort.Order order = effective.getSort().iterator().next();
                sortField = order.getProperty();
                sortDir = order.getDirection().name();
            }
            List<ProductDocument> docs = productSearchService.searchProducts(
                    keyword, categoryId, brandId, status, effective.getPageNumber(), effective.getPageSize(), sortField,
                    sortDir);

            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = keyword.trim();
                List<ProductDocument> exact = docs.stream()
                        .filter(d -> term.equalsIgnoreCase(d.getName()))
                        .collect(Collectors.toList());
                if (!exact.isEmpty()) {
                    docs = exact;
                }
            }

            // fetch the full Product entities (with images) from the database
            List<Long> ids = docs.stream()
                    .map(d -> Long.valueOf(d.getId()))
                    .collect(Collectors.toList());
            List<Product> loaded = productRepository.findByIdInWithRelations(ids);
            Map<Long, Product> map = loaded.stream()
                    .collect(Collectors.toMap(Product::getId, p -> p));
            List<ProductResponse> responseList = ids.stream()
                    .map(map::get)
                    .filter(java.util.Objects::nonNull)
                    .map(productMapper::toResponse)
                    .collect(Collectors.toList());

            populateTotalStockForProducts(responseList);

            return new PageImpl<>(
                    responseList,
                    effective,
                    (effective.getPageNumber() + 1) * effective.getPageSize() + 1); // rough pagination
        }

        Page<ProductResponse> resultPage = productRepository.findAll(spec, effective)
                .map(productMapper::toResponse);
        populateTotalStockForProducts(resultPage.getContent());
        return resultPage;
    }

    @Override
    public Optional<ProductResponse> getProductById(Long id) {
        return productRepository.findById(id)
                .map(product -> {
                    ProductResponse response = productMapper.toResponse(product);

                    // Fetch stock information from inventory service
                    try {
                        ApiResponseDto<List<StoreInventoryDto>> inventoryResponse = inventoryServiceClient
                                .getProductInventoryAllStores(id);

                        if (inventoryResponse != null && inventoryResponse.getStatus() == 200
                                && inventoryResponse.getData() != null) {
                            List<StoreStockInfo> storeStocks = inventoryResponse.getData().stream()
                                    .map(inv -> StoreStockInfo.builder()
                                            .storeId(inv.getStoreId())
                                            .storeName(inv.getStoreName())
                                            .address(inv.getAddress())
                                            .city(inv.getCity())
                                            .quantity(inv.getQuantity())
                                            .minStockLevel(inv.getMinStockLevel())
                                            .stockStatus(
                                                    calculateStockStatus(inv.getQuantity(), inv.getMinStockLevel()))
                                            .shelfLocation(inv.getShelfLocation())
                                            .lastUpdated(inv.getLastUpdated())
                                            .build())
                                    .collect(Collectors.toList());

                            response.setStoreStocks(storeStocks);
                        }
                    } catch (Exception e) {
                        log.warn("Failed to fetch stock information for product {}: {}", id, e.getMessage());
                        // Continue without stock info if inventory service is unavailable
                    }

                    populateTotalStockForProducts(Collections.singletonList(response));

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
                .orElseThrow(
                        () -> new ResourceNotFoundException("Category not found with id: " + request.getCategoryId()));

        Brand brand = brandRepository.findByIdAndStatus(request.getBrandId(), EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + request.getBrandId()));

        Product product = productMapper.toEntity(request, category, brand);
        Product savedProduct = productRepository.save(product);
        productSearchSyncService.syncProduct(savedProduct);
        return productMapper.toResponse(savedProduct);
    }

    @Override
    public ProductResponse updateProduct(Long id, ProductUpdateRequest request) {
        Product product = productRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + id));

        Category category = null;
        if (request.getCategoryId() != null) {
            category = categoryRepository.findByIdAndStatus(request.getCategoryId(), EntityStatus.ACTIVE)
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Category not found with id: " + request.getCategoryId()));
        }

        Brand brand = null;
        if (request.getBrandId() != null) {
            brand = brandRepository.findByIdAndStatus(request.getBrandId(), EntityStatus.ACTIVE)
                    .orElseThrow(
                            () -> new ResourceNotFoundException("Brand not found with id: " + request.getBrandId()));
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
        Product savedProduct = productRepository.save(product);
        productSearchSyncService.syncProduct(savedProduct);
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
    public Page<ProductResponse> listProductsSortedByStock(Pageable pageable,
            String keyword,
            Long categoryId,
            Long brandId,
            String status) {

        // debug logging to help diagnose why keyword filtering sometimes
        // appears to be ignored (see issue where clicking an autocomplete
        // suggestion still returned the full product list). We print the raw
        // incoming parameter and whether our branch to query ES is taken.
        log.debug("listProductsSortedByStock called with keyword='{}', categoryId={}, brandId={}, status={}",
                keyword, categoryId, brandId, status);

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
        Specification<Product> spec = (root, query, cb) -> {
            List<Predicate> preds = new ArrayList<>();

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
                        cb.like(cb.lower(root.get("description")), pattern)));
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
        List<Product> allProducts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // perform search against elasticsearch index to get the matching ids
            log.debug("keyword non-empty, querying ES");
            List<ProductDocument> docs = productSearchService.searchProducts(
                    keyword, categoryId, brandId, status, 0, 1000, null, null);

            // same post-filter as above for the sorted-by-stock path
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = keyword.trim();
                List<com.kidfavor.productservice.document.ProductDocument> exact = docs.stream()
                        .filter(d -> term.equalsIgnoreCase(d.getName()))
                        .collect(Collectors.toList());
                if (!exact.isEmpty()) {
                    docs = exact;
                }
            }

            // collect ids in the order returned by ES so we can preserve it later
            List<Long> ids = docs.stream()
                    .map(doc -> Long.valueOf(doc.getId()))
                    .collect(Collectors.toList());

            // fetch full entities (including images) in a single query
            List<Product> loaded = productRepository.findByIdInWithRelations(ids);

            // maintain ES ordering; filter out any missing products just in case
            Map<Long, Product> map = loaded.stream()
                    .collect(Collectors.toMap(Product::getId, p -> p));
            allProducts = ids.stream()
                    .map(map::get)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
        } else {
            allProducts = productRepository.findAll(spec);
        }

        // Sort products: with stock first, then without stock
        final Set<Long> stockSet = productIdsWithStock;
        List<Product> sortedProducts = allProducts.stream()
                .sorted((p1, p2) -> {
                    boolean p1HasStock = stockSet.contains(p1.getId());
                    boolean p2HasStock = stockSet.contains(p2.getId());

                    if (p1HasStock && !p2HasStock)
                        return -1;
                    if (!p1HasStock && p2HasStock)
                        return 1;

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

        populateTotalStockForProducts(responseList);

        return new PageImpl<>(
                responseList,
                pageable,
                sortedProducts.size());
    }

    @Override
    public ProductResponse setSalePrice(Long id, SetSalePriceRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));

        // Validate sale price is less than original price
        if (request.getSalePrice().compareTo(product.getPrice()) >= 0) {
            throw new RuntimeException("Sale price must be less than the original price");
        }

        product.setSalePrice(request.getSalePrice());
        product.setSaleStartDate(request.getSaleStartDate());
        product.setSaleEndDate(request.getSaleEndDate());

        Product saved = productRepository.save(product);
        return productMapper.toResponse(saved);
    }

    @Override
    public ProductResponse removeSalePrice(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));

        product.setSalePrice(null);
        product.setSaleStartDate(null);
        product.setSaleEndDate(null);

        Product saved = productRepository.save(product);
        return productMapper.toResponse(saved);
    }

    @Override
    public Page<ProductResponse> getOnSaleProducts(
           Pageable pageable) {
        Page<ProductResponse> resultPage = productRepository.findOnSaleProducts(java.time.LocalDateTime.now(), pageable)
                .map(productMapper::toResponse);
        populateTotalStockForProducts(resultPage.getContent());
        return resultPage;
    }

    private void populateTotalStockForProducts(List<ProductResponse> products) {
        if (products == null || products.isEmpty()) {
            return;
        }

        try {
            List<Long> productIds = products.stream()
                    .map(ProductResponse::getId)
                    .collect(Collectors.toList());

            ApiResponseDto<Map<Long, Integer>> inventoryResponse = inventoryServiceClient
                    .getTotalWarehouseStockForProducts(productIds);

            if (inventoryResponse != null && inventoryResponse.getStatus() == 200
                    && inventoryResponse.getData() != null) {
                Map<Long, Integer> stockMap = inventoryResponse.getData();
                for (ProductResponse product : products) {
                    product.setTotalStock(stockMap.getOrDefault(product.getId(), 0));
                }
            }
        } catch (Exception e) {
            log.warn("Failed to fetch total stock for products: {}", e.getMessage());
        }
    }
}
