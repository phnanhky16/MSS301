package com.kidfavor.reviewservice.service;

import com.kidfavor.reviewservice.event.ReviewEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class KafkaProducerService {

    private final KafkaTemplate<String, ReviewEvent> kafkaTemplate;

    @Value("${kafka.topics.review-created}")
    private String reviewCreatedTopic;

    @Value("${kafka.topics.review-updated}")
    private String reviewUpdatedTopic;

    @Value("${kafka.topics.review-deleted}")
    private String reviewDeletedTopic;

    @Async
    public void sendReviewCreatedEvent(Long reviewId, Long userId, Long productId, Integer rating, String comment) {
        ReviewEvent event = ReviewEvent.builder()
                .reviewId(reviewId)
                .userId(userId)
                .productId(productId)
                .rating(rating)
                .comment(comment)
                .eventType("CREATED")
                .timestamp(LocalDateTime.now())
                .build();

        kafkaTemplate.send(reviewCreatedTopic, event);
        log.info("Sent review created event: {}", event);
    }

    @Async
    public void sendReviewUpdatedEvent(Long reviewId, Long userId, Long productId, Integer rating, String comment) {
        ReviewEvent event = ReviewEvent.builder()
                .reviewId(reviewId)
                .userId(userId)
                .productId(productId)
                .rating(rating)
                .comment(comment)
                .eventType("UPDATED")
                .timestamp(LocalDateTime.now())
                .build();

        kafkaTemplate.send(reviewUpdatedTopic, event);
        log.info("Sent review updated event: {}", event);
    }

    @Async
    public void sendReviewDeletedEvent(Long reviewId, Long userId, Long productId) {
        ReviewEvent event = ReviewEvent.builder()
                .reviewId(reviewId)
                .userId(userId)
                .productId(productId)
                .eventType("DELETED")
                .timestamp(LocalDateTime.now())
                .build();

        kafkaTemplate.send(reviewDeletedTopic, event);
        log.info("Sent review deleted event: {}", event);
    }
}
