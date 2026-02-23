package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventoryResponse {
    private Long id;
    private Long storeId;
    private String storeCode;
    private String storeName;
    private Long productId;
    private Integer quantity;
    private Integer minStockLevel;
    private String shelfLocation;
    private LocalDateTime lastUpdated;
}
