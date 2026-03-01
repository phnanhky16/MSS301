package com.kidfavor.userservice.service.impl;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.repository.UserRepository;
import com.kidfavor.userservice.security.JwtTokenProvider;
import com.kidfavor.userservice.service.OAuth2Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;

@Service
@RequiredArgsConstructor
@Slf4j
public class OAuth2ServiceImpl implements OAuth2Service {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    @Override
    @Transactional
    public AuthResponse authenticateWithGoogle(String idToken) {
        try {
            // Verify Google ID token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), new GsonFactory())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken googleIdToken = verifier.verify(idToken);
            if (googleIdToken == null) {
                throw new RuntimeException("Invalid Google ID token");
            }

            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String googleUserId = payload.getSubject();
            String pictureUrl = (String) payload.get("picture");

            log.info("Google OAuth2 login attempt for email: {}", email);

            // Find or create user
            User user = userRepository.findByEmail(email)
                    .orElseGet(() -> createGoogleUser(email, name, googleUserId, pictureUrl));

            // Update provider info if user exists but wasn't linked to Google
            if (user.getProvider() == null || !user.getProvider().equals("GOOGLE")) {
                user.setProvider("GOOGLE");
                user.setProviderId(googleUserId);
                user = userRepository.save(user);
            }

            // Check if user is active
            if (!user.getStatus()) {
                throw new RuntimeException("User account is disabled");
            }

            // Generate JWT tokens
            String accessToken = jwtTokenProvider.generateAccessToken(user);
            String refreshToken = jwtTokenProvider.generateRefreshToken(user);

            log.info("User logged in successfully via Google: {}", user.getUserName());

            return AuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .tokenType("Bearer")
                    .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                    .user(mapToUserResponse(user))
                    .build();

        } catch (Exception e) {
            log.error("Error during Google OAuth2 authentication: {}", e.getMessage());
            throw new RuntimeException("Google authentication failed: " + e.getMessage());
        }
    }

    private User createGoogleUser(String email, String name, String googleUserId, String pictureUrl) {
        log.info("Creating new user from Google OAuth2: {}", email);

        User user = User.builder()
                .email(email)
                .fullName(name != null ? name : email.split("@")[0])
                .userName(email.split("@")[0] + "_" + System.currentTimeMillis())
                .provider("GOOGLE")
                .providerId(googleUserId)
                .password("") // No password for OAuth users
                .status(true)
                .role(Role.CUSTOMER)
                .build();

        return userRepository.save(user);
    }

    private UserResponse mapToUserResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .userName(user.getUserName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .status(user.getStatus())
                .role(user.getRole())
                .build();
    }
}


