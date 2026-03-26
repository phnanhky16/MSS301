package com.kidfavor.orderservice.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkAllocationRequest {
    private Double latitude;
    private Double longitude;
    private List<ItemRequest> items;
    private Double maxDistanceKm;
    private Long storeId;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ItemRequest {
        private Long productId;
        private Integer quantity;
    }
}
