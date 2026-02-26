package com.kidfavor.productservice.config;

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
 * CORS configuration for Product Service.
 * Allows cross-origin requests from API Gateway and frontend applications.
 */
@Configuration
public class WebConfig {

    // CORS handling has been moved to the API gateway; downstream services
    // must not send their own Access-Control-Allow-Origin header.  The
    // previous incarnation of this method returned `null`, which caused Spring
    // to throw an IllegalStateException during start-up when it tried to
    // register the bean.  Instead we register a disabled filter so that the
    // bean exists but never executes, eliminating startup errors while still
    // documenting the intended state.
    @Bean
    public FilterRegistrationBean<CorsFilter> corsFilterRegistration() {
        FilterRegistrationBean<CorsFilter> registration = new FilterRegistrationBean<>(
                new CorsFilter(new UrlBasedCorsConfigurationSource()));
        registration.setEnabled(false);
        return registration;
    }
}
