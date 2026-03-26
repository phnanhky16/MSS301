package com.kidfavor.orderservice.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for geocoding result from inventory-service
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GeocodingResultDTO {
    private Double latitude;
    private Double longitude;
    private String street;
    private String ward;
    private String district;
    private String city;
    private String formattedAddress;
    private String accuracy;
}
