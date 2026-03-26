package com.kidfavor.userservice.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Returned to the Flutter client.
 * Field names match Product.fromJson() in the app:
 *   id, name, description, price, imageUrls, category, brand, totalStock
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class WishlistItemResponse {
    private Long id;             // productId
    private String name;
    private String description;
    private Double price;
    private List<String> imageUrls;
    private Object category;
    private Object brand;
    private Integer totalStock;
    private LocalDateTime addedAt;
}
