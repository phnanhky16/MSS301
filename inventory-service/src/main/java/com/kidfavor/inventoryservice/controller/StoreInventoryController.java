package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.StockUpdateRequest;
import com.kidfavor.inventoryservice.dto.StoreAvailabilityResponse;
import com.kidfavor.inventoryservice.dto.StoreInventoryRequest;
import com.kidfavor.inventoryservice.dto.StoreInventoryResponse;
import com.kidfavor.inventoryservice.dto.StoreRestockRequest;
import com.kidfavor.inventoryservice.dto.StoreRestockResponse;
import com.kidfavor.inventoryservice.enums.ProductStockStatus;
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

    @GetMapping("/{storeId}/out-of-stock")
    @Operation(summary = "Get out of stock products in a store")
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getOutOfStockProductsByStore(@PathVariable Long storeId) {
        List<StoreInventoryResponse> products = storeInventoryService.getOutOfStockProductsByStore(storeId);
        return ResponseEntity.ok(ResponseWrapper.success("Out of stock products retrieved successfully", products));
    }

    @GetMapping("/{storeId}/in-stock")
    @Operation(summary = "Get in stock products in a store")
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getInStockProductsByStore(@PathVariable Long storeId) {
        List<StoreInventoryResponse> products = storeInventoryService.getInStockProductsByStore(storeId);
        return ResponseEntity.ok(ResponseWrapper.success("In stock products retrieved successfully", products));
    }

    @GetMapping("/{storeId}/inventory/status/{status}")
    @Operation(summary = "Get products by stock status in a store", description = "Retrieve products by status: OUT_OF_STOCK, LOW_STOCK, or IN_STOCK")
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getProductsByStatus(
            @Parameter(description = "Store ID") @PathVariable Long storeId,
            @Parameter(description = "Stock status (OUT_OF_STOCK, LOW_STOCK, IN_STOCK)") @PathVariable ProductStockStatus status) {
        List<StoreInventoryResponse> products = storeInventoryService.getProductsByStatusAndStore(storeId, status);
        return ResponseEntity.ok(ResponseWrapper.success("Products with status " + status + " retrieved successfully", products));
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

    @GetMapping("/availability")
    @Operation(summary = "Check which stores have a product in stock",
               description = "Find all stores that have a specific product and check if they have enough quantity. Returns stores sorted by: 1. Has enough stock first, 2. Available quantity descending")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Store availability retrieved successfully")
    })
    public ResponseEntity<ResponseWrapper<List<StoreAvailabilityResponse>>> checkStoreAvailability(
            @Parameter(description = "Product ID to check", required = true) 
            @RequestParam Long productId,
            @Parameter(description = "Required quantity", required = true) 
            @RequestParam Integer requiredQuantity) {
        List<StoreAvailabilityResponse> availability = storeInventoryService.checkStoreAvailability(productId, requiredQuantity);
        return ResponseEntity.ok(ResponseWrapper.success(
                String.format("Found %d store(s) with product %d", availability.size(), productId), 
                availability));
    }

    @PostMapping("/restock")
    @Operation(summary = "Restock store from warehouse", 
               description = "Transfer products from warehouse to store. This will decrease warehouse stock and increase store stock.")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Restock completed successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request or insufficient stock"),
        @ApiResponse(responseCode = "404", description = "Warehouse, store, or product not found")
    })
    public ResponseEntity<ResponseWrapper<StoreRestockResponse>> restockFromWarehouse(
            @Valid @RequestBody StoreRestockRequest request) {
        StoreRestockResponse response = storeInventoryService.restockFromWarehouse(request);
        return ResponseEntity.ok(ResponseWrapper.success("Store restocked successfully", response));
    }
    
    @GetMapping("/products-with-stock")
    @Operation(summary = "Get all product IDs with stock", 
               description = "Retrieve list of all product IDs that have stock (quantity > 0) in any store")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved product IDs")
    })
    public ResponseEntity<ResponseWrapper<List<Long>>> getAllProductIdsWithStock() {
        List<Long> productIds = storeInventoryService.getAllProductIdsWithStock();
        return ResponseEntity.ok(ResponseWrapper.success(
                String.format("Found %d products with stock", productIds.size()), 
                productIds));
    }
    
    @GetMapping("/inventory/product/{productId}")
    @Operation(summary = "Get inventory for product across all stores", 
               description = "Retrieve inventory information for a specific product in all stores")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved product inventory")
    })
    public ResponseEntity<ResponseWrapper<List<StoreInventoryResponse>>> getInventoryByProductId(
            @Parameter(description = "Product ID") @PathVariable Long productId) {
        List<StoreInventoryResponse> inventories = storeInventoryService.getInventoryByProductId(productId);
        return ResponseEntity.ok(ResponseWrapper.success(
                String.format("Found inventory in %d store(s) for product %d", inventories.size(), productId), 
                inventories));
    }
}
