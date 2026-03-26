package com.kidfavor.userservice.repository;

import com.kidfavor.userservice.entity.EmailVerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmailVerificationTokenRepository extends JpaRepository<EmailVerificationToken, Long> {

    Optional<EmailVerificationToken> findByToken(String token);

    Optional<EmailVerificationToken> findTopByUserIdOrderByCreatedAtDesc(Integer userId);

    List<EmailVerificationToken> findByUserIdAndRevokedFalseAndUsedFalse(Integer userId);
}