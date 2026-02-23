package com.kidfavor.productservice.repository;

import com.kidfavor.productservice.entity.Category;
import com.kidfavor.productservice.enums.EntityStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    // Find by status (parameterized to prevent SQL injection)
    List<Category> findByStatus(EntityStatus status);
    
    Page<Category> findByStatus(EntityStatus status, Pageable pageable);
    
    // Find by ID and status
    Optional<Category> findByIdAndStatus(Long id, EntityStatus status);
    
    // Find by name and status
    Optional<Category> findByNameAndStatus(String name, EntityStatus status);
    
    // Count categories by status (for validation)
    long countByStatus(EntityStatus status);
}
