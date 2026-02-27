package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreRestockResponse {
    private Long fromWarehouseId;
    private String fromWarehouseName;
    private Long toStoreId;
    private String toStoreName;
    private Long productId;
    private String productName;
    private Integer quantity;
    private Integer warehouseRemainingStock;
    private Integer storeNewStock;
    private String transferredBy;
    private LocalDateTime transferredAt;
    private String notes;
}
