package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
import com.kidfavor.orderservice.client.dto.BulkAllocationRequest;
import com.kidfavor.orderservice.client.dto.BulkAllocationResult;
import com.kidfavor.orderservice.client.dto.GeocodingResultDTO;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

/**
 * Fallback factory for InventoryServiceClient
 * Provides graceful degradation when inventory-service is unavailable
 */
@Component
@Slf4j
public class InventoryServiceClientFallbackFactory implements FallbackFactory<InventoryServiceClient> {

    @Override
    public InventoryServiceClient create(Throwable cause) {
        return new InventoryServiceClient() {
            @Override
            public GeocodingResultDTO geocodeAddress(String address, String city, String district) {
                log.error("⚠️ Geocoding fallback triggered: {}", 
                         cause instanceof FeignException ? ((FeignException) cause).status() : cause.getMessage());
                
                // Return null to indicate geocoding failed
                return null;
            }

            @Override
            public AllocationResultDTO allocateFromNearestStore(
                    Double latitude, Double longitude, Long productId, Integer quantity, Double maxDistanceKm) {
                log.error("Fallback: Cannot allocate inventory from nearest store. Cause: {}", cause.getMessage());
                return AllocationResultDTO.builder()
                        .success(false)
                        .message("Inventory service unavailable: " + cause.getMessage())
                        .build();
            }

            @Override
            public BulkAllocationResult allocateBulkInventory(BulkAllocationRequest request) {
                log.error("Fallback: Cannot perform bulk allocation. Cause: {}", cause.getMessage());
                return BulkAllocationResult.builder()
                        .fullyAllocated(false)
                        .message("Inventory service unavailable: " + cause.getMessage())
                        .build();
            }
        };
    }
}
