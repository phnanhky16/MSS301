package com.kidfavor.reviewservice.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaTopicConfig {

    @Value("${kafka.topics.review-created}")
    private String reviewCreatedTopic;

    @Value("${kafka.topics.review-updated}")
    private String reviewUpdatedTopic;

    @Value("${kafka.topics.review-deleted}")
    private String reviewDeletedTopic;

    @Bean
    public NewTopic reviewCreatedTopic() {
        return TopicBuilder.name(reviewCreatedTopic)
                .partitions(3)
                .replicas(1)
                .build();
    }

    @Bean
    public NewTopic reviewUpdatedTopic() {
        return TopicBuilder.name(reviewUpdatedTopic)
                .partitions(3)
                .replicas(1)
                .build();
    }

    @Bean
    public NewTopic reviewDeletedTopic() {
        return TopicBuilder.name(reviewDeletedTopic)
                .partitions(3)
                .replicas(1)
                .build();
    }
}
