package com.kidfavor.addressservice.repository;

import com.kidfavor.addressservice.entity.AdministrativeUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdministrativeUnitRepository extends JpaRepository<AdministrativeUnit, Long> {

    /** Returns all units at a given level sorted by name — used for provinces (level=1). */
    List<AdministrativeUnit> findByLevelOrderByNameAsc(int level);

    /** Returns children of a parent unit at the expected level — used for districts (level=2) and wards (level=3). */
    List<AdministrativeUnit> findByParentIdAndLevelOrderByNameAsc(Long parentId, int level);
}
