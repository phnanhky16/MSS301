-- V5__Add_product_name_column.sql
-- Add product_name column to warehouse_products table for denormalization
-- This allows retrieving product name without calling product-service

-- Add product_name column to warehouse_products table
ALTER TABLE warehouse_products 
ADD COLUMN product_name VARCHAR(255);

-- Add comment
COMMENT ON COLUMN warehouse_products.product_name IS 'Name of the product (denormalized from product-service)';

-- Add product_name column to store_inventory table
ALTER TABLE store_inventory 
ADD COLUMN product_name VARCHAR(255);

-- Add comment
COMMENT ON COLUMN store_inventory.product_name IS 'Name of the product (denormalized from product-service)';
