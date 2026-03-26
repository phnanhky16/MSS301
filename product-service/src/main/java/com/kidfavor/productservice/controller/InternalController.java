package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.response.ResponseWrapper;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.service.ProductService;
import io.swagger.v3.oas.annotations.Hidden;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

/**
 * Internal API endpoints for inter-service communication
 * These endpoints are NOT protected by JWT - they trust the API Gateway
 */
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Hidden
public class InternalController {
    
    ProductService productService;
    
    /**
     * Get product by ID for internal service calls
     * Used by other microservices (e.g., review-service, order-service)
     */
    @GetMapping("/products/{id}")
    public ResponseEntity<ResponseWrapper<ProductResponse>> getProductByIdInternal(@PathVariable Long id) {
        Optional<ProductResponse> productOpt = productService.getProductById(id);
        
        if (productOpt.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ResponseWrapper.error("Product not found"));
        }
        
        ProductResponse product = productOpt.get();
        
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved product successfully", product));
    }
    
    /**
     * Validate if product exists and is available
     */
    @GetMapping("/products/{id}/validate")
    public ResponseEntity<ResponseWrapper<String>> validateProduct(@PathVariable Long id) {
        Optional<ProductResponse> productOpt = productService.getProductById(id);
        
        if (productOpt.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ResponseWrapper.error("Product not found"));
        }
        
        return ResponseEntity.ok(ResponseWrapper.success("Product is valid", "valid"));
    }

    @GetMapping("/products/by-ids")
    public ResponseEntity<ResponseWrapper<java.util.List<ProductResponse>>> getProductsByIdsInternal(
            @RequestParam("ids") java.util.List<Long> ids) {
        java.util.List<ProductResponse> products = ids.stream()
                .map(id -> productService.getProductById(id).orElse(null))
                .filter(java.util.Objects::nonNull)
                .collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved products successfully", products));
    }
}
