package com.kidfavor.paymentservice.service;

import com.kidfavor.paymentservice.dto.CreatePaymentResponse;
import com.kidfavor.paymentservice.dto.PaymentStatusResponse;

import java.util.Map;

public interface PaymentService {

    /**
     * Create a PayOS payment link for the given order.
     */
    CreatePaymentResponse createPayment(String orderNumber);

    /**
     * Handle the PayOS webhook callback.
     */
    void handleWebhook(Map<String, Object> webhookBody) throws Exception;

    /**
     * Get payment status by order number.
     */
    PaymentStatusResponse getPaymentStatus(String orderNumber);

    /**
     * Cancel a payment link.
     */
    void cancelPayment(String orderNumber) throws Exception;
}
