package com.kidfavor.cartservice.service;

import com.kidfavor.cartservice.client.ProductClient;
import com.kidfavor.cartservice.dto.*;
import com.kidfavor.cartservice.entity.Cart;
import com.kidfavor.cartservice.entity.CartItem;
import com.kidfavor.cartservice.exception.CartNotFoundException;
import com.kidfavor.cartservice.exception.InsufficientStockException;
import com.kidfavor.cartservice.exception.InvalidQuantityException;
import com.kidfavor.cartservice.exception.ProductNotFoundException;
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
        log.info("Fetching cart for user: {}", userId);
        Cart cart = cartRepository.findByUserId(userId)
<<<<<<< HEAD
                .orElseGet(() -> {
                    // nếu người dùng chưa có giỏ nào thì trả về một giỏ rỗng
                    Cart empty = new Cart();
                    empty.setUserId(userId);
                    empty = cartRepository.save(empty);
                    return empty;
                });
=======
                .orElseThrow(() -> new CartNotFoundException("Cart not found for user: " + userId));
>>>>>>> d99fb530b7f8eccd66c6574226b8f6d6a8155d93
        
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#request.userId")
    public CartResponse addToCart(AddToCartRequest request) {
        log.info("Adding item to cart - userId: {}, productId: {}, quantity: {}", 
                request.getUserId(), request.getProductId(), request.getQuantity());
        
        // Validate quantity
        if (request.getQuantity() == null || request.getQuantity() <= 0) {
            throw new InvalidQuantityException("Quantity must be greater than 0");
        }
        
        // Validate product exists and get product info
        ProductDTO product = validateAndGetProduct(request.getProductId());
        
        // Handle nullable stock
        int availableStock = product.getStock() != null ? product.getStock() : 0;
        // Check stock availability
<<<<<<< HEAD
        if (availableStock < request.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + availableStock);
=======
        if (product.getStock() < request.getQuantity()) {
            throw new InsufficientStockException(
                String.format("Insufficient stock for product %d. Available: %d, Requested: %d", 
                    request.getProductId(), product.getStock(), request.getQuantity())
            );
>>>>>>> d99fb530b7f8eccd66c6574226b8f6d6a8155d93
        }

        // Get or create cart for user
        Cart cart = cartRepository.findByUserId(request.getUserId())
                .orElseGet(() -> {
                    log.info("Creating new cart for user: {}", request.getUserId());
                    Cart newCart = new Cart();
                    newCart.setUserId(request.getUserId());
                    return cartRepository.save(newCart);
                });

        // Check if product already in cart
        var existingItem = cartItemRepository.findByCartIdAndProductId(
                cart.getId(), request.getProductId());

        if (existingItem.isPresent()) {
            // Update existing item quantity
            CartItem item = existingItem.get();
            int newQuantity = item.getQuantity() + request.getQuantity();
            
            // Validate stock for new total quantity
            if (product.getStock() < newQuantity) {
                throw new InsufficientStockException(
                    String.format("Insufficient stock for product %d. Available: %d, Cart has: %d, Requested to add: %d", 
                        request.getProductId(), product.getStock(), item.getQuantity(), request.getQuantity())
                );
            }
            
            item.setQuantity(newQuantity);
            cartItemRepository.save(item);
            log.info("Updated cart item - productId: {}, old quantity: {}, new quantity: {}", 
                    request.getProductId(), item.getQuantity() - request.getQuantity(), newQuantity);
        } else {
            // Add new item to cart
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProductId(request.getProductId());
            newItem.setQuantity(request.getQuantity());
            cartItemRepository.save(newItem);
            log.info("Added new item to cart - productId: {}, quantity: {}", 
                    request.getProductId(), request.getQuantity());
        }

        // Refresh cart to get updated items
        cart = cartRepository.findById(cart.getId())
                .orElseThrow(() -> new CartNotFoundException("Cart not found after update"));

        log.info("Successfully added product {} to cart for user {}", request.getProductId(), request.getUserId());
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#userId")
    public CartResponse updateCartItem(Long userId, Long productId, UpdateCartItemRequest request) {
        log.info("Updating cart item - userId: {}, productId: {}, new quantity: {}", 
                userId, productId, request.getQuantity());
        
        // Validate quantity
        if (request.getQuantity() == null || request.getQuantity() <= 0) {
            throw new InvalidQuantityException("Quantity must be greater than 0");
        }
        
        // Get cart
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new CartNotFoundException("Cart not found for user: " + userId));

        // Get cart item
        CartItem item = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId)
                .orElseThrow(() -> new ProductNotFoundException("Product " + productId + " not found in cart"));

