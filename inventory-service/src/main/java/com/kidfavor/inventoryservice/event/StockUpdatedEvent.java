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
public class StockUpdatedEvent {
    private Long productId;
    private String locationType; // WAREHOUSE or STORE
    private Long locationId;
    private String locationCode;
    private Integer previousQuantity;
    private Integer newQuantity;
    private Integer quantityChange;
    private String reason;
    private LocalDateTime timestamp;
}
