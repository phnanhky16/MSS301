package com.kidfavor.cartservice.controller;

import com.kidfavor.cartservice.dto.*;
import com.kidfavor.cartservice.service.CartService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/carts")
@RequiredArgsConstructor
@Tag(name = "Cart", description = "Shopping Cart Management APIs")
public class CartController {

    private final CartService cartService;

    @GetMapping("/{userId}")
    @Operation(summary = "Get user's cart", description = "Retrieve cart with all items for a specific user")
    public ResponseEntity<ApiResponse<CartResponse>> getCart(@PathVariable Long userId) {
        CartResponse cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(ApiResponse.success(cart, "Cart retrieved successfully"));
    }

    @PostMapping
    @Operation(summary = "Add item to cart", description = "Add a product to user's cart or update quantity if exists")
    public ResponseEntity<ApiResponse<CartResponse>> addToCart(@Valid @RequestBody AddToCartRequest request) {
        CartResponse cart = cartService.addToCart(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(cart, "Item added to cart successfully"));
    }

    @PutMapping("/{userId}/items/{productId}")
    @Operation(summary = "Update cart item", description = "Update quantity of a specific item in cart")
    public ResponseEntity<ApiResponse<CartResponse>> updateCartItem(
            @PathVariable Long userId,
            @PathVariable Long productId,
            @Valid @RequestBody UpdateCartItemRequest request) {
        CartResponse cart = cartService.updateCartItem(userId, productId, request);
        return ResponseEntity.ok(ApiResponse.success(cart, "Cart item updated successfully"));
    }

    @DeleteMapping("/{userId}/items/{productId}")
    @Operation(summary = "Remove item from cart", description = "Remove a specific product from cart")
    public ResponseEntity<ApiResponse<CartResponse>> removeFromCart(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        CartResponse cart = cartService.removeFromCart(userId, productId);
        return ResponseEntity.ok(ApiResponse.success(cart, "Item removed from cart successfully"));
    }

    @DeleteMapping("/{userId}")
    @Operation(summary = "Clear cart", description = "Remove all items from user's cart")
    public ResponseEntity<ApiResponse<Void>> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.ok(ApiResponse.success(null, "Cart cleared successfully"));
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Void>> handleRuntimeException(RuntimeException ex) {
        return ResponseEntity.badRequest()
                .body(ApiResponse.error(ex.getMessage()));
    }
}
