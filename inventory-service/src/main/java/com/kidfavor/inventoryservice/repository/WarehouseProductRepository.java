package com.kidfavor.inventoryservice.repository;

import com.kidfavor.inventoryservice.entity.Warehouse;
import com.kidfavor.inventoryservice.entity.WarehouseProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WarehouseProductRepository extends JpaRepository<WarehouseProduct, Long> {
    
    Optional<WarehouseProduct> findByWarehouseAndProductId(Warehouse warehouse, Long productId);
    
    List<WarehouseProduct> findByWarehouse(Warehouse warehouse);
    
    List<WarehouseProduct> findByProductId(Long productId);
    
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.warehouse.warehouseId = :warehouseId")
    List<WarehouseProduct> findByWarehouseId(@Param("warehouseId") Long warehouseId);
    
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.quantity < wp.minStockLevel")
    List<WarehouseProduct> findLowStockProducts();
    
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.warehouse.warehouseId = :warehouseId AND wp.quantity < wp.minStockLevel")
    List<WarehouseProduct> findLowStockProductsByWarehouse(@Param("warehouseId") Long warehouseId);
    
    // Out of stock products (quantity = 0)
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.quantity = 0")
    List<WarehouseProduct> findOutOfStockProducts();
    
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.warehouse.warehouseId = :warehouseId AND wp.quantity = 0")
    List<WarehouseProduct> findOutOfStockProductsByWarehouse(@Param("warehouseId") Long warehouseId);
    
    // In stock products (quantity >= minStockLevel)
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.quantity >= wp.minStockLevel")
    List<WarehouseProduct> findInStockProducts();
    
    @Query("SELECT wp FROM WarehouseProduct wp WHERE wp.warehouse.warehouseId = :warehouseId AND wp.quantity >= wp.minStockLevel")
    List<WarehouseProduct> findInStockProductsByWarehouse(@Param("warehouseId") Long warehouseId);
}
