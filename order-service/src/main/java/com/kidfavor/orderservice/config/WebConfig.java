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
    // CORS is not configured in individual services.  All cross-origin
    // header handling is delegated to the API gateway; if this class were to
    // register filters/mappings the gateway would receive duplicate
    // Access-Control-Allow-Origin values and browsers would reject requests.
    //
    // The class remains present to satisfy any component-scan requirements, but
    // it contains no active beans or overrides.
}
