package com.kidfavor.orderservice.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * OpenAPI/Swagger Configuration for Order Service
 * Configures JWT Bearer authentication in Swagger UI
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI orderServiceOpenAPI() {
        // Define JWT Security Scheme
        SecurityScheme securityScheme = new SecurityScheme()
                .name("bearerAuth")
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .in(SecurityScheme.In.HEADER)
                .description("JWT Authentication token from User Service. " +
                        "Login at http://localhost:8081/api/auth/login to get token.");

        // Define Security Requirement
        SecurityRequirement securityRequirement = new SecurityRequirement()
                .addList("bearerAuth");

        return new OpenAPI()
                .info(new Info()
                        .title("Order Service API")
                        .description("RESTful API for Order Management in KidFavor Microservices Architecture. " +
                                "Handles order creation, location-based inventory allocation, and shipment coordination.")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("KidFavor Team")
                                .email("contact@kidfavor.com")
                                .url("https://kidfavor.com"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server()
                                .url("http://localhost:8080/order-service")
                                .description("API Gateway"),
                        new Server()
                                .url("http://localhost:8082")
                                .description("Direct Access (Local Development)")
                ))
                .components(new Components()
                        .addSecuritySchemes("bearerAuth", securityScheme))
                .addSecurityItem(securityRequirement);
    }
}
