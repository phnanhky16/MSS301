package com.kidfavor.productservice.service;

import com.kidfavor.productservice.dto.request.CategoryCreateRequest;
import com.kidfavor.productservice.dto.request.CategoryUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.CategoryResponse;

import java.util.List;
import java.util.Optional;

public interface CategoryService {
    
    List<CategoryResponse> getAllCategories();
    
    Optional<CategoryResponse> getCategoryById(Long id);
    
    Optional<CategoryResponse> getCategoryByName(String name);
    
    CategoryResponse createCategory(CategoryCreateRequest request);
    
    CategoryResponse updateCategory(Long id, CategoryUpdateRequest request);
    
    void deleteCategory(Long id);
    
    CategoryResponse updateCategoryStatus(Long id, StatusUpdateRequest request);
}


