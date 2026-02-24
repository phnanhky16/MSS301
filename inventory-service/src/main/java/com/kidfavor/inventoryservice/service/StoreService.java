package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StoreRequest;
import com.kidfavor.inventoryservice.dto.StoreResponse;
import com.kidfavor.inventoryservice.entity.Store;

import java.util.List;

public interface StoreService {
    
    List<StoreResponse> getAllStores();
    
    List<StoreResponse> getActiveStores();
    
    StoreResponse getStoreById(Long id);
    
    StoreResponse getStoreByCode(String code);
    
    StoreResponse createStore(StoreRequest request);
    
    StoreResponse updateStore(Long id, StoreRequest request);
    
    void deleteStore(Long id);
    
    Store getStoreEntityById(Long id);
}
