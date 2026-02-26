package com.kidfavor.orderservice.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Swagger/OpenAPI configuration for Order Service.
 */
@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI orderServiceOpenAPI() {
        // Gateway server should be first (default)
        Server gatewayServer = new Server();
        gatewayServer.setUrl("http://localhost:8080/order-service");
        gatewayServer.setDescription("API Gateway Server");

        Server localServer = new Server();
        localServer.setUrl("http://localhost:8082");
        localServer.setDescription("Local Development Server");

        Contact contact = new Contact();
        contact.setEmail("support@kidfavor.com");
        contact.setName("KidFavor Support Team");
        contact.setUrl("https://www.kidfavor.com");

        License license = new License()
                .name("Apache 2.0")
                .url("https://www.apache.org/licenses/LICENSE-2.0");

        Info info = new Info()
                .title("Order Service API")
                .version("1.0.0")
                .contact(contact)
                .description("Order Service for KidFavor Microservices - Handles order creation, management, and event publishing")
                .termsOfService("https://www.kidfavor.com/terms")
                .license(license);

        return new OpenAPI()
                .info(info)
                .servers(List.of(gatewayServer, localServer));
    }
}
