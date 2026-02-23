package com.kidfavor.productservice.service.impl;

import com.kidfavor.productservice.dto.request.CategoryCreateRequest;
import com.kidfavor.productservice.dto.request.CategoryUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.CategoryResponse;
import com.kidfavor.productservice.entity.Category;
import com.kidfavor.productservice.enums.EntityStatus;
import com.kidfavor.productservice.exception.BadRequestException;
import com.kidfavor.productservice.exception.ResourceNotFoundException;
import com.kidfavor.productservice.mapper.CategoryMapper;
import com.kidfavor.productservice.repository.CategoryRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import com.kidfavor.productservice.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryServiceImpl implements CategoryService {
    
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final CategoryMapper categoryMapper;
    
    @Override
    public List<CategoryResponse> getAllCategories() {
        List<Category> categories = categoryRepository.findAll();
        return categoryMapper.toResponseList(categories);
    }
    
    @Override
    public Optional<CategoryResponse> getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .map(categoryMapper::toResponse);
    }
    
    @Override
    public Optional<CategoryResponse> getCategoryByName(String name) {
        return categoryRepository.findByNameAndStatus(name, EntityStatus.ACTIVE)
                .map(categoryMapper::toResponse);
    }
    
    @Override
    public CategoryResponse createCategory(CategoryCreateRequest request) {
        Category category = categoryMapper.toEntity(request);
        Category savedCategory = categoryRepository.save(category);
        return categoryMapper.toResponse(savedCategory);
    }
    
    @Override
    public CategoryResponse updateCategory(Long id, CategoryUpdateRequest request) {
        Category category = categoryRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
        
        categoryMapper.updateEntity(category, request);
        Category updatedCategory = categoryRepository.save(category);
        return categoryMapper.toResponse(updatedCategory);
    }
    
    @Override
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findByIdAndStatus(id, EntityStatus.ACTIVE)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
        
        // Validate: Check if category has active products
        long activeProductCount = productRepository.findByCategoryIdAndStatus(id, EntityStatus.ACTIVE).size();
        if (activeProductCount > 0) {
            throw new BadRequestException(
                "Cannot delete category. " + activeProductCount + " active product(s) are in this category"
            );
        }
        
        category.setStatus(EntityStatus.DELETED);
        category.setStatusChangedAt(LocalDateTime.now());
        categoryRepository.save(category);
    }
    
    @Override
    public CategoryResponse updateCategoryStatus(Long id, StatusUpdateRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
        
        category.setStatus(request.getStatus());
        category.setStatusChangedAt(LocalDateTime.now());
        Category updatedCategory = categoryRepository.save(category);
        return categoryMapper.toResponse(updatedCategory);
    }
}
