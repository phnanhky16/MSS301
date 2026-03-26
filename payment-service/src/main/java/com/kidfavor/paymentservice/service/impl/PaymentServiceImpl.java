package com.kidfavor.paymentservice.service.impl;

import com.kidfavor.paymentservice.client.OrderServiceClient;
import com.kidfavor.paymentservice.client.UserServiceClient;
import com.kidfavor.paymentservice.dto.ApiResponse;
import com.kidfavor.paymentservice.dto.CreatePaymentResponse;
import com.kidfavor.paymentservice.dto.OrderDto;
import com.kidfavor.paymentservice.dto.PaymentStatusResponse;
import com.kidfavor.paymentservice.entity.Payment;
import com.kidfavor.paymentservice.entity.PaymentStatus;
import com.kidfavor.paymentservice.event.PaymentCompletedEvent;
import com.kidfavor.paymentservice.repository.PaymentRepository;
import com.kidfavor.paymentservice.service.PaymentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.payos.PayOS;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;

import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {

    private final PayOS payOS;
    private final PaymentRepository paymentRepository;
    private final OrderServiceClient orderServiceClient;
    private final UserServiceClient userServiceClient;
    private final KafkaTemplate<String, Object> kafkaTemplate;


    @Value("${app.payment.return-url}")
    private String returnUrl;

    @Value("${app.payment.cancel-url}")
    private String cancelUrl;

    @Value("${app.kafka.topics.payment-completed}")
    private String paymentCompletedTopic;

    @Override
    @Transactional
    public CreatePaymentResponse createPayment(String orderNumber) {
        log.info("Creating payment for order: {}", orderNumber);

        // Check if payment already exists
        paymentRepository.findByOrderNumber(orderNumber).ifPresent(existing -> {
            if (existing.getStatus() == PaymentStatus.PENDING) {
                throw new RuntimeException("Payment already exists for order: " + orderNumber
                        + ". Use checkout URL: " + existing.getCheckoutUrl());
            }
        });

        // Fetch order from order-service
        ApiResponse<OrderDto> apiResponse = orderServiceClient.getOrderByNumber(orderNumber);
        OrderDto order = apiResponse.getData();
        if (order == null) {
            throw new RuntimeException("Order not found: " + orderNumber);
        }

        try {
            // Generate a unique numeric order code for PayOS (must be unique, int64)
            long orderCode = System.currentTimeMillis() % 1_000_000_000L;

            // Build description
            String description = "KidFavor " + orderNumber;
            if (description.length() > 25) {
                description = description.substring(0, 25);
            }

            // Build PayOS payment request
            CreatePaymentLinkRequest request = CreatePaymentLinkRequest.builder()
                    .orderCode(orderCode)
                    .amount(order.getTotalAmount().longValue())
                    .description(description)
                    .returnUrl(returnUrl + "?orderNumber=" + orderNumber)
                    .cancelUrl(cancelUrl + "?orderNumber=" + orderNumber)
                    .build();

            // Call PayOS API — use var so we don't need to guess the response class name
            var response = payOS.paymentRequests().create(request);

            String checkoutUrl = response.getCheckoutUrl();
            String qrCode = response.getQrCode();
            String paymentLinkId = response.getPaymentLinkId();

            // Save payment record
            Payment payment = Payment.builder()
                    .orderNumber(orderNumber)
                    .orderCode(orderCode)
                    .userId(order.getUserId())
                    .amount(order.getTotalAmount())
                    .description(description)
                    .status(PaymentStatus.PENDING)
                    .paymentLinkId(paymentLinkId)
                    .checkoutUrl(checkoutUrl)
                    .qrCode(qrCode)
                    .build();

            paymentRepository.save(payment);

            log.info("Payment link created for order: {}. Checkout: {}", orderNumber, checkoutUrl);

            return CreatePaymentResponse.builder()
                    .orderNumber(orderNumber)
                    .orderCode(orderCode)
                    .checkoutUrl(checkoutUrl)
                    .qrCode(qrCode)
                    .status("PENDING")
                    .accountName(response.getAccountName())
                    .accountNumber(response.getAccountNumber())
                    .bin(response.getBin())
                    .build();

        } catch (Exception e) {
            log.error("Failed to create PayOS payment link for order: {}", orderNumber, e);
            throw new RuntimeException("Failed to create payment: " + e.getMessage(), e);
        }
    }

    @Override
    @Transactional
    public void handleWebhook(Map<String, Object> webhookBody) throws Exception {
        log.info("Received PayOS webhook: {}", webhookBody);

        // Extract data from webhook body
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) webhookBody.get("data");
        if (data == null) {
            log.warn("Webhook body has no 'data' field. Ignoring.");
            return;
        }

        Object orderCodeObj = data.get("orderCode");
        if (orderCodeObj == null) {
            log.warn("Webhook data has no 'orderCode'. Ignoring.");
            return;
        }

        long orderCode = Long.parseLong(orderCodeObj.toString());
        log.info("Webhook for orderCode: {}", orderCode);

        // Ignore test webhook (orderCode = 123)
        if (orderCode == 123) {
            log.info("Test webhook received, ignoring.");
            return;
        }

        // Check code field for success
        String code = webhookBody.get("code") != null ? webhookBody.get("code").toString() : "";
        if (!"00".equals(code)) {
            log.warn("Webhook indicates non-success. code={}", code);
            return;
        }

        // Find payment
        Payment payment = paymentRepository.findByOrderCode(orderCode)
                .orElseThrow(() -> new RuntimeException("Payment not found for orderCode: " + orderCode));

        if (payment.getStatus() == PaymentStatus.PAID) {
            log.info("Payment already confirmed for orderCode: {}", orderCode);
            return;
        }

        // Update payment status
        String reference = data.get("reference") != null ? data.get("reference").toString() : null;
        payment.setStatus(PaymentStatus.PAID);
        payment.setTransactionReference(reference);
        payment.setPaidAt(LocalDateTime.now());
        paymentRepository.save(payment);

        log.info("Payment confirmed for order: {} (orderCode: {})", payment.getOrderNumber(), orderCode);

        // Fetch user email for notification
        String customerEmail = null;
        String customerName = null;
        try {
            var userResponse = userServiceClient.getUserById(payment.getUserId());
            if (userResponse != null && userResponse.getData() != null) {
                customerEmail = userResponse.getData().getEmail();
                customerName = userResponse.getData().getFullName();
            }
        } catch (Exception e) {
            log.warn("Could not fetch user info for userId: {}. Email notification may be skipped.", payment.getUserId());
        }

        // Publish Kafka event
        PaymentCompletedEvent event = PaymentCompletedEvent.builder()
                .orderNumber(payment.getOrderNumber())
                .orderCode(orderCode)
                .userId(payment.getUserId())
                .customerEmail(customerEmail)
                .customerName(customerName)
                .amount(payment.getAmount())
                .transactionReference(reference)
                .paymentLinkId(payment.getPaymentLinkId())
                .paidAt(payment.getPaidAt())
                .build();

        kafkaTemplate.send(paymentCompletedTopic, payment.getOrderNumber(), event);
        log.info("PaymentCompletedEvent published for order: {}", payment.getOrderNumber());
    }

    @Override
    public PaymentStatusResponse getPaymentStatus(String orderNumber) {
        Payment payment = paymentRepository.findByOrderNumber(orderNumber)
                .orElseThrow(() -> new RuntimeException("Payment not found for order: " + orderNumber));

        return PaymentStatusResponse.builder()
                .orderNumber(payment.getOrderNumber())
                .orderCode(payment.getOrderCode())
                .amount(payment.getAmount())
                .status(payment.getStatus())
                .checkoutUrl(payment.getCheckoutUrl())
                .transactionReference(payment.getTransactionReference())
                .paidAt(payment.getPaidAt())
                .createdAt(payment.getCreatedAt())
                .build();
    }

    @Override
    @Transactional
    public void cancelPayment(String orderNumber) throws Exception {
        Payment payment = paymentRepository.findByOrderNumber(orderNumber)
                .orElseThrow(() -> new RuntimeException("Payment not found for order: " + orderNumber));

        if (payment.getStatus() != PaymentStatus.PENDING) {
            throw new RuntimeException("Cannot cancel payment with status: " + payment.getStatus());
        }

        // Cancel on PayOS using v2 API
        payOS.paymentRequests().cancel(payment.getOrderCode(), "Cancelled by user");

        payment.setStatus(PaymentStatus.CANCELLED);
        paymentRepository.save(payment);

        log.info("Payment cancelled for order: {}", orderNumber);
    }
}
