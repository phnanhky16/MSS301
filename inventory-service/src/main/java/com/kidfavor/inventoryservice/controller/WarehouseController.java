package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.WarehouseRequest;
import com.kidfavor.inventoryservice.dto.WarehouseResponse;
import com.kidfavor.inventoryservice.service.WarehouseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/warehouses")
@RequiredArgsConstructor
@Tag(name = "Warehouse", description = "Warehouse management APIs")
public class WarehouseController {

    private final WarehouseService warehouseService;

    @GetMapping
    @Operation(summary = "Get all warehouses")
    public ResponseEntity<ResponseWrapper<List<WarehouseResponse>>> getAllWarehouses() {
        List<WarehouseResponse> warehouses = warehouseService.getAllWarehouses();
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved all warehouses successfully", warehouses));
    }

    @GetMapping("/active")
    @Operation(summary = "Get all active warehouses")
    public ResponseEntity<ResponseWrapper<List<WarehouseResponse>>> getActiveWarehouses() {
        List<WarehouseResponse> warehouses = warehouseService.getActiveWarehouses();
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved active warehouses successfully", warehouses));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get warehouse by ID")
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> getWarehouseById(@PathVariable Long id) {
        WarehouseResponse warehouse = warehouseService.getWarehouseById(id);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse retrieved successfully", warehouse));
    }

    @GetMapping("/code/{code}")
    @Operation(summary = "Get warehouse by code")
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> getWarehouseByCode(@PathVariable String code) {
        WarehouseResponse warehouse = warehouseService.getWarehouseByCode(code);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse retrieved successfully", warehouse));
    }

    @PostMapping
    @Operation(summary = "Create new warehouse")
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> createWarehouse(@Valid @RequestBody WarehouseRequest request) {
        WarehouseResponse warehouse = warehouseService.createWarehouse(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ResponseWrapper.created("Warehouse created successfully", warehouse));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update warehouse")
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> updateWarehouse(
            @PathVariable Long id,
            @Valid @RequestBody WarehouseRequest request) {
        WarehouseResponse warehouse = warehouseService.updateWarehouse(id, request);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse updated successfully", warehouse));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete warehouse")
    public ResponseEntity<ResponseWrapper<Void>> deleteWarehouse(@PathVariable Long id) {
        warehouseService.deleteWarehouse(id);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse deleted successfully", null));
    }
}
