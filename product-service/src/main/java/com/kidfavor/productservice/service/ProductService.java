package com.kidfavor.productservice.service;

import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface ProductService {

        // returns paged list of products with optional filters
        Page<ProductResponse> listProducts(
                        Pageable pageable,
                        String keyword,
                        Long categoryId,
                        Long brandId,
                        String status);

        Optional<ProductResponse> getProductById(Long id);

        ProductResponse createProduct(ProductCreateRequest request);

        ProductResponse updateProduct(Long id, ProductUpdateRequest request);

        void deleteProduct(Long id);

        ProductResponse updateProductStatus(Long id, StatusUpdateRequest request);

    Page<ProductResponse> listProductsSortedByStock(
                        Pageable pageable,
                        String keyword,
                        Long categoryId,
                        Long brandId,
                        String status);

        // Sale price management
        ProductResponse setSalePrice(Long id, com.kidfavor.productservice.dto.request.SetSalePriceRequest request);

        ProductResponse removeSalePrice(Long id);

        Page<ProductResponse> getOnSaleProducts(
                        Pageable pageable);
}
