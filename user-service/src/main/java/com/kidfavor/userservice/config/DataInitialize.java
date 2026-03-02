package com.kidfavor.userservice.config;

import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitialize implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        initAdminUser();
            initSampleUsers();
    }

    private void initAdminUser() {
        String adminUsername = "admin";
        String adminPassword = "admin123";
        String adminEmail = "admin@kidfavor.com";

        // Check if admin user already exists
        if (userRepository.findByUserName(adminUsername).isEmpty()) {
            User adminUser = new User();
            adminUser.setFullName("System Administrator");
            adminUser.setUserName(adminUsername);
            adminUser.setEmail(adminEmail);
            adminUser.setPassword(passwordEncoder.encode(adminPassword));
            adminUser.setPhone("0000000000");
            adminUser.setStatus(true);
            adminUser.setRole(Role.ADMIN);

            userRepository.save(adminUser);
            log.info("========================================");
            log.info("Admin user created successfully!");
            log.info("Username: {}", adminUsername);
            log.info("Password: {}", adminPassword);
            log.info("========================================");
        } else {
            log.info("Admin user already exists, skipping initialization.");
        }
    }

    /**
     * create a few sample accounts covering all roles except admin
     */
    private void initSampleUsers() {
        // use consistent password pattern: username + "123"
        // pad existing users too; update their password if the pattern changed
        createOrUpdatePassword("customer", "customer123", "customer@kidfavor.com", Role.CUSTOMER, "Customer User");
        createOrUpdatePassword("storestaff", "storestaff123", "store@kidfavor.com", Role.STAFF_FOR_STORE, "Store Staff");
        createOrUpdatePassword("warestaff", "warestaff123", "warehouse@kidfavor.com", Role.STAFF_FOR_WAREHOUSE, "Warehouse Staff");
        // admin already handled above
    }

    private void createIfMissing(String username, String rawPassword, String email, Role role, String fullName) {
        if (userRepository.findByUserName(username).isEmpty()) {
            User u = new User();
            u.setFullName(fullName);
            u.setUserName(username);
            u.setEmail(email);
            u.setPassword(passwordEncoder.encode(rawPassword));
            u.setPhone("0000000000");
            u.setStatus(true);
            u.setRole(role);
            userRepository.save(u);
            log.info("Created sample {} user: {} / {}", role, username, rawPassword);
        } else {
            log.info("User {} exists, skipping", username);
        }
    }

    /**
     * Ensure a sample account exists and its password matches the expected raw
     * string.  This helps when the hardcoded default is modified after the
     * user was created originally, which would otherwise leave the database
     * out of sync and lead to confusing login failures.
     */
    private void createOrUpdatePassword(String username,
                                        String rawPassword,
                                        String email,
                                        Role role,
                                        String fullName) {
        userRepository.findByUserName(username).ifPresentOrElse(existing -> {
            boolean needsUpdate = !passwordEncoder.matches(rawPassword, existing.getPassword());
            if (needsUpdate) {
                existing.setPassword(passwordEncoder.encode(rawPassword));
                userRepository.save(existing);
                log.info("Updated password for existing {} user '{}' / {}", role, username, rawPassword);
            } else {
                log.info("User {} exists with correct password, skipping update", username);
            }
        }, () -> {
            User u = new User();
            u.setFullName(fullName);
            u.setUserName(username);
            u.setEmail(email);
            u.setPassword(passwordEncoder.encode(rawPassword));
            u.setPhone("0000000000");
            u.setStatus(true);
            u.setRole(role);
            userRepository.save(u);
            log.info("Created sample {} user: {} / {}", role, username, rawPassword);
        });
    }
}
