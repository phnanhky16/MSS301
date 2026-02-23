package com.kidfavor.orderservice.controller;

import com.kidfavor.orderservice.dto.request.CouponRequest;
import com.kidfavor.orderservice.dto.response.CouponResponse;
import com.kidfavor.orderservice.entity.Coupon;
import com.kidfavor.orderservice.service.CouponService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
// Gateway already prefixes requests with /api; downstream services should
// expose paths relative to their own context. Using "/api" here caused
// requests forwarded by the gateway to land at /coupons, which didn’t match
// the mapping and resulted in a 500. Removing the prefix fixes routing.
@RequestMapping("/coupons")
@RequiredArgsConstructor
public class CouponController {

    private final CouponService couponService;

    @PostMapping
    public ResponseEntity<CouponResponse> createOrUpdate(@Validated @RequestBody CouponRequest request) {
        Coupon coupon = Coupon.builder()
                .id(null)
                .code(request.getCode())
                .active(request.getActive())
                .discountType(request.getDiscountType())
                .discountValue(request.getDiscountValue())
                .expiresAt(request.getExpiresAt())
                .maxRedemptions(request.getMaxRedemptions())
                .build();
        Coupon saved = couponService.save(coupon);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(toResponse(saved));
    }

    @PutMapping("/{code}")
    public ResponseEntity<CouponResponse> update(
            @PathVariable String code,
            @Validated @RequestBody CouponRequest request) {
        Coupon existing = couponService.getByCode(code);
        // update allowed fields
        log.debug("Updating coupon code from {} to {}", existing.getCode(), request.getCode());
        // code may be changed by admin as well
        existing.setCode(request.getCode());
        existing.setActive(request.getActive());
        existing.setDiscountType(request.getDiscountType());
        existing.setDiscountValue(request.getDiscountValue());
        existing.setExpiresAt(request.getExpiresAt());
        existing.setMaxRedemptions(request.getMaxRedemptions());
        Coupon saved = couponService.save(existing);
        log.debug("Saved coupon, resulting code {}", saved.getCode());
        return ResponseEntity.ok(toResponse(saved));
    }

    @DeleteMapping("/{code}")
    public ResponseEntity<Void> delete(@PathVariable String code) {
        couponService.deleteByCode(code);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public org.springframework.data.domain.Page<CouponResponse> list(org.springframework.data.domain.Pageable pageable) {
        return couponService.listAll(pageable)
                .map(this::toResponse);
    }

    @GetMapping("/{code}")
    public CouponResponse getByCode(@PathVariable String code) {
        return toResponse(couponService.getByCode(code));
    }

    private CouponResponse toResponse(Coupon c) {
        return CouponResponse.builder()
                .id(c.getId())
                .code(c.getCode())
                .discountType(c.getDiscountType())
                .discountValue(c.getDiscountValue())
                .expiresAt(c.getExpiresAt())
                .maxRedemptions(c.getMaxRedemptions())
                .timesRedeemed(c.getTimesRedeemed())
                .active(c.isActive())
                .build();
    }
}
