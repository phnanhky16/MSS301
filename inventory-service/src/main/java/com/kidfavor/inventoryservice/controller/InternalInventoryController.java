package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.service.LocationBasedInventoryService;
import com.kidfavor.inventoryservice.service.impl.LocationBasedInventoryServiceImpl.AllocationResult;
import com.kidfavor.inventoryservice.dto.BulkAllocationRequest;
import com.kidfavor.inventoryservice.dto.BulkAllocationResult;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * Internal Controller for Inventory operations
 * Used for service-to-service communication (no authentication required)
 */
@Slf4j
@RestController
@RequestMapping("/internal/inventory")
@RequiredArgsConstructor
public class InternalInventoryController {

    private final LocationBasedInventoryService locationBasedInventoryService;

    /**
     * Allocate inventory from nearest store/warehouse - Internal endpoint for order-service
     * No authentication required for service-to-service calls
     */
    @PostMapping("/allocate")
    public AllocationResult allocateInventory(
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam Long productId,
            @RequestParam Integer quantity,
            @RequestParam(required = false, defaultValue = "50") Double maxDistanceKm) {
        
        log.info("📦 Internal API: Allocating {} units of product {} from nearest location to ({}, {})",
                 quantity, productId, latitude, longitude);
        
        AllocationResult result = locationBasedInventoryService.allocateFromNearestStore(
                latitude, longitude, productId, quantity, maxDistanceKm
        );
        
        if (result.isSuccess()) {
            String locationCode = result.getStoreCode() != null ? result.getStoreCode() : result.getWarehouseCode();
            log.info("✅ Internal API: Allocated from {} ({}km away)",
                     locationCode, result.getDistanceKm());
        } else {
            log.warn("❌ Internal API: Allocation failed: {}", result.getMessage());
        }
        
        return result;
    }

    /**
     * Allocate inventory for multiple items from nearest stores.
     * Uses a greedy algorithm.
     */
    @PostMapping("/allocate-bulk")
    public BulkAllocationResult allocateBulkInventory(@RequestBody BulkAllocationRequest request) {
        log.info("📦 Internal API: Bulk allocating {} items from nearest locations to ({}, {})",
                 request.getItems().size(), request.getLatitude(), request.getLongitude());
                 
        BulkAllocationResult result = locationBasedInventoryService.allocateBulkInventories(request);
        
        if (result.isFullyAllocated()) {
            log.info("✅ Internal API: Bulk allocation completely successful");
        } else {
            log.warn("⚠️ Internal API: Bulk allocation partially failed: {}", result.getMessage());
        }
        
        return result;
    }
}
