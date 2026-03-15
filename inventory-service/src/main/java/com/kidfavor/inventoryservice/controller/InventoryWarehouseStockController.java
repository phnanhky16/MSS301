package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import com.kidfavor.inventoryservice.service.WarehouseProductService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Endpoint to retrieve aggregate stock information for multiple products.
 *
 * This is intentionally exposed under /api/inventory to avoid conflicts with
 * the warehouse-specific API surface.
 */
@RestController
@RequiredArgsConstructor
public class InventoryWarehouseStockController {

    private final WarehouseProductService warehouseProductService;

    @GetMapping("/api/inventory/warehouses/total-stock")
    @Operation(summary = "Get total stock in all warehouses by product IDs")
    public ResponseEntity<ResponseWrapper<Map<Long, Integer>>> getTotalStockForProducts(
            @RequestParam("productIds") List<Long> productIds) {
        Map<Long, Integer> stockMap = warehouseProductService.getTotalStockForProducts(productIds);
        return ResponseEntity.ok(ResponseWrapper.success("Retrieved successfully", stockMap));
    }
}
