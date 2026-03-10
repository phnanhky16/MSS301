package com.kidfavor.gateway.security;

import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;
// CORS support is controlled by `gateway.cors.enabled` property.  when
// enabled the gateway registers a CorsWebFilter (see CorsConfig) and the
// AddCorsHeaderFilter ensures a wildcard origin header on all responses.
// imports are left here for reference but are not required unless the
// feature is active.
// import org.springframework.web.cors.CorsConfiguration;
// import org.springframework.web.cors.reactive.CorsConfigurationSource;
// import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http) {
        http
            .csrf(ServerHttpSecurity.CsrfSpec::disable)
            // we no longer configure "cors" here; a dedicated global filter
            // (AddCorsHeaderFilter) unconditionally injects a wildcard
            // Access-Control-Allow-Origin header on every response.  keeping a
            // cors() spec in security would actually trigger Spring's built-in
            // CORS machinery and could conflict with the simple header we add.
            .authorizeExchange(exchanges -> exchanges
                // All requests are permitted - let downstream services handle auth
                .anyExchange().permitAll()
            );

        return http.build();
    }

    // CORS configuration bean removed as headers are no longer injected by
    // the gateway.  Retaining the commented-out method for historical
    // reference.
    //
    // @Bean
    // public CorsConfigurationSource corsConfigurationSource() {
    //     CorsConfiguration configuration = new CorsConfiguration();
    //     configuration.setAllowedOrigins(List.of("*"));
    //     configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
    //     configuration.setAllowedHeaders(List.of("*"));
    //     configuration.setExposedHeaders(Arrays.asList("Authorization", "Content-Type"));
    //     
    //     UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    //     source.registerCorsConfiguration("/**", configuration);
    //     return source;
    // }
}
