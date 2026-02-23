package com.kidfavor.notificationservice.listener;

import com.kidfavor.notificationservice.dto.OrderPlacedEvent;
import com.kidfavor.notificationservice.dto.UserRegisteredEvent;
import com.kidfavor.notificationservice.service.EmailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Kafka listener for consuming notification events.
 * Handles OrderPlacedEvent from order-service and UserRegisteredEvent from user-service.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class NotificationListener {

    private final EmailService emailService;

    /**
     * Consumes order-placed events and sends order confirmation emails.
     */
    @KafkaListener(
            topics = "${app.kafka.topics.order-placed}",
            groupId = "${spring.kafka.consumer.group-id}",
            containerFactory = "kafkaListenerContainerFactory"
    )
    public void handleOrderPlacedEvent(OrderPlacedEvent event) {
        try {
            log.info("Received OrderPlacedEvent for order: {}, customer: {}",
                    event.getOrderNumber(), event.getCustomerEmail());

            if (event.getCustomerEmail() != null && !event.getCustomerEmail().isBlank()) {
                String totalAmount = event.getTotalAmount() != null
                        ? event.getTotalAmount().toPlainString()
                        : "N/A";
                String customerName = event.getCustomerName() != null ? event.getCustomerName() : "Customer";
                emailService.sendOrderConfirmationEmail(
                        event.getCustomerEmail(),
                        customerName,
                        event.getOrderNumber(),
                        totalAmount
                );
            } else {
                log.warn("OrderPlacedEvent missing customerEmail for order: {}", event.getOrderNumber());
            }
        } catch (Exception e) {
            log.error("Error processing OrderPlacedEvent: {}", e.getMessage(), e);
        }
    }

    /**
     * Consumes user-registered events and sends welcome emails.
     */
    @KafkaListener(
            topics = "${app.kafka.topics.user-registered}",
            groupId = "${spring.kafka.consumer.group-id}",
            containerFactory = "kafkaListenerContainerFactory"
    )
    public void handleUserRegisteredEvent(UserRegisteredEvent event) {
        try {
            log.info("Received UserRegisteredEvent for user: {}, email: {}",
                    event.getUsername(), event.getEmail());

            if (event.getEmail() != null && !event.getEmail().isBlank()) {
                String fullName = event.getFullName() != null ? event.getFullName() : event.getUsername();
                emailService.sendWelcomeEmail(event.getEmail(), fullName, event.getUsername());
            } else {
                log.warn("UserRegisteredEvent missing email for user: {}", event.getUsername());
            }
        } catch (Exception e) {
            log.error("Error processing UserRegisteredEvent: {}", e.getMessage(), e);
        }
    }
}
