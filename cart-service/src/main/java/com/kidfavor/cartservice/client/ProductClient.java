package com.kidfavor.cartservice.client;

import com.kidfavor.cartservice.dto.ApiResponse;
import com.kidfavor.cartservice.dto.ProductDTO;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "product-service", fallbackFactory = ProductClientFallbackFactory.class)
public interface ProductClient {
    
    @Retry(name = "product-service")
    @GetMapping("/internal/products/{id}")
    ApiResponse<ProductDTO> getProductById(@PathVariable("id") Long id);
}
