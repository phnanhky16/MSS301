package com.kidfavor.orderservice.coupon;

public class CouponUnavailableException extends RuntimeException {
    public CouponUnavailableException(String code) {
        super("Coupon cannot be applied: " + code);
    }
}
