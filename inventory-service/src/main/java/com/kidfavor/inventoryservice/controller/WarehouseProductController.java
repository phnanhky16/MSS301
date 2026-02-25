package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductRequest;
import com.kidfavor.inventoryservice.dto.WarehouseProductResponse;
import com.kidfavor.inventoryservice.service.WarehouseProductService;
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
@Tag(name = "Warehouse Inventory", description = "Warehouse inventory management APIs")
public class WarehouseProductController {

    private final WarehouseProductService warehouseProductService;

    @GetMapping("/{warehouseId}/products")
    @Operation(summary = "Get all products in a warehouse", description = "Retrieve all products stored in a specific warehouse")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved products")
    })
    public ResponseEntity<ResponseWrapper<List<WarehouseProductResponse>>> getProductsByWarehouse(
            @Parameter(description = "Warehouse ID") @PathVariable Long warehouseId) {
        List<WarehouseProductResponse> products = warehouseProductService.getProductsByWarehouse(warehouseId);
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved warehouse products successfully", products));
    }

    @GetMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Get specific product in a warehouse", description = "Retrieve a specific product from warehouse")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product found"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ResponseWrapper<WarehouseProductResponse>> getWarehouseProduct(
            @Parameter(description = "Warehouse ID") @PathVariable Long warehouseId,
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        WarehouseProductResponse product = warehouseProductService.getWarehouseProduct(warehouseId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Product retrieved successfully", product));
    }

    @GetMapping("/{warehouseId}/products/{productId}/stock")
    @Operation(summary = "Get available stock for a product in warehouse")
    public ResponseEntity<ResponseWrapper<Integer>> getAvailableStock(
            @PathVariable Long warehouseId,
            @PathVariable Long productId) {
        Integer stock = warehouseProductService.getAvailableStock(warehouseId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Stock retrieved successfully", stock));
    }

    @GetMapping("/{warehouseId}/low-stock")
    @Operation(summary = "Get low stock products in a warehouse")
    public ResponseEntity<ResponseWrapper<List<WarehouseProductResponse>>> getLowStockProductsByWarehouse(@PathVariable Long warehouseId) {
        List<WarehouseProductResponse> products = warehouseProductService.getLowStockProductsByWarehouse(warehouseId);
        return ResponseEntity.ok(ResponseWrapper.success("Low stock products retrieved successfully", products));
    }

    @PostMapping("/{warehouseId}/products")
    @Operation(summary = "Add or update product in warehouse", description = "Add a new product to warehouse or update existing stock")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Product added/updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input"),
        @ApiResponse(responseCode = "404", description = "Warehouse or product not found")
    })
    public ResponseEntity<ResponseWrapper<WarehouseProductResponse>> addOrUpdateProduct(
            @Parameter(description = "Warehouse ID") @PathVariable Long warehouseId,
            @Valid @RequestBody WarehouseProductRequest request) {
        request.setWarehouseId(warehouseId);
        WarehouseProductResponse product = warehouseProductService.addOrUpdateProduct(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ResponseWrapper.created("Product added/updated successfully", product));
    }

    @PutMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Update stock quantity for a product in warehouse", description = "Update the stock quantity for a specific product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Stock updated successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found"),
        @ApiResponse(responseCode = "400", description = "Invalid stock operation")
    })
    public ResponseEntity<ResponseWrapper<WarehouseProductResponse>> updateStock(
            @Parameter(description = "Warehouse ID") @PathVariable Long warehouseId,
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Valid @RequestBody StockUpdateRequest request) {
        request.setProductId(productId);
        WarehouseProductResponse product = warehouseProductService.updateStock(warehouseId, request);
        return ResponseEntity.ok(ResponseWrapper.success("Stock updated successfully", product));
    }

    @DeleteMapping("/{warehouseId}/products/{productId}")
    @Operation(summary = "Remove product from warehouse", description = "Remove a product from the warehouse")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product removed successfully"),
        @ApiResponse(responseCode = "404", description = "Product not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> removeProduct(
            @Parameter(description = "Warehouse ID") @PathVariable Long warehouseId,
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        warehouseProductService.removeProduct(warehouseId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Product removed successfully", null));
    }
}
