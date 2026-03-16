package com.kidfavor.userservice.service;

import com.kidfavor.userservice.dto.request.auth.GoogleLoginRequest;
import com.kidfavor.userservice.dto.request.auth.LoginRequest;
import com.kidfavor.userservice.dto.request.auth.PasswordResetOtpRequest;
import com.kidfavor.userservice.dto.request.auth.ResendEmailVerificationRequest;
import com.kidfavor.userservice.dto.request.auth.ResetPasswordRequest;
import com.kidfavor.userservice.dto.request.auth.RefreshTokenRequest;
import com.kidfavor.userservice.dto.request.auth.RegisterRequest;
import com.kidfavor.userservice.dto.request.auth.VerifyPasswordResetOtpRequest;
import com.kidfavor.userservice.dto.response.AuthResponse;

import org.springframework.security.oauth2.core.user.OAuth2User;

public interface AuthService {
    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    AuthResponse refreshToken(RefreshTokenRequest request);

    void logout(String token);

    AuthResponse processOAuth2User(OAuth2User oAuth2User);
    
    AuthResponse authenticateWithGoogle(GoogleLoginRequest request);

    void requestPasswordResetOtp(PasswordResetOtpRequest request);

    void verifyPasswordResetOtp(VerifyPasswordResetOtpRequest request);

    void resetPassword(ResetPasswordRequest request);

    void sendResetPasswordLinkByAdmin(Integer userId);

    void verifyEmail(String token);

    void resendEmailVerificationLink(ResendEmailVerificationRequest request);
}
