package com.kidfavor.productservice.service;

import com.kidfavor.productservice.dto.ImageUploadResponse;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ProductImageService {

    /**
     * Upload image for a product (only if no images exist yet)
     * 
     * @param productId Product ID
     * @param file      Image file
     * @return Upload response with image details
     */
    ImageUploadResponse uploadProductImage(Long productId, MultipartFile file) throws Exception;

    /**
     * Upload multiple images for a product (only if no images exist yet)
     * 
     * @param productId Product ID
     * @param files     Array of image files
     * @return List of upload responses
     */
    List<ImageUploadResponse> uploadMultipleProductImages(Long productId, MultipartFile[] files) throws Exception;

    /**
     * Update/Replace a specific image by image ID
     * 
     * @param imageId Image ID to replace
     * @param file    New image file
     * @return Upload response with new image details
     */
    ImageUploadResponse updateProductImage(Long imageId, MultipartFile file) throws Exception;

    /**
     * Update/Replace all images for a product
     * 
     * @param productId Product ID
     * @param files     Array of new image files
     * @return List of upload responses
     */
    List<ImageUploadResponse> updateAllProductImages(Long productId, MultipartFile[] files) throws Exception;

    /**
     * Set primary (featured) image for a product
     * 
     * @param productId Product ID
     * @param imageId   Image ID to set as primary
     */
    void setPrimaryImage(Long productId, Long imageId) throws Exception;

    /**
     * Reorder images for a product
     * 
     * @param productId Product ID
     * @param imageIds  List of image IDs in new order
     */
    void reorderImages(Long productId, java.util.List<Long> imageIds) throws Exception;

    /**
     * Get all images for a product
     * 
     * @param productId Product ID
     * @return List of image URLs
     */
    List<ImageUploadResponse> getProductImages(Long productId);

    /**
     * Delete product image
     * 
     * @param imageId Image ID
     */
    void deleteProductImage(Long imageId) throws Exception;

    /**
     * Delete all images for a product
     * 
     * @param productId Product ID
     */
    void deleteAllProductImages(Long productId) throws Exception;
}
