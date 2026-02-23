package com.kidfavor.inventoryservice.repository;

import com.kidfavor.inventoryservice.entity.Warehouse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WarehouseRepository extends JpaRepository<Warehouse, Long> {
    
    Optional<Warehouse> findByWarehouseCode(String warehouseCode);
    
    List<Warehouse> findByIsActive(Boolean isActive);
    
    List<Warehouse> findByCity(String city);
    
    boolean existsByWarehouseCode(String warehouseCode);
}
