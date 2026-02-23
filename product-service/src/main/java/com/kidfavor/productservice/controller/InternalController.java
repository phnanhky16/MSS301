package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.ApiResponse;
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
@Hidden // Hide from Swagger documentation
public class InternalController {
    
    ProductService productService;
    
    /**
     * Get product by ID for internal service calls
     * Used by other microservices (e.g., review-service, order-service)
     */
    @GetMapping("/products/{id}")
    public ResponseEntity<ApiResponse<ProductResponse>> getProductByIdInternal(@PathVariable Long id) {
        Optional<ProductResponse> productOpt = productService.getProductById(id);
        
        if (productOpt.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Product not found"));
        }
        
        ProductResponse product = productOpt.get();
        
        return ResponseEntity.ok(ApiResponse.success("Retrieved product successfully", product));
    }
    
    /**
     * Validate if product exists and is available
     */
    @GetMapping("/products/{id}/validate")
    public ResponseEntity<ApiResponse<String>> validateProduct(@PathVariable Long id) {
        Optional<ProductResponse> productOpt = productService.getProductById(id);
        
        if (productOpt.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Product not found"));
        }
        
        return ResponseEntity.ok(ApiResponse.success("Product is valid", "valid"));
    }
}
