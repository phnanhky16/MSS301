package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.dto.WarehouseTransferRequest;
import com.kidfavor.inventoryservice.dto.WarehouseTransferResponse;
import com.kidfavor.inventoryservice.enums.ProductStockStatus;

import java.util.List;
import java.util.Map;

public interface WarehouseProductService {
    
    List<WarehouseProductResponse> getProductsByWarehouse(Long warehouseId);
    
    WarehouseProductResponse getWarehouseProduct(Long warehouseId, Long productId);
    
    List<WarehouseProductResponse> getLowStockProducts();
    
    List<WarehouseProductResponse> getLowStockProductsByWarehouse(Long warehouseId);
    
    List<WarehouseProductResponse> getOutOfStockProducts();
    
    List<WarehouseProductResponse> getOutOfStockProductsByWarehouse(Long warehouseId);
    
    List<WarehouseProductResponse> getInStockProducts();
    
    List<WarehouseProductResponse> getInStockProductsByWarehouse(Long warehouseId);
    
    List<WarehouseProductResponse> getProductsByStatus(ProductStockStatus status);
    
    List<WarehouseProductResponse> getProductsByStatusAndWarehouse(Long warehouseId, ProductStockStatus status);
    
    WarehouseProductResponse addOrUpdateProduct(WarehouseProductRequest request);
    
    WarehouseProductResponse updateStock(Long warehouseId, StockUpdateRequest request);
    
    void removeProduct(Long warehouseId, Long productId);
    
    Integer getAvailableStock(Long warehouseId, Long productId);
    
    WarehouseTransferResponse transferBetweenWarehouses(WarehouseTransferRequest request);
    
    Map<Long, Integer> getTotalStockForProducts(List<Long> productIds);
    
    Integer getTotalStockForProduct(Long productId);
}
