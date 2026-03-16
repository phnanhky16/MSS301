package com.kidfavor.userservice.service.impl;

import com.kidfavor.userservice.dto.request.auth.GoogleLoginRequest;
import com.kidfavor.userservice.dto.request.auth.LoginRequest;
import com.kidfavor.userservice.dto.request.auth.PasswordResetOtpRequest;
import com.kidfavor.userservice.dto.request.auth.ResetPasswordRequest;
import com.kidfavor.userservice.dto.request.auth.RefreshTokenRequest;
import com.kidfavor.userservice.dto.request.auth.RegisterRequest;
import com.kidfavor.userservice.dto.request.auth.VerifyPasswordResetOtpRequest;
import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.PasswordResetSession;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.event.UserRegisteredDomainEvent;
import com.kidfavor.userservice.repository.PasswordResetSessionRepository;
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
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
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
import java.time.LocalDateTime;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.UUID;

@Service
@Slf4j
public class AuthServiceImpl implements AuthService {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    @Value("${spring.mail.username}")
    private String mailSenderAddress;

    @Value("${app.password-reset.otp-expiration-minutes:5}")
    private long otpExpirationMinutes;

    @Value("${app.password-reset.link-expiration-minutes:10}")
    private long resetLinkExpirationMinutes;

    @Value("${app.frontend.url.base:http://localhost:3000}")
    private String frontendBaseUrl;

    private final UserRepository userRepository;
    private final PasswordResetSessionRepository passwordResetSessionRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final AuthenticationManager authenticationManager;
    private final ApplicationEventPublisher eventPublisher;
    private final JavaMailSender mailSender;

    public AuthServiceImpl(UserRepository userRepository,
            PasswordResetSessionRepository passwordResetSessionRepository,
            PasswordEncoder passwordEncoder,
            JwtTokenProvider jwtTokenProvider,
            @Lazy AuthenticationManager authenticationManager,
            ApplicationEventPublisher eventPublisher,
            JavaMailSender mailSender) {
        this.userRepository = userRepository;
        this.passwordResetSessionRepository = passwordResetSessionRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.authenticationManager = authenticationManager;
        this.eventPublisher = eventPublisher;
        this.mailSender = mailSender;
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
        String identifier = request.getUsername().trim();
        User user = userRepository.findByUserName(identifier)
            .or(() -> userRepository.findByEmail(identifier.toLowerCase()))
            .orElseThrow(() -> new RuntimeException("User not found"));

        if ("GOOGLE".equalsIgnoreCase(user.getProvider())
            && (user.getPassword() == null || user.getPassword().isBlank())) {
            throw new RuntimeException("This account uses Google sign-in. Please continue with Google login");
        }

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                user.getUserName(),
                        request.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);

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
    public void requestPasswordResetOtp(PasswordResetOtpRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email is not registered"));

        String verificationCode = generateVerificationCode();
        LocalDateTime now = LocalDateTime.now();

        PasswordResetSession session = PasswordResetSession.builder()
                .email(email)
                .verificationCode(verificationCode)
                .verificationCodeExpiresAt(now.plusMinutes(otpExpirationMinutes))
                .verificationVerified(false)
                .used(false)
                .revoked(false)
                .build();

        passwordResetSessionRepository.save(session);
        sendVerificationCodeEmail(email, verificationCode, otpExpirationMinutes);
    }

    @Override
    @Transactional
    public void verifyPasswordResetOtp(VerifyPasswordResetOtpRequest request) {
        String email = request.getEmail().trim().toLowerCase();
        String verificationCode = request.getVerificationCode().trim();

        PasswordResetSession session = passwordResetSessionRepository
                .findTopByEmailAndVerificationCodeOrderByCreatedAtDesc(email, verificationCode)
                .orElseThrow(() -> new RuntimeException("Invalid verification code"));

        if (Boolean.TRUE.equals(session.getRevoked()) || Boolean.TRUE.equals(session.getUsed())) {
            throw new RuntimeException("Verification code has been revoked");
        }

        if (Boolean.TRUE.equals(session.getVerificationVerified())) {
            throw new RuntimeException("Verification code has already been used");
        }

        if (session.getVerificationCodeExpiresAt() == null
                || LocalDateTime.now().isAfter(session.getVerificationCodeExpiresAt())) {
            throw new RuntimeException("Verification code has expired");
        }

        String resetToken = UUID.randomUUID().toString().replace("-", "");
        LocalDateTime now = LocalDateTime.now();

        session.setVerificationVerified(true);
        session.setVerificationVerifiedAt(now);
        session.setResetToken(resetToken);
        session.setResetTokenExpiresAt(now.plusMinutes(resetLinkExpirationMinutes));
        session.setResetTokenSentAt(now);
        passwordResetSessionRepository.save(session);

        String resetUrl = buildResetUrl(resetToken);
        sendResetPasswordLinkEmail(email, resetUrl, resetLinkExpirationMinutes);
    }

