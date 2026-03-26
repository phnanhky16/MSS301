package com.kidfavor.inventoryservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WarehouseStatsResponse {
    private long totalWarehouses;
    private long activeWarehouses;
    private long totalProducts;
    private long totalStockQuantity;
    private long lowStockItemsCount;
}
