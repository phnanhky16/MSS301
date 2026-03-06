package com.kidfavor.inventoryservice.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Security configuration for inventory-service.
 * - GET endpoints are public
 * - POST, PUT, DELETE require authentication
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // explicitly enable a permissive CORS configuration for every
                // endpoint in the service. the gateway already adds a wildcard
                // header on every response, but when you hit a backend service
                // directly (e.g. during development) the Spring Security chain
                // will still enforce CORS rules unless we provide a source.
                // we could also configure this via `application.yml` but doing it
                // here keeps the behaviour consistent across modules.
                        .cors().and()
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Swagger and API docs - public
                        .requestMatchers(
                                "/v3/api-docs/**",
                                "/swagger-ui/**",
                                "/swagger-ui.html"
                        ).permitAll()
                        
                        // Actuator - public
                        .requestMatchers("/actuator/**").permitAll()
                        
                        // Internal service-to-service endpoints - no auth required
                        .requestMatchers("/internal/**").permitAll()
                        
                        // OPTIONS - permit all for CORS preflight
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        
                        // GET endpoints - public
                        .requestMatchers(HttpMethod.GET, "/api/stores/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/warehouses/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/inventory/**").permitAll()
                        
                        // Geocoding and Location endpoints - public for testing/frontend
                        .requestMatchers("/geocoding/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/location/**").permitAll()
                        
                        // Location-based inventory - public for order placement
                        .requestMatchers("/location-inventory/**").permitAll()
                        
                        // POST, PUT, DELETE - require authentication
                        .requestMatchers(HttpMethod.POST, "/api/**").authenticated()
                        .requestMatchers(HttpMethod.PUT, "/api/**").authenticated()
                        .requestMatchers(HttpMethod.DELETE, "/api/**").authenticated()
                        
                        // Location update endpoints - require authentication
                        .requestMatchers(HttpMethod.POST, "/location/**").authenticated()
                        
                        // Any other request - require authentication
                        .anyRequest().authenticated()
                )
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setStatus(HttpStatus.UNAUTHORIZED.value());
                            response.setContentType("application/json");
                            response.getWriter().write(
                                    "{\"error\": \"Unauthorized\", \"message\": \"Authentication required\"}"
                            );
                        })
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

        /**
         * Permit all origins/headers/methods for CORS.  This effectively disables
         * browser CORS protections when clients talk directly to this service.
         *
         * The API gateway already adds an Access-Control-Allow-Origin: * header to
         * every response, but enabling a matching `CorsConfigurationSource` here
         * prevents Spring Security from blocking preflight requests when the
         * service is invoked without the gateway (for example during local
         * testing).
         */
        @Bean
        public org.springframework.web.cors.CorsConfigurationSource corsConfigurationSource() {
                org.springframework.web.cors.CorsConfiguration configuration = new org.springframework.web.cors.CorsConfiguration();
                configuration.setAllowedOrigins(java.util.List.of("*"));
                configuration.setAllowedMethods(java.util.Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
                configuration.setAllowedHeaders(java.util.List.of("*"));
                configuration.setExposedHeaders(java.util.List.of("Authorization", "Content-Type"));
                org.springframework.web.cors.UrlBasedCorsConfigurationSource source = new org.springframework.web.cors.UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", configuration);
                return source;
        }
}
