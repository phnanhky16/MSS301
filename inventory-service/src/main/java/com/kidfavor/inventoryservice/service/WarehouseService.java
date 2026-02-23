package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.WarehouseRequest;
import com.kidfavor.inventoryservice.dto.WarehouseResponse;
import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.exception.DuplicateResourceException;
import com.kidfavor.inventoryservice.exception.ResourceNotFoundException;
import com.kidfavor.inventoryservice.mapper.InventoryMapper;
import com.kidfavor.inventoryservice.repository.WarehouseRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class WarehouseService {

    private final WarehouseRepository warehouseRepository;
    private final InventoryMapper mapper;

    public List<WarehouseResponse> getAllWarehouses() {
        log.info("Fetching all warehouses");
        return warehouseRepository.findAll().stream()
                .map(mapper::toWarehouseResponse)
                .collect(Collectors.toList());
    }

    public List<WarehouseResponse> getActiveWarehouses() {
        log.info("Fetching active warehouses");
        return warehouseRepository.findByIsActive(true).stream()
                .map(mapper::toWarehouseResponse)
                .collect(Collectors.toList());
    }

    public WarehouseResponse getWarehouseById(Long id) {
        log.info("Fetching warehouse with id: {}", id);
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
        return mapper.toWarehouseResponse(warehouse);
    }

    public WarehouseResponse getWarehouseByCode(String code) {
        log.info("Fetching warehouse with code: {}", code);
        Warehouse warehouse = warehouseRepository.findByWarehouseCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with code: " + code));
        return mapper.toWarehouseResponse(warehouse);
    }

    @Transactional
    public WarehouseResponse createWarehouse(WarehouseRequest request) {
        log.info("Creating new warehouse with code: {}", request.getWarehouseCode());
        
        if (warehouseRepository.existsByWarehouseCode(request.getWarehouseCode())) {
            throw new DuplicateResourceException("Warehouse already exists with code: " + request.getWarehouseCode());
        }

        Warehouse warehouse = mapper.toWarehouse(request);
        Warehouse savedWarehouse = warehouseRepository.save(warehouse);
        log.info("Warehouse created successfully with id: {}", savedWarehouse.getWarehouseId());
        
        return mapper.toWarehouseResponse(savedWarehouse);
    }

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

        Warehouse updatedWarehouse = warehouseRepository.save(warehouse);
        log.info("Warehouse updated successfully with id: {}", id);
        
        return mapper.toWarehouseResponse(updatedWarehouse);
    }

    @Transactional
    public void deleteWarehouse(Long id) {
        log.info("Deleting warehouse with id: {}", id);
        
        Warehouse warehouse = warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
        
        warehouseRepository.delete(warehouse);
        log.info("Warehouse deleted successfully with id: {}", id);
    }

    public Warehouse getWarehouseEntityById(Long id) {
        return warehouseRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Warehouse not found with id: " + id));
    }
}
