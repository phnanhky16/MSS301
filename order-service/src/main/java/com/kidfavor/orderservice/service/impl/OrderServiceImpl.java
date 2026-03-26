package com.kidfavor.orderservice.service.impl;

import com.kidfavor.orderservice.client.ProductServiceClient;
import com.kidfavor.orderservice.client.UserServiceClient;
import com.kidfavor.orderservice.client.dto.ApiResponse;
import com.kidfavor.orderservice.client.dto.EntityStatus;
import com.kidfavor.orderservice.client.dto.ProductDto;
import com.kidfavor.orderservice.client.dto.UserDto;
import com.kidfavor.orderservice.dto.request.CreateOrderRequest;
import com.kidfavor.orderservice.dto.request.OrderItemRequest;
import com.kidfavor.orderservice.dto.response.OrderItemResponse;
import com.kidfavor.orderservice.dto.response.OrderResponse;
import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderItem;
import com.kidfavor.orderservice.entity.OrderStatus;
import com.kidfavor.orderservice.event.OrderCreatedDomainEvent;
import com.kidfavor.orderservice.exception.*;
import com.kidfavor.orderservice.repository.OrderRepository;
import com.kidfavor.orderservice.service.OrderService;
import com.kidfavor.orderservice.service.LocationBasedOrderService;

