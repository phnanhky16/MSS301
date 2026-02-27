package com.kidfavor.inventoryservice.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;
import java.util.List;

/**
 * CORS configuration for Inventory Service.
 * CORS is handled by API Gateway, not by individual services.
 */
@Configuration
public class WebConfig {

    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilterRegistration() {
        FilterRegistrationBean<CorsFilter> registration = new FilterRegistrationBean<>(
                new CorsFilter(new UrlBasedCorsConfigurationSource()));
        registration.setEnabled(false);
        return registration;
    }
}
