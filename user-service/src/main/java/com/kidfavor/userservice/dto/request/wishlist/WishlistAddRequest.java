package com.kidfavor.userservice.dto.request.wishlist;

import lombok.Data;

@Data
public class WishlistAddRequest {
    private String name;
    private String description;
    private Double price;
    private String imageUrl;
}
