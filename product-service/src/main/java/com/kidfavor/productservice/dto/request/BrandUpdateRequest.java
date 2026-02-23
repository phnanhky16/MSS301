package com.kidfavor.productservice.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BrandUpdateRequest {
    
    private String name;
    
    private String description;
    
    private String logoUrl;
}
