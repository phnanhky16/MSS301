package com.kidfavor.orderservice.service.impl;

import com.kidfavor.orderservice.client.ProductServiceClient;
import com.kidfavor.orderservice.client.UserServiceClient;
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
import lombok.RequiredArgsConstructor;
import com.kidfavor.orderservice.coupon.CouponService;
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
                .status(OrderStatus.PENDING)
                .shippingAddress(request.getShippingAddress())
                .phoneNumber(request.getPhoneNumber())
                .notes(request.getNotes())
                .items(new ArrayList<>())
                .build();

        // Step 3: Create order items with validated product data
        for (OrderItemRequest itemRequest : request.getItems()) {
            ProductDto product = validatedProducts.get(itemRequest.getProductId());
            
            OrderItem orderItem = OrderItem.builder()
                    .productId(product.getId())
                    .productName(product.getName())
                    .unitPrice(product.getPrice())
                    .quantity(itemRequest.getQuantity())
                    .subtotal(product.getPrice().multiply(BigDecimal.valueOf(itemRequest.getQuantity())))
                    .build();
            
            order.addItem(orderItem);
        }

        // Step 4: Calculate total amount
        order.calculateTotalAmount();

        // Step 4b: apply coupon if provided
        if (request.getCouponCode() != null && !request.getCouponCode().isBlank()) {
            BigDecimal discount = couponService.applyCoupon(request.getCouponCode(), order.getTotalAmount());
            order.setCouponCode(request.getCouponCode());
            order.setDiscountAmount(discount);
            // recalc after discount
            order.calculateTotalAmount();
        }

        // Step 5: Persist order atomically
        Order savedOrder = orderRepository.save(order);
        log.info("Order created successfully. Order ID: {}, Order Number: {}", 
                savedOrder.getId(), savedOrder.getOrderNumber());

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
            savedOrder.getDiscountAmount()
        ));

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

    /**
     * Validates all products in the order request and returns validated product data.
     * This method performs fail-fast validation before any order creation.
     */
    private Map<Long, ProductDto> validateAndFetchProducts(List<OrderItemRequest> items) {
        log.debug("Validating {} products for order", items.size());

        Map<Long, ProductDto> productMap = items.stream()
                .map(OrderItemRequest::getProductId)
                .distinct()
                .map(this::fetchAndValidateProduct)
                .collect(Collectors.toMap(ProductDto::getId, Function.identity()));

        // Validate stock for each item
        for (OrderItemRequest item : items) {
            ProductDto product = productMap.get(item.getProductId());
            validateStock(product, item.getQuantity());
        }

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
        ProductDto product = productServiceClient.getProductById(productId);
        
        // Null check phòng trường hợp response rỗng
        if (product == null) {
            throw new ProductNotFoundException(productId);
        }

        // Validate product is active
        if (product.getActive() == null || !product.getActive()) {
            throw new ProductInactiveException(productId);
        }

        return product;
    }

    /**
     * Validates that sufficient stock is available for the requested quantity.
     */
    private void validateStock(ProductDto product, Integer requestedQuantity) {
        Integer availableStock = product.getStock() != null ? product.getStock() : 0;
        
        if (availableStock < requestedQuantity) {
            throw new InsufficientStockException(
                    product.getId(), 
                    requestedQuantity, 
                    availableStock
            );
        }
    }

    /**
     * Validates that the user exists and is active. Returns the fetched UserDto.
     * Throws UserNotFoundException if user doesn't exist.
     * Throws UserServiceUnavailableException if User Service is down.
     * Throws UserInactiveException if user is inactive.
     */
    private UserDto validateUser(Long userId) {
        log.debug("Validating user: {}", userId);
        UserDto user = userServiceClient.getUserById(userId);

        if (user == null) {
            throw new UserNotFoundException(userId);
        }

        // Support both isActive and status fields from different UserResponse shapes
        boolean active = (user.getIsActive() != null && user.getIsActive())
                || (user.getStatus() != null && user.getStatus());
        if (!active) {
            throw new UserInactiveException(userId);
        }

        log.debug("User validated successfully: {}", userId);
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
                        .productName(item.getProductName())
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
