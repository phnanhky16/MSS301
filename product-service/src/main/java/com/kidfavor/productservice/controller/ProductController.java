package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.ApiResponse;
import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
@Tag(name = "Product", description = "Product management APIs")
public class ProductController {
    
    private final ProductService productService;
    
    // paged listing with optional filtering by keyword, category, brand
    @GetMapping
    @Operation(summary = "List products", description = "Retrieve products (paged) with optional filters")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ApiResponse<org.springframework.data.domain.Page<ProductResponse>>> getAllProducts(
            org.springframework.data.domain.Pageable pageable,
            @RequestParam(name="keyword", required=false) String keyword,
            @RequestParam(name="categoryId", required=false) Long categoryId,
            @RequestParam(name="brandId", required=false) Long brandId) {
        var page = productService.listProducts(pageable, keyword, categoryId, brandId);
        return ResponseEntity.ok(
            ApiResponse.success("Products retrieved successfully", page)
        );
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get product by ID", description = "Retrieve a specific product by its ID")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Product found"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ApiResponse<ProductResponse>> getProductById(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        return productService.getProductById(id)
                .map(product -> ResponseEntity.ok(
                    ApiResponse.success("Product retrieved successfully", product)
                ))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @Deprecated
    @GetMapping("/category/{categoryId}")
    @Operation(summary = "Get products by category", description = "Retrieve all products in a specific category")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ApiResponse<List<ProductResponse>>> getProductsByCategory(
            @Parameter(description = "Category ID") @PathVariable Long categoryId) {
        List<ProductResponse> products = productService.getProductsByCategory(categoryId);
        return ResponseEntity.ok(
            ApiResponse.success("Products retrieved successfully", products)
        );
    }
    
    @Deprecated
    @GetMapping("/brand/{brandId}")
    @Operation(summary = "Get products by brand", description = "Retrieve all products of a specific brand")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ApiResponse<List<ProductResponse>>> getProductsByBrand(
            @Parameter(description = "Brand ID") @PathVariable Long brandId) {
        List<ProductResponse> products = productService.getProductsByBrand(brandId);
        return ResponseEntity.ok(
            ApiResponse.success("Products retrieved successfully", products)
        );
    }
    
    @Deprecated
    @GetMapping("/search")
    @Operation(summary = "Search products", description = "Search products by keyword in name or description")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ApiResponse<List<ProductResponse>>> searchProducts(
            @Parameter(description = "Search keyword") @RequestParam String keyword) {
        List<ProductResponse> products = productService.searchProducts(keyword);
        return ResponseEntity.ok(
            ApiResponse.success("Products retrieved successfully", products)
        );
    }
    
    @PostMapping
    @Operation(summary = "Create product", description = "Create a new product")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Product created successfully"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ApiResponse<ProductResponse>> createProduct(@Valid @RequestBody ProductCreateRequest request) {
        ProductResponse created = productService.createProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(
            ApiResponse.created("Product created successfully", created)
        );
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Update product", description = "Update an existing product")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Product updated successfully"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Product not found"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ApiResponse<ProductResponse>> updateProduct(
            @Parameter(description = "Product ID") @PathVariable Long id, 
            @Valid @RequestBody ProductUpdateRequest request) {
        ProductResponse updated = productService.updateProduct(id, request);
        return ResponseEntity.ok(
            ApiResponse.success("Product updated successfully", updated)
        );
    }
    
    @PutMapping("/{id}/status")
    @Operation(summary = "Update product status", description = "Change product status (ACTIVE, INACTIVE, DELETED)")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Product status updated successfully"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Product not found"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid status")
    })
    public ResponseEntity<ApiResponse<ProductResponse>> updateProductStatus(
            @Parameter(description = "Product ID") @PathVariable Long id,
            @Valid @RequestBody StatusUpdateRequest request) {
        ProductResponse updated = productService.updateProductStatus(id, request);
        return ResponseEntity.ok(
            ApiResponse.success("Product status updated successfully", updated)
        );
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete product", description = "Delete a product by ID (sets status to DELETED)")
    @ApiResponses(value = {
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Product deleted successfully"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ApiResponse<Void>> deleteProduct(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok(
            ApiResponse.noContent("Product deleted successfully")
        );
    }
}
