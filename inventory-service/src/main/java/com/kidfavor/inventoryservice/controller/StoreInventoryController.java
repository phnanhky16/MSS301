package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ApiResponse;
import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.service.StoreInventoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "Store Inventory", description = "Store inventory management APIs")
public class StoreInventoryController {

    private final StoreInventoryService storeInventoryService;

    @GetMapping("/{storeId}/inventory")
    @Operation(summary = "Get all inventory in a store")
    public ResponseEntity<ApiResponse<List<StoreInventoryResponse>>> getInventoryByStore(@PathVariable Long storeId) {
        List<StoreInventoryResponse> inventory = storeInventoryService.getInventoryByStore(storeId);
        return ResponseEntity.ok(ApiResponse.success("Retrieved store inventory successfully", inventory));
    }

    @GetMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Get specific product inventory in a store")
    public ResponseEntity<ApiResponse<StoreInventoryResponse>> getStoreInventory(
            @PathVariable Long storeId,
            @PathVariable Long productId) {
        StoreInventoryResponse inventory = storeInventoryService.getStoreInventory(storeId, productId);
        return ResponseEntity.ok(ApiResponse.success("Inventory retrieved successfully", inventory));
    }

    @GetMapping("/{storeId}/inventory/{productId}/stock")
    @Operation(summary = "Get available stock for a product in store")
    public ResponseEntity<ApiResponse<Integer>> getAvailableStock(
            @PathVariable Long storeId,
            @PathVariable Long productId) {
        Integer stock = storeInventoryService.getAvailableStock(storeId, productId);
        return ResponseEntity.ok(ApiResponse.success("Stock retrieved successfully", stock));
    }

    @GetMapping("/{storeId}/low-stock")
    @Operation(summary = "Get low stock products in a store")
    public ResponseEntity<ApiResponse<List<StoreInventoryResponse>>> getLowStockProductsByStore(@PathVariable Long storeId) {
        List<StoreInventoryResponse> products = storeInventoryService.getLowStockProductsByStore(storeId);
        return ResponseEntity.ok(ApiResponse.success("Low stock products retrieved successfully", products));
    }

    @PostMapping("/{storeId}/inventory")
    @Operation(summary = "Add or update product inventory in store")
    public ResponseEntity<ApiResponse<StoreInventoryResponse>> addOrUpdateInventory(
            @PathVariable Long storeId,
            @Valid @RequestBody StoreInventoryRequest request) {
        request.setStoreId(storeId);
        StoreInventoryResponse inventory = storeInventoryService.addOrUpdateInventory(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Inventory added/updated successfully", inventory));
    }

    @PutMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Update stock quantity for a product in store")
    public ResponseEntity<ApiResponse<StoreInventoryResponse>> updateStock(
            @PathVariable Long storeId,
            @PathVariable Long productId,
            @Valid @RequestBody StockUpdateRequest request) {
        request.setProductId(productId);
        StoreInventoryResponse inventory = storeInventoryService.updateStock(storeId, request);
        return ResponseEntity.ok(ApiResponse.success("Stock updated successfully", inventory));
    }

    @DeleteMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Remove product from store inventory")
    public ResponseEntity<ApiResponse<Void>> removeInventory(
            @PathVariable Long storeId,
            @PathVariable Long productId) {
        storeInventoryService.removeInventory(storeId, productId);
        return ResponseEntity.ok(ApiResponse.success("Inventory removed successfully", null));
    }
}
