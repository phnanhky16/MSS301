package com.kidfavor.inventoryservice.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockUpdateRequest {

    @NotNull(message = "Product ID is required")
    private Long productId;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity must be greater than or equal to 0")
    private Integer quantity;

    private String reason;
}
