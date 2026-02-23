package com.kidfavor.orderservice.coupon.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
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
public class CouponRequest {
    @NotBlank
    @Size(max = 50)
    private String code;

    @NotNull
    private com.kidfavor.orderservice.coupon.Coupon.DiscountType discountType;

    @NotNull
    @DecimalMin("0")
    private BigDecimal discountValue;

    private LocalDateTime expiresAt;

    private Integer maxRedemptions;

    @NotNull
    private Boolean active;
}
