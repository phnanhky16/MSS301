-- =====================================================
-- Script to clean Flyway migration history
-- Run this in PostgreSQL to reset migrations
-- =====================================================

-- Drop all tables (in correct order due to foreign keys)
DROP TABLE IF EXISTS product_images CASCADE;
DROP TABLE IF EXISTS packages CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS brands CASCADE;

-- Drop Flyway schema history table
DROP TABLE IF EXISTS flyway_schema_history CASCADE;

-- Now you can restart your application and Flyway will run V1__Init_schema.sql
