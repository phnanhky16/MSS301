package com.kidfavor.orderservice.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShipmentCreateRequest {
    private String street;
    private String ward;
    private String district;
    private String city;
    private String shippingAddress;  // Full address
    private String recipientPhone;
    private Integer userId;
}
