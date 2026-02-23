package com.kidfavor.inventoryservice.repository;

import com.kidfavor.inventoryservice.entity.Store;
import com.kidfavor.inventoryservice.entity.StoreInventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreInventoryRepository extends JpaRepository<StoreInventory, Long> {
    
    Optional<StoreInventory> findByStoreAndProductId(Store store, Long productId);
    
    List<StoreInventory> findByStore(Store store);
    
    List<StoreInventory> findByProductId(Long productId);
    
    @Query("SELECT si FROM StoreInventory si WHERE si.store.storeId = :storeId")
    List<StoreInventory> findByStoreId(@Param("storeId") Long storeId);
    
    @Query("SELECT si FROM StoreInventory si WHERE si.quantity < si.minStockLevel")
    List<StoreInventory> findLowStockProducts();
    
    @Query("SELECT si FROM StoreInventory si WHERE si.store.storeId = :storeId AND si.quantity < si.minStockLevel")
    List<StoreInventory> findLowStockProductsByStore(@Param("storeId") Long storeId);
}
