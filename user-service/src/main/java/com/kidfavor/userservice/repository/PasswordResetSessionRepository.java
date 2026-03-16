package com.kidfavor.userservice.repository;

import com.kidfavor.userservice.entity.PasswordResetSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PasswordResetSessionRepository extends JpaRepository<PasswordResetSession, Long> {

    Optional<PasswordResetSession> findTopByEmailAndVerificationCodeOrderByCreatedAtDesc(String email, String verificationCode);

    Optional<PasswordResetSession> findByResetToken(String resetToken);

    List<PasswordResetSession> findByRevokedFalseAndUsedFalseAndResetTokenIsNotNullAndResetTokenExpiresAtBefore(
            LocalDateTime now);
}