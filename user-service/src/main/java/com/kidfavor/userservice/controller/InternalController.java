package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.service.UserService;
import io.swagger.v3.oas.annotations.Hidden;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Internal API endpoints for inter-service communication
 * These endpoints are NOT protected by JWT - they trust the API Gateway
 */
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Hidden // Hide from Swagger documentation
public class InternalController {
    
    UserService userService;
    
    /**
     * Get user by ID for internal service calls
     * Used by other microservices (e.g., review-service, order-service)
     */
    @GetMapping("/users/{id}")
    public ResponseEntity<ApiResponse<UserResponse>> getUserByIdInternal(
            @PathVariable Integer id) {
        UserResponse user = userService.getUserById(id);
        
        // Check if user is active
        if (user.getStatus() == null || !user.getStatus()) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(400, "User is inactive", null));
        }
        
        return ResponseEntity.ok(ApiResponse.success("Retrieved user successfully", user));
    }
    
    /**
     * Validate if user exists and is active
     */
    @GetMapping("/users/{id}/validate")
    public ResponseEntity<ApiResponse<String>> validateUser(@PathVariable Integer id) {
        try {
            UserResponse user = userService.getUserById(id);
            boolean isValid = user.getStatus() != null && user.getStatus();
            
            if (isValid) {
                return ResponseEntity.ok(ApiResponse.success("User is valid", "valid"));
            } else {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error(400, "User is inactive", "inactive"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(404, "User not found", "not_found"));
        }
    }
}
