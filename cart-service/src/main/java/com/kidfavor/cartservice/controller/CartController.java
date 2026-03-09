package com.kidfavor.cartservice.controller;

import com.kidfavor.cartservice.dto.*;
import com.kidfavor.cartservice.service.CartService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/carts")
@RequiredArgsConstructor
@Tag(name = "Cart", description = "Shopping Cart Management APIs")
@SecurityRequirement(name = "bearer-jwt")
public class CartController {

    private final CartService cartService;

    @GetMapping
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(
        summary = "Get current user's cart",
        description = "Retrieve cart with all items for the authenticated user. Returns cart details including items, quantities, and total price."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cart retrieved successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Cart not found",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<CartResponse>> getCart() {
        Long userId = getCurrentUserId();
        CartResponse cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(com.kidfavor.cartservice.dto.ApiResponse.success(cart, "Cart retrieved successfully"));
    }

    @PostMapping("/items")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(
        summary = "Add item to cart",
        description = "Add a product to current user's cart. If the product already exists in cart, quantity will be incremented. Validates product existence and stock availability before adding."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Item added to cart successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid request - Invalid quantity or insufficient stock",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Product not found",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<CartResponse>> addToCart(
            @Valid @RequestBody @Parameter(description = "Product and quantity to add to cart") AddToCartRequest request) {
        Long userId = getCurrentUserId();
        request.setUserId(userId); // Set userId from JWT
        CartResponse cart = cartService.addToCart(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(com.kidfavor.cartservice.dto.ApiResponse.success(cart, "Item added to cart successfully"));
    }

    @PutMapping("/items/{productId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(
        summary = "Update cart item quantity",
        description = "Update the quantity of a specific product in current user's cart. Validates stock availability for the new quantity."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cart item updated successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid request - Invalid quantity or insufficient stock",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Product not found in cart",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<CartResponse>> updateCartItem(
            @PathVariable @Parameter(description = "Product ID to update") Long productId,
            @Valid @RequestBody @Parameter(description = "New quantity for the product") UpdateCartItemRequest request) {
        Long userId = getCurrentUserId();
        CartResponse cart = cartService.updateCartItem(userId, productId, request);
        return ResponseEntity.ok(com.kidfavor.cartservice.dto.ApiResponse.success(cart, "Cart item updated successfully"));
    }

    @DeleteMapping("/items/{productId}")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(
        summary = "Remove item from cart",
        description = "Remove a specific product from current user's cart completely, regardless of quantity."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Item removed from cart successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Product not found in cart",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<CartResponse>> removeFromCart(
            @PathVariable @Parameter(description = "Product ID to remove") Long productId) {
        Long userId = getCurrentUserId();
        CartResponse cart = cartService.removeFromCart(userId, productId);
        return ResponseEntity.ok(com.kidfavor.cartservice.dto.ApiResponse.success(cart, "Item removed from cart successfully"));
    }

    @DeleteMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(
        summary = "Clear cart",
        description = "Remove all items from current user's cart. This operation cannot be undone."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cart cleared successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Cart not found",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<Void>> clearCart() {
        Long userId = getCurrentUserId();
        cartService.clearCart(userId);
        return ResponseEntity.ok(com.kidfavor.cartservice.dto.ApiResponse.success(null, "Cart cleared successfully"));
    }

    // Admin endpoint to view any user's cart
    @GetMapping("/admin/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
        summary = "Get user's cart (Admin only)",
        description = "Retrieve cart for any user. This endpoint is restricted to administrators only."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Cart retrieved successfully",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "401", description = "Unauthorized - Invalid or missing JWT token",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "403", description = "Forbidden - Admin role required",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class))),
        @ApiResponse(responseCode = "404", description = "Cart not found",
            content = @Content(schema = @Schema(implementation = com.kidfavor.cartservice.dto.ApiResponse.class)))
    })
    public ResponseEntity<com.kidfavor.cartservice.dto.ApiResponse<CartResponse>> getCartByUserId(
            @PathVariable @Parameter(description = "User ID whose cart to retrieve") Long userId) {
        CartResponse cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(com.kidfavor.cartservice.dto.ApiResponse.success(cart, "Cart retrieved successfully"));
    }

    /**
     * Extract userId from JWT token in SecurityContext
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getDetails() instanceof Long) {
            return (Long) authentication.getDetails();
        }
        // Fallback: try to parse from name if it's a number
        try {
            return Long.parseLong(authentication.getName());
        } catch (NumberFormatException e) {
            throw new RuntimeException("Unable to extract user ID from authentication token");
        }
    }
}
