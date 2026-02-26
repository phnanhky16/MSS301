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
 * Allows cross-origin requests from API Gateway and frontend applications.
 */
@Configuration
public class WebConfig {

    // Gateway handles all CORS headers. this bean is intentionally disabled to
    // prevent duplicate Access-Control-Allow-Origin values in proxied responses.
    // returning null caused a startup failure, so we register it but disable it.
    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilterRegistration() {
        FilterRegistrationBean<CorsFilter> registration = new FilterRegistrationBean<>(
                new CorsFilter(new UrlBasedCorsConfigurationSource()));
        registration.setEnabled(false);
        return registration;
    }
}
