package com.kidfavor.reviewservice.service;

import com.kidfavor.reviewservice.dto.CreateReviewRequest;
import com.kidfavor.reviewservice.dto.ReviewResponse;
import com.kidfavor.reviewservice.dto.UpdateReviewRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ReviewService {

    ReviewResponse createReview(CreateReviewRequest request);

    ReviewResponse updateReview(Long id, UpdateReviewRequest request);

    void deleteReview(Long id);

    ReviewResponse getReviewById(Long id);

    // Paginated methods
    Page<ReviewResponse> listReviews(Pageable pageable, Long userId, Long productId, Integer rating, Boolean isHidden);

    Page<ReviewResponse> getReviewsByProductIdPaged(Long productId, Integer rating, Pageable pageable);

    Page<ReviewResponse> getReviewsByUserIdPaged(Long userId, Pageable pageable);

    // Deprecated convenience methods retained for backward compatibility
    @Deprecated
    default List<ReviewResponse> getAllReviews() {
        return listReviews(PageRequest.of(0, Integer.MAX_VALUE), null, null, null, null)
                .getContent();
    }

    @Deprecated
    default List<ReviewResponse> getReviewsByUserId(Long userId) {
        return getReviewsByUserIdPaged(userId, PageRequest.of(0, Integer.MAX_VALUE))
                .getContent();
    }

    @Deprecated
    default List<ReviewResponse> getReviewsByProductId(Long productId) {
        return getReviewsByProductIdPaged(productId, null, PageRequest.of(0, Integer.MAX_VALUE))
                .getContent();
    }

    Double getAverageRatingByProductId(Long productId);

    Long getReviewCountByProductId(Long productId);

    /**
     * Get current user ID from JWT token in SecurityContext
     */
    Long getCurrentUserId();

    ReviewResponse replyToReview(Long id, String reply);

    ReviewResponse toggleReviewVisibility(Long id, boolean hide, String reason);

    java.util.Map<String, Object> getReviewStats();
}
