package com.kidfavor.inventoryservice.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WarehouseResponse {
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String address;
    private String city;
    private String district;
    private String ward;
    private String phone;
    private String managerName;
    private BigDecimal capacity;
    private String warehouseType;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
