package com.kidfavor.paymentservice.controller;

import com.kidfavor.paymentservice.dto.CreatePaymentResponse;
import com.kidfavor.paymentservice.dto.PaymentStatusResponse;
import com.kidfavor.paymentservice.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/payments")
@RequiredArgsConstructor
@Tag(name = "Payment", description = "Payment operations with PayOS")
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/create")
    @Operation(summary = "Create payment link", description = "Creates a PayOS payment link for an order")
    public ResponseEntity<CreatePaymentResponse> createPayment(
            @Parameter(description = "Order number") @RequestParam String orderNumber) {
        log.info("Request to create payment for order: {}", orderNumber);
        CreatePaymentResponse response = paymentService.createPayment(orderNumber);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/webhook")
    @Operation(summary = "PayOS webhook", description = "Receives payment confirmation from PayOS")
    public ResponseEntity<Map<String, Object>> handleWebhook(@RequestBody Map<String, Object> body) {
        log.info("Received webhook from PayOS");
        try {
            paymentService.handleWebhook(body);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            log.error("Webhook processing failed: {}", e.getMessage(), e);
            return ResponseEntity.ok(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/{orderNumber}")
    @Operation(summary = "Get payment status", description = "Get payment status by order number")
    public ResponseEntity<PaymentStatusResponse> getPaymentStatus(
            @Parameter(description = "Order number") @PathVariable String orderNumber) {
        PaymentStatusResponse response = paymentService.getPaymentStatus(orderNumber);
        return ResponseEntity.ok(response);

    }

    @PostMapping("/{orderNumber}/cancel")
    @Operation(summary = "Cancel payment", description = "Cancel a pending payment link")
    public ResponseEntity<Map<String, String>> cancelPayment(
            @Parameter(description = "Order number") @PathVariable String orderNumber) {
        try {
            paymentService.cancelPayment(orderNumber);
            return ResponseEntity.ok(Map.of("message", "Payment cancelled successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
