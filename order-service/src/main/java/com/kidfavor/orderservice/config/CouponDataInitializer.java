package com.kidfavor.orderservice.config;

import com.kidfavor.orderservice.entity.Coupon;
import com.kidfavor.orderservice.service.CouponService;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;

/**
 * Inserts a batch of example coupons at startup when the database is empty.
 * This makes it easier to test search/filter behaviour without handcrafting
 * records each time.
 */
@Configuration
public class CouponDataInitializer {
    @Bean
    public ApplicationRunner initCoupons(CouponService service) {
        return args -> {
            long existing = service.listAll(org.springframework.data.domain.PageRequest.of(0, 1)).getTotalElements();
            int target = 50;
            if (existing >= target) {
                return; // enough data already
            }
            Random rng = new Random(1234);
            for (int i = (int)existing + 1; i <= target; i++) {
                Coupon c = Coupon.builder()
                        .code("CODE" + String.format("%03d", i))
                        .active(i % 3 != 0) // make every third inactive
                        .discountType(i % 2 == 0 ? Coupon.DiscountType.FIXED : Coupon.DiscountType.PERCENT)
                        .discountValue(BigDecimal.valueOf(rng.nextInt(50) + 1))
                        .expiresAt(LocalDateTime.now().plusDays(rng.nextInt(30)))
                        .maxRedemptions(100 + rng.nextInt(900))
                        .timesRedeemed(rng.nextInt(10))
                        .build();
                service.save(c);
            }
        };
    }
}