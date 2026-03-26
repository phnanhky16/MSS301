package com.kidfavor.orderservice.service;

import com.kidfavor.orderservice.dto.response.LocationBasedOrderResult;
import com.kidfavor.orderservice.entity.Order;

/**
 * Service interface for location-based order processing.
 * Handles order creation, shipment management, geocoding, and inventory allocation.
 */
public interface LocationBasedOrderService {
    
    /**
     * Process an order with location-based inventory allocation.
     * 
     * @param order The order to process
     * @return LocationBasedOrderResult with processing details
     */
    LocationBasedOrderResult processOrder(Order order);
}
