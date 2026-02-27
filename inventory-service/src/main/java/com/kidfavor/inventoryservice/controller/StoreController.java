package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.dto.StoreRequest;
import com.kidfavor.inventoryservice.dto.StoreResponse;
import com.kidfavor.inventoryservice.service.StoreService;
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
@Tag(name = "Store", description = "Store management APIs")
public class StoreController {

    private final StoreService storeService;

    @GetMapping
    @Operation(summary = "Get all stores", description = "Retrieve all stores")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved stores")
    })
    public ResponseEntity<ResponseWrapper<List<StoreResponse>>> getAllStores() {
        List<StoreResponse> stores = storeService.getAllStores();
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved all stores successfully", stores));
    }

    @GetMapping("/active")
    @Operation(summary = "Get all active stores")
    public ResponseEntity<ResponseWrapper<List<StoreResponse>>> getActiveStores() {
        List<StoreResponse> stores = storeService.getActiveStores();
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved active stores successfully", stores));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get store by ID", description = "Retrieve a specific store by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Store found"),
        @ApiResponse(responseCode = "404", description = "Store not found")
    })
    public ResponseEntity<ResponseWrapper<StoreResponse>> getStoreById(
            @Parameter(description = "Store ID") @PathVariable Long id) {
        StoreResponse store = storeService.getStoreById(id);
        return ResponseEntity.ok(ResponseWrapper.success("Store retrieved successfully", store));
    }

    @GetMapping("/code/{code}")
    @Operation(summary = "Get store by code")
    public ResponseEntity<ResponseWrapper<StoreResponse>> getStoreByCode(@PathVariable String code) {
        StoreResponse store = storeService.getStoreByCode(code);
        return ResponseEntity.ok(ResponseWrapper.success("Store retrieved successfully", store));
    }

    @PostMapping
    @Operation(summary = "Create new store", description = "Create a new store")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Store created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input"),
        @ApiResponse(responseCode = "409", description = "Store already exists")
    })
    public ResponseEntity<ResponseWrapper<StoreResponse>> createStore(@Valid @RequestBody StoreRequest request) {
        StoreResponse store = storeService.createStore(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ResponseWrapper.created("Store created successfully", store));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update store", description = "Update an existing store")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Store updated successfully"),
        @ApiResponse(responseCode = "404", description = "Store not found"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<StoreResponse>> updateStore(
            @Parameter(description = "Store ID") @PathVariable Long id,
            @Valid @RequestBody StoreRequest request) {
        StoreResponse store = storeService.updateStore(id, request);
        return ResponseEntity.ok(ResponseWrapper.success("Store updated successfully", store));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete store", description = "Delete a store by ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Store deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Store not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> deleteStore(
            @Parameter(description = "Store ID") @PathVariable Long id) {
        storeService.deleteStore(id);
        return ResponseEntity.ok(ResponseWrapper.success("Store deleted successfully", null));
    }
}
