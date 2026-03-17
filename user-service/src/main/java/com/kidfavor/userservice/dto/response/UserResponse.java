package com.kidfavor.userservice.dto.response;

import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private Integer id;
    private String fullName;
    private String userName;
    private String email;
    private String phone;
    private Boolean status;
    private Boolean emailVerified;
    private Role role;
    private List<ShipmentResponse> shipments;

    public static UserResponse from(User user) {
        return new UserResponse(
                user.getId(),
                user.getFullName(),
                user.getUserName(),
                user.getEmail(),
                user.getPhone(),
                user.getStatus(),
                user.getEmailVerified(),
                user.getRole(),
                user.getShipments() != null ?
                        user.getShipments().stream()
                                .map(ShipmentResponse::from)
                                .collect(Collectors.toList()) : null
        );
    }
}
