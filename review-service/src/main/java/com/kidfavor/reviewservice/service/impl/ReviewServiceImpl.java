package com.kidfavor.reviewservice.service.impl;

import com.kidfavor.reviewservice.client.ProductClient;
import com.kidfavor.reviewservice.client.UserClient;
import com.kidfavor.reviewservice.dto.*;
import com.kidfavor.reviewservice.entity.Review;
import com.kidfavor.reviewservice.repository.ReviewRepository;
import com.kidfavor.reviewservice.security.UserPrincipal;
import com.kidfavor.reviewservice.service.KafkaProducerService;
import com.kidfavor.reviewservice.service.ReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserClient userClient;
    private final ProductClient productClient;
    private final KafkaProducerService kafkaProducerService;

    @Override
    @Transactional
    public ReviewResponse createReview(CreateReviewRequest request) {
        log.info("Creating review for user {} and product {}", request.getUserId(), request.getProductId());

        // Validate user exists and is active
        try {
            var userResponse = userClient.getUserById(request.getUserId());
            if (userResponse.getData() == null) {
                throw new RuntimeException("User not found with id: " + request.getUserId());
            }
            if (userResponse.getData().getStatus() == null || !userResponse.getData().getStatus()) {
                throw new RuntimeException("User is inactive with id: " + request.getUserId());
            }
        } catch (Exception e) {
            log.error("Failed to validate user: {}", e.getMessage());
            throw new RuntimeException("Failed to validate user: " + e.getMessage());
        }

        // Validate product exists
        try {
            var productResponse = productClient.getProductById(request.getProductId());
            if (productResponse.getData() == null) {
                throw new RuntimeException("Product not found with id: " + request.getProductId());
            }
        } catch (Exception e) {
            log.error("Failed to validate product: {}", e.getMessage());
            throw new RuntimeException("Failed to validate product: " + e.getMessage());
        }

        // Create review after validation passes
        Review review = Review.builder()
                .userId(request.getUserId())
                .productId(request.getProductId())
                .rating(request.getRating())
                .comment(request.getComment())
                .build();

        Review savedReview = reviewRepository.save(review);
        log.info("Review created with id: {}", savedReview.getId());

        // Send Kafka event asynchronously (không block)
        try {
            kafkaProducerService.sendReviewCreatedEvent(
                    savedReview.getId(),
                    savedReview.getUserId(),
                    savedReview.getProductId(),
                    savedReview.getRating(),
                    savedReview.getComment());
        } catch (Exception e) {
            log.error("Failed to send Kafka event, but review was created: {}", e.getMessage());
        }

        // Return response ngay lập tức
        return mapToResponse(savedReview);
    }

    @Override
    @Transactional
    public ReviewResponse updateReview(Long id, UpdateReviewRequest request) {
        log.info("Updating review with id: {}", id);

        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + id));

        if (request.getRating() != null) {
            review.setRating(request.getRating());
        }
        if (request.getComment() != null) {
            review.setComment(request.getComment());
        }

        Review updatedReview = reviewRepository.save(review);
        log.info("Review updated with id: {}", updatedReview.getId());

        // Send Kafka event
        kafkaProducerService.sendReviewUpdatedEvent(
                updatedReview.getId(),
                updatedReview.getUserId(),
                updatedReview.getProductId(),
                updatedReview.getRating(),
                updatedReview.getComment());

        return mapToResponse(updatedReview);
    }

    @Override
    @Transactional
    public void deleteReview(Long id) {
        log.info("Deleting review with id: {}", id);

        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + id));

        reviewRepository.delete(review);
        log.info("Review deleted with id: {}", id);

        // Send Kafka event
        kafkaProducerService.sendReviewDeletedEvent(
                review.getId(),
                review.getUserId(),
                review.getProductId());
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewResponse getReviewById(Long id) {
        log.info("Getting review with id: {}", id);

        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + id));

        return mapToResponse(review);
    }

    @Override
    @Transactional(readOnly = true)
    public Double getAverageRatingByProductId(Long productId) {
        log.info("Getting average rating for product: {}", productId);
        Double avgRating = reviewRepository.getAverageRatingByProductId(productId);
        return avgRating != null ? avgRating : 0.0;
    }

    @Override
    @Transactional(readOnly = true)
    public Long getReviewCountByProductId(Long productId) {
        log.info("Getting review count for product: {}", productId);
        return reviewRepository.countByProductId(productId);
    }

    private ReviewResponse mapToResponse(Review review, java.util.Map<Long, UserDTO> userCache, java.util.Map<Long, ProductDTO> productCache) {
        UserDTO user = null;
        ProductDTO product = null;

        // Fetch user details
        Long uId = review.getUserId();
        if (userCache != null && userCache.containsKey(uId)) {
            user = userCache.get(uId);
        } else {
            try {
                var userResponse = userClient.getUserById(uId);
                user = userResponse.getData();
                if (userCache != null) userCache.put(uId, user);
                log.info("Fetched user details for userId: {}", uId);
            } catch (Exception e) {
                log.warn("Could not fetch user details for id: {}. Error: {}", uId, e.getMessage());
            }
        }

        // Fetch product details
        Long pId = review.getProductId();
        if (productCache != null && productCache.containsKey(pId)) {
            product = productCache.get(pId);
        } else {
            try {
                var productResponse = productClient.getProductById(pId);
                product = productResponse.getData();
                if (productCache != null) productCache.put(pId, product);
                log.info("Fetched product details for productId: {}", pId);
            } catch (Exception e) {
                log.warn("Could not fetch product details for id: {}. Error: {}", pId, e.getMessage());
            }
        }

        return ReviewResponse.builder()
                .id(review.getId())
                .userId(review.getUserId())
                .productId(review.getProductId())
                .rating(review.getRating())
                .comment(review.getComment())
                .createdAt(review.getCreatedAt())
                .updatedAt(review.getUpdatedAt())
                .user(user)
                .product(product)
                .adminReply(review.getAdminReply())
                .repliedAt(review.getRepliedAt())
                .isHidden(review.getIsHidden())
                .hiddenReason(review.getHiddenReason())
                .build();
    }

    private ReviewResponse mapToResponse(Review review) {
        return mapToResponse(review, null, null);
    }

    @Override
    public Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserPrincipal) {
            return ((UserPrincipal) authentication.getPrincipal()).getUserId();
        }
        throw new RuntimeException("Unable to extract user ID from authentication token");
    }

    @Override
    @Transactional(readOnly = true)
    public Page<ReviewResponse> listReviews(Pageable pageable, Long userId, Long productId, Integer rating, Boolean isHidden) {
        log.info("Listing reviews with filters - userId: {}, productId: {}, rating: {}, isHidden: {}", userId, productId, rating, isHidden);

        Specification<Review> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (userId != null) {
                predicates.add(cb.equal(root.get("userId"), userId));
            }

            if (productId != null) {
                predicates.add(cb.equal(root.get("productId"), productId));
            }

            if (rating != null) {
                predicates.add(cb.equal(root.get("rating"), rating));
            }

            if (isHidden != null) {
                predicates.add(cb.equal(root.get("isHidden"), isHidden));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Review> reviews = reviewRepository.findAll(spec, pageable);
        java.util.Map<Long, UserDTO> userCache = new java.util.HashMap<>();
        java.util.Map<Long, ProductDTO> productCache = new java.util.HashMap<>();
        return reviews.map(r -> mapToResponse(r, userCache, productCache));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<ReviewResponse> getReviewsByProductIdPaged(Long productId, Integer rating, Pageable pageable) {
        log.info("Getting paged reviews for product: {} with rating: {}, page: {}, size: {}",
                productId, rating, pageable.getPageNumber(), pageable.getPageSize());

        Specification<Review> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("productId"), productId));

            if (rating != null) {
                predicates.add(cb.equal(root.get("rating"), rating));
            }

            // Exclude hidden reviews for public product view
            predicates.add(cb.or(cb.equal(root.get("isHidden"), false), cb.isNull(root.get("isHidden"))));

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Review> reviews = reviewRepository.findAll(spec, pageable);
        java.util.Map<Long, UserDTO> userCache = new java.util.HashMap<>();
        java.util.Map<Long, ProductDTO> productCache = new java.util.HashMap<>();
        return reviews.map(r -> mapToResponse(r, userCache, productCache));
    }

    @Override
    @Transactional(readOnly = true)
    public Page<ReviewResponse> getReviewsByUserIdPaged(Long userId, Pageable pageable) {
        log.info("Getting paged reviews for user: {} with page: {}, size: {}",
                userId, pageable.getPageNumber(), pageable.getPageSize());

        Page<Review> reviews = reviewRepository.findByUserId(userId, pageable);
        java.util.Map<Long, UserDTO> userCache = new java.util.HashMap<>();
        java.util.Map<Long, ProductDTO> productCache = new java.util.HashMap<>();
        return reviews.map(r -> mapToResponse(r, userCache, productCache));
    }

    @Override
    @Transactional
    public ReviewResponse replyToReview(Long id, String reply) {
        log.info("Admin replying to review id: {}", id);
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + id));

        review.setAdminReply(reply);
        review.setRepliedAt(java.time.LocalDateTime.now());

        Review saved = reviewRepository.save(review);
        return mapToResponse(saved);
    }

    @Override
    @Transactional
    public ReviewResponse toggleReviewVisibility(Long id, boolean hide, String reason) {
        log.info("Toggling visibility for review id: {} to hidden={}", id, hide);
        Review review = reviewRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Review not found with id: " + id));

        review.setIsHidden(hide);
        review.setHiddenReason(hide ? reason : null);

        Review saved = reviewRepository.save(review);
        return mapToResponse(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public java.util.Map<String, Object> getReviewStats() {
        log.info("Fetching review statistics for admin");
        long totalReviews = reviewRepository.count();
        
        // Use a manual approach for stats if needed or use queries
        long hiddenCount = listReviews(org.springframework.data.domain.Pageable.unpaged(), null, null, null, null)
                .stream().filter(r -> Boolean.TRUE.equals(r.getIsHidden())).count();

        java.util.List<Object[]> dist = reviewRepository.getRatingDistribution();
        java.util.Map<Integer, Long> ratingDist = new java.util.HashMap<>();
        for (Object[] row : dist) {
            ratingDist.put((Integer) row[0], (Long) row[1]);
        }

        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalReviews", totalReviews);
        stats.put("hiddenReviews", hiddenCount);
        stats.put("ratingDistribution", ratingDist);
        
        return stats;
    }
}
