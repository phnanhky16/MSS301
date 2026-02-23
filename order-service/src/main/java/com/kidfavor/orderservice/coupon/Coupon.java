package com.kidfavor.orderservice.coupon;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "coupons")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;

    @Column(nullable = false)
    private boolean active;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal discountValue; // either fixed amount or percent

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private DiscountType discountType;

    @Column
    private LocalDateTime expiresAt;

    @Column
    private Integer maxRedemptions;

    @Column(nullable = false)
    @Builder.Default
    private Integer timesRedeemed = 0;

    @Version
    private Long version;

    public enum DiscountType {
        PERCENT, FIXED
    }

    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    public boolean isUsable() {
        if (!active) return false;
        if (isExpired()) return false;
        if (maxRedemptions != null && timesRedeemed >= maxRedemptions) return false;
        return true;
    }
}
