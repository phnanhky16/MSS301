package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StoreRequest;
import com.kidfavor.inventoryservice.dto.StoreResponse;
import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.exception.DuplicateResourceException;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StoreService {

    private final StoreRepository storeRepository;
    private final InventoryMapper mapper;

    public List<StoreResponse> getAllStores() {
        log.info("Fetching all stores");
        return storeRepository.findAll().stream()
                .map(mapper::toStoreResponse)
                .collect(Collectors.toList());
    }

    public List<StoreResponse> getActiveStores() {
        log.info("Fetching active stores");
        return storeRepository.findByIsActive(true).stream()
                .map(mapper::toStoreResponse)
                .collect(Collectors.toList());
    }

    public StoreResponse getStoreById(Long id) {
        log.info("Fetching store with id: {}", id);
        Store store = storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
        return mapper.toStoreResponse(store);
    }

    public StoreResponse getStoreByCode(String code) {
        log.info("Fetching store with code: {}", code);
        Store store = storeRepository.findByStoreCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with code: " + code));
        return mapper.toStoreResponse(store);
    }

    @Transactional
    public StoreResponse createStore(StoreRequest request) {
        log.info("Creating new store with code: {}", request.getStoreCode());
        
        if (storeRepository.existsByStoreCode(request.getStoreCode())) {
            throw new DuplicateResourceException("Store already exists with code: " + request.getStoreCode());
        }

        Store store = mapper.toStore(request);
        Store savedStore = storeRepository.save(store);
        log.info("Store created successfully with id: {}", savedStore.getStoreId());
        
        return mapper.toStoreResponse(savedStore);
    }

    @Transactional
    public StoreResponse updateStore(Long id, StoreRequest request) {
        log.info("Updating store with id: {}", id);
        
        Store store = storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));

        // Check if code is being changed to an existing code
        if (!store.getStoreCode().equals(request.getStoreCode()) &&
            storeRepository.existsByStoreCode(request.getStoreCode())) {
            throw new DuplicateResourceException("Store already exists with code: " + request.getStoreCode());
        }

        store.setStoreCode(request.getStoreCode());
        store.setStoreName(request.getStoreName());
        store.setAddress(request.getAddress());
        store.setCity(request.getCity());
        store.setDistrict(request.getDistrict());
        store.setPhone(request.getPhone());
        store.setManagerName(request.getManagerName());
        store.setIsActive(request.getIsActive());

        Store updatedStore = storeRepository.save(store);
        log.info("Store updated successfully with id: {}", id);
        
        return mapper.toStoreResponse(updatedStore);
    }

    @Transactional
    public void deleteStore(Long id) {
        log.info("Deleting store with id: {}", id);
        
        Store store = storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
        
        storeRepository.delete(store);
        log.info("Store deleted successfully with id: {}", id);
    }

    public Store getStoreEntityById(Long id) {
        return storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
    }
}
