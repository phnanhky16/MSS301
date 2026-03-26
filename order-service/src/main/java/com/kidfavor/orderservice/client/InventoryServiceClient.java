package com.kidfavor.orderservice.client;

import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
import com.kidfavor.orderservice.client.dto.BulkAllocationRequest;
import com.kidfavor.orderservice.client.dto.BulkAllocationResult;
import com.kidfavor.orderservice.client.dto.GeocodingResultDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * Feign Client for inventory-service
 * Used for geocoding addresses and allocating inventory based on location
 */
@FeignClient(
        name = "inventory-service",
        fallbackFactory = InventoryServiceClientFallbackFactory.class
)
public interface InventoryServiceClient {

    /**
     * Geocode address to GPS coordinates (Internal endpoint - no auth required)
     * 
     * @param address Full address
     * @param city City name
     * @param district District name
     * @return GPS coordinates
     */
    @GetMapping("/internal/geocoding")
    GeocodingResultDTO geocodeAddress(
            @RequestParam("address") String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "district", required = false) String district
    );

    /**
     * Allocate inventory from nearest store (Internal endpoint - no auth required)
     * 
     * @param latitude User's GPS latitude
     * @param longitude User's GPS longitude
     * @param productId Product ID to allocate
     * @param quantity Quantity needed
     * @param maxDistanceKm Maximum search distance (default 50km)
     * @return Allocation result with store info
     */
    @PostMapping("/internal/inventory/allocate")
    AllocationResultDTO allocateFromNearestStore(
            @RequestParam("latitude") Double latitude,
            @RequestParam("longitude") Double longitude,
            @RequestParam("productId") Long productId,
            @RequestParam("quantity") Integer quantity,
            @RequestParam(value = "maxDistanceKm", required = false, defaultValue = "50") Double maxDistanceKm);

    /**
     * Allocate inventory in bulk to multiple locations (Internal endpoint - no auth required)
     * 
     * @param request Bulk allocation request with multiple items and locations
     * @return Bulk allocation result with status for each item
     */
    @PostMapping("/internal/inventory/allocate-bulk")
    BulkAllocationResult allocateBulkInventory(@RequestBody BulkAllocationRequest request);
}
