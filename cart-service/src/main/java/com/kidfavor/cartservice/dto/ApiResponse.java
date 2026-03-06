package com.kidfavor.cartservice.dto;

import lombok.Data;

@Data
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private Integer status;

    public ApiResponse() {
    }

    public ApiResponse(boolean success, String message, T data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }

    public ApiResponse(boolean success, String message, T data, Integer status) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.status = status;
    }

    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(true, message, data);
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null);
    }

    public static <T> ApiResponse<T> error(int status, String message) {
        return new ApiResponse<>(false, message, null, status);
    }

    public static <T> ApiResponse<T> error(int status, String message, T data) {
        return new ApiResponse<>(false, message, data, status);
    }
}
