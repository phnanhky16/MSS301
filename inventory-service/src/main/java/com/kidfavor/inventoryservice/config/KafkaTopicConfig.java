package com.kidfavor.inventoryservice.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaTopicConfig {

    @Value("${app.kafka.topics.stock-updated}")
    private String stockUpdatedTopic;

    @Value("${app.kafka.topics.stock-low-alert}")
    private String stockLowAlertTopic;

    @Bean
    public NewTopic stockUpdatedTopic() {
        return TopicBuilder.name(stockUpdatedTopic)
                .partitions(3)
                .replicas(1)
                .build();
    }

    @Bean
    public NewTopic stockLowAlertTopic() {
        return TopicBuilder.name(stockLowAlertTopic)
                .partitions(3)
                .replicas(1)
                .build();
    }
}
