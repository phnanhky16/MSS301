package com.kidfavor.addressservice.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Self-referencing entity for Vietnamese administrative divisions.
 * <p>
 * level 1 = Tỉnh / Thành phố (Province)
 * level 2 = Quận / Huyện      (District)
 * level 3 = Phường / Xã       (Ward)
 */
@Entity
@Table(
        name = "administrative_units",
        indexes = {
                @Index(name = "idx_au_parent", columnList = "parent_id"),
                @Index(name = "idx_au_level",  columnList = "level")
        }
)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdministrativeUnit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    /** Administrative code (e.g. "HCM", "01") — nullable */
    @Column(length = 50)
    private String code;

    /**
     * Hierarchy level:
     * 1 = Province, 2 = District, 3 = Ward
     */
    @Column(nullable = false)
    private Integer level;

    /** Parent unit id — null for top-level provinces */
    @Column(name = "parent_id")
    private Long parentId;
}
