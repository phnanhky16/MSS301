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
    sale_price NUMERIC(19,2),
    sale_start_date TIMESTAMP,
    sale_end_date TIMESTAMP,
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
('LEGO', 'Famous construction toys and building blocks', 'https://www.mykingdom.com.vn/cdn/shop/files/lego-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR', 'Remote control cars and vehicles', 'https://www.mykingdom.com.vn/cdn/shop/files/rastar-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Beyblade', 'Spinning tops and battling toys', 'https://www.mykingdom.com.vn/cdn/shop/files/beyblade-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Mattel', 'Global toy manufacturer', 'https://www.mykingdom.com.vn/cdn/shop/files/mattel-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Collecta', 'Realistic animal figurines', 'https://www.mykingdom.com.vn/cdn/shop/files/collecta-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Barbie', 'Fashion dolls and accessories', 'https://www.mykingdom.com.vn/cdn/shop/files/barbie-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Vecto', 'Innovative robot toys', 'https://www.mykingdom.com.vn/cdn/shop/files/vecto-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Miniforce', 'Police robot transformer series', 'https://www.mykingdom.com.vn/cdn/shop/files/miniforce-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Tobot', 'Korean transforming robot toys', 'https://www.mykingdom.com.vn/cdn/shop/files/tobot-logo.png', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Categories
INSERT INTO categories (name, description, parent_id, status, created_at, updated_at) VALUES
('Toys', 'All types of toys for children', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robots', 'Robot and transformer toys', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Dinosaurs', 'Dinosaur models and toys', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Dolls', 'Fashion dolls and doll sets', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Stuffed Animals', 'Soft toys and plushies', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Games', 'Board games and party games', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Toys for Babies', 'Educational toys for infants', NULL, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Subcategories
INSERT INTO categories (name, description, parent_id, status, created_at, updated_at) VALUES
('LEGO Sets', 'LEGO construction sets', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RC Vehicles', 'Remote control cars and vehicles', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Spinning Tops', 'Beyblade and spinning toys', 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Products
-- LEGO Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('LEGO Ninjago Rồng Thần Sức Mạnh Thunderfang', 'Bộ LEGO Ninjago Thunderfang Dragon set', 2850000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO City Trạm Bảo Dưỡng Xe F1', 'LEGO City F1 Service Station set', 3200000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Ninjago Chiến Giáp Của Cole', 'LEGO Ninjago Cole Armor set', 2100000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Marvel Người Nhện Đại Chiến', 'LEGO Marvel Spider-Man Epic Battle set', 2650000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Animals Rồng Đỏ May Mắn', 'LEGO Animals Lucky Red Dragon set', 1500000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Disney Vua Sư Tử Simba', 'LEGO Disney Lion King set', 2200000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Botanical Hoa Anh Đào', 'LEGO Botanical Cherry Blossoms set', 1800000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Technic Ferrari SF-24 F1', 'LEGO Technic Ferrari F1 racing car', 3500000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Technic Lamborghini Siêu Xe', 'LEGO Technic Lamborghini supercar', 3800000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('LEGO Technic Kawasaki Mô Tô Thể Thao', 'LEGO Technic Kawasaki sports motorcycle', 2900000, 8, 1, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- RC Vehicles Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('RASTAR Xe R/C Porsche 911 GT2 RS 1:24', 'Remote control Porsche 911 GT2 RS 1:24 scale', 1200000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR Xe R/C Mercedes-AMG F1 W11 1:18', 'Remote control Mercedes F1 car 1:18 scale', 1500000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR Xe Điều Khiển BMW i8 Bạc', 'Remote control BMW i8 silver car', 1000000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR Xe Điều Khiển Red Bull Racing RB18', 'Remote control Red Bull Racing F1 car 1:18', 1350000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR Xe Điều Khiển Lamborghini Aventador SVJ Vàng', 'Remote control Lamborghini yellow car 1:24', 1100000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RASTAR Xe Điều Khiển BMW 3.0 CSL Trắng', 'Remote control BMW white car 1:24', 1050000, 9, 2, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Spinning Tops Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Beyblade B-180 Booster Dynamite Belial', 'Beyblade metal spinner Dynamite Belial', 750000, 10, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Beyblade B-193 Booster Ultimate Valkyrie', 'Beyblade metal spinner Ultimate Valkyrie', 850000, 10, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Beyblade B-192 Booster Greatest Raphael', 'Beyblade metal spinner Greatest Raphael', 800000, 10, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Beyblade X BX-01 Starter Dran Sword', 'Beyblade X plastic spinner Dran Sword', 550000, 10, 3, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Robot Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Robot Chú Chó MAX Đáng Yêu', 'Cute robot dog MAX with AI features', 2500000, 2, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robot Mèo Con Thông Thái VECTO VT2059', 'Smart cat robot VECTO VT2059', 2200000, 2, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robot Siêu Cảnh Sát Tuần Tra Patrol Cop', 'Police patrol robot transformer', 1800000, 2, 8, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Tobot Biến Hình Chiến Binh Nhiệt Huyết Z', 'Tobot Z red warrior robot transformer', 1900000, 2, 9, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Tobot Biến Hình Chiến Binh Thần Tốc Y', 'Tobot Y yellow warrior robot transformer', 1900000, 2, 9, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robot Siêu Cảnh Sát Xây Dựng Build Cop', 'Construction robot transformer Build Cop', 1750000, 2, 8, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robot Chỉ Huy Captain Commander', 'Captain Commander robot transformer', 2100000, 2, 8, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Đồ Chơi Robot Đặc Vụ AGENT 04', 'Agent 04 spy robot remote control', 1600000, 2, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Robot Biến Hình điều Khiển từ xa STRIKE', 'STRIKE transforming robot remote control', 2300000, 2, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Dinosaur Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Mô Hình SaGa Khủng Long Chiến Đấu T-REX', 'SaGa T-REX battle dinosaur model', 1400000, 3, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Trứng Slime Sưu Tập Jurassic World', 'Jurassic World slime egg collection', 550000, 3, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Trứng Khủng Long Huyền Bí Jurassic World', 'Jurassic World mystery dinosaur egg', 680000, 3, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Khủng Long VELOCIRAPTOR BLUE', 'Velociraptor Blue dinosaur model', 1100000, 3, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('SaGa Khủng Long Chiến Đấu Carnotaurus', 'SaGa Carnotaurus battle dinosaur', 1450000, 3, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Động Vật Khủng Long Tyrannosaurus Rex', 'Collecta Tyrannosaurus Rex animal model', 950000, 3, 5, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Doll Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Búp Bê Thời Trang Fashionista - Arm Cast Millie', 'Barbie Fashionista doll Arm Cast Millie', 850000, 4, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Búp Bê Thời Trang Fashionista - Pink Leopard', 'Barbie Fashionista doll Pink Leopard', 850000, 4, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Công Chúa Disney Princess - Cinderella', 'Cinderella Disney Princess royal doll', 1200000, 4, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Búp Bê Thời Trang Fashionista - Blue Bows', 'Barbie Fashionista doll Blue Bows', 850000, 4, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Búp Bê Barbie Thời Trang - Pink Dress Diamonds', 'Barbie Fashion doll pink dress with diamonds', 900000, 4, 6, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Stuffed Animals Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Nhồi Bông DogDay POPPY PLAYTIME', 'DogDay plush toy from Poppy Playtime', 650000, 5, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Đồ Chơi Móc Khoá Nhồi Bông Miffy', 'Miffy plush keychain toy', 280000, 5, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Nhồi Bông Panda Roll Lying Down', 'Panda Roll lying down plush toy', 420000, 5, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('CraftyCorn POPPY PLAYTIME Nhồi Bông', 'CraftyCorn plush toy from Poppy Playtime', 680000, 5, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Games Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Cờ Tỷ Phú - Monopoly Premium', 'Premium Monopoly board game', 850000, 6, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Cờ Tỷ Phú Cơ Bản MONOPOLY C1009', 'Classic Monopoly board game', 650000, 6, 4, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Trò Chơi Lô Tô SPIN GAMES 6038108', 'Spin Games Lotto game', 450000, 6, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Trò Chơi Cờ Vua SPIN GAMES', 'Spin Games chess board game', 500000, 6, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Baby Toys Products
INSERT INTO products (name, description, price, category_id, brand_id, status, created_at, updated_at) VALUES
('Xe Tập Đi 3 Trong 1', '3 in 1 learning walking car', 1200000, 7, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Laptop Màu Xanh - Đồ Chơi Học Tập', 'Blue learning laptop toy for babies', 650000, 7, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Xe Bus Vui Học', 'Fun learning school bus toy', 1100000, 7, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Đồ Chơi Câu Cá - Hà Mã', 'Hippo fishing game toy', 480000, 7, 7, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert Product Images
-- LEGO Products Images (1-10)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(1, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-rong-than-suc-manh-thunderfang-lego-ninjago-71832.png?v=1765777873&width=1206', TRUE, 1),
(1, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-rong-than-suc-manh-thunderfang-lego-ninjago-71832_1.jpg?v=1765777873&width=1206', FALSE, 2),
(1, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-rong-than-suc-manh-thunderfang-lego-ninjago-71832_2.png?v=1765777873&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(2, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-tram-bao-duong-xe-f1-lego-city-60443.png?v=1741235306&width=1206', TRUE, 1),
(2, 'https://www.mykingdom.com.vn/cdn/shop/files/1_d9f4e19d-18c9-4e8f-937c-be91e57fc261.jpg?v=1741235306&width=1206', FALSE, 2),
(2, 'https://www.mykingdom.com.vn/cdn/shop/files/2_c7383568-8873-4f10-a958-80409a076fa3.jpg?v=1741235306&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(3, 'https://www.mykingdom.com.vn/cdn/shop/files/71806_4bd05f3b-92a3-4f59-9596-fc0d990b708b.jpg?v=1725524372&width=1206', TRUE, 1),
(3, 'https://www.mykingdom.com.vn/cdn/shop/products/71806_1.jpg?v=1725524380&width=1206', FALSE, 2),
(3, 'https://www.mykingdom.com.vn/cdn/shop/products/71806_1-2.jpg?v=1725524380&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(4, 'https://www.mykingdom.com.vn/cdn/shop/files/1_8e7520f2-c305-4c0e-9427-f25ff22b6169.jpg?v=1753684633&width=1206', TRUE, 1),
(4, 'https://www.mykingdom.com.vn/cdn/shop/files/2_ef0a6f11-0f0e-4ea9-adce-d63337d0f5e8.jpg?v=1734881226&width=1206', FALSE, 2),
(4, 'https://www.mykingdom.com.vn/cdn/shop/files/3_4599d168-1a63-431c-82a5-b6436acc8878.jpg?v=1734881226&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(5, 'https://www.mykingdom.com.vn/cdn/shop/files/31145_1484650c-aea1-4fb3-89c5-556e78e4adec.jpg?v=1725510773&width=1206', TRUE, 1),
(5, 'https://www.mykingdom.com.vn/cdn/shop/products/31145_1.jpg?v=1725510783&width=1206', FALSE, 2),
(5, 'https://www.mykingdom.com.vn/cdn/shop/products/31145_1-1.jpg?v=1725510783&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(6, 'https://www.mykingdom.com.vn/cdn/shop/files/43243.jpg?v=1726764324&width=1206', TRUE, 1),
(6, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-vua-su-tu-simba-lego-disney-princess-43243_1.jpg?v=1715755593&width=1206', FALSE, 2),
(6, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-vua-su-tu-simba-lego-disney-princess-43243_1.2.jpg?v=1715755599&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(7, 'https://www.mykingdom.com.vn/cdn/shop/files/40725_a392e2ad-825f-4c0e-a864-4abe044302de.jpg?v=1725519642&width=1206', TRUE, 1),
(7, 'https://www.mykingdom.com.vn/cdn/shop/products/40725_1_dc5699f3-dfa1-40de-ade0-11ad92169507.jpg?v=1725519648&width=1206', FALSE, 2),
(7, 'https://www.mykingdom.com.vn/cdn/shop/products/40725_1-2_48cb6d28-aa59-4250-9e36-282ddd32f6ae.jpg?v=1725519648&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-xe-ferrari-sf-24-f1-lego-technic-42207_0.jpg?v=1765774445&width=1206', TRUE, 1),
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-xe-ferrari-sf-24-f1-lego-technic-42207_2.png?v=1765774445&width=1206', FALSE, 2),
(8, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-lap-rap-xe-ferrari-sf-24-f1-lego-technic-42207_6.jpg?v=1765774445&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/42161_d5649b1a-7db4-47a5-b841-02ba476300c9.jpg?v=1725519736&width=1206', TRUE, 1),
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/945918a1fc1166f415ba6a5e120e6c89.jpg?v=1725519747&width=1206', FALSE, 2),
(9, 'https://www.mykingdom.com.vn/cdn/shop/files/c8d746fe5683330e441785b0993ec6f4.jpg?v=1725519747&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/42170_92188d78-2f65-4dbf-a641-88c1ef93aca7.jpg?v=1767842094&width=1206', TRUE, 1),
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/42170copy0.jpg?v=1767842094&width=1206', FALSE, 2),
(10, 'https://www.mykingdom.com.vn/cdn/shop/files/42170copy1.jpg?v=1767842094&width=1206', FALSE, 3);

-- RC Vehicles Images (11-16)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(11, 'https://www.mykingdom.com.vn/cdn/shop/products/r99700_2.jpg?v=1718270988&width=1206', TRUE, 1),
(11, 'https://www.mykingdom.com.vn/cdn/shop/products/r99700_3.jpg?v=1718270988&width=1206', FALSE, 2),
(11, 'https://www.mykingdom.com.vn/cdn/shop/products/r99700_1.jpg?v=1718270988&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(12, 'https://www.mykingdom.com.vn/cdn/shop/files/r98500.jpg?v=1751253934&width=1206', TRUE, 1),
(12, 'https://www.mykingdom.com.vn/cdn/shop/products/r98500_3.jpg?v=1751253934&width=1206', FALSE, 2),
(12, 'https://www.mykingdom.com.vn/cdn/shop/products/r98500_2.jpg?v=1751253934&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-bmw-i8-bac-r48400-2_1.png?v=1751253978&width=1206', TRUE, 1),
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-bmw-i8-bac-r48400-2_3.png?v=1751253978&width=1206', FALSE, 2),
(13, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-bmw-i8-bac-r48400-2_4.png?v=1751253978&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-18-oracle-red-bull-racing-rb18-xanh-duong-dam-rastar-r94800.jpg?v=1746864584&width=1206', TRUE, 1),
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-18-oracle-red-bull-racing-rb18-xanh-duong-dam-rastar-r94800_1.jpg?v=1746864584&width=1206', FALSE, 2),
(14, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-18-oracle-red-bull-racing-rb18-xanh-duong-dam-rastar-r94800_8.jpg?v=1746864584&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(15, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-24-lamborghini-aventador-svj-mau-vang-r96100-yel.jpg?v=1746863989&width=1206', TRUE, 1),
(15, 'https://www.mykingdom.com.vn/cdn/shop/products/r96100-yel-09.11_1.png?v=1746863989&width=1206', FALSE, 2),
(15, 'https://www.mykingdom.com.vn/cdn/shop/products/r96100_yel_1.jpg?v=1746863989&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/R92900-WHI.png?v=1751253883&width=1206', TRUE, 1),
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-24-bmw-3-0-csl-trang-rastar-r92900_520a871f-a5cc-455f-8a6a-b4388126d4fb.png?v=1751253883&width=1206', FALSE, 2),
(16, 'https://www.mykingdom.com.vn/cdn/shop/files/xe-dieu-khien-1-24-bmw-3-0-csl-trang-rastar-r92900.png?v=1751253883&width=1206', FALSE, 3);

-- Spinning Tops Images (17-20)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(17, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-180-booster-dynamite-belial-nx-vn-2-173670_9464c799-20dd-4ef4-b769-4ecfb4ba9adc.jpg?v=1727233912&width=1206', TRUE, 1),
(17, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-180-booster-dynamite-belial-nx-vn-2-173670.jpg?v=1721818516&width=1206', FALSE, 2),
(17, 'https://www.mykingdom.com.vn/cdn/shop/products/b-180_173670_copy_28.04.jpg?v=1721818592&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(18, 'https://www.mykingdom.com.vn/cdn/shop/products/179795_1.jpg?v=1742374683&width=1206', TRUE, 1),
(18, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-193-booster-ultimate-valkyrie-lg-v-9-179795.jpg?v=1742374683&width=1206', FALSE, 2),
(18, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-193-booster-ultimate-valkyrie-lg-v-9-179795_828c4518-1e77-48c0-9664-d364cef3a3b6.jpg?v=1742374683&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-192-booster-greatest-raphael-ov-hxt-173779_a0054b44-7900-47f7-a059-f56d79fb5de6.jpg?v=1727233221&width=1206', TRUE, 1),
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-b-192-booster-greatest-raphael-ov-hxt-173779.jpg?v=1742290365&width=1206', FALSE, 2),
(19, 'https://www.mykingdom.com.vn/cdn/shop/products/b-192_173779_3.jpg?v=1742290365&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/910381.jpg?v=1767861781&width=1206', TRUE, 1),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-bx-01-starter-dran-sword-3-60f-beyblade-x-910381_4.jpg?v=1767861781&width=1206', FALSE, 2),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/con-quay-bx-01-starter-dran-sword-3-60f-beyblade-x-910381_2.jpg?v=1767861781&width=1206', FALSE, 3);

-- Robot Images (21-29)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(21, 'https://www.mykingdom.com.vn/cdn/shop/files/c7a7651269aca042641df9fc3232bfc8.jpg?v=1768717531&width=1206', TRUE, 1),
(21, 'https://www.mykingdom.com.vn/cdn/shop/files/a2b79687e5cec29c7e7566787857085c.jpg?v=1768717531&width=1206', FALSE, 2),
(21, 'https://www.mykingdom.com.vn/cdn/shop/files/a05f9fcd961511273148ae3aae96c861.jpg?v=1751253906&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(22, 'https://www.mykingdom.com.vn/cdn/shop/products/vt2059_2.jpg?v=1751253955&width=1206', TRUE, 1),
(22, 'https://www.mykingdom.com.vn/cdn/shop/products/vt2059_3.jpg?v=1751253955&width=1206', FALSE, 2),
(22, 'https://www.mykingdom.com.vn/cdn/shop/products/vt2059_1.jpg?v=1751253955&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(23, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-tuan-tra-patrol-cop-dien-nang-miniiforce-505001_1.png?v=1718945152&width=1206', TRUE, 1),
(23, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-tuan-tra-patrol-cop-dien-nang-miniiforce-505001_2.png?v=1758857174&width=1206', FALSE, 2),
(23, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-tuan-tra-patrol-cop-dien-nang-miniiforce-505001_3.png?v=1758857175&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(24, 'https://www.mykingdom.com.vn/cdn/shop/files/301157.jpg?v=1751253845&width=1206', TRUE, 1),
(24, 'https://www.mykingdom.com.vn/cdn/shop/files/tobot-bien-hinh-chien-binh-nhiet-huyet-z-tobot-301157.png?v=1751253845&width=1206', FALSE, 2),
(24, 'https://www.mykingdom.com.vn/cdn/shop/files/tobot-bien-hinh-chien-binh-nhiet-huyet-z-tobot-301157_1.jpg?v=1751253845&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(25, 'https://www.mykingdom.com.vn/cdn/shop/files/301156.jpg?v=1727604770&width=1206', TRUE, 1),
(25, 'https://www.mykingdom.com.vn/cdn/shop/files/tobot-bien-hinh-chien-binh-than-toc-y-tobot-301156_2.png?v=1721965397&width=1206', FALSE, 2),
(25, 'https://www.mykingdom.com.vn/cdn/shop/files/tobot-bien-hinh-chien-binh-than-toc-y-tobot-301156_3.jpg?v=1721880912&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(26, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_1.png?v=1718951931&width=1206', TRUE, 1),
(26, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_2.png?v=1742092208&width=1206', FALSE, 2),
(26, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-sieu-canh-sat-xay-dung-build-cop-tho-nang-miniforce-505003_3.png?v=1742092208&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(27, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-chi-huy-captain-commander-bien-hinh-xe-container-miniforce-505011_1.png?v=1718952670&width=1206', TRUE, 1),
(27, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-chi-huy-captain-commander-bien-hinh-xe-container-miniforce-505011_2.png?v=1718952669&width=1206', FALSE, 2),
(27, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-chi-huy-captain-commander-bien-hinh-xe-container-miniforce-505011_3.png?v=1718952670&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(28, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-dac-vu-agent-04-dieu-khien-tu-xa-vecto-vt5099_3.jpg?v=1760064534&width=1206', TRUE, 1),
(28, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-dac-vu-agent-04-dieu-khien-tu-xa-vecto-vt5099_4.jpg?v=1760064534&width=1206', FALSE, 2),
(28, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-dac-vu-agent-04-dieu-khien-tu-xa-vecto-vt5099_2.jpg?v=1760064534&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(29, 'https://www.mykingdom.com.vn/cdn/shop/products/vtk4_2_6de83dd8-0edb-429f-874d-038154b94d4a.jpg?v=1706986074&width=1206', TRUE, 1),
(29, 'https://www.mykingdom.com.vn/cdn/shop/products/vtk4_3_8bb1f17b-0068-4587-b91f-736fe6757677.jpg?v=1706986074&width=1206', FALSE, 2),
(29, 'https://www.mykingdom.com.vn/cdn/shop/products/vtk4_1_0e36b885-ae24-4460-8e89-e994b9187777.jpg?v=1706986074&width=1206', FALSE, 3);

-- Dinosaur Images (30-35)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(30, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_4.jpg?v=1748578116&width=1206', TRUE, 1),
(30, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_6.jpg?v=1748578116&width=1206', FALSE, 2),
(30, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-t-rex-jurassic-world-mattel-jgm14-jgm12_1.jpg?v=1748578116&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(31, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-slime-suu-tap-jurassic-world-tai-sinh-toy-monster-t01532_16.jpg?v=1749119463&width=1206', TRUE, 1),
(31, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-slime-suu-tap-jurassic-world-tai-sinh-toy-monster-t01532_10.jpg?v=1749119463&width=1206', FALSE, 2),
(31, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-slime-suu-tap-jurassic-world-tai-sinh-toy-monster-t01532_11.jpg?v=1749119463&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(32, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-khung-long-huyen-bi-jurassic-world-tai-sinh-toy-monster-t01533_2.jpg?v=1748924541&width=1206', TRUE, 1),
(32, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-khung-long-huyen-bi-jurassic-world-tai-sinh-toy-monster-t01533_13.jpg?v=1748924541&width=1206', FALSE, 2),
(32, 'https://www.mykingdom.com.vn/cdn/shop/files/trung-khung-long-huyen-bi-jurassic-world-tai-sinh-toy-monster-t01533_14.jpg?v=1748924541&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(33, 'https://www.mykingdom.com.vn/cdn/shop/products/gfm01_c_22_01.jpg?v=1720148274&width=1206', TRUE, 1),
(33, 'https://www.mykingdom.com.vn/cdn/shop/products/gfm01_c_22_05.jpg?v=1720148274&width=1206', FALSE, 2),
(33, 'https://www.mykingdom.com.vn/cdn/shop/products/gfm01_c_22_03.jpg?v=1720148274&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(34, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-carnotaurus-jurassic-world-mattel-jgm15-jgm12_3.jpg?v=1762154422&width=1206', TRUE, 1),
(34, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-carnotaurus-jurassic-world-mattel-jgm15-jgm12_6.jpg?v=1762154422&width=1206', FALSE, 2),
(34, 'https://www.mykingdom.com.vn/cdn/shop/files/saga-khung-long-chien-dau-carnotaurus-jurassic-world-mattel-jgm15-jgm12_5.jpg?v=1762154422&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(35, 'https://www.mykingdom.com.vn/cdn/shop/files/mo-hinh-dong-vat-khung-long-tyrannosaurus-rex-collecta-88118_3.jpg?v=1757130999&width=1206', TRUE, 1),
(35, 'https://www.mykingdom.com.vn/cdn/shop/files/mo-hinh-dong-vat-khung-long-tyrannosaurus-rex-collecta-88118_1.jpg?v=1757130999&width=1206', FALSE, 2),
(35, 'https://www.mykingdom.com.vn/cdn/shop/files/mo-hinh-dong-vat-khung-long-tyrannosaurus-rex-collecta-88118_2.jpg?v=1757130999&width=1206', FALSE, 3);

-- Doll Images (36-40)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(36, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_3.jpg?v=1770188893&width=1206', TRUE, 1),
(36, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_4.jpg?v=1770188893&width=1206', FALSE, 2),
(36, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-arm-cast-millie-barbie-jjn56_5.jpg?v=1770188893&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(37, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-pink-leopard-asian-barbie-jjn59_3.jpg?v=1770189057&width=1206', TRUE, 1),
(37, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-pink-leopard-asian-barbie-jjn59_2.jpg?v=1770189057&width=1206', FALSE, 2),
(37, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-pink-leopard-asian-barbie-jjn59_4.jpg?v=1770189057&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(38, 'https://www.mykingdom.com.vn/cdn/shop/files/cong-chua-disney-princess-vien-ngoc-ky-dieu-cua-cinderella-disney-princess-mattel-jhl50-jhl48_2.jpg?v=1770191408&width=1206', TRUE, 1),
(38, 'https://www.mykingdom.com.vn/cdn/shop/files/cong-chua-disney-princess-vien-ngoc-ky-dieu-cua-cinderella-disney-princess-mattel-jhl50-jhl48_4.jpg?v=1770191408&width=1206', FALSE, 2),
(38, 'https://www.mykingdom.com.vn/cdn/shop/files/cong-chua-disney-princess-vien-ngoc-ky-dieu-cua-cinderella-disney-princess-mattel-jhl50-jhl48_3.jpg?v=1770191408&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(39, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-blue-bows-barbie-hyt93_1.jpg?v=1770185401&width=1206', TRUE, 1),
(39, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-blue-bows-barbie-hyt93_4.jpg?v=1770185425&width=1206', FALSE, 2),
(39, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-thoi-trang-fashionista-barbie-blue-bows-barbie-hyt93_2.jpg?v=1770185425&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(40, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-barbie-thoi-trang-pink-dress-diamonds-barbie-jlg07-t7439_3.jpg?v=1770197883&width=1206', TRUE, 1),
(40, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-barbie-thoi-trang-pink-dress-diamonds-barbie-jlg07-t7439_2.jpg?v=1770197883&width=1206', FALSE, 2),
(40, 'https://www.mykingdom.com.vn/cdn/shop/files/bup-be-barbie-thoi-trang-pink-dress-diamonds-barbie-jlg07-t7439_4.jpg?v=1770197883&width=1206', FALSE, 3);

-- Stuffed Animals Images (41-44)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(41, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-dogday-CP7752_1.jpg?v=1739247258&width=1206', TRUE, 1),
(41, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-dogday-CP7752_2.jpg?v=1739247258&width=1206', FALSE, 2),
(41, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-dogday-CP7752_4.jpg?v=1739247264&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(42, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-moc-khoa-nhoi-bong-miffy-mif37442_1.jpg?v=1763026886&width=1206', TRUE, 1),
(42, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-moc-khoa-nhoi-bong-miffy-mif37442_21.jpg?v=1763027045&width=1206', FALSE, 2),
(42, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-moc-khoa-nhoi-bong-miffy-mif37442_20.jpg?v=1763027045&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(43, 'https://www.mykingdom.com.vn/cdn/shop/files/nhan-vat-nhoi-bong-panda-roll-lying-down-magnetic-shoulder-6958985028523_3.jpg?v=1738830523&width=1206', TRUE, 1),
(43, 'https://www.mykingdom.com.vn/cdn/shop/files/nhan-vat-nhoi-bong-panda-roll-lying-down-magnetic-shoulder-6958985028523_2.jpg?v=1738830523&width=1206', FALSE, 2);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(44, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-craftycorn-cp7753_1.jpg?v=1739247560&width=1206', TRUE, 1),
(44, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-craftycorn-cp7753_2.jpg?v=1739247560&width=1206', FALSE, 2),
(44, 'https://www.mykingdom.com.vn/cdn/shop/files/thu-nhoi-bong-poppy-playtime-craftycorn-cp7753_4.jpg?v=1739247560&width=1206', FALSE, 3);

-- Games Images (45-48)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(45, 'https://www.mykingdom.com.vn/cdn/shop/products/e8978_1.jpg?v=1751253932&width=1206', TRUE, 1),
(45, 'https://www.mykingdom.com.vn/cdn/shop/products/e8978_2.jpg?v=1751253932&width=1206', FALSE, 2),
(45, 'https://www.mykingdom.com.vn/cdn/shop/products/e8978_4.jpg?v=1751253933&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(46, 'https://www.mykingdom.com.vn/cdn/shop/products/C1009_2.jpg?v=1724138591&width=1206', TRUE, 1),
(46, 'https://www.mykingdom.com.vn/cdn/shop/products/C1009_1.jpg?v=1724138591&width=1206', FALSE, 2);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(47, 'https://www.mykingdom.com.vn/cdn/shop/products/6038108-1.jpg?v=1684962986&width=1206', TRUE, 1),
(47, 'https://www.mykingdom.com.vn/cdn/shop/products/6038108-2.jpg?v=1684962986&width=1206', FALSE, 2),
(47, 'https://www.mykingdom.com.vn/cdn/shop/products/6038108-3.jpg?v=1684962986&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(48, 'https://www.mykingdom.com.vn/cdn/shop/products/6038140-1.jpg?v=1684963024&width=1206', TRUE, 1),
(48, 'https://www.mykingdom.com.vn/cdn/shop/files/214288dc713a29801f6ced4a8c96e6eb.jpg?v=1706805547&width=1206', FALSE, 2),
(48, 'https://www.mykingdom.com.vn/cdn/shop/files/0a7f07c5f1e16d503d8e8cb1bb20790d.jpg?v=1706805550&width=1206', FALSE, 3);

-- Baby Toys Images (49-52)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(49, 'https://www.mykingdom.com.vn/cdn/shop/products/eu461542_11.jpg?v=1751253959&width=1206', TRUE, 1),
(49, 'https://www.mykingdom.com.vn/cdn/shop/files/184657108_1853183184850320_7116593188803475895_n.png?v=1751253960&width=1206', FALSE, 2),
(49, 'https://www.mykingdom.com.vn/cdn/shop/files/184808313_1853183104850328_8758095813255733170_n.png?v=1751253960&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(50, 'https://www.mykingdom.com.vn/cdn/shop/files/eca12596e4e8da03a4f43039dc45d49f.jpg?v=1751253981&width=1206', TRUE, 1),
(50, 'https://www.mykingdom.com.vn/cdn/shop/files/b86672e14e1e7ccb30612658e3d4e65e.jpg?v=1751253981&width=1206', FALSE, 2),
(50, 'https://www.mykingdom.com.vn/cdn/shop/files/4d8e0378d9f14cab7d95d6d64ba47b09.jpg?v=1751253982&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(51, 'https://www.mykingdom.com.vn/cdn/shop/files/80-601300_c9eafcb5-8875-48a6-a68c-2724d40f59dd.jpg?v=1765765996&width=1206', TRUE, 1),
(51, 'https://www.mykingdom.com.vn/cdn/shop/products/06_232_1.jpg?v=1765765996&width=1206', FALSE, 2),
(51, 'https://www.mykingdom.com.vn/cdn/shop/products/07_220_1.jpg?v=1765765996&width=1206', FALSE, 3);

INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(52, 'https://www.mykingdom.com.vn/cdn/shop/files/PAB026.jpg?v=1751253930&width=1206', TRUE, 1),
(52, 'https://www.mykingdom.com.vn/cdn/shop/files/PAB026_642b83a6-7dd7-49d3-95ad-213a2f807edc.jpg?v=1751253930&width=1206', FALSE, 2),
(52, 'https://www.mykingdom.com.vn/cdn/shop/products/pab026_6.jpg?v=1751253931&width=1206', FALSE, 3);

-- Insert Product Images
-- LEGO Products Images (1-10)
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_1.jpg?v=1770267716&width=1206', TRUE, 1),
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_3.jpg?v=1770267716&width=1206', FALSE, 2),
(19, 'https://www.mykingdom.com.vn/cdn/shop/files/robot-bien-hinh-co-lon-jett-phien-ban-dac-biet-superwings-eu710210n_7.jpg?v=1770267716&width=1206', FALSE, 3);

-- Product 20: Gerber Puffs Cereal Snack
INSERT INTO product_images (product_id, image_url, is_primary, display_order) VALUES
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_2.jpg?v=1761559088&width=1206', TRUE, 1),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_3.jpg?v=1761559088&width=1206', FALSE, 2),
(20, 'https://www.mykingdom.com.vn/cdn/shop/files/do-choi-robot-meo-puffy-mum-mim-dieu-khien-tu-xa-trang-vecto-vtk48-wh_1.jpg?v=1761559088&width=1206', FALSE, 3);
