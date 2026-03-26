package com.kidfavor.inventoryservice.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "warehouses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Warehouse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "warehouse_id")
    private Long warehouseId;

    @Column(name = "warehouse_code", nullable = false, unique = true, length = 50)
    private String warehouseCode;

    @Column(name = "warehouse_name", nullable = false, length = 200)
    private String warehouseName;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "city", length = 100)
    private String city;

    @Column(name = "district", length = 100)
    private String district;

    @Column(name = "ward", length = 100)
    private String ward;

    @Column(name = "street", length = 200)
    private String street;

    @Column(name = "house_number", length = 50)
    private String houseNumber;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "manager_name", length = 200)
    private String managerName;

    @Column(name = "capacity", precision = 10, scale = 2)
    private BigDecimal capacity;

    @Column(name = "warehouse_type", length = 50)
    private String warehouseType;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    // GPS Coordinates
    @Column(name = "latitude")
    private Double latitude;  // Vietnam: ~8° to 23°N

    @Column(name = "longitude")
    private Double longitude; // Vietnam: ~102° to 110°E

    @Column(name = "location_accuracy", length = 50)
    private String locationAccuracy; // address, street, district, city

    @Column(name = "osm_place_id", length = 100)
    private String osmPlaceId; // OpenStreetMap Place ID

    @Column(name = "formatted_address", length = 1000)
    private String formattedAddress; // Full address from geocoding

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
