package com.kidfavor.productservice.client.dto;

import lombok.*;

/**
 * DTO for Store information from Inventory Service.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreDto {
    private Long storeId;
    private String storeCode;
    private String storeName;
    private String address;
    private String city;
    private String district;
    private String phone;
    private String managerName;
    private Boolean isActive;
}
