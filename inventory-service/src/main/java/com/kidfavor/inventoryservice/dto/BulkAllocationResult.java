package com.kidfavor.inventoryservice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BulkAllocationResult {
    private boolean fullyAllocated;
    private List<AllocationItem> allocations;
    private String message;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AllocationItem {
        private Long productId;
        private Long storeId;
        private Integer allocatedQuantity;
        private boolean success;
    }
}
