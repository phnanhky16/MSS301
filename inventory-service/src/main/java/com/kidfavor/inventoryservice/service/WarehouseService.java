package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.WarehouseRequest;
import com.kidfavor.inventoryservice.dto.WarehouseResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;

import java.util.List;

public interface WarehouseService {
    
    List<WarehouseResponse> getAllWarehouses();
    
    List<WarehouseResponse> getActiveWarehouses();
    
    WarehouseResponse getWarehouseById(Long id);
    
    WarehouseResponse getWarehouseByCode(String code);
    
    WarehouseResponse createWarehouse(WarehouseRequest request);
    
    WarehouseResponse updateWarehouse(Long id, WarehouseRequest request);
    
    void deleteWarehouse(Long id);
    
    Warehouse getWarehouseEntityById(Long id);
}
