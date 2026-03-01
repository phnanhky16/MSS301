package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.request.auth.LoginRequest;
import com.kidfavor.userservice.dto.request.auth.LogoutRequest;
import com.kidfavor.userservice.dto.request.auth.OAuth2LoginRequest;
import com.kidfavor.userservice.dto.request.auth.RefreshTokenRequest;
import com.kidfavor.userservice.dto.request.auth.RegisterRequest;
import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.service.AuthService;
import com.kidfavor.userservice.service.OAuth2Service;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "APIs for user authentication (Register, Login, Logout, OAuth2)")
@io.swagger.v3.oas.annotations.security.SecurityRequirements // No security required for auth endpoints
public class AuthController {

    private final AuthService authService;
    private final OAuth2Service oauth2Service;

    @Operation(
            summary = "Register a new user",
            description = "Create a new user account and return JWT tokens"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "201",
                    description = "User registered successfully",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Invalid input or user already exists"
            )
    })
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(
            @Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(201, "User registered successfully", response));
    }

    @Operation(
            summary = "Login user",
            description = "Authenticate user and return JWT tokens"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Login successful",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "401",
                    description = "Invalid credentials"
            )
    })
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(
            @Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", response));
    }

    @Operation(
            summary = "Refresh access token",
            description = "Get new access token using refresh token"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Token refreshed successfully",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "401",
                    description = "Invalid refresh token"
            )
    })
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(
            @Valid @RequestBody RefreshTokenRequest request) {
        AuthResponse response = authService.refreshToken(request);
        return ResponseEntity.ok(ApiResponse.success("Token refreshed successfully", response));
    }

    @Operation(
            summary = "Google OAuth2 Login",
            description = "Authenticate user with Google ID token and return JWT tokens"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Google login successful",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "401",
                    description = "Invalid Google token"
            )
    })
    @PostMapping("/google")
    public ResponseEntity<ApiResponse<AuthResponse>> googleLogin(
            @Valid @RequestBody OAuth2LoginRequest request) {
        AuthResponse response = oauth2Service.authenticateWithGoogle(request.getToken());
        return ResponseEntity.ok(ApiResponse.success("Google login successful", response));
    }

    @Operation(
            summary = "Logout user",
            description = "Invalidate the current JWT token"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Logout successful"
            )
    })
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(
            @Valid @RequestBody LogoutRequest request) {
        authService.logout(request.getToken());
        return ResponseEntity.ok(ApiResponse.success("Logout successful", null));
    }
}
