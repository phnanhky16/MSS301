package com.kidfavor.addressservice.dto;

import com.kidfavor.addressservice.entity.AdministrativeUnit;

/**
 * Lightweight response DTO — only exposes id & name as per the API contract.
 */
public record UnitDto(Long id, String name) {

    public static UnitDto from(AdministrativeUnit unit) {
        return new UnitDto(unit.getId(), unit.getName());
    }
}
