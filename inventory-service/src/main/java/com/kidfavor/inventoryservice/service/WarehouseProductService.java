package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;

import java.util.List;

public interface WarehouseProductService {
    
    List<WarehouseProductResponse> getProductsByWarehouse(Long warehouseId);
    
    WarehouseProductResponse getWarehouseProduct(Long warehouseId, Long productId);
    
    List<WarehouseProductResponse> getLowStockProducts();
    
    List<WarehouseProductResponse> getLowStockProductsByWarehouse(Long warehouseId);
    
    WarehouseProductResponse addOrUpdateProduct(WarehouseProductRequest request);
    
    WarehouseProductResponse updateStock(Long warehouseId, StockUpdateRequest request);
    
    void removeProduct(Long warehouseId, Long productId);
    
    Integer getAvailableStock(Long warehouseId, Long productId);
}
