package com.kidfavor.inventoryservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

/**
 * Response from OpenStreetMap Nominatim API
 * API Docs: https://nominatim.org/release-docs/latest/api/Search/
 */
@Data
public class NominatimResponse {
    
    @JsonProperty("place_id")
    private Long placeId;
    
    private String licence;
    
    @JsonProperty("osm_type")
    private String osmType; // "node", "way", "relation"
    
    @JsonProperty("osm_id")
    private Long osmId;
    
    private List<String> boundingbox;
    
    @JsonProperty("lat")
    private String latitude;
    
    @JsonProperty("lon")
    private String longitude;
    
    @JsonProperty("display_name")
    private String displayName;
    
    @JsonProperty("class")
    private String classification;
    
    private String type;
    
    private Double importance;
    
    private String icon;
    
    private AddressComponents address;
    
    @Data
    public static class AddressComponents {
        @JsonProperty("house_number")
        private String houseNumber;
        
        private String road;
        private String suburb;
        private String quarter;
        
        @JsonProperty("city_district")
        private String cityDistrict;
        
        private String city;
        private String county;
        
        @JsonProperty("state_district")
        private String stateDistrict;
        
        private String state;
        
        @JsonProperty("ISO3166-2-lvl4")
        private String iso3166Level4;
        
        private String postcode;
        private String country;
        
        @JsonProperty("country_code")
        private String countryCode;
    }
}
