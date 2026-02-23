package com.kidfavor.productservice.service;

import com.kidfavor.productservice.dto.request.BrandCreateRequest;
import com.kidfavor.productservice.dto.request.BrandUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.BrandResponse;

import java.util.List;
import java.util.Optional;

public interface BrandService {
    
    List<BrandResponse> getAllBrands();
    
    Optional<BrandResponse> getBrandById(Long id);
    
    Optional<BrandResponse> getBrandByName(String name);
    
    BrandResponse createBrand(BrandCreateRequest request);
    
    BrandResponse updateBrand(Long id, BrandUpdateRequest request);
    
    void deleteBrand(Long id);
    
    BrandResponse updateBrandStatus(Long id, StatusUpdateRequest request);
}
