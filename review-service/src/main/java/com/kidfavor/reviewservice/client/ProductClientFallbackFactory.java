package com.kidfavor.reviewservice.client;

import com.kidfavor.reviewservice.dto.ApiResponse;
import com.kidfavor.reviewservice.dto.ProductDTO;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ProductClientFallbackFactory implements FallbackFactory<ProductClient> {

    @Override
    public ProductClient create(Throwable cause) {
        log.error("Product Service fallback triggered due to: {}", cause.getMessage());
        
        return new ProductClient() {
            @Override
            public ApiResponse<ProductDTO> getProductById(Long id) {
                log.warn("Fallback: Unable to fetch product with ID {}. Cause: {}", id, cause.getMessage());
                
                // Check if it's a 404 error (product not found)
                if (cause instanceof FeignException.NotFound) {
                    throw new RuntimeException("Product not found with id: " + id);
                }
                
                // Check if it's a connection error or service unavailable
                if (cause instanceof FeignException.ServiceUnavailable ||
                    cause instanceof FeignException.BadGateway ||
                    cause instanceof FeignException.GatewayTimeout ||
                    cause.getMessage() != null && cause.getMessage().contains("Connection refused")) {
                    throw new RuntimeException("Product Service is currently unavailable. Please try again later.");
                }
                
                // For other Feign exceptions
                if (cause instanceof FeignException) {
                    FeignException fe = (FeignException) cause;
                    if (fe.status() == 404) {
                        throw new RuntimeException("Product not found with id: " + id);
                    }
                    throw new RuntimeException("Failed to fetch product from Product Service: " + cause.getMessage());
                }
                
                // Default: service unavailable
                throw new RuntimeException("Product Service is currently unavailable: " + cause.getMessage());
            }
        };
    }
}
