package com.kidfavor.inventoryservice.client;

import com.kidfavor.inventoryservice.client.dto.ExternalResponse;
import com.kidfavor.inventoryservice.client.dto.ProductResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@FeignClient(name = "product-service")
public interface ProductServiceClient {

    @GetMapping("/internal/products/by-ids")
    ExternalResponse<List<ProductResponseDto>> getProductsByIds(@RequestParam("ids") List<Long> ids);
}
