package com.kidfavor.cartservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemResponse implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private Long productId;
    private Integer quantity;
    private ProductDTO product;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
