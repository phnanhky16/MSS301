package com.kidfavor.inventoryservice.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreAvailabilityResponse {
    private Long storeId;
    private String storeCode;
    private String storeName;
    private String address;
    private Long productId;
    private String productName;
    private Integer availableQuantity;
    private String shelfLocation;
}
