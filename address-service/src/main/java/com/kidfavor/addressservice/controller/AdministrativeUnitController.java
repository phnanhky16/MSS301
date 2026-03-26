package com.kidfavor.addressservice.controller;

import com.kidfavor.addressservice.dto.UnitDto;
import com.kidfavor.addressservice.service.AdministrativeUnitService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/administrative-units")
@RequiredArgsConstructor
@Tag(name = "Administrative Units", description = "Vietnamese Tỉnh / Huyện / Xã lookup")
public class AdministrativeUnitController {

    private final AdministrativeUnitService service;

    // ─── Explicit endpoints ───────────────────────────────────────────────────

    @GetMapping("/provinces")
    @Operation(summary = "Lấy danh sách tất cả Tỉnh / Thành phố (63 tỉnh)")
    public ResponseEntity<List<UnitDto>> getProvinces() {
        return ResponseEntity.ok(service.getProvinces());
    }

    @GetMapping("/{provinceId}/districts")
    @Operation(summary = "Lấy danh sách Quận / Huyện theo Tỉnh")
    public ResponseEntity<List<UnitDto>> getDistricts(@PathVariable Long provinceId) {
        return ResponseEntity.ok(service.getDistricts(provinceId));
    }

    @GetMapping("/{districtId}/wards")
    @Operation(summary = "Lấy danh sách Phường / Xã theo Huyện")
    public ResponseEntity<List<UnitDto>> getWards(@PathVariable Long districtId) {
        return ResponseEntity.ok(service.getWards(districtId));
    }

    // ─── Generic / dynamic endpoint ──────────────────────────────────────────

    /**
     * GET /api/v1/administrative-units?parentId=<id>
     *
     * parentId absent or null → returns all provinces
     * parentId = province id  → returns districts
     * parentId = district id  → returns wards
     */
    @GetMapping
    @Operation(
            summary = "Generic endpoint — lấy children theo parentId",
            description = "parentId=null → Tỉnh | parentId=tỉnh → Huyện | parentId=huyện → Xã"
    )
    public ResponseEntity<List<UnitDto>> getChildren(
            @RequestParam(required = false) Long parentId) {
        return ResponseEntity.ok(service.getChildren(parentId));
    }
}
