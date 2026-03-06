package com.kidfavor.addressservice.service;

import com.kidfavor.addressservice.dto.UnitDto;

import java.util.List;

/**
 * Service interface for managing Vietnamese Administrative Units
 * (Provinces, Districts, Wards)
 */
public interface AdministrativeUnitService {

    /**
     * Returns all 63 Vietnamese provinces/cities (level = 1).
     *
     * @return list of province DTOs
     */
    List<UnitDto> getProvinces();

    /**
     * Returns the districts (level = 2) that belong to a given province.
     *
     * @param provinceId id of the parent province
     * @return list of district DTOs
     */
    List<UnitDto> getDistricts(Long provinceId);

    /**
     * Returns the wards (level = 3) that belong to a given district.
     *
     * @param districtId id of the parent district
     * @return list of ward DTOs
     */
    List<UnitDto> getWards(Long districtId);

    /**
     * Generic / dynamic endpoint:
     * - parentId null  → provinces
     * - parentId set   → children of that parent
     *
     * @param parentId id of the parent unit (null for provinces)
     * @return list of child unit DTOs
     */
    List<UnitDto> getChildren(Long parentId);
}
