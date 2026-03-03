package com.kidfavor.userservice.dto.request.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OAuth2LoginRequest {
    private String token; // Google ID token or access token
    private String provider; // "google", "facebook", etc.
}

