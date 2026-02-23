package com.kidfavor.productservice.config;

import com.kidfavor.productservice.entity.Brand;
import com.kidfavor.productservice.entity.Category;
import com.kidfavor.productservice.entity.Product;
import com.kidfavor.productservice.enums.EntityStatus;
import com.kidfavor.productservice.repository.BrandRepository;
import com.kidfavor.productservice.repository.CategoryRepository;
import com.kidfavor.productservice.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * Data initializer for Product Service.
 * Creates sample categories, brands, and products for testing purposes.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final BrandRepository brandRepository;
    private final ProductRepository productRepository;

    @Override
    @Transactional
    public void run(String... args) {
        initCategories();
        initBrands();
        initProducts();
    }

    private void initCategories() {
        if (categoryRepository.count() > 0) {
            log.info("Categories already exist, skipping initialization. Total: {}", categoryRepository.count());
            return;
        }

        log.info("========================================");
        log.info("Initializing sample categories...");
        log.info("========================================");

        Category milkFormula = createCategory("Milk & Formula", "Baby milk powder and formula products");
        Category diapers = createCategory("Diapers & Wipes", "Diapers, baby wipes, and changing accessories");
        Category feeding = createCategory("Feeding", "Bottles, pacifiers, and feeding accessories");
        Category bathing = createCategory("Bath & Skincare", "Baby bath, shampoo, lotion, and skincare products");
        Category toys = createCategory("Toys & Games", "Educational toys and games for babies and toddlers");
        Category clothing = createCategory("Clothing", "Baby clothes and accessories");
        Category nursery = createCategory("Nursery", "Cribs, strollers, and nursery furniture");
        Category health = createCategory("Health & Safety", "Baby monitors, thermometers, and safety products");

        log.info("Created {} categories", categoryRepository.count());
    }

    private Category createCategory(String name, String description) {
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        category.setStatus(EntityStatus.ACTIVE);
        return categoryRepository.save(category);
    }

    private void initBrands() {
        if (brandRepository.count() > 0) {
            log.info("Brands already exist, skipping initialization. Total: {}", brandRepository.count());
            return;
        }

        log.info("========================================");
        log.info("Initializing sample brands...");
        log.info("========================================");

        createBrand("Abbott", "Global healthcare company specializing in nutrition", "https://example.com/abbott-logo.png");
        createBrand("Nestle", "World's largest food and beverage company", "https://example.com/nestle-logo.png");
        createBrand("Pampers", "Leading diaper brand by Procter & Gamble", "https://example.com/pampers-logo.png");
        createBrand("Huggies", "Premium diaper brand by Kimberly-Clark", "https://example.com/huggies-logo.png");
        createBrand("Pigeon", "Japanese baby care products manufacturer", "https://example.com/pigeon-logo.png");
        createBrand("Johnson & Johnson", "American healthcare and baby products company", "https://example.com/jnj-logo.png");
        createBrand("Fisher-Price", "American company that produces educational toys", "https://example.com/fisher-logo.png");
        createBrand("Chicco", "Italian baby products brand", "https://example.com/chicco-logo.png");

        log.info("Created {} brands", brandRepository.count());
    }

    private Brand createBrand(String name, String description, String logoUrl) {
        Brand brand = new Brand();
        brand.setName(name);
        brand.setDescription(description);
        brand.setLogoUrl(logoUrl);
        brand.setStatus(EntityStatus.ACTIVE);
        return brandRepository.save(brand);
    }

    private void initProducts() {
        if (productRepository.count() > 0) {
            log.info("Products already exist, skipping initialization. Total: {}", productRepository.count());
            return;
        }

        log.info("========================================");
        log.info("Initializing sample products...");
        log.info("========================================");

        // Get categories and brands
        Category milkFormula = categoryRepository.findAll().stream()
                .filter(c -> c.getName().equals("Milk & Formula")).findFirst().orElse(null);
        Category diapers = categoryRepository.findAll().stream()
                .filter(c -> c.getName().equals("Diapers & Wipes")).findFirst().orElse(null);
        Category feeding = categoryRepository.findAll().stream()
                .filter(c -> c.getName().equals("Feeding")).findFirst().orElse(null);
        Category bathing = categoryRepository.findAll().stream()
                .filter(c -> c.getName().equals("Bath & Skincare")).findFirst().orElse(null);
        Category toys = categoryRepository.findAll().stream()
                .filter(c -> c.getName().equals("Toys & Games")).findFirst().orElse(null);

        Brand abbott = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Abbott")).findFirst().orElse(null);
        Brand nestle = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Nestle")).findFirst().orElse(null);
        Brand pampers = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Pampers")).findFirst().orElse(null);
        Brand huggies = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Huggies")).findFirst().orElse(null);
        Brand pigeon = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Pigeon")).findFirst().orElse(null);
        Brand johnson = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Johnson & Johnson")).findFirst().orElse(null);
        Brand fisher = brandRepository.findAll().stream()
                .filter(b -> b.getName().equals("Fisher-Price")).findFirst().orElse(null);

        // Milk & Formula Products
        createProduct("Similac Pro-Advance Stage 1", 
                "Premium infant formula with 2'-FL HMO for immune support, 0-12 months",
                new BigDecimal("450000"), milkFormula, abbott, 100);
        createProduct("Similac Pro-Sensitive Stage 1",
                "Formula for sensitive tummies with 2'-FL HMO, 0-12 months",
                new BigDecimal("480000"), milkFormula, abbott, 75);
        createProduct("NAN Optipro 1",
                "Premium infant formula with optimized protein, 0-6 months",
                new BigDecimal("420000"), milkFormula, nestle, 120);
        createProduct("NAN Optipro 2",
                "Follow-on formula for growing babies, 6-12 months",
                new BigDecimal("380000"), milkFormula, nestle, 90);
        createProduct("Similac Gain Plus Stage 3",
                "Growing up milk for toddlers 1-3 years with brain development nutrients",
                new BigDecimal("520000"), milkFormula, abbott, 60);

        // Diapers Products
        createProduct("Pampers Premium Care Size M",
                "Ultra-soft diapers with air channels, 52 pcs, 6-11kg",
                new BigDecimal("320000"), diapers, pampers, 200);
        createProduct("Pampers Premium Care Size L",
                "Ultra-soft diapers with air channels, 46 pcs, 9-14kg",
                new BigDecimal("340000"), diapers, pampers, 180);
        createProduct("Huggies Natural Soft Size M",
                "Natural cotton soft diapers, 56 pcs, 5-10kg",
                new BigDecimal("290000"), diapers, huggies, 150);
        createProduct("Huggies Natural Soft Size L",
                "Natural cotton soft diapers, 48 pcs, 9-14kg",
                new BigDecimal("310000"), diapers, huggies, 140);
        createProduct("Pampers Baby Wipes Sensitive",
                "Gentle cleansing wipes for sensitive skin, 80 pcs",
                new BigDecimal("85000"), diapers, pampers, 300);

        // Feeding Products
        createProduct("Pigeon SofTouch Wide Neck Bottle 160ml",
                "Anti-colic bottle with natural latch nipple",
                new BigDecimal("180000"), feeding, pigeon, 80);
        createProduct("Pigeon SofTouch Wide Neck Bottle 240ml",
                "Anti-colic bottle with natural latch nipple, larger size",
                new BigDecimal("200000"), feeding, pigeon, 70);
        createProduct("Pigeon Silicone Pacifier S",
                "Orthodontic silicone pacifier for 0-5 months",
                new BigDecimal("75000"), feeding, pigeon, 120);
        createProduct("Pigeon Breast Pump Manual",
                "Comfortable manual breast pump with soft cushion",
                new BigDecimal("650000"), feeding, pigeon, 40);

        // Bath & Skincare Products
        createProduct("Johnson's Baby Shampoo 500ml",
                "No more tears formula, gentle for daily use",
                new BigDecimal("95000"), bathing, johnson, 150);
        createProduct("Johnson's Baby Lotion 200ml",
                "24-hour moisturizing lotion for baby's delicate skin",
                new BigDecimal("85000"), bathing, johnson, 160);
        createProduct("Johnson's Baby Bath 500ml",
                "Gentle cleansing for baby's head to toe",
                new BigDecimal("110000"), bathing, johnson, 140);
        createProduct("Johnson's Baby Oil 200ml",
                "Pure mineral oil for baby massage",
                new BigDecimal("75000"), bathing, johnson, 130);

        // Toys Products
        createProduct("Fisher-Price Laugh & Learn Smart Stages Chair",
                "Interactive learning chair with songs and phrases, 12m+",
                new BigDecimal("890000"), toys, fisher, 30);
        createProduct("Fisher-Price Rock-a-Stack",
                "Classic stacking rings toy for motor skill development, 6m+",
                new BigDecimal("180000"), toys, fisher, 50);
        createProduct("Fisher-Price Baby's First Blocks",
                "Colorful blocks for shape sorting, 6m+",
                new BigDecimal("220000"), toys, fisher, 45);

        log.info("Created {} products", productRepository.count());
    }

    private Product createProduct(String name, String description, BigDecimal price, 
                                   Category category, Brand brand, Integer stock) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setCategory(category);
        product.setBrand(brand);
        product.setStock(stock);
        product.setStatus(EntityStatus.ACTIVE);
        return productRepository.save(product);
    }
}
