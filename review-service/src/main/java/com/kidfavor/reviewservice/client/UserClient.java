package com.kidfavor.reviewservice.client;

import com.kidfavor.reviewservice.dto.ApiResponse;
import com.kidfavor.reviewservice.dto.UserDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(
        name = "user-service",
        fallbackFactory = UserClientFallbackFactory.class
)
public interface UserClient {

    @GetMapping("/internal/users/{id}")
    ApiResponse<UserDTO> getUserById(@PathVariable("id") Long id);
}
