package com.kidfavor.inventoryservice.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Mirror DTO for the OrderPlacedEvent produced by order-service.
 * Used to deserialize the Kafka message for inventory deduction.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderPlacedEvent {

    private Long orderId;
    private String orderNumber;
    private Long userId;
    private Long storeId;
    private String customerEmail;
    private String customerName;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;
    private String couponCode;
    private BigDecimal discountAmount;
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
