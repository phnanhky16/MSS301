package com.kidfavor.orderservice.service;

import java.math.BigDecimal;
import com.kidfavor.orderservice.entity.Coupon;

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
     * Return all coupons in the system.  This is a convenience method and may
     * be inefficient for large data sets; controllers should prefer the
     * paged variant when exposing data to clients.
     */
    java.util.List<Coupon> listAll();

    /**
     * Return coupons in the system paged.  The pageable is built automatically
     * by Spring from `page`/`size` query params in the controller.
     */
    org.springframework.data.domain.Page<Coupon> listAll(org.springframework.data.domain.Pageable pageable);
}
