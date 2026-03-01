package com.kidfavor.userservice.service;

import com.kidfavor.userservice.dto.response.AuthResponse;

public interface OAuth2Service {
    /**
     * Authenticate user with Google ID token
     * @param idToken Google ID token from frontend
     * @return AuthResponse with JWT tokens
     */
    AuthResponse authenticateWithGoogle(String idToken);
}

