package com.kidfavor.userservice.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomOAuth2FailureHandler implements AuthenticationFailureHandler {

    @Value("${app.frontend.url.base:http://localhost:3000/}")
    private String frontendUrl;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {
        // Log the failure
        System.err.println("OAuth2 login failed: " + exception.getMessage());

        // Redirect back to the frontend login page with an error message
        String errorMessage = exception.getMessage().replace(" ", "_");
        response.sendRedirect(frontendUrl + "login?error=" + errorMessage);
    }
}
