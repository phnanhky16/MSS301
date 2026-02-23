package com.kidfavor.productservice.dto.request;

import com.kidfavor.productservice.enums.EntityStatus;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class StatusUpdateRequest {
    
    @NotNull(message = "Status is required")
    private EntityStatus status;
}
