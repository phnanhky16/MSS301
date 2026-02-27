package com.kidfavor.productservice.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;

public interface MinioService {
    
    /**
     * Upload file to MinIO
     * @param file MultipartFile to upload
     * @param objectName Object name in MinIO bucket
     * @return URL of uploaded file
     */
    String uploadFile(MultipartFile file, String objectName) throws Exception;
    
    /**
     * Download file from MinIO
     * @param objectName Object name in MinIO bucket
     * @return InputStream of file
     */
    InputStream downloadFile(String objectName) throws Exception;
    
    /**
     * Delete file from MinIO
     * @param objectName Object name in MinIO bucket
     */
    void deleteFile(String objectName) throws Exception;
    
    /**
     * Check if file exists
     * @param objectName Object name in MinIO bucket
     * @return true if exists
     */
    boolean fileExists(String objectName) throws Exception;
    
    /**
     * Get presigned URL for file
     * @param objectName Object name in MinIO bucket
     * @param expirySeconds Expiry time in seconds
     * @return Presigned URL
     */
    String getPresignedUrl(String objectName, int expirySeconds) throws Exception;
}
