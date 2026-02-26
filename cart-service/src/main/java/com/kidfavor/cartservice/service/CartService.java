package com.kidfavor.cartservice.service;

import com.kidfavor.cartservice.dto.*;

public interface CartService {
    CartResponse getCartByUserId(Long userId);
    CartResponse addToCart(AddToCartRequest request);
    CartResponse updateCartItem(Long userId, Long productId, UpdateCartItemRequest request);
    CartResponse removeFromCart(Long userId, Long productId);
    void clearCart(Long userId);
}
