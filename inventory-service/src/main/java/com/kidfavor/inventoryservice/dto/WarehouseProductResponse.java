package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseProductResponse {
    private Long id;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long productId;
    private Integer quantity;
    private Integer minStockLevel;
    private Integer maxStockLevel;
    private String locationCode;
    private LocalDateTime lastUpdated;
}
