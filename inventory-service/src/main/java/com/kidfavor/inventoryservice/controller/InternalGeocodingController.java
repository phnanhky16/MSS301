package com.kidfavor.inventoryservice.controller;

import com.kidfavor.inventoryservice.dto.LocationDTO;
import com.kidfavor.inventoryservice.service.GeocodingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * Internal Controller for Geocoding operations
 * Used for service-to-service communication (no authentication required)
 */
@Slf4j
@RestController
@RequestMapping("/internal/geocoding")
@RequiredArgsConstructor
public class InternalGeocodingController {

    private final GeocodingService geocodingService;

    /**
     * Geocode address - Internal endpoint for order-service
     * No authentication required for service-to-service calls
     */
    @GetMapping
    public LocationDTO geocode(
            @RequestParam String address,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String district) {
        
        log.info("🗺️ Internal API: Geocoding address: {}", address);
        
        // Parse city and district from address if not provided
        String parsedCity = city;
        String parsedDistrict = district;
        
        if (address != null) {
            // Extract city (TP.HCM, Hà Nội, etc.)
            if (parsedCity == null && address.contains("TP.HCM")) {
                parsedCity = "TP.HCM";
            } else if (parsedCity == null && address.toLowerCase().contains("hồ chí minh")) {
                parsedCity = "Hồ Chí Minh";
            } else if (parsedCity == null && address.toLowerCase().contains("hà nội")) {
                parsedCity = "Hà Nội";
            }
            
            // Extract district (Quận X, Huyện Y, etc.)
            if (parsedDistrict == null) {
                if (address.contains("Quận")) {
                    int start = address.indexOf("Quận");
                    int end = address.indexOf(",", start);
                    if (end == -1) end = address.indexOf("TP", start);
                    if (end == -1) end = address.length();
                    parsedDistrict = address.substring(start, end).trim();
                } else if (address.contains("Huyện")) {
                    int start = address.indexOf("Huyện");
                    int end = address.indexOf(",", start);
                    if (end == -1) end = address.length();
                    parsedDistrict = address.substring(start, end).trim();
                }
            }
        }
        
        log.info("📍 Parsed location: city={}, district={}", parsedCity, parsedDistrict);
        
        LocationDTO response = geocodingService.geocodeAddress(address, parsedCity, parsedDistrict);
        
        if (response != null && response.getLatitude() != null && response.getLongitude() != null) {
            log.info("✅ Internal API: Geocoded to ({}, {})", response.getLatitude(), response.getLongitude());
        } else {
            log.warn("⚠️ Internal API: Geocoding returned null or invalid coordinates");
        }
        
        return response;
    }
}