    @Override
    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Confirm password does not match");
        }

        PasswordResetSession session = passwordResetSessionRepository.findByResetToken(request.getToken())
                .orElseThrow(() -> new RuntimeException("Invalid reset token"));

        if (Boolean.TRUE.equals(session.getUsed()) || Boolean.TRUE.equals(session.getRevoked())) {
            throw new RuntimeException("Reset token is no longer valid");
        }

        if (session.getResetTokenExpiresAt() == null || LocalDateTime.now().isAfter(session.getResetTokenExpiresAt())) {
            session.setRevoked(true);
            passwordResetSessionRepository.save(session);
            throw new RuntimeException("Reset token has expired");
        }

        User user = userRepository.findByEmail(session.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        session.setUsed(true);
        session.setRevoked(true);
        passwordResetSessionRepository.save(session);
    }

    @Override
    @Transactional
    public void sendResetPasswordLinkByAdmin(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String email = user.getEmail().trim().toLowerCase();
        LocalDateTime now = LocalDateTime.now();
        String resetToken = UUID.randomUUID().toString().replace("-", "");

        PasswordResetSession session = PasswordResetSession.builder()
                .email(email)
                .verificationCode("000000")
                .verificationCodeExpiresAt(now.plusMinutes(otpExpirationMinutes))
                .verificationVerified(true)
                .verificationVerifiedAt(now)
                .resetToken(resetToken)
                .resetTokenExpiresAt(now.plusMinutes(resetLinkExpirationMinutes))
                .resetTokenSentAt(now)
                .used(false)
                .revoked(false)
                .build();

        passwordResetSessionRepository.save(session);
        String resetUrl = buildResetUrl(resetToken);
        sendResetPasswordLinkEmail(email, resetUrl, resetLinkExpirationMinutes);
        log.info("Admin requested password reset link for userId={} email={}", userId, email);
    }

    private String generateVerificationCode() {
        int value = 100000 + SECURE_RANDOM.nextInt(900000);
        return String.valueOf(value);
    }

    private String buildResetUrl(String token) {
        String base = frontendBaseUrl == null ? "http://localhost:3000" : frontendBaseUrl.trim();
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/reset-password?token=" + java.net.URLEncoder.encode(token, StandardCharsets.UTF_8);
    }

    private void sendVerificationCodeEmail(String recipient, String verificationCode, long expiresInMinutes) {
        try {
            jakarta.mail.internet.MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(mailSenderAddress);
            helper.setTo(recipient);
            helper.setSubject("KidFavor - Password Reset Verification Code");
            helper.setText(buildVerificationCodeMailBody(verificationCode, expiresInMinutes), true);
            mailSender.send(message);
            log.info("Sent password reset OTP to {}", recipient);
        } catch (Exception ex) {
            log.error("Failed to send verification code email to {}", recipient, ex);
            throw new RuntimeException("Unable to send verification code email at the moment");
        }
    }

    private void sendResetPasswordLinkEmail(String recipient, String resetUrl, long expiresInMinutes) {
        try {
            jakarta.mail.internet.MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(mailSenderAddress);
            helper.setTo(recipient);
            helper.setSubject("KidFavor - Password Reset Link");
            helper.setText(buildResetLinkMailBody(resetUrl, expiresInMinutes), true);
            mailSender.send(message);
            log.info("Sent password reset link to {}", recipient);
        } catch (Exception ex) {
            log.error("Failed to send password reset link email to {}", recipient, ex);
            throw new RuntimeException("Unable to send password reset link email at the moment");
        }
    }

    private String buildVerificationCodeMailBody(String verificationCode, long expiresInMinutes) {
        return "<html><body style='font-family:Arial,sans-serif;line-height:1.5;color:#222;'>"
                + "<h2>Verify your email</h2>"
                + "<p>Use the following code to verify your password reset request:</p>"
                + "<p style='font-size:28px;font-weight:bold;letter-spacing:3px;color:#1a6e8a;'>" + verificationCode + "</p>"
                + "<p>This code expires in " + expiresInMinutes + " minutes.</p>"
                + "<p>If you did not request this, please ignore this email.</p>"
                + "<p><strong>KidFavor Team</strong></p>"
                + "</body></html>";
    }

    private String buildResetLinkMailBody(String resetUrl, long expiresInMinutes) {
        return "<html><body style='font-family:Arial,sans-serif;line-height:1.5;color:#222;'>"
                + "<h2>Password reset link</h2>"
                + "<p>Your email has been verified. Click the button below to set a new password:</p>"
                + "<p><a href='" + resetUrl + "' style='display:inline-block;padding:10px 20px;background:#1a6e8a;color:#fff;text-decoration:none;border-radius:6px;'>Reset Password</a></p>"
                + "<p>Or copy this URL:</p>"
                + "<p><a href='" + resetUrl + "'>" + resetUrl + "</a></p>"
                + "<p>This link expires in " + expiresInMinutes + " minutes and can only be used once.</p>"
                + "<p>If you did not request this, please ignore this email.</p>"
                + "<p><strong>KidFavor Team</strong></p>"
                + "</body></html>";
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
