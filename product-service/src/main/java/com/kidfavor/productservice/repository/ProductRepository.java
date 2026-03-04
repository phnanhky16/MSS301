package com.kidfavor.productservice.repository;

import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.enums.EntityStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>,
    org.springframework.data.jpa.repository.JpaSpecificationExecutor<Product> {
    
    // Find by status (parameterized to prevent SQL injection)
    List<Product> findByStatus(EntityStatus status);
    
    Page<Product> findByStatus(EntityStatus status, Pageable pageable);
    
    // Find by ID and status
    Optional<Product> findByIdAndStatus(Long id, EntityStatus status);
    
    // Find by category and status
    List<Product> findByCategoryIdAndStatus(Long categoryId, EntityStatus status);
    
    // Find by brand and status
    List<Product> findByBrandIdAndStatus(Long brandId, EntityStatus status);
    
    // Search by name and status (parameterized query)
    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) AND p.status = :status")
    List<Product> searchByNameAndStatus(@Param("keyword") String keyword, @Param("status") EntityStatus status);

    /**
     * Retrieve all products and eagerly fetch brand/category associations.  This
     * is used during Elasticsearch synchronization to avoid LazyInitialization
     * exceptions outside of a transactional context.
     */
    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"category", "brand", "images"})
    @Query("SELECT p FROM Product p")
    List<Product> findAllWithRelations();

    /**
     * Retrieve products by a set of ids and eagerly fetch associations including
     * images.  This is useful when the service needs to hydrate entities that were
     * originally located via an external search index so that the returned
     * {@link com.kidfavor.productservice.dto.response.ProductResponse} includes the
     * image URLs instead of an empty list.
     */
    @org.springframework.data.jpa.repository.EntityGraph(attributePaths = {"category", "brand", "images"})
    @Query("SELECT p FROM Product p WHERE p.id IN :ids")
    List<Product> findByIdInWithRelations(@Param("ids") java.util.Collection<Long> ids);
    
    // Count products by brand and status (for validation)
    long countByBrandAndStatus(Brand brand, EntityStatus status);
}
