package com.kidfavor.cartservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String name;
    private String description;
    private Double price;
    private Integer stock;
}
