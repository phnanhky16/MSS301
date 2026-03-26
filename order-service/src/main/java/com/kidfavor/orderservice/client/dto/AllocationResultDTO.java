package com.kidfavor.orderservice.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for inventory allocation result from inventory-service
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AllocationResultDTO {
    private Boolean success;
    private String message;
    
    // Store allocation info
    private Long storeId;           // Added for setting order.storeId
    private String storeCode;
    private String storeName;
    private Double storeLatitude;
    private Double storeLongitude;
    private Double distanceKm;
    private Integer allocatedQuantity;
    private Integer stockBefore;
    private Integer stockAfter;
    
    // For warehouse allocation
    private Long warehouseId;       // Added for completeness
    private String warehouseCode;
    private String warehouseName;
}
