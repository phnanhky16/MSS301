package com.kidfavor.orderservice.listener;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderStatus;
import com.kidfavor.orderservice.repository.OrderRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Slf4j
@Component
@RequiredArgsConstructor
public class PaymentCompletedListener {

    private final OrderRepository orderRepository;

    @KafkaListener(topics = "${app.kafka.topics.payment-completed}", groupId = "${spring.kafka.consumer.group-id:order-service-group}", containerFactory = "kafkaListenerContainerFactory")
    @Transactional
    public void handlePaymentCompleted(PaymentCompletedEvent event) {
        log.info("Received PaymentCompletedEvent for order: {}", event.getOrderNumber());

        if (event.getOrderNumber() == null) {
            log.error("PaymentCompletedEvent missing orderNumber. Skipping.");
            return;
        }

        Order order = orderRepository.findByOrderNumber(event.getOrderNumber())
                .orElse(null);

        if (order == null) {
            log.error("Order not found: {}. Cannot update status.", event.getOrderNumber());
            return;
        }

        if (order.getStatus() == OrderStatus.CONFIRMED) {
            log.info("Order {} already CONFIRMED. Skipping.", event.getOrderNumber());
            return;
        }

        order.setStatus(OrderStatus.CONFIRMED);
        orderRepository.save(order);

        log.info("Order {} status updated to CONFIRMED after payment.", event.getOrderNumber());
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class PaymentCompletedEvent {
        private String orderNumber;
        private Long orderCode;
        private Long userId;
        private BigDecimal amount;
        private String transactionReference;
        private String paymentLinkId;
        private LocalDateTime paidAt;
    }
}
