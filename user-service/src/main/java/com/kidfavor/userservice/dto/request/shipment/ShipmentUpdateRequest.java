package com.kidfavor.userservice.dto.request.shipment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShipmentUpdateRequest {
    private String street;
    private String ward;
    private String district;
    private String city;
    private String note;
}
