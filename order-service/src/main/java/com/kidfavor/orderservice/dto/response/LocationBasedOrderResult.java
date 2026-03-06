package com.kidfavor.orderservice.dto.response;

import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Result of location-based order processing
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LocationBasedOrderResult {
    private String orderNumber;
    private Boolean shipmentCreated;
    private Long shipmentId;
    private Boolean geocodingSuccess;
    private Double latitude;
    private Double longitude;
    private Long allocatedStoreId;              // Store ID from allocation
    private List<AllocationResultDTO> allocations;
    private Boolean allAllocationsSuccessful;
    private String errorMessage;
}
