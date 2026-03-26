package com.kidfavor.inventoryservice.service.impl;

import com.kidfavor.inventoryservice.dto.LocationDTO;
import com.kidfavor.inventoryservice.dto.NominatimResponse;
import com.kidfavor.inventoryservice.service.GeocodingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;

/**
 * Implementation of GeocodingService
 * Uses OpenStreetMap Nominatim API for geocoding addresses to GPS coordinates
 * 
 * Nominatim API: https://nominatim.openstreetmap.org/
 * 
 * Usage Policy: 
 * - Maximum 1 request per second
 * - Include valid User-Agent and email in requests
 * - For Vietnam addresses, use "countrycodes=vn"
 * 
 * For production: Consider self-hosting Nominatim or using commercial alternatives
 */
@Service
@Slf4j
public class GeocodingServiceImpl implements GeocodingService {

    private static final String NOMINATIM_BASE_URL = "https://nominatim.openstreetmap.org";
    
    @Value("${app.geocoding.user-agent:KidFavor-Inventory/1.0}")
    private String userAgent;
    
    @Value("${app.geocoding.email:contact@kidfavor.com}")
    private String contactEmail;
    
    private RestClient restClient;
    
    /**
     * Initialize RestClient after dependency injection
     */
    private RestClient getRestClient() {
        if (restClient == null) {
            restClient = RestClient.builder()
                    .baseUrl(NOMINATIM_BASE_URL)
                    .defaultHeader(HttpHeaders.USER_AGENT, userAgent)
                    .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
                    .build();
            log.info("RestClient initialized with User-Agent: {}", userAgent);
        }
        return restClient;
    }

    /**
     * Geocode a Vietnamese address to GPS coordinates
     * 
     * @param address Full address string
     * @param city City name (e.g., "Hồ Chí Minh", "Hà Nội")
     * @param district District name (e.g., "Quận 1", "Quận Tân Bình")
     * @return LocationDTO with coordinates and formatted address
     */
    @Override
    public LocationDTO geocodeAddress(String address, String city, String district) {
        try {
            // Try with full address first
            String query = buildSearchQuery(address, district, city);
            log.info("Geocoding address: {}", query);
            
            LocationDTO result = tryGeocode(query);
            if (result != null) {
                log.info("✅ Geocoded to ({}, {})", result.getLatitude(), result.getLongitude());
                return result;
            }
            
            // Fallback 1: Try without specific address, just district + city
            if (district != null && !district.trim().isEmpty()) {
                String fallbackQuery = buildSearchQuery(null, district, city);
                log.warn("⚠️ Exact address not found. Trying fallback with district: {}", fallbackQuery);
                
                result = tryGeocode(fallbackQuery);
                if (result != null) {
                    result.setAccuracy("district_fallback");
                    log.info("✅ Fallback: Geocoded to district center ({}, {})", 
                             result.getLatitude(), result.getLongitude());
                    return result;
                }
            }
            
            // Fallback 2: Try with just city
            if (city != null && !city.trim().isEmpty()) {
                String cityQuery = buildSearchQuery(null, null, city);
                log.warn("⚠️ District not found. Trying fallback with city: {}", cityQuery);
                
                result = tryGeocode(cityQuery);
                if (result != null) {
                    result.setAccuracy("city_fallback");
                    log.info("✅ Fallback: Geocoded to city center ({}, {})", 
                             result.getLatitude(), result.getLongitude());
                    return result;
                }
            }
            
            log.warn("❌ No geocoding results found for any fallback: {}", query);
            return null;
            
        } catch (Exception e) {
            log.error("Error geocoding address: {}", address, e);
            return null;
        }
    }

    /**
     * Calculate distance between two GPS coordinates using Haversine formula
     * 
     * @param lat1 Latitude of point 1
     * @param lon1 Longitude of point 1
     * @param lat2 Latitude of point 2
     * @param lon2 Longitude of point 2
     * @return Distance in kilometers
     */
    @Override
    public double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int EARTH_RADIUS_KM = 6371;
        
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);
        
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        
        return EARTH_RADIUS_KM * c;
    }

    // Helper methods

    private String buildSearchQuery(String address, String district, String city) {
        StringBuilder query = new StringBuilder();
        
        if (address != null && !address.trim().isEmpty()) {
            query.append(address.trim());
        }
        
        if (district != null && !district.trim().isEmpty()) {
            if (query.length() > 0) query.append(", ");
            query.append(district.trim());
        }
        
        if (city != null && !city.trim().isEmpty()) {
            if (query.length() > 0) query.append(", ");
            query.append(city.trim());
        }
        
        // Always add Vietnam
        if (query.length() > 0) query.append(", ");
        query.append("Vietnam");
        
        return query.toString();
    }

    private LocationDTO mapToLocationDTO(NominatimResponse response) {
        LocationDTO location = LocationDTO.builder()
                .latitude(Double.parseDouble(response.getLatitude()))
                .longitude(Double.parseDouble(response.getLongitude()))
                .osmPlaceId(String.valueOf(response.getPlaceId()))
                .osmDisplayName(response.getDisplayName())
                .formattedAddress(response.getDisplayName())
                .osmType(response.getOsmType())
                .build();
        
        // Extract address components
        if (response.getAddress() != null) {
            NominatimResponse.AddressComponents addr = response.getAddress();
            location.setHouseNumber(addr.getHouseNumber());
            location.setStreet(addr.getRoad());
            location.setDistrict(addr.getCityDistrict() != null ? addr.getCityDistrict() : addr.getCounty());
            location.setCity(addr.getCity() != null ? addr.getCity() : addr.getState());
            location.setWard(addr.getSuburb() != null ? addr.getSuburb() : addr.getQuarter());
        }
        
        // Determine accuracy
        location.setAccuracy(determineAccuracy(response));
        
        return location;
    }

    private String determineAccuracy(NominatimResponse response) {
        if (response.getAddress() != null && response.getAddress().getHouseNumber() != null) {
            return "address";
        } else if (response.getAddress() != null && response.getAddress().getRoad() != null) {
            return "street";
        } else if (response.getType() != null && response.getType().contains("district")) {
            return "district";
        } else {
            return "city";
        }
    }
    
    /**
     * Try to geocode a query using Nominatim API
     * 
     * @param query Search query
     * @return LocationDTO if found, null otherwise
     */
    private LocationDTO tryGeocode(String query) {
        try {
            // Build URL with parameters
            String url = UriComponentsBuilder.fromPath("/search")
                    .queryParam("q", query)
                    .queryParam("format", "json")
                    .queryParam("addressdetails", 1)
                    .queryParam("limit", 1)
                    .queryParam("countrycodes", "vn") // Vietnam only
                    .queryParam("email", contactEmail)
                    .build()
                    .toUriString();
            
            // Call Nominatim API (respect 1 req/sec limit)
            Thread.sleep(1000); // Rate limiting
            
            List<NominatimResponse> responses = getRestClient().get()
                    .uri(url)
                    .retrieve()
                    .body(new ParameterizedTypeReference<>() {});
            
            if (responses == null || responses.isEmpty()) {
                return null;
            }
            
            return mapToLocationDTO(responses.get(0));
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("Geocoding interrupted", e);
            return null;
        } catch (Exception e) {
            log.error("Error trying to geocode: {}", query, e);
            return null;
        }
    }
}
