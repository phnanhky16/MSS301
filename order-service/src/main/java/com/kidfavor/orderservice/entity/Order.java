package com.kidfavor.orderservice.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String orderNumber;

    @Column(nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal totalAmount;

    // coupon that has been applied to this order (null if none)
    @Column(length = 50)
    private String couponCode;

    // amount discounted due to coupon (zero if none)
    @Column(precision = 19, scale = 2)
    @Builder.Default
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @Column(length = 500)
    private String shippingAddress;

    @Column(length = 20)
    private String phoneNumber;

    @Column(length = 500)
    private String notes;

    // Store ID for POS orders that bypass location-based allocation
    @Column(name = "store_id")
    private Long storeId;

    // GPS coordinates of shipping address for location-based inventory allocation
    @Column(name = "shipping_latitude")
    private Double shippingLatitude;

    @Column(name = "shipping_longitude")
    private Double shippingLongitude;

    // Shipment ID reference (created in user-service)
    @Column(name = "shipment_id")
    private Long shipmentId;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<OrderItem> items = new ArrayList<>();

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public void addItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }

    public void removeItem(OrderItem item) {
        items.remove(item);
        item.setOrder(null);
    }

    public void calculateTotalAmount() {
        this.totalAmount = items.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add)
                .subtract(discountAmount != null ? discountAmount : BigDecimal.ZERO);
    }
}
