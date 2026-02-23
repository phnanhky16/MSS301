package com.kidfavor.orderservice.coupon;

import java.math.BigDecimal;

public interface CouponService {
    /**
     * Validates a coupon code and returns the discount amount that should be
     * applied to the given order subtotal. Throws exception if coupon is
     * invalid or cannot be applied.
     */
    BigDecimal applyCoupon(String code, BigDecimal orderSubtotal);

    /**
     * Create or update a coupon record.
     */
    Coupon save(Coupon coupon);

    /**
     * Lookup coupon by code.
     */
    Coupon getByCode(String code);
    
    /**
     * Remove a coupon by code (hard delete).
     */
    void deleteByCode(String code);

    /**
     * Return all coupons in the system.
     */
    java.util.List<Coupon> listAll();
}
