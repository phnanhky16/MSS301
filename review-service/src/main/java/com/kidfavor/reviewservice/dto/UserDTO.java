package com.kidfavor.reviewservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
    private Integer id;
    private String fullName;
    private String userName;
    private String email;
    private String phone;
    private Boolean status;
    private String role;
}
