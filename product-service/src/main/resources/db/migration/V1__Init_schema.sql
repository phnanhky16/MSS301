-- =====================================================
-- PostgreSQL Database Schema for Product Service
-- =====================================================

-- Create brands table
CREATE TABLE brands (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255),
    logo_url VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    status_changed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(255),
    parent_id BIGINT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    status_changed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- Create products table
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(2000),
    price DECIMAL(19,2) NOT NULL,
    category_id BIGINT,
    brand_id BIGINT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    status_changed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Create product_images table
CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INTEGER DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create packages table
CREATE TABLE packages (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(19,2) NOT NULL,
    duration_months INTEGER,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_brands_status ON brands(status);
CREATE INDEX idx_categories_status ON categories(status);
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- =====================================================
-- Sample Data
-- =====================================================

-- Insert Brands
INSERT INTO brands (name, description, logo_url, status, created_at, updated_at) VALUES
('Fisher-Price', 'Leading brand in educational toys for children', 'https://example.com/logos/fisher-price.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO', 'Famous construction toys and building blocks', 'https://example.com/logos/lego.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Pampers', 'Premium baby care products and diapers', 'https://example.com/logos/pampers.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Huggies', 'Trusted baby diapers and wipes', 'https://example.com/logos/huggies.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Gerber', 'Quality baby food and nutrition products', 'https://example.com/logos/gerber.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Chicco', 'Italian brand for baby products', 'https://example.com/logos/chicco.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Melissa & Doug', 'Educational toys and crafts', 'https://example.com/logos/melissa-doug.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('VTech', 'Electronic learning toys', 'https://example.com/logos/vtech.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Categories
INSERT INTO categories (name, description, parent_id, status, created_at, updated_at) VALUES
('Toys', 'All types of toys for children', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Baby Care', 'Products for baby care and hygiene', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Clothing', 'Baby and kids clothing', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Food & Nutrition', 'Baby food and nutrition products', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Furniture', 'Kids furniture and room decor', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Subcategories
INSERT INTO categories (name, description, parent_id, status, created_at, updated_at) VALUES
('Educational Toys', 'Toys that help children learn', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Building Blocks', 'Construction and building toys', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Stuffed Animals', 'Soft toys and plushies', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Diapers', 'Baby diapers and training pants', 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Baby Wipes', 'Wet wipes for babies', 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Baby Bottles', 'Feeding bottles and accessories', 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Baby Formula', 'Infant formula and supplements', 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Baby Food', 'Ready-to-eat baby meals', 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Products
-- Educational Toys
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Laugh & Learn Smart Stages Puppy', 'Interactive learning toy that teaches first words, letters, and numbers', 29.99, 6, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('VTech Touch and Learn Activity Desk', 'Interactive desk with activities for letters, numbers, and music', 89.99, 6, 8, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Melissa & Doug Wooden Building Blocks', 'Classic wooden blocks set with 100 pieces', 34.99, 6, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Building Blocks
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('LEGO Classic Large Creative Brick Box', '790 pieces of colorful LEGO bricks for creative building', 59.99, 7, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO DUPLO My First Number Train', 'Learning toy for toddlers to learn numbers', 24.99, 7, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO City Fire Station', 'Complete fire station set with vehicles and figures', 89.99, 7, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Stuffed Animals
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Fisher-Price Soothe & Glow Seahorse', 'Soft plush seahorse with soothing music and lights', 19.99, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Melissa & Doug Giant Teddy Bear', 'Large stuffed teddy bear, perfect for hugs', 44.99, 8, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Diapers
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Pampers Swaddlers Newborn Diapers Size 1', 'Soft and absorbent diapers for newborns, 198 count', 49.99, 9, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Pampers Baby Dry Size 3', 'Overnight protection diapers, 162 count', 44.99, 9, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Huggies Little Snugglers Size 2', 'Gentle care diapers for sensitive skin, 180 count', 47.99, 9, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Huggies Pull-Ups Training Pants', 'Training pants for potty training, 84 count', 34.99, 9, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Baby Wipes
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Pampers Sensitive Water Baby Wipes', 'Gentle and hypoallergenic wipes, 9 packs (576 total)', 24.99, 10, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Huggies Natural Care Baby Wipes', 'Thick and gentle wipes, 8 packs (560 total)', 22.99, 10, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Baby Bottles
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Chicco Natural Feeling Bottle Set', 'Anti-colic bottles with natural nipple, 4-pack', 29.99, 11, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Chicco Well-Being Silicone Bottle', 'Silicone feeding bottle with physiological nipple', 19.99, 11, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Baby Formula & Food
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Gerber Good Start Gentle Infant Formula', 'Easy-to-digest infant formula, 12.7 oz', 32.99, 12, 5, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Gerber 1st Foods Banana Baby Food', 'Single ingredient banana puree, 6 jars', 6.99, 13, 5, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Gerber 2nd Foods Variety Pack', 'Mixed vegetables and fruits, 12 jars', 14.99, 13, 5, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Gerber Puffs Cereal Snack', 'Melt-in-mouth snacks for babies, 4 pack', 12.99, 13, 5, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Product Images
-- Product 1: Laugh & Learn Smart Stages Puppy (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(1, 'https://www.mykingdom.com.vn/cdn/shop/files/BRU02505-04-10.jpg?v=1715076822&width=1206', TRUE, 1),
(1, 'https://www.mykingdom.com.vn/cdn/shop/products/bruder-bru02505_2.jpg?v=1715076822&width=1206', FALSE, 2),
(1, 'https://www.mykingdom.com.vn/cdn/shop/products/bruder-bru02505_1.jpg?v=1715076822&width=1206', FALSE, 3);

-- Product 2: VTech Touch and Learn Activity Desk (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(2, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2670l28ptboaa.webp', TRUE, 1),
(2, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2670osj9ak2a8.webp', FALSE, 2),
(2, 'https://down-vn.img.susercontent.com/file/vn-11134207-7ras8-m2670ov15n049e.webp', FALSE, 3);

-- Product 3: Melissa & Doug Wooden Building Blocks (2 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(3, 'https://www.mykingdom.com.vn/cdn/shop/products/r99700_2.jpg?v=1718270988&width=1946', TRUE, 1),
(3, 'https://www.mykingdom.com.vn/cdn/shop/products/r99700_3.jpg?v=1718270988&width=1206', FALSE, 2);

-- Product 4: LEGO Classic Large Creative Brick Box (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(4, 'https://www.mykingdom.com.vn/cdn/shop/products/r98500_3.jpg?v=1751253934&width=1206', TRUE, 1),
(4, 'https://www.mykingdom.com.vn/cdn/shop/products/r98500_2.jpg?v=1751253934&width=1206', FALSE, 2),
(4, 'https://www.mykingdom.com.vn/cdn/shop/products/r98500_1.jpg?v=1751253934&width=1206', FALSE, 3);

-- Product 5: LEGO DUPLO My First Number Train (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(5, 'https://cdn.shopify.com/s/files/1/0731/6514/4343/files/con-quay-b-180-booster-dynamite-belial-nx-vn-2-173670_9464c799-20dd-4ef4-b769-4ecfb4ba9adc.jpg?v=1727233912&width=500', TRUE, 1),
(5, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-180-booster-dynamite-belial-nx-vn-2-173670.jpg?v=1721818516&width=1206', FALSE, 2),
(5, 'https://www.mykingdom.com.vn/cdn/shop/products/b-180_173670_copy_28.04.jpg?v=1721818592&width=1206', FALSE, 3);

-- Product 6: LEGO City Fire Station (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(6, 'https://www.mykingdom.com.vn/cdn/shop/products/179795_1.jpg?v=1742374683&width=1206', TRUE, 1),
(6, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-193-booster-ultimate-valkyrie-lg-v-9-179795_828c4518-1e77-48c0-9664-d364cef3a3b6.jpg?v=1742374683&width=1206', FALSE, 2),
(6, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-193-booster-ultimate-valkyrie-lg-v-9-179795.jpg?v=1742374683&width=1206', FALSE, 3);

-- Product 7: Fisher-Price Soothe & Glow Seahorse (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(7, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-slime-suu-tap-jurassic-world-tai-sinh-toy-monster-t01532_16.jpg?v=1749119463&width=1206', TRUE, 1),
(7, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-193-booster-ultimate-valkyrie-lg-v-9-179795.jpg?v=1742374683&width=1206', FALSE, 2),
(7, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-slime-suu-tap-jurassic-world-tai-sinh-toy-monster-t01532_10.jpg?v=1749119463&width=1206', FALSE, 3);

-- Product 8: Melissa & Doug Giant Teddy Bear (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_4.jpg?v=1748578116&width=1206', TRUE, 1),
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_6.jpg?v=1748578116&width=1206', FALSE, 2),
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_2.jpg?v=1748578116&width=1206', FALSE, 3);

-- Product 9: Pampers Swaddlers Newborn Diapers (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-tai-vang-vecto-vtb22-yl_2.jpg?v=1770965733&width=1206', TRUE, 1),
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-tai-vang-vecto-vtb22-yl_3.jpg?v=1770965733&width=1206', FALSE, 2),
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-tai-vang-vecto-vtb22-yl_1.jpg?v=1770965733&width=1206', FALSE, 3);

-- Product 10: Pampers Baby Dry Size 3 (3 images)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_1.png?v=1718951931&width=1206', TRUE, 1),
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_2.png?v=1742092208&width=1206', FALSE, 2),
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_3.png?v=1742092208&width=1206', FALSE, 3);

-- Diapers Images (Products 11-12)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(11, 'https://www.mykingdom.com.vn/cdn/shop/files/31145_1484650c-aea1-4fb3-89c5-556e78e4adec.jpg?v=1725510773&width=1206', TRUE, 1),
(11, 'https://www.mykingdom.com.vn/cdn/shop/products/31145_1.jpg?v=1725510783&width=1206', FALSE, 2),
(11, 'https://www.mykingdom.com.vn/cdn/shop/products/31145_2.jpg?v=1725510783&width=1206', FALSE, 3);


-- Baby Wipes Images
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(12, 'https://www.mykingdom.com.vn/cdn/shop/products/eu461542_11.jpg?v=1751253959&width=1206', TRUE, 1),
(12, 'https://www.mykingdom.com.vn/cdn/shop/files/184657108_1853183184850320_7116593188803475895_n.png?v=1751253960&width=1206', FALSE, 2),
(12, 'https://www.mykingdom.com.vn/cdn/shop/files/184808313_1853183104850328_8758095813255733170_n.png?v=1751253960&width=1206', FALSE, 3);

-- Baby Bottles Images
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/ba-lo-fancy-kitty-pinky-cleverhippo-bk1108-pink_4.jpg?v=1763695585&width=1206', TRUE, 1),
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/ba-lo-fancy-kitty-pinky-cleverhippo-bk1108-pink_2.jpg?v=1763695585&width=1206', FALSE, 2),
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/ba-lo-fancy-kitty-pinky-cleverhippo-bk1108-pink_3.jpg?v=1763695585&width=1206', FALSE, 3);

-- Product 14: Chicco Well-Being Silicone Bottle
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-choi-chan-bo-xanh-3-banh-scuttle-bug-xl-ride-on-8555_2.jpg?v=1763102695&width=1206', TRUE, 1),
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-choi-chan-bo-xanh-3-banh-scuttle-bug-xl-ride-on-8555_11.jpg?v=1763102695&width=1206', FALSE, 2),
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-choi-chan-bo-xanh-3-banh-scuttle-bug-xl-ride-on-8555_5.jpg?v=1763102695&width=1206', FALSE, 3);

-- Product 15: Huggies Little Snugglers Size 2
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(15, 'https://www.mykingdom.com.vn/cdn/shop/products/cm16-5p-bl_3__1_1f642a40-6625-4563-aaf8-0876f5425698.jpg?v=1746866123&width=1206', TRUE, 1),
(15, 'https://www.mykingdom.com.vn/cdn/shop/products/cm16-5p-bl_2__1_f31c0109-acfc-40ab-a571-396b6b4c5070.jpg?v=1746866123&width=1206', FALSE, 2),
(15, 'https://www.mykingdom.com.vn/cdn/shop/products/cm16-5p-bl-nentrang.jpg?v=1746866123&width=1206', FALSE, 3);

-- Product 16: Huggies Pull-Ups Training Pants
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_3.jpg?v=1770188893&width=1206', TRUE, 1),
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_4.jpg?v=1770188893&width=1206', FALSE, 2),
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_5.jpg?v=1770188893&width=1206', FALSE, 3);

-- Product 17: Gerber Good Start Gentle Infant Formula
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(17, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_4.jpg?v=1770188893&width=1206', TRUE, 1),
(17, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_5.jpg?v=1770188893&width=1206', FALSE, 2),
(17, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-pink-leopard-asian-barbie-jjn59_2.jpg?v=1770189057&width=1206', FALSE, 3);

-- Product 18: Gerber 1st Foods Banana Baby Food
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(18, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-b_c-thep-vang-vecto-vtb17-yl_1.jpg?v=1761559795&width=1206', TRUE, 1),
(18, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-b_c-thep-vang-vecto-vtb17-yl_3.jpg?v=1761559818&width=1206', FALSE, 2),
(18, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-bien-hinh-thanh-xe-b_c-thep-vang-vecto-vtb17-yl_2.jpg?v=1761559818&width=1206', FALSE, 3);

-- Product 19: Gerber 2nd Foods Variety Pack
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_1.jpg?v=1770267716&width=1206', TRUE, 1),
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_3.jpg?v=1770267716&width=1206', FALSE, 2),
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_7.jpg?v=1770267716&width=1206', FALSE, 3);

-- Product 20: Gerber Puffs Cereal Snack
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_2.jpg?v=1761559088&width=1206', TRUE, 1),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_3.jpg?v=1761559088&width=1206', FALSE, 2),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_1.jpg?v=1761559088&width=1206', FALSE, 3);
