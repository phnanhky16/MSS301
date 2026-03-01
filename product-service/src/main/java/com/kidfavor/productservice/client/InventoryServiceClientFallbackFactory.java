package com.kidfavor.productservice.client;

import com.kidfavor.productservice.client.dto.ApiResponseDto;
import com.kidfavor.productservice.client.dto.StoreDto;
import com.kidfavor.productservice.client.dto.StoreInventoryDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

/**
 * Fallback factory for InventoryServiceClient.
 * Provides graceful degradation when inventory service is unavailable.
 */
@Component
@Slf4j
public class InventoryServiceClientFallbackFactory implements FallbackFactory<InventoryServiceClient> {

    @Override
    public InventoryServiceClient create(Throwable cause) {
        log.error("Inventory Service is unavailable. Cause: {}", cause.getMessage());
        
        return new InventoryServiceClient() {
            
            @Override
            public ApiResponseDto<Integer> getAvailableStock(Long storeId, Long productId) {
                log.warn("Fallback: getAvailableStock for productId={}, storeId={}", productId, storeId);
                return ApiResponseDto.<Integer>builder()
                        .timestamp(LocalDateTime.now())
                        .status(503)
                        .message("Inventory service unavailable. Stock information not available.")
                        .data(0) // Return 0 stock as safe default
                        .build();
            }

            @Override
            public ApiResponseDto<StoreInventoryDto> getStoreInventory(Long storeId, Long productId) {
                log.warn("Fallback: getStoreInventory for productId={}, storeId={}", productId, storeId);
                return ApiResponseDto.<StoreInventoryDto>builder()
                        .timestamp(LocalDateTime.now())
                        .status(503)
                        .message("Inventory service unavailable. Inventory details not available.")
                        .data(null)
                        .build();
            }

            @Override
            public ApiResponseDto<List<StoreInventoryDto>> getProductInventoryAllStores(Long productId) {
                log.warn("Fallback: getProductInventoryAllStores for productId={}", productId);
                return ApiResponseDto.<List<StoreInventoryDto>>builder()
                        .timestamp(LocalDateTime.now())
                        .status(503)
                        .message("Inventory service unavailable. Store inventory not available.")
                        .data(Collections.emptyList())
                        .build();
            }

            @Override
            public ApiResponseDto<List<StoreDto>> getActiveStores() {
                log.warn("Fallback: getActiveStores");
                return ApiResponseDto.<List<StoreDto>>builder()
                        .timestamp(LocalDateTime.now())
                        .status(503)
                        .message("Inventory service unavailable. Store list not available.")
                        .data(Collections.emptyList())
                        .build();
            }
            
            @Override
            public ApiResponseDto<List<Long>> getAllProductIdsWithStock() {
                log.warn("Fallback: getAllProductIdsWithStock");
                return ApiResponseDto.<List<Long>>builder()
                        .timestamp(LocalDateTime.now())
                        .status(503)
                        .message("Inventory service unavailable. Product stock list not available.")
                        .data(Collections.emptyList())
                        .build();
            }
        };
    }
}
