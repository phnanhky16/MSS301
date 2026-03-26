package com.kidfavor.productservice.config;

import org.springframework.boot.autoconfigure.elasticsearch.ElasticsearchProperties;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Debug helper that prints the resolved Elasticsearch properties when the
 * application starts.  Useful for verifying that the username/password from
 * the environment are actually being seen by Spring Boot.
 */
@Component
public class EsPropertiesLogger implements CommandLineRunner {

    private final ElasticsearchProperties properties;

    public EsPropertiesLogger(ElasticsearchProperties properties) {
        this.properties = properties;
    }

    @Override
    public void run(String... args) {
        System.out.println("[DEBUG] ElasticsearchProperties: " + properties);
    }
}
