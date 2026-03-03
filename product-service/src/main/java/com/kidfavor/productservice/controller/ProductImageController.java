package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.ImageUploadResponse;
import com.kidfavor.productservice.service.ProductImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Product Images", description = "Product image management APIs using MinIO")
public class ProductImageController {

    private final ProductImageService productImageService;

    @PostMapping(value = "/{productId}/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload product image (Only when product has NO images)", 
               description = "Upload an image for a product that doesn't have images yet. If product already has images, use UPDATE endpoint instead. Max file size: 10MB. Allowed formats: jpg, jpeg, png, gif, webp")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Image uploaded successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid file, product already has images, or file size exceeds limit"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<Map<String, Object>> uploadProductImage(
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Parameter(description = "Image file to upload") @RequestParam("file") MultipartFile file) {
        
        try {
            log.info("Received upload request for product {} with file: {}", productId, file.getOriginalFilename());
            
            ImageUploadResponse response = productImageService.uploadProductImage(productId, file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Image uploaded successfully");
            result.put("data", response);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(result);
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error uploading image: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to upload image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PostMapping(value = "/{productId}/images/batch", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload multiple product images (Only when product has NO images, Max 6-10 images)", 
               description = "Upload 2-10 images for a product that doesn't have images yet. If product already has images, use UPDATE endpoint instead. Max file size: 10MB each, Max request size: 50MB. Allowed formats: jpg, jpeg, png, gif, webp. Suitable for e-commerce websites like MyKingdom.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Images uploaded successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid files, product already has images, file size exceeds limit, or more than 10 files"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<Map<String, Object>> uploadMultipleProductImages(
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Parameter(description = "Array of image files to upload (max 10 files)", 
                       required = true,
                       content = @io.swagger.v3.oas.annotations.media.Content(
                               mediaType = MediaType.MULTIPART_FORM_DATA_VALUE
                       ))
            @RequestPart("files") List<MultipartFile> files) {
        
        try {
            log.info("Received batch upload request for product {} with {} files", productId, files.size());
            
            // Validate: No files
            if (files == null || files.isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "No files provided. Please select at least 1 image.");
                return ResponseEntity.badRequest().body(error);
            }
            
            // Validate: Max 6 files (for initial upload via Swagger, business logic allows up to 10)
            if (files.size() > 6) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", String.format("Too many files. Maximum 6 images allowed per batch upload, but received %d files.", files.size()));
                return ResponseEntity.badRequest().body(error);
            }

            // Convert List to Array for service method
            MultipartFile[] filesArray = files.toArray(new MultipartFile[0]);
            List<ImageUploadResponse> responses = productImageService.uploadMultipleProductImages(productId, filesArray);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", String.format("Uploaded %d out of %d images successfully", responses.size(), files.size()));
            result.put("totalFiles", files.size());
            result.put("successCount", responses.size());
            result.put("failedCount", files.size() - responses.size());
            result.put("data", responses);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(result);
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error uploading images: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to upload images: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PutMapping(value = "/images/{imageId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Update/Replace a specific product image", 
               description = "Replace an existing image with a new one. Keeps the same display order and primary status. Max file size: 10MB.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Image updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid file or file size exceeds limit"),
        @ApiResponse(responseCode = "404", description = "Image not found")
    })
    public ResponseEntity<Map<String, Object>> updateProductImage(
            @Parameter(description = "Image ID to replace") @PathVariable Long imageId,
            @Parameter(description = "New image file") @RequestParam("file") MultipartFile file) {
        
        try {
            log.info("Received update request for image {} with file: {}", imageId, file.getOriginalFilename());
            
            ImageUploadResponse response = productImageService.updateProductImage(imageId, file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Image updated successfully");
            result.put("data", response);
            
            return ResponseEntity.ok(result);
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error updating image: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to update image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PutMapping(value = "/{productId}/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Update/Replace all product images", 
               description = "Delete all existing images and upload new ones. First image becomes primary. Max 10 images, 10MB each.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "All images updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid files or exceeds limits"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<Map<String, Object>> updateAllProductImages(
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Parameter(description = "Array of new image files (max 10 files)", 
                       required = true,
                       content = @io.swagger.v3.oas.annotations.media.Content(
                               mediaType = MediaType.MULTIPART_FORM_DATA_VALUE
                       ))
            @RequestPart("files") List<MultipartFile> files) {
        
        try {
            log.info("Received update all images request for product {} with {} files", productId, files.size());
            
            if (files == null || files.isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "No files provided. Please select at least 1 image.");
                return ResponseEntity.badRequest().body(error);
            }

            MultipartFile[] filesArray = files.toArray(new MultipartFile[0]);
            List<ImageUploadResponse> responses = productImageService.updateAllProductImages(productId, filesArray);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", String.format("Updated all images successfully. Total: %d images", responses.size()));
            result.put("totalFiles", files.size());
            result.put("successCount", responses.size());
            result.put("data", responses);
            
            return ResponseEntity.ok(result);
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error updating all images: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to update images: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PatchMapping("/{productId}/images/{imageId}/set-primary")
    @Operation(summary = "Set image as primary/featured", 
               description = "Mark a specific image as the primary (featured) image for product listing. Previous primary is automatically unset.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Primary image set successfully"),
        @ApiResponse(responseCode = "400", description = "Image does not belong to this product"),
        @ApiResponse(responseCode = "404", description = "Product or Image not found")
    })
    public ResponseEntity<Map<String, Object>> setPrimaryImage(
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Parameter(description = "Image ID to set as primary") @PathVariable Long imageId) {
        
        try {
            log.info("Setting primary image {} for product: {}", imageId, productId);
            
            productImageService.setPrimaryImage(productId, imageId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Primary image set successfully");
            
            return ResponseEntity.ok(result);
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(error);
            
        } catch (Exception e) {
            log.error("Error setting primary image: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to set primary image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PatchMapping("/{productId}/images/reorder")
    @Operation(summary = "Reorder product images", 
               description = "Change the display order of images for carousel/gallery. Send a map of imageId -> displayOrder.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Images reordered successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<Map<String, Object>> reorderImages(
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @RequestBody Map<Long, Integer> imageOrders) {
        
        try {
            log.info("Reordering images for product: {}", productId);
            
            productImageService.reorderImages(productId, imageOrders);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Images reordered successfully");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("Error reordering images: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to reorder images: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @GetMapping("/{productId}/images")
    @Operation(summary = "Get all images for a product", 
               description = "Retrieve all images associated with a product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Images retrieved successfully")
    })
    public ResponseEntity<Map<String, Object>> getProductImages(
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        
        log.info("Getting images for product: {}", productId);
        
        List<ImageUploadResponse> images = productImageService.getProductImages(productId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "Images retrieved successfully");
        result.put("count", images.size());
        result.put("data", images);
        
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/images/{imageId}")
    @Operation(summary = "Delete a product image", 
               description = "Delete a specific product image from MinIO and database")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Image deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Image not found")
    })
    public ResponseEntity<Map<String, Object>> deleteProductImage(
            @Parameter(description = "Image ID") @PathVariable Long imageId) {
        
        try {
            log.info("Deleting image: {}", imageId);
            
            productImageService.deleteProductImage(imageId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "Image deleted successfully");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("Error deleting image: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to delete image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @DeleteMapping("/{productId}/images")
    @Operation(summary = "Delete all images for a product", 
               description = "Delete all images associated with a product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "All images deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<Map<String, Object>> deleteAllProductImages(
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        
        try {
            log.info("Deleting all images for product: {}", productId);
            
            productImageService.deleteAllProductImages(productId);
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("message", "All images deleted successfully");
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            log.error("Error deleting images: {}", e.getMessage(), e);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Failed to delete images: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}
