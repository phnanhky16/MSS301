package com.kidfavor.inventoryservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();
    
    private int status;
    private String message;
    private T data;
    private String error;
    private String path;
    
    // Success responses
    public static <T> ApiResponse<T> success(T data) {
        return ApiResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .status(200)
                .message("Success")
                .data(data)
                .build();
    }
    
    public static <T> ApiResponse<T> success(String message, T data) {
        return ApiResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .status(200)
                .message(message)
                .data(data)
                .build();
    }
    
    public static <T> ApiResponse<T> created(String message, T data) {
        return ApiResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .status(201)
                .message(message)
                .data(data)
                .build();
    }
    
    public static <T> ApiResponse<T> noContent(String message) {
        return ApiResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .status(204)
                .message(message)
                .build();
    }
    
    // Error responses
    public static <T> ApiResponse<T> error(int status, String error, String message, String path) {
        return ApiResponse.<T>builder()
                .timestamp(LocalDateTime.now())
                .status(status)
                .error(error)
                .message(message)
                .path(path)
                .build();
    }
    
    public static <T> ApiResponse<T> badRequest(String message, String path) {
        return error(400, "Bad Request", message, path);
    }
    
    public static <T> ApiResponse<T> notFound(String message, String path) {
        return error(404, "Not Found", message, path);
    }
    
    public static <T> ApiResponse<T> conflict(String message, String path) {
        return error(409, "Conflict", message, path);
    }
    
    public static <T> ApiResponse<T> internalError(String message, String path) {
        return error(500, "Internal Server Error", message, path);
    }
}
