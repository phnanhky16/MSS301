-- V3__Insert_inventory_sample_data.sql
-- Sample inventory data for testing
-- Note: Using assumed product_id values (1-10) for testing purposes
-- In production, these should reference actual products from product-service

-- Insert sample warehouse products
-- Kho Hà Nội (warehouse_id = 1)
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, min_stock_level, max_stock_level, location_code) VALUES
(1, 1, 500, 50, 1000, 'A-01-01'),  -- Lego Classic
(1, 2, 300, 30, 800, 'A-01-02'),   -- Barbie Doll
(1, 3, 450, 40, 900, 'A-01-03'),   -- Hot Wheels Car Set
(1, 4, 200, 20, 500, 'A-02-01'),   -- Puzzle 1000 pieces
(1, 5, 350, 35, 700, 'A-02-02');   -- Robot Transformer

-- Kho TP.HCM (warehouse_id = 2)
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, min_stock_level, max_stock_level, location_code) VALUES
(2, 1, 600, 60, 1200, 'B-01-01'),  -- Lego Classic
(2, 2, 400, 40, 1000, 'B-01-02'),  -- Barbie Doll
(2, 3, 550, 50, 1100, 'B-01-03'),  -- Hot Wheels Car Set
(2, 6, 300, 30, 600, 'B-02-01'),   -- Baby Doll
(2, 7, 250, 25, 500, 'B-02-02'),   -- Construction Blocks
(2, 8, 400, 40, 800, 'B-03-01');   -- Educational Tablet

-- Kho Đà Nẵng (warehouse_id = 3)
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, min_stock_level, max_stock_level, location_code) VALUES
(3, 1, 300, 30, 600, 'C-01-01'),   -- Lego Classic
(3, 4, 150, 15, 400, 'C-01-02'),   -- Puzzle 1000 pieces
(3, 5, 200, 20, 500, 'C-02-01'),   -- Robot Transformer
(3, 9, 180, 18, 400, 'C-02-02'),   -- RC Car
(3, 10, 220, 22, 450, 'C-03-01');  -- Stuffed Animal

-- Insert sample store inventory
-- KidFavor Hà Nội - Royal City (store_id = 1)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
(1, 1, 50, 5, 'S1-A-01'),   -- Lego Classic
(1, 2, 40, 4, 'S1-A-02'),   -- Barbie Doll
(1, 3, 45, 5, 'S1-A-03'),   -- Hot Wheels Car Set
(1, 4, 30, 3, 'S1-B-01'),   -- Puzzle 1000 pieces
(1, 5, 35, 4, 'S1-B-02');   -- Robot Transformer

-- KidFavor TP.HCM - Crescent Mall (store_id = 2)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
(2, 1, 60, 6, 'S2-A-01'),   -- Lego Classic
(2, 2, 50, 5, 'S2-A-02'),   -- Barbie Doll
(2, 3, 55, 6, 'S2-A-03'),   -- Hot Wheels Car Set
(2, 6, 40, 4, 'S2-B-01'),   -- Baby Doll
(2, 7, 35, 4, 'S2-B-02'),   -- Construction Blocks
(2, 8, 45, 5, 'S2-C-01');   -- Educational Tablet

-- KidFavor Hà Nội - Times City (store_id = 3)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
(3, 1, 45, 5, 'S3-A-01'),   -- Lego Classic
(3, 2, 38, 4, 'S3-A-02'),   -- Barbie Doll
(3, 4, 28, 3, 'S3-B-01'),   -- Puzzle 1000 pieces
(3, 9, 32, 3, 'S3-C-01');   -- RC Car

-- KidFavor Đà Nẵng - Vincom (store_id = 4)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
(4, 1, 35, 4, 'S4-A-01'),   -- Lego Classic
(4, 4, 25, 3, 'S4-A-02'),   -- Puzzle 1000 pieces
(4, 5, 30, 3, 'S4-B-01'),   -- Robot Transformer
(4, 9, 28, 3, 'S4-B-02'),   -- RC Car
(4, 10, 33, 3, 'S4-C-01');  -- Stuffed Animal

-- KidFavor TP.HCM - Aeon Mall (store_id = 5)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
(5, 1, 55, 6, 'S5-A-01'),   -- Lego Classic
(5, 2, 48, 5, 'S5-A-02'),   -- Barbie Doll
(5, 6, 42, 4, 'S5-B-01'),   -- Baby Doll
(5, 7, 38, 4, 'S5-B-02'),   -- Construction Blocks
(5, 8, 50, 5, 'S5-C-01'),   -- Educational Tablet
(5, 10, 36, 4, 'S5-C-02');  -- Stuffed Animal
