package com.kidfavor.paymentservice.dto;

import com.kidfavor.paymentservice.entity.PaymentStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentStatusResponse {
    private String orderNumber;
    private Long orderCode;
    private BigDecimal amount;
    private PaymentStatus status;
    private String checkoutUrl;
    private String transactionReference;
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;
}
