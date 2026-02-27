package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.ApiResponse;
import com.kidfavor.orderservice.client.dto.ProductDto;
import com.kidfavor.orderservice.config.FeignClientConfig;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * Feign client for communicating with Product Service.
 * Uses Consul service discovery to locate the product-service.
 */
@FeignClient(
        name = "product-service",
        configuration = FeignClientConfig.class,
        fallbackFactory = ProductServiceClientFallbackFactory.class
)
public interface ProductServiceClient {

    @GetMapping("/internal/products/{id}")
    ApiResponse<ProductDto> getProductById(@PathVariable("id") Long id);
}
