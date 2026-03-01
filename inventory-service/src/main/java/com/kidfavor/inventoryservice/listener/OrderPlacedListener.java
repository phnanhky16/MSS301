package com.kidfavor.inventoryservice.listener;

import com.kidfavor.inventoryservice.event.OrderPlacedEvent;
import com.kidfavor.inventoryservice.service.StoreInventoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

/**
 * Kafka listener that consumes order-placed events and deducts
 * the purchased quantities from the corresponding store's inventory.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OrderPlacedListener {

    private final StoreInventoryService storeInventoryService;

    @KafkaListener(topics = "${app.kafka.topics.order-placed}", groupId = "${spring.kafka.consumer.group-id}", containerFactory = "kafkaListenerContainerFactory")
    public void handleOrderPlacedEvent(OrderPlacedEvent event) {
        log.info("Received OrderPlacedEvent for order: {}, store: {}",
                event.getOrderNumber(), event.getStoreId());

        if (event.getStoreId() == null) {
            log.error("OrderPlacedEvent missing storeId for order: {}. Skipping inventory deduction.",
                    event.getOrderNumber());
            return;
        }

        if (event.getItems() == null || event.getItems().isEmpty()) {
            log.warn("OrderPlacedEvent has no items for order: {}. Skipping inventory deduction.",
                    event.getOrderNumber());
            return;
        }

        for (OrderPlacedEvent.OrderItemEvent item : event.getItems()) {
            try {
                storeInventoryService.deductStock(
                        event.getStoreId(),
                        item.getProductId(),
                        item.getQuantity());
                log.info("Stock deducted for product {} (qty: {}) in store {} — order: {}",
                        item.getProductId(), item.getQuantity(),
                        event.getStoreId(), event.getOrderNumber());
            } catch (Exception e) {
                log.error("Failed to deduct stock for product {} in store {} — order: {}. Error: {}",
                        item.getProductId(), event.getStoreId(),
                        event.getOrderNumber(), e.getMessage(), e);
                // Continue processing remaining items even if one fails
            }
        }

        log.info("Inventory deduction completed for order: {}", event.getOrderNumber());
    }
}
