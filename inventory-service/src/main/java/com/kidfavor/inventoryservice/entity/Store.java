package com.kidfavor.inventoryservice.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "stores")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Store {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "store_id")
    private Long storeId;

    @Column(name = "store_code", nullable = false, unique = true, length = 50)
    private String storeCode;

    @Column(name = "store_name", nullable = false, length = 200)
    private String storeName;

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

    // GPS Coordinates for real map integration
    @Column(name = "latitude")
    private Double latitude;  // Vĩ độ (Việt Nam: ~8° to 23°N)

    @Column(name = "longitude")
    private Double longitude; // Kinh độ (Việt Nam: ~102° to 110°E)

    @Column(name = "location_accuracy", length = 50)
    private String locationAccuracy; // OSM accuracy level: "address", "street", "city"

    @Column(name = "osm_place_id", length = 100)
    private String osmPlaceId; // OpenStreetMap Place ID for reference

    @Column(name = "formatted_address", length = 1000)
    private String formattedAddress; // Full address from OSM

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
