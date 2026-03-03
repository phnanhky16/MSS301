package com.kidfavor.productservice.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO for store stock information in product response.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StoreStockInfo {
    
    private Long storeId;
    private String storeName;
    private String address;
    private String city;
    private Integer quantity;
    private Integer minStockLevel;
    private String stockStatus;
    private String shelfLocation;
    private LocalDateTime lastUpdated;
}
