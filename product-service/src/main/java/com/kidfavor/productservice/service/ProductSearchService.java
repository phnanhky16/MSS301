package com.kidfavor.productservice.service;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.SortOrder;
import co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import co.elastic.clients.elasticsearch._types.query_dsl.QueryBuilders;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import com.kidfavor.productservice.document.ProductDocument;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductSearchService {

    private final ElasticsearchClient esClient;
    private static final String INDEX_NAME = "products_alias";

    public List<ProductDocument> searchProducts(String keyword, Long categoryId, Long brandId, String status, int page,
            int size, String sortField, String sortDir) {
        try {
            BoolQuery.Builder boolQuery = QueryBuilders.bool();

            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = keyword.trim();
                // for very short keywords (e.g. 1-2 characters) the standard
                // analyzer will tokenize to something that rarely matches any full
                // product name; in that case fall back to edge_ngram/autocomplete
                // field which we also use for suggestions. this mirrors the UI
                // behaviour where typing "la" shows suggestions even though a
                // full-text search would return nothing.
                if (term.length() < 3) {
                    Query matchAutocomplete = QueryBuilders.match()
                            .field("name.autocomplete")
                            .query(term)
                            .operator(co.elastic.clients.elasticsearch._types.query_dsl.Operator.And)
                            .build()._toQuery();
                    boolQuery.must(matchAutocomplete);
                } else {
                    Query multiMatch = QueryBuilders.multiMatch()
                            .query(term)
                            .fields(List.of("name^5.0", "brand^2.0", "category^1.5", "description^0.5"))
                            .fuzziness("AUTO")
                            .build()._toQuery();
                    boolQuery.must(multiMatch);
                }
            }

            if (status != null && !status.equalsIgnoreCase("ALL")) {
                boolQuery.filter(f -> f.term(t -> t.field("status").value(status.toUpperCase())));
            }

            if (categoryId != null) {
                boolQuery.filter(f -> f.term(t -> t.field("categoryId").value(categoryId)));
            }

            if (brandId != null) {
                boolQuery.filter(f -> f.term(t -> t.field("brandId").value(brandId)));
            }

            SearchRequest.Builder requestBuilder = new SearchRequest.Builder()
                    .index(INDEX_NAME)
                    .query(boolQuery.build()._toQuery())
                    .from(page * size)
                    .size(size);

            if (sortField != null && !sortField.isEmpty()) {
                requestBuilder.sort(s -> s.field(f -> f.field(sortField)
                        .order("desc".equalsIgnoreCase(sortDir) ? SortOrder.Desc : SortOrder.Asc)));
            } else if (keyword != null && !keyword.trim().isEmpty()) {
                // If searching by keyword, sort by score first, then createdAt
                requestBuilder.sort(s -> s.score(sc -> sc));
                requestBuilder.sort(s -> s.field(f -> f.field("createdAt").order(SortOrder.Desc)));
            }

            SearchResponse<ProductDocument> response = esClient.search(requestBuilder.build(), ProductDocument.class);
            return response.hits().hits().stream().map(Hit::source).collect(Collectors.toList());

        } catch (IOException e) {
            log.error("Error searching in Elasticsearch", e);
            throw new RuntimeException("Search failed", e);
        }
    }

    public List<ProductDocument> autocomplete(String keyword) {
        try {
            Query edgeNgramQuery = QueryBuilders.match()
                    .field("name.autocomplete")
                    .query(keyword)
                    .operator(co.elastic.clients.elasticsearch._types.query_dsl.Operator.And)
                    .build()._toQuery();

            SearchRequest request = new SearchRequest.Builder()
                    .index(INDEX_NAME)
                    .query(edgeNgramQuery)
                    .size(5)
                    .build();

            SearchResponse<ProductDocument> response = esClient.search(request, ProductDocument.class);
            return response.hits().hits().stream().map(Hit::source).collect(Collectors.toList());
        } catch (IOException e) {
            log.error("Error autocomplete in Elasticsearch", e);
            throw new RuntimeException("Autocomplete failed", e);
        }
    }
}
