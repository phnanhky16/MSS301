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
                // CORS handling has been removed entirely.  the gateway is
                // responsible for any Access-Control-* headers and Spring
                // Security will no longer apply its own CORS filter.  this makes
                // the backend oblivious to cross-origin concerns (requests may
                // still be blocked by the browser if no header is sent).
                
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
        // CORS configuration bean removed; the service no longer advertises
        // any Access-Control-* headers.  rely on the gateway or clients to
        // handle cross-origin requirements if necessary.
}
