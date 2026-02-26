package com.kidfavor.inventoryservice.dto;

import com.kidfavor.inventoryservice.enums.ProductStockStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseProductResponse {
    private Long productId;
    private String productName;
    private Integer quantity;
    private ProductStockStatus status;
    private String locationCode;
    private String updatedBy;
    private LocalDateTime lastUpdated;
}
