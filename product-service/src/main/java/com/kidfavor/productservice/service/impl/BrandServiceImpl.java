package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.dto.request.BrandCreateRequest;
import com.kidfavor.productservice.dto.request.BrandUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.BrandResponse;
import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.enums.EntityStatus;
import com.kidfavor.productservice.exception.BadRequestException;
import com.kidfavor.productservice.exception.ResourceNotFoundException;
import com.kidfavor.productservice.mapper.BrandMapper;
import com.kidfavor.productservice.repository.BrandRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import com.kidfavor.productservice.service.BrandService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class BrandServiceImpl implements BrandService {
    
    private final BrandRepository brandRepository;
    private final ProductRepository productRepository;
    private final BrandMapper brandMapper;
    
    @Override
    public List<BrandResponse> getAllBrands() {
        List<Brand> brands = brandRepository.findAll();
        return brandMapper.toResponseList(brands);
    }
    
    @Override
    public Optional<BrandResponse> getBrandById(Long id) {
        return brandRepository.findById(id)
                .map(brandMapper::toResponse);
    }
    
    @Override
    public Optional<BrandResponse> getBrandByName(String name) {
        return brandRepository.findByNameAndStatus(name, EntityStatus.ACTIVE)
                .map(brandMapper::toResponse);
    }
    
    @Override
    public BrandResponse createBrand(BrandCreateRequest request) {
        Brand brand = brandMapper.toEntity(request);
        Brand savedBrand = brandRepository.save(brand);
        return brandMapper.toResponse(savedBrand);
    }
    
    @Override
    public BrandResponse updateBrand(Long id, BrandUpdateRequest request) {
        Brand brand = brandRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                    .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + id));
        
        brandMapper.updateEntity(brand, request);
        Brand updatedBrand = brandRepository.save(brand);
        return brandMapper.toResponse(updatedBrand);
    }
    
    @Override
    public void deleteBrand(Long id) {
        Brand brand = brandRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + id));
        
        // Validate: Check if brand has active products
        long activeProductCount = productRepository.countByBrandAndStatus(brand, EntityStatus.ACTIVE);
        if (activeProductCount > 0) {
            throw new BadRequestException(
                "Cannot delete brand. " + activeProductCount + " active product(s) are using this brand"
            );
        }
        
        brand.setStatus(EntityStatus.DELETED);
        brand.setStatusChangedAt(LocalDateTime.now());
        brandRepository.save(brand);
    }
    
    @Override
    public BrandResponse updateBrandStatus(Long id, StatusUpdateRequest request) {
        Brand brand = brandRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Brand not found with id: " + id));
        
        brand.setStatus(request.getStatus());
        brand.setStatusChangedAt(LocalDateTime.now());
        Brand updatedBrand = brandRepository.save(brand);
        return brandMapper.toResponse(updatedBrand);
    }
}
