package com.kidfavor.reviewservice.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReviewEvent {
    private Long reviewId;
    private Long userId;
    private Long productId;
    private Integer rating;
    private String comment;
    private String eventType; // CREATED, UPDATED, DELETED
    private LocalDateTime timestamp;
}
