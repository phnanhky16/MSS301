package com.kidfavor.apigateway.config;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import reactor.core.publisher.Mono;

/**
 * Ensures an Access-Control-Allow-Origin header is present on *every* response,
 * even when the gateway short-circuits with an error (401/503/etc).
 *
 * The regular CORS mechanism in Spring Security may not execute for errors,
 * so this global filter adds a default header during commit if none exists.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class AddCorsHeaderFilter implements GlobalFilter {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        // before the response is committed (including error responses) add header
        exchange.getResponse().beforeCommit(() -> {
            HttpHeaders headers = exchange.getResponse().getHeaders();
            // always override the value with a wildcard.  there were cases
            // where the same header was accidentally appended twice, resulting
            // in "*, *" which browsers reject; setting explicitly avoids that
            // and keeps the behaviour simple (gateway is the single source of
            // truth for CORS headers).
            headers.set(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*");
            return Mono.empty();
        });
        return chain.filter(exchange);
    }
}