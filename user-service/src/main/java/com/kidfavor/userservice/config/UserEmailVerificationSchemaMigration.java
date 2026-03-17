package com.kidfavor.userservice.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
@Order(0)
@RequiredArgsConstructor
@Slf4j
public class UserEmailVerificationSchemaMigration implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        try {
            jdbcTemplate.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT TRUE");
            jdbcTemplate.execute("UPDATE users SET email_verified = TRUE WHERE email_verified IS NULL");
            jdbcTemplate.execute("ALTER TABLE users ALTER COLUMN email_verified SET NOT NULL");
            log.info("Ensured users.email_verified column exists and is populated");
        } catch (Exception ex) {
            log.warn("Could not migrate users.email_verified schema: {}", ex.getMessage());
        }
    }
}