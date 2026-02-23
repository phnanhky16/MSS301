package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ApiResponse;
import com.kidfavor.inventoryservice.dto.StoreRequest;
import com.kidfavor.inventoryservice.dto.StoreResponse;
import com.kidfavor.inventoryservice.service.StoreService;
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
@Tag(name = "Store", description = "Store management APIs")
public class StoreController {

    private final StoreService storeService;

    @GetMapping
    @Operation(summary = "Get all stores")
    public ResponseEntity<ApiResponse<List<StoreResponse>>> getAllStores() {
        List<StoreResponse> stores = storeService.getAllStores();
        return ResponseEntity.ok(ApiResponse.success("Retrieved all stores successfully", stores));
    }

    @GetMapping("/active")
    @Operation(summary = "Get all active stores")
    public ResponseEntity<ApiResponse<List<StoreResponse>>> getActiveStores() {
        List<StoreResponse> stores = storeService.getActiveStores();
        return ResponseEntity.ok(ApiResponse.success("Retrieved active stores successfully", stores));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get store by ID")
    public ResponseEntity<ApiResponse<StoreResponse>> getStoreById(@PathVariable Long id) {
        StoreResponse store = storeService.getStoreById(id);
        return ResponseEntity.ok(ApiResponse.success("Store retrieved successfully", store));
    }

    @GetMapping("/code/{code}")
    @Operation(summary = "Get store by code")
    public ResponseEntity<ApiResponse<StoreResponse>> getStoreByCode(@PathVariable String code) {
        StoreResponse store = storeService.getStoreByCode(code);
        return ResponseEntity.ok(ApiResponse.success("Store retrieved successfully", store));
    }

    @PostMapping
    @Operation(summary = "Create new store")
    public ResponseEntity<ApiResponse<StoreResponse>> createStore(@Valid @RequestBody StoreRequest request) {
        StoreResponse store = storeService.createStore(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Store created successfully", store));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update store")
    public ResponseEntity<ApiResponse<StoreResponse>> updateStore(
            @PathVariable Long id,
            @Valid @RequestBody StoreRequest request) {
        StoreResponse store = storeService.updateStore(id, request);
        return ResponseEntity.ok(ApiResponse.success("Store updated successfully", store));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete store")
    public ResponseEntity<ApiResponse<Void>> deleteStore(@PathVariable Long id) {
        storeService.deleteStore(id);
        return ResponseEntity.ok(ApiResponse.success("Store deleted successfully", null));
    }
}
