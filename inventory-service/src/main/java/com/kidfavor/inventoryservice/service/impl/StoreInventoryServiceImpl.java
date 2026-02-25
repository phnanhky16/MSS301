package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.entity.StoreInventory;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.StoreInventoryRepository;
import com.kidfavor.inventoryservice.service.StoreInventoryService;
import com.kidfavor.inventoryservice.service.StoreService;
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
public class StoreInventoryServiceImpl implements StoreInventoryService {

    private final StoreInventoryRepository storeInventoryRepository;
    private final StoreService storeService;
    private final InventoryMapper mapper;

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return "system";
    }

    @Override
    public List<StoreInventoryResponse> getInventoryByStore(Long storeId) {
        log.info("Fetching inventory for store id: {}", storeId);
        return storeInventoryRepository.findByStoreId(storeId).stream()
                .map(mapper::toStoreInventoryResponse)
                .collect(Collectors.toList());
    }

    @Override
    public StoreInventoryResponse getStoreInventory(Long storeId, Long productId) {
        log.info("Fetching product {} in store {}", productId, storeId);
        Store store = storeService.getStoreEntityById(storeId);
        StoreInventory si = storeInventoryRepository.findByStoreAndProductId(store, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in store " + storeId));
        return mapper.toStoreInventoryResponse(si);
    }

    @Override
    public List<StoreInventoryResponse> getLowStockProducts() {
        log.info("Fetching low stock products in all stores");
        return storeInventoryRepository.findLowStockProducts().stream()
                .map(mapper::toStoreInventoryResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoreInventoryResponse> getLowStockProductsByStore(Long storeId) {
        log.info("Fetching low stock products in store: {}", storeId);
        return storeInventoryRepository.findLowStockProductsByStore(storeId).stream()
                .map(mapper::toStoreInventoryResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public StoreInventoryResponse addOrUpdateInventory(StoreInventoryRequest request) {
        log.info("Adding/updating product {} in store {}", request.getProductId(), request.getStoreId());
        
        Store store = storeService.getStoreEntityById(request.getStoreId());
        
        StoreInventory storeInventory = storeInventoryRepository
                .findByStoreAndProductId(store, request.getProductId())
                .orElse(StoreInventory.builder()
                        .store(store)
                        .productId(request.getProductId())
                        .build());

        storeInventory.setQuantity(request.getQuantity());
        storeInventory.setMinStockLevel(request.getMinStockLevel());
        storeInventory.setShelfLocation(request.getShelfLocation());
        storeInventory.setUpdatedBy(getCurrentUsername());

        StoreInventory saved = storeInventoryRepository.save(storeInventory);
        log.info("Product {} updated in store {}", request.getProductId(), request.getStoreId());
        
        return mapper.toStoreInventoryResponse(saved);
    }

    @Override
    @Transactional
    public StoreInventoryResponse updateStock(Long storeId, StockUpdateRequest request) {
        log.info("Updating stock for product {} in store {}", request.getProductId(), storeId);
        
        Store store = storeService.getStoreEntityById(storeId);
        StoreInventory storeInventory = storeInventoryRepository
                .findByStoreAndProductId(store, request.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + request.getProductId() + " not found in store " + storeId));

        storeInventory.setQuantity(request.getQuantity());
        storeInventory.setUpdatedBy(getCurrentUsername());
        StoreInventory saved = storeInventoryRepository.save(storeInventory);
        
        log.info("Stock updated for product {} in store {}. New quantity: {}", 
                request.getProductId(), storeId, request.getQuantity());
        
        return mapper.toStoreInventoryResponse(saved);
    }

    @Override
    @Transactional
    public void removeInventory(Long storeId, Long productId) {
        log.info("Removing product {} from store {}", productId, storeId);
        
        Store store = storeService.getStoreEntityById(storeId);
        StoreInventory storeInventory = storeInventoryRepository
                .findByStoreAndProductId(store, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in store " + storeId));

        storeInventoryRepository.delete(storeInventory);
        log.info("Product {} removed from store {}", productId, storeId);
    }

    @Override
    public Integer getAvailableStock(Long storeId, Long productId) {
        Store store = storeService.getStoreEntityById(storeId);
        return storeInventoryRepository.findByStoreAndProductId(store, productId)
                .map(StoreInventory::getQuantity)
                .orElse(0);
    }
}
