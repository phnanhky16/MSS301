package com.kidfavor.userservice.repository;

import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WishlistRepository extends JpaRepository<WishlistItem, Integer> {

    List<WishlistItem> findByUser(User user);

    Optional<WishlistItem> findByUserAndProductId(User user, Integer productId);

    void deleteByUserAndProductId(User user, Integer productId);

    boolean existsByUserAndProductId(User user, Integer productId);
}
