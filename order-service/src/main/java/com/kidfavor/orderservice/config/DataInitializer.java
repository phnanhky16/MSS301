package com.kidfavor.orderservice.config;

import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderItem;
import com.kidfavor.orderservice.entity.OrderStatus;
import com.kidfavor.orderservice.repository.OrderRepository;
import com.kidfavor.orderservice.entity.Coupon;
import com.kidfavor.orderservice.repository.CouponRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.UUID;

/**
 * Data initializer for Order Service.
 * Creates sample orders for testing purposes.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final OrderRepository orderRepository;
    private final CouponRepository couponRepository;

    @Override
    @Transactional
    public void run(String... args) {
        initSampleOrders();
        initSampleCoupons();
    }

    private void initSampleOrders() {
        // Check if orders already exist
        if (orderRepository.count() > 0) {
            log.info("Orders already exist, skipping initialization. Total orders: {}", orderRepository.count());
            return;
        }

        log.info("========================================");
        log.info("Initializing sample orders...");
        log.info("========================================");

        // Order 1 - Pending order
        Order order1 = createOrder(1L, OrderStatus.PENDING, "123 Main St, District 1, HCMC", "0901234567");
        addOrderItem(order1, 1L, "Baby Milk Powder Premium", new BigDecimal("450000"), 2);
        addOrderItem(order1, 2L, "Baby Diapers Pack (L)", new BigDecimal("320000"), 3);
        order1.calculateTotalAmount();
        orderRepository.save(order1);
        log.info("Created Order 1: {} - Status: {} - Total: {}", order1.getOrderNumber(), order1.getStatus(), order1.getTotalAmount());

        // Order 2 - Confirmed order
        Order order2 = createOrder(1L, OrderStatus.CONFIRMED, "456 Le Loi St, District 3, HCMC", "0901234567");
        addOrderItem(order2, 3L, "Baby Formula Stage 2", new BigDecimal("380000"), 1);
        addOrderItem(order2, 4L, "Baby Wipes 80pcs", new BigDecimal("85000"), 4);
        addOrderItem(order2, 5L, "Baby Bottle 250ml", new BigDecimal("120000"), 2);
        order2.calculateTotalAmount();
        orderRepository.save(order2);
        log.info("Created Order 2: {} - Status: {} - Total: {}", order2.getOrderNumber(), order2.getStatus(), order2.getTotalAmount());

        // Order 3 - Processing order
        Order order3 = createOrder(2L, OrderStatus.PROCESSING, "789 Nguyen Hue St, District 1, HCMC", "0912345678");
        addOrderItem(order3, 1L, "Baby Milk Powder Premium", new BigDecimal("450000"), 1);
        addOrderItem(order3, 6L, "Baby Lotion 200ml", new BigDecimal("150000"), 2);
        order3.calculateTotalAmount();
        orderRepository.save(order3);
        log.info("Created Order 3: {} - Status: {} - Total: {}", order3.getOrderNumber(), order3.getStatus(), order3.getTotalAmount());

        // Order 4 - Shipped order
        Order order4 = createOrder(2L, OrderStatus.SHIPPED, "101 Tran Hung Dao St, District 5, HCMC", "0912345678");
        addOrderItem(order4, 7L, "Baby Shampoo 250ml", new BigDecimal("95000"), 1);
        addOrderItem(order4, 8L, "Baby Toy Set", new BigDecimal("250000"), 1);
        order4.calculateTotalAmount();
        orderRepository.save(order4);
        log.info("Created Order 4: {} - Status: {} - Total: {}", order4.getOrderNumber(), order4.getStatus(), order4.getTotalAmount());

        // Order 5 - Delivered order
        Order order5 = createOrder(3L, OrderStatus.DELIVERED, "202 Vo Van Tan St, District 3, HCMC", "0923456789");
        addOrderItem(order5, 2L, "Baby Diapers Pack (L)", new BigDecimal("320000"), 5);
        addOrderItem(order5, 4L, "Baby Wipes 80pcs", new BigDecimal("85000"), 6);
        addOrderItem(order5, 9L, "Baby Blanket", new BigDecimal("180000"), 1);
        order5.calculateTotalAmount();
        orderRepository.save(order5);
        log.info("Created Order 5: {} - Status: {} - Total: {}", order5.getOrderNumber(), order5.getStatus(), order5.getTotalAmount());

        // Order 6 - Cancelled order
        Order order6 = createOrder(3L, OrderStatus.CANCELLED, "303 Hai Ba Trung St, District 1, HCMC", "0923456789");
        addOrderItem(order6, 10L, "Baby Stroller", new BigDecimal("2500000"), 1);
        order6.calculateTotalAmount();
        orderRepository.save(order6);
        log.info("Created Order 6: {} - Status: {} - Total: {}", order6.getOrderNumber(), order6.getStatus(), order6.getTotalAmount());

        // Order 7 - Large order
        Order order7 = createOrder(4L, OrderStatus.PENDING, "404 Pham Ngu Lao St, District 1, HCMC", "0934567890");
        addOrderItem(order7, 1L, "Baby Milk Powder Premium", new BigDecimal("450000"), 4);
        addOrderItem(order7, 2L, "Baby Diapers Pack (L)", new BigDecimal("320000"), 6);
        addOrderItem(order7, 3L, "Baby Formula Stage 2", new BigDecimal("380000"), 2);
        addOrderItem(order7, 4L, "Baby Wipes 80pcs", new BigDecimal("85000"), 10);
        addOrderItem(order7, 5L, "Baby Bottle 250ml", new BigDecimal("120000"), 4);
        order7.calculateTotalAmount();
        orderRepository.save(order7);
        log.info("Created Order 7: {} - Status: {} - Total: {}", order7.getOrderNumber(), order7.getStatus(), order7.getTotalAmount());

        log.info("========================================");
        log.info("Sample orders initialized successfully!");
        log.info("Total orders created: {}", orderRepository.count());
        log.info("========================================");
    }

    private void initSampleCoupons() {
        if (couponRepository.count() > 0) {
            log.info("Coupons already exist, skipping coupon initialization.");
            return;
        }

        log.info("Initializing sample coupons...");

        Coupon c1 = Coupon.builder()
                .code("SPRING10")
                .active(true)
                .discountType(Coupon.DiscountType.PERCENT)
                .discountValue(BigDecimal.valueOf(10))
                .expiresAt(LocalDateTime.now().plusMonths(3))
                .maxRedemptions(100)
                .build();

        Coupon c2 = Coupon.builder()
                .code("FLAT50")
                .active(true)
                .discountType(Coupon.DiscountType.FIXED)
                .discountValue(BigDecimal.valueOf(50))
                .expiresAt(LocalDateTime.now().plusMonths(1))
                .maxRedemptions(50)
                .build();

        couponRepository.save(c1);
        couponRepository.save(c2);

        log.info("Created sample coupons: {}, {}", c1.getCode(), c2.getCode());
    }
    private Order createOrder(Long userId, OrderStatus status, String shippingAddress, String phoneNumber) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String uniqueId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        return Order.builder()
                .orderNumber("ORD-" + timestamp + "-" + uniqueId)
                .userId(userId)
                .status(status)
                .shippingAddress(shippingAddress)
                .phoneNumber(phoneNumber)
                .notes("Sample order for testing")
                .items(new ArrayList<>())
                .build();
    }

    private void addOrderItem(Order order, Long productId, String productName, BigDecimal unitPrice, Integer quantity) {
        OrderItem item = OrderItem.builder()
                .productId(productId)
                .productName(productName)
                .unitPrice(unitPrice)
                .quantity(quantity)
                .subtotal(unitPrice.multiply(BigDecimal.valueOf(quantity)))
                .build();
        order.addItem(item);
    }
}
