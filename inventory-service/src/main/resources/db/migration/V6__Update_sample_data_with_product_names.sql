-- V6__Update_sample_data_with_product_names.sql
-- Update existing sample data with product names

-- Update warehouse_products with product names
UPDATE warehouse_products SET product_name = 'Lego Classic' WHERE product_id = 1;
UPDATE warehouse_products SET product_name = 'Barbie Doll' WHERE product_id = 2;
UPDATE warehouse_products SET product_name = 'Iphone 15' WHERE product_id = 3;
UPDATE warehouse_products SET product_name = 'Puzzle 1000 pieces' WHERE product_id = 4;
UPDATE warehouse_products SET product_name = 'Robot Transformer' WHERE product_id = 5;
UPDATE warehouse_products SET product_name = 'Baby Doll' WHERE product_id = 6;
UPDATE warehouse_products SET product_name = 'Construction Blocks' WHERE product_id = 7;
UPDATE warehouse_products SET product_name = 'Educational Tablet' WHERE product_id = 8;
UPDATE warehouse_products SET product_name = 'RC Car' WHERE product_id = 9;
UPDATE warehouse_products SET product_name = 'Stuffed Animal' WHERE product_id = 10;

-- Update store_inventory with product names
UPDATE store_inventory SET product_name = 'Lego Classic' WHERE product_id = 1;
UPDATE store_inventory SET product_name = 'Barbie Doll' WHERE product_id = 2;
UPDATE store_inventory SET product_name = 'Iphone 15' WHERE product_id = 3;
UPDATE store_inventory SET product_name = 'Puzzle 1000 pieces' WHERE product_id = 4;
UPDATE store_inventory SET product_name = 'Robot Transformer' WHERE product_id = 5;
UPDATE store_inventory SET product_name = 'Baby Doll' WHERE product_id = 6;
UPDATE store_inventory SET product_name = 'Construction Blocks' WHERE product_id = 7;
UPDATE store_inventory SET product_name = 'Educational Tablet' WHERE product_id = 8;
UPDATE store_inventory SET product_name = 'RC Car' WHERE product_id = 9;
UPDATE store_inventory SET product_name = 'Stuffed Animal' WHERE product_id = 10;
