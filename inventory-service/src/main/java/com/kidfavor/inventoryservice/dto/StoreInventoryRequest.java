package com.kidfavor.inventoryservice.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventoryRequest {

    @NotNull(message = "Store ID is required")
    private Long storeId;

    @NotNull(message = "Product ID is required")
    private Long productId;

    @Size(max = 255, message = "Product name must not exceed 255 characters")
    private String productName;

    private BigDecimal price;

    private BigDecimal salePrice;

    @Size(max = 1000, message = "Image URL must not exceed 1000 characters")
    private String imageUrl;

    @NotNull(message = "Quantity is required")
    @Min(value = 0, message = "Quantity must be non-negative")
    private Integer quantity;

    @Min(value = 0, message = "Min stock level must be non-negative")
    private Integer minStockLevel = 0;

    @Size(max = 50, message = "Shelf location must not exceed 50 characters")
    private String shelfLocation;
}
