package com.kidfavor.userservice.dto.response;

import com.kidfavor.userservice.entity.Shipment;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShipmentResponse {
    private Integer shipId;
    private String street;
    private String ward;
    private String district;
    private String city;
    private Integer userId;
    private Boolean status;
    private String note;
    public static ShipmentResponse from(Shipment shipment) {
        return new ShipmentResponse(
                shipment.getShipId(),
                shipment.getStreet(),
                shipment.getWard(),
                shipment.getDistrict(),
                shipment.getCity(),
                shipment.getUser().getId(),
                shipment.getStatus(),
                shipment.getNote());
    }
}
