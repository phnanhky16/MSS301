package com.kidfavor.orderservice.exception;

public class CouponUnavailableException extends RuntimeException {
    public CouponUnavailableException(String code) {
        super("Coupon cannot be applied: " + code);
    }
}
