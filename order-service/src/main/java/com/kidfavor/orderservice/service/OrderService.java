package com.kidfavor.orderservice.service;

import com.kidfavor.orderservice.dto.request.CreateOrderRequest;
import com.kidfavor.orderservice.dto.response.OrderResponse;
import com.kidfavor.orderservice.entity.OrderStatus;

import java.util.List;

/**
 * Service interface for order operations.
 */
public interface OrderService {

    /**
     * Creates a new order after validating product availability.
     * Publishes OrderPlacedEvent to Kafka after successful creation.
     *
     * @param request the order creation request
     * @return the created order response
     */
    OrderResponse createOrder(CreateOrderRequest request);

    /**
     * Retrieves an order by its ID.
     *
     * @param orderId the order ID
     * @return the order response
     */
    OrderResponse getOrderById(Long orderId);

    /**
     * Retrieves an order by its order number.
     *
     * @param orderNumber the order number
     * @return the order response
     */
    OrderResponse getOrderByOrderNumber(String orderNumber);

    /**
     * Retrieves all orders for a specific user.
     *
     * @param userId the user ID
     * @return list of order responses
     */
    List<OrderResponse> getOrdersByUserId(Long userId);

    /**
     * Retrieves orders by status.
     *
     * @param status the order status
     * @return list of order responses
     */
    List<OrderResponse> getOrdersByStatus(OrderStatus status);

    /**
     * Updates the status of an order.
     *
     * @param orderId the order ID
     * @param status the new status
     * @return the updated order response
     */
    OrderResponse updateOrderStatus(Long orderId, OrderStatus status);

    /**
     * Cancels an order if it's still in a cancellable state.
     *
     * @param orderId the order ID
     * @return the cancelled order response
     */
    OrderResponse cancelOrder(Long orderId);

    /**
     * Retrieves all orders in a paged fashion for administrative listing.
     */
    org.springframework.data.domain.Page<OrderResponse> listAll(org.springframework.data.domain.Pageable pageable);

        /**
         * Search orders by various optional criteria; used by UI filtering.
         */
            org.springframework.data.domain.Page<OrderResponse> searchOrders(
                org.springframework.data.domain.Pageable pageable,
                String orderNumber,
                java.math.BigDecimal minTotal,
                java.math.BigDecimal maxTotal,
                java.time.LocalDateTime startDate,
                java.time.LocalDateTime endDate,
                OrderStatus status
            );
        /**
         * Total number of orders in the system.
         */
        long countOrders();

        /**
         * Counts orders grouped by status.
         */
        java.util.Map<OrderStatus, Long> countByStatus();

        /**
         * Sum of all order totals (revenue).
         */
        java.math.BigDecimal totalRevenue();
}
