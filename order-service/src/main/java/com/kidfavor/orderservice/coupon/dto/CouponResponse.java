package com.kidfavor.orderservice.coupon.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CouponResponse {
    private Long id;
    private String code;
    private com.kidfavor.orderservice.coupon.Coupon.DiscountType discountType;
    private BigDecimal discountValue;
    private LocalDateTime expiresAt;
    private Integer maxRedemptions;
    private Integer timesRedeemed;
    private Boolean active;
}
