package com.kidfavor.orderservice.repository;

import com.kidfavor.orderservice.entity.OrderItem;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

    List<OrderItem> findByOrderId(Long orderId);

    List<OrderItem> findByProductId(Long productId);

    /**
     * Find best-selling product IDs ordered by total quantity sold (descending).
     * Returns List of Object[] where [0] = productId (Long), [1] = totalSold
     * (Long).
     */
    @Query("SELECT oi.productId, SUM(oi.quantity) as totalSold FROM OrderItem oi " +
            "GROUP BY oi.productId ORDER BY totalSold DESC")
    List<Object[]> findBestSellingProductIds(Pageable pageable);
}
