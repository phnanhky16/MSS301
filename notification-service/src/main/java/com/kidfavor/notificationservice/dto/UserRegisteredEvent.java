package com.kidfavor.notificationservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Mirror DTO for the UserRegisteredEvent produced by user-service.
 * Kept local to notification-service for decoupling.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRegisteredEvent {

    private Integer userId;
    private String username;
    private String email;
    private String fullName;
    private LocalDateTime registeredAt;
}
