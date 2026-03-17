package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.request.auth.ChangePasswordRequest;
import com.kidfavor.userservice.dto.request.auth.GoogleLoginRequest;
import com.kidfavor.userservice.dto.request.auth.LoginRequest;
import com.kidfavor.userservice.dto.request.auth.LogoutRequest;

import com.kidfavor.userservice.dto.request.auth.RefreshTokenRequest;
import com.kidfavor.userservice.dto.request.auth.RegisterRequest;
import com.kidfavor.userservice.dto.response.AuthResponse;
import com.kidfavor.userservice.service.AuthService;
import com.kidfavor.userservice.security.JwtTokenProvider;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "APIs for user authentication (Register, Login, Logout, OAuth2)")
@io.swagger.v3.oas.annotations.security.SecurityRequirements // No security required for auth endpoints
@Slf4j
public class AuthController {

        private final AuthService authService;
        private final JwtTokenProvider jwtTokenProvider;

        @Operation(summary = "Register a new user", description = "Create a new user account and return JWT tokens")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "User registered successfully", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid input or user already exists")
        })
        @PostMapping("/register")
        public ResponseEntity<ApiResponse<AuthResponse>> register(
                        @Valid @RequestBody RegisterRequest request) {
                AuthResponse response = authService.register(request);
                return ResponseEntity.status(HttpStatus.CREATED)
                                .body(ApiResponse.success(201, "User registered successfully", response));
        }

        @Operation(summary = "Login user", description = "Authenticate user and return JWT tokens")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Login successful", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Invalid credentials")
        })
        @PostMapping("/login")
        public ResponseEntity<ApiResponse<AuthResponse>> login(
                        @Valid @RequestBody LoginRequest request) {
                // authentication exceptions are handled by GlobalExceptionHandler
        // (bad credentials, disabled account, etc.), so we simply delegate.
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", response));
        }

        @Operation(summary = "Refresh access token", description = "Get new access token using refresh token")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Token refreshed successfully", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Invalid refresh token")
        })
        @PostMapping("/refresh")
        public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(
                        @Valid @RequestBody RefreshTokenRequest request) {
                AuthResponse response = authService.refreshToken(request);
                return ResponseEntity.ok(ApiResponse.success("Token refreshed successfully", response));
        }

        @Operation(summary = "Logout user", description = "Invalidate the current JWT token")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Logout successful")
        })
        @PostMapping("/logout")
        public ResponseEntity<ApiResponse<Void>> logout(
                        @Valid @RequestBody LogoutRequest request) {
                authService.logout(request.getToken());
                return ResponseEntity.ok(ApiResponse.success("Logout successful", null));
        }

        @Operation(summary = "Google Login", description = "Authenticate user with Google ID token or access token")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Login successful", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Invalid Google token")
        })
        @PostMapping("/google-login")
        public ResponseEntity<ApiResponse<AuthResponse>> googleLogin(
                        @Valid @RequestBody GoogleLoginRequest request) {
                AuthResponse response = authService.authenticateWithGoogle(request);
                return ResponseEntity.ok(ApiResponse.success("Google login successful", response));
        }

        @Operation(summary = "Initiate Google Login", description = "Redirect to Google for authentication. After authentication, you'll need to extract the ID token and use the POST /auth/google-login endpoint.")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "302", description = "Redirect to Google login page")
        })
        @GetMapping("/google-login")
        public ResponseEntity<ApiResponse<String>> initiateGoogleLogin() {
                String googleAuthUrl = String.format(
                        "https://accounts.google.com/o/oauth2/v2/auth?client_id=%s&redirect_uri=%s&response_type=token&scope=email profile",
                        "1085016969658-o80o0smreofoe1f0q598t88un2mkckru.apps.googleusercontent.com",
                        "http://localhost:3000/auth/google/callback"
                );
                return ResponseEntity.ok(ApiResponse.success("Please redirect to Google login", googleAuthUrl));
        }

        @Operation(summary = "Change user password", description = "Change password for a logged-in user. Requires authentication.")
        @ApiResponses(value = {
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Password changed successfully", content = @Content(schema = @Schema(implementation = ApiResponse.class))),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid password or password mismatch"),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Unauthorized - invalid token"),
                        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "User not found")
        })
        @PutMapping("/users/{userId}/change-password")
        @io.swagger.v3.oas.annotations.security.SecurityRequirement(name = "Bearer Authentication")
        public ResponseEntity<ApiResponse<Void>> changePassword(
                        @Parameter(description = "User ID", required = true)
                        @PathVariable Integer userId,
                        @Valid @RequestBody ChangePasswordRequest request,
                        HttpServletRequest httpRequest) {
                
                // Extract token from request header
                String authHeader = httpRequest.getHeader(HttpHeaders.AUTHORIZATION);
                if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                        throw new RuntimeException("Missing or invalid authorization header");
                }
                
                String token = authHeader.substring(7);
                Integer tokenUserId = jwtTokenProvider.getUserIdFromToken(token);
                
                // Validate that the user can only change their own password
                if (!tokenUserId.equals(userId)) {
                        throw new RuntimeException("Unauthorized: You can only change your own password");
                }
                
                authService.changePassword(userId, request);
                return ResponseEntity.ok(ApiResponse.success("Password changed successfully", null));
        }
}
