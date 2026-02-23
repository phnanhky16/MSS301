package com.kidfavor.inventoryservice.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseProductRequest {

    @NotNull(message = "Warehouse ID is required")
    private Long warehouseId;

    @NotNull(message = "Product ID is required")
    private Long productId;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity must be non-negative")
    private Integer quantity;

    @Min(value = 0, message = "Min stock level must be non-negative")
    private Integer minStockLevel = 0;

    @Min(value = 0, message = "Max stock level must be non-negative")
    private Integer maxStockLevel = 0;

    @Size(max = 50, message = "Location code must not exceed 50 characters")
    private String locationCode;
}
