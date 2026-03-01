package com.kidfavor.productservice.service;

import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;

import java.util.List;
import java.util.Optional;

public interface ProductService {
    
        // returns paged list of products with optional filters
        org.springframework.data.domain.Page<ProductResponse> listProducts(
            org.springframework.data.domain.Pageable pageable,
            String keyword,
            Long categoryId,
            Long brandId,
            String status);
    
    Optional<ProductResponse> getProductById(Long id);
    
    // deprecated convenience methods retained for backward compatibility
    default List<ProductResponse> getProductsByCategory(Long categoryId) {
        return listProducts(org.springframework.data.domain.PageRequest.of(0, Integer.MAX_VALUE), null, categoryId, null, null)
                .getContent();
    }

    default List<ProductResponse> getProductsByBrand(Long brandId) {
        return listProducts(org.springframework.data.domain.PageRequest.of(0, Integer.MAX_VALUE), null, null, brandId, null)
                .getContent();
    }

    default List<ProductResponse> searchProducts(String keyword) {
        return listProducts(org.springframework.data.domain.PageRequest.of(0, Integer.MAX_VALUE), keyword, null, null, null)
                .getContent();
    }
    
    ProductResponse createProduct(ProductCreateRequest request);
    
    ProductResponse updateProduct(Long id, ProductUpdateRequest request);
    
    void deleteProduct(Long id);
    
    ProductResponse updateProductStatus(Long id, StatusUpdateRequest request);
    
    org.springframework.data.domain.Page<ProductResponse> listProductsSortedByStock(
        org.springframework.data.domain.Pageable pageable,
        String keyword,
        Long categoryId,
        Long brandId,
        String status);
}
