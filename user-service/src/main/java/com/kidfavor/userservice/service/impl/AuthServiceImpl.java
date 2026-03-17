package com.kidfavor.userservice.service.impl;

import com.kidfavor.userservice.dto.request.auth.ChangePasswordRequest;
import com.kidfavor.userservice.dto.request.auth.GoogleLoginRequest;
import com.kidfavor.userservice.dto.request.auth.LoginRequest;
import com.kidfavor.userservice.dto.request.auth.RefreshTokenRequest;
import com.kidfavor.userservice.dto.request.auth.RegisterRequest;
import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.event.UserRegisteredDomainEvent;
import com.kidfavor.userservice.repository.UserRepository;
import com.kidfavor.userservice.security.JwtTokenProvider;
import com.kidfavor.userservice.service.AuthService;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.context.annotation.Lazy;

import java.util.Collections;
import java.util.Map;

@Service
@Slf4j
public class AuthServiceImpl implements AuthService {

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final AuthenticationManager authenticationManager;
    private final ApplicationEventPublisher eventPublisher;

    public AuthServiceImpl(UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtTokenProvider jwtTokenProvider,
            @Lazy AuthenticationManager authenticationManager,
            ApplicationEventPublisher eventPublisher) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.authenticationManager = authenticationManager;
        this.eventPublisher = eventPublisher;
    }

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Check if username already exists
        if (userRepository.findByUserName(request.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }

        // Check if email already exists
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new RuntimeException("Email already exists");
        }

        // Create new user
        User user = new User();
        user.setFullName(request.getFullName());
        user.setUserName(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setPhone(request.getPhone());
        user.setStatus(true);
        user.setRole(Role.CUSTOMER);

        User savedUser = userRepository.save(user);
        log.info("User registered successfully: {}", savedUser.getUserName());

        // Fire domain event — UserEventPublisher will publish to Kafka AFTER
        // transaction commits
        eventPublisher.publishEvent(new UserRegisteredDomainEvent(this, savedUser));

        // Generate tokens
        String accessToken = jwtTokenProvider.generateAccessToken(savedUser);
        String refreshToken = jwtTokenProvider.generateRefreshToken(savedUser);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                .user(mapToUserResponse(savedUser))
                .build();
    }

    @Override
    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

        User user = userRepository.findByUserName(request.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getStatus()) {
            throw new RuntimeException("User account is disabled");
        }

        String accessToken = jwtTokenProvider.generateAccessToken(user);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user);

        log.info("User logged in successfully: {}", user.getUserName());

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                .user(mapToUserResponse(user))
                .build();
    }

    @Override
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        String refreshToken = request.getRefreshToken();

        if (!jwtTokenProvider.validateToken(refreshToken)) {
            throw new RuntimeException("Invalid refresh token");
        }

        String username = jwtTokenProvider.getUsernameFromToken(refreshToken);
        User user = userRepository.findByUserName(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String newAccessToken = jwtTokenProvider.generateAccessToken(user);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                .user(mapToUserResponse(user))
                .build();
    }

    @Override
    public void logout(String token) {
        jwtTokenProvider.invalidateToken(token);
        SecurityContextHolder.clearContext();
        log.info("User logged out successfully");
    }

    @Override
    @Transactional
    public AuthResponse processOAuth2User(org.springframework.security.oauth2.core.user.OAuth2User oAuth2User) {
        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        String googleUserId = oAuth2User.getAttribute("sub"); // Google uses "sub" as the unique ID

        log.info("Processing Google OAuth2 user: {}", email);

        if (email == null) {
            throw new RuntimeException("Email not found from OAuth2 provider");
        }

        // Find or create user
        User user = userRepository.findByEmail(email)
                .orElseGet(() -> {
                    log.info("Creating new user from Google OAuth2: {}", email);
                    User newUser = User.builder()
                            .email(email)
                            .fullName(name != null ? name : email.split("@")[0])
                            .userName(email.split("@")[0] + "_" + System.currentTimeMillis())
                            .provider("GOOGLE")
                            .providerId(googleUserId)
                            .password("") // No password for OAuth users
                            .status(true)
                            .role(Role.CUSTOMER)
                            .build();
                    return userRepository.save(newUser);
                });

        // Update provider info if user exists but wasn't linked to Google
        if (user.getProvider() == null || !user.getProvider().equals("GOOGLE")) {
            user.setProvider("GOOGLE");
            user.setProviderId(googleUserId);
            user = userRepository.save(user);
        }

        if (!user.getStatus()) {
            throw new RuntimeException("User account is disabled");
        }

        // Generate tokens
        String accessToken = jwtTokenProvider.generateAccessToken(user);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user);

        log.info("OAuth2 User processed successfully: {}", user.getUserName());

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                .user(mapToUserResponse(user))
                .build();
    }

    @Override
    @Transactional
    public AuthResponse authenticateWithGoogle(GoogleLoginRequest request) {
        try {
            log.debug("Attempting to verify Google token");
            
            // Check if it's an access token (starts with "ya29.")
            if (request.getIdToken().startsWith("ya29.")) {
                log.debug("Detected Google access token, using Google API to get user info");
                return authenticateWithGoogleAccessToken(request.getIdToken());
            }
            
            // Verify Google ID Token
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(), 
                    new GsonFactory())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();
            
            GoogleIdToken idToken = verifier.verify(request.getIdToken());
            if (idToken == null) {
                log.error("Google ID token verification failed");
                throw new RuntimeException("Invalid Google ID token");
            }
            
            Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String googleUserId = payload.getSubject();
            
            log.info("Google token verified for email: {}", email);
            
            return processGoogleUser(email, name, googleUserId);
            
        } catch (Exception e) {
            log.error("Error authenticating with Google", e);
            throw new RuntimeException("Google authentication failed: " + e.getMessage());
        }
    }
    
    private AuthResponse authenticateWithGoogleAccessToken(String accessToken) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);
            HttpEntity<String> entity = new HttpEntity<>(headers);
            
            @SuppressWarnings("unchecked")
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    "https://www.googleapis.com/oauth2/v3/userinfo",
                    HttpMethod.GET,
                    entity,
                    (Class<Map<String, Object>>) (Object) Map.class
            );
            
            Map<String, Object> userInfo = response.getBody();
            if (userInfo == null) {
                throw new RuntimeException("Failed to get user info from Google API");
            }
            
            log.debug("Retrieved user info from Google API: {}", userInfo);
            String email = (String) userInfo.get("email");
            String name = (String) userInfo.get("name");
            String googleUserId = (String) userInfo.get("sub");
            
            return processGoogleUser(email, name, googleUserId);
            
        } catch (Exception e) {
            log.error("Error authenticating with Google access token", e);
            throw new RuntimeException("Google authentication failed: " + e.getMessage());
        }
    }
    
    private AuthResponse processGoogleUser(String email, String name, String googleUserId) {
        if (email == null) {
            throw new RuntimeException("Email not found from Google");
        }
        
        // Find or create user
        User user = userRepository.findByEmail(email)
                .orElseGet(() -> {
                    log.info("Creating new user from Google: {}", email);
                    User newUser = User.builder()
                            .email(email)
                            .fullName(name != null ? name : email.split("@")[0])
                            .userName(email.split("@")[0] + "_" + System.currentTimeMillis())
                            .provider("GOOGLE")
                            .providerId(googleUserId)
                            .password("") // No password for OAuth users
                            .status(true)
                            .role(Role.CUSTOMER)
                            .build();
                    return userRepository.save(newUser);
                });
        
        // Update provider info if user exists but wasn't linked to Google
        if (user.getProvider() == null || !user.getProvider().equals("GOOGLE")) {
            user.setProvider("GOOGLE");
            user.setProviderId(googleUserId);
            user = userRepository.save(user);
        }
        
        if (!user.getStatus()) {
            throw new RuntimeException("User account is disabled");
        }
        
        // Generate tokens
        String accessToken = jwtTokenProvider.generateAccessToken(user);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user);
        
        log.info("Google user processed successfully: {}", user.getUserName());
        
        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtTokenProvider.getAccessTokenExpiration())
                .user(mapToUserResponse(user))
                .build();
    }

    @Override
    @Transactional
    public void changePassword(int userId, ChangePasswordRequest request) {
        // Validate inputs
        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("New password and confirm password do not match");
        }

        if (request.getNewPassword().equals(request.getOldPassword())) {
            throw new RuntimeException("New password must be different from current password");
        }

        // Find user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Verify old password
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new RuntimeException("Old password is incorrect");
        }

        // Update password
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
        log.info("Password changed successfully for user: {}", user.getUserName());
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
