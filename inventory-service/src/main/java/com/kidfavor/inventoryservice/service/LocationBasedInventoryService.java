package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.service.impl.LocationBasedInventoryServiceImpl.AllocationResult;
import com.kidfavor.inventoryservice.service.impl.LocationBasedInventoryServiceImpl.OrderItem;
import com.kidfavor.inventoryservice.service.impl.LocationBasedInventoryServiceImpl.StoreAvailability;

import java.util.List;

/**
 * Service interface for location-based inventory allocation
 * Automatically finds nearest store with sufficient stock
 */
public interface LocationBasedInventoryService {

    /**
     * Allocate inventory from nearest store with sufficient stock
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param productId Product ID to allocate
     * @param requiredQuantity Quantity needed
     * @param maxDistanceKm Maximum distance to search (km)
     * @return AllocationResult with store info and updated inventory
     */
    AllocationResult allocateFromNearestStore(
            Double userLatitude, 
            Double userLongitude,
            Long productId,
            Integer requiredQuantity,
            Double maxDistanceKm);

    /**
     * Allocate inventory from nearest warehouse with sufficient stock
     * Fallback when no store has enough inventory
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param productId Product ID to allocate
     * @param requiredQuantity Quantity needed
     * @param maxDistanceKm Maximum distance to search (km)
     * @return AllocationResult with warehouse info and updated inventory
     */
    AllocationResult allocateFromNearestWarehouse(
            Double userLatitude,
            Double userLongitude,
            Long productId,
            Integer requiredQuantity,
            Double maxDistanceKm);

    /**
     * Allocate multiple products from nearest store
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param items List of order items (product + quantity)
     * @param maxDistanceKm Maximum distance to search (km)
     * @return List of AllocationResults for each product
     */
    List<AllocationResult> allocateMultipleProducts(
            Double userLatitude,
            Double userLongitude,
            List<OrderItem> items,
            Double maxDistanceKm);

    /**
     * Find all stores with stock for a specific product
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param productId Product ID to search
     * @param minQuantity Minimum quantity required
     * @param maxDistanceKm Maximum distance to search (km)
     * @return List of StoreAvailability sorted by distance
     */
    List<StoreAvailability> findStoresWithStock(
            Double userLatitude,
            Double userLongitude,
            Long productId,
            Integer minQuantity,
            Double maxDistanceKm);
}
