package com.kidfavor.inventoryservice.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockLowAlertEvent {
    private Long productId;
    private String locationType; // WAREHOUSE or STORE
    private Long locationId;
    private String locationCode;
    private String locationName;
    private Integer currentQuantity;
    private Integer minStockLevel;
    private LocalDateTime timestamp;
}
