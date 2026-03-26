package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.StoreRequest;
import com.kidfavor.inventoryservice.dto.StoreResponse;
import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.exception.DuplicateResourceException;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.StoreRepository;
import com.kidfavor.inventoryservice.service.StoreService;
import com.kidfavor.inventoryservice.service.GeocodingService;
import com.kidfavor.inventoryservice.dto.LocationDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StoreServiceImpl implements StoreService {

    private final StoreRepository storeRepository;
    private final InventoryMapper mapper;
    private final GeocodingService geocodingService;

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return "system";
    }

    @Override
    public List<StoreResponse> getAllStores() {
        log.info("Fetching all stores");
        return storeRepository.findAll().stream()
                .map(mapper::toStoreResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoreResponse> getActiveStores() {
        log.info("Fetching active stores");
        return storeRepository.findByIsActive(true).stream()
                .map(mapper::toStoreResponse)
                .collect(Collectors.toList());
    }

    @Override
    public StoreResponse getStoreById(Long id) {
        log.info("Fetching store with id: {}", id);
        Store store = storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
        return mapper.toStoreResponse(store);
    }

    @Override
    public StoreResponse getStoreByCode(String code) {
        log.info("Fetching store with code: {}", code);
        Store store = storeRepository.findByStoreCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with code: " + code));
        return mapper.toStoreResponse(store);
    }

    @Override
    @Transactional
    public StoreResponse createStore(StoreRequest request) {
        log.info("Creating new store with code: {}", request.getStoreCode());
        
        if (storeRepository.existsByStoreCode(request.getStoreCode())) {
            throw new DuplicateResourceException("Store already exists with code: " + request.getStoreCode());
        }

        Store store = mapper.toStore(request);
        
        if (request.getLatitude() == null || request.getLongitude() == null) {
            LocationDTO location = geocodingService.geocodeAddress(request.getAddress(), request.getCity(), request.getDistrict());
            if (location != null && location.getLatitude() != null && location.getLongitude() != null) {
                store.setLatitude(location.getLatitude());
                store.setLongitude(location.getLongitude());
            }
        }
        
        Store savedStore = storeRepository.save(store);
        log.info("Store created successfully with id: {}", savedStore.getStoreId());
        
        return mapper.toStoreResponse(savedStore);
    }

    @Override
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
        
        if (request.getLatitude() != null && request.getLongitude() != null) {
            store.setLatitude(request.getLatitude());
            store.setLongitude(request.getLongitude());
        } else if (!request.getAddress().equals(store.getAddress()) || !request.getCity().equals(store.getCity()) || !request.getDistrict().equals(store.getDistrict())) {
            // Address changed, update coordinates
            LocationDTO location = geocodingService.geocodeAddress(request.getAddress(), request.getCity(), request.getDistrict());
            if (location != null && location.getLatitude() != null && location.getLongitude() != null) {
                store.setLatitude(location.getLatitude());
                store.setLongitude(location.getLongitude());
            }
        }

        store.setUpdatedBy(getCurrentUsername());

        Store updatedStore = storeRepository.save(store);
        log.info("Store updated successfully with id: {}", id);
        
        return mapper.toStoreResponse(updatedStore);
    }

    @Override
    @Transactional
    public void deleteStore(Long id) {
        log.info("Soft deleting store with id: {}", id);
        
        Store store = storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
        
        store.setIsActive(false);
        storeRepository.save(store);
        log.info("Store soft deleted (deactivated) successfully with id: {}", id);
    }

    @Override
    public Store getStoreEntityById(Long id) {
        return storeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + id));
    }
}
