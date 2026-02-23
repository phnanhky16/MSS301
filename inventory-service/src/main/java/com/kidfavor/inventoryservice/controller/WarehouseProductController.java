package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ApiResponse;
import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.service.WarehouseProductService;
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
@Tag(name = "Warehouse Inventory", description = "Warehouse inventory management APIs")
public class WarehouseProductController {

    private final WarehouseProductService warehouseProductService;

    @GetMapping("/{warehouseId}/products")
    @Operation(summary = "Get all products in a warehouse")
    public ResponseEntity<ApiResponse<List<WarehouseProductResponse>>> getProductsByWarehouse(@PathVariable Long warehouseId) {
        List<WarehouseProductResponse> products = warehouseProductService.getProductsByWarehouse(warehouseId);
        return ResponseEntity.ok(ApiResponse.success("Retrieved warehouse products successfully", products));
    }

    @GetMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Get specific product in a warehouse")
    public ResponseEntity<ApiResponse<WarehouseProductResponse>> getWarehouseProduct(
            @PathVariable Long warehouseId,
            @PathVariable Long productId) {
        WarehouseProductResponse product = warehouseProductService.getWarehouseProduct(warehouseId, productId);
        return ResponseEntity.ok(ApiResponse.success("Product retrieved successfully", product));
    }

    @GetMapping("/{warehouseId}/products/{productId}/stock")
    @Operation(summary = "Get available stock for a product in warehouse")
    public ResponseEntity<ApiResponse<Integer>> getAvailableStock(
            @PathVariable Long warehouseId,
            @PathVariable Long productId) {
        Integer stock = warehouseProductService.getAvailableStock(warehouseId, productId);
        return ResponseEntity.ok(ApiResponse.success("Stock retrieved successfully", stock));
    }

    @GetMapping("/{warehouseId}/low-stock")
    @Operation(summary = "Get low stock products in a warehouse")
    public ResponseEntity<ApiResponse<List<WarehouseProductResponse>>> getLowStockProductsByWarehouse(@PathVariable Long warehouseId) {
        List<WarehouseProductResponse> products = warehouseProductService.getLowStockProductsByWarehouse(warehouseId);
        return ResponseEntity.ok(ApiResponse.success("Low stock products retrieved successfully", products));
    }

    @PostMapping("/{warehouseId}/products")
    @Operation(summary = "Add or update product in warehouse")
    public ResponseEntity<ApiResponse<WarehouseProductResponse>> addOrUpdateProduct(
            @PathVariable Long warehouseId,
            @Valid @RequestBody WarehouseProductRequest request) {
        request.setWarehouseId(warehouseId);
        WarehouseProductResponse product = warehouseProductService.addOrUpdateProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Product added/updated successfully", product));
    }

    @PutMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Update stock quantity for a product in warehouse")
    public ResponseEntity<ApiResponse<WarehouseProductResponse>> updateStock(
            @PathVariable Long warehouseId,
            @PathVariable Long productId,
            @Valid @RequestBody StockUpdateRequest request) {
        request.setProductId(productId);
        WarehouseProductResponse product = warehouseProductService.updateStock(warehouseId, request);
        return ResponseEntity.ok(ApiResponse.success("Stock updated successfully", product));
    }

    @DeleteMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Remove product from warehouse")
    public ResponseEntity<ApiResponse<Void>> removeProduct(
            @PathVariable Long warehouseId,
            @PathVariable Long productId) {
        warehouseProductService.removeProduct(warehouseId, productId);
        return ResponseEntity.ok(ApiResponse.success("Product removed successfully", null));
    }
}
