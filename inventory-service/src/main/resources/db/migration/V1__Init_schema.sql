-- V1__Init_schema.sql
-- Inventory Service Database Schema

-- Create Warehouses table
CREATE TABLE warehouses (
    warehouse_id BIGSERIAL PRIMARY KEY,
    warehouse_code VARCHAR(50) NOT NULL UNIQUE,
    warehouse_name VARCHAR(200) NOT NULL,
    address VARCHAR(500),
    city VARCHAR(100),
    district VARCHAR(100),
    ward VARCHAR(100),
    phone VARCHAR(20),
    manager_name VARCHAR(200),
    capacity DECIMAL(10, 2),
    warehouse_type VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Stores table
CREATE TABLE stores (
    store_id BIGSERIAL PRIMARY KEY,
    store_code VARCHAR(50) NOT NULL UNIQUE,
    store_name VARCHAR(200) NOT NULL,
    address VARCHAR(500),
    city VARCHAR(100),
    district VARCHAR(100),
    phone VARCHAR(20),
    manager_name VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Warehouse Products table
CREATE TABLE warehouse_products (
    id BIGSERIAL PRIMARY KEY,
    warehouse_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    min_stock_level INTEGER DEFAULT 0,
    max_stock_level INTEGER DEFAULT 0,
    location_code VARCHAR(50),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE,
    CONSTRAINT uq_warehouse_product UNIQUE (warehouse_id, product_id),
    CONSTRAINT chk_quantity CHECK (quantity >= 0)
);

-- Create Store Inventory table
CREATE TABLE store_inventory (
    id BIGSERIAL PRIMARY KEY,
    store_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    min_stock_level INTEGER DEFAULT 0,
    shelf_location VARCHAR(50),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE,
    CONSTRAINT uq_store_product UNIQUE (store_id, product_id),
    CONSTRAINT chk_inventory_quantity CHECK (quantity >= 0)
);

-- Create indexes for better query performance
CREATE INDEX idx_warehouse_code ON warehouses(warehouse_code);
CREATE INDEX idx_warehouse_active ON warehouses(is_active);
CREATE INDEX idx_warehouse_city ON warehouses(city);

CREATE INDEX idx_store_code ON stores(store_code);
CREATE INDEX idx_store_active ON stores(is_active);
CREATE INDEX idx_store_city ON stores(city);

CREATE INDEX idx_wp_warehouse ON warehouse_products(warehouse_id);
CREATE INDEX idx_wp_product ON warehouse_products(product_id);
CREATE INDEX idx_wp_quantity ON warehouse_products(quantity);

CREATE INDEX idx_si_store ON store_inventory(store_id);
CREATE INDEX idx_si_product ON store_inventory(product_id);
CREATE INDEX idx_si_quantity ON store_inventory(quantity);

-- Comments for documentation
COMMENT ON TABLE warehouses IS 'Stores information about warehouse locations';
COMMENT ON TABLE stores IS 'Stores information about retail store locations';
COMMENT ON TABLE warehouse_products IS 'Tracks product inventory in warehouses';
COMMENT ON TABLE store_inventory IS 'Tracks product inventory in retail stores';
