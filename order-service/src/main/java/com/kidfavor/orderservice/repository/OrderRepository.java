package com.kidfavor.orderservice.repository;

import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long>,
    org.springframework.data.jpa.repository.JpaSpecificationExecutor<Order> {

    Optional<Order> findByOrderNumber(String orderNumber);

    List<Order> findByUserId(Long userId);

    List<Order> findByUserIdAndStatus(Long userId, OrderStatus status);

    List<Order> findByStatus(OrderStatus status);

    @Query("SELECT o FROM Order o WHERE o.createdAt BETWEEN :startDate AND :endDate")
    List<Order> findOrdersByDateRange(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );

        /**
         * Flexible search with optional criteria. null parameters are ignored.
         * Pageable makes sorting by createdAt or totalAmount trivial.
         */
                // use CAST(...) to give the database a concrete type for null values
                @Query("SELECT o FROM Order o " +
                    "WHERE (:orderNumber IS NULL OR o.orderNumber LIKE CONCAT('%',:orderNumber,'%')) " +
                    "AND (:minTotal IS NULL OR o.totalAmount >= :minTotal) " +
                    "AND (:maxTotal IS NULL OR o.totalAmount <= :maxTotal) " +
                    "AND (CAST(:startDate AS timestamp) IS NULL OR o.createdAt >= CAST(:startDate AS timestamp)) " +
                    "AND (CAST(:endDate AS timestamp) IS NULL OR o.createdAt <= CAST(:endDate AS timestamp))")
        org.springframework.data.domain.Page<Order> findFiltered(
            @Param("orderNumber") String orderNumber,
            @Param("minTotal") java.math.BigDecimal minTotal,
            @Param("maxTotal") java.math.BigDecimal maxTotal,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            org.springframework.data.domain.Pageable pageable
        );

    @Query("SELECT o FROM Order o LEFT JOIN FETCH o.items WHERE o.id = :id")
    Optional<Order> findByIdWithItems(@Param("id") Long id);

    boolean existsByOrderNumber(String orderNumber);

    // counts by status for dashboard
    long countByStatus(OrderStatus status);

    // total revenue across all orders
    @Query("SELECT COALESCE(SUM(o.totalAmount),0) FROM Order o")
    java.math.BigDecimal sumTotalAmount();
}
