package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.entity.StoreInventory;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
import com.kidfavor.inventoryservice.repository.StoreInventoryRepository;
import com.kidfavor.inventoryservice.repository.StoreRepository;
import com.kidfavor.inventoryservice.repository.WarehouseProductRepository;
import com.kidfavor.inventoryservice.repository.WarehouseRepository;
import com.kidfavor.inventoryservice.service.GeocodingService;
import com.kidfavor.inventoryservice.service.LocationBasedInventoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

/**
 * Implementation of LocationBasedInventoryService
 * Provides location-based inventory allocation functionality
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class LocationBasedInventoryServiceImpl implements LocationBasedInventoryService {

    private final StoreRepository storeRepository;
    private final StoreInventoryRepository storeInventoryRepository;
    private final WarehouseRepository warehouseRepository;
    private final WarehouseProductRepository warehouseProductRepository;
    private final GeocodingService geocodingService;

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
    @Override
    @Transactional
    public AllocationResult allocateFromNearestStore(
            Double userLatitude, 
            Double userLongitude,
            Long productId,
            Integer requiredQuantity,
            Double maxDistanceKm) {
        
        log.info("Allocating {} units of product {} for user at ({}, {})", 
                 requiredQuantity, productId, userLatitude, userLongitude);
        
        // Validate input
        if (userLatitude == null || userLongitude == null) {
            return AllocationResult.failed("User GPS coordinates not provided");
        }
        
        if (requiredQuantity == null || requiredQuantity <= 0) {
            return AllocationResult.failed("Invalid quantity: " + requiredQuantity);
        }
        
        // Get all active stores with GPS
        List<Store> allStores = storeRepository.findByIsActive(true);
        List<StoreWithDistance> storesWithStock = new ArrayList<>();
        
        // Calculate distance and check stock for each store
        for (Store store : allStores) {
            if (store.getLatitude() == null || store.getLongitude() == null) {
                continue; // Skip stores without GPS
            }
            
            // Calculate distance
            double distance = geocodingService.calculateDistance(
                    userLatitude, userLongitude,
                    store.getLatitude(), store.getLongitude()
            );
            
            // Skip if beyond max distance
            if (maxDistanceKm != null && distance > maxDistanceKm) {
                log.debug("Store {} is too far: {}km", store.getStoreCode(), distance);
                continue;
            }
            
            // Check stock at this store
            Optional<StoreInventory> inventory = storeInventoryRepository
                    .findByStoreIdAndProductId(store.getStoreId(), productId);
            
            if (inventory.isPresent() && inventory.get().getQuantity() >= requiredQuantity) {
                storesWithStock.add(new StoreWithDistance(
                        store, 
                        inventory.get(), 
                        distance
                ));
                log.debug("Store {} has sufficient stock: {} units, distance: {}km", 
                         store.getStoreCode(), inventory.get().getQuantity(), distance);
            } else {
                log.debug("Store {} has insufficient stock: {} units (need {})", 
                         store.getStoreCode(), 
                         inventory.map(StoreInventory::getQuantity).orElse(0),
                         requiredQuantity);
            }
        }
        
        // No store found with sufficient stock - Try warehouse fallback
        if (storesWithStock.isEmpty()) {
            log.warn("No store found with sufficient stock for product {} within {}km, trying nearest warehouse", 
                     productId, maxDistanceKm);
            
            return allocateFromNearestWarehouse(
                    userLatitude, userLongitude, productId, requiredQuantity, maxDistanceKm
            );
        }
        
        // Sort by distance (nearest first)
        storesWithStock.sort(Comparator.comparingDouble(StoreWithDistance::getDistance));
        
        // Allocate from nearest store
        StoreWithDistance nearest = storesWithStock.get(0);
        Store nearestStore = nearest.getStore();
        StoreInventory inventory = nearest.getInventory();
        
        // Deduct stock
        int oldQuantity = inventory.getQuantity();
        inventory.setQuantity(oldQuantity - requiredQuantity);
        storeInventoryRepository.save(inventory);
        
        log.info("✅ Allocated {} units of product {} from store {} (distance: {}km). Stock: {} → {}", 
                 requiredQuantity, productId, nearestStore.getStoreCode(), 
                 nearest.getDistance(), oldQuantity, inventory.getQuantity());
        
        return AllocationResult.success(
                nearestStore,
                inventory,
                nearest.getDistance(),
                requiredQuantity,
                oldQuantity,
                inventory.getQuantity()
        );
    }

    /**
     * Allocate inventory from nearest warehouse
     * Used as fallback when no store has sufficient stock
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param productId Product ID to allocate
     * @param requiredQuantity Quantity needed
     * @param maxDistanceKm Maximum distance to search (km)
     * @return AllocationResult with warehouse info and updated inventory
     */
    @Transactional
    public AllocationResult allocateFromNearestWarehouse(
            Double userLatitude,
            Double userLongitude,
            Long productId,
            Integer requiredQuantity,
            Double maxDistanceKm) {
        
        log.info("🏭 Allocating {} units of product {} from nearest warehouse for user at ({}, {})",
                 requiredQuantity, productId, userLatitude, userLongitude);
        
        // Get all active warehouses with GPS
        List<Warehouse> allWarehouses = warehouseRepository.findByIsActive(true);
        List<WarehouseWithDistance> warehousesWithStock = new ArrayList<>();
        
        // Calculate distance and check stock for each warehouse
        for (Warehouse warehouse : allWarehouses) {
            if (warehouse.getLatitude() == null || warehouse.getLongitude() == null) {
                continue; // Skip warehouses without GPS
            }
            
            // Calculate distance
            double distance = geocodingService.calculateDistance(
                    userLatitude, userLongitude,
                    warehouse.getLatitude(), warehouse.getLongitude()
            );
            
            // Skip if beyond max distance
            if (maxDistanceKm != null && distance > maxDistanceKm) {
                log.debug("Warehouse {} is too far: {}km", warehouse.getWarehouseCode(), distance);
                continue;
            }
            
            // Check stock at this warehouse
            Optional<WarehouseProduct> warehouseProduct = warehouseProductRepository
                    .findByWarehouseIdAndProductId(warehouse.getWarehouseId(), productId);
            
            if (warehouseProduct.isPresent() && warehouseProduct.get().getQuantity() >= requiredQuantity) {
                warehousesWithStock.add(new WarehouseWithDistance(
                        warehouse,
                        warehouseProduct.get(),
                        distance
                ));
                log.debug("Warehouse {} has sufficient stock: {} units, distance: {}km",
                         warehouse.getWarehouseCode(), warehouseProduct.get().getQuantity(), distance);
            }
        }
        
        // No warehouse found with sufficient stock
        if (warehousesWithStock.isEmpty()) {
            log.error("❌ No warehouse found with sufficient stock for product {} within {}km",
                     productId, maxDistanceKm);
            return AllocationResult.failed(
                    String.format("No store or warehouse has %d units of product %d within %dkm",
                                requiredQuantity, productId, maxDistanceKm != null ? maxDistanceKm.intValue() : 50)
            );
        }
        
        // Sort by distance (nearest first)
        warehousesWithStock.sort(Comparator.comparingDouble(WarehouseWithDistance::getDistance));
        
        // Allocate from nearest warehouse
        WarehouseWithDistance nearest = warehousesWithStock.get(0);
        Warehouse nearestWarehouse = nearest.getWarehouse();
        WarehouseProduct warehouseProduct = nearest.getWarehouseProduct();
        
        // Deduct stock
        int oldQuantity = warehouseProduct.getQuantity();
        warehouseProduct.setQuantity(oldQuantity - requiredQuantity);
        warehouseProductRepository.save(warehouseProduct);
        
        log.info("✅ Allocated {} units of product {} from warehouse {} (distance: {}km). Stock: {} → {}",
                 requiredQuantity, productId, nearestWarehouse.getWarehouseCode(),
                 nearest.getDistance(), oldQuantity, warehouseProduct.getQuantity());
        
        return AllocationResult.successFromWarehouse(
                nearestWarehouse,
                warehouseProduct,
                nearest.getDistance(),
                requiredQuantity,
                oldQuantity,
                warehouseProduct.getQuantity()
        );
    }

    /**
     * Multi-product allocation from nearest stores
     * 
     * @param userLatitude User's GPS latitude
     * @param userLongitude User's GPS longitude
     * @param items List of product IDs and quantities
     * @param maxDistanceKm Maximum distance to search
     * @return List of allocation results
     */
    @Transactional
    public List<AllocationResult> allocateMultipleProducts(
            Double userLatitude,
            Double userLongitude,
            List<OrderItem> items,
            Double maxDistanceKm) {
        
        List<AllocationResult> results = new ArrayList<>();
        
        for (OrderItem item : items) {
            AllocationResult result = allocateFromNearestStore(
                    userLatitude, 
                    userLongitude, 
                    item.getProductId(), 
                    item.getQuantity(), 
                    maxDistanceKm
            );
            results.add(result);
        }
        
        return results;
    }

    /**
     * Check available stores with stock within radius
     * Does NOT deduct inventory - just for checking
     */
    @Transactional(readOnly = true)
    public List<StoreAvailability> findStoresWithStock(
            Double userLatitude,
            Double userLongitude,
            Long productId,
            Integer requiredQuantity,
            Double maxDistanceKm) {
        
        List<Store> allStores = storeRepository.findByIsActive(true);
        List<StoreAvailability> availability = new ArrayList<>();
        
        for (Store store : allStores) {
            if (store.getLatitude() == null || store.getLongitude() == null) {
                continue;
            }
            
            double distance = geocodingService.calculateDistance(
                    userLatitude, userLongitude,
                    store.getLatitude(), store.getLongitude()
            );
            
            if (maxDistanceKm != null && distance > maxDistanceKm) {
                continue;
            }
            
            Optional<StoreInventory> inventory = storeInventoryRepository
                    .findByStoreIdAndProductId(store.getStoreId(), productId);
            
            int availableStock = inventory.map(StoreInventory::getQuantity).orElse(0);
            boolean hasSufficientStock = availableStock >= requiredQuantity;
            
            if (hasSufficientStock) {
                availability.add(new StoreAvailability(
                        store.getStoreCode(),
                        store.getStoreName(),
                        store.getLatitude(),
                        store.getLongitude(),
                        distance,
                        availableStock,
                        requiredQuantity,
                        hasSufficientStock
                ));
            }
        }
        
        // Sort by distance
        availability.sort(Comparator.comparingDouble(StoreAvailability::getDistanceKm));
        
        return availability;
    }

    // Helper classes
    
    /**
     * Internal class to hold store with distance
     */
    private static class StoreWithDistance {
        private final Store store;
        private final StoreInventory inventory;
        private final double distance;
        
        public StoreWithDistance(Store store, StoreInventory inventory, double distance) {
            this.store = store;
            this.inventory = inventory;
            this.distance = distance;
        }
        
        public Store getStore() { return store; }
        public StoreInventory getInventory() { return inventory; }
        public double getDistance() { return distance; }
    }
    
    /**
     * Helper class to hold warehouse, product, and distance information
     */
    private static class WarehouseWithDistance {
        private final Warehouse warehouse;
        private final WarehouseProduct warehouseProduct;
        private final double distance;
        
        public WarehouseWithDistance(Warehouse warehouse, WarehouseProduct warehouseProduct, double distance) {
            this.warehouse = warehouse;
            this.warehouseProduct = warehouseProduct;
            this.distance = distance;
        }
        
        public Warehouse getWarehouse() { return warehouse; }
        public WarehouseProduct getWarehouseProduct() { return warehouseProduct; }
        public double getDistance() { return distance; }
    }
    
    /**
     * Order item for multi-product allocation
     */
    public static class OrderItem {
        private Long productId;
        private Integer quantity;
        
        public OrderItem() {}
        
        public OrderItem(Long productId, Integer quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }
        
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }
    
    /**
     * Result of inventory allocation
     */
    public static class AllocationResult {
        private boolean success;
        private String message;
        private Long storeId;           // Added for order.storeId
        private String storeCode;
        private String storeName;
        private Double storeLatitude;
        private Double storeLongitude;
        private Long warehouseId;       // Added for completeness
        private String warehouseCode;
        private String warehouseName;
        private Double warehouseLatitude;
        private Double warehouseLongitude;
        private Double distanceKm;
        private Integer allocatedQuantity;
        private Integer stockBefore;
        private Integer stockAfter;
        
        private AllocationResult() {}
        
        public static AllocationResult success(Store store, StoreInventory inventory, 
                                               double distance, int allocated, 
                                               int before, int after) {
            AllocationResult result = new AllocationResult();
            result.success = true;
            result.message = "Successfully allocated from store " + store.getStoreCode();
            result.storeId = store.getStoreId();       // ✅ Add storeId
            result.storeCode = store.getStoreCode();
            result.storeName = store.getStoreName();
            result.storeLatitude = store.getLatitude();
            result.storeLongitude = store.getLongitude();
            result.distanceKm = distance;
            result.allocatedQuantity = allocated;
            result.stockBefore = before;
            result.stockAfter = after;
            return result;
        }
        
        public static AllocationResult successFromWarehouse(Warehouse warehouse, 
                                                            WarehouseProduct warehouseProduct,
                                                            double distance, int allocated, 
                                                            int before, int after) {
            AllocationResult result = new AllocationResult();
            result.success = true;
            result.message = "Successfully allocated from warehouse " + warehouse.getWarehouseCode();
            result.warehouseId = warehouse.getWarehouseId();  // ✅ Add warehouseId
            result.warehouseCode = warehouse.getWarehouseCode();
            result.warehouseName = warehouse.getWarehouseName();
            result.warehouseLatitude = warehouse.getLatitude();
            result.warehouseLongitude = warehouse.getLongitude();
            result.distanceKm = distance;
            result.allocatedQuantity = allocated;
            result.stockBefore = before;
            result.stockAfter = after;
            return result;
        }
        
        public static AllocationResult failed(String message) {
            AllocationResult result = new AllocationResult();
            result.success = false;
            result.message = message;
            return result;
        }
        
        // Getters
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Long getStoreId() { return storeId; }           // ✅ Added
        public String getStoreCode() { return storeCode; }
        public String getStoreName() { return storeName; }
        public Double getStoreLatitude() { return storeLatitude; }
        public Double getStoreLongitude() { return storeLongitude; }
        public Long getWarehouseId() { return warehouseId; }   // ✅ Added
        public String getWarehouseCode() { return warehouseCode; }
        public String getWarehouseName() { return warehouseName; }
        public Double getWarehouseLatitude() { return warehouseLatitude; }
        public Double getWarehouseLongitude() { return warehouseLongitude; }
        public Double getDistanceKm() { return distanceKm; }
        public Integer getAllocatedQuantity() { return allocatedQuantity; }
        public Integer getStockBefore() { return stockBefore; }
        public Integer getStockAfter() { return stockAfter; }
    }
    
    /**
     * Store availability info (no allocation)
     */
    public static class StoreAvailability {
        private String storeCode;
        private String storeName;
        private Double latitude;
        private Double longitude;
        private Double distanceKm;
        private Integer availableStock;
        private Integer requiredQuantity;
        private Boolean hasSufficientStock;
        
        public StoreAvailability(String storeCode, String storeName, Double latitude, 
                                 Double longitude, Double distanceKm, Integer availableStock,
                                 Integer requiredQuantity, Boolean hasSufficientStock) {
            this.storeCode = storeCode;
            this.storeName = storeName;
            this.latitude = latitude;
            this.longitude = longitude;
            this.distanceKm = distanceKm;
            this.availableStock = availableStock;
            this.requiredQuantity = requiredQuantity;
            this.hasSufficientStock = hasSufficientStock;
        }
        
        // Getters
        public String getStoreCode() { return storeCode; }
        public String getStoreName() { return storeName; }
        public Double getLatitude() { return latitude; }
        public Double getLongitude() { return longitude; }
        public Double getDistanceKm() { return distanceKm; }
        public Integer getAvailableStock() { return availableStock; }
        public Integer getRequiredQuantity() { return requiredQuantity; }
        public Boolean getHasSufficientStock() { return hasSufficientStock; }
    }
}
