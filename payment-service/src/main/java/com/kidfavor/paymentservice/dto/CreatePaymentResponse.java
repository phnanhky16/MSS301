package com.kidfavor.paymentservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePaymentResponse {
    private String orderNumber;
    private Long orderCode;
    private String checkoutUrl;
    private String qrCode;
    private String status;
}
