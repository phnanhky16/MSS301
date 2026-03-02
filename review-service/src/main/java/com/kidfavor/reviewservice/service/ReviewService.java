package com.kidfavor.reviewservice.service;

import com.kidfavor.reviewservice.dto.CreateReviewRequest;
import com.kidfavor.reviewservice.dto.ReviewResponse;
import com.kidfavor.reviewservice.dto.UpdateReviewRequest;

import java.util.List;

public interface ReviewService {
    
    ReviewResponse createReview(CreateReviewRequest request);
    
    ReviewResponse updateReview(Long id, UpdateReviewRequest request);
    
    void deleteReview(Long id);
    
    ReviewResponse getReviewById(Long id);
    
    List<ReviewResponse> getAllReviews();
    
    List<ReviewResponse> getReviewsByUserId(Long userId);
    
    List<ReviewResponse> getReviewsByProductId(Long productId);
    
    Double getAverageRatingByProductId(Long productId);
    
    Long getReviewCountByProductId(Long productId);
    
    /**
     * Get current user ID from JWT token in SecurityContext
     */
    Long getCurrentUserId();
}
