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

    @Bean
    public ApplicationRunner initUsers(UserRepository repo) {
        return args -> {
            long existing = repo.count();
            int target = 200;
            System.out.println("[UserDataInitializer] existing users=" + existing);
            if (existing >= target) {
                System.out.println("[UserDataInitializer] already at or above target, skipping");
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
                        .password("password")              // ensure not null
                        .phone("0875" + (1000 + rng.nextInt(9000)))
                        .status(rng.nextBoolean())
                        .role(Role.values()[rng.nextInt(Role.values().length)]);
                User u = builder.build();
                System.out.println("[UserDataInitializer] inserting " + u.getUserName());
                repo.save(u);
            }
            System.out.println("[UserDataInitializer] completed seeding to target " + target);
        };
    }

    // fallback listener approach in case ApplicationRunner isn't invoked
    @org.springframework.context.event.EventListener(org.springframework.boot.context.event.ApplicationReadyEvent.class)
    public void onApplicationReady(org.springframework.boot.context.event.ApplicationReadyEvent evt) {
        UserRepository repo = evt.getApplicationContext().getBean(UserRepository.class);
        long existing = repo.count();
        int target = 200;
        System.out.println("[UserDataInitializer][ready] existing=" + existing);
        if (existing >= target) {
            System.out.println("[UserDataInitializer][ready] skipping, already at target");
            return;
        }
        Random rng = new Random(5678);
        for (int i = (int) existing + 1; i <= target; i++) {
            String fullName = NAMES[rng.nextInt(NAMES.length)];
            String email = fullName.toLowerCase().replace(' ', '.') + i + "@" +
                    EMAIL_DOMAINS[rng.nextInt(EMAIL_DOMAINS.length)];
            User u = User.builder()
                    .fullName(fullName)
                    .userName("user" + i)
                    .email(email)
                    .password("password")
                    .phone("0875" + (1000 + rng.nextInt(9000)))
                    .status(rng.nextBoolean())
                    .role(Role.values()[rng.nextInt(Role.values().length)])
                    .build();
            System.out.println("[UserDataInitializer][ready] inserting " + u.getUserName());
            repo.save(u);
        }
        System.out.println("[UserDataInitializer][ready] done");
    }

    @jakarta.annotation.PostConstruct
    public void postConstruct() {
        System.out.println("[UserDataInitializer] bean created");
    }
}