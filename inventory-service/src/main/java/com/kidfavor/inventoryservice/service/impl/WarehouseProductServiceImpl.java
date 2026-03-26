package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.dto.WarehouseTransferRequest;
import com.kidfavor.inventoryservice.dto.WarehouseTransferResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
import com.kidfavor.inventoryservice.enums.ProductStockStatus;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.WarehouseProductRepository;
import com.kidfavor.inventoryservice.service.WarehouseProductService;
import com.kidfavor.inventoryservice.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WarehouseProductServiceImpl implements WarehouseProductService {

    private final WarehouseProductRepository warehouseProductRepository;
    private final WarehouseService warehouseService;
    private final InventoryMapper mapper;
    private final com.kidfavor.inventoryservice.client.ProductServiceClient productServiceClient;

    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return "system";
    }

    @Override
    public List<WarehouseProductResponse> getProductsByWarehouse(Long warehouseId) {
        log.info("Fetching products for warehouse id: {}", warehouseId);
        List<WarehouseProduct> products = warehouseProductRepository.findByWarehouseId(warehouseId);
        
        // Identify products with missing names
        List<Long> productsWithMissingNames = products.stream()
                .filter(p -> p.getProductName() == null || p.getProductName().isEmpty())
                .map(WarehouseProduct::getProductId)
                .distinct()
                .collect(Collectors.toList());

        if (!productsWithMissingNames.isEmpty()) {
            log.info("Fetching {} missing product names from Product Service", productsWithMissingNames.size());
            try {
                var response = productServiceClient.getProductsByIds(productsWithMissingNames);
                if (response != null && response.isSuccess() && response.getData() != null) {
                    java.util.Map<Long, String> nameMap = response.getData().stream()
                            .collect(Collectors.toMap(
                                    com.kidfavor.inventoryservice.client.dto.ProductResponseDto::getId,
                                    com.kidfavor.inventoryservice.client.dto.ProductResponseDto::getName,
                                    (existing, replacement) -> existing
                            ));

                    // Update local entities with fetched names (caching)
                    for (WarehouseProduct wp : products) {
                        if ((wp.getProductName() == null || wp.getProductName().isEmpty()) && 
                            nameMap.containsKey(wp.getProductId())) {
                            wp.setProductName(nameMap.get(wp.getProductId()));
                            warehouseProductRepository.save(wp);
                        }
                    }
                }
            } catch (Exception e) {
                log.error("Failed to fetch product names from Product Service: {}", e.getMessage());
            }
        }

        return products.stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public WarehouseProductResponse getWarehouseProduct(Long warehouseId, Long productId) {
        log.info("Fetching product {} in warehouse {}", productId, warehouseId);
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        WarehouseProduct wp = warehouseProductRepository.findByWarehouseAndProductId(warehouse, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in warehouse " + warehouseId));
        return mapper.toWarehouseProductResponse(wp);
    }

    @Override
    public List<WarehouseProductResponse> getLowStockProducts() {
        log.info("Fetching low stock products in all warehouses");
        return warehouseProductRepository.findLowStockProducts().stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getLowStockProductsByWarehouse(Long warehouseId) {
        log.info("Fetching low stock products in warehouse: {}", warehouseId);
        return warehouseProductRepository.findLowStockProductsByWarehouse(warehouseId).stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getOutOfStockProducts() {
        log.info("Fetching out of stock products in all warehouses");
        return warehouseProductRepository.findOutOfStockProducts().stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getOutOfStockProductsByWarehouse(Long warehouseId) {
        log.info("Fetching out of stock products in warehouse: {}", warehouseId);
        return warehouseProductRepository.findOutOfStockProductsByWarehouse(warehouseId).stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getInStockProducts() {
        log.info("Fetching in stock products in all warehouses");
        return warehouseProductRepository.findInStockProducts().stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getInStockProductsByWarehouse(Long warehouseId) {
        log.info("Fetching in stock products in warehouse: {}", warehouseId);
        return warehouseProductRepository.findInStockProductsByWarehouse(warehouseId).stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseProductResponse> getProductsByStatus(ProductStockStatus status) {
        log.info("Fetching products with status: {}", status);
        return switch (status) {
            case OUT_OF_STOCK -> getOutOfStockProducts();
            case LOW_STOCK -> getLowStockProducts();
            case IN_STOCK -> getInStockProducts();
        };
    }

    @Override
    public List<WarehouseProductResponse> getProductsByStatusAndWarehouse(Long warehouseId, ProductStockStatus status) {
        log.info("Fetching products with status {} in warehouse: {}", status, warehouseId);
        return switch (status) {
            case OUT_OF_STOCK -> getOutOfStockProductsByWarehouse(warehouseId);
            case LOW_STOCK -> getLowStockProductsByWarehouse(warehouseId);
            case IN_STOCK -> getInStockProductsByWarehouse(warehouseId);
        };
    }

    @Override
    @Transactional
    public WarehouseProductResponse addOrUpdateProduct(WarehouseProductRequest request) {
        log.info("Adding/updating product {} in warehouse {}", request.getProductId(), request.getWarehouseId());
        
        Warehouse warehouse = warehouseService.getWarehouseEntityById(request.getWarehouseId());
        
        WarehouseProduct warehouseProduct = warehouseProductRepository
                .findByWarehouseAndProductId(warehouse, request.getProductId())
                .orElse(WarehouseProduct.builder()
                        .warehouse(warehouse)
                        .productId(request.getProductId())
                        .build());

        warehouseProduct.setQuantity(request.getQuantity());
        warehouseProduct.setProductName(request.getProductName());
        warehouseProduct.setMinStockLevel(request.getMinStockLevel());
        warehouseProduct.setMaxStockLevel(request.getMaxStockLevel());
        warehouseProduct.setLocationCode(request.getLocationCode());
        warehouseProduct.setUpdatedBy(getCurrentUsername());

        WarehouseProduct saved = warehouseProductRepository.save(warehouseProduct);
        log.info("Product {} updated in warehouse {}", request.getProductId(), request.getWarehouseId());
        
        return mapper.toWarehouseProductResponse(saved);
    }

    @Override
    @Transactional
    public WarehouseProductResponse updateStock(Long warehouseId, StockUpdateRequest request) {
        log.info("Updating stock for product {} in warehouse {}", request.getProductId(), warehouseId);
        
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        WarehouseProduct warehouseProduct = warehouseProductRepository
                .findByWarehouseAndProductId(warehouse, request.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + request.getProductId() + " not found in warehouse " + warehouseId));

        warehouseProduct.setQuantity(request.getQuantity());
        warehouseProduct.setUpdatedBy(getCurrentUsername());
        WarehouseProduct saved = warehouseProductRepository.save(warehouseProduct);
        
        log.info("Stock updated for product {} in warehouse {}. New quantity: {}", 
                request.getProductId(), warehouseId, request.getQuantity());
        
        return mapper.toWarehouseProductResponse(saved);
    }

    @Override
    @Transactional
    public void removeProduct(Long warehouseId, Long productId) {
        log.info("Removing product {} from warehouse {}", productId, warehouseId);
        
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        WarehouseProduct warehouseProduct = warehouseProductRepository
                .findByWarehouseAndProductId(warehouse, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in warehouse " + warehouseId));

        warehouseProductRepository.delete(warehouseProduct);
        log.info("Product {} removed from warehouse {}", productId, warehouseId);
    }

    @Override
    public Integer getAvailableStock(Long warehouseId, Long productId) {
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        return warehouseProductRepository.findByWarehouseAndProductId(warehouse, productId)
                .map(WarehouseProduct::getQuantity)
                .orElse(0);
    }

    @Override
    @Transactional
    public WarehouseTransferResponse transferBetweenWarehouses(WarehouseTransferRequest request) {
        log.info("Transferring {} units of product {} from warehouse {} to warehouse {}", 
                request.getQuantity(), request.getProductId(), 
                request.getFromWarehouseId(), request.getToWarehouseId());

        // Validate warehouses are different
        if (request.getFromWarehouseId().equals(request.getToWarehouseId())) {
            throw new IllegalArgumentException("Source and destination warehouses must be different");
        }

        // Get warehouses
        Warehouse fromWarehouse = warehouseService.getWarehouseEntityById(request.getFromWarehouseId());
        Warehouse toWarehouse = warehouseService.getWarehouseEntityById(request.getToWarehouseId());

        // Get source warehouse product
        WarehouseProduct fromProduct = warehouseProductRepository
                .findByWarehouseAndProductId(fromWarehouse, request.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + request.getProductId() + " not found in source warehouse " + request.getFromWarehouseId()));

        // Check if source has enough stock
        if (fromProduct.getQuantity() < request.getQuantity()) {
            throw new IllegalArgumentException(
                    String.format("Insufficient stock in source warehouse. Available: %d, Requested: %d", 
                            fromProduct.getQuantity(), request.getQuantity()));
        }

        // Get or create destination warehouse product
        WarehouseProduct toProduct = warehouseProductRepository
                .findByWarehouseAndProductId(toWarehouse, request.getProductId())
                .orElse(WarehouseProduct.builder()
                        .warehouse(toWarehouse)
                        .productId(request.getProductId())
                        .productName(fromProduct.getProductName())
                        .quantity(0)
                        .minStockLevel(fromProduct.getMinStockLevel())
                        .maxStockLevel(fromProduct.getMaxStockLevel())
                        .build());

        // Update quantities
        String currentUser = getCurrentUsername();
        fromProduct.setQuantity(fromProduct.getQuantity() - request.getQuantity());
        fromProduct.setUpdatedBy(currentUser);
        
        toProduct.setQuantity(toProduct.getQuantity() + request.getQuantity());
        toProduct.setUpdatedBy(currentUser);

        // Save both products
        WarehouseProduct savedFromProduct = warehouseProductRepository.save(fromProduct);
        WarehouseProduct savedToProduct = warehouseProductRepository.save(toProduct);

        log.info("Transfer completed. Product {} - From warehouse {} remaining: {}, To warehouse {} new stock: {}", 
                request.getProductId(), request.getFromWarehouseId(), savedFromProduct.getQuantity(),
                request.getToWarehouseId(), savedToProduct.getQuantity());

        // Build response
        return WarehouseTransferResponse.builder()
                .fromWarehouseId(fromWarehouse.getWarehouseId())
                .fromWarehouseName(fromWarehouse.getWarehouseName())
                .toWarehouseId(toWarehouse.getWarehouseId())
                .toWarehouseName(toWarehouse.getWarehouseName())
                .productId(request.getProductId())
                .productName(fromProduct.getProductName())
                .quantity(request.getQuantity())
                .fromWarehouseRemainingStock(savedFromProduct.getQuantity())
                .toWarehouseNewStock(savedToProduct.getQuantity())
                .transferredBy(currentUser)
                .transferredAt(LocalDateTime.now())
                .notes(request.getNotes())
                .build();
    }

    @Override
    public java.util.Map<Long, Integer> getTotalStockForProducts(List<Long> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return java.util.Collections.emptyMap();
        }
        List<Object[]> results = warehouseProductRepository.findTotalStockByProductIds(productIds);
        java.util.Map<Long, Integer> map = new java.util.HashMap<>();
        for (Object[] row : results) {
            Long productId = (Long) row[0];
            Number sum = (Number) row[1];
            map.put(productId, sum != null ? sum.intValue() : 0);
        }
        return map;
    }

    @Override
    public Integer getTotalStockForProduct(Long productId) {
        Integer total = warehouseProductRepository.findTotalStockByProductId(productId);
        return total != null ? total : 0;
    }
}
