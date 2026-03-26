package com.kidfavor.orderservice.dto.response;

import com.fasterxml.jackson.annotation.JsonAlias;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO for shipment response from user-service
 * Note: user-service returns "shipId" but we also support "shipmentId" alias
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShipmentResponse {
    
    @JsonAlias({"shipId", "shipmentId"})  // Support both field names
    private Long shipmentId;
    
    private Long userId;
    private String street;
    private String ward;
    private String district;
    private String city;
    private String address;
    private String phoneNumber;
    private Boolean status;
    private LocalDateTime createdAt;
}
