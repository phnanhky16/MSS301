package com.kidfavor.inventoryservice.mapper;

import com.kidfavor.inventoryservice.dto.*;
import com.kidfavor.inventoryservice.entity.*;
import org.springframework.stereotype.Component;

@Component
public class InventoryMapper {

    public WarehouseResponse toWarehouseResponse(Warehouse warehouse) {
        return WarehouseResponse.builder()
                .warehouseId(warehouse.getWarehouseId())
                .warehouseCode(warehouse.getWarehouseCode())
                .warehouseName(warehouse.getWarehouseName())
                .address(warehouse.getAddress())
                .city(warehouse.getCity())
                .district(warehouse.getDistrict())
                .ward(warehouse.getWard())
                .phone(warehouse.getPhone())
                .managerName(warehouse.getManagerName())
                .capacity(warehouse.getCapacity())
                .warehouseType(warehouse.getWarehouseType())
                .isActive(warehouse.getIsActive())
                .createdAt(warehouse.getCreatedAt())
                .updatedAt(warehouse.getUpdatedAt())
                .build();
    }

    public Warehouse toWarehouse(WarehouseRequest request) {
        return Warehouse.builder()
                .warehouseCode(request.getWarehouseCode())
                .warehouseName(request.getWarehouseName())
                .address(request.getAddress())
                .city(request.getCity())
                .district(request.getDistrict())
                .ward(request.getWard())
                .phone(request.getPhone())
                .managerName(request.getManagerName())
                .capacity(request.getCapacity())
                .warehouseType(request.getWarehouseType())
                .isActive(request.getIsActive())
                .build();
    }

    public StoreResponse toStoreResponse(Store store) {
        return StoreResponse.builder()
                .storeId(store.getStoreId())
                .storeCode(store.getStoreCode())
                .storeName(store.getStoreName())
                .address(store.getAddress())
                .city(store.getCity())
                .district(store.getDistrict())
                .phone(store.getPhone())
                .managerName(store.getManagerName())
                .isActive(store.getIsActive())
                .createdAt(store.getCreatedAt())
                .updatedAt(store.getUpdatedAt())
                .build();
    }

    public Store toStore(StoreRequest request) {
        return Store.builder()
                .storeCode(request.getStoreCode())
                .storeName(request.getStoreName())
                .address(request.getAddress())
                .city(request.getCity())
                .district(request.getDistrict())
                .phone(request.getPhone())
                .managerName(request.getManagerName())
                .isActive(request.getIsActive())
                .build();
    }

    public WarehouseProductResponse toWarehouseProductResponse(WarehouseProduct wp) {
        return WarehouseProductResponse.builder()
                .id(wp.getId())
                .warehouseId(wp.getWarehouse().getWarehouseId())
                .warehouseCode(wp.getWarehouse().getWarehouseCode())
                .warehouseName(wp.getWarehouse().getWarehouseName())
                .productId(wp.getProductId())
                .quantity(wp.getQuantity())
                .minStockLevel(wp.getMinStockLevel())
                .maxStockLevel(wp.getMaxStockLevel())
                .locationCode(wp.getLocationCode())
                .lastUpdated(wp.getLastUpdated())
                .build();
    }

    public StoreInventoryResponse toStoreInventoryResponse(StoreInventory si) {
        return StoreInventoryResponse.builder()
                .id(si.getId())
                .storeId(si.getStore().getStoreId())
                .storeCode(si.getStore().getStoreCode())
                .storeName(si.getStore().getStoreName())
                .productId(si.getProductId())
                .quantity(si.getQuantity())
                .minStockLevel(si.getMinStockLevel())
                .shelfLocation(si.getShelfLocation())
                .lastUpdated(si.getLastUpdated())
                .build();
    }
}
