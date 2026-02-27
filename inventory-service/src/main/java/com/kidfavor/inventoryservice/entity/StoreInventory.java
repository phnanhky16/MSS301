package com.kidfavor.inventoryservice.entity;

import com.kidfavor.inventoryservice.enums.ProductStockStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "store_inventory", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"store_id", "product_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StoreInventory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "product_id", nullable = false)
    private Long productId;

    @Column(name = "product_name", length = 255)
    private String productName;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 0;

    @Column(name = "min_stock_level")
    private Integer minStockLevel = 0;

    @Column(name = "shelf_location", length = 50)
    private String shelfLocation;

    @Column(name = "updated_by", length = 100)
    private String updatedBy;

    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;

    @PrePersist
    @PreUpdate
    public void updateLastUpdated() {
        this.lastUpdated = LocalDateTime.now();
    }

    public ProductStockStatus getStockStatus() {
        if (quantity == null || quantity == 0) {
            return ProductStockStatus.OUT_OF_STOCK;
        }
        if (minStockLevel != null && quantity < minStockLevel) {
            return ProductStockStatus.LOW_STOCK;
        }
        return ProductStockStatus.IN_STOCK;
    }
}
