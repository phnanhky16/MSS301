package com.kidfavor.productservice.client;

import com.kidfavor.productservice.client.dto.ApiResponseDto;
import com.kidfavor.productservice.client.dto.StoreDto;
import com.kidfavor.productservice.client.dto.StoreInventoryDto;
import com.kidfavor.productservice.config.FeignClientConfig;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

/**
 * Feign client for communicating with Inventory Service.
 * Uses Consul service discovery to locate the inventory-service.
 */
@FeignClient(
        name = "inventory-service",
        configuration = FeignClientConfig.class,
        fallbackFactory = InventoryServiceClientFallbackFactory.class
)
public interface InventoryServiceClient {

    /**
     * Get available stock for a product in a specific store.
     * 
     * @param storeId Store ID
     * @param productId Product ID
     * @return Available stock quantity
     */
    @GetMapping("/api/stores/{storeId}/inventory/{productId}/stock")
    ApiResponseDto<Integer> getAvailableStock(
            @PathVariable("storeId") Long storeId,
            @PathVariable("productId") Long productId
    );

    /**
     * Get full inventory details for a product in a store.
     * 
     * @param storeId Store ID
     * @param productId Product ID
     * @return Store inventory details
     */
    @GetMapping("/api/stores/{storeId}/inventory/{productId}")
    ApiResponseDto<StoreInventoryDto> getStoreInventory(
            @PathVariable("storeId") Long storeId,
            @PathVariable("productId") Long productId
    );

    /**
     * Get all inventory for a product across all stores.
     * 
     * @param productId Product ID
     * @return List of store inventories for the product
     */
    @GetMapping("/api/inventory/product/{productId}")
    ApiResponseDto<List<StoreInventoryDto>> getProductInventoryAllStores(
            @PathVariable("productId") Long productId
    );

    /**
     * Get all active stores.
     * 
     * @return List of active stores
     */
    @GetMapping("/api/stores/active")
    ApiResponseDto<List<StoreDto>> getActiveStores();
    
    /**
     * Get all product IDs that have stock (quantity > 0) in any store.
     * 
     * @return List of product IDs with stock
     */
    @GetMapping("/api/stores/products-with-stock")
    ApiResponseDto<List<Long>> getAllProductIdsWithStock();
}
