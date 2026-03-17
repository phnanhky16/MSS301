package com.kidfavor.userservice.entity;

import com.kidfavor.userservice.entity.enums.Role;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String fullName;

    @Column(nullable = false, length = 100)
    private String userName;

    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Column
    private String password;

    // OAuth2 fields
    @Column(length = 50)
    private String provider; // "local", "google", "facebook", etc.

    @Column(unique = true)
    private String providerId; // unique ID from OAuth provider

    @Column(length = 20)
    private String phone;

    @Column(nullable = false)
    @Builder.Default
    private Boolean status = true;

    @Column(nullable = false)
    @Builder.Default
    private Boolean emailVerified = true;

    private LocalDateTime emailVerifiedAt;

    private Role role;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Shipment> shipments;
}
