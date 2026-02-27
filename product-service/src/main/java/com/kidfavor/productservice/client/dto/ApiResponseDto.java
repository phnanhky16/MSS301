package com.kidfavor.productservice.client.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Generic API response wrapper for Feign client responses.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponseDto<T> {
    
    private LocalDateTime timestamp;
    private int status;
    private String message;
    private T data;
    private String error;
    private String path;
}
