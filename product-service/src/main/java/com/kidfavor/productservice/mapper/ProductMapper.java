package com.kidfavor.productservice.mapper;

import com.kidfavor.productservice.dto.request.ProductCreateRequest;
import com.kidfavor.productservice.dto.request.ProductUpdateRequest;
import com.kidfavor.productservice.dto.response.ProductResponse;
import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.entity.Category;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.entity.ProductImage;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class ProductMapper {
    
    private final BrandMapper brandMapper;
    private final CategoryMapper categoryMapper;
    
    public ProductMapper(BrandMapper brandMapper, CategoryMapper categoryMapper) {
        this.brandMapper = brandMapper;
        this.categoryMapper = categoryMapper;
    }
    
    public Product toEntity(ProductCreateRequest request, Category category, Brand brand) {
        Product product = new Product();
        product.setName(request.getName());
        product.setDescription(request.getDescription());
        product.setPrice(request.getPrice());
        product.setCategory(category);
        product.setBrand(brand);
        return product;
    }
    
    public void updateEntity(Product product, ProductUpdateRequest request, Category category, Brand brand) {
        if (request.getName() != null) {
            product.setName(request.getName());
        }
        if (request.getDescription() != null) {
            product.setDescription(request.getDescription());
        }
        if (request.getPrice() != null) {
            product.setPrice(request.getPrice());
        }
        if (category != null) {
            product.setCategory(category);
        }
        if (brand != null) {
            product.setBrand(brand);
        }
    }
    
    public ProductResponse toResponse(Product product) {
        List<String> imageUrls = product.getImages() != null 
            ? product.getImages().stream()
                .map(ProductImage::getImageUrl)
                .collect(Collectors.toList())
            : Collections.emptyList();
        
        return ProductResponse.builder()
                .id(product.getId())
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .stock(product.getStock())
                .status(product.getStatus())
                .statusChangedAt(product.getStatusChangedAt())
                .category(product.getCategory() != null ? categoryMapper.toResponse(product.getCategory()) : null)
                .brand(product.getBrand() != null ? brandMapper.toResponse(product.getBrand()) : null)
                .imageUrls(imageUrls)
                .createdAt(product.getCreatedAt())
                .updatedAt(product.getUpdatedAt())
                .build();
    }
    
    public List<ProductResponse> toResponseList(List<Product> products) {
        return products.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}
