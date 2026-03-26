package com.kidfavor.productservice.client.dto;

import lombok.*;

import java.time.LocalDateTime;

/**
 * DTO for Store Inventory information from Inventory Service.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventoryDto {
    private Long id;
    private Long storeId;
    private String storeCode;
    private String storeName;
    private String address;
    private String city;
    private Long productId;
    private Integer quantity;
    private Integer minStockLevel;
    private String shelfLocation;
    private LocalDateTime lastUpdated;
}
