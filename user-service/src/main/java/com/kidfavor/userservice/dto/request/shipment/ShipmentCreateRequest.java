package com.kidfavor.userservice.dto.request.shipment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShipmentCreateRequest {
    private String street;
    private String ward;
    private String district;
    private String city;
    private int userId;
    private String note;
}
