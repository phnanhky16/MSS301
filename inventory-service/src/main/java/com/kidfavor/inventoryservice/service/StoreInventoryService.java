package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreAvailabilityResponse;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.dto.StoreRestockRequest;
import com.kidfavor.inventoryservice.dto.StoreRestockResponse;
import com.kidfavor.inventoryservice.enums.ProductStockStatus;

import java.util.List;

public interface StoreInventoryService {
    
    List<StoreInventoryResponse> getInventoryByStore(Long storeId);
    
    StoreInventoryResponse getStoreInventory(Long storeId, Long productId);
    
    List<StoreInventoryResponse> getLowStockProducts();
    
    List<StoreInventoryResponse> getLowStockProductsByStore(Long storeId);
    
    List<StoreInventoryResponse> getOutOfStockProducts();
    
    List<StoreInventoryResponse> getOutOfStockProductsByStore(Long storeId);
    
    List<StoreInventoryResponse> getInStockProducts();
    
    List<StoreInventoryResponse> getInStockProductsByStore(Long storeId);
    
    List<StoreInventoryResponse> getProductsByStatus(ProductStockStatus status);
    
    List<StoreInventoryResponse> getProductsByStatusAndStore(Long storeId, ProductStockStatus status);
    
    StoreInventoryResponse addOrUpdateInventory(StoreInventoryRequest request);
    
    StoreInventoryResponse updateStock(Long storeId, StockUpdateRequest request);
    
    void removeInventory(Long storeId, Long productId);
    
    Integer getAvailableStock(Long storeId, Long productId);
    
    List<StoreAvailabilityResponse> checkStoreAvailability(Long productId, Integer requiredQuantity);
    
    StoreRestockResponse restockFromWarehouse(StoreRestockRequest request);
    
    List<Long> getAllProductIdsWithStock();

    /**
     * Deducts the specified quantity from a store's inventory for a given product.
     * Throws if the product is not found in the store or if there is insufficient
     * stock.
     */
    void deductStock(Long storeId, Long productId, Integer quantity);
}
