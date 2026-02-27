package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.WarehouseRequest;
import com.kidfavor.inventoryservice.dto.WarehouseResponse;
import com.kidfavor.inventoryservice.service.WarehouseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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
    @Operation(summary = "Get all warehouses", description = "Retrieve all warehouses")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved warehouses")
    })
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
    @Operation(summary = "Get warehouse by ID", description = "Retrieve a specific warehouse by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Warehouse found"),
        @ApiResponse(responseCode = "404", description = "Warehouse not found")
    })
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> getWarehouseById(
            @Parameter(description = "Warehouse ID") @PathVariable Long id) {
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
    @Operation(summary = "Create new warehouse", description = "Create a new warehouse")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Warehouse created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input"),
        @ApiResponse(responseCode = "409", description = "Warehouse already exists")
    })
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> createWarehouse(@Valid @RequestBody WarehouseRequest request) {
        WarehouseResponse warehouse = warehouseService.createWarehouse(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ResponseWrapper.created("Warehouse created successfully", warehouse));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update warehouse", description = "Update an existing warehouse")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Warehouse updated successfully"),
        @ApiResponse(responseCode = "404", description = "Warehouse not found"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<WarehouseResponse>> updateWarehouse(
            @Parameter(description = "Warehouse ID") @PathVariable Long id,
            @Valid @RequestBody WarehouseRequest request) {
        WarehouseResponse warehouse = warehouseService.updateWarehouse(id, request);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse updated successfully", warehouse));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete warehouse", description = "Delete a warehouse by ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Warehouse deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Warehouse not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> deleteWarehouse(
            @Parameter(description = "Warehouse ID") @PathVariable Long id) {
        warehouseService.deleteWarehouse(id);
        return ResponseEntity.ok(ResponseWrapper.success("Warehouse deleted successfully", null));
    }
}
