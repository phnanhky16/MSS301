package com.kidfavor.orderservice.service.impl;

import com.kidfavor.orderservice.client.InventoryServiceClient;
import com.kidfavor.orderservice.client.UserServiceClient;
import com.kidfavor.orderservice.client.dto.AllocationResultDTO;
import com.kidfavor.orderservice.client.dto.BulkAllocationRequest;
import com.kidfavor.orderservice.client.dto.BulkAllocationResult;
import com.kidfavor.orderservice.client.dto.BulkAllocationResult.AllocationItem;
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

        if (order.getShippingLatitude() != null) {
            List<BulkAllocationRequest.ItemRequest> itemRequests = new ArrayList<>();
            for (OrderItem item : order.getItems()) {
                itemRequests.add(BulkAllocationRequest.ItemRequest.builder()
                        .productId(item.getProductId())
                        .quantity(item.getQuantity())
                        .build());
            }

            BulkAllocationRequest bulkRequest = BulkAllocationRequest.builder()
                    .latitude(order.getShippingLatitude())
                    .longitude(order.getShippingLongitude())
                    .items(itemRequests)
                    .maxDistanceKm(50.0) // default search radius
                    .build();

            BulkAllocationResult bulkResult = inventoryServiceClient.allocateBulkInventory(bulkRequest);

            if (bulkResult != null && bulkResult.getAllocations() != null) {
                List<OrderItem> splitItems = new ArrayList<>();
                for (AllocationItem allocated : bulkResult.getAllocations()) {
                    // Find original item specs (price, name, etc.)
                    OrderItem originalItem = order.getItems().stream()
                            .filter(i -> i.getProductId().equals(allocated.getProductId()))
                            .findFirst().orElse(null);

                    if (originalItem != null) {
                        OrderItem splitItem = OrderItem.builder()
                                .order(order)
                                .productId(originalItem.getProductId())
                                .productName(originalItem.getProductName())
                                .productImageUrl(originalItem.getProductImageUrl())
                                .unitPrice(originalItem.getUnitPrice())
                                .quantity(allocated.getAllocatedQuantity())
                                .storeId(allocated.getStoreId())
                                .build();
                        splitItem.calculateSubtotal();
                        splitItems.add(splitItem);
                    }
                }
                
                // Replace the original items with the split/allocated items
                order.getItems().clear();
                for (OrderItem splitItem : splitItems) {
                    order.addItem(splitItem);
                }

                result.setAllAllocationsSuccessful(bulkResult.isFullyAllocated());
                if (!bulkResult.isFullyAllocated()) {
                    result.setErrorMessage(bulkResult.getMessage());
                }
            }
        }

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
}
