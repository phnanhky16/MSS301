-- V4__Add_updated_by_column.sql
-- Add updated_by column to track who made the last update

-- Add updated_by column to warehouses table
ALTER TABLE warehouses 
ADD COLUMN updated_by VARCHAR(100);

-- Add updated_by column to stores table
ALTER TABLE stores 
ADD COLUMN updated_by VARCHAR(100);

-- Add updated_by column to warehouse_products table
ALTER TABLE warehouse_products 
ADD COLUMN updated_by VARCHAR(100);

-- Add updated_by column to store_inventory table
ALTER TABLE store_inventory 
ADD COLUMN updated_by VARCHAR(100);

-- Add comments for documentation
COMMENT ON COLUMN warehouses.updated_by IS 'Username of the person who last updated this warehouse';
COMMENT ON COLUMN stores.updated_by IS 'Username of the person who last updated this store';
COMMENT ON COLUMN warehouse_products.updated_by IS 'Username of the person who last updated this warehouse product';
COMMENT ON COLUMN store_inventory.updated_by IS 'Username of the person who last updated this store inventory';
