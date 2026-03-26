package com.kidfavor.userservice.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Drops legacy snapshot columns from wishlist_items that were created
 * in an earlier version of the schema. Runs once on startup before any
 * Hibernate DDL update so the table matches the current entity definition.
 */
@Component
@Order(1)
@RequiredArgsConstructor
@Slf4j
public class WishlistSchemaMigration implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        dropColumnIfExists("wishlist_items", "name");
        dropColumnIfExists("wishlist_items", "description");
        dropColumnIfExists("wishlist_items", "price");
        dropColumnIfExists("wishlist_items", "image_url");
    }

    private void dropColumnIfExists(String table, String column) {
        try {
            // PostgreSQL: check information_schema before dropping
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.columns " +
                "WHERE table_name = ? AND column_name = ?",
                Integer.class, table, column
            );
            if (count != null && count > 0) {
                jdbcTemplate.execute(
                    "ALTER TABLE " + table + " DROP COLUMN IF EXISTS " + column
                );
                log.info("Dropped legacy column {}.{}", table, column);
            }
        } catch (Exception e) {
            log.warn("Could not drop column {}.{}: {}", table, column, e.getMessage());
        }
    }
}
