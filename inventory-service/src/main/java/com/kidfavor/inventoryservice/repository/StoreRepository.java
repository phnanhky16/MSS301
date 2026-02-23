package com.kidfavor.inventoryservice.repository;

import com.kidfavor.inventoryservice.entity.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreRepository extends JpaRepository<Store, Long> {
    
    Optional<Store> findByStoreCode(String storeCode);
    
    List<Store> findByIsActive(Boolean isActive);
    
    List<Store> findByCity(String city);
    
    boolean existsByStoreCode(String storeCode);
}
