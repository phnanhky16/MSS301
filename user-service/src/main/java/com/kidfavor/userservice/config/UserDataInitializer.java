package com.kidfavor.userservice.config;

import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.repository.UserRepository;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDateTime;
import java.util.Random;

/**
 * Populate the user table with a large batch of realistic-looking accounts
 * when the database is empty. Helps exercise search, filters, and paging.
 */
@Configuration
public class UserDataInitializer {

    private static final String[] NAMES = {
            "Alice Smith", "Bob Johnson", "Carol Williams", "David Brown",
            "Eve Davis", "Frank Miller", "Grace Wilson", "Hank Moore",
            "Ivy Taylor", "Jack Anderson", "Kara Thomas", "Liam Jackson"
    };

    private static final String[] EMAIL_DOMAINS = {"example.com", "mail.com", "test.org"};

    // Use volatile to ensure thread safety across multiple initialization attempts
    private volatile boolean initialized = false;

    @Bean
    public ApplicationRunner initUsers(UserRepository repo) {
        return args -> {
            if (initialized) {
                System.out.println("[UserDataInitializer] Already initialized, skipping");
                return;
            }
            
            synchronized (this) {
                if (initialized) {
                    return;
                }
                
                long existing = repo.count();
                int target = 200;
                System.out.println("[UserDataInitializer] existing users=" + existing);
                
                if (existing >= target) {
                    System.out.println("[UserDataInitializer] already at or above target, skipping");
                    initialized = true;
                    return;
                }
                
                Random rng = new Random(5678);
                for (int i = (int) existing + 1; i <= target; i++) {
                    String fullName = NAMES[rng.nextInt(NAMES.length)];
                    String email = fullName.toLowerCase().replace(' ', '.') + i + "@" +
                            EMAIL_DOMAINS[rng.nextInt(EMAIL_DOMAINS.length)];
                    User.UserBuilder builder = User.builder()
                            .fullName(fullName)
                            .userName("user" + i)
                            .email(email)
                            .password("password")
                            .phone("0875" + (1000 + rng.nextInt(9000)))
                            .status(rng.nextBoolean())
                            .role(Role.values()[rng.nextInt(Role.values().length)]);
                    User u = builder.build();
                    repo.save(u);
                }
                
                System.out.println("[UserDataInitializer] completed seeding to target " + target);
                initialized = true;
            }
        };
    }
}