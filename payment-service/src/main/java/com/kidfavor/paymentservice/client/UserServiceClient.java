package com.kidfavor.paymentservice.client;

import com.kidfavor.paymentservice.dto.ApiResponse;
import com.kidfavor.paymentservice.dto.UserDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "user-service")
public interface UserServiceClient {

    @GetMapping("/internal/users/{id}")
    ApiResponse<UserDto> getUserById(@PathVariable("id") Long id);
}
