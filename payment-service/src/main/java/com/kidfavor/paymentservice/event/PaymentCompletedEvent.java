package com.kidfavor.paymentservice.event;

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
public class PaymentCompletedEvent {
    private String orderNumber;
    private Long orderCode;
    private Long userId;
    private String customerEmail;
    private String customerName;
    private BigDecimal amount;
    private String transactionReference;
    private String paymentLinkId;
    private LocalDateTime paidAt;
}
