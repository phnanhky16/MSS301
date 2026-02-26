package com.kidfavor.cartservice;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.kafka.annotation.EnableKafka;

@SpringBootApplication
@EnableFeignClients
@EnableKafka
@OpenAPIDefinition(
    info = @Info(
        title = "Cart Service API",
        version = "1.0",
        description = "API for managing shopping carts",
        contact = @Contact(name = "KidFavor Team", email = "support@kidfavor.com")
    ),
    servers = {
        @Server(url = "http://localhost:8080/cart-service", description = "API Gateway"),
        @Server(url = "http://localhost:8085", description = "Direct")
    }
)
public class CartServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(CartServiceApplication.class, args);
    }
}
