package com.kidfavor.notificationservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Mirror DTO for the OrderPlacedEvent produced by order-service.
 * Kept local to notification-service for decoupling.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderPlacedEvent {

    private Long orderId;
    private String orderNumber;
    private Long userId;
    private String customerEmail;
    private String customerName;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;
    private String eventVersion;
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
