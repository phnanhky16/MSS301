package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class ProductServiceImpl implements ProductService {
    
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final BrandRepository brandRepository;
    private final ProductMapper productMapper;
    

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
                .map(productMapper::toResponse);
    }
    
    @Override
    public List<ProductResponse> getProductsByCategory(Long categoryId) {
        List<Product> products = productRepository.findByCategoryIdAndStatus(categoryId, EntityStatus.ACTIVE);
        return productMapper.toResponseList(products);
    }
    
    @Override
    public List<ProductResponse> getProductsByBrand(Long brandId) {
        List<Product> products = productRepository.findByBrandIdAndStatus(brandId, EntityStatus.ACTIVE);
        return productMapper.toResponseList(products);
    }
    
    @Override
    public List<ProductResponse> searchProducts(String keyword) {
        List<Product> products = productRepository.searchByNameAndStatus(keyword, EntityStatus.ACTIVE);
        return productMapper.toResponseList(products);
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
}
