package com.kidfavor.userservice.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "password_reset_sessions", indexes = {
        @Index(name = "idx_password_reset_email", columnList = "email"),
        @Index(name = "idx_password_reset_token", columnList = "resetToken")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String email;

    @Column(nullable = false, length = 6)
    private String verificationCode;

    @Column(nullable = false)
    private LocalDateTime verificationCodeExpiresAt;

    @Builder.Default
    @Column(nullable = false)
    private Boolean verificationVerified = false;

    private LocalDateTime verificationVerifiedAt;

    @Column(unique = true, length = 120)
    private String resetToken;

    private LocalDateTime resetTokenExpiresAt;

    private LocalDateTime resetTokenSentAt;

    @Builder.Default
    @Column(nullable = false)
    private Boolean used = false;

    @Builder.Default
    @Column(nullable = false)
    private Boolean revoked = false;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}