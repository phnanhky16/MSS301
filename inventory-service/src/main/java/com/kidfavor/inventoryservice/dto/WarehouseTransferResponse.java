package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseTransferResponse {
    private Long fromWarehouseId;
    private String fromWarehouseName;
    private Long toWarehouseId;
    private String toWarehouseName;
    private Long productId;
    private String productName;
    private Integer quantity;
    private Integer fromWarehouseRemainingStock;
    private Integer toWarehouseNewStock;
    private String transferredBy;
    private LocalDateTime transferredAt;
    private String notes;
}
