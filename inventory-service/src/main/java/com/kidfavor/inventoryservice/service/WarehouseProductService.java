package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
import com.kidfavor.inventoryservice.exception.InsufficientStockException;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.WarehouseProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WarehouseProductService {

    private final WarehouseProductRepository warehouseProductRepository;
    private final WarehouseService warehouseService;
    private final InventoryMapper mapper;

    public List<WarehouseProductResponse> getProductsByWarehouse(Long warehouseId) {
        log.info("Fetching products for warehouse id: {}", warehouseId);
        return warehouseProductRepository.findByWarehouseId(warehouseId).stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    public WarehouseProductResponse getWarehouseProduct(Long warehouseId, Long productId) {
        log.info("Fetching product {} in warehouse {}", productId, warehouseId);
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        WarehouseProduct wp = warehouseProductRepository.findByWarehouseAndProductId(warehouse, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + productId + " not found in warehouse " + warehouseId));
        return mapper.toWarehouseProductResponse(wp);
    }

    public List<WarehouseProductResponse> getLowStockProducts() {
        log.info("Fetching low stock products in all warehouses");
        return warehouseProductRepository.findLowStockProducts().stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

    public List<WarehouseProductResponse> getLowStockProductsByWarehouse(Long warehouseId) {
        log.info("Fetching low stock products in warehouse: {}", warehouseId);
        return warehouseProductRepository.findLowStockProductsByWarehouse(warehouseId).stream()
                .map(mapper::toWarehouseProductResponse)
                .collect(Collectors.toList());
    }

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
        warehouseProduct.setMinStockLevel(request.getMinStockLevel());
        warehouseProduct.setMaxStockLevel(request.getMaxStockLevel());
        warehouseProduct.setLocationCode(request.getLocationCode());

        WarehouseProduct saved = warehouseProductRepository.save(warehouseProduct);
        log.info("Product {} updated in warehouse {}", request.getProductId(), request.getWarehouseId());
        
        return mapper.toWarehouseProductResponse(saved);
    }

    @Transactional
    public WarehouseProductResponse updateStock(Long warehouseId, StockUpdateRequest request) {
        log.info("Updating stock for product {} in warehouse {}", request.getProductId(), warehouseId);
        
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        WarehouseProduct warehouseProduct = warehouseProductRepository
                .findByWarehouseAndProductId(warehouse, request.getProductId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Product " + request.getProductId() + " not found in warehouse " + warehouseId));

        int newQuantity = warehouseProduct.getQuantity() + request.getQuantityChange();
        
        if (newQuantity < 0) {
            throw new InsufficientStockException(
                    "Insufficient stock for product " + request.getProductId() + 
                    " in warehouse " + warehouseId + ". Available: " + warehouseProduct.getQuantity());
        }

        warehouseProduct.setQuantity(newQuantity);
        WarehouseProduct saved = warehouseProductRepository.save(warehouseProduct);
        
        log.info("Stock updated for product {} in warehouse {}. New quantity: {}", 
                request.getProductId(), warehouseId, newQuantity);
        
        return mapper.toWarehouseProductResponse(saved);
    }

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

    public Integer getAvailableStock(Long warehouseId, Long productId) {
        Warehouse warehouse = warehouseService.getWarehouseEntityById(warehouseId);
        return warehouseProductRepository.findByWarehouseAndProductId(warehouse, productId)
                .map(WarehouseProduct::getQuantity)
                .orElse(0);
    }
}
