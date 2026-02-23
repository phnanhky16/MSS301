-- V2__Insert_sample_data.sql
-- Sample data for testing

-- Insert sample warehouses
INSERT INTO warehouses (warehouse_code, warehouse_name, address, city, district, phone, manager_name, capacity, warehouse_type, is_active) VALUES
('WH001', 'Kho Tổng Hà Nội', '123 Đường Láng, Đống Đa', 'Hà Nội', 'Đống Đa', '0241234567', 'Nguyễn Văn A', 10000.00, 'CENTRAL', true),
('WH002', 'Kho Tổng TP.HCM', '456 Nguyễn Văn Cừ, Quận 5', 'TP. Hồ Chí Minh', 'Quận 5', '0281234567', 'Trần Thị B', 15000.00, 'CENTRAL', true),
('WH003', 'Kho Miền Trung', '789 Lê Duẩn, Hải Châu', 'Đà Nẵng', 'Hải Châu', '0236123456', 'Lê Văn C', 8000.00, 'REGIONAL', true);

-- Insert sample stores
INSERT INTO stores (store_code, store_name, address, city, district, phone, manager_name, is_active) VALUES
('ST001', 'KidFavor Hà Nội - Royal City', 'Royal City, Thanh Xuân', 'Hà Nội', 'Thanh Xuân', '0243456789', 'Phạm Thị D', true),
('ST002', 'KidFavor TP.HCM - Crescent Mall', 'Crescent Mall, Quận 7', 'TP. Hồ Chí Minh', 'Quận 7', '0283456789', 'Hoàng Văn E', true),
('ST003', 'KidFavor Hà Nội - Times City', 'Times City, Hai Bà Trưng', 'Hà Nội', 'Hai Bà Trưng', '0244567890', 'Đỗ Thị F', true),
('ST004', 'KidFavor Đà Nẵng - Vincom', 'Vincom Đà Nẵng, Hải Châu', 'Đà Nẵng', 'Hải Châu', '0236456789', 'Vũ Văn G', true),
('ST005', 'KidFavor TP.HCM - Aeon Mall', 'Aeon Mall Bình Tân', 'TP. Hồ Chí Minh', 'Bình Tân', '0284567890', 'Bùi Thị H', true);

-- Note: Product inventory will be added through the API
-- This is because product_id references the product-service
