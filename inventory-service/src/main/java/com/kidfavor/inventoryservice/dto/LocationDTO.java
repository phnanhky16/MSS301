package com.kidfavor.inventoryservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for GPS coordinates and location information
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LocationDTO {
    
    private Double latitude;
    private Double longitude;
    
    // Distance from user/reference point
    private Double distanceKm;
    
    // Full address from OSM
    private String formattedAddress;
    
    // Address components
    private String city;
    private String district;
    private String ward;
    private String street;
    private String houseNumber;
    
    // OSM metadata
    private String osmPlaceId;
    private String osmDisplayName;
    private String accuracy; // "address", "street", "city", "district"
    private String osmType;  // "house", "shop", "building", "amenity"
}
