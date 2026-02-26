package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
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

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WarehouseProductServiceImpl implements WarehouseProductService {

    private final WarehouseProductRepository warehouseProductRepository;
    private final WarehouseService warehouseService;
    private final InventoryMapper mapper;

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
        return warehouseProductRepository.findByWarehouseId(warehouseId).stream()
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
}
