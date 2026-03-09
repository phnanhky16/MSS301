package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.response.ResponseWrapper;
import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.request.SetSalePriceRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.service.ProductSearchService;
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

import org.springframework.web.multipart.MultipartFile;
import java.util.Map;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
@Tag(name = "Product", description = "Product management APIs")
public class ProductController {

        private final ProductService productService;
        private final ProductSearchService productSearchService;
        private final com.kidfavor.productservice.service.ProductImageService productImageService;

        @GetMapping
        @Operation(summary = "List products", description = "Retrieve products (paged) with optional filters")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Successfully retrieved products")
        })
        public ResponseEntity<ResponseWrapper<org.springframework.data.domain.Page<ProductResponse>>> getAllProducts(
                        org.springframework.data.domain.Pageable pageable,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "categoryId", required = false) Long categoryId,
                        @RequestParam(name = "brandId", required = false) Long brandId,
                        @RequestParam(name = "status", required = false) String status) {
                var page = productService.listProducts(pageable, keyword, categoryId, brandId, status);
                return ResponseEntity.ok(
                                ResponseWrapper.success("Products retrieved successfully", page));
        }

        @GetMapping("/sorted-by-stock")
        @Operation(summary = "List products sorted by stock availability", description = "Retrieve products (paged) with optional filters. Products with stock in stores are displayed first, followed by products without stock.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Successfully retrieved products")
        })
        public ResponseEntity<ResponseWrapper<org.springframework.data.domain.Page<ProductResponse>>> getProductsSortedByStock(
                        org.springframework.data.domain.Pageable pageable,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "categoryId", required = false) Long categoryId,
                        @RequestParam(name = "brandId", required = false) Long brandId,
                        @RequestParam(name = "status", required = false) String status) {
                var page = productService.listProductsSortedByStock(pageable, keyword, categoryId, brandId, status);
                return ResponseEntity.ok(
                                ResponseWrapper.success("Products retrieved and sorted by stock availability", page));
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
                                                ResponseWrapper.success("Product retrieved successfully", product)))
                                .orElse(ResponseEntity.notFound().build());
        }

        @PostMapping
        @Operation(summary = "Create product", description = "Create a new product")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Product created successfully"),
                        @ApiResponse(responseCode = "400", description = "Invalid input")
        })
        public ResponseEntity<ResponseWrapper<ProductResponse>> createProduct(
                        @Valid @RequestBody ProductCreateRequest request) {
                ProductResponse created = productService.createProduct(request);
                return ResponseEntity.status(HttpStatus.CREATED).body(
                                ResponseWrapper.created("Product created successfully", created));
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
                                ResponseWrapper.success("Product updated successfully", updated));
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
                                ResponseWrapper.success("Product status updated successfully", updated));
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
                                ResponseWrapper.noContent("Product deleted successfully"));
        }

        @GetMapping("/autocomplete")
        @Operation(summary = "Autocomplete product search", description = "Get product suggestions based on keyword prefix")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Successfully retrieved suggestions")
        })
        public ResponseEntity<ResponseWrapper<java.util.List<com.kidfavor.productservice.document.ProductDocument>>> autocomplete(
                        @RequestParam(name = "keyword") String keyword) {
                if (keyword == null || keyword.trim().isEmpty()) {
                        return ResponseEntity.ok(ResponseWrapper.success("Suggestions", java.util.List.of()));
                }
                var suggestions = productSearchService.autocomplete(keyword);
                return ResponseEntity.ok(
                                ResponseWrapper.success("Suggestions retrieved successfully", suggestions));
        }

        @GetMapping("/{productId}/images")
        public ResponseEntity<Map<String, Object>> getProductImages(@PathVariable Long productId) {
                try {
                        var images = productImageService.getProductImages(productId);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        result.put("count", images.size());
                        result.put("data", images);
                        return ResponseEntity.ok(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @PostMapping(value = "/{productId}/images", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
        public ResponseEntity<Map<String, Object>> uploadProductImage(
                        @PathVariable Long productId,
                        @RequestParam("file") MultipartFile file) {
                try {
                        var response = productImageService.uploadProductImage(productId, file);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        result.put("data", response);
                        return ResponseEntity.status(HttpStatus.CREATED).body(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @DeleteMapping("/images/{imageId}")
        public ResponseEntity<Map<String, Object>> deleteProductImage(@PathVariable Long imageId) {
                try {
                        productImageService.deleteProductImage(imageId);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        return ResponseEntity.ok(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @PatchMapping("/{productId}/images/{imageId}/set-primary")
        public ResponseEntity<Map<String, Object>> setPrimaryImage(
                        @PathVariable Long productId, @PathVariable Long imageId) {
                try {
                        productImageService.setPrimaryImage(productId, imageId);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        return ResponseEntity.ok(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @PutMapping(value = "/images/{imageId}", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
        public ResponseEntity<Map<String, Object>> updateProductImage(
                        @PathVariable Long imageId, @RequestParam("file") MultipartFile file) {
                try {
                        var response = productImageService.updateProductImage(imageId, file);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        result.put("data", response);
                        return ResponseEntity.ok(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @PostMapping(value = "/{productId}/images/batch", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
        public ResponseEntity<Map<String, Object>> uploadBatch(
                        @PathVariable Long productId, @RequestParam("files") List<MultipartFile> files) {
                try {
                        var responses = productImageService.uploadMultipleProductImages(productId,
                                        files.toArray(new MultipartFile[0]));
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        result.put("data", responses);
                        return ResponseEntity.status(HttpStatus.CREATED).body(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        @PatchMapping("/{productId}/images/reorder")
        public ResponseEntity<Map<String, Object>> reorderProductImages(
                        @PathVariable Long productId,
                        @RequestBody List<Long> imageIds) {
                try {
                        productImageService.reorderImages(productId, imageIds);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", true);
                        return ResponseEntity.ok(result);
                } catch (Exception e) {
                        Map<String, Object> error = new HashMap<>();
                        error.put("success", false);
                        error.put("message", e.getMessage());
                        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
                }
        }

        // ── Sale Price Management ─────────────────────────────────

        @Operation(summary = "Set sale price for a product")
        @PutMapping("/{id}/sale")
        public ResponseEntity<ResponseWrapper<ProductResponse>> setSalePrice(
                        @PathVariable Long id,
                        @Valid @RequestBody SetSalePriceRequest request) {
                ProductResponse response = productService.setSalePrice(id, request);
                return ResponseEntity.ok(ResponseWrapper.success("Sale price set successfully", response));
        }

        @Operation(summary = "Remove sale price from a product")
        @DeleteMapping("/{id}/sale")
        public ResponseEntity<ResponseWrapper<ProductResponse>> removeSalePrice(
                        @PathVariable Long id) {
                ProductResponse response = productService.removeSalePrice(id);
                return ResponseEntity.ok(ResponseWrapper.success("Sale price removed", response));
        }

        @Operation(summary = "Get all products currently on sale")
        @GetMapping("/on-sale")
        public ResponseEntity<ResponseWrapper<org.springframework.data.domain.Page<ProductResponse>>> getOnSaleProducts(
                        org.springframework.data.domain.Pageable pageable) {
                var page = productService.getOnSaleProducts(pageable);
                return ResponseEntity.ok(ResponseWrapper.success("On-sale products retrieved", page));
        }

        @Operation(summary = "Get products by list of IDs")
        @GetMapping("/by-ids")
        public ResponseEntity<ResponseWrapper<List<ProductResponse>>> getProductsByIds(
                        @RequestParam("ids") List<Long> ids) {
                List<ProductResponse> products = ids.stream()
                                .map(id -> productService.getProductById(id).orElse(null))
                                .filter(p -> p != null)
                                .collect(java.util.stream.Collectors.toList());
                return ResponseEntity.ok(ResponseWrapper.success("Products retrieved", products));
        }
}
