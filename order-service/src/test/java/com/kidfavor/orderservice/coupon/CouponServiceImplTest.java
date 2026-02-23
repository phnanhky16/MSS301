package com.kidfavor.orderservice.coupon;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

class CouponServiceImplTest {

    private CouponRepository repo;
    private CouponServiceImpl service;

    @BeforeEach
    void setup() {
        repo = Mockito.mock(CouponRepository.class);
        service = new CouponServiceImpl(repo);
    }

    @Test
    void applyPercentCoupon() {
        Coupon c = Coupon.builder()
                .code("PERCENT10")
                .active(true)
                .discountType(Coupon.DiscountType.PERCENT)
                .discountValue(BigDecimal.TEN)
                .build();
        when(repo.findByCode("PERCENT10")).thenReturn(Optional.of(c));
        when(repo.save(any())).thenAnswer(i -> i.getArgument(0));

        BigDecimal discount = service.applyCoupon("PERCENT10", BigDecimal.valueOf(200));
        // use compareTo to ignore scale differences
        assertEquals(0, discount.compareTo(BigDecimal.valueOf(20)), "discount should be 20");
        assertEquals(1, c.getTimesRedeemed());
    }

    @Test
    void applyFixedCoupon() {
        Coupon c = Coupon.builder()
                .code("FIX50")
                .active(true)
                .discountType(Coupon.DiscountType.FIXED)
                .discountValue(BigDecimal.valueOf(50))
                .build();
        when(repo.findByCode("FIX50")).thenReturn(Optional.of(c));
        when(repo.save(any())).thenAnswer(i -> i.getArgument(0));

        BigDecimal discount = service.applyCoupon("FIX50", BigDecimal.valueOf(200));
        assertEquals(0, discount.compareTo(BigDecimal.valueOf(50)), "discount should equal fixed value");
    }

    @Test
    void couponNotFound() {
        when(repo.findByCode(anyString())).thenReturn(Optional.empty());
        assertThrows(CouponNotFoundException.class,
                () -> service.applyCoupon("NONE", BigDecimal.ONE));
    }

    @Test
    void deleteCoupon() {
        Coupon c = Coupon.builder().code("X").build();
        when(repo.findByCode("X")).thenReturn(Optional.of(c));
        service.deleteByCode("X");
        verify(repo).delete(c);
    }

    @Test
    void listAllReturnsAll() {
        Coupon c = Coupon.builder().code("Y").build();
        when(repo.findAll()).thenReturn(java.util.List.of(c));
        var list = service.listAll();
        assertEquals(1, list.size());
    }

    @Test
    void listAllPaged() {
        Coupon c1 = Coupon.builder().code("A").build();
        Coupon c2 = Coupon.builder().code("B").build();
        Page<Coupon> pageMock = new PageImpl<>(java.util.List.of(c1, c2));
        when(repo.findAll(any(Pageable.class))).thenReturn(pageMock);

        Page<Coupon> result = service.listAll(PageRequest.of(0, 10));
        assertEquals(2, result.getTotalElements());
        assertEquals(2, result.getContent().size());
    }
}
