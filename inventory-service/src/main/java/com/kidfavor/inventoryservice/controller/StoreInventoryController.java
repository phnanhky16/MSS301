package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.service.StoreInventoryService;
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
@RequestMapping("/api/stores")
@RequiredArgsConstructor
@Tag(name = "Store Inventory", description = "Store inventory management APIs")
public class StoreInventoryController {

    private final StoreInventoryService storeInventoryService;

    @GetMapping("/{storeId}/inventory")
    @Operation(summary = "Get all inventory in a store", description = "Retrieve all product inventory for a specific store")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved inventory")
    })
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getInventoryByStore(
            @Parameter(description = "Store ID") @PathVariable Long storeId) {
        List<StoreInventoryResponse> inventory = storeInventoryService.getInventoryByStore(storeId);
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved store inventory successfully", inventory));
    }

    @GetMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Get specific product inventory in a store", description = "Retrieve inventory for a specific product in a store")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Inventory found"),
        @ApiResponse(responseCode = "404", description = "Inventory not found")
    })
    public ResponseEntity<ResponseWrapper<StoreInventoryResponse>> getStoreInventory(
            @Parameter(description = "Store ID") @PathVariable Long storeId,
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        StoreInventoryResponse inventory = storeInventoryService.getStoreInventory(storeId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Inventory retrieved successfully", inventory));
    }

    @GetMapping("/{storeId}/inventory/{productId}/stock")
    @Operation(summary = "Get available stock for a product in store")
    public ResponseEntity<ResponseWrapper<Integer>> getAvailableStock(
            @PathVariable Long storeId,
            @PathVariable Long productId) {
        Integer stock = storeInventoryService.getAvailableStock(storeId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Stock retrieved successfully", stock));
    }

    @GetMapping("/{storeId}/low-stock")
    @Operation(summary = "Get low stock products in a store")
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getLowStockProductsByStore(@PathVariable Long storeId) {
        List<StoreInventoryResponse> products = storeInventoryService.getLowStockProductsByStore(storeId);
        return ResponseEntity.ok(ResponseWrapper.success("Low stock products retrieved successfully", products));
    }

    @PostMapping("/{storeId}/inventory")
    @Operation(summary = "Add or update product inventory in store", description = "Add a new product to inventory or update existing inventory")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Inventory created/updated successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input"),
        @ApiResponse(responseCode = "404", description = "Store or product not found")
    })
    public ResponseEntity<ResponseWrapper<StoreInventoryResponse>> addOrUpdateInventory(
            @Parameter(description = "Store ID") @PathVariable Long storeId,
            @Valid @RequestBody StoreInventoryRequest request) {
        request.setStoreId(storeId);
        StoreInventoryResponse inventory = storeInventoryService.addOrUpdateInventory(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ResponseWrapper.created("Inventory added/updated successfully", inventory));
    }

    @PutMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Update stock quantity for a product in store", description = "Set the stock quantity to a specific value (not incremental)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Stock updated successfully"),
        @ApiResponse(responseCode = "404", description = "Inventory not found"),
        @ApiResponse(responseCode = "400", description = "Invalid quantity (must be >= 0)")
    })
    public ResponseEntity<ResponseWrapper<StoreInventoryResponse>> updateStock(
            @Parameter(description = "Store ID") @PathVariable Long storeId,
            @Parameter(description = "Product ID") @PathVariable Long productId,
            @Valid @RequestBody StockUpdateRequest request) {
        request.setProductId(productId);
        StoreInventoryResponse inventory = storeInventoryService.updateStock(storeId, request);
        return ResponseEntity.ok(ResponseWrapper.success("Stock updated successfully", inventory));
    }

    @DeleteMapping("/{storeId}/inventory/{productId}")
    @Operation(summary = "Remove product from store inventory", description = "Remove a product from the store's inventory")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Inventory removed successfully"),
        @ApiResponse(responseCode = "404", description = "Inventory not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> removeInventory(
            @Parameter(description = "Store ID") @PathVariable Long storeId,
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        storeInventoryService.removeInventory(storeId, productId);
        return ResponseEntity.ok(ResponseWrapper.success("Inventory removed successfully", null));
    }
}
