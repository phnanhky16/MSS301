package com.kidfavor.orderservice.event;

import com.kidfavor.orderservice.entity.Order;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

/**
 * Event listener that publishes OrderPlacedEvent to Kafka.
 * Uses @TransactionalEventListener with AFTER_COMMIT phase to ensure
 * events are only published after the database transaction successfully commits.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OrderEventPublisher {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${app.kafka.topics.order-placed}")
    private String orderPlacedTopic;

    /**
     * Listens for OrderCreatedDomainEvent and publishes to Kafka AFTER transaction commits.
     * This ensures that:
     * 1. Events are only published for successfully persisted orders
     * 2. No Kafka messages are sent if the transaction rolls back
     * 3. Event publishing failures don't affect the order creation transaction
     */
    @Async
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handleOrderCreatedEvent(OrderCreatedDomainEvent event) {
        Order order = event.getOrder();
        String orderNumber = order.getOrderNumber();

        log.info("Publishing OrderPlacedEvent for order: {}", orderNumber);

        try {
            OrderPlacedEvent orderPlacedEvent = buildOrderPlacedEvent(order, event.getCustomerEmail(), event.getCustomerName());
            
            CompletableFuture<SendResult<String, Object>> future = 
                    kafkaTemplate.send(orderPlacedTopic, orderNumber, orderPlacedEvent);
            
            future.whenComplete((result, ex) -> {
                if (ex == null) {
                    log.info("OrderPlacedEvent published successfully for order: {}. Topic: {}, Partition: {}, Offset: {}",
                            orderNumber,
                            result.getRecordMetadata().topic(),
                            result.getRecordMetadata().partition(),
                            result.getRecordMetadata().offset());
                } else {
                    log.error("Failed to publish OrderPlacedEvent for order: {}. Error: {}",
                            orderNumber, ex.getMessage(), ex);
                    // Here you could implement retry logic or dead-letter queue
                    handlePublishFailure(orderPlacedEvent, ex);
                }
            });
            
        } catch (Exception ex) {
            log.error("Error building/publishing OrderPlacedEvent for order: {}. Error: {}",
                    orderNumber, ex.getMessage(), ex);
        }
    }

    /**
     * Builds the OrderPlacedEvent from the Order entity and customer info.
     */
    private OrderPlacedEvent buildOrderPlacedEvent(Order order, String customerEmail, String customerName) {
        return OrderPlacedEvent.builder()
                .orderId(order.getId())
                .orderNumber(order.getOrderNumber())
                .userId(order.getUserId())
                .customerEmail(customerEmail)
                .customerName(customerName)
                .totalAmount(order.getTotalAmount())
                .createdAt(order.getCreatedAt())
                .items(order.getItems().stream()
                        .map(item -> OrderPlacedEvent.OrderItemEvent.builder()
                                .productId(item.getProductId())
                                .productName(item.getProductName())
                                .quantity(item.getQuantity())
                                .unitPrice(item.getUnitPrice())
                                .subtotal(item.getSubtotal())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }

    /**
     * Handles failures in publishing events to Kafka.
     * In production, this could write to a dead-letter queue or retry table.
     */
    private void handlePublishFailure(OrderPlacedEvent event, Throwable ex) {
        log.warn("Storing failed event for order {} for later retry. This should be handled by a retry mechanism.",
                event.getOrderNumber());
        // TODO: Implement dead-letter queue or outbox pattern for guaranteed delivery
    }
}
