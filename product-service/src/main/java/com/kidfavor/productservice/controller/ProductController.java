package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.response.ResponseWrapper;
import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.service.ProductService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
@Tag(name = "Product", description = "Product management APIs")
public class ProductController {
    
    private final ProductService productService;
    
    @GetMapping
    @Operation(summary = "List products", description = "Retrieve products (paged) with optional filters")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ResponseWrapper<org.springframework.data.domain.Page<ProductResponse>>> getAllProducts(
            org.springframework.data.domain.Pageable pageable,
            @RequestParam(name="keyword", required=false) String keyword,
            @RequestParam(name="categoryId", required=false) Long categoryId,
            @RequestParam(name="brandId", required=false) Long brandId,
            @RequestParam(name="status", required=false) String status) {
        var page = productService.listProducts(pageable, keyword, categoryId, brandId, status);
        return ResponseEntity.ok(
            ResponseWrapper.success("Products retrieved successfully", page)
        );
    }
    
    @GetMapping("/sorted-by-stock")
    @Operation(summary = "List products sorted by stock availability", 
               description = "Retrieve products (paged) with optional filters. Products with stock in stores are displayed first, followed by products without stock.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ResponseWrapper<org.springframework.data.domain.Page<ProductResponse>>> getProductsSortedByStock(
            org.springframework.data.domain.Pageable pageable,
            @RequestParam(name="keyword", required=false) String keyword,
            @RequestParam(name="categoryId", required=false) Long categoryId,
            @RequestParam(name="brandId", required=false) Long brandId,
            @RequestParam(name="status", required=false) String status) {
        var page = productService.listProductsSortedByStock(pageable, keyword, categoryId, brandId, status);
        return ResponseEntity.ok(
            ResponseWrapper.success("Products retrieved and sorted by stock availability", page)
        );
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get product by ID", description = "Retrieve a specific product by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product found"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ResponseWrapper<ProductResponse>> getProductById(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        return productService.getProductById(id)
                .map(product -> ResponseEntity.ok(
                    ResponseWrapper.success("Product retrieved successfully", product)
                ))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @Operation(summary = "Create product", description = "Create a new product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Product created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<ProductResponse>> createProduct(@Valid @RequestBody ProductCreateRequest request) {
        ProductResponse created = productService.createProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(
            ResponseWrapper.created("Product created successfully", created)
        );
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Update product", description = "Update an existing product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product updated successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<ProductResponse>> updateProduct(
            @Parameter(description = "Product ID") @PathVariable Long id, 
            @Valid @RequestBody ProductUpdateRequest request) {
        ProductResponse updated = productService.updateProduct(id, request);
        return ResponseEntity.ok(
            ResponseWrapper.success("Product updated successfully", updated)
        );
    }
    
    @PutMapping("/{id}/status")
    @Operation(summary = "Update product status", description = "Change product status (ACTIVE, INACTIVE, DELETED)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product status updated successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found"),
        @ApiResponse(responseCode = "400", description = "Invalid status")
    })
    public ResponseEntity<ResponseWrapper<ProductResponse>> updateProductStatus(
            @Parameter(description = "Product ID") @PathVariable Long id,
            @Valid @RequestBody StatusUpdateRequest request) {
        ProductResponse updated = productService.updateProductStatus(id, request);
        return ResponseEntity.ok(
            ResponseWrapper.success("Product status updated successfully", updated)
        );
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete product", description = "Delete a product by ID (sets status to DELETED)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> deleteProduct(
            @Parameter(description = "Product ID") @PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok(
            ResponseWrapper.noContent("Product deleted successfully")
        );
    }
}
