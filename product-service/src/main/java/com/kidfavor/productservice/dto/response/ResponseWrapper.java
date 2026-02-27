package com.kidfavor.productservice.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResponseWrapper<T> {
    private boolean success;
    private int status;
    private String message;
    private T data;
    private LocalDateTime timestamp;

    public static <T> ResponseWrapper<T> success(String message, T data) {
        return ResponseWrapper.<T>builder()
                .success(true)
                .status(HttpStatus.OK.value())
                .message(message)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public static <T> ResponseWrapper<T> created(String message, T data) {
        return ResponseWrapper.<T>builder()
                .success(true)
                .status(HttpStatus.CREATED.value())
                .message(message)
                .data(data)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public static <T> ResponseWrapper<T> noContent(String message) {
        return ResponseWrapper.<T>builder()
                .success(true)
                .status(HttpStatus.NO_CONTENT.value())
                .message(message)
                .data(null)
                .timestamp(LocalDateTime.now())
                .build();
    }

    public static <T> ResponseWrapper<T> error(String message) {
        return ResponseWrapper.<T>builder()
                .success(false)
                .status(HttpStatus.BAD_REQUEST.value())
                .message(message)
                .data(null)
                .timestamp(LocalDateTime.now())
                .build();
    }
}