<<<<<<< HEAD
        // Validate product stock
        var productResponse = productClient.getProductById(productId);
        if (productResponse.getData() == null) {
            throw new RuntimeException("Product not found: " + productId);
        }

        ProductDTO product = productResponse.getData();
        int availableStock = product.getStock() != null ? product.getStock() : 0;
        if (availableStock < request.getQuantity()) {
            throw new RuntimeException("Insufficient stock. Available: " + availableStock);
=======
        // Validate product still exists and check stock
        ProductDTO product = validateAndGetProduct(productId);
        
        if (product.getStock() < request.getQuantity()) {
            throw new InsufficientStockException(
                String.format("Insufficient stock for product %d. Available: %d, Requested: %d", 
                    productId, product.getStock(), request.getQuantity())
            );
>>>>>>> d99fb530b7f8eccd66c6574226b8f6d6a8155d93
        }

        int oldQuantity = item.getQuantity();
        item.setQuantity(request.getQuantity());
        cartItemRepository.save(item);

        log.info("Successfully updated cart item - productId: {}, old quantity: {}, new quantity: {}", 
                productId, oldQuantity, request.getQuantity());
        
        // Refresh cart to get updated totals
        cart = cartRepository.findById(cart.getId())
                .orElseThrow(() -> new CartNotFoundException("Cart not found after update"));
        
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CachePut(value = "carts", key = "#userId")
    public CartResponse removeFromCart(Long userId, Long productId) {
        log.info("Removing item from cart - userId: {}, productId: {}", userId, productId);
        
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new CartNotFoundException("Cart not found for user: " + userId));

        CartItem item = cartItemRepository.findByCartIdAndProductId(cart.getId(), productId)
                .orElseThrow(() -> new ProductNotFoundException("Product " + productId + " not found in cart"));

        cartItemRepository.delete(item);
        log.info("Successfully removed product {} from cart for user {}", productId, userId);

        // Refresh cart to get updated items and totals
        cart = cartRepository.findById(cart.getId())
                .orElseThrow(() -> new CartNotFoundException("Cart not found after removal"));
        
        return mapToCartResponse(cart);
    }

    @Override
    @Transactional
    @CacheEvict(value = "carts", key = "#userId")
    public void clearCart(Long userId) {
        log.info("Clearing cart for user: {}", userId);
        
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new CartNotFoundException("Cart not found for user: " + userId));

        int itemCount = cartItemRepository.findByCartId(cart.getId()).size();
        cartItemRepository.deleteByCartId(cart.getId());
        
        log.info("Successfully cleared {} items from cart for user {}", itemCount, userId);
    }

    /**
     * Validate product exists and return product info
     */
    private ProductDTO validateAndGetProduct(Long productId) {
        try {
            var productResponse = productClient.getProductById(productId);
            if (productResponse == null || productResponse.getData() == null) {
                throw new ProductNotFoundException("Product not found: " + productId);
            }
            return productResponse.getData();
        } catch (Exception e) {
            log.error("Failed to fetch product {}: {}", productId, e.getMessage());
            throw new ProductNotFoundException("Product not found or service unavailable: " + productId);
        }
    }

    /**
     * Map Cart entity to CartResponse DTO with full product information
     */
    private CartResponse mapToCartResponse(Cart cart) {
        List<CartItem> items = cartItemRepository.findByCartId(cart.getId());
        
        List<CartItemResponse> itemResponses = items.stream()
                .map(this::mapToCartItemResponse)
                .collect(Collectors.toList());

        // Calculate totals
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

    /**
     * Map CartItem entity to CartItemResponse DTO with product details
     */
    private CartItemResponse mapToCartItemResponse(CartItem item) {
        ProductDTO product = null;
        try {
            var response = productClient.getProductById(item.getProductId());
            if (response != null && response.getData() != null) {
                product = response.getData();
            }
        } catch (Exception e) {
            log.warn("Failed to fetch product details for productId {}: {}", item.getProductId(), e.getMessage());
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

