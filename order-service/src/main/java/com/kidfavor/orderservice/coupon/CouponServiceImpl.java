package com.kidfavor.orderservice.coupon;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CouponServiceImpl implements CouponService {

    private final CouponRepository repository;

    @Override
    @Transactional
    public BigDecimal applyCoupon(String code, BigDecimal orderSubtotal) {
        Coupon coupon = repository.findByCode(code)
                .orElseThrow(() -> new CouponNotFoundException(code));

        if (!coupon.isUsable()) {
            throw new CouponUnavailableException(code);
        }

        BigDecimal discount;
        if (coupon.getDiscountType() == Coupon.DiscountType.PERCENT) {
            discount = orderSubtotal.multiply(coupon.getDiscountValue())
                    .divide(BigDecimal.valueOf(100));
        } else {
            discount = coupon.getDiscountValue();
        }

        // do not allow discount greater than subtotal
        if (discount.compareTo(orderSubtotal) > 0) {
            discount = orderSubtotal;
        }

        // increment redemption count
        coupon.setTimesRedeemed(coupon.getTimesRedeemed() + 1);
        repository.save(coupon);

        return discount;
    }

    @Override
    @Transactional
    public void deleteByCode(String code) {
        repository.findByCode(code).ifPresent(repository::delete);
    }

    @Override
    @Transactional(readOnly = true)
    public java.util.List<Coupon> listAll() {
        return repository.findAll();
    }

    @Override
    public Coupon save(Coupon coupon) {
        return repository.save(coupon);
    }

    @Override
    @Transactional(readOnly = true)
    public Coupon getByCode(String code) {
        return repository.findByCode(code)
                .orElseThrow(() -> new CouponNotFoundException(code));
    }
}
