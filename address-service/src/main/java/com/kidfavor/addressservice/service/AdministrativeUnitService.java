package com.kidfavor.addressservice.service;

import com.kidfavor.addressservice.dto.UnitDto;
import com.kidfavor.addressservice.exception.ResourceNotFoundException;
import com.kidfavor.addressservice.repository.AdministrativeUnitRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdministrativeUnitService {

    private final AdministrativeUnitRepository repository;

    /** Returns all 63 Vietnamese provinces/cities (level = 1). */
    public List<UnitDto> getProvinces() {
        return repository.findByLevelOrderByNameAsc(1)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    /**
     * Returns the districts (level = 2) that belong to a given province.
     *
     * @param provinceId id of the parent province
     */
    public List<UnitDto> getDistricts(Long provinceId) {
        // Validate province exists
        repository.findById(provinceId)
                .orElseThrow(() -> new ResourceNotFoundException("Province not found with id: " + provinceId));

        return repository.findByParentIdAndLevelOrderByNameAsc(provinceId, 2)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    /**
     * Returns the wards (level = 3) that belong to a given district.
     *
     * @param districtId id of the parent district
     */
    public List<UnitDto> getWards(Long districtId) {
        // Validate district exists
        repository.findById(districtId)
                .orElseThrow(() -> new ResourceNotFoundException("District not found with id: " + districtId));

        return repository.findByParentIdAndLevelOrderByNameAsc(districtId, 3)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    /**
     * Generic / dynamic endpoint:
     * - parentId null  → provinces
     * - parentId set   → children of that parent
     */
    public List<UnitDto> getChildren(Long parentId) {
        if (parentId == null) {
            return getProvinces();
        }

        return repository.findById(parentId).map(parent -> {
            int childLevel = parent.getLevel() + 1;
            return repository.findByParentIdAndLevelOrderByNameAsc(parentId, childLevel)
                    .stream()
                    .map(UnitDto::from)
                    .toList();
        }).orElseThrow(() -> new ResourceNotFoundException("Administrative unit not found with id: " + parentId));
    }
}
