package com.kidfavor.inventoryservice.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseRequest {

    @NotBlank(message = "Warehouse code is required")
    @Size(max = 50, message = "Warehouse code must not exceed 50 characters")
    private String warehouseCode;

    @NotBlank(message = "Warehouse name is required")
    @Size(max = 200, message = "Warehouse name must not exceed 200 characters")
    private String warehouseName;

    @Size(max = 500, message = "Address must not exceed 500 characters")
    private String address;

    @Size(max = 100, message = "City must not exceed 100 characters")
    private String city;

    @Size(max = 100, message = "District must not exceed 100 characters")
    private String district;

    @Size(max = 100, message = "Ward must not exceed 100 characters")
    private String ward;

    @Size(max = 20, message = "Phone must not exceed 20 characters")
    private String phone;

    @Size(max = 200, message = "Manager name must not exceed 200 characters")
    private String managerName;

    @DecimalMin(value = "0.0", message = "Capacity must be positive")
    private BigDecimal capacity;

    @Size(max = 50, message = "Warehouse type must not exceed 50 characters")
    private String warehouseType;

    private Boolean isActive = true;
}
