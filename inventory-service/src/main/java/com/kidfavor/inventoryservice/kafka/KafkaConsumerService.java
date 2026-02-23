package com.kidfavor.inventoryservice.kafka;

import com.kidfavor.inventoryservice.event.OrderCreatedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class KafkaConsumerService {

    // This listener will consume order events from order-service
    // and can trigger inventory updates or notifications
    
    @KafkaListener(topics = "${app.kafka.topics.order-created:order-created}", 
                   groupId = "${spring.kafka.consumer.group-id}")
    public void handleOrderCreated(OrderCreatedEvent event) {
        log.info("Received OrderCreatedEvent: orderId={}, items={}", 
                event.getOrderId(), event.getItems().size());
        
        // TODO: Implement logic to:
        // 1. Reserve stock for the order
        // 2. Decrease inventory
        // 3. Send low stock alerts if needed
        
        event.getItems().forEach(item -> {
            log.info("Order item - ProductId: {}, Quantity: {}", 
                    item.getProductId(), item.getQuantity());
            // Process inventory deduction here
        });
    }
}
