package com.kidfavor.userservice.service;

import com.kidfavor.userservice.dto.response.WishlistItemResponse;

import java.util.List;

public interface WishlistService {

    List<WishlistItemResponse> getWishlist(String username);

    WishlistItemResponse addToWishlist(String username, Integer productId);

    void removeFromWishlist(String username, Integer productId);
}
