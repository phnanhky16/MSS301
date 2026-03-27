package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreAvailabilityResponse;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.dto.StoreRestockRequest;
import com.kidfavor.inventoryservice.dto.StoreRestockResponse;
import com.kidfavor.inventoryservice.client.ProductServiceClient;
import com.kidfavor.inventoryservice.client.dto.ProductResponseDto;
import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.entity.StoreInventory;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
import com.kidfavor.inventoryservice.enums.ProductStockStatus;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.StoreInventoryRepository;
import com.kidfavor.inventoryservice.repository.WarehouseProductRepository;
import com.kidfavor.inventoryservice.service.StoreInventoryService;
import com.kidfavor.inventoryservice.service.StoreService;
import com.kidfavor.inventoryservice.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StoreInventoryServiceImpl implements StoreInventoryService {

    private final StoreInventoryRepository storeInventoryRepository;
    private final StoreService storeService;
    private final WarehouseService warehouseService;
    private final WarehouseProductRepository warehouseProductRepository;
    private final InventoryMapper mapper;
    private final ProductServiceClient productServiceClient;

    private boolean needsProductEnrichment(StoreInventory si) {
        return si.getProductName() == null || si.getProductName().isBlank()
                || si.getPrice() == null
                || si.getImageUrl() == null || si.getImageUrl().isBlank();
    }

    private String firstImageUrl(ProductResponseDto dto) {
        if (dto == null || dto.getImageUrls() == null || dto.getImageUrls().isEmpty()) {
            return null;
        }
        return dto.getImageUrls().get(0);
    }

    private List<StoreInventoryResponse> toEnrichedResponses(List<StoreInventory> inventories) {
        if (inventories == null || inventories.isEmpty()) {
            return List.of();
        }

        List<Long> missingProductIds = inventories.stream()
                .filter(this::needsProductEnrichment)
                .map(StoreInventory::getProductId)
                .distinct()
                .collect(Collectors.toList());

        if (!missingProductIds.isEmpty()) {
            try {
                var response = productServiceClient.getProductsByIds(missingProductIds);
                if (response != null && response.isSuccess() && response.getData() != null) {
                    Map<Long, ProductResponseDto> productMap = response.getData().stream()
                            .collect(Collectors.toMap(ProductResponseDto::getId, p -> p, (a, b) -> a));

                    boolean changed = false;
                    for (StoreInventory si : inventories) {
                        ProductResponseDto product = productMap.get(si.getProductId());
                        if (product == null) {
                            continue;
                        }

                        if ((si.getProductName() == null || si.getProductName().isBlank()) && product.getName() != null) {
                            si.setProductName(product.getName());
                            changed = true;
                        }

                        if (si.getPrice() == null && product.getPrice() != null) {
                            si.setPrice(product.getPrice());
                            changed = true;
                        }

                        if (si.getSalePrice() == null && product.getSalePrice() != null) {
                            si.setSalePrice(product.getSalePrice());
                            changed = true;
                        }

                        if ((si.getImageUrl() == null || si.getImageUrl().isBlank())) {
                            String image = firstImageUrl(product);
                            if (image != null) {
                                si.setImageUrl(image);
                                changed = true;
                            }
                        }
                    }

                    if (changed) {
                        storeInventoryRepository.saveAll(inventories);
                    }
                }
            } catch (Exception e) {
                log.warn("Failed to enrich store inventory product details: {}", e.getMessage());
            }
        }

        return inventories.stream().map(mapper::toStoreInventoryResponse).collect(Collectors.toList());
    }

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
        return toEnrichedResponses(storeInventoryRepository.findByStoreId(storeId));
    }

    @Override
    public StoreInventoryResponse getStoreInventory(Long storeId, Long productId) {
        log.info("Fetching product {} in store {}", productId, storeId);
        Store store = storeService.getStoreEntityById(storeId);
        StoreInventory si = storeInventoryRepository.findByStoreAndProductId(store, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in store " + storeId));
        return toEnrichedResponses(List.of(si)).stream().findFirst().orElse(mapper.toStoreInventoryResponse(si));
    }

    @Override
    public List<StoreInventoryResponse> getLowStockProducts() {
        log.info("Fetching low stock products in all stores");
        return toEnrichedResponses(storeInventoryRepository.findLowStockProducts());
    }

    @Override
    public List<StoreInventoryResponse> getLowStockProductsByStore(Long storeId) {
        log.info("Fetching low stock products in store: {}", storeId);
        return toEnrichedResponses(storeInventoryRepository.findLowStockProductsByStore(storeId));
    }

    @Override
    public List<StoreInventoryResponse> getOutOfStockProducts() {
        log.info("Fetching out of stock products in all stores");
        return toEnrichedResponses(storeInventoryRepository.findOutOfStockProducts());
    }

    @Override
    public List<StoreInventoryResponse> getOutOfStockProductsByStore(Long storeId) {
        log.info("Fetching out of stock products in store: {}", storeId);
        return toEnrichedResponses(storeInventoryRepository.findOutOfStockProductsByStore(storeId));
    }

    @Override
    public List<StoreInventoryResponse> getInStockProducts() {
        log.info("Fetching in stock products in all stores");
        return toEnrichedResponses(storeInventoryRepository.findInStockProducts());
    }

    @Override
    public List<StoreInventoryResponse> getInStockProductsByStore(Long storeId) {
        log.info("Fetching in stock products in store: {}", storeId);
        return toEnrichedResponses(storeInventoryRepository.findInStockProductsByStore(storeId));
    }

    @Override
    public List<StoreInventoryResponse> getProductsByStatus(ProductStockStatus status) {
        log.info("Fetching products with status: {}", status);
        return switch (status) {
            case OUT_OF_STOCK -> getOutOfStockProducts();
            case LOW_STOCK -> getLowStockProducts();
            case IN_STOCK -> getInStockProducts();
        };
    }

    @Override
    public List<StoreInventoryResponse> getProductsByStatusAndStore(Long storeId, ProductStockStatus status) {
        log.info("Fetching products with status {} in store: {}", status, storeId);
        return switch (status) {
            case OUT_OF_STOCK -> getOutOfStockProductsByStore(storeId);
            case LOW_STOCK -> getLowStockProductsByStore(storeId);
            case IN_STOCK -> getInStockProductsByStore(storeId);
        };
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
        storeInventory.setProductName(request.getProductName());
        storeInventory.setPrice(request.getPrice());
        storeInventory.setSalePrice(request.getSalePrice());
        storeInventory.setImageUrl(request.getImageUrl());
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

    @Override
    public List<StoreAvailabilityResponse> checkStoreAvailability(Long productId) {
        log.info("Checking availability for product {}", productId);
        
        // Get all store inventory for this product
        List<StoreInventory> inventoryList = storeInventoryRepository.findByProductId(productId);
        
        if (inventoryList.isEmpty()) {
            log.warn("Product {} not found in any store", productId);
            return List.of();
        }
        
        // Convert to availability response, sorted by available quantity descending
        return inventoryList.stream()
                .map(inventory -> {
                    Store store = inventory.getStore();
                    
                    return StoreAvailabilityResponse.builder()
                            .storeId(store.getStoreId())
                            .storeCode(store.getStoreCode())
                            .storeName(store.getStoreName())
                            .address(store.getAddress())
                            .productId(productId)
                            .productName(inventory.getProductName())
                            .availableQuantity(inventory.getQuantity())
                            .shelfLocation(inventory.getShelfLocation())
                            .build();
                })
                .sorted((a, b) -> b.getAvailableQuantity().compareTo(a.getAvailableQuantity()))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public StoreRestockResponse restockFromWarehouse(StoreRestockRequest request) {
        log.info("Restocking store {} from warehouse {} - Product {}, Quantity: {}", 
                request.getToStoreId(), request.getFromWarehouseId(), 
                request.getProductId(), request.getQuantity());

        // Get warehouse and store
        Warehouse warehouse = warehouseService.getWarehouseEntityById(request.getFromWarehouseId());
        Store store = storeService.getStoreEntityById(request.getToStoreId());

        // Get warehouse product
        WarehouseProduct warehouseProduct = warehouseProductRepository
                .findByWarehouseAndProductId(warehouse, request.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + request.getProductId() + " not found in warehouse " + request.getFromWarehouseId()));

        // Check if warehouse has enough stock
        if (warehouseProduct.getQuantity() < request.getQuantity()) {
            throw new IllegalArgumentException(
                    String.format("Insufficient stock in warehouse. Available: %d, Requested: %d", 
                            warehouseProduct.getQuantity(), request.getQuantity()));
        }

        // Get or create store inventory
        StoreInventory storeInventory = storeInventoryRepository
                .findByStoreAndProductId(store, request.getProductId())
                .orElse(StoreInventory.builder()
                        .store(store)
                        .productId(request.getProductId())
                        .productName(warehouseProduct.getProductName())
                        .quantity(0)
                        .minStockLevel(warehouseProduct.getMinStockLevel())
                        .build());

        // Update quantities
        String currentUser = getCurrentUsername();
        warehouseProduct.setQuantity(warehouseProduct.getQuantity() - request.getQuantity());
        warehouseProduct.setUpdatedBy(currentUser);
        
        storeInventory.setQuantity(storeInventory.getQuantity() + request.getQuantity());
        storeInventory.setUpdatedBy(currentUser);

        // Save both
        WarehouseProduct savedWarehouseProduct = warehouseProductRepository.save(warehouseProduct);
        StoreInventory savedStoreInventory = storeInventoryRepository.save(storeInventory);

        log.info("Restock completed. Product {} - Warehouse {} remaining: {}, Store {} new stock: {}", 
                request.getProductId(), request.getFromWarehouseId(), savedWarehouseProduct.getQuantity(),
                request.getToStoreId(), savedStoreInventory.getQuantity());

        // Build response
        return StoreRestockResponse.builder()
                .fromWarehouseId(warehouse.getWarehouseId())
                .fromWarehouseName(warehouse.getWarehouseName())
                .toStoreId(store.getStoreId())
                .toStoreName(store.getStoreName())
                .productId(request.getProductId())
                .productName(warehouseProduct.getProductName())
                .quantity(request.getQuantity())
                .warehouseRemainingStock(savedWarehouseProduct.getQuantity())
                .storeNewStock(savedStoreInventory.getQuantity())
                .transferredBy(currentUser)
                .transferredAt(LocalDateTime.now())
                .notes(request.getNotes())
                .build();
    }

    @Override
    @Transactional
    public void deductStock(Long storeId, Long productId, Integer quantity) {
        log.info("Deducting {} units of product {} from store {}", quantity, productId, storeId);

        Store store = storeService.getStoreEntityById(storeId);
        StoreInventory storeInventory = storeInventoryRepository
                .findByStoreAndProductId(store, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in store " + storeId));

        int currentQty = storeInventory.getQuantity() != null ? storeInventory.getQuantity() : 0;
        if (currentQty < quantity) {
            throw new IllegalArgumentException(
                    String.format("Insufficient stock for product %d in store %d. Available: %d, Requested: %d",
                            productId, storeId, currentQty, quantity));
        }

        storeInventory.setQuantity(currentQty - quantity);
        storeInventory.setUpdatedBy("order-system");
        storeInventoryRepository.save(storeInventory);

        log.info("Stock deducted for product {} in store {}. Previous: {}, Deducted: {}, Remaining: {}",
                productId, storeId, currentQty, quantity, currentQty - quantity);
    }

    @Override
    public List<Long> getAllProductIdsWithStock() {
        log.info("Fetching all product IDs with stock across all stores");
        return storeInventoryRepository.findAllProductIdsWithStock();
    }
    
    @Override
    public List<StoreInventoryResponse> getInventoryByProductId(Long productId) {
        log.info("Fetching inventory for product {} across all stores", productId);
        return storeInventoryRepository.findByProductId(productId).stream()
                .map(mapper::toStoreInventoryResponse)
                .collect(Collectors.toList());
    }
}
