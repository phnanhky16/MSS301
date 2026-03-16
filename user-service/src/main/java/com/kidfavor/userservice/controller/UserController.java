package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.request.user.UserUpdateRequest;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.service.AuthService;
import com.kidfavor.userservice.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Tag(name = "User Management", description = "APIs for managing users (Requires Authentication)")
@SecurityRequirement(name = "Bearer Authentication")
public class UserController {
    UserService userService;
        AuthService authService;
    @Operation(
            summary = "Get all users",
            description = "Retrieve a list of all users in the system"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Successfully retrieved list of users",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            )
    })
        @GetMapping
                public ResponseEntity<ApiResponse<org.springframework.data.domain.Page<UserResponse>>> getAllUsers(
                                                org.springframework.data.domain.Pageable pageable,
                                                @RequestParam(name="keyword", required=false) String keyword,
                                                @RequestParam(name="status", required=false) Boolean status,
                                                @RequestParam(name="emailVerified", required=false) Boolean emailVerified,
                                                @RequestParam(name="role", required=false) Role role) {
                                var users = userService.getAllUsers(pageable, keyword, status, emailVerified, role);
                                return ResponseEntity.ok(ApiResponse.success("Retrieved users successfully", users));
        }

        @GetMapping("/archived")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<ApiResponse<org.springframework.data.domain.Page<UserResponse>>> getArchivedUsers(
                        org.springframework.data.domain.Pageable pageable,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "role", required = false) Role role) {
                var users = userService.getArchivedUsers(pageable, keyword, role);
                return ResponseEntity.ok(ApiResponse.success("Retrieved archived users successfully", users));
        }

        // count endpoint must come before /{id} to avoid treating "count" as an id
        @GetMapping("/count")
        public ResponseEntity<ApiResponse<Long>> getUserCount() {
                long count = userService.countUsers();
                return ResponseEntity.ok(ApiResponse.success("User count", count));
        }

    @Operation(
            summary = "Get user by ID",
            description = "Retrieve a specific user by their ID"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Successfully retrieved user",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "User not found"
            )
    })
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UserResponse>> getUserById(
            @Parameter(description = "User ID", required = true)
            @PathVariable Integer id) {
        UserResponse user = userService.getUserById(id);
        return ResponseEntity.ok(ApiResponse.success("Retrieved user successfully", user));
    }

        /**
         * Dashboard stats: total number of users in the system.
         */

    @Operation(
            summary = "Get users by status",
            description = "Retrieve all users filtered by their active/inactive status"
    )
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<UserResponse>>> getUsersByStatus(
            @Parameter(description = "User status (true=active, false=inactive)", required = true)
            @PathVariable Boolean status) {
        List<UserResponse> users = userService.getUsersByStatus(status);
        return ResponseEntity.ok(ApiResponse.success("Retrieved users by status successfully", users));
    }

    @Operation(
            summary = "Get users by role",
            description = "Retrieve all users with a specific role"
    )
    @GetMapping("/role/{role}")
    public ResponseEntity<ApiResponse<List<UserResponse>>> getUsersByRole(
            @Parameter(description = "User role (CUSTOMER, STAFF_FOR_STORE, STAFF_FOR_WAREHOUSE, ADMIN)", required = true)
            @PathVariable Role role) {
        List<UserResponse> users = userService.getUsersByRole(role);
        return ResponseEntity.ok(ApiResponse.success("Retrieved users by role successfully", users));
    }

    @Operation(
            summary = "Update user",
            description = "Update an existing user's information"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "User updated successfully"
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "User not found"
            )
    })
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<UserResponse>> updateUser(
            @Parameter(description = "User ID", required = true)
            @PathVariable Integer id,
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "User update data",
                    required = true,
                    content = @Content(schema = @Schema(implementation = UserUpdateRequest.class))
            )
            @RequestBody UserUpdateRequest request) {
        UserResponse user = userService.updateUser(id, request);
        return ResponseEntity.ok(ApiResponse.success("User updated successfully", user));
    }

    @Operation(
            summary = "Archive user",
            description = "Soft-delete (archive) a user account"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "User archived successfully"
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "User not found"
            )
    })
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> archiveUser(
            @Parameter(description = "User ID", required = true)
            @PathVariable Integer id) {
                userService.archiveUser(id);
                return ResponseEntity.ok(ApiResponse.success("User archived successfully", null));
    }

        @PatchMapping("/{id}/restore")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<ApiResponse<Void>> restoreUser(
                        @Parameter(description = "User ID", required = true)
                        @PathVariable Integer id) {
                userService.restoreUser(id);
                return ResponseEntity.ok(ApiResponse.success("User restored successfully", null));
        }

        @DeleteMapping("/{id}/permanent")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<ApiResponse<Void>> permanentlyDeleteUser(
                        @Parameter(description = "User ID", required = true)
                        @PathVariable Integer id) {
                userService.permanentlyDeleteUser(id);
                return ResponseEntity.ok(ApiResponse.success("User permanently deleted successfully", null));
        }

        @Operation(
                        summary = "Send password reset link by admin",
                        description = "Allow admin/support to send a password reset link directly to user email"
        )
        @PostMapping("/{id}/password-reset-link")
        @PreAuthorize("hasRole('ADMIN')")
        public ResponseEntity<ApiResponse<Void>> sendPasswordResetLinkByAdmin(
                        @Parameter(description = "User ID", required = true)
                        @PathVariable Integer id) {
                authService.sendResetPasswordLinkByAdmin(id);
                return ResponseEntity.ok(ApiResponse.success("Password reset link sent to user email", null));
        }
}
