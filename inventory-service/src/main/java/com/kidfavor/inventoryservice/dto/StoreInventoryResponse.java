package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventoryResponse {
    private Long productId;
    private String productName;
    private Integer quantity;
    private String shelfLocation;
    private String updatedBy;
    private LocalDateTime lastUpdated;
}
