package com.kidfavor.orderservice.client.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Wrapper for API responses from Product Service and User Service.
 * Handles the standard response format: { success, status, message, data, timestamp }
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ApiResponse<T> {
    
    private Boolean success;
    private Integer status;
    private String message;
    private T data;
    private String timestamp;
}
