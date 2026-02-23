package com.kidfavor.gateway.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

// The gateway previously defined a CorsWebFilter here, but CORS can be handled
// solely via the SecurityConfig bean. Leaving both in place resulted in the
// same origin header being written twice, which browsers reject. Removing
// this file eliminates the redundant header. The SecurityConfig class now
// configures CORS properly for the frontend.

// class removed intentionally.
