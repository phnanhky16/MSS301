package com.kidfavor.reviewservice.client;

import com.kidfavor.reviewservice.dto.ApiResponse;
import com.kidfavor.reviewservice.dto.UserDTO;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class UserClientFallbackFactory implements FallbackFactory<UserClient> {

    @Override
    public UserClient create(Throwable cause) {
        log.error("User Service fallback triggered due to: {}", cause.getMessage());
        
        return new UserClient() {
            @Override
            public ApiResponse<UserDTO> getUserById(Long id) {
                log.warn("Fallback: Unable to fetch user with ID {}. Cause: {}", id, cause.getMessage());
                
                // Check if it's a 404 error (user not found)
                if (cause instanceof FeignException.NotFound) {
                    throw new RuntimeException("User not found with id: " + id);
                }
                
                // Check if it's a connection error or service unavailable
                if (cause instanceof FeignException.ServiceUnavailable ||
                    cause instanceof FeignException.BadGateway ||
                    cause instanceof FeignException.GatewayTimeout ||
                    cause.getMessage() != null && cause.getMessage().contains("Connection refused")) {
                    throw new RuntimeException("User Service is currently unavailable. Please try again later.");
                }
                
                // For other Feign exceptions
                if (cause instanceof FeignException) {
                    FeignException fe = (FeignException) cause;
                    if (fe.status() == 404) {
                        throw new RuntimeException("User not found with id: " + id);
                    }
                    throw new RuntimeException("Failed to fetch user from User Service: " + cause.getMessage());
                }
                
                // Default: service unavailable
                throw new RuntimeException("User Service is currently unavailable: " + cause.getMessage());
            }
        };
    }
}
