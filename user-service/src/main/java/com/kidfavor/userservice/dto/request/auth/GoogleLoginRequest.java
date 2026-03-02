package com.kidfavor.userservice.dto.request.auth;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Request for Google Login with ID Token")
public class GoogleLoginRequest {
    
    @NotBlank(message = "ID token is required")
    @Schema(description = "Google ID token or access token from Google Sign-In", example = "eyJhbGciOiJSUzI1NiIsImtpZCI6...")
    private String idToken;
}
