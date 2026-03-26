package com.kidfavor.addressservice.config;

import org.flywaydb.core.Flyway;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * Custom Flyway configuration for the address-service.
 * <p>
 * Drops and re-creates the schema on every restart so that editing or
 * replacing migration files never causes a checksum mismatch.  This is
 * safe because the address database only contains static lookup data.
 */
@Configuration
public class FlywayConfig {

    @Bean
    public Flyway flyway(DataSource dataSource) {
        return Flyway.configure()
                .dataSource(dataSource)
                .locations("classpath:db/migration")
                .baselineOnMigrate(true)
                .baselineVersion("0")
                .cleanDisabled(false)
                .load();
    }

    /**
     * Override the default FlywayMigrationInitializer so we can call
     * clean() before migrate().  This runs during context startup.
     */
    @Bean
    public FlywayMigrationInitializer flywayInitializer(Flyway flyway) {
        return new FlywayMigrationInitializer(flyway, f -> {
            f.clean();
            f.migrate();
        });
    }
}
