package com.kidfavor.orderservice.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.loader.ast.internal.CacheEntityLoaderHelper;

import java.math.BigDecimal;

/**
 * DTO representing a product from Product Service.
 * Contains only the fields needed for order creation.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductDto {

    private Long id;
    private String name;
    private BigDecimal price;
    private EntityStatus status;
}
