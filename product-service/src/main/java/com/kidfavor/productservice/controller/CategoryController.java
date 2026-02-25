package com.kidfavor.productservice.controller;

import com.kidfavor.productservice.dto.response.ResponseWrapper;
import com.kidfavor.productservice.dto.request.CategoryCreateRequest;
import com.kidfavor.productservice.dto.request.CategoryUpdateRequest;
import com.kidfavor.productservice.dto.request.StatusUpdateRequest;
import com.kidfavor.productservice.dto.response.CategoryResponse;
import com.kidfavor.productservice.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
@Tag(name = "Category", description = "Category management APIs")
public class CategoryController {
    
    private final CategoryService categoryService;
    
    @GetMapping
    @Operation(summary = "Get all categories", description = "Retrieve all categories")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully retrieved categories")
    })
    public ResponseEntity<ResponseWrapper<List<CategoryResponse>>> getAllCategories() {
        List<CategoryResponse> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(
            ResponseWrapper.success("Categories retrieved successfully", categories)
        );
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get category by ID", description = "Retrieve a specific category by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Category found"),
        @ApiResponse(responseCode = "404", description = "Category not found")
    })
    public ResponseEntity<ResponseWrapper<CategoryResponse>> getCategoryById(
            @Parameter(description = "Category ID") @PathVariable Long id) {
        return categoryService.getCategoryById(id)
                .map(category -> ResponseEntity.ok(
                    ResponseWrapper.success("Category retrieved successfully", category)
                ))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @Operation(summary = "Create category", description = "Create a new category")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Category created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<CategoryResponse>> createCategory(@Valid @RequestBody CategoryCreateRequest request) {
        CategoryResponse created = categoryService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(
            ResponseWrapper.created("Category created successfully", created)
        );
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Update category", description = "Update an existing category")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Category updated successfully"),
        @ApiResponse(responseCode = "404", description = "Category not found"),
        @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<ResponseWrapper<CategoryResponse>> updateCategory(
            @Parameter(description = "Category ID") @PathVariable Long id, 
            @Valid @RequestBody CategoryUpdateRequest request) {
        CategoryResponse updated = categoryService.updateCategory(id, request);
        return ResponseEntity.ok(
            ResponseWrapper.success("Category updated successfully", updated)
        );
    }
    
    @PutMapping("/{id}/status")
    @Operation(summary = "Update category status", description = "Change category status (ACTIVE, INACTIVE, DELETED)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Category status updated successfully"),
        @ApiResponse(responseCode = "404", description = "Category not found"),
        @ApiResponse(responseCode = "400", description = "Invalid status")
    })
    public ResponseEntity<ResponseWrapper<CategoryResponse>> updateCategoryStatus(
            @Parameter(description = "Category ID") @PathVariable Long id,
            @Valid @RequestBody StatusUpdateRequest request) {
        CategoryResponse updated = categoryService.updateCategoryStatus(id, request);
        return ResponseEntity.ok(
            ResponseWrapper.success("Category status updated successfully", updated)
        );
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete category", description = "Delete a category by ID (sets status to DELETED)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Category deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Category not found")
    })
    public ResponseEntity<ResponseWrapper<Void>> deleteCategory(
            @Parameter(description = "Category ID") @PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.ok(
            ResponseWrapper.noContent("Category deleted successfully")
        );
    }
}
