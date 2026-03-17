package com.kidfavor.userservice.config;

import com.kidfavor.userservice.entity.PasswordResetSession;
import com.kidfavor.userservice.repository.PasswordResetSessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class PasswordResetCleanupScheduler {

    private final PasswordResetSessionRepository passwordResetSessionRepository;

    @Scheduled(cron = "${app.password-reset.revoke-cron:0 */1 * * * *}")
    @Transactional
    public void revokeExpiredResetTokens() {
        List<PasswordResetSession> expiredSessions = passwordResetSessionRepository
                .findByRevokedFalseAndUsedFalseAndResetTokenIsNotNullAndResetTokenExpiresAtBefore(LocalDateTime.now());

        if (expiredSessions.isEmpty()) {
            return;
        }

        for (PasswordResetSession session : expiredSessions) {
            session.setRevoked(true);
        }

        passwordResetSessionRepository.saveAll(expiredSessions);
        log.info("Revoked {} expired password reset token(s)", expiredSessions.size());
    }
}