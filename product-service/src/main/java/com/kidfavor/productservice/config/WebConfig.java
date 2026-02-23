package com.kidfavor.productservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
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

    // CORS headers are applied by the API gateway only. when the product
    // service is invoked through the gateway the origin seen by this process
    // is the browser origin (e.g. http://localhost:3000) which the gateway has
    // already authorized. attempting to add a second Access-Control-Allow-Origin
    // header here caused the browser errors you saw earlier:
    //
    //   "Access-Control-Allow-Origin header contains multiple values
    //    'http://localhost:3000, http://localhost:3000'"
    //
    // and Spring Security would block the request with 403 because the origin
    // wasn't in the limited list below. the order-service package already
    // removed its CORS filter for the same reason; do the same here so that
    // only the gateway is responsible for cross‑origin policies.

    // keep the class around for consistency, but do not register any beans or
    // configure WebMvcConfigurer. the gateway configuration lives in
    // api-gateway/src/main/java/com/kidfavor/apigateway/security/SecurityConfig.java
    // (see earlier commits).
}
