package com.kidfavor.productservice.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ImageUploadResponse {
    private Long imageId;
    private String imageUrl;
    private String fileName;
    private Long fileSize;
    private String contentType;
    private Boolean isPrimary;
    private Integer displayOrder;
}
