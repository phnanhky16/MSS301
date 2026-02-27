package com.kidfavor.inventoryservice.exception;

import com.kidfavor.inventoryservice.dto.ResponseWrapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    private String getPath(WebRequest request) {
        return ((ServletWebRequest) request).getRequest().getRequestURI();
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ResponseEntity<ResponseWrapper<Void>> handleResourceNotFoundException(
            ResourceNotFoundException ex, WebRequest request) {
        log.error("ResourceNotFoundException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.notFound(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    @ExceptionHandler(DuplicateResourceException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ResponseEntity<ResponseWrapper<Void>> handleDuplicateResourceException(
            DuplicateResourceException ex, WebRequest request) {
        log.error("DuplicateResourceException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.conflict(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
    }

    @ExceptionHandler(InsufficientStockException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<ResponseWrapper<Void>> handleInsufficientStockException(
            InsufficientStockException ex, WebRequest request) {
        log.error("InsufficientStockException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.badRequest(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(InvalidStockOperationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<ResponseWrapper<Void>> handleInvalidStockOperationException(
            InvalidStockOperationException ex, WebRequest request) {
        log.error("InvalidStockOperationException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.badRequest(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(ProductNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ResponseEntity<ResponseWrapper<Void>> handleProductNotFoundException(
            ProductNotFoundException ex, WebRequest request) {
        log.error("ProductNotFoundException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.notFound(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<ResponseWrapper<Map<String, String>>> handleValidationExceptions(
            MethodArgumentNotValidException ex, WebRequest request) {
        log.error("Validation failed: {}", ex.getMessage());
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });

        ResponseWrapper<Map<String, String>> response = ResponseWrapper.<Map<String, String>>builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.BAD_REQUEST.value())
                .error("Validation Failed")
                .message("Invalid input data")
                .data(errors)
                .path(getPath(request))
                .build();

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ResponseEntity<ResponseWrapper<Void>> handleIllegalArgumentException(
            IllegalArgumentException ex, WebRequest request) {
        log.error("IllegalArgumentException: {}", ex.getMessage());
        
        ResponseWrapper<Void> response = ResponseWrapper.badRequest(ex.getMessage(), getPath(request));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ResponseEntity<ResponseWrapper<Void>> handleGlobalException(
            Exception ex, WebRequest request) {
        log.error("Unexpected error: ", ex);
        
        ResponseWrapper<Void> response = ResponseWrapper.internalError(
                "An unexpected error occurred: " + ex.getMessage(), 
                getPath(request)
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
