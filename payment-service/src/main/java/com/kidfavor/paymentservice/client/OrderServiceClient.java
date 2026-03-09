package com.kidfavor.paymentservice.client;

import com.kidfavor.paymentservice.dto.ApiResponse;
import com.kidfavor.paymentservice.dto.OrderDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "order-service", path = "/orders")
public interface OrderServiceClient {

    @GetMapping("/order-number/{orderNumber}")
    ApiResponse<OrderDto> getOrderByNumber(@PathVariable("orderNumber") String orderNumber);
}
