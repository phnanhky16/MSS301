package com.kidfavor.orderservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;
import java.util.List;

/**
 * CORS configuration for Order Service.
 * Allows cross-origin requests from Gateway and frontend applications.
 */
@Configuration
public class WebConfig {
    // CORS configuration has been moved to the API gateway. the gateway is the
    // only external entry point for browser traffic, so the service should not
    // attempt to add its own Access-Control-* headers. leaving this class
    // around keeps the package structure consistent for other shared
    // configuration but it no longer implements WebMvcConfigurer or
    // registers any beans.
}
