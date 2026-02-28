package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.ApiResponse;
import com.kidfavor.orderservice.client.dto.UserDto;
import com.kidfavor.orderservice.exception.UserNotFoundException;
import com.kidfavor.orderservice.exception.UserServiceUnavailableException;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

/**
 * Fallback factory for UserServiceClient.
 * Provides graceful degradation when User Service is unavailable.
 */
@Slf4j
@Component
public class UserServiceClientFallbackFactory implements FallbackFactory<UserServiceClient> {

    @Override
    public UserServiceClient create(Throwable cause) {
        log.error("User Service fallback triggered due to: {}", cause.getMessage());

        return new UserServiceClient() {
            @Override
            public ApiResponse<UserDto> getUserById(Long id) {
                log.warn("Fallback: Unable to fetch user with ID {}. Cause: {}", id, cause.getMessage());

                // Check if it's a 404 error (user not found)
                if (cause instanceof FeignException.NotFound) {
                    throw new UserNotFoundException(id);
                }

                // Check if it's a connection error or service unavailable
                if (cause instanceof FeignException.ServiceUnavailable ||
                        cause instanceof FeignException.BadGateway ||
                        cause instanceof FeignException.GatewayTimeout ||
                        cause.getMessage() != null && cause.getMessage().contains("Connection refused")) {
                    throw new UserServiceUnavailableException(
                            "User Service is currently unavailable. Please try again later.");
                }

                // For other Feign exceptions, check status code
                if (cause instanceof FeignException) {
                    FeignException fe = (FeignException) cause;
                    if (fe.status() == 404) {
                        throw new UserNotFoundException(id);
                    }
                    throw new UserServiceUnavailableException(
                            "Failed to fetch user from User Service: " + cause.getMessage());
                }

                // Default: service unavailable
                throw new UserServiceUnavailableException(
                        "User Service is currently unavailable: " + cause.getMessage());
            }
        };
    }
}
