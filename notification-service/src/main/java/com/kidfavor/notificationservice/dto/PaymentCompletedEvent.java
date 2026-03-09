package com.kidfavor.notificationservice.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Mirror DTO for PaymentCompletedEvent published by payment-service.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
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
