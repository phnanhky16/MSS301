package com.kidfavor.userservice.security;

import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@Slf4j
public class CustomOAuth2SuccessHandler implements AuthenticationSuccessHandler {

    private final AuthService authService;

    public CustomOAuth2SuccessHandler(@Lazy AuthService authService) {
        this.authService = authService;
    }

    @Value("${app.frontend.url.base:http://localhost:3000/}")
    private String frontendUrl;

    @Value("${app.frontend.url.mobile:http://localhost:3000/mobile/}")
    private String frontendMobileUrl;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getAttribute("email");

        log.info("OAuth2 login successful for email: {}", email);

        try {
            // Process the user and get tokens
            AuthResponse authResponse = authService.processOAuth2User(oAuth2User);

            // Determine redirect URL
            boolean isMobile = isMobileRequest(request);
            String targetUrl = isMobile ? frontendMobileUrl : frontendUrl;

            // Append tokens to URL (Note: in production, consider more secure ways like
            // secure cookies or one-time codes)
            String redirectUrl = String.format("%s?token=%s",
                    targetUrl,
                    authResponse.getAccessToken());

            log.info("Redirecting to frontend: {}", targetUrl);
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            log.error("Error processing OAuth2 success: {}", e.getMessage());
            String errorUrl = String.format("%slogin?error=%s",
                    frontendUrl,
                    e.getMessage().replace(" ", "_"));
            response.sendRedirect(errorUrl);
        }
    }

    private boolean isMobileRequest(HttpServletRequest request) {
        // Simple mobile detection from the user's snippet logic
        String ua = request.getHeader("User-Agent");
        if (ua != null) {
            String lowercaseUa = ua.toLowerCase();
            return lowercaseUa.contains("mobile") || lowercaseUa.contains("android") || lowercaseUa.contains("iphone");
        }
        return false;
    }
}
