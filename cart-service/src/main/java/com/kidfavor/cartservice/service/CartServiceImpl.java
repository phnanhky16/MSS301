package com.kidfavor.cartservice.service;

import com.kidfavor.cartservice.client.ProductClient;
import com.kidfavor.cartservice.dto.*;
import com.kidfavor.cartservice.entity.Cart;
import com.kidfavor.cartservice.entity.CartItem;
import com.kidfavor.cartservice.repository.CartItemRepository;
import com.kidfavor.cartservice.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductClient productClient;

    @Override
    @Transactional
    @Cacheable(value = "carts", key = "#userId")
    public CartResponse getCartByUserId(Long userId) {
        log.info("Fetching cart from database for user: {}", userId);
        Cart cart = cartRepository.findByUserId(userId)
                .orElseGet(() -> {
                    // nếu người dùng chưa có giỏ nào thì trả về một giỏ rỗng
                    Cart empty = new Cart();
                    empty.setUserId(userId);
                    empty = cartRepository.save(empty);
                    return empty;
                });
        
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#request.userId")
    public CartResponse addToCart(AddToCartRequest request) {
        log.info("Adding item to cart for user: {}", request.getUserId());
        // Validate product exists
        var productResponse = productClient.getProductById(request.getProductId());
        if (productResponse.getData() == null) {
            throw new RuntimeException("Product not found: " + request.getProductId());
        }
        
        ProductDTO product = productResponse.getData();
        
        // Handle nullable stock
        int availableStock = product.getStock() != null ? product.getStock() : 0;
        // Check stock availability
        if (availableStock < request.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + availableStock);
        }

        // Get or create cart for user
        Cart cart = cartRepository.findByUserId(request.getUserId())
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUserId(request.getUserId());
                    return cartRepository.save(newCart);
                });

        // Check if product already in cart
        var existingItem = cartItemRepository.findByCartIdAndProductId(
                cart.getId(), request.getProductId());

        if (existingItem.isPresent()) {
            // Update quantity
            CartItem item = existingItem.get();
            int newQuantity = item.getQuantity() + request.getQuantity();
            
            if (product.getStock() < newQuantity) {
                throw new RuntimeException("Insufficient stock. Available: " + product.getStock());
            }
            
            item.setQuantity(newQuantity);
            cartItemRepository.save(item);
        } else {
            // Add new item
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProductId(request.getProductId());
            newItem.setQuantity(request.getQuantity());
            cartItemRepository.save(newItem);
        }

        // Refresh cart to get updated items
        cart = cartRepository.findById(cart.getId())
                .orElseThrow(() -> new RuntimeException("Cart not found"));

        log.info("Added product {} to cart for user {}", request.getProductId(), request.getUserId());
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#userId")
    public CartResponse updateCartItem(Long userId, Long productId, UpdateCartItemRequest request) {
        log.info("Updating cart item for user: {}", userId);
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found for user: " + userId));

        CartItem item = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId)
                .orElseThrow(() -> new RuntimeException("Product not found in cart"));

        // Validate product stock
        var productResponse = productClient.getProductById(productId);
        if (productResponse.getData() == null) {
            throw new RuntimeException("Product not found: " + productId);
        }

        ProductDTO product = productResponse.getData();
        int availableStock = product.getStock() != null ? product.getStock() : 0;
        if (availableStock < request.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + availableStock);
        }

        item.setQuantity(request.getQuantity());
        cartItemRepository.save(item);

        log.info("Updated cart item {} for user {}", productId, userId);
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#userId")
    public CartResponse removeFromCart(Long userId, Long productId) {
        log.info("Removing item from cart for user: {}", userId);
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found for user: " + userId));

        CartItem item = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId)
                .orElseThrow(() -> new RuntimeException("Product not found in cart"));

        cartItemRepository.delete(item);

        log.info("Removed product {} from cart for user {}", productId, userId);
        
        // Refresh cart
        cart = cartRepository.findById(cart.getId())
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CacheEvict(value = "carts", key = "#userId")
    public void clearCart(Long userId) {
        log.info("Clearing cart for user: {}", userId);
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cart not found for user: " + userId));

        cartItemRepository.deleteByCartId(cart.getId());
        log.info("Cleared cart for user {}", userId);
    }

    private CartResponse mapToCartResponse(Cart cart) {
        List<CartItem> items = cartItemRepository.findByCartId(cart.getId());
        
        List<CartItemResponse> itemResponses = items.stream()
                .map(this::mapToCartItemResponse)
                .collect(Collectors.toList());

        double totalPrice = itemResponses.stream()
                .mapToDouble(item -> {
                    if (item.getProduct() != null && item.getProduct().getPrice() != null) {
                        return item.getProduct().getPrice().doubleValue() * item.getQuantity();
                    }
                    return 0.0;
                })
                .sum();

        int totalItems = items.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();

        return CartResponse.builder()
                .id(cart.getId())
                .userId(cart.getUserId())
                .items(itemResponses)
                .totalItems(totalItems)
                .totalPrice(totalPrice)
                .createdAt(cart.getCreatedAt())
                .updatedAt(cart.getUpdatedAt())
                .build();
    }

    private CartItemResponse mapToCartItemResponse(CartItem item) {
        ProductDTO product = null;
        try {
            var response = productClient.getProductById(item.getProductId());
            if (response.getData() != null) {
                product = response.getData();
            }
        } catch (Exception e) {
            log.error("Failed to fetch product {}: {}", item.getProductId(), e.getMessage());
        }

        return CartItemResponse.builder()
                .id(item.getId())
                .productId(item.getProductId())
                .quantity(item.getQuantity())
                .product(product)
                .createdAt(item.getCreatedAt())
                .updatedAt(item.getUpdatedAt())
                .build();
    }
}
