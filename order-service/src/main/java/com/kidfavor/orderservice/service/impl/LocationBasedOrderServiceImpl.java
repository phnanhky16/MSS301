package com.kidfavor.orderservice.service.impl;

import com.kidfavor.orderservice.client.InventoryServiceClient;
import com.kidfavor.orderservice.client.UserServiceClient;
import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
import com.kidfavor.orderservice.client.dto.GeocodingResultDTO;
import com.kidfavor.orderservice.dto.request.ShipmentCreateRequest;
import com.kidfavor.orderservice.dto.response.LocationBasedOrderResult;
import com.kidfavor.orderservice.dto.response.ShipmentResponse;
import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderItem;
import com.kidfavor.orderservice.service.LocationBasedOrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class LocationBasedOrderServiceImpl implements LocationBasedOrderService {

    private final InventoryServiceClient inventoryServiceClient;
    private final UserServiceClient userServiceClient;

    @Override
    public LocationBasedOrderResult processOrder(Order order) {
        log.info("Processing location-based order: {}", order.getOrderNumber());
        
        LocationBasedOrderResult result = LocationBasedOrderResult.builder()
                .orderNumber(order.getOrderNumber())
                .build();

        try {
            Long shipmentId = createShipment(order);
            order.setShipmentId(shipmentId);
            result.setShipmentId(shipmentId);
            result.setShipmentCreated(true);
        } catch (Exception e) {
            log.error("Failed to create shipment", e);
            result.setShipmentCreated(false);
            result.setErrorMessage("Failed to create shipment");
            return result;
        }

        if (order.getShippingAddress() != null) {
            try {
                GeocodingResultDTO geocoding = geocodeAddress(order.getShippingAddress());
                if (geocoding != null) {
                    order.setShippingLatitude(geocoding.getLatitude());
                    order.setShippingLongitude(geocoding.getLongitude());
                    result.setGeocodingSuccess(true);
                    result.setLatitude(geocoding.getLatitude());
                    result.setLongitude(geocoding.getLongitude());
                }
            } catch (Exception e) {
                log.error("Geocoding failed", e);
                result.setGeocodingSuccess(false);
            }
        }

        List<AllocationResultDTO> allocations = new ArrayList<>();
        if (order.getShippingLatitude() != null) {
            for (OrderItem item : order.getItems()) {
                AllocationResultDTO allocation = allocateInventory(
                    order.getShippingLatitude(),
                    order.getShippingLongitude(),
                    item.getProductId(),
                    item.getQuantity()
                );
                allocations.add(allocation);
                
                if (allocation.getSuccess() && allocation.getStoreId() != null) {
                    order.setStoreId(allocation.getStoreId());
                    result.setAllocatedStoreId(allocation.getStoreId());
                }
            }
        }

        result.setAllocations(allocations);
        result.setAllAllocationsSuccessful(
            allocations.stream().allMatch(AllocationResultDTO::getSuccess)
        );

        return result;
    }

    private Long createShipment(Order order) {
        // Create shipment with available order information
        ShipmentCreateRequest request = ShipmentCreateRequest.builder()
                .userId(order.getUserId().intValue())  // Convert Long to Integer
                .shippingAddress(order.getShippingAddress())
                .recipientPhone(order.getPhoneNumber())
                .build();
        
        try {
            var response = userServiceClient.createShipment(request);
            // Extract shipment ID from ApiResponse wrapper
            if (response != null && response.getData() != null) {
                return response.getData().getShipmentId();  // Fixed: use getShipmentId()
            }
            log.warn("Shipment creation returned null or empty response");
            return null;
        } catch (Exception e) {
            log.error("Failed to create shipment via UserServiceClient", e);
            throw e;
        }
    }

    private GeocodingResultDTO geocodeAddress(String address) {
        String city = "TP.HCM";
        String district = null;
        if (address.contains("Quận")) {
            int idx = address.indexOf("Quận");
            String temp = address.substring(idx);
            String[] parts = temp.split(",");
            if (parts.length > 0) {
                district = parts[0].trim();
            }
        }
        return inventoryServiceClient.geocodeAddress(address, city, district);
    }

    private AllocationResultDTO allocateInventory(Double lat, Double lon, Long productId, Integer quantity) {
        try {
            // Call with default max distance 50km
            return inventoryServiceClient.allocateFromNearestStore(lat, lon, productId, quantity, 50.0);
        } catch (Exception e) {
            log.error("Failed to allocate inventory for product {}", productId, e);
            return AllocationResultDTO.builder()
                    .success(false)
                    .message("Allocation failed: " + e.getMessage())
                    .build();
        }
    }
}
