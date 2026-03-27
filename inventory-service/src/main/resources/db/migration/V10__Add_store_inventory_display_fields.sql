-- V10__Add_store_inventory_display_fields.sql
-- Add denormalized display fields so POS can read name/price/image directly

ALTER TABLE store_inventory
ADD COLUMN IF NOT EXISTS price NUMERIC(19,2);

ALTER TABLE store_inventory
ADD COLUMN IF NOT EXISTS sale_price NUMERIC(19,2);

ALTER TABLE store_inventory
ADD COLUMN IF NOT EXISTS image_url VARCHAR(1000);

COMMENT ON COLUMN store_inventory.price IS 'Base selling price (denormalized from product-service)';
COMMENT ON COLUMN store_inventory.sale_price IS 'Sale price if product is on sale (denormalized from product-service)';
COMMENT ON COLUMN store_inventory.image_url IS 'Primary product image URL (denormalized from product-service)';
