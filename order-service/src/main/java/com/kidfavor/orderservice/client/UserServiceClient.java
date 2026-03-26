package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.ApiResponse;
import com.kidfavor.orderservice.client.dto.UserDto;
import com.kidfavor.orderservice.config.UserFeignClientConfig;
import com.kidfavor.orderservice.dto.request.ShipmentCreateRequest;
import com.kidfavor.orderservice.dto.response.ShipmentResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * Feign client for communicating with User Service.
 * Uses Consul service discovery to locate the user-service.
 * Uses internal endpoint to bypass authentication.
 */
@FeignClient(name = "user-service", configuration = UserFeignClientConfig.class, fallbackFactory = UserServiceClientFallbackFactory.class)
public interface UserServiceClient {

    @GetMapping("/internal/users/{id}")
    ApiResponse<UserDto> getUserById(@PathVariable("id") Long id);

    /**
     * Create shipment for order delivery (Internal endpoint - no auth required)
     * 
     * @param request Shipment creation request
     * @return Created shipment wrapped in ApiResponse
     */
    @PostMapping("/internal/shipments")
    ApiResponse<ShipmentResponse> createShipment(@RequestBody ShipmentCreateRequest request);
}
