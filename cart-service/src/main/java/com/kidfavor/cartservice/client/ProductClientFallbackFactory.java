package com.kidfavor.cartservice.client;

import com.kidfavor.cartservice.dto.ApiResponse;
import com.kidfavor.cartservice.dto.ProductDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ProductClientFallbackFactory implements FallbackFactory<ProductClient> {
    
    @Override
    public ProductClient create(Throwable cause) {
        return new ProductClient() {
            @Override
            public ApiResponse<ProductDTO> getProductById(Long id) {
                log.error("Failed to fetch product with id: {}. Error: {}", id, cause.getMessage());
                return ApiResponse.error("Product service unavailable");
            }
        };
    }
}
