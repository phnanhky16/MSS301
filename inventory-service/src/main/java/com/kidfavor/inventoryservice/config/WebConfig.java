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

    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilterRegistration() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        
        // Allow requests from these origins
        corsConfiguration.setAllowedOrigins(Arrays.asList(
                "http://localhost:8080",      // API Gateway
                "http://localhost:3000",      // React frontend
                "http://localhost:4200",      // Angular frontend
                "http://localhost:5173",      // Vite frontend
                "http://127.0.0.1:8080",
                "http://127.0.0.1:3000"
        ));
        
        // Allow all origins in development (comment out in production)
        corsConfiguration.setAllowedOriginPatterns(List.of("*"));
        
        // Allow these HTTP methods
        corsConfiguration.setAllowedMethods(Arrays.asList(
                "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"
        ));
        
        // Allow these headers
        corsConfiguration.setAllowedHeaders(Arrays.asList(
                "Authorization",
                "Content-Type",
                "Accept",
                "Origin",
                "X-Requested-With",
                "Access-Control-Request-Method",
                "Access-Control-Request-Headers"
        ));
        
        // Expose these headers to the client
        corsConfiguration.setExposedHeaders(Arrays.asList(
                "Authorization",
                "Content-Type",
                "X-Total-Count",
                "X-Page-Number",
                "X-Page-Size"
        ));
        
        // Allow credentials (cookies, authorization headers)
        corsConfiguration.setAllowCredentials(true);
        
        // Cache preflight response for 1 hour
        corsConfiguration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfiguration);
        
        FilterRegistrationBean<CorsFilter> bean = new FilterRegistrationBean<>(new CorsFilter(source));
        bean.setOrder(Ordered.HIGHEST_PRECEDENCE);
        return bean;
    }
}
