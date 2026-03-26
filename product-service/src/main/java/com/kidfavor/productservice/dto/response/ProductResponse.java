package com.kidfavor.productservice.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.kidfavor.productservice.enums.EntityStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductResponse {

    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal salePrice;
    private LocalDateTime saleStartDate;
    private LocalDateTime saleEndDate;
    private Boolean onSale;
    private EntityStatus status;
    private LocalDateTime statusChangedAt;
    private CategoryResponse category;
    private BrandResponse brand;
    private List<String> imageUrls;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * Stock information from all stores.
     */
    private List<StoreStockInfo> storeStocks;

    /**
     * Total stock quantity across all stores.
     */
    private Integer totalStock;

    /**
     * Computed field for backward compatibility with order-service.
     * Returns true if status is ACTIVE, false otherwise.
     */
    public Boolean getActive() {
        return status == EntityStatus.ACTIVE;
    }

    /**
     * Returns the effective price: salePrice if on sale, otherwise original price.
     */
    @JsonProperty("effectivePrice")
    public BigDecimal getEffectivePrice() {
        return Boolean.TRUE.equals(onSale) && salePrice != null ? salePrice : price;
    }
}
