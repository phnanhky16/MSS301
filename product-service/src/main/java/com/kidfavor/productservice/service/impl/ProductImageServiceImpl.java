package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.dto.ImageUploadResponse;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.entity.ProductImage;
import com.kidfavor.productservice.exception.ResourceNotFoundException;
import com.kidfavor.productservice.repository.ProductImageRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import com.kidfavor.productservice.service.MinioService;
import com.kidfavor.productservice.service.ProductImageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductImageServiceImpl implements ProductImageService {

    private final ProductImageRepository productImageRepository;
    private final ProductRepository productRepository;
    private final MinioService minioService;

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif", "webp");
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    private static final int MAX_IMAGES_PER_PRODUCT = 10; // Giới hạn tối đa 10 ảnh/sản phẩm

    @Override
    @Transactional
    public ImageUploadResponse uploadProductImage(Long productId, MultipartFile file) throws Exception {
        log.info("Uploading image for product: {}", productId);

        // Validate product exists
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + productId));

        // Check current image count and validate limit
        List<ProductImage> existingImages = productImageRepository.findByProductId(productId);
        int currentCount = existingImages.size();

        if (currentCount >= MAX_IMAGES_PER_PRODUCT) {
            throw new IllegalArgumentException(
                    String.format(
                            "Sản phẩm đã có %d/%d hình ảnh (đạt giới hạn tối đa). Vui lòng xóa bớt hình ảnh trước khi thêm mới.",
                            currentCount, MAX_IMAGES_PER_PRODUCT));
        }

        // Validate file
        validateFile(file);

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String uniqueFilename = String.format("products/%d/%s.%s",
                productId, UUID.randomUUID().toString(), extension);

        // Upload to MinIO
        String imageUrl = minioService.uploadFile(file, uniqueFilename);

        // Save to database
        ProductImage productImage = new ProductImage();
        productImage.setProduct(product);
        productImage.setImageUrl(imageUrl);
        // Set as primary only if this is the first image
        productImage.setIsPrimary(currentCount == 0);
        productImage.setDisplayOrder(currentCount);

        ProductImage savedImage = productImageRepository.save(productImage);

        log.info("Image uploaded successfully for product {}. Total images: {}/{}",
                productId, currentCount + 1, MAX_IMAGES_PER_PRODUCT);

        return buildImageResponse(savedImage, uniqueFilename, file.getSize(), file.getContentType());
    }

    @Override
    @Transactional
    public List<ImageUploadResponse> uploadMultipleProductImages(Long productId, MultipartFile[] files)
            throws Exception {
        log.info("Uploading {} images for product: {}", files.length, productId);

        // Validate product exists once
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + productId));

        // Check current image count and validate limit
        List<ProductImage> existingImages = productImageRepository.findByProductId(productId);
        int currentCount = existingImages.size();
        int availableSlots = MAX_IMAGES_PER_PRODUCT - currentCount;

        if (availableSlots <= 0) {
            throw new IllegalArgumentException(
                    String.format(
                            "Sản phẩm đã có %d/%d hình ảnh (đạt giới hạn tối đa). Vui lòng xóa bớt hình ảnh trước khi thêm mới.",
                            currentCount, MAX_IMAGES_PER_PRODUCT));
        }

        if (files.length > availableSlots) {
            throw new IllegalArgumentException(
                    String.format(
                            "Sản phẩm hiện có %d hình ảnh, chỉ có thể thêm tối đa %d ảnh nữa (giới hạn %d ảnh/sản phẩm). Bạn đang cố upload %d ảnh.",
                            currentCount, availableSlots, MAX_IMAGES_PER_PRODUCT, files.length));
        }

        List<ImageUploadResponse> uploadedImages = new java.util.ArrayList<>();
        List<String> failedFiles = new java.util.ArrayList<>();

        // Check if product already has a primary image
        boolean hasPrimaryImage = existingImages.stream().anyMatch(ProductImage::getIsPrimary);

        for (int i = 0; i < files.length; i++) {
            MultipartFile file = files[i];
            try {
                // Validate file
                validateFile(file);

                // Generate unique filename
                String originalFilename = file.getOriginalFilename();
                String extension = getFileExtension(originalFilename);
                String uniqueFilename = String.format("products/%d/%s.%s",
                        productId, UUID.randomUUID().toString(), extension);

                // Upload to MinIO
                String imageUrl = minioService.uploadFile(file, uniqueFilename);

                // Save to database
                ProductImage productImage = new ProductImage();
                productImage.setProduct(product);
                productImage.setImageUrl(imageUrl);
                // Set as primary only if no existing primary image AND this is first new image
                productImage.setIsPrimary(!hasPrimaryImage && i == 0);
                productImage.setDisplayOrder(currentCount + i);

                ProductImage savedImage = productImageRepository.save(productImage);

                uploadedImages
                        .add(buildImageResponse(savedImage, uniqueFilename, file.getSize(), file.getContentType()));

                log.info("Successfully uploaded image: {}", originalFilename);

            } catch (Exception e) {
                log.error("Failed to upload image: {}", file.getOriginalFilename(), e);
                failedFiles.add(file.getOriginalFilename() + " - " + e.getMessage());
            }
        }

        if (!failedFiles.isEmpty()) {
            log.warn("Some files failed to upload: {}", failedFiles);
        }

        log.info("Batch upload completed for product {}. Success: {}, Failed: {}. Total images: {}/{}",
                productId, uploadedImages.size(), failedFiles.size(), currentCount + uploadedImages.size(),
                MAX_IMAGES_PER_PRODUCT);
        return uploadedImages;
    }

    @Override
    @Transactional
    public ImageUploadResponse updateProductImage(Long imageId, MultipartFile file) throws Exception {
        log.info("Updating image: {}", imageId);

        // Find existing image
        ProductImage existingImage = productImageRepository.findById(imageId)
                .orElseThrow(() -> new ResourceNotFoundException("Image not found with id: " + imageId));

        // Validate file
        validateFile(file);

        // Delete old image from MinIO
        String oldObjectName = extractObjectNameFromUrl(existingImage.getImageUrl());
        minioService.deleteFile(oldObjectName);

        // Upload new image to MinIO
        String originalFilename = file.getOriginalFilename();
        String extension = getFileExtension(originalFilename);
        String uniqueFilename = String.format("products/%d/%s.%s",
                existingImage.getProduct().getId(), UUID.randomUUID().toString(), extension);
        String newImageUrl = minioService.uploadFile(file, uniqueFilename);

        // Update database (keep isPrimary and displayOrder)
        existingImage.setImageUrl(newImageUrl);
        ProductImage updatedImage = productImageRepository.save(existingImage);

        log.info("Image updated successfully: {}", imageId);

        return buildImageResponse(updatedImage, uniqueFilename, file.getSize(), file.getContentType());
    }

    @Override
    @Transactional
    public List<ImageUploadResponse> updateAllProductImages(Long productId, MultipartFile[] files) throws Exception {
        log.info("Updating all images for product: {}", productId);

        // Validate product exists
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with id: " + productId));

        // Validate không vượt quá giới hạn
        if (files.length > MAX_IMAGES_PER_PRODUCT) {
            throw new IllegalArgumentException(
                    String.format("Vượt quá giới hạn %d ảnh/sản phẩm. Bạn đang cố upload %d ảnh.",
                            MAX_IMAGES_PER_PRODUCT, files.length));
        }

        // Delete all old images
        List<ProductImage> oldImages = productImageRepository.findByProductId(productId);
        for (ProductImage oldImage : oldImages) {
            try {
                String objectName = extractObjectNameFromUrl(oldImage.getImageUrl());
                minioService.deleteFile(objectName);
            } catch (Exception e) {
                log.warn("Failed to delete old image from MinIO: {}", oldImage.getImageUrl(), e);
            }
        }
        productImageRepository.deleteAll(oldImages);

        // Upload new images
        List<ImageUploadResponse> uploadedImages = new java.util.ArrayList<>();
        for (int i = 0; i < files.length; i++) {
            MultipartFile file = files[i];
            try {
                validateFile(file);

                String originalFilename = file.getOriginalFilename();
                String extension = getFileExtension(originalFilename);
                String uniqueFilename = String.format("products/%d/%s.%s",
                        productId, UUID.randomUUID().toString(), extension);

                String imageUrl = minioService.uploadFile(file, uniqueFilename);

                ProductImage productImage = new ProductImage();
                productImage.setProduct(product);
                productImage.setImageUrl(imageUrl);
                productImage.setIsPrimary(i == 0); // Ảnh đầu tiên là ảnh chính
                productImage.setDisplayOrder(i);

                ProductImage savedImage = productImageRepository.save(productImage);

                uploadedImages
                        .add(buildImageResponse(savedImage, uniqueFilename, file.getSize(), file.getContentType()));

                log.info("Successfully uploaded new image: {}", originalFilename);

            } catch (Exception e) {
                log.error("Failed to upload new image: {}", file.getOriginalFilename(), e);
            }
        }

        log.info("All images updated for product {}. Total: {}", productId, uploadedImages.size());
        return uploadedImages;
    }

    @Override
    @Transactional
    public void setPrimaryImage(Long productId, Long imageId) throws Exception {
        log.info("Setting primary image {} for product: {}", imageId, productId);

        // Validate image exists and belongs to product
        ProductImage newPrimaryImage = productImageRepository.findById(imageId)
                .orElseThrow(() -> new ResourceNotFoundException("Image not found with id: " + imageId));

        if (!newPrimaryImage.getProduct().getId().equals(productId)) {
            throw new IllegalArgumentException("Image does not belong to this product");
        }

        // Remove primary flag from all other images
        List<ProductImage> allImages = productImageRepository.findByProductId(productId);
        for (ProductImage image : allImages) {
            image.setIsPrimary(false);
        }

        // Set new primary image
        newPrimaryImage.setIsPrimary(true);
        productImageRepository.saveAll(allImages);

        log.info("Primary image set successfully for product {}", productId);
    }

    @Override
    @Transactional
    public void reorderImages(Long productId, java.util.List<Long> imageIds) throws Exception {
        log.info("Reordering images for product: {}", productId);

        List<ProductImage> images = productImageRepository.findByProductId(productId);

        // Map for quick lookup
        java.util.Map<Long, ProductImage> imageMap = images.stream()
                .collect(java.util.stream.Collectors.toMap(ProductImage::getId, img -> img));

        for (int i = 0; i < imageIds.size(); i++) {
            Long id = imageIds.get(i);
            if (imageMap.containsKey(id)) {
                ProductImage img = imageMap.get(id);
                img.setDisplayOrder(i);
                // First image in the list becomes primary
                img.setIsPrimary(i == 0);
            }
        }

        // For images not in the reorder list (if any), reset their primary status if it
        // was set
        // and push them to the end
        if (imageIds.size() < images.size()) {
            int nextOrder = imageIds.size();
            for (ProductImage img : images) {
                if (!imageIds.contains(img.getId())) {
                    img.setDisplayOrder(nextOrder++);
                    img.setIsPrimary(false);
                }
            }
        }

        productImageRepository.saveAll(images);
        log.info("Images reordered successfully for product {}", productId);
    }

    @Override
    public List<ImageUploadResponse> getProductImages(Long productId) {
        log.info("Getting images for product: {}", productId);

        List<ProductImage> images = productImageRepository.findByProductId(productId);

        return images.stream()
                .sorted((a, b) -> a.getDisplayOrder().compareTo(b.getDisplayOrder())) // Sắp xếp theo displayOrder
                .map(image -> ImageUploadResponse.builder()
                        .imageId(image.getId())
                        .imageUrl(image.getImageUrl())
                        .isPrimary(image.getIsPrimary())
                        .displayOrder(image.getDisplayOrder())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void deleteProductImage(Long imageId) throws Exception {
        log.info("Deleting image: {}", imageId);

        ProductImage image = productImageRepository.findById(imageId)
                .orElseThrow(() -> new ResourceNotFoundException("Image not found with id: " + imageId));

        // Extract object name from URL
        String objectName = extractObjectNameFromUrl(image.getImageUrl());

        // Delete from MinIO
        minioService.deleteFile(objectName);

        // Delete from database
        productImageRepository.delete(image);

        log.info("Image deleted successfully: {}", imageId);
    }

    @Override
    @Transactional
    public void deleteAllProductImages(Long productId) throws Exception {
        log.info("Deleting all images for product: {}", productId);

        List<ProductImage> images = productImageRepository.findByProductId(productId);

        for (ProductImage image : images) {
            try {
                String objectName = extractObjectNameFromUrl(image.getImageUrl());
                minioService.deleteFile(objectName);
            } catch (Exception e) {
                log.warn("Failed to delete image from MinIO: {}", image.getImageUrl(), e);
            }
        }

        productImageRepository.deleteAll(images);
        log.info("All images deleted for product: {}", productId);
    }

    // ========== Helper Methods ==========

    private ImageUploadResponse buildImageResponse(ProductImage image, String fileName, Long fileSize,
            String contentType) {
        return ImageUploadResponse.builder()
                .imageId(image.getId())
                .imageUrl(image.getImageUrl())
                .fileName(fileName)
                .fileSize(fileSize)
                .contentType(contentType)
                .isPrimary(image.getIsPrimary())
                .displayOrder(image.getDisplayOrder())
                .build();
    }

    private void validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File is empty");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException(
                    String.format("File size exceeds maximum allowed size of %d MB", MAX_FILE_SIZE / (1024 * 1024)));
        }

        String extension = getFileExtension(file.getOriginalFilename());
        if (!ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            throw new IllegalArgumentException(
                    String.format("File type not allowed. Allowed types: %s", String.join(", ", ALLOWED_EXTENSIONS)));
        }
    }

    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            throw new IllegalArgumentException("Invalid filename");
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }

    private String extractObjectNameFromUrl(String imageUrl) {
        // Extract object name from URL like:
        // http://localhost:9000/product-images/products/1/uuid.jpg
        // Result: products/1/uuid.jpg
        String[] parts = imageUrl.split("/");
        if (parts.length < 3) {
            throw new IllegalArgumentException("Invalid image URL format");
        }
        // Skip protocol, domain, and bucket name
        return String.join("/", Arrays.copyOfRange(parts, 4, parts.length));
    }
}
