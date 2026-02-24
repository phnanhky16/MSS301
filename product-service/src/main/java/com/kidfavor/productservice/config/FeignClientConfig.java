package com.kidfavor.productservice.config;

import feign.Logger;
import feign.Retryer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

/**
 * Configuration for Feign clients.
 * Provides logging and retry policies for inter-service communication.
 */
@Configuration
public class FeignClientConfig {

    /**
     * Enable full logging for Feign clients in development.
     */
    @Bean
    public Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }

    /**
     * Configure retry policy for transient failures.
     * Retries up to 3 times with exponential backoff.
     */
    @Bean
    public Retryer feignRetryer() {
        return new Retryer.Default(
                100,           // initial interval in ms
                TimeUnit.SECONDS.toMillis(1), // max interval
                3              // max attempts
        );
    }
}
