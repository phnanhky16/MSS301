package com.kidfavor.productservice.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BrandCreateRequest {
    
    @NotBlank(message = "Brand name is required")
    private String name;
    
    private String description;
    
    private String logoUrl;
}
