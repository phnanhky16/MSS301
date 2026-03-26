package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
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
                    Double userLatitude, Double userLongitude,
                    Long productId, Integer quantity, Double maxDistanceKm) {
                
                log.error("⚠️ Inventory allocation fallback triggered: {}", 
                         cause instanceof FeignException ? ((FeignException) cause).status() : cause.getMessage());
                
                // Return failed result
                return AllocationResultDTO.builder()
                        .success(false)
                        .message("Inventory service unavailable: " + cause.getMessage())
                        .build();
            }
        };
    }
}
