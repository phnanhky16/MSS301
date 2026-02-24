package com.kidfavor.reviewservice.client;

import com.kidfavor.reviewservice.dto.ApiResponse;
import com.kidfavor.reviewservice.dto.ProductDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(
        name = "product-service",
        fallbackFactory = ProductClientFallbackFactory.class
)
public interface ProductClient {

    @GetMapping("/internal/products/{id}")
    ApiResponse<ProductDTO> getProductById(@PathVariable("id") Long id);
}
