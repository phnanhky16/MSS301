package com.kidfavor.inventoryservice.service;

import com.kidfavor.inventoryservice.dto.LocationDTO;

/**
 * Service interface for geocoding addresses to GPS coordinates
 * Uses OpenStreetMap Nominatim API
 */
public interface GeocodingService {

    /**
     * Geocode an address to GPS coordinates with fallback strategy
     * 
     * @param address Full address string
     * @param city City name for fallback
     * @param district District name for fallback
     * @return LocationDTO with latitude and longitude, or null if geocoding fails
     */
    LocationDTO geocodeAddress(String address, String city, String district);

    /**
     * Calculate distance between two GPS coordinates using Haversine formula
     * 
     * @param lat1 Latitude of first point
     * @param lon1 Longitude of first point
     * @param lat2 Latitude of second point
     * @param lon2 Longitude of second point
     * @return Distance in kilometers
     */
    double calculateDistance(double lat1, double lon1, double lat2, double lon2);
}
