package com.kidfavor.apigateway.config;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import reactor.core.publisher.Mono;

@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class CorsCleanupFilter implements GlobalFilter {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        return chain.filter(exchange)
                .then(Mono.fromRunnable(() -> {
                    HttpHeaders headers = exchange.getResponse().getHeaders();
                    List<String> origins = headers.get(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN);
                    if (origins != null && !origins.isEmpty()) {
                        // parse each header value (could be comma-separated) and dedupe
                        List<String> tokens = origins.stream()
                                .flatMap(val -> Arrays.stream(val.split(",")))
                                .map(String::trim)
                                .filter(val -> !val.isEmpty() && !"*".equals(val))
                                .distinct()
                                .collect(Collectors.toList());
                        if (!tokens.isEmpty()) {
                            headers.set(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, String.join(", ", tokens));
                        } else {
                            // no valid origins left
                            headers.remove(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN);
                        }
                    }
                }));
    }
}
