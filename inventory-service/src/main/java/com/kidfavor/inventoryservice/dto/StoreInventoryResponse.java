package com.kidfavor.inventoryservice.dto;

import com.kidfavor.inventoryservice.enums.ProductStockStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventoryResponse {
    // identify the store that holds the inventory; these were previously
    // omitted which caused the product-service to display null values.
    private Long storeId;
    private String storeName;

    // additional store location details requested by frontend
    private String address;
    private String city;

    private Long productId;
    private String productName;
    private Integer quantity;
    private ProductStockStatus status;
    private String shelfLocation;
    private String updatedBy;
    private LocalDateTime lastUpdated;
}