import lombok.RequiredArgsConstructor;
import com.kidfavor.orderservice.service.CouponService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Implementation of OrderService.
 * Handles order creation with product validation and event publishing.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final ProductServiceClient productServiceClient;
    private final UserServiceClient userServiceClient;
    private final ApplicationEventPublisher eventPublisher;
    private final CouponService couponService;
    private final LocationBasedOrderService locationBasedOrderService;

    @Override
    @Transactional
    public OrderResponse createOrder(CreateOrderRequest request) {
        log.info("Creating order for user: {}", request.getUserId());

        // Step 1: Validate user exists and is active
        UserDto user = validateUser(request.getUserId());

        // Step 2: Validate all products BEFORE creating the order
        Map<Long, ProductDto> validatedProducts = validateAndFetchProducts(request.getItems());

        // Step 3: Create order entity
        Order order = Order.builder()
                .orderNumber(generateOrderNumber())
                .userId(request.getUserId())
                .storeId(request.getStoreId()) // set for POS orders; null for GPS-based orders
                .status(OrderStatus.PENDING)
                .shippingAddress(request.getShippingAddress())
                .phoneNumber(request.getPhoneNumber())
                .notes(request.getNotes())
                .items(new ArrayList<>())
                .build();

        // Step 3: Create order items with validated product data
        for (OrderItemRequest itemRequest : request.getItems()) {
            ProductDto product = validatedProducts.get(itemRequest.getProductId());

            BigDecimal effectivePrice = product.getPrice();
            if (product.getOnSale() != null && product.getOnSale() && product.getSalePrice() != null) {
                effectivePrice = product.getSalePrice();
            }

            OrderItem orderItem = OrderItem.builder()
                    .productId(product.getId())
                    .productName(product.getName())
                    .productImageUrl(product.getImageUrl())
                    .unitPrice(effectivePrice)
                    .quantity(itemRequest.getQuantity())
                    .subtotal(effectivePrice.multiply(BigDecimal.valueOf(itemRequest.getQuantity())))
                    .build();

            order.addItem(orderItem);
        }

        // Step 4: Calculate total amount
        order.calculateTotalAmount();

        // Step 4b: apply coupon if provided (skip if null, empty, or "string" default
        // value)
        if (request.getCouponCode() != null
                && !request.getCouponCode().isBlank()
                && !request.getCouponCode().equalsIgnoreCase("string")) {
            try {
                BigDecimal discount = couponService.applyCoupon(request.getCouponCode(), order.getTotalAmount());
                order.setCouponCode(request.getCouponCode());
                order.setDiscountAmount(discount);
                // recalc after discount
                order.calculateTotalAmount();
                log.info("Coupon {} applied successfully. Discount: {}", request.getCouponCode(), discount);
            } catch (Exception e) {
                log.warn("Failed to apply coupon {}: {}. Order will proceed without discount.",
                        request.getCouponCode(), e.getMessage());
                // Continue without coupon - don't fail the order
            }
        }

        // Step 5: Persist order atomically
        Order savedOrder = orderRepository.save(order);
        log.info("Order created successfully. Order ID: {}, Order Number: {}",
                savedOrder.getId(), savedOrder.getOrderNumber());

        // Step 5.5: Process location-based order (geocoding + inventory allocation)
        boolean isPOSOrder = request.getStoreId() != null;
        boolean hasAddress = savedOrder.getShippingAddress() != null && !savedOrder.getShippingAddress().isBlank();
        if (isPOSOrder || hasAddress) {
            try {
                log.info(isPOSOrder
                    ? "🛒 Processing POS order for store {}: {}"
                    : "🌍 Processing location-based order for: {}",
                    isPOSOrder ? savedOrder.getStoreId() : "", savedOrder.getOrderNumber());
                locationBasedOrderService.processOrder(savedOrder);
                savedOrder = orderRepository.save(savedOrder);
                log.info("✅ Order processing completed for: {}", savedOrder.getOrderNumber());
            } catch (Exception e) {
                log.error("❌ Order processing failed for {}: {}", savedOrder.getOrderNumber(), e.getMessage(), e);
                // Continue - order is already saved, location/inventory data is optional for delivery recalc
            }
        }

        // Step 6: Publish domain event (will be sent to Kafka AFTER_COMMIT)
        String customerEmail = user.getEmail();
        String customerName = user.getFullName() != null ? user.getFullName()
                : (user.getFirstName() != null ? user.getFirstName() + " " + user.getLastName() : user.getUsername());
        eventPublisher.publishEvent(new OrderCreatedDomainEvent(
                this,
                savedOrder,
                customerEmail,
                customerName,
                savedOrder.getCouponCode(),
                savedOrder.getDiscountAmount()));

        return mapToOrderResponse(savedOrder);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderResponse getOrderById(Long orderId) {
        log.debug("Fetching order by ID: {}", orderId);
        Order order = orderRepository.findByIdWithItems(orderId)
                .orElseThrow(() -> new OrderNotFoundException(orderId));
        return mapToOrderResponse(order);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderResponse getOrderByOrderNumber(String orderNumber) {
        log.debug("Fetching order by order number: {}", orderNumber);
        Order order = orderRepository.findByOrderNumber(orderNumber)
                .orElseThrow(() -> new OrderNotFoundException("Order not found with order number: " + orderNumber));
        return mapToOrderResponse(order);
    }

    @Override
    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByUserId(Long userId) {
        log.debug("Fetching orders for user: {}", userId);
        return orderRepository.findByUserId(userId).stream()
                .map(this::mapToOrderResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByStatus(OrderStatus status) {
        log.debug("Fetching orders by status: {}", status);
        return orderRepository.findByStatus(status).stream()
                .map(this::mapToOrderResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public OrderResponse updateOrderStatus(Long orderId, OrderStatus status) {
        log.info("Updating order {} status to {}", orderId, status);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new OrderNotFoundException(orderId));

        validateStatusTransition(order.getStatus(), status);
        order.setStatus(status);

        Order updatedOrder = orderRepository.save(order);
        log.info("Order {} status updated to {}", orderId, status);

        return mapToOrderResponse(updatedOrder);
    }

    @Override
    @Transactional
    public OrderResponse cancelOrder(Long orderId) {
        log.info("Cancelling order: {}", orderId);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new OrderNotFoundException(orderId));

        if (!canBeCancelled(order.getStatus())) {
            throw new IllegalArgumentException(
                    "Order cannot be cancelled. Current status: " + order.getStatus());
        }

        order.setStatus(OrderStatus.CANCELLED);
        Order cancelledOrder = orderRepository.save(order);
        log.info("Order {} cancelled successfully", orderId);

        return mapToOrderResponse(cancelledOrder);
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<OrderResponse> listAll(
            org.springframework.data.domain.Pageable pageable) {
        // simply delegate to repository paging and convert entities to DTO
        return orderRepository.findAll(pageable)
                .map(this::mapToOrderResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<OrderResponse> searchOrders(
            org.springframework.data.domain.Pageable pageable,
            String orderNumber,
            java.math.BigDecimal minTotal,
            java.math.BigDecimal maxTotal,
            java.time.LocalDateTime startDate,
            java.time.LocalDateTime endDate,
            OrderStatus status) {
        // Build a dynamic Specification to avoid JPQL null/typing problems.
        org.springframework.data.jpa.domain.Specification<Order> spec = (root, query, cb) -> {
            java.util.List<jakarta.persistence.criteria.Predicate> preds = new java.util.ArrayList<>();
            if (orderNumber != null && !orderNumber.isEmpty()) {
                preds.add(cb.like(root.get("orderNumber"), "%" + orderNumber + "%"));
            }
            if (minTotal != null) {
                preds.add(cb.ge(root.get("totalAmount"), minTotal));
            }
            if (maxTotal != null) {
                preds.add(cb.le(root.get("totalAmount"), maxTotal));
            }
            if (startDate != null) {
                preds.add(cb.greaterThanOrEqualTo(root.get("createdAt"), startDate));
            }
            if (endDate != null) {
                preds.add(cb.lessThanOrEqualTo(root.get("createdAt"), endDate));
            }
            if (status != null) {
                preds.add(cb.equal(root.get("status"), status));
            }
            return preds.isEmpty() ? null : cb.and(preds.toArray(new jakarta.persistence.criteria.Predicate[0]));
        };
        return orderRepository.findAll(spec, pageable)
                .map(this::mapToOrderResponse);
    }

    @Override
    public long countOrders() {
        return orderRepository.count();
    }

    @Override
    public java.util.Map<OrderStatus, Long> countByStatus() {
        java.util.Map<OrderStatus, Long> map = new java.util.EnumMap<>(OrderStatus.class);
        for (OrderStatus status : OrderStatus.values()) {
            map.put(status, orderRepository.countByStatus(status));
        }
        return map;
    }

    @Override
    public java.math.BigDecimal totalRevenue() {
        return orderRepository.sumTotalAmount();
    }

    /**
     * Validates all products in the order request and returns validated product
     * data.
     * This method performs fail-fast validation before any order creation.
     */
    private Map<Long, ProductDto> validateAndFetchProducts(List<OrderItemRequest> items) {
        log.debug("Validating {} products for order", items.size());

        Map<Long, ProductDto> productMap = items.stream()
                .map(OrderItemRequest::getProductId)
                .distinct()
                .map(this::fetchAndValidateProduct)
                .collect(Collectors.toMap(ProductDto::getId, Function.identity()));

        // TODO: Stock validation should be done via inventory-service
        // Validate stock for each item
        // for (OrderItemRequest item : items) {
        // ProductDto product = productMap.get(item.getProductId());
        // validateStock(product, item.getQuantity());
        // }

        log.debug("All products validated successfully");
        return productMap;
    }

    /**
     * Fetches a product from Product Service and validates its availability.
     * Throws ProductNotFoundException if product doesn't exist.
     * Throws ProductServiceUnavailableException if Product Service is down.
     */
    private ProductDto fetchAndValidateProduct(Long productId) {
        log.debug("Fetching product: {}", productId);

        // ProductServiceClient sẽ throw exception nếu:
        // - Product Service không available -> ProductServiceUnavailableException
        // - Product không tồn tại -> ProductNotFoundException (từ ErrorDecoder)
        ApiResponse<ProductDto> response = productServiceClient.getProductById(productId);

        // Validate response
        if (response == null || response.getData() == null) {
            throw new ProductNotFoundException(productId);
        }

        ProductDto product = response.getData();

        // Validate product is active
        if (product.getStatus() == null || product.getStatus() != EntityStatus.ACTIVE) {
            throw new ProductInactiveException(productId);
        }
        return product;
    }

    /**
     * Validates that sufficient stock is available for the requested quantity.
     * TODO: This should call inventory-service instead of checking product stock
     */
    // private void validateStock(ProductDto product, Integer requestedQuantity) {
    // Integer availableStock = product.getStock() != null ? product.getStock() : 0;
    //
    // if (availableStock < requestedQuantity) {
    // throw new InsufficientStockException(
    // product.getId(),
    // requestedQuantity,
    // availableStock
    // );
    // }
    // }

    /**
     * Validates that the user exists and is active. Returns the fetched UserDto.
     * Throws UserNotFoundException if user doesn't exist.
     * Throws UserServiceUnavailableException if User Service is down.
     * Throws UserInactiveException if user is inactive.
     */
    private UserDto validateUser(Long userId) {
        log.debug("Validating user: {}", userId);
        com.kidfavor.orderservice.client.dto.ApiResponse<UserDto> response = userServiceClient.getUserById(userId);

        if (response == null || response.getData() == null) {
            throw new UserNotFoundException(userId);
        }

        UserDto user = response.getData();

        // Support both isActive and status fields from different UserResponse shapes
        boolean active = (user.getIsActive() != null && user.getIsActive())
                || (user.getStatus() != null && user.getStatus());
        if (!active) {
            throw new UserInactiveException(userId);
        }

        log.debug("User validated successfully: {} (email: {})", userId, user.getEmail());
        return user;
    }

    /**
     * Generates a unique order number.
     */
    private String generateOrderNumber() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String uniqueId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return "ORD-" + timestamp + "-" + uniqueId;
    }

    /**
     * Validates that the status transition is allowed.
     */
    private void validateStatusTransition(OrderStatus currentStatus, OrderStatus newStatus) {
        // Define valid transitions
        if (currentStatus == OrderStatus.CANCELLED || currentStatus == OrderStatus.REFUNDED) {
            throw new IllegalArgumentException(
                    "Cannot change status of a " + currentStatus + " order");
        }

        if (currentStatus == OrderStatus.DELIVERED && newStatus != OrderStatus.REFUNDED) {
            throw new IllegalArgumentException(
                    "Delivered orders can only be transitioned to REFUNDED status");
        }
    }

    /**
     * Checks if an order can be cancelled based on its current status.
     */
    private boolean canBeCancelled(OrderStatus status) {
        return status == OrderStatus.PENDING || status == OrderStatus.CONFIRMED;
    }

    /**
     * Maps Order entity to OrderResponse DTO.
     */
    private OrderResponse mapToOrderResponse(Order order) {
        List<OrderItemResponse> itemResponses = order.getItems().stream()
                .map(item -> OrderItemResponse.builder()
                        .id(item.getId())
                        .productId(item.getProductId())
                        .storeId(item.getStoreId())
                        .productName(item.getProductName())
                        .productImageUrl(item.getProductImageUrl())
                        .unitPrice(item.getUnitPrice())
                        .quantity(item.getQuantity())
                        .subtotal(item.getSubtotal())
                        .build())
                .collect(Collectors.toList());

        return OrderResponse.builder()
                .id(order.getId())
                .orderNumber(order.getOrderNumber())
                .userId(order.getUserId())
                .status(order.getStatus())
                .totalAmount(order.getTotalAmount())
                .shippingAddress(order.getShippingAddress())
                .storeId(order.getStoreId())
                .shippingLatitude(order.getShippingLatitude())
                .shippingLongitude(order.getShippingLongitude())
                .shipmentId(order.getShipmentId())
                .phoneNumber(order.getPhoneNumber())
                .notes(order.getNotes())
                .items(itemResponses)
                .couponCode(order.getCouponCode())
                .discountAmount(order.getDiscountAmount())
                .createdAt(order.getCreatedAt())
                .updatedAt(order.getUpdatedAt())
                .build();
    }
}
