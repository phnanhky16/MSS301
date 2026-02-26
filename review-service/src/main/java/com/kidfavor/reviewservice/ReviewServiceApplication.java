package com.kidfavor.reviewservice;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableFeignClients
@EnableKafka
@EnableAsync
@OpenAPIDefinition(
    info = @Info(
        title = "Review Service API",
        version = "1.0",
        description = "API for managing product reviews",
        contact = @Contact(name = "KidFavor Team", email = "support@kidfavor.com")
    ),
    servers = {
        @Server(url = "http://localhost:8080/review-service", description = "API Gateway (Production)"),
        @Server(url = "http://localhost:8086", description = "Review Service (Direct - Development)")
    }
)
public class ReviewServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ReviewServiceApplication.class, args);
    }
}
