package com.kidfavor.userservice.service;

import com.kidfavor.userservice.dto.request.user.UserUpdateRequest;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.enums.Role;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserService {
    org.springframework.data.domain.Page<UserResponse> getAllUsers(org.springframework.data.domain.Pageable pageable);

    // enhanced listing with optional filter/search parameters
    org.springframework.data.domain.Page<UserResponse> getAllUsers(org.springframework.data.domain.Pageable pageable,
                                                                   String keyword,
                                                                   Boolean status,
                                                                   Boolean emailVerified,
                                                                   Role role);

    org.springframework.data.domain.Page<UserResponse> getArchivedUsers(org.springframework.data.domain.Pageable pageable,
                                                                        String keyword,
                                                                        Role role);
    UserResponse getUserById(int id);
    List<UserResponse> getUsersByStatus(Boolean status);
    List<UserResponse> getUsersByRole(Role role);
    UserResponse updateUser(int id, UserUpdateRequest request);
    void changeUserStatus(int id);
    void archiveUser(int id);
    void restoreUser(int id);
    UserResponse changeUserRole(int id, Role role);
    void permanentlyDeleteUser(int id);
    /**
     * Return total number of users (for dashboard stats).
     */
    long countUsers();

}
