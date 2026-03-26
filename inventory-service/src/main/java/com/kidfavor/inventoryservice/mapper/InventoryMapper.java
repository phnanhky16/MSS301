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
                .latitude(warehouse.getLatitude())
                .longitude(warehouse.getLongitude())
                .updatedBy(warehouse.getUpdatedBy())
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
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
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
                .latitude(store.getLatitude())
                .longitude(store.getLongitude())
                .updatedBy(store.getUpdatedBy())
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
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .build();
    }

    public WarehouseProductResponse toWarehouseProductResponse(WarehouseProduct wp) {
        return WarehouseProductResponse.builder()
                .productId(wp.getProductId())
                .productName(wp.getProductName())
                .quantity(wp.getQuantity())
                .status(wp.getStockStatus())
                .locationCode(wp.getLocationCode())
                .updatedBy(wp.getUpdatedBy())
                .lastUpdated(wp.getLastUpdated())
                .build();
    }

    public StoreInventoryResponse toStoreInventoryResponse(StoreInventory si) {
        // include store identifiers so callers (eg. product-service) can show
        // where the stock resides. `StoreInventory` holds a reference to the
        // Store entity; we lazily fetch the id/name here.
        Long storeId = null;
        String storeName = null;
        String address = null;
        String city = null;
        if (si.getStore() != null) {
            storeId = si.getStore().getStoreId();
            storeName = si.getStore().getStoreName();
            address = si.getStore().getAddress();
            city = si.getStore().getCity();
        }

        return StoreInventoryResponse.builder()
                .storeId(storeId)
                .storeName(storeName)
                .address(address)
                .city(city)
                .productId(si.getProductId())
                .productName(si.getProductName())
                .quantity(si.getQuantity())
                .status(si.getStockStatus())
                .shelfLocation(si.getShelfLocation())
                .updatedBy(si.getUpdatedBy())
                .lastUpdated(si.getLastUpdated())
                .build();
    }
}
