package com.kidfavor.productservice.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(indexName = "products_alias")
@Setting(settingPath = "elasticsearch/settings.json")
// ignore extra fields such as _class that may be added by ES
@com.fasterxml.jackson.annotation.JsonIgnoreProperties(ignoreUnknown = true)
public class ProductDocument {

    @Id
    @Field(type = FieldType.Keyword)
    private String id;

    @MultiField(mainField = @Field(type = FieldType.Text, analyzer = "standard"), otherFields = {
            @InnerField(suffix = "keyword", type = FieldType.Keyword, ignoreAbove = 256),
            @InnerField(suffix = "autocomplete", type = FieldType.Text, analyzer = "autocomplete_analyzer", searchAnalyzer = "autocomplete_search_analyzer")
    })
    private String name;

    @Field(type = FieldType.Text, analyzer = "standard")
    private String description;

    @Field(type = FieldType.Keyword)
    private String category;

    @Field(type = FieldType.Long)
    private Long categoryId;

    @Field(type = FieldType.Keyword)
    private String brand;

    @Field(type = FieldType.Long)
    private Long brandId;

    @Field(type = FieldType.Double)
    private BigDecimal price;

    @Field(type = FieldType.Float)
    private Float rating;

    @Field(type = FieldType.Integer, docValues = true)
    private Integer salesCount;

    @Field(type = FieldType.Date, format = {}, pattern = "uuuu-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime createdAt;

    @Field(type = FieldType.Keyword)
    private String status;

    @Field(type = FieldType.Keyword, index = false)
    private String imageUrl;

    @Field(type = FieldType.Integer, index = false)
    private Integer totalStock;
}
