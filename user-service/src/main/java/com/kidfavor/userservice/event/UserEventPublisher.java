package com.kidfavor.userservice.event;

import com.kidfavor.userservice.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import java.time.LocalDateTime;

/**
 * Publishes UserRegisteredEvent to Kafka AFTER the DB transaction commits.
 * This mirrors the pattern used by OrderEventPublisher in order-service.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserEventPublisher {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${app.kafka.topics.user-registered}")
    private String userRegisteredTopic;

    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handleUserRegisteredEvent(UserRegisteredDomainEvent domainEvent) {
        User user = domainEvent.getUser();
        log.info("Publishing UserRegisteredEvent for user: {}", user.getUserName());

        try {
            UserRegisteredEvent event = UserRegisteredEvent.builder()
                    .userId(user.getId())
                    .username(user.getUserName())
                    .email(user.getEmail())
                    .fullName(user.getFullName())
                    .registeredAt(LocalDateTime.now())
                    .build();

            kafkaTemplate.send(userRegisteredTopic, String.valueOf(user.getId()), event)
                    .whenComplete((result, ex) -> {
                        if (ex == null) {
                            log.info("UserRegisteredEvent published successfully for user: {}. Topic: {}, Partition: {}, Offset: {}",
                                    user.getUserName(),
                                    result.getRecordMetadata().topic(),
                                    result.getRecordMetadata().partition(),
                                    result.getRecordMetadata().offset());
                        } else {
                            log.error("Failed to publish UserRegisteredEvent for user: {}. Error: {}",
                                    user.getUserName(), ex.getMessage());
                        }
                    });
        } catch (Exception e) {
            log.error("Error publishing UserRegisteredEvent for user: {}. Error: {}",
                    user.getUserName(), e.getMessage());
        }
    }
}

