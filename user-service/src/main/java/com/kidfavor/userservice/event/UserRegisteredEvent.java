package com.kidfavor.userservice.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Event published to Kafka when a new user successfully registers.
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
