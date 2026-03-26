package com.kidfavor.orderservice.dto.response;

import com.kidfavor.orderservice.entity.OrderStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderResponse {

    private Long id;
    private String orderNumber;
    private Long userId;
    private OrderStatus status;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private Long storeId;              // Store ID for POS orders
    private Double shippingLatitude;   // GPS latitude
    private Double shippingLongitude;  // GPS longitude
    private Long shipmentId;           // Shipment reference
    private String phoneNumber;
    private String notes;
    private List<OrderItemResponse> items;
    private String couponCode; // Added couponCode
    private BigDecimal discountAmount; // Added discountAmount
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
