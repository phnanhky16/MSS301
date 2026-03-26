package com.kidfavor.cartservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
<<<<<<< HEAD
    private BigDecimal salePrice;
    private Boolean onSale;
=======
    
    @JsonProperty("effectivePrice")
    private BigDecimal effectivePrice;
    
>>>>>>> origin/dev
    private String status;
    private List<String> imageUrls;

    /**
     * Maps "totalStock" field from product-service JSON response.
     */
    @JsonProperty("totalStock")
    private Integer stock;
}
