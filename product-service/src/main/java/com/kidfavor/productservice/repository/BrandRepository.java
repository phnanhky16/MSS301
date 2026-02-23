package com.kidfavor.productservice.repository;

import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.enums.EntityStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BrandRepository extends JpaRepository<Brand, Long> {
    
    // Find by status (parameterized to prevent SQL injection)
    List<Brand> findByStatus(EntityStatus status);
    
    Page<Brand> findByStatus(EntityStatus status, Pageable pageable);
    
    // Find by ID and status
    Optional<Brand> findByIdAndStatus(Long id, EntityStatus status);
    
    // Find by name and status
    Optional<Brand> findByNameAndStatus(String name, EntityStatus status);
}
