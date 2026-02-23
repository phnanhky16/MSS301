package com.kidfavor.inventoryservice.kafka;

import com.kidfavor.inventoryservice.event.StockLowAlertEvent;
import com.kidfavor.inventoryservice.event.StockUpdatedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class KafkaProducerService {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${app.kafka.topics.stock-updated}")
    private String stockUpdatedTopic;

    @Value("${app.kafka.topics.stock-low-alert}")
    private String stockLowAlertTopic;

    public void sendStockUpdatedEvent(StockUpdatedEvent event) {
        log.info("Sending StockUpdatedEvent for product {} at {} {}", 
                event.getProductId(), event.getLocationType(), event.getLocationId());
        kafkaTemplate.send(stockUpdatedTopic, event.getProductId().toString(), event);
    }

    public void sendStockLowAlertEvent(StockLowAlertEvent event) {
        log.warn("Sending StockLowAlertEvent for product {} at {} {}. Current: {}, Min: {}", 
                event.getProductId(), event.getLocationType(), event.getLocationId(),
                event.getCurrentQuantity(), event.getMinStockLevel());
        kafkaTemplate.send(stockLowAlertTopic, event.getProductId().toString(), event);
    }
}
