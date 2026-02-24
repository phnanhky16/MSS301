package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;

import java.util.List;

public interface StoreInventoryService {
    
    List<StoreInventoryResponse> getInventoryByStore(Long storeId);
    
    StoreInventoryResponse getStoreInventory(Long storeId, Long productId);
    
    List<StoreInventoryResponse> getLowStockProducts();
    
    List<StoreInventoryResponse> getLowStockProductsByStore(Long storeId);
    
    StoreInventoryResponse addOrUpdateInventory(StoreInventoryRequest request);
    
    StoreInventoryResponse updateStock(Long storeId, StockUpdateRequest request);
    
    void removeInventory(Long storeId, Long productId);
    
    Integer getAvailableStock(Long storeId, Long productId);
}
