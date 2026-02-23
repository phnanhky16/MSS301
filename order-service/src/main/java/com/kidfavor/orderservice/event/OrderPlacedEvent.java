package com.kidfavor.orderservice.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Event published when an order is successfully created.
 * This event is published to Kafka AFTER the database transaction commits.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderPlacedEvent {

    private static final String EVENT_VERSION = "1.0";

    /**
     * Unique identifier for the order.
     */
    private Long orderId;

    /**
     * Order number (business identifier).
     */
    private String orderNumber;

    /**
     * ID of the user who placed the order.
     */
    private Long userId;

    /**
     * Email of the customer who placed the order.
     */
    private String customerEmail;

    /**
     * Full name of the customer who placed the order.
     */
    private String customerName;

    /**
     * Total amount of the order.
     */
    private BigDecimal totalAmount;

    /**
     * Timestamp when the order was created.
     */
    private LocalDateTime createdAt;

    /**
     * Version of the event schema for forward compatibility.
     */
    @Builder.Default
    private String eventVersion = EVENT_VERSION;

    /**
     * List of items in the order.
     */
    private List<OrderItemEvent> items;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class OrderItemEvent {
        private Long productId;
        private String productName;
        private Integer quantity;
        private BigDecimal unitPrice;
        private BigDecimal subtotal;
    }
}
