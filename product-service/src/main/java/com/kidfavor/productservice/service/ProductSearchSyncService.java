package com.kidfavor.productservice.service;

import com.kidfavor.productservice.document.ProductDocument;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.repository.ProductElasticsearchRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductSearchSyncService {

    private final ProductRepository productRepository;
    private final ProductElasticsearchRepository elasticsearchRepository;

    @EventListener(ApplicationReadyEvent.class)
    public void initIndicesAfterStartup() {
        log.info("Checking if Elasticsearch product index is empty...");
        if (elasticsearchRepository.count() == 0) {
            log.info("Elasticsearch index is empty. Starting initial data sync from Database...");
            syncAllProductsToElasticsearch();
        } else {
            log.info("Elasticsearch index already contains data. Skipping initial sync.");
        }
    }

    // syncAllProducts executes synchronously on startup so that the index is
    // populated before the service begins handling search requests.  It uses
    // a custom repository method which eagerly fetches relations to avoid
    // LazyInitializationExceptions.
    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public void syncAllProductsToElasticsearch() {
        try {
            // use custom method to eagerly fetch associations
            List<Product> products = productRepository.findAllWithRelations();
            List<ProductDocument> documents = products.stream()
                    .map(this::mapToDocument)
                    .collect(Collectors.toList());

            if (!documents.isEmpty()) {
                elasticsearchRepository.saveAll(documents);
                log.info("Successfully synced {} products to Elasticsearch", documents.size());
            }
        } catch (Exception e) {
            log.error("Failed to sync products to Elasticsearch", e);
        }
    }

    @Async
    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public void syncProduct(Product product) {
        try {
            ProductDocument doc = mapToDocument(product);
            elasticsearchRepository.save(doc);
            log.debug("Synced product ID {} to Elasticsearch", product.getId());
        } catch (Exception e) {
            log.error("Failed to sync product ID {} to Elasticsearch", product.getId(), e);
        }
    }

    @Async
    public void deleteProductSync(Long id) {
        try {
            elasticsearchRepository.deleteById(String.valueOf(id));
            log.debug("Deleted product ID {} from Elasticsearch", id);
        } catch (Exception e) {
            log.error("Failed to delete product ID {} from Elasticsearch", id, e);
        }
    }

    private ProductDocument mapToDocument(Product product) {
        return ProductDocument.builder()
                .id(String.valueOf(product.getId()))
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categoryId(product.getCategory() != null ? product.getCategory().getId() : null)
                .category(product.getCategory() != null ? product.getCategory().getName() : null)
                .brandId(product.getBrand() != null ? product.getBrand().getId() : null)
                .brand(product.getBrand() != null ? product.getBrand().getName() : null)
                .status(product.getStatus() != null ? product.getStatus().name() : null)
                .createdAt(product.getCreatedAt())
                // Assuming first image as imageUrl
                .imageUrl(product.getImages() != null && !product.getImages().isEmpty()
                        ? product.getImages().get(0).getImageUrl()
                        : null)
                .build();
    }
}
