package com.kidfavor.reviewservice.security;

import lombok.Data;

@Data
public class UserPrincipal {
    private Long userId;
    private String username;
    private String role;
    
    public UserPrincipal(Long userId, String username, String role) {
        this.userId = userId;
        this.username = username;
        this.role = role;
    }
}
