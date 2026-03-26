package com.kidfavor.orderservice.listener;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Kafka event published when a payment is confirmed by PayOS.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentFailedEvent {
    private String orderNumber;
    private Long orderCode;
    private Long userId;
    private String errorCode;
    private String errorMessage;
}
