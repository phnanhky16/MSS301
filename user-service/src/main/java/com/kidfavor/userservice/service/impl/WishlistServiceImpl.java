package com.kidfavor.userservice.service.impl;

import com.kidfavor.userservice.dto.response.WishlistItemResponse;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.WishlistItem;
import com.kidfavor.userservice.repository.UserRepository;
import com.kidfavor.userservice.repository.WishlistRepository;
import com.kidfavor.userservice.service.WishlistService;
import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@FieldDefaults(level = AccessLevel.PRIVATE)
@Slf4j
public class WishlistServiceImpl implements WishlistService {

    final WishlistRepository wishlistRepository;
    final UserRepository userRepository;
    final RestTemplate restTemplate;

    @Value("${services.product-service.url:http://localhost:8083}")
    String productServiceUrl;

    public WishlistServiceImpl(WishlistRepository wishlistRepository,
                                UserRepository userRepository) {
        this.wishlistRepository = wishlistRepository;
        this.userRepository = userRepository;
        this.restTemplate = new RestTemplate();
    }

    @Override
    public List<WishlistItemResponse> getWishlist(String username) {
        User user = getUserByUsername(username);
        return wishlistRepository.findByUser(user)
                .stream()
                .map(item -> fetchProductDetails(item.getProductId(), item))
                .filter(r -> r != null)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public WishlistItemResponse addToWishlist(String username, Integer productId) {
        User user = getUserByUsername(username);

        if (wishlistRepository.existsByUserAndProductId(user, productId)) {
            WishlistItem existing = wishlistRepository
                    .findByUserAndProductId(user, productId).orElseThrow();
            return fetchProductDetails(productId, existing);
        }

        WishlistItem item = WishlistItem.builder()
                .user(user)
                .productId(productId)
                .build();

        WishlistItem saved = wishlistRepository.save(item);
        log.info("User {} added product {} to wishlist", username, productId);
        return fetchProductDetails(productId, saved);
    }

    @Override
    @Transactional
    public void removeFromWishlist(String username, Integer productId) {
        User user = getUserByUsername(username);
        if (!wishlistRepository.existsByUserAndProductId(user, productId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found in wishlist");
        }
        wishlistRepository.deleteByUserAndProductId(user, productId);
        log.info("User {} removed product {} from wishlist", username, productId);
    }

    // -----------------------------------------------------------------------
    // Helpers
    // -----------------------------------------------------------------------

    private User getUserByUsername(String username) {
        return userRepository.findByUserName(username)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "User not found: " + username));
    }

    /**
     * Calls product-service internal endpoint to fetch live product details.
     * Returns null if the product no longer exists.
     */
    @SuppressWarnings("unchecked")
    private WishlistItemResponse fetchProductDetails(Integer productId, WishlistItem item) {
        try {
            String url = productServiceUrl + "/internal/products/" + productId;
            log.info("Fetching product details from: {}", url);

            var response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<Map<String, Object>>() {}
            );

            Map<String, Object> body = response.getBody();
            if (body == null || !Boolean.TRUE.equals(body.get("success"))) {
                log.warn("Product {} not found or invalid response from product-service. Body: {}", productId, body);
                return null;
            }

            Map<String, Object> data = (Map<String, Object>) body.get("data");
            if (data == null) return null;

            Long id = null;
            Object rawId = data.get("id");
            if (rawId instanceof Number) id = ((Number) rawId).longValue();

            Double price = null;
            Object rawPrice = data.get("price");
            if (rawPrice instanceof Number) price = ((Number) rawPrice).doubleValue();

            Integer totalStock = null;
            Object rawStock = data.get("totalStock");
            if (rawStock instanceof Number) totalStock = ((Number) rawStock).intValue();

            List<String> imageUrls = null;
            Object rawImages = data.get("imageUrls");
            if (rawImages instanceof List) imageUrls = (List<String>) rawImages;

            return WishlistItemResponse.builder()
                    .id(id)
                    .name((String) data.get("name"))
                    .description((String) data.get("description"))
                    .price(price)
                    .imageUrls(imageUrls)
                    .category(data.get("category"))
                    .brand(data.get("brand"))
                    .totalStock(totalStock)
                    .addedAt(item.getAddedAt())
                    .build();

        } catch (Exception e) {
            log.error("Failed to fetch product {} from product-service (url={}): {}",
                    productId, productServiceUrl, e.getMessage());
            return null;
        }
    }
}
