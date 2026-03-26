package com.kidfavor.paymentservice.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI paymentServiceOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Payment Service API")
                        .description("Payment Service with PayOS Integration for KidFavor")
                        .version("1.0.0"))
                .servers(List.of(
                        new Server().url("http://localhost:8080/payment-service")
                                .description("API Gateway"),
                        new Server().url("http://localhost:8089")
                                .description("Direct Access")
                ));
    }
}
