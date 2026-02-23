package com.kidfavor.orderservice.coupon;

import com.kidfavor.orderservice.coupon.dto.CouponRequest;
import com.kidfavor.orderservice.coupon.dto.CouponResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/coupons")
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
        existing.setActive(request.getActive());
        existing.setDiscountType(request.getDiscountType());
        existing.setDiscountValue(request.getDiscountValue());
        existing.setExpiresAt(request.getExpiresAt());
        existing.setMaxRedemptions(request.getMaxRedemptions());
        Coupon saved = couponService.save(existing);
        return ResponseEntity.ok(toResponse(saved));
    }

    @DeleteMapping("/{code}")
    public ResponseEntity<Void> delete(@PathVariable String code) {
        couponService.deleteByCode(code);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public java.util.List<CouponResponse> list() {
        return couponService.listAll().stream()
                .map(this::toResponse)
                .toList();
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
