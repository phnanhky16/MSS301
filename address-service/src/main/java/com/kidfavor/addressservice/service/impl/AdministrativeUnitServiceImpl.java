package com.kidfavor.addressservice.service.impl;

import com.kidfavor.addressservice.dto.UnitDto;
import com.kidfavor.addressservice.exception.ResourceNotFoundException;
import com.kidfavor.addressservice.repository.AdministrativeUnitRepository;
import com.kidfavor.addressservice.service.AdministrativeUnitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Implementation of AdministrativeUnitService
 * Manages Vietnamese administrative units (Provinces, Districts, Wards)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdministrativeUnitServiceImpl implements AdministrativeUnitService {

    private final AdministrativeUnitRepository repository;

    @Override
    public List<UnitDto> getProvinces() {
        log.debug("Fetching all provinces");
        return repository.findByLevelOrderByNameAsc(1)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    @Override
    public List<UnitDto> getDistricts(Long provinceId) {
        log.debug("Fetching districts for province ID: {}", provinceId);
        
        // Validate province exists
        repository.findById(provinceId)
                .orElseThrow(() -> new ResourceNotFoundException("Province not found with id: " + provinceId));

        return repository.findByParentIdAndLevelOrderByNameAsc(provinceId, 2)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    @Override
    public List<UnitDto> getWards(Long districtId) {
        log.debug("Fetching wards for district ID: {}", districtId);
        
        // Validate district exists
        repository.findById(districtId)
                .orElseThrow(() -> new ResourceNotFoundException("District not found with id: " + districtId));

        return repository.findByParentIdAndLevelOrderByNameAsc(districtId, 3)
                .stream()
                .map(UnitDto::from)
                .toList();
    }

    @Override
    public List<UnitDto> getChildren(Long parentId) {
        log.debug("Fetching children for parent ID: {}", parentId);
        
        if (parentId == null) {
            return getProvinces();
        }

        return repository.findById(parentId).map(parent -> {
            int childLevel = parent.getLevel() + 1;
            log.debug("Parent level: {}, child level: {}", parent.getLevel(), childLevel);
            
            return repository.findByParentIdAndLevelOrderByNameAsc(parentId, childLevel)
                    .stream()
                    .map(UnitDto::from)
                    .toList();
        }).orElseThrow(() -> new ResourceNotFoundException("Administrative unit not found with id: " + parentId));
    }
}
