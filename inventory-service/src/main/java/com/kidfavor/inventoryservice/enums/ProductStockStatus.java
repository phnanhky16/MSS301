package com.kidfavor.inventoryservice.enums;

public enum ProductStockStatus {
    OUT_OF_STOCK,    // quantity = 0
    LOW_STOCK,       // 0 < quantity < minStockLevel
    IN_STOCK         // quantity >= minStockLevel
}
