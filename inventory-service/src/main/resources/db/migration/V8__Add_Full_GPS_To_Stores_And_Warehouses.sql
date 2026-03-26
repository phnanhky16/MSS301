-- V8__Add_Full_GPS_To_Stores_And_Warehouses.sql
-- Add GPS coordinates and detailed address fields to stores and warehouses

-- Add GPS and address fields to stores table
ALTER TABLE stores ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 7);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS longitude DECIMAL(10, 7);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS ward VARCHAR(100);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS street VARCHAR(200);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS house_number VARCHAR(50);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS location_accuracy VARCHAR(50);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS osm_place_id VARCHAR(100);
ALTER TABLE stores ADD COLUMN IF NOT EXISTS formatted_address VARCHAR(1000);

-- Add GPS and address fields to warehouses table
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 7);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS longitude DECIMAL(10, 7);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS street VARCHAR(200);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS house_number VARCHAR(50);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS location_accuracy VARCHAR(50);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS osm_place_id VARCHAR(100);
ALTER TABLE warehouses ADD COLUMN IF NOT EXISTS formatted_address VARCHAR(1000);

-- Create indexes for GPS coordinates
CREATE INDEX IF NOT EXISTS idx_stores_coordinates ON stores(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_stores_location ON stores(city, district, ward);
CREATE INDEX IF NOT EXISTS idx_warehouses_coordinates ON warehouses(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_warehouses_location ON warehouses(city, district, ward);

-- Clear old data (delete in correct order to avoid FK violations)
DELETE FROM warehouse_products;
DELETE FROM store_inventory;
DELETE FROM warehouses;
DELETE FROM stores;

-- Reset sequences
ALTER SEQUENCE warehouses_warehouse_id_seq RESTART WITH 1;
ALTER SEQUENCE stores_store_id_seq RESTART WITH 1;

-- Insert new stores with full GPS coordinates (15 stores across Vietnam)
-- Ho Chi Minh City (6 stores)
INSERT INTO stores (store_code, store_name, address, city, district, ward, street, house_number, phone, manager_name, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('HCM001', 'KidFavor Nguyễn Huệ', '123 Nguyễn Huệ', 'Hồ Chí Minh', 'Quận 1', 'Phường Bến Nghé', 'Nguyễn Huệ', '123', '0281234001', 'Nguyễn Văn A', 10.7756800, 106.7004400, '123 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh', 'HCM001_OSM', 'address'),
('HCM002', 'KidFavor Tân Bình', '456 Cách Mạng Tháng 8', 'Hồ Chí Minh', 'Quận Tân Bình', 'Phường 7', 'Cách Mạng Tháng 8', '456', '0281234002', 'Trần Thị B', 10.7990500, 106.6541800, '456 Cách Mạng Tháng 8, Phường 7, Quận Tân Bình, TP. Hồ Chí Minh', 'HCM002_OSM', 'address'),
('HCM003', 'KidFavor Bình Thạnh', '789 Xô Viết Nghệ Tĩnh', 'Hồ Chí Minh', 'Quận Bình Thạnh', 'Phường 25', 'Xô Viết Nghệ Tĩnh', '789', '0281234003', 'Lê Văn C', 10.8068700, 106.7112100, '789 Xô Viết Nghệ Tĩnh, Phường 25, Quận Bình Thạnh, TP. Hồ Chí Minh', 'HCM003_OSM', 'address'),
('HCM004', 'KidFavor Phú Nhuận', '321 Phan Đăng Lưu', 'Hồ Chí Minh', 'Quận Phú Nhuận', 'Phường 1', 'Phan Đăng Lưu', '321', '0281234004', 'Phạm Thị D', 10.7968900, 106.6769400, '321 Phan Đăng Lưu, Phường 1, Quận Phú Nhuận, TP. Hồ Chí Minh', 'HCM004_OSM', 'address'),
('HCM005', 'KidFavor Quận 3', '555 Võ Văn Tần', 'Hồ Chí Minh', 'Quận 3', 'Phường 6', 'Võ Văn Tần', '555', '0281234005', 'Hoàng Văn E', 10.7804200, 106.6904400, '555 Võ Văn Tần, Phường 6, Quận 3, TP. Hồ Chí Minh', 'HCM005_OSM', 'address'),
('HCM006', 'KidFavor Thủ Đức', '888 Võ Văn Ngân', 'Hồ Chí Minh', 'Thủ Đức', 'Phường Linh Chiểu', 'Võ Văn Ngân', '888', '0281234006', 'Vũ Thị F', 10.8508200, 106.7719800, '888 Võ Văn Ngân, Phường Linh Chiểu, TP. Thủ Đức, TP. Hồ Chí Minh', 'HCM006_OSM', 'address');

-- Hanoi (5 stores)
INSERT INTO stores (store_code, store_name, address, city, district, ward, street, house_number, phone, manager_name, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('HN001', 'KidFavor Hoàn Kiếm', '234 Bà Triệu', 'Hà Nội', 'Quận Hoàn Kiếm', 'Phường Bà Triệu', 'Bà Triệu', '234', '0241234001', 'Đỗ Văn G', 21.0195700, 105.8483900, '234 Bà Triệu, Phường Bà Triệu, Quận Hoàn Kiếm, Hà Nội', 'HN001_OSM', 'address'),
('HN002', 'KidFavor Đống Đa', '678 Giải Phóng', 'Hà Nội', 'Quận Đống Đa', 'Phường Khương Đình', 'Giải Phóng', '678', '0241234002', 'Bùi Thị H', 21.0041200, 105.8337600, '678 Giải Phóng, Phường Khương Đình, Quận Đống Đa, Hà Nội', 'HN002_OSM', 'address'),
('HN003', 'KidFavor Cầu Giấy', '999 Nguyễn Trãi', 'Hà Nội', 'Quận Cầu Giấy', 'Phường Dịch Vọng', 'Nguyễn Trãi', '999', '0241234003', 'Ngô Văn I', 21.0294400, 105.7883700, '999 Nguyễn Trãi, Phường Dịch Vọng, Quận Cầu Giấy, Hà Nội', 'HN003_OSM', 'address'),
('HN004', 'KidFavor Hai Bà Trưng', '777 Bạch Mai', 'Hà Nội', 'Quận Hai Bà Trưng', 'Phường Bạch Mai', 'Bạch Mai', '777', '0241234004', 'Đinh Thị K', 21.0053900, 105.8460100, '777 Bạch Mai, Phường Bạch Mai, Quận Hai Bà Trưng, Hà Nội', 'HN004_OSM', 'address'),
('HN005', 'KidFavor Long Biên', '444 Nguyễn Văn Cừ', 'Hà Nội', 'Quận Long Biên', 'Phường Ngọc Lâm', 'Nguyễn Văn Cừ', '444', '0241234005', 'Trương Văn L', 21.0365400, 105.8943700, '444 Nguyễn Văn Cừ, Phường Ngọc Lâm, Quận Long Biên, Hà Nội', 'HN005_OSM', 'address');

-- Da Nang (2 stores)
INSERT INTO stores (store_code, store_name, address, city, district, ward, street, house_number, phone, manager_name, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('DN001', 'KidFavor Hải Châu', '111 Lê Duẩn', 'Đà Nẵng', 'Quận Hải Châu', 'Phường Hải Châu 1', 'Lê Duẩn', '111', '0236234001', 'Phan Văn M', 16.0471700, 108.2203300, '111 Lê Duẩn, Phường Hải Châu 1, Quận Hải Châu, Đà Nẵng', 'DN001_OSM', 'address'),
('DN002', 'KidFavor Thanh Khê', '222 Hùng Vương', 'Đà Nẵng', 'Quận Thanh Khê', 'Phường Thanh Khê Đông', 'Hùng Vương', '222', '0236234002', 'Võ Thị N', 16.0629300, 108.1919100, '222 Hùng Vương, Phường Thanh Khê Đông, Quận Thanh Khê, Đà Nẵng', 'DN002_OSM', 'address');

-- Can Tho (1 store)
INSERT INTO stores (store_code, store_name, address, city, district, ward, street, house_number, phone, manager_name, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('CT001', 'KidFavor Ninh Kiều', '333 Trần Hưng Đạo', 'Cần Thơ', 'Quận Ninh Kiều', 'Phường Tân An', 'Trần Hưng Đạo', '333', '0292234001', 'Lý Văn O', 10.0451700, 105.7468800, '333 Trần Hưng Đạo, Phường Tân An, Quận Ninh Kiều, Cần Thơ', 'CT001_OSM', 'address');

-- Hai Phong (1 store)
INSERT INTO stores (store_code, store_name, address, city, district, ward, street, house_number, phone, manager_name, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('HP001', 'KidFavor Hồng Bàng', '666 Điện Biên Phủ', 'Hải Phòng', 'Quận Hồng Bàng', 'Phường Quán Toan', 'Điện Biên Phủ', '666', '0225234001', 'Mai Văn P', 20.8614300, 106.6880800, '666 Điện Biên Phủ, Phường Quán Toan, Quận Hồng Bàng, Hải Phòng', 'HP001_OSM', 'address');

-- Insert warehouses with full GPS coordinates (5 warehouses)
-- Main Distribution Centers
INSERT INTO warehouses (warehouse_code, warehouse_name, address, city, district, ward, street, house_number, phone, manager_name, warehouse_type, capacity, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('WH-HCM-01', 'Kho Trung Tâm TP.HCM', '1000 Quốc Lộ 1A', 'Hồ Chí Minh', 'Quận Bình Tân', 'Phường Bình Trị Đông B', 'Quốc Lộ 1A', '1000', '0281111001', 'Nguyễn Quản Lý A', 'DISTRIBUTION_CENTER', 50000.00, 10.7421500, 106.6063400, '1000 Quốc Lộ 1A, Phường Bình Trị Đông B, Quận Bình Tân, TP. Hồ Chí Minh', 'WH_HCM01_OSM', 'address'),
('WH-HN-01', 'Kho Trung Tâm Hà Nội', '500 Đường Láng', 'Hà Nội', 'Quận Đống Đa', 'Phường Láng Thượng', 'Đường Láng', '500', '0241111001', 'Trần Quản Lý B', 'DISTRIBUTION_CENTER', 40000.00, 21.0161100, 105.8052200, '500 Đường Láng, Phường Láng Thượng, Quận Đống Đa, Hà Nội', 'WH_HN01_OSM', 'address'),
('WH-DN-01', 'Kho Trung Tâm Đà Nẵng', '300 Điện Biên Phủ', 'Đà Nẵng', 'Quận Thanh Khê', 'Phường Chính Gián', 'Điện Biên Phủ', '300', '0236111001', 'Lê Quản Lý C', 'DISTRIBUTION_CENTER', 25000.00, 16.0645300, 108.1489100, '300 Điện Biên Phủ, Phường Chính Gián, Quận Thanh Khê, Đà Nẵng', 'WH_DN01_OSM', 'address');

-- Regional Warehouses
INSERT INTO warehouses (warehouse_code, warehouse_name, address, city, district, ward, street, house_number, phone, manager_name, warehouse_type, capacity, latitude, longitude, formatted_address, osm_place_id, location_accuracy) VALUES
('WH-CT-01', 'Kho Khu Vực Cần Thơ', '200 Quốc Lộ 91', 'Cần Thơ', 'Quận Ninh Kiều', 'Phường An Khánh', 'Quốc Lộ 91', '200', '0292111001', 'Phạm Quản Lý D', 'REGIONAL', 15000.00, 10.0126900, 105.7662600, '200 Quốc Lộ 91, Phường An Khánh, Quận Ninh Kiều, Cần Thơ', 'WH_CT01_OSM', 'address'),
('WH-HP-01', 'Kho Khu Vực Hải Phòng', '400 Lạch Tray', 'Hải Phòng', 'Quận Ngô Quyền', 'Phường Lạch Tray', 'Lạch Tray', '400', '0225111001', 'Vũ Quản Lý E', 'REGIONAL', 18000.00, 20.8574600, 106.6826200, '400 Lạch Tray, Phường Lạch Tray, Quận Ngô Quyền, Hải Phòng', 'WH_HP01_OSM', 'address');

-- Add sample inventory data
-- Warehouse products (assuming product IDs 1-10 exist)
INSERT INTO warehouse_products (warehouse_id, product_id, quantity, min_stock_level, max_stock_level, location_code) VALUES
-- WH-HCM-01 inventory
(1, 1, 5000, 500, 10000, 'A-01-01'),
(1, 2, 3000, 300, 6000, 'A-01-02'),
(1, 3, 4500, 450, 9000, 'A-02-01'),
(1, 4, 2800, 280, 5600, 'A-02-02'),
(1, 5, 3500, 350, 7000, 'A-03-01'),
-- WH-HN-01 inventory
(2, 1, 4000, 400, 8000, 'B-01-01'),
(2, 2, 2500, 250, 5000, 'B-01-02'),
(2, 3, 3000, 300, 6000, 'B-02-01'),
(2, 4, 2000, 200, 4000, 'B-02-02'),
(2, 5, 2800, 280, 5600, 'B-03-01'),
-- WH-DN-01 inventory
(3, 1, 2000, 200, 4000, 'C-01-01'),
(3, 2, 1500, 150, 3000, 'C-01-02'),
(3, 3, 1800, 180, 3600, 'C-02-01'),
(3, 4, 1200, 120, 2400, 'C-02-02'),
(3, 5, 1600, 160, 3200, 'C-03-01');

-- Store inventory (smaller quantities)
INSERT INTO store_inventory (store_id, product_id, quantity, min_stock_level, shelf_location) VALUES
-- HCM001 inventory
(1, 1, 150, 20, 'S-A1'),
(1, 2, 100, 15, 'S-A2'),
(1, 3, 120, 18, 'S-B1'),
(1, 4, 80, 12, 'S-B2'),
(1, 5, 95, 14, 'S-C1'),
-- HCM002 inventory
(2, 1, 130, 20, 'S-A1'),
(2, 2, 90, 15, 'S-A2'),
(2, 3, 110, 18, 'S-B1'),
(2, 4, 70, 12, 'S-B2'),
(2, 5, 85, 14, 'S-C1'),
-- HN001 inventory
(7, 1, 140, 20, 'S-A1'),
(7, 2, 95, 15, 'S-A2'),
(7, 3, 115, 18, 'S-B1'),
(7, 4, 75, 12, 'S-B2'),
(7, 5, 90, 14, 'S-C1'),
-- DN001 inventory
(12, 1, 100, 20, 'S-A1'),
(12, 2, 70, 15, 'S-A2'),
(12, 3, 85, 18, 'S-B1'),
(12, 4, 55, 12, 'S-B2'),
(12, 5, 65, 14, 'S-C1');

-- Add comments
COMMENT ON COLUMN stores.latitude IS 'GPS Latitude coordinate (decimal degrees)';
COMMENT ON COLUMN stores.longitude IS 'GPS Longitude coordinate (decimal degrees)';
COMMENT ON COLUMN stores.ward IS 'Ward/Commune (Phường/Xã)';
COMMENT ON COLUMN stores.street IS 'Street name';
COMMENT ON COLUMN stores.house_number IS 'House/building number';
COMMENT ON COLUMN stores.location_accuracy IS 'Geocoding accuracy: address, street, district, city';
COMMENT ON COLUMN stores.osm_place_id IS 'OpenStreetMap place ID for reference';
COMMENT ON COLUMN stores.formatted_address IS 'Full formatted address from geocoding';

COMMENT ON COLUMN warehouses.latitude IS 'GPS Latitude coordinate (decimal degrees)';
COMMENT ON COLUMN warehouses.longitude IS 'GPS Longitude coordinate (decimal degrees)';
COMMENT ON COLUMN warehouses.street IS 'Street name';
COMMENT ON COLUMN warehouses.house_number IS 'House/building number';
COMMENT ON COLUMN warehouses.location_accuracy IS 'Geocoding accuracy: address, street, district, city';
COMMENT ON COLUMN warehouses.osm_place_id IS 'OpenStreetMap place ID for reference';
COMMENT ON COLUMN warehouses.formatted_address IS 'Full formatted address from geocoding';
