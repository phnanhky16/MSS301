package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.request.shipment.ShipmentCreateRequest;
import com.kidfavor.userservice.dto.response.ShipmentResponse;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.service.ShipmentService;
import com.kidfavor.userservice.service.UserService;
import io.swagger.v3.oas.annotations.Hidden;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Internal API endpoints for inter-service communication
 * These endpoints are NOT protected by JWT - they trust the API Gateway
 * 
 * Consolidated internal controller for:
 * - User operations
 * - Shipment operations
 */
@Slf4j
@RestController
@RequestMapping("/internal")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Hidden // Hide from Swagger documentation
public class InternalController {
    
    UserService userService;
    ShipmentService shipmentService;
    
    /**
     * Get user by ID for internal service calls
     * Used by other microservices (e.g., review-service, order-service)
     */
    @GetMapping("/users/{id}")
    public ResponseEntity<ApiResponse<UserResponse>> getUserByIdInternal(
            @PathVariable Integer id) {
        UserResponse user = userService.getUserById(id);
        
        return ResponseEntity.ok(ApiResponse.success("Retrieved user successfully", user));
    }
    
    /**
     * Validate if user exists and is active
     */
    @GetMapping("/users/{id}/validate")
    public ResponseEntity<ApiResponse<String>> validateUser(@PathVariable Integer id) {
        try {
            userService.getUserById(id);
            return ResponseEntity.ok(ApiResponse.success("User exists", "exists"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(404, "User not found", "not_found"));
        }
    }
    
    // ==================== SHIPMENT ENDPOINTS ====================
    
    /**
     * Create shipment - Internal endpoint for order-service
     * No authentication required for service-to-service calls
     */
    @PostMapping("/shipments")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ShipmentResponse> createShipment(@RequestBody ShipmentCreateRequest request) {
        log.info("📦 Internal API: Creating shipment for user {}", request.getUserId());
        ShipmentResponse shipment = shipmentService.createShipment(request);
        log.info("✅ Internal API: Shipment created with ID: {}", shipment.getShipId());
        return ApiResponse.success("Shipment created successfully", shipment);
    }

    /**
     * Get shipment by ID - Internal endpoint
     */
    @GetMapping("/shipments/{shipmentId}")
    public ApiResponse<ShipmentResponse> getShipmentById(@PathVariable int shipmentId) {
        log.debug("📦 Internal API: Fetching shipment {}", shipmentId);
        ShipmentResponse shipment = shipmentService.getShipmentById(shipmentId);
        return ApiResponse.success("Shipment retrieved successfully", shipment);
    }
}
