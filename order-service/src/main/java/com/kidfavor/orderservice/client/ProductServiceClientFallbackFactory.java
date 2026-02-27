package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.ApiResponse;
import com.kidfavor.orderservice.client.dto.ProductDto;
import com.kidfavor.orderservice.exception.ProductNotFoundException;
import com.kidfavor.orderservice.exception.ProductServiceUnavailableException;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

/**
 * Fallback factory for ProductServiceClient.
 * Provides graceful degradation when Product Service is unavailable.
 */
@Slf4j
@Component
public class ProductServiceClientFallbackFactory implements FallbackFactory<ProductServiceClient> {

    @Override
    public ProductServiceClient create(Throwable cause) {
        log.error("Product Service fallback triggered due to: {}", cause.getMessage());
        
        return new ProductServiceClient() {
            @Override
            public ApiResponse<ProductDto> getProductById(Long id) {
                log.warn("Fallback: Unable to fetch product with ID {}. Cause: {}", id, cause.getMessage());
                
                // Check if it's a 404 error (product not found)
                if (cause instanceof FeignException.NotFound) {
                    throw new ProductNotFoundException(id);
                }
                
                // Check if it's a connection error or service unavailable
                if (cause instanceof FeignException.ServiceUnavailable ||
                    cause instanceof FeignException.BadGateway ||
                    cause instanceof FeignException.GatewayTimeout ||
                    cause.getMessage() != null && cause.getMessage().contains("Connection refused")) {
                    throw new ProductServiceUnavailableException(
                            "Product Service is currently unavailable. Please try again later.");
                }
                
                // For other Feign exceptions, throw service unavailable
                if (cause instanceof FeignException) {
                    FeignException fe = (FeignException) cause;
                    if (fe.status() == 404) {
                        throw new ProductNotFoundException(id);
                    }
                    throw new ProductServiceUnavailableException(
                            "Failed to fetch product from Product Service: " + cause.getMessage());
                }
                
                // Default: service unavailable
                throw new ProductServiceUnavailableException(
                        "Product Service is currently unavailable: " + cause.getMessage());
            }
        };
    }
}
