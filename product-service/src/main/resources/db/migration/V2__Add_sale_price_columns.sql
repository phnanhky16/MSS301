-- Add sale price columns to products table
ALTER TABLE products ADD COLUMN IF NOT EXISTS sale_price NUMERIC(19,2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS sale_start_date TIMESTAMP;
ALTER TABLE products ADD COLUMN IF NOT EXISTS sale_end_date TIMESTAMP;
