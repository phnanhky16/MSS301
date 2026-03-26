package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.WarehouseRequest;
import com.kidfavor.inventoryservice.dto.WarehouseResponse;
import com.kidfavor.inventoryservice.dto.WarehouseStatsResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.exception.DuplicateResourceException;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.WarehouseProductRepository;
import com.kidfavor.inventoryservice.repository.WarehouseRepository;
import com.kidfavor.inventoryservice.service.WarehouseService;
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
public class WarehouseServiceImpl implements WarehouseService {

    private final WarehouseRepository warehouseRepository;
    private final WarehouseProductRepository warehouseProductRepository;
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
    public List<WarehouseResponse> getAllWarehouses() {
        log.info("Fetching all warehouses");
        return warehouseRepository.findAll().stream()
                .map(mapper::toWarehouseResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<WarehouseResponse> getActiveWarehouses() {
        log.info("Fetching active warehouses");
        return warehouseRepository.findByIsActive(true).stream()
                .map(mapper::toWarehouseResponse)
                .collect(Collectors.toList());
    }

    @Override
    public WarehouseResponse getWarehouseById(Long id) {
        log.info("Fetching warehouse with id: {}", id);
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
        return mapper.toWarehouseResponse(warehouse);
    }

    @Override
    public WarehouseResponse getWarehouseByCode(String code) {
        log.info("Fetching warehouse with code: {}", code);
        Warehouse warehouse = warehouseRepository.findByWarehouseCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with code: " + code));
        return mapper.toWarehouseResponse(warehouse);
    }

    @Override
    @Transactional
    public WarehouseResponse createWarehouse(WarehouseRequest request) {
        log.info("Creating new warehouse with code: {}", request.getWarehouseCode());
        
        if (warehouseRepository.existsByWarehouseCode(request.getWarehouseCode())) {
            throw new DuplicateResourceException("Warehouse already exists with code: " + request.getWarehouseCode());
        }

        Warehouse warehouse = mapper.toWarehouse(request);
        
        if (request.getLatitude() == null || request.getLongitude() == null) {
            LocationDTO location = geocodingService.geocodeAddress(request.getAddress(), request.getCity(), request.getDistrict());
            if (location != null && location.getLatitude() != null && location.getLongitude() != null) {
                warehouse.setLatitude(location.getLatitude());
                warehouse.setLongitude(location.getLongitude());
            }
        }
        
        Warehouse savedWarehouse = warehouseRepository.save(warehouse);
        log.info("Warehouse created successfully with id: {}", savedWarehouse.getWarehouseId());
        
        return mapper.toWarehouseResponse(savedWarehouse);
    }

    @Override
    @Transactional
    public WarehouseResponse updateWarehouse(Long id, WarehouseRequest request) {
        log.info("Updating warehouse with id: {}", id);
        
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));

        // Check if code is being changed to an existing code
        if (!warehouse.getWarehouseCode().equals(request.getWarehouseCode()) &&
            warehouseRepository.existsByWarehouseCode(request.getWarehouseCode())) {
            throw new DuplicateResourceException("Warehouse already exists with code: " + request.getWarehouseCode());
        }

        warehouse.setWarehouseCode(request.getWarehouseCode());
        warehouse.setWarehouseName(request.getWarehouseName());
        warehouse.setAddress(request.getAddress());
        warehouse.setCity(request.getCity());
        warehouse.setDistrict(request.getDistrict());
        warehouse.setWard(request.getWard());
        warehouse.setPhone(request.getPhone());
        warehouse.setManagerName(request.getManagerName());
        warehouse.setCapacity(request.getCapacity());
        warehouse.setWarehouseType(request.getWarehouseType());
        warehouse.setIsActive(request.getIsActive());
        
        if (request.getLatitude() != null && request.getLongitude() != null) {
            warehouse.setLatitude(request.getLatitude());
            warehouse.setLongitude(request.getLongitude());
        } else if (!request.getAddress().equals(warehouse.getAddress()) || !request.getCity().equals(warehouse.getCity()) || !request.getDistrict().equals(warehouse.getDistrict())) {
            // Address changed, update coordinates
            LocationDTO location = geocodingService.geocodeAddress(request.getAddress(), request.getCity(), request.getDistrict());
            if (location != null && location.getLatitude() != null && location.getLongitude() != null) {
                warehouse.setLatitude(location.getLatitude());
                warehouse.setLongitude(location.getLongitude());
            }
        }

        warehouse.setUpdatedBy(getCurrentUsername());

        Warehouse updatedWarehouse = warehouseRepository.save(warehouse);
        log.info("Warehouse updated successfully with id: {}", id);
        
        return mapper.toWarehouseResponse(updatedWarehouse);
    }

    @Override
    @Transactional
    public void deleteWarehouse(Long id) {
        log.info("Soft deleting warehouse with id: {}", id);
        
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
        
        warehouse.setIsActive(false);
        warehouseRepository.save(warehouse);
        log.info("Warehouse soft deleted (deactivated) successfully with id: {}", id);
    }

    @Override
    public Warehouse getWarehouseEntityById(Long id) {
        return warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
    }

    @Override
    public WarehouseStatsResponse getWarehouseStats() {
        log.info("Fetching warehouse statistics for dashboard");
        long totalWarehouses = warehouseRepository.count();
        long activeWarehouses = warehouseRepository.findByIsActive(true).size();
        long totalProducts = warehouseProductRepository.countDistinctProducts();
        Long totalStock = warehouseProductRepository.sumTotalStockQuantity();
        long lowStockCount = warehouseProductRepository.countLowStockItems();

        return WarehouseStatsResponse.builder()
                .totalWarehouses(totalWarehouses)
                .activeWarehouses(activeWarehouses)
                .totalProducts(totalProducts)
                .totalStockQuantity(totalStock != null ? totalStock : 0)
                .lowStockItemsCount(lowStockCount)
                .build();
    }
}
