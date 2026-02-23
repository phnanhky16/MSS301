package com.kidfavor.userservice.controller;

import com.kidfavor.userservice.dto.ApiResponse;
import com.kidfavor.userservice.dto.request.user.UserUpdateRequest;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.enums.Role;
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
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.RequestAttributes;

import java.util.List;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Tag(name = "User Management", description = "APIs for managing users (Requires Authentication)")
@SecurityRequirement(name = "Bearer Authentication")
public class UserController {
    UserService userService;
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
                        org.springframework.data.domain.Pageable pageable) {
                var users = userService.getAllUsers(pageable);
                return ResponseEntity.ok(ApiResponse.success("Retrieved users successfully", users));
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
            summary = "Delete user",
            description = "Delete a user from the system"
    )
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "User deleted successfully"
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "User not found"
            )
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> changeUserStatus(
            @Parameter(description = "User ID", required = true)
            @PathVariable Integer id) {
                // NOTE: this endpoint previously toggled status. Add delete support
                // so admin can completely remove a user.  We keep the old behaviour
                // for backwards compatibility by allowing a query param `delete`.
                boolean delete = false;
                // spring will bind query parameters automatically if we capture them
                // but easier to inspect request parameter map - use ServletRequest
                // for now, use default delete=false behavior only toggles status.
                                if ("true".equalsIgnoreCase(((jakarta.servlet.http.HttpServletRequest)org.springframework.web.context.request.RequestContextHolder
                                .currentRequestAttributes()
                                .resolveReference(org.springframework.web.context.request.RequestAttributes.REFERENCE_REQUEST))
                                .getParameter("delete"))) {
                        delete = true;
                }
                if (delete) {
                        userService.deleteUser(id);
                        return ResponseEntity.ok(ApiResponse.success("User deleted successfully", null));
                } else {
                        userService.changeUserStatus(id);
                        return ResponseEntity.ok(ApiResponse.success("User changed status successfully", null));
                }
    }
}
