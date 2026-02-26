package com.kidfavor.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

// scanBasePackages expanded so that support classes under
// `com.kidfavor.apigateway` (CorsCleanupFilter, etc.) are picked up even
// though the main application class lives in `com.kidfavor.gateway`.
@SpringBootApplication(scanBasePackages = "com.kidfavor")
@EnableDiscoveryClient
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}
