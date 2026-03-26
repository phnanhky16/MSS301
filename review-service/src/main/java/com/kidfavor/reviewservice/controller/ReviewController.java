package com.kidfavor.reviewservice.controller;

import com.kidfavor.reviewservice.dto.CreateReviewRequest;
import com.kidfavor.reviewservice.dto.ReviewResponse;
import com.kidfavor.reviewservice.dto.UpdateReviewRequest;
import com.kidfavor.reviewservice.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/reviews")
@RequiredArgsConstructor
@Tag(name = "Review", description = "Product Review Management APIs")
@SecurityRequirement(name = "bearer-jwt")
public class ReviewController {

        private final ReviewService reviewService;

        @PostMapping
        @PreAuthorize("hasRole('CUSTOMER')")
        @Operation(summary = "Create a review", description = "Create a new product review. Only authenticated customers can create reviews.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "201", description = "Review created successfully", content = @Content(schema = @Schema(implementation = ReviewResponse.class))),
                        @ApiResponse(responseCode = "400", description = "Invalid request data", content = @Content),
                        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token", content = @Content),
                        @ApiResponse(responseCode = "404", description = "Product or User not found", content = @Content)
        })
        public ResponseEntity<ReviewResponse> createReview(
                        @Valid @RequestBody @Parameter(description = "Review details") CreateReviewRequest request) {
                Long userId = reviewService.getCurrentUserId();
                request.setUserId(userId); // Set userId from JWT
                ReviewResponse response = reviewService.createReview(request);
                return ResponseEntity.status(HttpStatus.CREATED).body(response);
        }


        @GetMapping("/product/{productId}/average-rating")
        @Operation(summary = "Get product average rating (Public)", description = "Calculate and retrieve the average rating and total review count for a specific product. This is a public endpoint.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Rating calculated successfully", content = @Content)
        })
        public ResponseEntity<Map<String, Object>> getAverageRating(
                        @PathVariable @Parameter(description = "Product ID") Long productId) {
                Double avgRating = reviewService.getAverageRatingByProductId(productId);
                Long count = reviewService.getReviewCountByProductId(productId);

                Map<String, Object> response = new HashMap<>();
                response.put("productId", productId);
                response.put("averageRating", avgRating);
                response.put("totalReviews", count);

                return ResponseEntity.ok(response);
        }

        // ============ Paginated Endpoints ============

        @GetMapping("/paged")
        @PreAuthorize("hasRole('ADMIN')")
        @Operation(summary = "List reviews with pagination and filters (Admin)", description = "Retrieve paginated reviews with optional filters. Admin only.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
                        @ApiResponse(responseCode = "401", description = "Unauthorized"),
                        @ApiResponse(responseCode = "403", description = "Forbidden - Admin role required")
        })
        public ResponseEntity<Page<ReviewResponse>> listReviews(
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "10") int size,
                        @RequestParam(defaultValue = "createdAt") String sortBy,
                        @RequestParam(defaultValue = "DESC") String sortDir,
                        @RequestParam(required = false) Long userId,
                        @RequestParam(required = false) Long productId,
                        @RequestParam(required = false) Integer rating,
                        @RequestParam(required = false) Boolean isHidden) {

                Sort.Direction direction = sortDir.equalsIgnoreCase("ASC") ? Sort.Direction.ASC : Sort.Direction.DESC;
                Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

                Page<ReviewResponse> reviews = reviewService.listReviews(pageable, userId, productId, rating, isHidden);
                return ResponseEntity.ok(reviews);
        }

        @GetMapping("/product/{productId}/paged")
        @Operation(summary = "Get paginated reviews by product ID (Public)", description = "Retrieve paginated reviews for a specific product. This is a public endpoint.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully")
        })
        public ResponseEntity<Page<ReviewResponse>> getReviewsByProductIdPaged(
                        @PathVariable @Parameter(description = "Product ID") Long productId,
                        @RequestParam(required = false) Integer rating,
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "10") int size,
                        @RequestParam(defaultValue = "createdAt") String sortBy,
                        @RequestParam(defaultValue = "DESC") String sortDir) {

                Sort.Direction direction = sortDir.equalsIgnoreCase("ASC") ? Sort.Direction.ASC : Sort.Direction.DESC;
                Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

                Page<ReviewResponse> reviews = reviewService.getReviewsByProductIdPaged(productId, rating, pageable);
                return ResponseEntity.ok(reviews);
        }

        @GetMapping("/user/{userId}/paged")
        @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
        @Operation(summary = "Get paginated reviews by user ID", description = "Retrieve paginated reviews created by a specific user.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
                        @ApiResponse(responseCode = "401", description = "Unauthorized")
        })
        public ResponseEntity<Page<ReviewResponse>> getReviewsByUserIdPaged(
                        @PathVariable @Parameter(description = "User ID") Long userId,
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "10") int size,
                        @RequestParam(defaultValue = "createdAt") String sortBy,
                        @RequestParam(defaultValue = "DESC") String sortDir) {

                Sort.Direction direction = sortDir.equalsIgnoreCase("ASC") ? Sort.Direction.ASC : Sort.Direction.DESC;
                Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

                Page<ReviewResponse> reviews = reviewService.getReviewsByUserIdPaged(userId, pageable);
                return ResponseEntity.ok(reviews);
        }

        @GetMapping("/my-reviews/paged")
        @PreAuthorize("hasRole('CUSTOMER')")
        @Operation(summary = "Get current user's reviews (Paginated)", description = "Retrieve paginated reviews created by the authenticated user.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Reviews retrieved successfully"),
                        @ApiResponse(responseCode = "401", description = "Unauthorized")
        })
        public ResponseEntity<Page<ReviewResponse>> getMyReviewsPaged(
                        @RequestParam(defaultValue = "0") int page,
                        @RequestParam(defaultValue = "10") int size,
                        @RequestParam(defaultValue = "createdAt") String sortBy,
                        @RequestParam(defaultValue = "DESC") String sortDir) {

                Long userId = reviewService.getCurrentUserId();
                Sort.Direction direction = sortDir.equalsIgnoreCase("ASC") ? Sort.Direction.ASC : Sort.Direction.DESC;
                Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

                Page<ReviewResponse> reviews = reviewService.getReviewsByUserIdPaged(userId, pageable);
                return ResponseEntity.ok(reviews);
        }

        @PostMapping("/{id}/reply")
        @PreAuthorize("hasRole('ADMIN')")
        @Operation(summary = "Reply to a review (Admin)", description = "Add an administrator reply to a review.")
        public ResponseEntity<ReviewResponse> replyToReview(
                        @PathVariable Long id,
                        @RequestBody Map<String, String> body) {
                String reply = body.get("reply");
                ReviewResponse response = reviewService.replyToReview(id, reply);
                return ResponseEntity.ok(response);
        }

        @PatchMapping("/{id}/visibility")
        @PreAuthorize("hasRole('ADMIN')")
        @Operation(summary = "Toggle review visibility (Admin)", description = "Hide or show a review. Requires a reason if hiding.")
        public ResponseEntity<ReviewResponse> toggleVisibility(
                        @PathVariable Long id,
                        @RequestParam boolean hide,
                        @RequestParam(required = false) String reason) {
                ReviewResponse response = reviewService.toggleReviewVisibility(id, hide, reason);
                return ResponseEntity.ok(response);
        }

        @GetMapping("/stats")
        @PreAuthorize("hasRole('ADMIN')")
        @Operation(summary = "Get review statistics (Admin)", description = "Retrieve overall review statistics for management dashboard.")
        public ResponseEntity<Map<String, Object>> getReviewStats() {
                return ResponseEntity.ok(reviewService.getReviewStats());
        }

        @PutMapping("/{id}")
        @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
        @Operation(summary = "Update a review", description = "Update an existing review. Customers can update their own reviews, admins can update any review.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Review updated successfully", content = @Content(schema = @Schema(implementation = ReviewResponse.class))),
                        @ApiResponse(responseCode = "400", description = "Invalid request data", content = @Content),
                        @ApiResponse(responseCode = "401", description = "Unauthorized", content = @Content),
                        @ApiResponse(responseCode = "403", description = "Forbidden - Not the review owner", content = @Content),
                        @ApiResponse(responseCode = "404", description = "Review not found", content = @Content)
        })
        public ResponseEntity<ReviewResponse> updateReview(
                        @PathVariable @Parameter(description = "Review ID") Long id,
                        @Valid @RequestBody @Parameter(description = "Updated review details") UpdateReviewRequest request) {
                ReviewResponse response = reviewService.updateReview(id, request);
                return ResponseEntity.ok(response);
        }

        @DeleteMapping("/{id}")
        @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
        @Operation(summary = "Delete a review", description = "Delete a review. Customers can delete their own reviews, admins can delete any review.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Review deleted successfully", content = @Content),
                        @ApiResponse(responseCode = "401", description = "Unauthorized", content = @Content),
                        @ApiResponse(responseCode = "403", description = "Forbidden - Not the review owner", content = @Content),
                        @ApiResponse(responseCode = "404", description = "Review not found", content = @Content)
        })
        public ResponseEntity<Map<String, String>> deleteReview(
                        @PathVariable @Parameter(description = "Review ID") Long id) {
                reviewService.deleteReview(id);
                Map<String, String> response = new HashMap<>();
                response.put("message", "Review deleted successfully");
                return ResponseEntity.ok(response);
        }

        @GetMapping("/{id}")
        @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
        @Operation(summary = "Get review by ID", description = "Retrieve a specific review by its ID.")
        @ApiResponses(value = {
                        @ApiResponse(responseCode = "200", description = "Review retrieved successfully", content = @Content(schema = @Schema(implementation = ReviewResponse.class))),
                        @ApiResponse(responseCode = "401", description = "Unauthorized", content = @Content),
                        @ApiResponse(responseCode = "404", description = "Review not found", content = @Content)
        })
        public ResponseEntity<ReviewResponse> getReviewById(
                        @PathVariable @Parameter(description = "Review ID") Long id) {
                ReviewResponse response = reviewService.getReviewById(id);
                return ResponseEntity.ok(response);
        }
}
