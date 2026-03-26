-- ============================================================
-- V1: Vietnamese Administrative Units - COMPLETE OFFICIAL DATASET
-- Schema + full seed data in one migration file
-- Source: https://provinces.open-api.vn/api/?depth=3
-- 63 provinces, 696 districts, 10051 wards (Phường/Xã/Thị trấn)
-- Generated automatically. DO NOT EDIT MANUALLY.
-- ============================================================

-- Schema
CREATE TABLE IF NOT EXISTS administrative_units (
    id        BIGSERIAL    PRIMARY KEY,
    name      VARCHAR(255) NOT NULL,
    code      VARCHAR(50),
    level     INT          NOT NULL,
    parent_id BIGINT       REFERENCES administrative_units(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_au_parent ON administrative_units(parent_id);
CREATE INDEX IF NOT EXISTS idx_au_level  ON administrative_units(level);

-- PROVINCES (level 1): 63 records
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1, 'Thành phố Hà Nội', '1', 1, NULL),
(2, 'Tỉnh Hà Giang', '2', 1, NULL),
(3, 'Tỉnh Cao Bằng', '4', 1, NULL),
(4, 'Tỉnh Bắc Kạn', '6', 1, NULL),
(5, 'Tỉnh Tuyên Quang', '8', 1, NULL),
(6, 'Tỉnh Lào Cai', '10', 1, NULL),
(7, 'Tỉnh Điện Biên', '11', 1, NULL),
(8, 'Tỉnh Lai Châu', '12', 1, NULL),
(9, 'Tỉnh Sơn La', '14', 1, NULL),
(10, 'Tỉnh Yên Bái', '15', 1, NULL),
(11, 'Tỉnh Hoà Bình', '17', 1, NULL),
(12, 'Tỉnh Thái Nguyên', '19', 1, NULL),
(13, 'Tỉnh Lạng Sơn', '20', 1, NULL),
(14, 'Tỉnh Quảng Ninh', '22', 1, NULL),
(15, 'Tỉnh Bắc Giang', '24', 1, NULL),
(16, 'Tỉnh Phú Thọ', '25', 1, NULL),
(17, 'Tỉnh Vĩnh Phúc', '26', 1, NULL),
(18, 'Tỉnh Bắc Ninh', '27', 1, NULL),
(19, 'Tỉnh Hải Dương', '30', 1, NULL),
(20, 'Thành phố Hải Phòng', '31', 1, NULL),
(21, 'Tỉnh Hưng Yên', '33', 1, NULL),
(22, 'Tỉnh Thái Bình', '34', 1, NULL),
(23, 'Tỉnh Hà Nam', '35', 1, NULL),
(24, 'Tỉnh Nam Định', '36', 1, NULL),
(25, 'Tỉnh Ninh Bình', '37', 1, NULL),
(26, 'Tỉnh Thanh Hóa', '38', 1, NULL),
(27, 'Tỉnh Nghệ An', '40', 1, NULL),
(28, 'Tỉnh Hà Tĩnh', '42', 1, NULL),
(29, 'Tỉnh Quảng Bình', '44', 1, NULL),
(30, 'Tỉnh Quảng Trị', '45', 1, NULL),
(31, 'Thành phố Huế', '46', 1, NULL),
(32, 'Thành phố Đà Nẵng', '48', 1, NULL),
(33, 'Tỉnh Quảng Nam', '49', 1, NULL),
(34, 'Tỉnh Quảng Ngãi', '51', 1, NULL),
(35, 'Tỉnh Bình Định', '52', 1, NULL),
(36, 'Tỉnh Phú Yên', '54', 1, NULL),
(37, 'Tỉnh Khánh Hòa', '56', 1, NULL),
(38, 'Tỉnh Ninh Thuận', '58', 1, NULL),
(39, 'Tỉnh Bình Thuận', '60', 1, NULL),
(40, 'Tỉnh Kon Tum', '62', 1, NULL),
(41, 'Tỉnh Gia Lai', '64', 1, NULL),
(42, 'Tỉnh Đắk Lắk', '66', 1, NULL),
(43, 'Tỉnh Đắk Nông', '67', 1, NULL),
(44, 'Tỉnh Lâm Đồng', '68', 1, NULL),
(45, 'Tỉnh Bình Phước', '70', 1, NULL),
(46, 'Tỉnh Tây Ninh', '72', 1, NULL),
(47, 'Tỉnh Bình Dương', '74', 1, NULL),
(48, 'Tỉnh Đồng Nai', '75', 1, NULL),
(49, 'Tỉnh Bà Rịa - Vũng Tàu', '77', 1, NULL),
(50, 'Thành phố Hồ Chí Minh', '79', 1, NULL),
(51, 'Tỉnh Long An', '80', 1, NULL),
(52, 'Tỉnh Tiền Giang', '82', 1, NULL),
(53, 'Tỉnh Bến Tre', '83', 1, NULL),
(54, 'Tỉnh Trà Vinh', '84', 1, NULL),
(55, 'Tỉnh Vĩnh Long', '86', 1, NULL),
(56, 'Tỉnh Đồng Tháp', '87', 1, NULL),
(57, 'Tỉnh An Giang', '89', 1, NULL),
(58, 'Tỉnh Kiên Giang', '91', 1, NULL),
(59, 'Thành phố Cần Thơ', '92', 1, NULL),
(60, 'Tỉnh Hậu Giang', '93', 1, NULL),
(61, 'Tỉnh Sóc Trăng', '94', 1, NULL),
(62, 'Tỉnh Bạc Liêu', '95', 1, NULL),
(63, 'Tỉnh Cà Mau', '96', 1, NULL);

-- DISTRICTS (level 2): 696 records
-- Thành phố Hà Nội
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(64, 'Quận Ba Đình', '1', 2, 1),
(65, 'Quận Hoàn Kiếm', '2', 2, 1),
(66, 'Quận Tây Hồ', '3', 2, 1),
(67, 'Quận Long Biên', '4', 2, 1),
(68, 'Quận Cầu Giấy', '5', 2, 1),
(69, 'Quận Đống Đa', '6', 2, 1),
(70, 'Quận Hai Bà Trưng', '7', 2, 1),
(71, 'Quận Hoàng Mai', '8', 2, 1),
(72, 'Quận Thanh Xuân', '9', 2, 1),
(73, 'Huyện Sóc Sơn', '16', 2, 1),
(74, 'Huyện Đông Anh', '17', 2, 1),
(75, 'Huyện Gia Lâm', '18', 2, 1),
(76, 'Quận Nam Từ Liêm', '19', 2, 1),
(77, 'Huyện Thanh Trì', '20', 2, 1),
(78, 'Quận Bắc Từ Liêm', '21', 2, 1),
(79, 'Huyện Mê Linh', '250', 2, 1),
(80, 'Quận Hà Đông', '268', 2, 1),
(81, 'Thị xã Sơn Tây', '269', 2, 1),
(82, 'Huyện Ba Vì', '271', 2, 1),
(83, 'Huyện Phúc Thọ', '272', 2, 1),
(84, 'Huyện Đan Phượng', '273', 2, 1),
(85, 'Huyện Hoài Đức', '274', 2, 1),
(86, 'Huyện Quốc Oai', '275', 2, 1),
(87, 'Huyện Thạch Thất', '276', 2, 1),
(88, 'Huyện Chương Mỹ', '277', 2, 1),
(89, 'Huyện Thanh Oai', '278', 2, 1),
(90, 'Huyện Thường Tín', '279', 2, 1),
(91, 'Huyện Phú Xuyên', '280', 2, 1),
(92, 'Huyện Ứng Hòa', '281', 2, 1),
(93, 'Huyện Mỹ Đức', '282', 2, 1);

-- Tỉnh Hà Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(94, 'Thành phố Hà Giang', '24', 2, 2),
(95, 'Huyện Đồng Văn', '26', 2, 2),
(96, 'Huyện Mèo Vạc', '27', 2, 2),
(97, 'Huyện Yên Minh', '28', 2, 2),
(98, 'Huyện Quản Bạ', '29', 2, 2),
(99, 'Huyện Vị Xuyên', '30', 2, 2),
(100, 'Huyện Bắc Mê', '31', 2, 2),
(101, 'Huyện Hoàng Su Phì', '32', 2, 2),
(102, 'Huyện Xín Mần', '33', 2, 2),
(103, 'Huyện Bắc Quang', '34', 2, 2),
(104, 'Huyện Quang Bình', '35', 2, 2);

-- Tỉnh Cao Bằng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(105, 'Thành phố Cao Bằng', '40', 2, 3),
(106, 'Huyện Bảo Lâm', '42', 2, 3),
(107, 'Huyện Bảo Lạc', '43', 2, 3),
(108, 'Huyện Hà Quảng', '45', 2, 3),
(109, 'Huyện Trùng Khánh', '47', 2, 3),
(110, 'Huyện Hạ Lang', '48', 2, 3),
(111, 'Huyện Quảng Hòa', '49', 2, 3),
(112, 'Huyện Hoà An', '51', 2, 3),
(113, 'Huyện Nguyên Bình', '52', 2, 3),
(114, 'Huyện Thạch An', '53', 2, 3);

-- Tỉnh Bắc Kạn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(115, 'Thành Phố Bắc Kạn', '58', 2, 4),
(116, 'Huyện Pác Nặm', '60', 2, 4),
(117, 'Huyện Ba Bể', '61', 2, 4),
(118, 'Huyện Ngân Sơn', '62', 2, 4),
(119, 'Huyện Bạch Thông', '63', 2, 4),
(120, 'Huyện Chợ Đồn', '64', 2, 4),
(121, 'Huyện Chợ Mới', '65', 2, 4),
(122, 'Huyện Na Rì', '66', 2, 4);

-- Tỉnh Tuyên Quang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(123, 'Thành phố Tuyên Quang', '70', 2, 5),
(124, 'Huyện Lâm Bình', '71', 2, 5),
(125, 'Huyện Na Hang', '72', 2, 5),
(126, 'Huyện Chiêm Hóa', '73', 2, 5),
(127, 'Huyện Hàm Yên', '74', 2, 5),
(128, 'Huyện Yên Sơn', '75', 2, 5),
(129, 'Huyện Sơn Dương', '76', 2, 5);

-- Tỉnh Lào Cai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(130, 'Thành phố Lào Cai', '80', 2, 6),
(131, 'Huyện Bát Xát', '82', 2, 6),
(132, 'Huyện Mường Khương', '83', 2, 6),
(133, 'Huyện Si Ma Cai', '84', 2, 6),
(134, 'Huyện Bắc Hà', '85', 2, 6),
(135, 'Huyện Bảo Thắng', '86', 2, 6),
(136, 'Huyện Bảo Yên', '87', 2, 6),
(137, 'Thị xã Sa Pa', '88', 2, 6),
(138, 'Huyện Văn Bàn', '89', 2, 6);

-- Tỉnh Điện Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(139, 'Thành phố Điện Biên Phủ', '94', 2, 7),
(140, 'Thị xã Mường Lay', '95', 2, 7),
(141, 'Huyện Mường Nhé', '96', 2, 7),
(142, 'Huyện Mường Chà', '97', 2, 7),
(143, 'Huyện Tủa Chùa', '98', 2, 7),
(144, 'Huyện Tuần Giáo', '99', 2, 7),
(145, 'Huyện Điện Biên', '100', 2, 7),
(146, 'Huyện Điện Biên Đông', '101', 2, 7),
(147, 'Huyện Mường Ảng', '102', 2, 7),
(148, 'Huyện Nậm Pồ', '103', 2, 7);

-- Tỉnh Lai Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(149, 'Thành phố Lai Châu', '105', 2, 8),
(150, 'Huyện Tam Đường', '106', 2, 8),
(151, 'Huyện Mường Tè', '107', 2, 8),
(152, 'Huyện Sìn Hồ', '108', 2, 8),
(153, 'Huyện Phong Thổ', '109', 2, 8),
(154, 'Huyện Than Uyên', '110', 2, 8),
(155, 'Huyện Tân Uyên', '111', 2, 8),
(156, 'Huyện Nậm Nhùn', '112', 2, 8);

-- Tỉnh Sơn La
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(157, 'Thành phố Sơn La', '116', 2, 9),
(158, 'Huyện Quỳnh Nhai', '118', 2, 9),
(159, 'Huyện Thuận Châu', '119', 2, 9),
(160, 'Huyện Mường La', '120', 2, 9),
(161, 'Huyện Bắc Yên', '121', 2, 9),
(162, 'Huyện Phù Yên', '122', 2, 9),
(163, 'Huyện Mộc Châu', '123', 2, 9),
(164, 'Huyện Yên Châu', '124', 2, 9),
(165, 'Huyện Mai Sơn', '125', 2, 9),
(166, 'Huyện Sông Mã', '126', 2, 9),
(167, 'Huyện Sốp Cộp', '127', 2, 9),
(168, 'Huyện Vân Hồ', '128', 2, 9);

-- Tỉnh Yên Bái
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(169, 'Thành phố Yên Bái', '132', 2, 10),
(170, 'Thị xã Nghĩa Lộ', '133', 2, 10),
(171, 'Huyện Lục Yên', '135', 2, 10),
(172, 'Huyện Văn Yên', '136', 2, 10),
(173, 'Huyện Mù Căng Chải', '137', 2, 10),
(174, 'Huyện Trấn Yên', '138', 2, 10),
(175, 'Huyện Trạm Tấu', '139', 2, 10),
(176, 'Huyện Văn Chấn', '140', 2, 10),
(177, 'Huyện Yên Bình', '141', 2, 10);

-- Tỉnh Hoà Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(178, 'Thành phố Hòa Bình', '148', 2, 11),
(179, 'Huyện Đà Bắc', '150', 2, 11),
(180, 'Huyện Lương Sơn', '152', 2, 11),
(181, 'Huyện Kim Bôi', '153', 2, 11),
(182, 'Huyện Cao Phong', '154', 2, 11),
(183, 'Huyện Tân Lạc', '155', 2, 11),
(184, 'Huyện Mai Châu', '156', 2, 11),
(185, 'Huyện Lạc Sơn', '157', 2, 11),
(186, 'Huyện Yên Thủy', '158', 2, 11),
(187, 'Huyện Lạc Thủy', '159', 2, 11);

-- Tỉnh Thái Nguyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(188, 'Thành phố Thái Nguyên', '164', 2, 12),
(189, 'Thành phố Sông Công', '165', 2, 12),
(190, 'Huyện Định Hóa', '167', 2, 12),
(191, 'Huyện Phú Lương', '168', 2, 12),
(192, 'Huyện Đồng Hỷ', '169', 2, 12),
(193, 'Huyện Võ Nhai', '170', 2, 12),
(194, 'Huyện Đại Từ', '171', 2, 12),
(195, 'Thành phố Phổ Yên', '172', 2, 12),
(196, 'Huyện Phú Bình', '173', 2, 12);

-- Tỉnh Lạng Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(197, 'Thành phố Lạng Sơn', '178', 2, 13),
(198, 'Huyện Tràng Định', '180', 2, 13),
(199, 'Huyện Bình Gia', '181', 2, 13),
(200, 'Huyện Văn Lãng', '182', 2, 13),
(201, 'Huyện Cao Lộc', '183', 2, 13),
(202, 'Huyện Văn Quan', '184', 2, 13),
(203, 'Huyện Bắc Sơn', '185', 2, 13),
(204, 'Huyện Hữu Lũng', '186', 2, 13),
(205, 'Huyện Chi Lăng', '187', 2, 13),
(206, 'Huyện Lộc Bình', '188', 2, 13),
(207, 'Huyện Đình Lập', '189', 2, 13);

-- Tỉnh Quảng Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(208, 'Thành phố Hạ Long', '193', 2, 14),
(209, 'Thành phố Móng Cái', '194', 2, 14),
(210, 'Thành phố Cẩm Phả', '195', 2, 14),
(211, 'Thành phố Uông Bí', '196', 2, 14),
(212, 'Huyện Bình Liêu', '198', 2, 14),
(213, 'Huyện Tiên Yên', '199', 2, 14),
(214, 'Huyện Đầm Hà', '200', 2, 14),
(215, 'Huyện Hải Hà', '201', 2, 14),
(216, 'Huyện Ba Chẽ', '202', 2, 14),
(217, 'Huyện Vân Đồn', '203', 2, 14),
(218, 'Thành phố Đông Triều', '205', 2, 14),
(219, 'Thị xã Quảng Yên', '206', 2, 14),
(220, 'Huyện Cô Tô', '207', 2, 14);

-- Tỉnh Bắc Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(221, 'Thành phố Bắc Giang', '213', 2, 15),
(222, 'Huyện Yên Thế', '215', 2, 15),
(223, 'Huyện Tân Yên', '216', 2, 15),
(224, 'Huyện Lạng Giang', '217', 2, 15),
(225, 'Huyện Lục Nam', '218', 2, 15),
(226, 'Huyện Lục Ngạn', '219', 2, 15),
(227, 'Huyện Sơn Động', '220', 2, 15),
(228, 'Thị xã Việt Yên', '222', 2, 15),
(229, 'Huyện Hiệp Hòa', '223', 2, 15),
(230, 'Thị xã Chũ', '224', 2, 15);

-- Tỉnh Phú Thọ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(231, 'Thành phố Việt Trì', '227', 2, 16),
(232, 'Thị xã Phú Thọ', '228', 2, 16),
(233, 'Huyện Đoan Hùng', '230', 2, 16),
(234, 'Huyện Hạ Hoà', '231', 2, 16),
(235, 'Huyện Thanh Ba', '232', 2, 16),
(236, 'Huyện Phù Ninh', '233', 2, 16),
(237, 'Huyện Yên Lập', '234', 2, 16),
(238, 'Huyện Cẩm Khê', '235', 2, 16),
(239, 'Huyện Tam Nông', '236', 2, 16),
(240, 'Huyện Lâm Thao', '237', 2, 16),
(241, 'Huyện Thanh Sơn', '238', 2, 16),
(242, 'Huyện Thanh Thuỷ', '239', 2, 16),
(243, 'Huyện Tân Sơn', '240', 2, 16);

-- Tỉnh Vĩnh Phúc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(244, 'Thành phố Vĩnh Yên', '243', 2, 17),
(245, 'Thành phố Phúc Yên', '244', 2, 17),
(246, 'Huyện Lập Thạch', '246', 2, 17),
(247, 'Huyện Tam Dương', '247', 2, 17),
(248, 'Huyện Tam Đảo', '248', 2, 17),
(249, 'Huyện Bình Xuyên', '249', 2, 17),
(250, 'Huyện Yên Lạc', '251', 2, 17),
(251, 'Huyện Vĩnh Tường', '252', 2, 17),
(252, 'Huyện Sông Lô', '253', 2, 17);

-- Tỉnh Bắc Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(253, 'Thành phố Bắc Ninh', '256', 2, 18),
(254, 'Huyện Yên Phong', '258', 2, 18),
(255, 'Thị xã Quế Võ', '259', 2, 18),
(256, 'Huyện Tiên Du', '260', 2, 18),
(257, 'Thành phố Từ Sơn', '261', 2, 18),
(258, 'Thị xã Thuận Thành', '262', 2, 18),
(259, 'Huyện Gia Bình', '263', 2, 18),
(260, 'Huyện Lương Tài', '264', 2, 18);

-- Tỉnh Hải Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(261, 'Thành phố Hải Dương', '288', 2, 19),
(262, 'Thành phố Chí Linh', '290', 2, 19),
(263, 'Huyện Nam Sách', '291', 2, 19),
(264, 'Thị xã Kinh Môn', '292', 2, 19),
(265, 'Huyện Kim Thành', '293', 2, 19),
(266, 'Huyện Thanh Hà', '294', 2, 19),
(267, 'Huyện Cẩm Giàng', '295', 2, 19),
(268, 'Huyện Bình Giang', '296', 2, 19),
(269, 'Huyện Gia Lộc', '297', 2, 19),
(270, 'Huyện Tứ Kỳ', '298', 2, 19),
(271, 'Huyện Ninh Giang', '299', 2, 19),
(272, 'Huyện Thanh Miện', '300', 2, 19);

-- Thành phố Hải Phòng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(273, 'Quận Hồng Bàng', '303', 2, 20),
(274, 'Quận Ngô Quyền', '304', 2, 20),
(275, 'Quận Lê Chân', '305', 2, 20),
(276, 'Quận Hải An', '306', 2, 20),
(277, 'Quận Kiến An', '307', 2, 20),
(278, 'Quận Đồ Sơn', '308', 2, 20),
(279, 'Quận Dương Kinh', '309', 2, 20),
(280, 'Thành phố Thuỷ Nguyên', '311', 2, 20),
(281, 'Quận An Dương', '312', 2, 20),
(282, 'Huyện An Lão', '313', 2, 20),
(283, 'Huyện Kiến Thuỵ', '314', 2, 20),
(284, 'Huyện Tiên Lãng', '315', 2, 20),
(285, 'Huyện Vĩnh Bảo', '316', 2, 20),
(286, 'Huyện Cát Hải', '317', 2, 20),
(287, 'Huyện Bạch Long Vĩ', '318', 2, 20);

-- Tỉnh Hưng Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(288, 'Thành phố Hưng Yên', '323', 2, 21),
(289, 'Huyện Văn Lâm', '325', 2, 21),
(290, 'Huyện Văn Giang', '326', 2, 21),
(291, 'Huyện Yên Mỹ', '327', 2, 21),
(292, 'Thị xã Mỹ Hào', '328', 2, 21),
(293, 'Huyện Ân Thi', '329', 2, 21),
(294, 'Huyện Khoái Châu', '330', 2, 21),
(295, 'Huyện Kim Động', '331', 2, 21),
(296, 'Huyện Tiên Lữ', '332', 2, 21),
(297, 'Huyện Phù Cừ', '333', 2, 21);

-- Tỉnh Thái Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(298, 'Thành phố Thái Bình', '336', 2, 22),
(299, 'Huyện Quỳnh Phụ', '338', 2, 22),
(300, 'Huyện Hưng Hà', '339', 2, 22),
(301, 'Huyện Đông Hưng', '340', 2, 22),
(302, 'Huyện Thái Thụy', '341', 2, 22),
(303, 'Huyện Tiền Hải', '342', 2, 22),
(304, 'Huyện Kiến Xương', '343', 2, 22),
(305, 'Huyện Vũ Thư', '344', 2, 22);

-- Tỉnh Hà Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(306, 'Thành phố Phủ Lý', '347', 2, 23),
(307, 'Thị xã Duy Tiên', '349', 2, 23),
(308, 'Thị xã Kim Bảng', '350', 2, 23),
(309, 'Huyện Thanh Liêm', '351', 2, 23),
(310, 'Huyện Bình Lục', '352', 2, 23),
(311, 'Huyện Lý Nhân', '353', 2, 23);

-- Tỉnh Nam Định
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(312, 'Thành phố Nam Định', '356', 2, 24),
(313, 'Huyện Vụ Bản', '359', 2, 24),
(314, 'Huyện Ý Yên', '360', 2, 24),
(315, 'Huyện Nghĩa Hưng', '361', 2, 24),
(316, 'Huyện Nam Trực', '362', 2, 24),
(317, 'Huyện Trực Ninh', '363', 2, 24),
(318, 'Huyện Xuân Trường', '364', 2, 24),
(319, 'Huyện Giao Thủy', '365', 2, 24),
(320, 'Huyện Hải Hậu', '366', 2, 24);

-- Tỉnh Ninh Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(321, 'Thành phố Tam Điệp', '370', 2, 25),
(322, 'Huyện Nho Quan', '372', 2, 25),
(323, 'Huyện Gia Viễn', '373', 2, 25),
(324, 'Thành phố Hoa Lư', '374', 2, 25),
(325, 'Huyện Yên Khánh', '375', 2, 25),
(326, 'Huyện Kim Sơn', '376', 2, 25),
(327, 'Huyện Yên Mô', '377', 2, 25);

-- Tỉnh Thanh Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(328, 'Thành phố Thanh Hóa', '380', 2, 26),
(329, 'Thị xã Bỉm Sơn', '381', 2, 26),
(330, 'Thành phố Sầm Sơn', '382', 2, 26),
(331, 'Huyện Mường Lát', '384', 2, 26),
(332, 'Huyện Quan Hóa', '385', 2, 26),
(333, 'Huyện Bá Thước', '386', 2, 26),
(334, 'Huyện Quan Sơn', '387', 2, 26),
(335, 'Huyện Lang Chánh', '388', 2, 26),
(336, 'Huyện Ngọc Lặc', '389', 2, 26),
(337, 'Huyện Cẩm Thủy', '390', 2, 26),
(338, 'Huyện Thạch Thành', '391', 2, 26),
(339, 'Huyện Hà Trung', '392', 2, 26),
(340, 'Huyện Vĩnh Lộc', '393', 2, 26),
(341, 'Huyện Yên Định', '394', 2, 26),
(342, 'Huyện Thọ Xuân', '395', 2, 26),
(343, 'Huyện Thường Xuân', '396', 2, 26),
(344, 'Huyện Triệu Sơn', '397', 2, 26),
(345, 'Huyện Thiệu Hóa', '398', 2, 26),
(346, 'Huyện Hoằng Hóa', '399', 2, 26),
(347, 'Huyện Hậu Lộc', '400', 2, 26),
(348, 'Huyện Nga Sơn', '401', 2, 26),
(349, 'Huyện Như Xuân', '402', 2, 26),
(350, 'Huyện Như Thanh', '403', 2, 26),
(351, 'Huyện Nông Cống', '404', 2, 26),
(352, 'Huyện Quảng Xương', '406', 2, 26),
(353, 'Thị xã Nghi Sơn', '407', 2, 26);

-- Tỉnh Nghệ An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(354, 'Thành phố Vinh', '412', 2, 27),
(355, 'Thị xã Thái Hoà', '414', 2, 27),
(356, 'Huyện Quế Phong', '415', 2, 27),
(357, 'Huyện Quỳ Châu', '416', 2, 27),
(358, 'Huyện Kỳ Sơn', '417', 2, 27),
(359, 'Huyện Tương Dương', '418', 2, 27),
(360, 'Huyện Nghĩa Đàn', '419', 2, 27),
(361, 'Huyện Quỳ Hợp', '420', 2, 27),
(362, 'Huyện Quỳnh Lưu', '421', 2, 27),
(363, 'Huyện Con Cuông', '422', 2, 27),
(364, 'Huyện Tân Kỳ', '423', 2, 27),
(365, 'Huyện Anh Sơn', '424', 2, 27),
(366, 'Huyện Diễn Châu', '425', 2, 27),
(367, 'Huyện Yên Thành', '426', 2, 27),
(368, 'Huyện Đô Lương', '427', 2, 27),
(369, 'Huyện Thanh Chương', '428', 2, 27),
(370, 'Huyện Nghi Lộc', '429', 2, 27),
(371, 'Huyện Nam Đàn', '430', 2, 27),
(372, 'Huyện Hưng Nguyên', '431', 2, 27),
(373, 'Thị xã Hoàng Mai', '432', 2, 27);

-- Tỉnh Hà Tĩnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(374, 'Thành phố Hà Tĩnh', '436', 2, 28),
(375, 'Thị xã Hồng Lĩnh', '437', 2, 28),
(376, 'Huyện Hương Sơn', '439', 2, 28),
(377, 'Huyện Đức Thọ', '440', 2, 28),
(378, 'Huyện Vũ Quang', '441', 2, 28),
(379, 'Huyện Nghi Xuân', '442', 2, 28),
(380, 'Huyện Can Lộc', '443', 2, 28),
(381, 'Huyện Hương Khê', '444', 2, 28),
(382, 'Huyện Thạch Hà', '445', 2, 28),
(383, 'Huyện Cẩm Xuyên', '446', 2, 28),
(384, 'Huyện Kỳ Anh', '447', 2, 28),
(385, 'Thị xã Kỳ Anh', '449', 2, 28);

-- Tỉnh Quảng Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(386, 'Thành Phố Đồng Hới', '450', 2, 29),
(387, 'Huyện Minh Hóa', '452', 2, 29),
(388, 'Huyện Tuyên Hóa', '453', 2, 29),
(389, 'Huyện Quảng Trạch', '454', 2, 29),
(390, 'Huyện Bố Trạch', '455', 2, 29),
(391, 'Huyện Quảng Ninh', '456', 2, 29),
(392, 'Huyện Lệ Thủy', '457', 2, 29),
(393, 'Thị xã Ba Đồn', '458', 2, 29);

-- Tỉnh Quảng Trị
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(394, 'Thành phố Đông Hà', '461', 2, 30),
(395, 'Thị xã Quảng Trị', '462', 2, 30),
(396, 'Huyện Vĩnh Linh', '464', 2, 30),
(397, 'Huyện Hướng Hóa', '465', 2, 30),
(398, 'Huyện Gio Linh', '466', 2, 30),
(399, 'Huyện Đa Krông', '467', 2, 30),
(400, 'Huyện Cam Lộ', '468', 2, 30),
(401, 'Huyện Triệu Phong', '469', 2, 30),
(402, 'Huyện Hải Lăng', '470', 2, 30),
(403, 'Huyện Cồn Cỏ', '471', 2, 30);

-- Thành phố Huế
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(404, 'Quận Thuận Hóa', '474', 2, 31),
(405, 'Quận Phú Xuân', '475', 2, 31),
(406, 'Thị xã Phong Điền', '476', 2, 31),
(407, 'Huyện Quảng Điền', '477', 2, 31),
(408, 'Huyện Phú Vang', '478', 2, 31),
(409, 'Thị xã Hương Thủy', '479', 2, 31),
(410, 'Thị xã Hương Trà', '480', 2, 31),
(411, 'Huyện A Lưới', '481', 2, 31),
(412, 'Huyện Phú Lộc', '482', 2, 31);

-- Thành phố Đà Nẵng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(413, 'Quận Liên Chiểu', '490', 2, 32),
(414, 'Quận Thanh Khê', '491', 2, 32),
(415, 'Quận Hải Châu', '492', 2, 32),
(416, 'Quận Sơn Trà', '493', 2, 32),
(417, 'Quận Ngũ Hành Sơn', '494', 2, 32),
(418, 'Quận Cẩm Lệ', '495', 2, 32),
(419, 'Huyện Hòa Vang', '497', 2, 32),
(420, 'Huyện Hoàng Sa', '498', 2, 32);

-- Tỉnh Quảng Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(421, 'Thành phố Tam Kỳ', '502', 2, 33),
(422, 'Thành phố Hội An', '503', 2, 33),
(423, 'Huyện Tây Giang', '504', 2, 33),
(424, 'Huyện Đông Giang', '505', 2, 33),
(425, 'Huyện Đại Lộc', '506', 2, 33),
(426, 'Thị xã Điện Bàn', '507', 2, 33),
(427, 'Huyện Duy Xuyên', '508', 2, 33),
(428, 'Huyện Quế Sơn', '509', 2, 33),
(429, 'Huyện Nam Giang', '510', 2, 33),
(430, 'Huyện Phước Sơn', '511', 2, 33),
(431, 'Huyện Hiệp Đức', '512', 2, 33),
(432, 'Huyện Thăng Bình', '513', 2, 33),
(433, 'Huyện Tiên Phước', '514', 2, 33),
(434, 'Huyện Bắc Trà My', '515', 2, 33),
(435, 'Huyện Nam Trà My', '516', 2, 33),
(436, 'Huyện Núi Thành', '517', 2, 33),
(437, 'Huyện Phú Ninh', '518', 2, 33);

-- Tỉnh Quảng Ngãi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(438, 'Thành phố Quảng Ngãi', '522', 2, 34),
(439, 'Huyện Bình Sơn', '524', 2, 34),
(440, 'Huyện Trà Bồng', '525', 2, 34),
(441, 'Huyện Sơn Tịnh', '527', 2, 34),
(442, 'Huyện Tư Nghĩa', '528', 2, 34),
(443, 'Huyện Sơn Hà', '529', 2, 34),
(444, 'Huyện Sơn Tây', '530', 2, 34),
(445, 'Huyện Minh Long', '531', 2, 34),
(446, 'Huyện Nghĩa Hành', '532', 2, 34),
(447, 'Huyện Mộ Đức', '533', 2, 34),
(448, 'Thị xã Đức Phổ', '534', 2, 34),
(449, 'Huyện Ba Tơ', '535', 2, 34),
(450, 'Huyện Lý Sơn', '536', 2, 34);

-- Tỉnh Bình Định
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(451, 'Thành phố Quy Nhơn', '540', 2, 35),
(452, 'Huyện An Lão', '542', 2, 35),
(453, 'Thị xã Hoài Nhơn', '543', 2, 35),
(454, 'Huyện Hoài Ân', '544', 2, 35),
(455, 'Huyện Phù Mỹ', '545', 2, 35),
(456, 'Huyện Vĩnh Thạnh', '546', 2, 35),
(457, 'Huyện Tây Sơn', '547', 2, 35),
(458, 'Huyện Phù Cát', '548', 2, 35),
(459, 'Thị xã An Nhơn', '549', 2, 35),
(460, 'Huyện Tuy Phước', '550', 2, 35),
(461, 'Huyện Vân Canh', '551', 2, 35);

-- Tỉnh Phú Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(462, 'Thành phố Tuy Hoà', '555', 2, 36),
(463, 'Thị xã Sông Cầu', '557', 2, 36),
(464, 'Huyện Đồng Xuân', '558', 2, 36),
(465, 'Huyện Tuy An', '559', 2, 36),
(466, 'Huyện Sơn Hòa', '560', 2, 36),
(467, 'Huyện Sông Hinh', '561', 2, 36),
(468, 'Huyện Tây Hoà', '562', 2, 36),
(469, 'Huyện Phú Hoà', '563', 2, 36),
(470, 'Thị xã Đông Hòa', '564', 2, 36);

-- Tỉnh Khánh Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(471, 'Thành phố Nha Trang', '568', 2, 37),
(472, 'Thành phố Cam Ranh', '569', 2, 37),
(473, 'Huyện Cam Lâm', '570', 2, 37),
(474, 'Huyện Vạn Ninh', '571', 2, 37),
(475, 'Thị xã Ninh Hòa', '572', 2, 37),
(476, 'Huyện Khánh Vĩnh', '573', 2, 37),
(477, 'Huyện Diên Khánh', '574', 2, 37),
(478, 'Huyện Khánh Sơn', '575', 2, 37),
(479, 'Huyện Trường Sa', '576', 2, 37);

-- Tỉnh Ninh Thuận
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(480, 'Thành phố Phan Rang - Tháp Chàm', '582', 2, 38),
(481, 'Huyện Bác Ái', '584', 2, 38),
(482, 'Huyện Ninh Sơn', '585', 2, 38),
(483, 'Huyện Ninh Hải', '586', 2, 38),
(484, 'Huyện Ninh Phước', '587', 2, 38),
(485, 'Huyện Thuận Bắc', '588', 2, 38),
(486, 'Huyện Thuận Nam', '589', 2, 38);

-- Tỉnh Bình Thuận
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(487, 'Thành phố Phan Thiết', '593', 2, 39),
(488, 'Thị xã La Gi', '594', 2, 39),
(489, 'Huyện Tuy Phong', '595', 2, 39),
(490, 'Huyện Bắc Bình', '596', 2, 39),
(491, 'Huyện Hàm Thuận Bắc', '597', 2, 39),
(492, 'Huyện Hàm Thuận Nam', '598', 2, 39),
(493, 'Huyện Tánh Linh', '599', 2, 39),
(494, 'Huyện Đức Linh', '600', 2, 39),
(495, 'Huyện Hàm Tân', '601', 2, 39),
(496, 'Huyện Phú Quí', '602', 2, 39);

-- Tỉnh Kon Tum
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(497, 'Thành phố Kon Tum', '608', 2, 40),
(498, 'Huyện Đắk Glei', '610', 2, 40),
(499, 'Huyện Ngọc Hồi', '611', 2, 40),
(500, 'Huyện Đắk Tô', '612', 2, 40),
(501, 'Huyện Kon Plông', '613', 2, 40),
(502, 'Huyện Kon Rẫy', '614', 2, 40),
(503, 'Huyện Đắk Hà', '615', 2, 40),
(504, 'Huyện Sa Thầy', '616', 2, 40),
(505, 'Huyện Tu Mơ Rông', '617', 2, 40),
(506, 'Huyện Ia H'' Drai', '618', 2, 40);

-- Tỉnh Gia Lai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(507, 'Thành phố Pleiku', '622', 2, 41),
(508, 'Thị xã An Khê', '623', 2, 41),
(509, 'Thị xã Ayun Pa', '624', 2, 41),
(510, 'Huyện KBang', '625', 2, 41),
(511, 'Huyện Đăk Đoa', '626', 2, 41),
(512, 'Huyện Chư Păh', '627', 2, 41),
(513, 'Huyện Ia Grai', '628', 2, 41),
(514, 'Huyện Mang Yang', '629', 2, 41),
(515, 'Huyện Kông Chro', '630', 2, 41),
(516, 'Huyện Đức Cơ', '631', 2, 41),
(517, 'Huyện Chư Prông', '632', 2, 41),
(518, 'Huyện Chư Sê', '633', 2, 41),
(519, 'Huyện Đăk Pơ', '634', 2, 41),
(520, 'Huyện Ia Pa', '635', 2, 41),
(521, 'Huyện Krông Pa', '637', 2, 41),
(522, 'Huyện Phú Thiện', '638', 2, 41),
(523, 'Huyện Chư Pưh', '639', 2, 41);

-- Tỉnh Đắk Lắk
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(524, 'Thành phố Buôn Ma Thuột', '643', 2, 42),
(525, 'Thị xã Buôn Hồ', '644', 2, 42),
(526, 'Huyện Ea H''leo', '645', 2, 42),
(527, 'Huyện Ea Súp', '646', 2, 42),
(528, 'Huyện Buôn Đôn', '647', 2, 42),
(529, 'Huyện Cư M''gar', '648', 2, 42),
(530, 'Huyện Krông Búk', '649', 2, 42),
(531, 'Huyện Krông Năng', '650', 2, 42),
(532, 'Huyện Ea Kar', '651', 2, 42),
(533, 'Huyện M''Đrắk', '652', 2, 42),
(534, 'Huyện Krông Bông', '653', 2, 42),
(535, 'Huyện Krông Pắc', '654', 2, 42),
(536, 'Huyện Krông A Na', '655', 2, 42),
(537, 'Huyện Lắk', '656', 2, 42),
(538, 'Huyện Cư Kuin', '657', 2, 42);

-- Tỉnh Đắk Nông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(539, 'Thành phố Gia Nghĩa', '660', 2, 43),
(540, 'Huyện Đăk Glong', '661', 2, 43),
(541, 'Huyện Cư Jút', '662', 2, 43),
(542, 'Huyện Đắk Mil', '663', 2, 43),
(543, 'Huyện Krông Nô', '664', 2, 43),
(544, 'Huyện Đắk Song', '665', 2, 43),
(545, 'Huyện Đắk R''Lấp', '666', 2, 43),
(546, 'Huyện Tuy Đức', '667', 2, 43);

-- Tỉnh Lâm Đồng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(547, 'Thành phố Đà Lạt', '672', 2, 44),
(548, 'Thành phố Bảo Lộc', '673', 2, 44),
(549, 'Huyện Đam Rông', '674', 2, 44),
(550, 'Huyện Lạc Dương', '675', 2, 44),
(551, 'Huyện Lâm Hà', '676', 2, 44),
(552, 'Huyện Đơn Dương', '677', 2, 44),
(553, 'Huyện Đức Trọng', '678', 2, 44),
(554, 'Huyện Di Linh', '679', 2, 44),
(555, 'Huyện Bảo Lâm', '680', 2, 44),
(556, 'Huyện Đạ Huoai', '682', 2, 44);

-- Tỉnh Bình Phước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(557, 'Thị xã Phước Long', '688', 2, 45),
(558, 'Thành phố Đồng Xoài', '689', 2, 45),
(559, 'Thị xã Bình Long', '690', 2, 45),
(560, 'Huyện Bù Gia Mập', '691', 2, 45),
(561, 'Huyện Lộc Ninh', '692', 2, 45),
(562, 'Huyện Bù Đốp', '693', 2, 45),
(563, 'Huyện Hớn Quản', '694', 2, 45),
(564, 'Huyện Đồng Phú', '695', 2, 45),
(565, 'Huyện Bù Đăng', '696', 2, 45),
(566, 'Thị xã Chơn Thành', '697', 2, 45),
(567, 'Huyện Phú Riềng', '698', 2, 45);

-- Tỉnh Tây Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(568, 'Thành phố Tây Ninh', '703', 2, 46),
(569, 'Huyện Tân Biên', '705', 2, 46),
(570, 'Huyện Tân Châu', '706', 2, 46),
(571, 'Huyện Dương Minh Châu', '707', 2, 46),
(572, 'Huyện Châu Thành', '708', 2, 46),
(573, 'Thị xã Hòa Thành', '709', 2, 46),
(574, 'Huyện Gò Dầu', '710', 2, 46),
(575, 'Huyện Bến Cầu', '711', 2, 46),
(576, 'Thị xã Trảng Bàng', '712', 2, 46);

-- Tỉnh Bình Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(577, 'Thành phố Thủ Dầu Một', '718', 2, 47),
(578, 'Huyện Bàu Bàng', '719', 2, 47),
(579, 'Huyện Dầu Tiếng', '720', 2, 47),
(580, 'Thành phố Bến Cát', '721', 2, 47),
(581, 'Huyện Phú Giáo', '722', 2, 47),
(582, 'Thành phố Tân Uyên', '723', 2, 47),
(583, 'Thành phố Dĩ An', '724', 2, 47),
(584, 'Thành phố Thuận An', '725', 2, 47),
(585, 'Huyện Bắc Tân Uyên', '726', 2, 47);

-- Tỉnh Đồng Nai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(586, 'Thành phố Biên Hòa', '731', 2, 48),
(587, 'Thành phố Long Khánh', '732', 2, 48),
(588, 'Huyện Tân Phú', '734', 2, 48),
(589, 'Huyện Vĩnh Cửu', '735', 2, 48),
(590, 'Huyện Định Quán', '736', 2, 48),
(591, 'Huyện Trảng Bom', '737', 2, 48),
(592, 'Huyện Thống Nhất', '738', 2, 48),
(593, 'Huyện Cẩm Mỹ', '739', 2, 48),
(594, 'Huyện Long Thành', '740', 2, 48),
(595, 'Huyện Xuân Lộc', '741', 2, 48),
(596, 'Huyện Nhơn Trạch', '742', 2, 48);

-- Tỉnh Bà Rịa - Vũng Tàu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(597, 'Thành phố Vũng Tàu', '747', 2, 49),
(598, 'Thành phố Bà Rịa', '748', 2, 49),
(599, 'Huyện Châu Đức', '750', 2, 49),
(600, 'Huyện Xuyên Mộc', '751', 2, 49),
(601, 'Huyện Long Đất', '753', 2, 49),
(602, 'Thị xã Phú Mỹ', '754', 2, 49),
(603, 'Huyện Côn Đảo', '755', 2, 49);

-- Thành phố Hồ Chí Minh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(604, 'Quận 1', '760', 2, 50),
(605, 'Quận 12', '761', 2, 50),
(606, 'Quận Gò Vấp', '764', 2, 50),
(607, 'Quận Bình Thạnh', '765', 2, 50),
(608, 'Quận Tân Bình', '766', 2, 50),
(609, 'Quận Tân Phú', '767', 2, 50),
(610, 'Quận Phú Nhuận', '768', 2, 50),
(611, 'Thành phố Thủ Đức', '769', 2, 50),
(612, 'Quận 3', '770', 2, 50),
(613, 'Quận 10', '771', 2, 50),
(614, 'Quận 11', '772', 2, 50),
(615, 'Quận 4', '773', 2, 50),
(616, 'Quận 5', '774', 2, 50),
(617, 'Quận 6', '775', 2, 50),
(618, 'Quận 8', '776', 2, 50),
(619, 'Quận Bình Tân', '777', 2, 50),
(620, 'Quận 7', '778', 2, 50),
(621, 'Huyện Củ Chi', '783', 2, 50),
(622, 'Huyện Hóc Môn', '784', 2, 50),
(623, 'Huyện Bình Chánh', '785', 2, 50),
(624, 'Huyện Nhà Bè', '786', 2, 50),
(625, 'Huyện Cần Giờ', '787', 2, 50);

-- Tỉnh Long An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(626, 'Thành phố Tân An', '794', 2, 51),
(627, 'Thị xã Kiến Tường', '795', 2, 51),
(628, 'Huyện Tân Hưng', '796', 2, 51),
(629, 'Huyện Vĩnh Hưng', '797', 2, 51),
(630, 'Huyện Mộc Hóa', '798', 2, 51),
(631, 'Huyện Tân Thạnh', '799', 2, 51),
(632, 'Huyện Thạnh Hóa', '800', 2, 51),
(633, 'Huyện Đức Huệ', '801', 2, 51),
(634, 'Huyện Đức Hòa', '802', 2, 51),
(635, 'Huyện Bến Lức', '803', 2, 51),
(636, 'Huyện Thủ Thừa', '804', 2, 51),
(637, 'Huyện Tân Trụ', '805', 2, 51),
(638, 'Huyện Cần Đước', '806', 2, 51),
(639, 'Huyện Cần Giuộc', '807', 2, 51),
(640, 'Huyện Châu Thành', '808', 2, 51);

-- Tỉnh Tiền Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(641, 'Thành phố Mỹ Tho', '815', 2, 52),
(642, 'Thành phố Gò Công', '816', 2, 52),
(643, 'Thị xã Cai Lậy', '817', 2, 52),
(644, 'Huyện Tân Phước', '818', 2, 52),
(645, 'Huyện Cái Bè', '819', 2, 52),
(646, 'Huyện Cai Lậy', '820', 2, 52),
(647, 'Huyện Châu Thành', '821', 2, 52),
(648, 'Huyện Chợ Gạo', '822', 2, 52),
(649, 'Huyện Gò Công Tây', '823', 2, 52),
(650, 'Huyện Gò Công Đông', '824', 2, 52),
(651, 'Huyện Tân Phú Đông', '825', 2, 52);

-- Tỉnh Bến Tre
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(652, 'Thành phố Bến Tre', '829', 2, 53),
(653, 'Huyện Châu Thành', '831', 2, 53),
(654, 'Huyện Chợ Lách', '832', 2, 53),
(655, 'Huyện Mỏ Cày Nam', '833', 2, 53),
(656, 'Huyện Giồng Trôm', '834', 2, 53),
(657, 'Huyện Bình Đại', '835', 2, 53),
(658, 'Huyện Ba Tri', '836', 2, 53),
(659, 'Huyện Thạnh Phú', '837', 2, 53),
(660, 'Huyện Mỏ Cày Bắc', '838', 2, 53);

-- Tỉnh Trà Vinh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(661, 'Thành phố Trà Vinh', '842', 2, 54),
(662, 'Huyện Càng Long', '844', 2, 54),
(663, 'Huyện Cầu Kè', '845', 2, 54),
(664, 'Huyện Tiểu Cần', '846', 2, 54),
(665, 'Huyện Châu Thành', '847', 2, 54),
(666, 'Huyện Cầu Ngang', '848', 2, 54),
(667, 'Huyện Trà Cú', '849', 2, 54),
(668, 'Huyện Duyên Hải', '850', 2, 54),
(669, 'Thị xã Duyên Hải', '851', 2, 54);

-- Tỉnh Vĩnh Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(670, 'Thành phố Vĩnh Long', '855', 2, 55),
(671, 'Huyện Long Hồ', '857', 2, 55),
(672, 'Huyện Mang Thít', '858', 2, 55),
(673, 'Huyện Vũng Liêm', '859', 2, 55),
(674, 'Huyện Tam Bình', '860', 2, 55),
(675, 'Thị xã Bình Minh', '861', 2, 55),
(676, 'Huyện Trà Ôn', '862', 2, 55),
(677, 'Huyện Bình Tân', '863', 2, 55);

-- Tỉnh Đồng Tháp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(678, 'Thành phố Cao Lãnh', '866', 2, 56),
(679, 'Thành phố Sa Đéc', '867', 2, 56),
(680, 'Thành phố Hồng Ngự', '868', 2, 56),
(681, 'Huyện Tân Hồng', '869', 2, 56),
(682, 'Huyện Hồng Ngự', '870', 2, 56),
(683, 'Huyện Tam Nông', '871', 2, 56),
(684, 'Huyện Tháp Mười', '872', 2, 56),
(685, 'Huyện Cao Lãnh', '873', 2, 56),
(686, 'Huyện Thanh Bình', '874', 2, 56),
(687, 'Huyện Lấp Vò', '875', 2, 56),
(688, 'Huyện Lai Vung', '876', 2, 56),
(689, 'Huyện Châu Thành', '877', 2, 56);

-- Tỉnh An Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(690, 'Thành phố Long Xuyên', '883', 2, 57),
(691, 'Thành phố Châu Đốc', '884', 2, 57),
(692, 'Huyện An Phú', '886', 2, 57),
(693, 'Thị xã Tân Châu', '887', 2, 57),
(694, 'Huyện Phú Tân', '888', 2, 57),
(695, 'Huyện Châu Phú', '889', 2, 57),
(696, 'Thị xã Tịnh Biên', '890', 2, 57),
(697, 'Huyện Tri Tôn', '891', 2, 57),
(698, 'Huyện Châu Thành', '892', 2, 57),
(699, 'Huyện Chợ Mới', '893', 2, 57),
(700, 'Huyện Thoại Sơn', '894', 2, 57);

-- Tỉnh Kiên Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(701, 'Thành phố Rạch Giá', '899', 2, 58),
(702, 'Thành phố Hà Tiên', '900', 2, 58),
(703, 'Huyện Kiên Lương', '902', 2, 58),
(704, 'Huyện Hòn Đất', '903', 2, 58),
(705, 'Huyện Tân Hiệp', '904', 2, 58),
(706, 'Huyện Châu Thành', '905', 2, 58),
(707, 'Huyện Giồng Riềng', '906', 2, 58),
(708, 'Huyện Gò Quao', '907', 2, 58),
(709, 'Huyện An Biên', '908', 2, 58),
(710, 'Huyện An Minh', '909', 2, 58),
(711, 'Huyện Vĩnh Thuận', '910', 2, 58),
(712, 'Thành phố Phú Quốc', '911', 2, 58),
(713, 'Huyện Kiên Hải', '912', 2, 58),
(714, 'Huyện U Minh Thượng', '913', 2, 58),
(715, 'Huyện Giang Thành', '914', 2, 58);

-- Thành phố Cần Thơ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(716, 'Quận Ninh Kiều', '916', 2, 59),
(717, 'Quận Ô Môn', '917', 2, 59),
(718, 'Quận Bình Thuỷ', '918', 2, 59),
(719, 'Quận Cái Răng', '919', 2, 59),
(720, 'Quận Thốt Nốt', '923', 2, 59),
(721, 'Huyện Vĩnh Thạnh', '924', 2, 59),
(722, 'Huyện Cờ Đỏ', '925', 2, 59),
(723, 'Huyện Phong Điền', '926', 2, 59),
(724, 'Huyện Thới Lai', '927', 2, 59);

-- Tỉnh Hậu Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(725, 'Thành phố Vị Thanh', '930', 2, 60),
(726, 'Thành phố Ngã Bảy', '931', 2, 60),
(727, 'Huyện Châu Thành A', '932', 2, 60),
(728, 'Huyện Châu Thành', '933', 2, 60),
(729, 'Huyện Phụng Hiệp', '934', 2, 60),
(730, 'Huyện Vị Thuỷ', '935', 2, 60),
(731, 'Huyện Long Mỹ', '936', 2, 60),
(732, 'Thị xã Long Mỹ', '937', 2, 60);

-- Tỉnh Sóc Trăng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(733, 'Thành phố Sóc Trăng', '941', 2, 61),
(734, 'Huyện Châu Thành', '942', 2, 61),
(735, 'Huyện Kế Sách', '943', 2, 61),
(736, 'Huyện Mỹ Tú', '944', 2, 61),
(737, 'Huyện Cù Lao Dung', '945', 2, 61),
(738, 'Huyện Long Phú', '946', 2, 61),
(739, 'Huyện Mỹ Xuyên', '947', 2, 61),
(740, 'Thị xã Ngã Năm', '948', 2, 61),
(741, 'Huyện Thạnh Trị', '949', 2, 61),
(742, 'Thị xã Vĩnh Châu', '950', 2, 61),
(743, 'Huyện Trần Đề', '951', 2, 61);

-- Tỉnh Bạc Liêu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(744, 'Thành phố Bạc Liêu', '954', 2, 62),
(745, 'Huyện Hồng Dân', '956', 2, 62),
(746, 'Huyện Phước Long', '957', 2, 62),
(747, 'Huyện Vĩnh Lợi', '958', 2, 62),
(748, 'Thị xã Giá Rai', '959', 2, 62),
(749, 'Huyện Đông Hải', '960', 2, 62),
(750, 'Huyện Hoà Bình', '961', 2, 62);

-- Tỉnh Cà Mau
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(751, 'Thành phố Cà Mau', '964', 2, 63),
(752, 'Huyện U Minh', '966', 2, 63),
(753, 'Huyện Thới Bình', '967', 2, 63),
(754, 'Huyện Trần Văn Thời', '968', 2, 63),
(755, 'Huyện Cái Nước', '969', 2, 63),
(756, 'Huyện Đầm Dơi', '970', 2, 63),
(757, 'Huyện Năm Căn', '971', 2, 63),
(758, 'Huyện Phú Tân', '972', 2, 63),
(759, 'Huyện Ngọc Hiển', '973', 2, 63);

-- WARDS (level 3): 10051 records
-- Thành phố Hà Nội > Quận Ba Đình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(760, 'Phường Phúc Xá', '1', 3, 64),
(761, 'Phường Trúc Bạch', '4', 3, 64),
(762, 'Phường Vĩnh Phúc', '6', 3, 64),
(763, 'Phường Cống Vị', '7', 3, 64),
(764, 'Phường Liễu Giai', '8', 3, 64),
(765, 'Phường Quán Thánh', '13', 3, 64),
(766, 'Phường Ngọc Hà', '16', 3, 64),
(767, 'Phường Điện Biên', '19', 3, 64),
(768, 'Phường Đội Cấn', '22', 3, 64),
(769, 'Phường Ngọc Khánh', '25', 3, 64),
(770, 'Phường Kim Mã', '28', 3, 64),
(771, 'Phường Giảng Võ', '31', 3, 64),
(772, 'Phường Thành Công', '34', 3, 64);

-- Thành phố Hà Nội > Quận Hoàn Kiếm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(773, 'Phường Phúc Tân', '37', 3, 65),
(774, 'Phường Đồng Xuân', '40', 3, 65),
(775, 'Phường Hàng Mã', '43', 3, 65),
(776, 'Phường Hàng Buồm', '46', 3, 65),
(777, 'Phường Hàng Đào', '49', 3, 65),
(778, 'Phường Hàng Bồ', '52', 3, 65),
(779, 'Phường Cửa Đông', '55', 3, 65),
(780, 'Phường Lý Thái Tổ', '58', 3, 65),
(781, 'Phường Hàng Bạc', '61', 3, 65),
(782, 'Phường Hàng Gai', '64', 3, 65),
(783, 'Phường Chương Dương', '67', 3, 65),
(784, 'Phường Hàng Trống', '70', 3, 65),
(785, 'Phường Cửa Nam', '73', 3, 65),
(786, 'Phường Hàng Bông', '76', 3, 65),
(787, 'Phường Tràng Tiền', '79', 3, 65),
(788, 'Phường Trần Hưng Đạo', '82', 3, 65),
(789, 'Phường Phan Chu Trinh', '85', 3, 65),
(790, 'Phường Hàng Bài', '88', 3, 65);

-- Thành phố Hà Nội > Quận Tây Hồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(791, 'Phường Phú Thượng', '91', 3, 66),
(792, 'Phường Nhật Tân', '94', 3, 66),
(793, 'Phường Tứ Liên', '97', 3, 66),
(794, 'Phường Quảng An', '100', 3, 66),
(795, 'Phường Xuân La', '103', 3, 66),
(796, 'Phường Yên Phụ', '106', 3, 66),
(797, 'Phường Bưởi', '109', 3, 66),
(798, 'Phường Thụy Khuê', '112', 3, 66);

-- Thành phố Hà Nội > Quận Long Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(799, 'Phường Thượng Thanh', '115', 3, 67),
(800, 'Phường Ngọc Thụy', '118', 3, 67),
(801, 'Phường Giang Biên', '121', 3, 67),
(802, 'Phường Đức Giang', '124', 3, 67),
(803, 'Phường Việt Hưng', '127', 3, 67),
(804, 'Phường Gia Thụy', '130', 3, 67),
(805, 'Phường Ngọc Lâm', '133', 3, 67),
(806, 'Phường Phúc Lợi', '136', 3, 67),
(807, 'Phường Bồ Đề', '139', 3, 67),
(808, 'Phường Long Biên', '145', 3, 67),
(809, 'Phường Thạch Bàn', '148', 3, 67),
(810, 'Phường Phúc Đồng', '151', 3, 67),
(811, 'Phường Cự Khối', '154', 3, 67);

-- Thành phố Hà Nội > Quận Cầu Giấy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(812, 'Phường Nghĩa Đô', '157', 3, 68),
(813, 'Phường Nghĩa Tân', '160', 3, 68),
(814, 'Phường Mai Dịch', '163', 3, 68),
(815, 'Phường Dịch Vọng', '166', 3, 68),
(816, 'Phường Dịch Vọng Hậu', '167', 3, 68),
(817, 'Phường Quan Hoa', '169', 3, 68),
(818, 'Phường Yên Hoà', '172', 3, 68),
(819, 'Phường Trung Hoà', '175', 3, 68);

-- Thành phố Hà Nội > Quận Đống Đa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(820, 'Phường Cát Linh', '178', 3, 69),
(821, 'Phường Văn Miếu - Quốc Tử Giám', '181', 3, 69),
(822, 'Phường Láng Thượng', '187', 3, 69),
(823, 'Phường Ô Chợ Dừa', '190', 3, 69),
(824, 'Phường Văn Chương', '193', 3, 69),
(825, 'Phường Hàng Bột', '196', 3, 69),
(826, 'Phường Láng Hạ', '199', 3, 69),
(827, 'Phường Khâm Thiên', '202', 3, 69),
(828, 'Phường Thổ Quan', '205', 3, 69),
(829, 'Phường Nam Đồng', '208', 3, 69),
(830, 'Phường Quang Trung', '214', 3, 69),
(831, 'Phường Trung Liệt', '217', 3, 69),
(832, 'Phường Phương Liên - Trung Tự', '226', 3, 69),
(833, 'Phường Kim Liên', '229', 3, 69),
(834, 'Phường Phương Mai', '232', 3, 69),
(835, 'Phường Thịnh Quang', '235', 3, 69),
(836, 'Phường Khương Thượng', '238', 3, 69);

-- Thành phố Hà Nội > Quận Hai Bà Trưng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(837, 'Phường Nguyễn Du', '241', 3, 70),
(838, 'Phường Bạch Đằng', '244', 3, 70),
(839, 'Phường Phạm Đình Hổ', '247', 3, 70),
(840, 'Phường Lê Đại Hành', '256', 3, 70),
(841, 'Phường Đồng Nhân', '259', 3, 70),
(842, 'Phường Phố Huế', '262', 3, 70),
(843, 'Phường Thanh Lương', '268', 3, 70),
(844, 'Phường Thanh Nhàn', '271', 3, 70),
(845, 'Phường Bách Khoa', '277', 3, 70),
(846, 'Phường Đồng Tâm', '280', 3, 70),
(847, 'Phường Vĩnh Tuy', '283', 3, 70),
(848, 'Phường Quỳnh Mai', '289', 3, 70),
(849, 'Phường Bạch Mai', '292', 3, 70),
(850, 'Phường Minh Khai', '295', 3, 70),
(851, 'Phường Trương Định', '298', 3, 70);

-- Thành phố Hà Nội > Quận Hoàng Mai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(852, 'Phường Thanh Trì', '301', 3, 71),
(853, 'Phường Vĩnh Hưng', '304', 3, 71),
(854, 'Phường Định Công', '307', 3, 71),
(855, 'Phường Mai Động', '310', 3, 71),
(856, 'Phường Tương Mai', '313', 3, 71),
(857, 'Phường Đại Kim', '316', 3, 71),
(858, 'Phường Tân Mai', '319', 3, 71),
(859, 'Phường Hoàng Văn Thụ', '322', 3, 71),
(860, 'Phường Giáp Bát', '325', 3, 71),
(861, 'Phường Lĩnh Nam', '328', 3, 71),
(862, 'Phường Thịnh Liệt', '331', 3, 71),
(863, 'Phường Trần Phú', '334', 3, 71),
(864, 'Phường Hoàng Liệt', '337', 3, 71),
(865, 'Phường Yên Sở', '340', 3, 71);

-- Thành phố Hà Nội > Quận Thanh Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(866, 'Phường Nhân Chính', '343', 3, 72),
(867, 'Phường Thượng Đình', '346', 3, 72),
(868, 'Phường Khương Trung', '349', 3, 72),
(869, 'Phường Khương Mai', '352', 3, 72),
(870, 'Phường Thanh Xuân Trung', '355', 3, 72),
(871, 'Phường Phương Liệt', '358', 3, 72),
(872, 'Phường Khương Đình', '364', 3, 72),
(873, 'Phường Thanh Xuân Bắc', '367', 3, 72),
(874, 'Phường Hạ Đình', '373', 3, 72);

-- Thành phố Hà Nội > Huyện Sóc Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(875, 'Thị trấn Sóc Sơn', '376', 3, 73),
(876, 'Xã Bắc Sơn', '379', 3, 73),
(877, 'Xã Minh Trí', '382', 3, 73),
(878, 'Xã Hồng Kỳ', '385', 3, 73),
(879, 'Xã Nam Sơn', '388', 3, 73),
(880, 'Xã Trung Giã', '391', 3, 73),
(881, 'Xã Tân Hưng', '394', 3, 73),
(882, 'Xã Minh Phú', '397', 3, 73),
(883, 'Xã Phù Linh', '400', 3, 73),
(884, 'Xã Bắc Phú', '403', 3, 73),
(885, 'Xã Tân Minh', '406', 3, 73),
(886, 'Xã Quang Tiến', '409', 3, 73),
(887, 'Xã Hiền Ninh', '412', 3, 73),
(888, 'Xã Tân Dân', '415', 3, 73),
(889, 'Xã Tiên Dược', '418', 3, 73),
(890, 'Xã Việt Long', '421', 3, 73),
(891, 'Xã Xuân Giang', '424', 3, 73),
(892, 'Xã Mai Đình', '427', 3, 73),
(893, 'Xã Đức Hoà', '430', 3, 73),
(894, 'Xã Thanh Xuân', '433', 3, 73),
(895, 'Xã Đông Xuân', '436', 3, 73),
(896, 'Xã Kim Lũ', '439', 3, 73),
(897, 'Xã Phú Cường', '442', 3, 73),
(898, 'Xã Phú Minh', '445', 3, 73),
(899, 'Xã Phù Lỗ', '448', 3, 73),
(900, 'Xã Xuân Thu', '451', 3, 73);

-- Thành phố Hà Nội > Huyện Đông Anh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(901, 'Thị trấn Đông Anh', '454', 3, 74),
(902, 'Xã Xuân Nộn', '457', 3, 74),
(903, 'Xã Thuỵ Lâm', '460', 3, 74),
(904, 'Xã Bắc Hồng', '463', 3, 74),
(905, 'Xã Nguyên Khê', '466', 3, 74),
(906, 'Xã Nam Hồng', '469', 3, 74),
(907, 'Xã Tiên Dương', '472', 3, 74),
(908, 'Xã Vân Hà', '475', 3, 74),
(909, 'Xã Uy Nỗ', '478', 3, 74),
(910, 'Xã Vân Nội', '481', 3, 74),
(911, 'Xã Liên Hà', '484', 3, 74),
(912, 'Xã Việt Hùng', '487', 3, 74),
(913, 'Xã Kim Nỗ', '490', 3, 74),
(914, 'Xã Kim Chung', '493', 3, 74),
(915, 'Xã Dục Tú', '496', 3, 74),
(916, 'Xã Đại Mạch', '499', 3, 74),
(917, 'Xã Vĩnh Ngọc', '502', 3, 74),
(918, 'Xã Cổ Loa', '505', 3, 74),
(919, 'Xã Hải Bối', '508', 3, 74),
(920, 'Xã Xuân Canh', '511', 3, 74),
(921, 'Xã Võng La', '514', 3, 74),
(922, 'Xã Tàm Xá', '517', 3, 74),
(923, 'Xã Mai Lâm', '520', 3, 74),
(924, 'Xã Đông Hội', '523', 3, 74);

-- Thành phố Hà Nội > Huyện Gia Lâm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(925, 'Thị trấn Yên Viên', '526', 3, 75),
(926, 'Xã Yên Thường', '529', 3, 75),
(927, 'Xã Yên Viên', '532', 3, 75),
(928, 'Xã Ninh Hiệp', '535', 3, 75),
(929, 'Xã Thiên Đức', '541', 3, 75),
(930, 'Xã Phù Đổng', '544', 3, 75),
(931, 'Xã Lệ Chi', '550', 3, 75),
(932, 'Xã Cổ Bi', '553', 3, 75),
(933, 'Xã Đặng Xá', '556', 3, 75),
(934, 'Xã Phú Sơn', '562', 3, 75),
(935, 'Thị trấn Trâu Quỳ', '565', 3, 75),
(936, 'Xã Dương Quang', '568', 3, 75),
(937, 'Xã Dương Xá', '571', 3, 75),
(938, 'Xã Đa Tốn', '577', 3, 75),
(939, 'Xã Kiêu Kỵ', '580', 3, 75),
(940, 'Xã Bát Tràng', '583', 3, 75),
(941, 'Xã Kim Đức', '589', 3, 75);

-- Thành phố Hà Nội > Quận Nam Từ Liêm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(942, 'Phường Cầu Diễn', '592', 3, 76),
(943, 'Phường Xuân Phương', '622', 3, 76),
(944, 'Phường Phương Canh', '623', 3, 76),
(945, 'Phường Mỹ Đình 1', '625', 3, 76),
(946, 'Phường Mỹ Đình 2', '626', 3, 76),
(947, 'Phường Tây Mỗ', '628', 3, 76),
(948, 'Phường Mễ Trì', '631', 3, 76),
(949, 'Phường Phú Đô', '632', 3, 76),
(950, 'Phường Đại Mỗ', '634', 3, 76),
(951, 'Phường Trung Văn', '637', 3, 76);

-- Thành phố Hà Nội > Huyện Thanh Trì
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(952, 'Thị trấn Văn Điển', '640', 3, 77),
(953, 'Xã Tân Triều', '643', 3, 77),
(954, 'Xã Thanh Liệt', '646', 3, 77),
(955, 'Xã Tả Thanh Oai', '649', 3, 77),
(956, 'Xã Hữu Hoà', '652', 3, 77),
(957, 'Xã Tam Hiệp', '655', 3, 77),
(958, 'Xã Tứ Hiệp', '658', 3, 77),
(959, 'Xã Yên Mỹ', '661', 3, 77),
(960, 'Xã Vĩnh Quỳnh', '664', 3, 77),
(961, 'Xã Ngũ Hiệp', '667', 3, 77),
(962, 'Xã Duyên Hà', '670', 3, 77),
(963, 'Xã Ngọc Hồi', '673', 3, 77),
(964, 'Xã Vạn Phúc', '676', 3, 77),
(965, 'Xã Đại áng', '679', 3, 77),
(966, 'Xã Liên Ninh', '682', 3, 77),
(967, 'Xã Đông Mỹ', '685', 3, 77);

-- Thành phố Hà Nội > Quận Bắc Từ Liêm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(968, 'Phường Thượng Cát', '595', 3, 78),
(969, 'Phường Liên Mạc', '598', 3, 78),
(970, 'Phường Đông Ngạc', '601', 3, 78),
(971, 'Phường Đức Thắng', '602', 3, 78),
(972, 'Phường Thụy Phương', '604', 3, 78),
(973, 'Phường Tây Tựu', '607', 3, 78),
(974, 'Phường Xuân Đỉnh', '610', 3, 78),
(975, 'Phường Xuân Tảo', '611', 3, 78),
(976, 'Phường Minh Khai', '613', 3, 78),
(977, 'Phường Cổ Nhuế 1', '616', 3, 78),
(978, 'Phường Cổ Nhuế 2', '617', 3, 78),
(979, 'Phường Phú Diễn', '619', 3, 78),
(980, 'Phường Phúc Diễn', '620', 3, 78);

-- Thành phố Hà Nội > Huyện Mê Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(981, 'Thị trấn Chi Đông', '8973', 3, 79),
(982, 'Xã Đại Thịnh', '8974', 3, 79),
(983, 'Xã Kim Hoa', '8977', 3, 79),
(984, 'Xã Thạch Đà', '8980', 3, 79),
(985, 'Xã Tiến Thắng', '8983', 3, 79),
(986, 'Xã Tự Lập', '8986', 3, 79),
(987, 'Thị trấn Quang Minh', '8989', 3, 79),
(988, 'Xã Thanh Lâm', '8992', 3, 79),
(989, 'Xã Tam Đồng', '8995', 3, 79),
(990, 'Xã Liên Mạc', '8998', 3, 79),
(991, 'Xã Chu Phan', '9004', 3, 79),
(992, 'Xã Tiến Thịnh', '9007', 3, 79),
(993, 'Xã Mê Linh', '9010', 3, 79),
(994, 'Xã Văn Khê', '9013', 3, 79),
(995, 'Xã Hoàng Kim', '9016', 3, 79),
(996, 'Xã Tiền Phong', '9019', 3, 79),
(997, 'Xã Tráng Việt', '9022', 3, 79);

-- Thành phố Hà Nội > Quận Hà Đông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(998, 'Phường Quang Trung', '9538', 3, 80),
(999, 'Phường Mộ Lao', '9541', 3, 80),
(1000, 'Phường Văn Quán', '9542', 3, 80),
(1001, 'Phường Vạn Phúc', '9544', 3, 80),
(1002, 'Phường La Khê', '9551', 3, 80),
(1003, 'Phường Phú La', '9552', 3, 80),
(1004, 'Phường Phúc La', '9553', 3, 80),
(1005, 'Phường Hà Cầu', '9556', 3, 80),
(1006, 'Phường Yên Nghĩa', '9562', 3, 80),
(1007, 'Phường Kiến Hưng', '9565', 3, 80),
(1008, 'Phường Phú Lãm', '9568', 3, 80),
(1009, 'Phường Phú Lương', '9571', 3, 80),
(1010, 'Phường Dương Nội', '9886', 3, 80),
(1011, 'Phường Đồng Mai', '10117', 3, 80),
(1012, 'Phường Biên Giang', '10123', 3, 80);

-- Thành phố Hà Nội > Thị xã Sơn Tây
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1013, 'Phường Ngô Quyền', '9574', 3, 81),
(1014, 'Phường Phú Thịnh', '9577', 3, 81),
(1015, 'Phường Sơn Lộc', '9586', 3, 81),
(1016, 'Phường Xuân Khanh', '9589', 3, 81),
(1017, 'Xã Đường Lâm', '9592', 3, 81),
(1018, 'Phường Viên Sơn', '9595', 3, 81),
(1019, 'Xã Xuân Sơn', '9598', 3, 81),
(1020, 'Phường Trung Hưng', '9601', 3, 81),
(1021, 'Xã Thanh Mỹ', '9604', 3, 81),
(1022, 'Phường Trung Sơn Trầm', '9607', 3, 81),
(1023, 'Xã Kim Sơn', '9610', 3, 81),
(1024, 'Xã Sơn Đông', '9613', 3, 81),
(1025, 'Xã Cổ Đông', '9616', 3, 81);

-- Thành phố Hà Nội > Huyện Ba Vì
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1026, 'Thị trấn Tây Đằng', '9619', 3, 82),
(1027, 'Xã Phú Cường', '9625', 3, 82),
(1028, 'Xã Cổ Đô', '9628', 3, 82),
(1029, 'Xã Vạn Thắng', '9634', 3, 82),
(1030, 'Xã Phong Vân', '9640', 3, 82),
(1031, 'Xã Phú Đông', '9643', 3, 82),
(1032, 'Xã Phú Hồng', '9646', 3, 82),
(1033, 'Xã Phú Châu', '9649', 3, 82),
(1034, 'Xã Thái Hòa', '9652', 3, 82),
(1035, 'Xã Đồng Thái', '9655', 3, 82),
(1036, 'Xã Phú Sơn', '9658', 3, 82),
(1037, 'Xã Minh Châu', '9661', 3, 82),
(1038, 'Xã Vật Lại', '9664', 3, 82),
(1039, 'Xã Chu Minh', '9667', 3, 82),
(1040, 'Xã Tòng Bạt', '9670', 3, 82),
(1041, 'Xã Cẩm Lĩnh', '9673', 3, 82),
(1042, 'Xã Sơn Đà', '9676', 3, 82),
(1043, 'Xã Đông Quang', '9679', 3, 82),
(1044, 'Xã Tiên Phong', '9682', 3, 82),
(1045, 'Xã Thụy An', '9685', 3, 82),
(1046, 'Xã Cam Thượng', '9688', 3, 82),
(1047, 'Xã Thuần Mỹ', '9691', 3, 82),
(1048, 'Xã Tản Lĩnh', '9694', 3, 82),
(1049, 'Xã Ba Trại', '9697', 3, 82),
(1050, 'Xã Minh Quang', '9700', 3, 82),
(1051, 'Xã Ba Vì', '9703', 3, 82),
(1052, 'Xã Vân Hòa', '9706', 3, 82),
(1053, 'Xã Yên Bài', '9709', 3, 82),
(1054, 'Xã Khánh Thượng', '9712', 3, 82);

-- Thành phố Hà Nội > Huyện Phúc Thọ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1055, 'Thị trấn Phúc Thọ', '9715', 3, 83),
(1056, 'Xã Vân Phúc', '9721', 3, 83),
(1057, 'Xã Nam Hà', '9724', 3, 83),
(1058, 'Xã Xuân Đình', '9727', 3, 83),
(1059, 'Xã Sen Phương', '9733', 3, 83),
(1060, 'Xã Võng Xuyên', '9739', 3, 83),
(1061, 'Xã Tích Lộc', '9742', 3, 83),
(1062, 'Xã Long Thượng', '9745', 3, 83),
(1063, 'Xã Hát Môn', '9751', 3, 83),
(1064, 'Xã Thanh Đa', '9757', 3, 83),
(1065, 'Xã Trạch Mỹ Lộc', '9760', 3, 83),
(1066, 'Xã Phúc Hòa', '9763', 3, 83),
(1067, 'Xã Ngọc Tảo', '9766', 3, 83),
(1068, 'Xã Phụng Thượng', '9769', 3, 83),
(1069, 'Xã Tam Thuấn', '9772', 3, 83),
(1070, 'Xã Tam Hiệp', '9775', 3, 83),
(1071, 'Xã Hiệp Thuận', '9778', 3, 83),
(1072, 'Xã Liên Hiệp', '9781', 3, 83);

-- Thành phố Hà Nội > Huyện Đan Phượng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1073, 'Thị trấn Phùng', '9784', 3, 84),
(1074, 'Xã Trung Châu', '9787', 3, 84),
(1075, 'Xã Thọ An', '9790', 3, 84),
(1076, 'Xã Thọ Xuân', '9793', 3, 84),
(1077, 'Xã Hồng Hà', '9796', 3, 84),
(1078, 'Xã Liên Hồng', '9799', 3, 84),
(1079, 'Xã Liên Hà', '9802', 3, 84),
(1080, 'Xã Hạ Mỗ', '9805', 3, 84),
(1081, 'Xã Liên Trung', '9808', 3, 84),
(1082, 'Xã Phương Đình', '9811', 3, 84),
(1083, 'Xã Thượng Mỗ', '9814', 3, 84),
(1084, 'Xã Tân Hội', '9817', 3, 84),
(1085, 'Xã Tân Lập', '9820', 3, 84),
(1086, 'Xã Đan Phượng', '9823', 3, 84),
(1087, 'Xã Đồng Tháp', '9826', 3, 84),
(1088, 'Xã Song Phượng', '9829', 3, 84);

-- Thành phố Hà Nội > Huyện Hoài Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1089, 'Thị trấn Trạm Trôi', '9832', 3, 85),
(1090, 'Xã Đức Thượng', '9835', 3, 85),
(1091, 'Xã Minh Khai', '9838', 3, 85),
(1092, 'Xã Dương Liễu', '9841', 3, 85),
(1093, 'Xã Di Trạch', '9844', 3, 85),
(1094, 'Xã Đức Giang', '9847', 3, 85),
(1095, 'Xã Cát Quế', '9850', 3, 85),
(1096, 'Xã Kim Chung', '9853', 3, 85),
(1097, 'Xã Yên Sở', '9856', 3, 85),
(1098, 'Xã Sơn Đồng', '9859', 3, 85),
(1099, 'Xã Vân Canh', '9862', 3, 85),
(1100, 'Xã Đắc Sở', '9865', 3, 85),
(1101, 'Xã Lại Yên', '9868', 3, 85),
(1102, 'Xã Tiền Yên', '9871', 3, 85),
(1103, 'Xã Song Phương', '9874', 3, 85),
(1104, 'Xã An Khánh', '9877', 3, 85),
(1105, 'Xã An Thượng', '9880', 3, 85),
(1106, 'Xã Vân Côn', '9883', 3, 85),
(1107, 'Xã La Phù', '9889', 3, 85),
(1108, 'Xã Đông La', '9892', 3, 85);

-- Thành phố Hà Nội > Huyện Quốc Oai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1109, 'Xã Đông Xuân', '4939', 3, 86),
(1110, 'Thị trấn Quốc Oai', '9895', 3, 86),
(1111, 'Xã Sài Sơn', '9898', 3, 86),
(1112, 'Xã Phượng Sơn', '9904', 3, 86),
(1113, 'Xã Ngọc Liệp', '9907', 3, 86),
(1114, 'Xã Ngọc Mỹ', '9910', 3, 86),
(1115, 'Xã Thạch Thán', '9916', 3, 86),
(1116, 'Xã Đồng Quang', '9919', 3, 86),
(1117, 'Xã Phú Cát', '9922', 3, 86),
(1118, 'Xã Tuyết Nghĩa', '9925', 3, 86),
(1119, 'Xã Liệp Nghĩa', '9928', 3, 86),
(1120, 'Xã Cộng Hòa', '9931', 3, 86),
(1121, 'Xã Hưng Đạo', '9934', 3, 86),
(1122, 'Xã Phú Mãn', '9940', 3, 86),
(1123, 'Xã Cấn Hữu', '9943', 3, 86),
(1124, 'Xã Hòa Thạch', '9949', 3, 86),
(1125, 'Xã Đông Yên', '9952', 3, 86);

-- Thành phố Hà Nội > Huyện Thạch Thất
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1126, 'Xã Yên Trung', '4927', 3, 87),
(1127, 'Xã Yên Bình', '4930', 3, 87),
(1128, 'Xã Tiến Xuân', '4936', 3, 87),
(1129, 'Thị trấn Liên Quan', '9955', 3, 87),
(1130, 'Xã Đại Đồng', '9958', 3, 87),
(1131, 'Xã Cẩm Yên', '9961', 3, 87),
(1132, 'Xã Lại Thượng', '9964', 3, 87),
(1133, 'Xã Phú Kim', '9967', 3, 87),
(1134, 'Xã Hương Ngải', '9970', 3, 87),
(1135, 'Xã Lam Sơn', '9973', 3, 87),
(1136, 'Xã Kim Quan', '9976', 3, 87),
(1137, 'Xã Bình Yên', '9982', 3, 87),
(1138, 'Xã Thạch Hoà', '9988', 3, 87),
(1139, 'Xã Cần Kiệm', '9991', 3, 87),
(1140, 'Xã Phùng Xá', '9997', 3, 87),
(1141, 'Xã Tân Xã', '10000', 3, 87),
(1142, 'Xã Thạch Xá', '10003', 3, 87),
(1143, 'Xã Quang Trung', '10006', 3, 87),
(1144, 'Xã Hạ Bằng', '10009', 3, 87),
(1145, 'Xã Đồng Trúc', '10012', 3, 87);

-- Thành phố Hà Nội > Huyện Chương Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1146, 'Thị trấn Chúc Sơn', '10015', 3, 88),
(1147, 'Thị trấn Xuân Mai', '10018', 3, 88),
(1148, 'Xã Phụng Châu', '10021', 3, 88),
(1149, 'Xã Tiên Phương', '10024', 3, 88),
(1150, 'Xã Đông Sơn', '10027', 3, 88),
(1151, 'Xã Đông Phương Yên', '10030', 3, 88),
(1152, 'Xã Phú Nghĩa', '10033', 3, 88),
(1153, 'Xã Trường Yên', '10039', 3, 88),
(1154, 'Xã Ngọc Hòa', '10042', 3, 88),
(1155, 'Xã Thủy Xuân Tiên', '10045', 3, 88),
(1156, 'Xã Thanh Bình', '10048', 3, 88),
(1157, 'Xã Trung Hòa', '10051', 3, 88),
(1158, 'Xã Đại Yên', '10054', 3, 88),
(1159, 'Xã Thụy Hương', '10057', 3, 88),
(1160, 'Xã Tốt Động', '10060', 3, 88),
(1161, 'Xã Lam Điền', '10063', 3, 88),
(1162, 'Xã Tân Tiến', '10066', 3, 88),
(1163, 'Xã Nam Phương Tiến', '10069', 3, 88),
(1164, 'Xã Hợp Đồng', '10072', 3, 88),
(1165, 'Xã Hoàng Văn Thụ', '10075', 3, 88),
(1166, 'Xã Hoàng Diệu', '10078', 3, 88),
(1167, 'Xã Hữu Văn', '10081', 3, 88),
(1168, 'Xã Quảng Bị', '10084', 3, 88),
(1169, 'Xã Mỹ Lương', '10087', 3, 88),
(1170, 'Xã Thượng Vực', '10090', 3, 88),
(1171, 'Xã Hồng Phú', '10096', 3, 88),
(1172, 'Xã Trần Phú', '10099', 3, 88),
(1173, 'Xã Văn Võ', '10102', 3, 88),
(1174, 'Xã Đồng Lạc', '10105', 3, 88),
(1175, 'Xã Hòa Phú', '10108', 3, 88);

-- Thành phố Hà Nội > Huyện Thanh Oai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1176, 'Thị trấn Kim Bài', '10114', 3, 89),
(1177, 'Xã Cự Khê', '10120', 3, 89),
(1178, 'Xã Bích Hòa', '10126', 3, 89),
(1179, 'Xã Mỹ Hưng', '10129', 3, 89),
(1180, 'Xã Cao Viên', '10132', 3, 89),
(1181, 'Xã Bình Minh', '10135', 3, 89),
(1182, 'Xã Tam Hưng', '10138', 3, 89),
(1183, 'Xã Thanh Cao', '10141', 3, 89),
(1184, 'Xã Thanh Thùy', '10144', 3, 89),
(1185, 'Xã Thanh Mai', '10147', 3, 89),
(1186, 'Xã Thanh Văn', '10150', 3, 89),
(1187, 'Xã Đỗ Động', '10153', 3, 89),
(1188, 'Xã Kim An', '10156', 3, 89),
(1189, 'Xã Kim Thư', '10159', 3, 89),
(1190, 'Xã Phương Trung', '10162', 3, 89),
(1191, 'Xã Tân Ước', '10165', 3, 89),
(1192, 'Xã Dân Hòa', '10168', 3, 89),
(1193, 'Xã Liên Châu', '10171', 3, 89),
(1194, 'Xã Cao Xuân Dương', '10174', 3, 89),
(1195, 'Xã Hồng Dương', '10180', 3, 89);

-- Thành phố Hà Nội > Huyện Thường Tín
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1196, 'Thị trấn Thường Tín', '10183', 3, 90),
(1197, 'Xã Ninh Sở', '10186', 3, 90),
(1198, 'Xã Nhị Khê', '10189', 3, 90),
(1199, 'Xã Duyên Thái', '10192', 3, 90),
(1200, 'Xã Khánh Hà', '10195', 3, 90),
(1201, 'Xã Hòa Bình', '10198', 3, 90),
(1202, 'Xã Văn Bình', '10201', 3, 90),
(1203, 'Xã Hiền Giang', '10204', 3, 90),
(1204, 'Xã Hồng Vân', '10207', 3, 90),
(1205, 'Xã Vân Tảo', '10210', 3, 90),
(1206, 'Xã Liên Phương', '10213', 3, 90),
(1207, 'Xã Văn Phú', '10216', 3, 90),
(1208, 'Xã Tự Nhiên', '10219', 3, 90),
(1209, 'Xã Tiền Phong', '10222', 3, 90),
(1210, 'Xã Hà Hồi', '10225', 3, 90),
(1211, 'Xã Nguyễn Trãi', '10231', 3, 90),
(1212, 'Xã Quất Động', '10234', 3, 90),
(1213, 'Xã Chương Dương', '10237', 3, 90),
(1214, 'Xã Tân Minh', '10240', 3, 90),
(1215, 'Xã Lê Lợi', '10243', 3, 90),
(1216, 'Xã Thắng Lợi', '10246', 3, 90),
(1217, 'Xã Dũng Tiến', '10249', 3, 90),
(1218, 'Xã Nghiêm Xuyên', '10255', 3, 90),
(1219, 'Xã Tô Hiệu', '10258', 3, 90),
(1220, 'Xã Văn Tự', '10261', 3, 90),
(1221, 'Xã Vạn Nhất', '10264', 3, 90),
(1222, 'Xã Minh Cường', '10267', 3, 90);

-- Thành phố Hà Nội > Huyện Phú Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1223, 'Thị trấn Phú Minh', '10270', 3, 91),
(1224, 'Thị trấn Phú Xuyên', '10273', 3, 91),
(1225, 'Xã Hồng Minh', '10276', 3, 91),
(1226, 'Xã Phượng Dực', '10279', 3, 91),
(1227, 'Xã Nam Tiến', '10282', 3, 91),
(1228, 'Xã Văn Hoàng', '10291', 3, 91),
(1229, 'Xã Phú Túc', '10294', 3, 91),
(1230, 'Xã Hồng Thái', '10300', 3, 91),
(1231, 'Xã Hoàng Long', '10303', 3, 91),
(1232, 'Xã Nam Phong', '10312', 3, 91),
(1233, 'Xã Tân Dân', '10315', 3, 91),
(1234, 'Xã Quang Hà', '10318', 3, 91),
(1235, 'Xã Chuyên Mỹ', '10321', 3, 91),
(1236, 'Xã Khai Thái', '10324', 3, 91),
(1237, 'Xã Phúc Tiến', '10327', 3, 91),
(1238, 'Xã Vân Từ', '10330', 3, 91),
(1239, 'Xã Tri Thủy', '10333', 3, 91),
(1240, 'Xã Đại Xuyên', '10336', 3, 91),
(1241, 'Xã Phú Yên', '10339', 3, 91),
(1242, 'Xã Bạch Hạ', '10342', 3, 91),
(1243, 'Xã Quang Lãng', '10345', 3, 91),
(1244, 'Xã Châu Can', '10348', 3, 91),
(1245, 'Xã Minh Tân', '10351', 3, 91);

-- Thành phố Hà Nội > Huyện Ứng Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1246, 'Thị trấn Vân Đình', '10354', 3, 92),
(1247, 'Xã Hoa Viên', '10363', 3, 92),
(1248, 'Xã Quảng Phú Cầu', '10366', 3, 92),
(1249, 'Xã Trường Thịnh', '10369', 3, 92),
(1250, 'Xã Liên Bạt', '10375', 3, 92),
(1251, 'Xã Cao Sơn Tiến', '10378', 3, 92),
(1252, 'Xã Phương Tú', '10384', 3, 92),
(1253, 'Xã Trung Tú', '10387', 3, 92),
(1254, 'Xã Đồng Tân', '10390', 3, 92),
(1255, 'Xã Tảo Dương Văn', '10393', 3, 92),
(1256, 'Xã Thái Hòa', '10396', 3, 92),
(1257, 'Xã Minh Đức', '10399', 3, 92),
(1258, 'Xã Trầm Lộng', '10402', 3, 92),
(1259, 'Xã Kim Đường', '10411', 3, 92),
(1260, 'Xã Hòa Phú', '10417', 3, 92),
(1261, 'Xã Đại Hùng', '10423', 3, 92),
(1262, 'Xã Đông Lỗ', '10426', 3, 92),
(1263, 'Xã Phù Lưu', '10429', 3, 92),
(1264, 'Xã Đại Cường', '10432', 3, 92),
(1265, 'Xã Bình Lưu Quang', '10435', 3, 92);

-- Thành phố Hà Nội > Huyện Mỹ Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1266, 'Thị trấn Đại Nghĩa', '10441', 3, 93),
(1267, 'Xã Đồng Tâm', '10444', 3, 93),
(1268, 'Xã Thượng Lâm', '10447', 3, 93),
(1269, 'Xã Tuy Lai', '10450', 3, 93),
(1270, 'Xã Phúc Lâm', '10453', 3, 93),
(1271, 'Xã Mỹ Xuyên', '10459', 3, 93),
(1272, 'Xã An Mỹ', '10462', 3, 93),
(1273, 'Xã Hồng Sơn', '10465', 3, 93),
(1274, 'Xã Lê Thanh', '10468', 3, 93),
(1275, 'Xã Xuy Xá', '10471', 3, 93),
(1276, 'Xã Phùng Xá', '10474', 3, 93),
(1277, 'Xã Phù Lưu Tế', '10477', 3, 93),
(1278, 'Xã Đại Hưng', '10480', 3, 93),
(1279, 'Xã Vạn Tín', '10483', 3, 93),
(1280, 'Xã Hương Sơn', '10489', 3, 93),
(1281, 'Xã Hùng Tiến', '10492', 3, 93),
(1282, 'Xã An Tiến', '10495', 3, 93),
(1283, 'Xã Hợp Tiến', '10498', 3, 93),
(1284, 'Xã Hợp Thanh', '10501', 3, 93),
(1285, 'Xã An Phú', '10504', 3, 93);

-- Tỉnh Hà Giang > Thành phố Hà Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1286, 'Phường Quang Trung', '688', 3, 94),
(1287, 'Phường Trần Phú', '691', 3, 94),
(1288, 'Phường Ngọc Hà', '692', 3, 94),
(1289, 'Phường Nguyễn Trãi', '694', 3, 94),
(1290, 'Phường Minh Khai', '697', 3, 94),
(1291, 'Xã Ngọc Đường', '700', 3, 94),
(1292, 'Xã Phương Độ', '946', 3, 94),
(1293, 'Xã Phương Thiện', '949', 3, 94);

-- Tỉnh Hà Giang > Huyện Đồng Văn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1294, 'Thị trấn Phó Bảng', '712', 3, 95),
(1295, 'Xã Lũng Cú', '715', 3, 95),
(1296, 'Xã Má Lé', '718', 3, 95),
(1297, 'Thị trấn Đồng Văn', '721', 3, 95),
(1298, 'Xã Lũng Táo', '724', 3, 95),
(1299, 'Xã Phố Là', '727', 3, 95),
(1300, 'Xã Thài Phìn Tủng', '730', 3, 95),
(1301, 'Xã Sủng Là', '733', 3, 95),
(1302, 'Xã Xà Phìn', '736', 3, 95),
(1303, 'Xã Tả Phìn', '739', 3, 95),
(1304, 'Xã Tả Lủng', '742', 3, 95),
(1305, 'Xã Phố Cáo', '745', 3, 95),
(1306, 'Xã Sính Lủng', '748', 3, 95),
(1307, 'Xã Sảng Tủng', '751', 3, 95),
(1308, 'Xã Lũng Thầu', '754', 3, 95),
(1309, 'Xã Hố Quáng Phìn', '757', 3, 95),
(1310, 'Xã Vần Chải', '760', 3, 95),
(1311, 'Xã Lũng Phìn', '763', 3, 95),
(1312, 'Xã Sủng Trái', '766', 3, 95);

-- Tỉnh Hà Giang > Huyện Mèo Vạc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1313, 'Thị trấn Mèo Vạc', '769', 3, 96),
(1314, 'Xã Thượng Phùng', '772', 3, 96),
(1315, 'Xã Pải Lủng', '775', 3, 96),
(1316, 'Xã Xín Cái', '778', 3, 96),
(1317, 'Xã Pả Vi', '781', 3, 96),
(1318, 'Xã Giàng Chu Phìn', '784', 3, 96),
(1319, 'Xã Sủng Trà', '787', 3, 96),
(1320, 'Xã Sủng Máng', '790', 3, 96),
(1321, 'Xã Sơn Vĩ', '793', 3, 96),
(1322, 'Xã Tả Lủng', '796', 3, 96),
(1323, 'Xã Cán Chu Phìn', '799', 3, 96),
(1324, 'Xã Lũng Pù', '802', 3, 96),
(1325, 'Xã Lũng Chinh', '805', 3, 96),
(1326, 'Xã Tát Ngà', '808', 3, 96),
(1327, 'Xã Nậm Ban', '811', 3, 96),
(1328, 'Xã Khâu Vai', '814', 3, 96),
(1329, 'Xã Niêm Tòng', '815', 3, 96),
(1330, 'Xã Niêm Sơn', '817', 3, 96);

-- Tỉnh Hà Giang > Huyện Yên Minh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1331, 'Thị trấn Yên Minh', '820', 3, 97),
(1332, 'Xã Thắng Mố', '823', 3, 97),
(1333, 'Xã Phú Lũng', '826', 3, 97),
(1334, 'Xã Sủng Tráng', '829', 3, 97),
(1335, 'Xã Bạch Đích', '832', 3, 97),
(1336, 'Xã Na Khê', '835', 3, 97),
(1337, 'Xã Sủng Thài', '838', 3, 97),
(1338, 'Xã Hữu Vinh', '841', 3, 97),
(1339, 'Xã Lao Và Chải', '844', 3, 97),
(1340, 'Xã Mậu Duệ', '847', 3, 97),
(1341, 'Xã Đông Minh', '850', 3, 97),
(1342, 'Xã Mậu Long', '853', 3, 97),
(1343, 'Xã Ngam La', '856', 3, 97),
(1344, 'Xã Ngọc Long', '859', 3, 97),
(1345, 'Xã Đường Thượng', '862', 3, 97),
(1346, 'Xã Lũng Hồ', '865', 3, 97),
(1347, 'Xã Du Tiến', '868', 3, 97),
(1348, 'Xã Du Già', '871', 3, 97);

-- Tỉnh Hà Giang > Huyện Quản Bạ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1349, 'Thị trấn Tam Sơn', '874', 3, 98),
(1350, 'Xã Bát Đại Sơn', '877', 3, 98),
(1351, 'Xã Nghĩa Thuận', '880', 3, 98),
(1352, 'Xã Cán Tỷ', '883', 3, 98),
(1353, 'Xã Cao Mã Pờ', '886', 3, 98),
(1354, 'Xã Thanh Vân', '889', 3, 98),
(1355, 'Xã Tùng Vài', '892', 3, 98),
(1356, 'Xã Đông Hà', '895', 3, 98),
(1357, 'Xã Quản Bạ', '898', 3, 98),
(1358, 'Xã Lùng Tám', '901', 3, 98),
(1359, 'Xã Quyết Tiến', '904', 3, 98),
(1360, 'Xã Tả Ván', '907', 3, 98),
(1361, 'Xã Thái An', '910', 3, 98);

-- Tỉnh Hà Giang > Huyện Vị Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1362, 'Xã Kim Thạch', '703', 3, 99),
(1363, 'Xã Phú Linh', '706', 3, 99),
(1364, 'Xã Kim Linh', '709', 3, 99),
(1365, 'Thị trấn Vị Xuyên', '913', 3, 99),
(1366, 'Thị trấn Nông Trường Việt Lâm', '916', 3, 99),
(1367, 'Xã Minh Tân', '919', 3, 99),
(1368, 'Xã Thuận Hoà', '922', 3, 99),
(1369, 'Xã Tùng Bá', '925', 3, 99),
(1370, 'Xã Thanh Thủy', '928', 3, 99),
(1371, 'Xã Thanh Đức', '931', 3, 99),
(1372, 'Xã Phong Quang', '934', 3, 99),
(1373, 'Xã Xín Chải', '937', 3, 99),
(1374, 'Xã Phương Tiến', '940', 3, 99),
(1375, 'Xã Lao Chải', '943', 3, 99),
(1376, 'Xã Cao Bồ', '952', 3, 99),
(1377, 'Xã Đạo Đức', '955', 3, 99),
(1378, 'Xã Thượng Sơn', '958', 3, 99),
(1379, 'Xã Linh Hồ', '961', 3, 99),
(1380, 'Xã Quảng Ngần', '964', 3, 99),
(1381, 'Xã Việt Lâm', '967', 3, 99),
(1382, 'Xã Ngọc Linh', '970', 3, 99),
(1383, 'Xã Ngọc Minh', '973', 3, 99),
(1384, 'Xã Bạch Ngọc', '976', 3, 99),
(1385, 'Xã Trung Thành', '979', 3, 99);

-- Tỉnh Hà Giang > Huyện Bắc Mê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1386, 'Xã Minh Sơn', '982', 3, 100),
(1387, 'Xã Giáp Trung', '985', 3, 100),
(1388, 'Xã Yên Định', '988', 3, 100),
(1389, 'Thị trấn Yên Phú', '991', 3, 100),
(1390, 'Xã Minh Ngọc', '994', 3, 100),
(1391, 'Xã Yên Phong', '997', 3, 100),
(1392, 'Xã Lạc Nông', '1000', 3, 100),
(1393, 'Xã Phú Nam', '1003', 3, 100),
(1394, 'Xã Yên Cường', '1006', 3, 100),
(1395, 'Xã Thượng Tân', '1009', 3, 100),
(1396, 'Xã Đường Âm', '1012', 3, 100),
(1397, 'Xã Đường Hồng', '1015', 3, 100),
(1398, 'Xã Phiêng Luông', '1018', 3, 100);

-- Tỉnh Hà Giang > Huyện Hoàng Su Phì
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1399, 'Thị trấn Vinh Quang', '1021', 3, 101),
(1400, 'Xã Bản Máy', '1024', 3, 101),
(1401, 'Xã Thàng Tín', '1027', 3, 101),
(1402, 'Xã Thèn Chu Phìn', '1030', 3, 101),
(1403, 'Xã Pố Lồ', '1033', 3, 101),
(1404, 'Xã Bản Phùng', '1036', 3, 101),
(1405, 'Xã Túng Sán', '1039', 3, 101),
(1406, 'Xã Chiến Phố', '1042', 3, 101),
(1407, 'Xã Đản Ván', '1045', 3, 101),
(1408, 'Xã Tụ Nhân', '1048', 3, 101),
(1409, 'Xã Tân Tiến', '1051', 3, 101),
(1410, 'Xã Nàng Đôn', '1054', 3, 101),
(1411, 'Xã Pờ Ly Ngài', '1057', 3, 101),
(1412, 'Xã Sán Xả Hồ', '1060', 3, 101),
(1413, 'Xã Bản Luốc', '1063', 3, 101),
(1414, 'Xã Ngàm Đăng Vài', '1066', 3, 101),
(1415, 'Xã Bản Nhùng', '1069', 3, 101),
(1416, 'Xã Tả Sử Choóng', '1072', 3, 101),
(1417, 'Xã Nậm Dịch', '1075', 3, 101),
(1418, 'Xã Hồ Thầu', '1081', 3, 101),
(1419, 'Xã Nam Sơn', '1084', 3, 101),
(1420, 'Xã Nậm Tỵ', '1087', 3, 101),
(1421, 'Xã Thông Nguyên', '1090', 3, 101),
(1422, 'Xã Nậm Khòa', '1093', 3, 101);

-- Tỉnh Hà Giang > Huyện Xín Mần
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1423, 'Thị trấn Cốc Pài', '1096', 3, 102),
(1424, 'Xã Nàn Xỉn', '1099', 3, 102),
(1425, 'Xã Bản Díu', '1102', 3, 102),
(1426, 'Xã Chí Cà', '1105', 3, 102),
(1427, 'Xã Xín Mần', '1108', 3, 102),
(1428, 'Xã Thèn Phàng', '1114', 3, 102),
(1429, 'Xã Trung Thịnh', '1117', 3, 102),
(1430, 'Xã Pà Vầy Sủ', '1120', 3, 102),
(1431, 'Xã Cốc Rế', '1123', 3, 102),
(1432, 'Xã Thu Tà', '1126', 3, 102),
(1433, 'Xã Nàn Ma', '1129', 3, 102),
(1434, 'Xã Tả Nhìu', '1132', 3, 102),
(1435, 'Xã Bản Ngò', '1135', 3, 102),
(1436, 'Xã Chế Là', '1138', 3, 102),
(1437, 'Xã Nấm Dẩn', '1141', 3, 102),
(1438, 'Xã Quảng Nguyên', '1144', 3, 102),
(1439, 'Xã Nà Chì', '1147', 3, 102),
(1440, 'Xã Khuôn Lùng', '1150', 3, 102);

-- Tỉnh Hà Giang > Huyện Bắc Quang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1441, 'Thị trấn Việt Quang', '1153', 3, 103),
(1442, 'Thị trấn Vĩnh Tuy', '1156', 3, 103),
(1443, 'Xã Tân Lập', '1159', 3, 103),
(1444, 'Xã Tân Thành', '1162', 3, 103),
(1445, 'Xã Đồng Tiến', '1165', 3, 103),
(1446, 'Xã Đồng Tâm', '1168', 3, 103),
(1447, 'Xã Tân Quang', '1171', 3, 103),
(1448, 'Xã Thượng Bình', '1174', 3, 103),
(1449, 'Xã Hữu Sản', '1177', 3, 103),
(1450, 'Xã Kim Ngọc', '1180', 3, 103),
(1451, 'Xã Việt Vinh', '1183', 3, 103),
(1452, 'Xã Bằng Hành', '1186', 3, 103),
(1453, 'Xã Quang Minh', '1189', 3, 103),
(1454, 'Xã Liên Hiệp', '1192', 3, 103),
(1455, 'Xã Vô Điếm', '1195', 3, 103),
(1456, 'Xã Việt Hồng', '1198', 3, 103),
(1457, 'Xã Hùng An', '1201', 3, 103),
(1458, 'Xã Đức Xuân', '1204', 3, 103),
(1459, 'Xã Tiên Kiều', '1207', 3, 103),
(1460, 'Xã Vĩnh Hảo', '1210', 3, 103),
(1461, 'Xã Vĩnh Phúc', '1213', 3, 103),
(1462, 'Xã Đồng Yên', '1216', 3, 103),
(1463, 'Xã Đông Thành', '1219', 3, 103);

-- Tỉnh Hà Giang > Huyện Quang Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1464, 'Xã Xuân Minh', '1222', 3, 104),
(1465, 'Xã Tiên Nguyên', '1225', 3, 104),
(1466, 'Xã Tân Nam', '1228', 3, 104),
(1467, 'Xã Bản Rịa', '1231', 3, 104),
(1468, 'Xã Yên Thành', '1234', 3, 104),
(1469, 'Thị trấn Yên Bình', '1237', 3, 104),
(1470, 'Xã Tân Trịnh', '1240', 3, 104),
(1471, 'Xã Tân Bắc', '1243', 3, 104),
(1472, 'Xã Bằng Lang', '1246', 3, 104),
(1473, 'Xã Yên Hà', '1249', 3, 104),
(1474, 'Xã Hương Sơn', '1252', 3, 104),
(1475, 'Xã Xuân Giang', '1255', 3, 104),
(1476, 'Xã Nà Khương', '1258', 3, 104),
(1477, 'Xã Tiên Yên', '1261', 3, 104),
(1478, 'Xã Vĩ Thượng', '1264', 3, 104);

-- Tỉnh Cao Bằng > Thành phố Cao Bằng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1479, 'Phường Sông Hiến', '1267', 3, 105),
(1480, 'Phường Sông Bằng', '1270', 3, 105),
(1481, 'Phường Hợp Giang', '1273', 3, 105),
(1482, 'Phường Tân Giang', '1276', 3, 105),
(1483, 'Phường Ngọc Xuân', '1279', 3, 105),
(1484, 'Phường Đề Thám', '1282', 3, 105),
(1485, 'Phường Hoà Chung', '1285', 3, 105),
(1486, 'Phường Duyệt Trung', '1288', 3, 105),
(1487, 'Xã Vĩnh Quang', '1693', 3, 105),
(1488, 'Xã Hưng Đạo', '1705', 3, 105),
(1489, 'Xã Chu Trinh', '1720', 3, 105);

-- Tỉnh Cao Bằng > Huyện Bảo Lâm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1490, 'Thị trấn Pác Miầu', '1290', 3, 106),
(1491, 'Xã Đức Hạnh', '1291', 3, 106),
(1492, 'Xã Lý Bôn', '1294', 3, 106),
(1493, 'Xã Nam Cao', '1296', 3, 106),
(1494, 'Xã Nam Quang', '1297', 3, 106),
(1495, 'Xã Vĩnh Quang', '1300', 3, 106),
(1496, 'Xã Quảng Lâm', '1303', 3, 106),
(1497, 'Xã Thạch Lâm', '1304', 3, 106),
(1498, 'Xã Vĩnh Phong', '1309', 3, 106),
(1499, 'Xã Mông Ân', '1312', 3, 106),
(1500, 'Xã Thái Học', '1315', 3, 106),
(1501, 'Xã Thái Sơn', '1316', 3, 106),
(1502, 'Xã Yên Thổ', '1318', 3, 106);

-- Tỉnh Cao Bằng > Huyện Bảo Lạc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1503, 'Thị trấn Bảo Lạc', '1321', 3, 107),
(1504, 'Xã Cốc Pàng', '1324', 3, 107),
(1505, 'Xã Thượng Hà', '1327', 3, 107),
(1506, 'Xã Cô Ba', '1330', 3, 107),
(1507, 'Xã Bảo Toàn', '1333', 3, 107),
(1508, 'Xã Khánh Xuân', '1336', 3, 107),
(1509, 'Xã Xuân Trường', '1339', 3, 107),
(1510, 'Xã Hồng Trị', '1342', 3, 107),
(1511, 'Xã Kim Cúc', '1343', 3, 107),
(1512, 'Xã Phan Thanh', '1345', 3, 107),
(1513, 'Xã Hồng An', '1348', 3, 107),
(1514, 'Xã Hưng Đạo', '1351', 3, 107),
(1515, 'Xã Hưng Thịnh', '1352', 3, 107),
(1516, 'Xã Huy Giáp', '1354', 3, 107),
(1517, 'Xã Đình Phùng', '1357', 3, 107),
(1518, 'Xã Sơn Lập', '1359', 3, 107),
(1519, 'Xã Sơn Lộ', '1360', 3, 107);

-- Tỉnh Cao Bằng > Huyện Hà Quảng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1520, 'Thị trấn Thông Nông', '1363', 3, 108),
(1521, 'Xã Cần Yên', '1366', 3, 108),
(1522, 'Xã Cần Nông', '1367', 3, 108),
(1523, 'Xã Lương Thông', '1372', 3, 108),
(1524, 'Xã Đa Thông', '1375', 3, 108),
(1525, 'Xã Ngọc Động', '1378', 3, 108),
(1526, 'Xã Yên Sơn', '1381', 3, 108),
(1527, 'Xã Lương Can', '1384', 3, 108),
(1528, 'Xã Thanh Long', '1387', 3, 108),
(1529, 'Thị trấn Xuân Hòa', '1392', 3, 108),
(1530, 'Xã Lũng Nặm', '1393', 3, 108),
(1531, 'Xã Trường Hà', '1399', 3, 108),
(1532, 'Xã Cải Viên', '1402', 3, 108),
(1533, 'Xã Nội Thôn', '1411', 3, 108),
(1534, 'Xã Tổng Cọt', '1414', 3, 108),
(1535, 'Xã Sóc Hà', '1417', 3, 108),
(1536, 'Xã Thượng Thôn', '1420', 3, 108),
(1537, 'Xã Hồng Sỹ', '1429', 3, 108),
(1538, 'Xã Quý Quân', '1432', 3, 108),
(1539, 'Xã Mã Ba', '1435', 3, 108),
(1540, 'Xã Ngọc Đào', '1438', 3, 108);

-- Tỉnh Cao Bằng > Huyện Trùng Khánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1541, 'Thị trấn Trà Lĩnh', '1447', 3, 109),
(1542, 'Xã Tri Phương', '1453', 3, 109),
(1543, 'Xã Quang Hán', '1456', 3, 109),
(1544, 'Xã Xuân Nội', '1462', 3, 109),
(1545, 'Xã Quang Trung', '1465', 3, 109),
(1546, 'Xã Quang Vinh', '1468', 3, 109),
(1547, 'Xã Cao Chương', '1471', 3, 109),
(1548, 'Thị trấn Trùng Khánh', '1477', 3, 109),
(1549, 'Xã Ngọc Khê', '1480', 3, 109),
(1550, 'Xã Ngọc Côn', '1481', 3, 109),
(1551, 'Xã Phong Nậm', '1483', 3, 109),
(1552, 'Xã Đình Phong', '1489', 3, 109),
(1553, 'Xã Đàm Thuỷ', '1495', 3, 109),
(1554, 'Xã Khâm Thành', '1498', 3, 109),
(1555, 'Xã Chí Viễn', '1501', 3, 109),
(1556, 'Xã Lăng Hiếu', '1504', 3, 109),
(1557, 'Xã Phong Châu', '1507', 3, 109),
(1558, 'Xã Trung Phúc', '1516', 3, 109),
(1559, 'Xã Cao Thăng', '1519', 3, 109),
(1560, 'Xã Đức Hồng', '1522', 3, 109),
(1561, 'Xã Đoài Dương', '1525', 3, 109);

-- Tỉnh Cao Bằng > Huyện Hạ Lang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1562, 'Xã Minh Long', '1534', 3, 110),
(1563, 'Xã Lý Quốc', '1537', 3, 110),
(1564, 'Xã Thắng Lợi', '1540', 3, 110),
(1565, 'Xã Đồng Loan', '1543', 3, 110),
(1566, 'Xã Đức Quang', '1546', 3, 110),
(1567, 'Xã Kim Loan', '1549', 3, 110),
(1568, 'Xã Quang Long', '1552', 3, 110),
(1569, 'Xã An Lạc', '1555', 3, 110),
(1570, 'Thị trấn Thanh Nhật', '1558', 3, 110),
(1571, 'Xã Vinh Quý', '1561', 3, 110),
(1572, 'Xã Thống Nhất', '1564', 3, 110),
(1573, 'Xã Cô Ngân', '1567', 3, 110),
(1574, 'Xã Thị Hoa', '1573', 3, 110);

-- Tỉnh Cao Bằng > Huyện Quảng Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1575, 'Xã Quốc Toản', '1474', 3, 111),
(1576, 'Thị trấn Quảng Uyên', '1576', 3, 111),
(1577, 'Xã Phi Hải', '1579', 3, 111),
(1578, 'Xã Quảng Hưng', '1582', 3, 111),
(1579, 'Xã Độc Lập', '1594', 3, 111),
(1580, 'Xã Cai Bộ', '1597', 3, 111),
(1581, 'Xã Phúc Sen', '1603', 3, 111),
(1582, 'Xã Chí Thảo', '1606', 3, 111),
(1583, 'Xã Tự Do', '1609', 3, 111),
(1584, 'Xã Hồng Quang', '1615', 3, 111),
(1585, 'Xã Ngọc Động', '1618', 3, 111),
(1586, 'Xã Hạnh Phúc', '1624', 3, 111),
(1587, 'Thị trấn Tà Lùng', '1627', 3, 111),
(1588, 'Xã Bế Văn Đàn', '1630', 3, 111),
(1589, 'Xã Cách Linh', '1636', 3, 111),
(1590, 'Xã Đại Sơn', '1639', 3, 111),
(1591, 'Xã Tiên Thành', '1645', 3, 111),
(1592, 'Thị trấn Hoà Thuận', '1648', 3, 111),
(1593, 'Xã Mỹ Hưng', '1651', 3, 111);

-- Tỉnh Cao Bằng > Huyện Hoà An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1594, 'Thị trấn Nước Hai', '1654', 3, 112),
(1595, 'Xã Dân Chủ', '1657', 3, 112),
(1596, 'Xã Nam Tuấn', '1660', 3, 112),
(1597, 'Xã Đại Tiến', '1666', 3, 112),
(1598, 'Xã Đức Long', '1669', 3, 112),
(1599, 'Xã Ngũ Lão', '1672', 3, 112),
(1600, 'Xã Trương Lương', '1675', 3, 112),
(1601, 'Xã Hồng Việt', '1687', 3, 112),
(1602, 'Xã Hoàng Tung', '1696', 3, 112),
(1603, 'Xã Nguyễn Huệ', '1699', 3, 112),
(1604, 'Xã Quang Trung', '1702', 3, 112),
(1605, 'Xã Bạch Đằng', '1708', 3, 112),
(1606, 'Xã Bình Dương', '1711', 3, 112),
(1607, 'Xã Lê Chung', '1714', 3, 112),
(1608, 'Xã Hồng Nam', '1723', 3, 112);

-- Tỉnh Cao Bằng > Huyện Nguyên Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1609, 'Thị trấn Nguyên Bình', '1726', 3, 113),
(1610, 'Thị trấn Tĩnh Túc', '1729', 3, 113),
(1611, 'Xã Yên Lạc', '1732', 3, 113),
(1612, 'Xã Triệu Nguyên', '1735', 3, 113),
(1613, 'Xã Ca Thành', '1738', 3, 113),
(1614, 'Xã Vũ Nông', '1744', 3, 113),
(1615, 'Xã Minh Tâm', '1747', 3, 113),
(1616, 'Xã Thể Dục', '1750', 3, 113),
(1617, 'Xã Mai Long', '1756', 3, 113),
(1618, 'Xã Vũ Minh', '1762', 3, 113),
(1619, 'Xã Hoa Thám', '1765', 3, 113),
(1620, 'Xã Phan Thanh', '1768', 3, 113),
(1621, 'Xã Quang Thành', '1771', 3, 113),
(1622, 'Xã Tam Kim', '1774', 3, 113),
(1623, 'Xã Thành Công', '1777', 3, 113),
(1624, 'Xã Thịnh Vượng', '1780', 3, 113),
(1625, 'Xã Hưng Đạo', '1783', 3, 113);

-- Tỉnh Cao Bằng > Huyện Thạch An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1626, 'Thị trấn Đông Khê', '1786', 3, 114),
(1627, 'Xã Canh Tân', '1789', 3, 114),
(1628, 'Xã Kim Đồng', '1792', 3, 114),
(1629, 'Xã Minh Khai', '1795', 3, 114),
(1630, 'Xã Đức Thông', '1801', 3, 114),
(1631, 'Xã Thái Cường', '1804', 3, 114),
(1632, 'Xã Vân Trình', '1807', 3, 114),
(1633, 'Xã Thụy Hùng', '1810', 3, 114),
(1634, 'Xã Quang Trọng', '1813', 3, 114),
(1635, 'Xã Trọng Con', '1816', 3, 114),
(1636, 'Xã Lê Lai', '1819', 3, 114),
(1637, 'Xã Đức Long', '1822', 3, 114),
(1638, 'Xã Lê Lợi', '1828', 3, 114),
(1639, 'Xã Đức Xuân', '1831', 3, 114);

-- Tỉnh Bắc Kạn > Thành Phố Bắc Kạn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1640, 'Phường Nguyễn Thị Minh Khai', '1834', 3, 115),
(1641, 'Phường Sông Cầu', '1837', 3, 115),
(1642, 'Phường Đức Xuân', '1840', 3, 115),
(1643, 'Phường Phùng Chí Kiên', '1843', 3, 115),
(1644, 'Phường Huyền Tụng', '1846', 3, 115),
(1645, 'Xã Dương Quang', '1849', 3, 115),
(1646, 'Xã Nông Thượng', '1852', 3, 115),
(1647, 'Phường Xuất Hóa', '1855', 3, 115);

-- Tỉnh Bắc Kạn > Huyện Pác Nặm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1648, 'Xã Bằng Thành', '1858', 3, 116),
(1649, 'Xã Nhạn Môn', '1861', 3, 116),
(1650, 'Xã Bộc Bố', '1864', 3, 116),
(1651, 'Xã Công Bằng', '1867', 3, 116),
(1652, 'Xã Giáo Hiệu', '1870', 3, 116),
(1653, 'Xã Xuân La', '1873', 3, 116),
(1654, 'Xã An Thắng', '1876', 3, 116),
(1655, 'Xã Cổ Linh', '1879', 3, 116),
(1656, 'Xã Nghiên Loan', '1882', 3, 116),
(1657, 'Xã Cao Tân', '1885', 3, 116);

-- Tỉnh Bắc Kạn > Huyện Ba Bể
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1658, 'Thị trấn Chợ Rã', '1888', 3, 117),
(1659, 'Xã Bành Trạch', '1891', 3, 117),
(1660, 'Xã Phúc Lộc', '1894', 3, 117),
(1661, 'Xã Hà Hiệu', '1897', 3, 117),
(1662, 'Xã Cao Thượng', '1900', 3, 117),
(1663, 'Xã Khang Ninh', '1906', 3, 117),
(1664, 'Xã Nam Mẫu', '1909', 3, 117),
(1665, 'Xã Thượng Giáo', '1912', 3, 117),
(1666, 'Xã Địa Linh', '1915', 3, 117),
(1667, 'Xã Yến Dương', '1918', 3, 117),
(1668, 'Xã Chu Hương', '1921', 3, 117),
(1669, 'Xã Quảng Khê', '1924', 3, 117),
(1670, 'Xã Mỹ Phương', '1927', 3, 117),
(1671, 'Xã Hoàng Trĩ', '1930', 3, 117),
(1672, 'Xã Đồng Phúc', '1933', 3, 117);

-- Tỉnh Bắc Kạn > Huyện Ngân Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1673, 'Thị trấn Nà Phặc', '1936', 3, 118),
(1674, 'Xã Thượng Ân', '1939', 3, 118),
(1675, 'Xã Bằng Vân', '1942', 3, 118),
(1676, 'Xã Cốc Đán', '1945', 3, 118),
(1677, 'Xã Trung Hoà', '1948', 3, 118),
(1678, 'Xã Đức Vân', '1951', 3, 118),
(1679, 'Thị trấn Vân Tùng', '1954', 3, 118),
(1680, 'Xã Thượng Quan', '1957', 3, 118),
(1681, 'Xã Hiệp Lực', '1960', 3, 118),
(1682, 'Xã Thuần Mang', '1963', 3, 118);

-- Tỉnh Bắc Kạn > Huyện Bạch Thông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1683, 'Thị trấn Phủ Thông', '1969', 3, 119),
(1684, 'Xã Vi Hương', '1975', 3, 119),
(1685, 'Xã Sĩ Bình', '1978', 3, 119),
(1686, 'Xã Vũ Muộn', '1981', 3, 119),
(1687, 'Xã Đôn Phong', '1984', 3, 119),
(1688, 'Xã Lục Bình', '1990', 3, 119),
(1689, 'Xã Tân Tú', '1993', 3, 119),
(1690, 'Xã Nguyên Phúc', '1999', 3, 119),
(1691, 'Xã Cao Sơn', '2002', 3, 119),
(1692, 'Xã Quân Hà', '2005', 3, 119),
(1693, 'Xã Cẩm Giàng', '2008', 3, 119),
(1694, 'Xã Mỹ Thanh', '2011', 3, 119),
(1695, 'Xã Dương Phong', '2014', 3, 119),
(1696, 'Xã Quang Thuận', '2017', 3, 119);

-- Tỉnh Bắc Kạn > Huyện Chợ Đồn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1697, 'Thị trấn Bằng Lũng', '2020', 3, 120),
(1698, 'Xã Xuân Lạc', '2023', 3, 120),
(1699, 'Xã Nam Cường', '2026', 3, 120),
(1700, 'Xã Đồng Lạc', '2029', 3, 120),
(1701, 'Xã Tân Lập', '2032', 3, 120),
(1702, 'Xã Bản Thi', '2035', 3, 120),
(1703, 'Xã Quảng Bạch', '2038', 3, 120),
(1704, 'Xã Bằng Phúc', '2041', 3, 120),
(1705, 'Xã Yên Thịnh', '2044', 3, 120),
(1706, 'Xã Yên Thượng', '2047', 3, 120),
(1707, 'Xã Phương Viên', '2050', 3, 120),
(1708, 'Xã Ngọc Phái', '2053', 3, 120),
(1709, 'Xã Đồng Thắng', '2059', 3, 120),
(1710, 'Xã Lương Bằng', '2062', 3, 120),
(1711, 'Xã Bằng Lãng', '2065', 3, 120),
(1712, 'Xã Đại Sảo', '2068', 3, 120),
(1713, 'Xã Nghĩa Tá', '2071', 3, 120),
(1714, 'Xã Yên Mỹ', '2077', 3, 120),
(1715, 'Xã Bình Trung', '2080', 3, 120),
(1716, 'Xã Yên Phong', '2083', 3, 120);

-- Tỉnh Bắc Kạn > Huyện Chợ Mới
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1717, 'Thị trấn Đồng Tâm', '2086', 3, 121),
(1718, 'Xã Tân Sơn', '2089', 3, 121),
(1719, 'Xã Thanh Vận', '2092', 3, 121),
(1720, 'Xã Mai Lạp', '2095', 3, 121),
(1721, 'Xã Hoà Mục', '2098', 3, 121),
(1722, 'Xã Thanh Mai', '2101', 3, 121),
(1723, 'Xã Cao Kỳ', '2104', 3, 121),
(1724, 'Xã Nông Hạ', '2107', 3, 121),
(1725, 'Xã Yên Cư', '2110', 3, 121),
(1726, 'Xã Thanh Thịnh', '2113', 3, 121),
(1727, 'Xã Yên Hân', '2116', 3, 121),
(1728, 'Xã Như Cố', '2122', 3, 121),
(1729, 'Xã Bình Văn', '2125', 3, 121),
(1730, 'Xã Quảng Chu', '2131', 3, 121);

-- Tỉnh Bắc Kạn > Huyện Na Rì
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1731, 'Xã Văn Vũ', '2137', 3, 122),
(1732, 'Xã Văn Lang', '2140', 3, 122),
(1733, 'Xã Lương Thượng', '2143', 3, 122),
(1734, 'Xã Kim Hỷ', '2146', 3, 122),
(1735, 'Xã Cường Lợi', '2152', 3, 122),
(1736, 'Thị trấn Yến Lạc', '2155', 3, 122),
(1737, 'Xã Kim Lư', '2158', 3, 122),
(1738, 'Xã Sơn Thành', '2161', 3, 122),
(1739, 'Xã Văn Minh', '2170', 3, 122),
(1740, 'Xã Côn Minh', '2173', 3, 122),
(1741, 'Xã Cư Lễ', '2176', 3, 122),
(1742, 'Xã Trần Phú', '2179', 3, 122),
(1743, 'Xã Quang Phong', '2185', 3, 122),
(1744, 'Xã Dương Sơn', '2188', 3, 122),
(1745, 'Xã Xuân Dương', '2191', 3, 122),
(1746, 'Xã Đổng Xá', '2194', 3, 122),
(1747, 'Xã Liêm Thuỷ', '2197', 3, 122);

-- Tỉnh Tuyên Quang > Thành phố Tuyên Quang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1748, 'Phường Phan Thiết', '2200', 3, 123),
(1749, 'Phường Minh Xuân', '2203', 3, 123),
(1750, 'Phường Tân Quang', '2206', 3, 123),
(1751, 'Xã Tràng Đà', '2209', 3, 123),
(1752, 'Phường Nông Tiến', '2212', 3, 123),
(1753, 'Phường Ỷ La', '2215', 3, 123),
(1754, 'Phường Tân Hà', '2216', 3, 123),
(1755, 'Phường Hưng Thành', '2218', 3, 123),
(1756, 'Xã Kim Phú', '2497', 3, 123),
(1757, 'Xã An Khang', '2503', 3, 123),
(1758, 'Phường Mỹ Lâm', '2509', 3, 123),
(1759, 'Phường An Tường', '2512', 3, 123),
(1760, 'Xã Lưỡng Vượng', '2515', 3, 123),
(1761, 'Xã Thái Long', '2521', 3, 123),
(1762, 'Phường Đội Cấn', '2524', 3, 123);

-- Tỉnh Tuyên Quang > Huyện Lâm Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1763, 'Xã Phúc Yên', '2233', 3, 124),
(1764, 'Xã Xuân Lập', '2242', 3, 124),
(1765, 'Xã Khuôn Hà', '2251', 3, 124),
(1766, 'Thị trấn Lăng Can', '2266', 3, 124),
(1767, 'Xã Thượng Lâm', '2269', 3, 124),
(1768, 'Xã Bình An', '2290', 3, 124),
(1769, 'Xã Hồng Quang', '2293', 3, 124),
(1770, 'Xã Thổ Bình', '2296', 3, 124),
(1771, 'Xã Phúc Sơn', '2299', 3, 124),
(1772, 'Xã Minh Quang', '2302', 3, 124);

-- Tỉnh Tuyên Quang > Huyện Na Hang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1773, 'Thị trấn Na Hang', '2221', 3, 125),
(1774, 'Xã Sinh Long', '2227', 3, 125),
(1775, 'Xã Thượng Giáp', '2230', 3, 125),
(1776, 'Xã Thượng Nông', '2239', 3, 125),
(1777, 'Xã Côn Lôn', '2245', 3, 125),
(1778, 'Xã Yên Hoa', '2248', 3, 125),
(1779, 'Xã Hồng Thái', '2254', 3, 125),
(1780, 'Xã Đà Vị', '2260', 3, 125),
(1781, 'Xã Khau Tinh', '2263', 3, 125),
(1782, 'Xã Sơn Phú', '2275', 3, 125),
(1783, 'Xã Năng Khả', '2281', 3, 125),
(1784, 'Xã Thanh Tương', '2284', 3, 125);

-- Tỉnh Tuyên Quang > Huyện Chiêm Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1785, 'Thị trấn Vĩnh Lộc', '2287', 3, 126),
(1786, 'Xã Trung Hà', '2305', 3, 126),
(1787, 'Xã Tân Mỹ', '2308', 3, 126),
(1788, 'Xã Hà Lang', '2311', 3, 126),
(1789, 'Xã Hùng Mỹ', '2314', 3, 126),
(1790, 'Xã Yên Lập', '2317', 3, 126),
(1791, 'Xã Tân An', '2320', 3, 126),
(1792, 'Xã Bình Phú', '2323', 3, 126),
(1793, 'Xã Xuân Quang', '2326', 3, 126),
(1794, 'Xã Ngọc Hội', '2329', 3, 126),
(1795, 'Xã Phú Bình', '2332', 3, 126),
(1796, 'Xã Hòa Phú', '2335', 3, 126),
(1797, 'Xã Phúc Thịnh', '2338', 3, 126),
(1798, 'Xã Kiên Đài', '2341', 3, 126),
(1799, 'Xã Tân Thịnh', '2344', 3, 126),
(1800, 'Xã Trung Hòa', '2347', 3, 126),
(1801, 'Xã Kim Bình', '2350', 3, 126),
(1802, 'Xã Hòa An', '2353', 3, 126),
(1803, 'Xã Vinh Quang', '2356', 3, 126),
(1804, 'Xã Tri Phú', '2359', 3, 126),
(1805, 'Xã Nhân Lý', '2362', 3, 126),
(1806, 'Xã Yên Nguyên', '2365', 3, 126),
(1807, 'Xã Linh Phú', '2368', 3, 126),
(1808, 'Xã Bình Nhân', '2371', 3, 126);

-- Tỉnh Tuyên Quang > Huyện Hàm Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1809, 'Thị trấn Tân Yên', '2374', 3, 127),
(1810, 'Xã Yên Thuận', '2377', 3, 127),
(1811, 'Xã Bạch Xa', '2380', 3, 127),
(1812, 'Xã Minh Khương', '2383', 3, 127),
(1813, 'Xã Yên Lâm', '2386', 3, 127),
(1814, 'Xã Minh Dân', '2389', 3, 127),
(1815, 'Xã Phù Lưu', '2392', 3, 127),
(1816, 'Xã Minh Hương', '2395', 3, 127),
(1817, 'Xã Yên Phú', '2398', 3, 127),
(1818, 'Xã Tân Thành', '2401', 3, 127),
(1819, 'Xã Bình Xa', '2404', 3, 127),
(1820, 'Xã Thái Sơn', '2407', 3, 127),
(1821, 'Xã Nhân Mục', '2410', 3, 127),
(1822, 'Xã Thành Long', '2413', 3, 127),
(1823, 'Xã Bằng Cốc', '2416', 3, 127),
(1824, 'Xã Thái Hòa', '2419', 3, 127),
(1825, 'Xã Đức Ninh', '2422', 3, 127),
(1826, 'Xã Hùng Đức', '2425', 3, 127);

-- Tỉnh Tuyên Quang > Huyện Yên Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1827, 'Xã Quí Quân', '2431', 3, 128),
(1828, 'Xã Lực Hành', '2434', 3, 128),
(1829, 'Xã Kiến Thiết', '2437', 3, 128),
(1830, 'Xã Trung Minh', '2440', 3, 128),
(1831, 'Xã Chiêu Yên', '2443', 3, 128),
(1832, 'Xã Trung Trực', '2446', 3, 128),
(1833, 'Xã Xuân Vân', '2449', 3, 128),
(1834, 'Xã Phúc Ninh', '2452', 3, 128),
(1835, 'Xã Hùng Lợi', '2455', 3, 128),
(1836, 'Xã Trung Sơn', '2458', 3, 128),
(1837, 'Xã Tân Tiến', '2461', 3, 128),
(1838, 'Xã Tứ Quận', '2464', 3, 128),
(1839, 'Xã Đạo Viện', '2467', 3, 128),
(1840, 'Xã Tân Long', '2470', 3, 128),
(1841, 'Thị trấn Yên Sơn', '2473', 3, 128),
(1842, 'Xã Kim Quan', '2476', 3, 128),
(1843, 'Xã Lang Quán', '2479', 3, 128),
(1844, 'Xã Phú Thịnh', '2482', 3, 128),
(1845, 'Xã Công Đa', '2485', 3, 128),
(1846, 'Xã Trung Môn', '2488', 3, 128),
(1847, 'Xã Chân Sơn', '2491', 3, 128),
(1848, 'Xã Thái Bình', '2494', 3, 128),
(1849, 'Xã Tiến Bộ', '2500', 3, 128),
(1850, 'Xã Mỹ Bằng', '2506', 3, 128),
(1851, 'Xã Hoàng Khai', '2518', 3, 128),
(1852, 'Xã Nhữ Hán', '2527', 3, 128),
(1853, 'Xã Nhữ Khê', '2530', 3, 128),
(1854, 'Xã Đội Bình', '2533', 3, 128);

-- Tỉnh Tuyên Quang > Huyện Sơn Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1855, 'Thị trấn Sơn Dương', '2536', 3, 129),
(1856, 'Xã Trung Yên', '2539', 3, 129),
(1857, 'Xã Minh Thanh', '2542', 3, 129),
(1858, 'Xã Tân Trào', '2545', 3, 129),
(1859, 'Xã Vĩnh Lợi', '2548', 3, 129),
(1860, 'Xã Thượng Ấm', '2551', 3, 129),
(1861, 'Xã Bình Yên', '2554', 3, 129),
(1862, 'Xã Lương Thiện', '2557', 3, 129),
(1863, 'Xã Tú Thịnh', '2560', 3, 129),
(1864, 'Xã Cấp Tiến', '2563', 3, 129),
(1865, 'Xã Hợp Thành', '2566', 3, 129),
(1866, 'Xã Phúc Ứng', '2569', 3, 129),
(1867, 'Xã Đông Thọ', '2572', 3, 129),
(1868, 'Xã Kháng Nhật', '2575', 3, 129),
(1869, 'Xã Hợp Hòa', '2578', 3, 129),
(1870, 'Xã Quyết Thắng', '2584', 3, 129),
(1871, 'Xã Đồng Quý', '2587', 3, 129),
(1872, 'Xã Tân Thanh', '2590', 3, 129),
(1873, 'Xã Văn Phú', '2596', 3, 129),
(1874, 'Xã Chi Thiết', '2599', 3, 129),
(1875, 'Xã Đông Lợi', '2602', 3, 129),
(1876, 'Xã Thiện Kế', '2605', 3, 129),
(1877, 'Xã Hồng Sơn', '2608', 3, 129),
(1878, 'Xã Phú Lương', '2611', 3, 129),
(1879, 'Xã Ninh Lai', '2614', 3, 129),
(1880, 'Xã Đại Phú', '2617', 3, 129),
(1881, 'Xã Sơn Nam', '2620', 3, 129),
(1882, 'Xã Hào Phú', '2623', 3, 129),
(1883, 'Xã Tam Đa', '2626', 3, 129),
(1884, 'Xã Trường Sinh', '2632', 3, 129);

-- Tỉnh Lào Cai > Thành phố Lào Cai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1885, 'Phường Duyên Hải', '2635', 3, 130),
(1886, 'Phường Lào Cai', '2641', 3, 130),
(1887, 'Phường Cốc Lếu', '2644', 3, 130),
(1888, 'Phường Kim Tân', '2647', 3, 130),
(1889, 'Phường Bắc Lệnh', '2650', 3, 130),
(1890, 'Phường Pom Hán', '2653', 3, 130),
(1891, 'Phường Xuân Tăng', '2656', 3, 130),
(1892, 'Phường Bình Minh', '2658', 3, 130),
(1893, 'Xã Thống Nhất', '2659', 3, 130),
(1894, 'Xã Đồng Tuyển', '2662', 3, 130),
(1895, 'Xã Vạn Hoà', '2665', 3, 130),
(1896, 'Phường Bắc Cường', '2668', 3, 130),
(1897, 'Phường Nam Cường', '2671', 3, 130),
(1898, 'Xã Cam Đường', '2674', 3, 130),
(1899, 'Xã Tả Phời', '2677', 3, 130),
(1900, 'Xã Hợp Thành', '2680', 3, 130),
(1901, 'Xã Cốc San', '2746', 3, 130);

-- Tỉnh Lào Cai > Huyện Bát Xát
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1902, 'Thị trấn Bát Xát', '2683', 3, 131),
(1903, 'Xã A Mú Sung', '2686', 3, 131),
(1904, 'Xã Nậm Chạc', '2689', 3, 131),
(1905, 'Xã A Lù', '2692', 3, 131),
(1906, 'Xã Trịnh Tường', '2695', 3, 131),
(1907, 'Xã Y Tý', '2701', 3, 131),
(1908, 'Xã Cốc Mỳ', '2704', 3, 131),
(1909, 'Xã Dền Sáng', '2707', 3, 131),
(1910, 'Xã Bản Vược', '2710', 3, 131),
(1911, 'Xã Sàng Ma Sáo', '2713', 3, 131),
(1912, 'Xã Bản Qua', '2716', 3, 131),
(1913, 'Xã Mường Vi', '2719', 3, 131),
(1914, 'Xã Dền Thàng', '2722', 3, 131),
(1915, 'Xã Bản Xèo', '2725', 3, 131),
(1916, 'Xã Mường Hum', '2728', 3, 131),
(1917, 'Xã Trung Lèng Hồ', '2731', 3, 131),
(1918, 'Xã Quang Kim', '2734', 3, 131),
(1919, 'Xã Pa Cheo', '2737', 3, 131),
(1920, 'Xã Nậm Pung', '2740', 3, 131),
(1921, 'Xã Phìn Ngan', '2743', 3, 131),
(1922, 'Xã Tòng Sành', '2749', 3, 131);

-- Tỉnh Lào Cai > Huyện Mường Khương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1923, 'Xã Pha Long', '2752', 3, 132),
(1924, 'Xã Tả Ngải Chồ', '2755', 3, 132),
(1925, 'Xã Tung Chung Phố', '2758', 3, 132),
(1926, 'Thị trấn Mường Khương', '2761', 3, 132),
(1927, 'Xã Dìn Chin', '2764', 3, 132),
(1928, 'Xã Tả Gia Khâu', '2767', 3, 132),
(1929, 'Xã Nậm Chảy', '2770', 3, 132),
(1930, 'Xã Nấm Lư', '2773', 3, 132),
(1931, 'Xã Lùng Khấu Nhin', '2776', 3, 132),
(1932, 'Xã Thanh Bình', '2779', 3, 132),
(1933, 'Xã Cao Sơn', '2782', 3, 132),
(1934, 'Xã Lùng Vai', '2785', 3, 132),
(1935, 'Xã Bản Lầu', '2788', 3, 132),
(1936, 'Xã La Pan Tẩn', '2791', 3, 132),
(1937, 'Xã Tả Thàng', '2794', 3, 132),
(1938, 'Xã Bản Sen', '2797', 3, 132);

-- Tỉnh Lào Cai > Huyện Si Ma Cai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1939, 'Xã Nàn Sán', '2800', 3, 133),
(1940, 'Xã Thào Chư Phìn', '2803', 3, 133),
(1941, 'Xã Bản Mế', '2806', 3, 133),
(1942, 'Thị trấn Si Ma Cai', '2809', 3, 133),
(1943, 'Xã Sán Chải', '2812', 3, 133),
(1944, 'Xã Lùng Thẩn', '2818', 3, 133),
(1945, 'Xã Cán Cấu', '2821', 3, 133),
(1946, 'Xã Sín Chéng', '2824', 3, 133),
(1947, 'Xã Quan Hồ Thẩn', '2827', 3, 133),
(1948, 'Xã Nàn Xín', '2836', 3, 133);

-- Tỉnh Lào Cai > Huyện Bắc Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1949, 'Thị trấn Bắc Hà', '2839', 3, 134),
(1950, 'Xã Lùng Cải', '2842', 3, 134),
(1951, 'Xã Lùng Phình', '2848', 3, 134),
(1952, 'Xã Tả Van Chư', '2851', 3, 134),
(1953, 'Xã Tả Củ Tỷ', '2854', 3, 134),
(1954, 'Xã Thải Giàng Phố', '2857', 3, 134),
(1955, 'Xã Hoàng Thu Phố', '2863', 3, 134),
(1956, 'Xã Bản Phố', '2866', 3, 134),
(1957, 'Xã Bản Liền', '2869', 3, 134),
(1958, 'Xã Na Hối', '2875', 3, 134),
(1959, 'Xã Cốc Ly', '2878', 3, 134),
(1960, 'Xã Nậm Mòn', '2881', 3, 134),
(1961, 'Xã Nậm Đét', '2884', 3, 134),
(1962, 'Xã Nậm Khánh', '2887', 3, 134),
(1963, 'Xã Bảo Nhai', '2890', 3, 134),
(1964, 'Xã Nậm Lúc', '2893', 3, 134),
(1965, 'Xã Cốc Lầu', '2896', 3, 134),
(1966, 'Xã Bản Cái', '2899', 3, 134);

-- Tỉnh Lào Cai > Huyện Bảo Thắng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1967, 'Thị trấn N.T Phong Hải', '2902', 3, 135),
(1968, 'Thị trấn Phố Lu', '2905', 3, 135),
(1969, 'Thị trấn Tằng Loỏng', '2908', 3, 135),
(1970, 'Xã Bản Phiệt', '2911', 3, 135),
(1971, 'Xã Bản Cầm', '2914', 3, 135),
(1972, 'Xã Thái Niên', '2917', 3, 135),
(1973, 'Xã Phong Niên', '2920', 3, 135),
(1974, 'Xã Gia Phú', '2923', 3, 135),
(1975, 'Xã Xuân Quang', '2926', 3, 135),
(1976, 'Xã Sơn Hải', '2929', 3, 135),
(1977, 'Xã Xuân Giao', '2932', 3, 135),
(1978, 'Xã Trì Quang', '2935', 3, 135),
(1979, 'Xã Sơn Hà', '2938', 3, 135),
(1980, 'Xã Phú Nhuận', '2944', 3, 135);

-- Tỉnh Lào Cai > Huyện Bảo Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1981, 'Thị trấn Phố Ràng', '2947', 3, 136),
(1982, 'Xã Tân Tiến', '2950', 3, 136),
(1983, 'Xã Nghĩa Đô', '2953', 3, 136),
(1984, 'Xã Vĩnh Yên', '2956', 3, 136),
(1985, 'Xã Điện Quan', '2959', 3, 136),
(1986, 'Xã Xuân Hoà', '2962', 3, 136),
(1987, 'Xã Tân Dương', '2965', 3, 136),
(1988, 'Xã Thượng Hà', '2968', 3, 136),
(1989, 'Xã Kim Sơn', '2971', 3, 136),
(1990, 'Xã Cam Cọn', '2974', 3, 136),
(1991, 'Xã Minh Tân', '2977', 3, 136),
(1992, 'Xã Xuân Thượng', '2980', 3, 136),
(1993, 'Xã Việt Tiến', '2983', 3, 136),
(1994, 'Xã Yên Sơn', '2986', 3, 136),
(1995, 'Xã Bảo Hà', '2989', 3, 136),
(1996, 'Xã Lương Sơn', '2992', 3, 136),
(1997, 'Xã Phúc Khánh', '2998', 3, 136);

-- Tỉnh Lào Cai > Thị xã Sa Pa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(1998, 'Phường Sa Pa', '3001', 3, 137),
(1999, 'Phường Sa Pả', '3002', 3, 137),
(2000, 'Phường Ô Quý Hồ', '3003', 3, 137),
(2001, 'Xã Ngũ Chỉ Sơn', '3004', 3, 137),
(2002, 'Phường Phan Si Păng', '3006', 3, 137),
(2003, 'Xã Trung Chải', '3010', 3, 137),
(2004, 'Xã Tả Phìn', '3013', 3, 137),
(2005, 'Phường Hàm Rồng', '3016', 3, 137),
(2006, 'Xã Hoàng Liên', '3019', 3, 137),
(2007, 'Xã Thanh Bình', '3022', 3, 137),
(2008, 'Phường Cầu Mây', '3028', 3, 137),
(2009, 'Xã Mường Hoa', '3037', 3, 137),
(2010, 'Xã Tả Van', '3040', 3, 137),
(2011, 'Xã Mường Bo', '3043', 3, 137),
(2012, 'Xã Bản Hồ', '3046', 3, 137),
(2013, 'Xã Liên Minh', '3052', 3, 137);

-- Tỉnh Lào Cai > Huyện Văn Bàn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2014, 'Thị trấn Khánh Yên', '3055', 3, 138),
(2015, 'Xã Võ Lao', '3061', 3, 138),
(2016, 'Xã Sơn Thuỷ', '3064', 3, 138),
(2017, 'Xã Nậm Mả', '3067', 3, 138),
(2018, 'Xã Tân Thượng', '3070', 3, 138),
(2019, 'Xã Nậm Rạng', '3073', 3, 138),
(2020, 'Xã Nậm Chầy', '3076', 3, 138),
(2021, 'Xã Tân An', '3079', 3, 138),
(2022, 'Xã Khánh Yên Thượng', '3082', 3, 138),
(2023, 'Xã Nậm Xé', '3085', 3, 138),
(2024, 'Xã Dần Thàng', '3088', 3, 138),
(2025, 'Xã Chiềng Ken', '3091', 3, 138),
(2026, 'Xã Làng Giàng', '3094', 3, 138),
(2027, 'Xã Hoà Mạc', '3097', 3, 138),
(2028, 'Xã Khánh Yên Trung', '3100', 3, 138),
(2029, 'Xã Khánh Yên Hạ', '3103', 3, 138),
(2030, 'Xã Dương Quỳ', '3106', 3, 138),
(2031, 'Xã Nậm Tha', '3109', 3, 138),
(2032, 'Xã Minh Lương', '3112', 3, 138),
(2033, 'Xã Thẩm Dương', '3115', 3, 138),
(2034, 'Xã Liêm Phú', '3118', 3, 138),
(2035, 'Xã Nậm Xây', '3121', 3, 138);

-- Tỉnh Điện Biên > Thành phố Điện Biên Phủ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2036, 'Phường Noong Bua', '3124', 3, 139),
(2037, 'Phường Him Lam', '3127', 3, 139),
(2038, 'Phường Thanh Bình', '3130', 3, 139),
(2039, 'Phường Tân Thanh', '3133', 3, 139),
(2040, 'Phường Mường Thanh', '3136', 3, 139),
(2041, 'Phường Nam Thanh', '3139', 3, 139),
(2042, 'Phường Thanh Trường', '3142', 3, 139),
(2043, 'Xã Thanh Minh', '3145', 3, 139),
(2044, 'Xã Nà Tấu', '3316', 3, 139),
(2045, 'Xã Nà Nhạn', '3317', 3, 139),
(2046, 'Xã Mường Phăng', '3325', 3, 139),
(2047, 'Xã Pá Khoang', '3326', 3, 139);

-- Tỉnh Điện Biên > Thị xã Mường Lay
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2048, 'Phường Sông Đà', '3148', 3, 140),
(2049, 'Phường Na Lay', '3151', 3, 140),
(2050, 'Xã Lay Nưa', '3184', 3, 140);

-- Tỉnh Điện Biên > Huyện Mường Nhé
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2051, 'Xã Sín Thầu', '3154', 3, 141),
(2052, 'Xã Sen Thượng', '3155', 3, 141),
(2053, 'Xã Chung Chải', '3157', 3, 141),
(2054, 'Xã Leng Su Sìn', '3158', 3, 141),
(2055, 'Xã Pá Mỳ', '3159', 3, 141),
(2056, 'Xã Mường Nhé', '3160', 3, 141),
(2057, 'Xã Nậm Vì', '3161', 3, 141),
(2058, 'Xã Nậm Kè', '3162', 3, 141),
(2059, 'Xã Mường Toong', '3163', 3, 141),
(2060, 'Xã Quảng Lâm', '3164', 3, 141),
(2061, 'Xã Huổi Lếnh', '3177', 3, 141);

-- Tỉnh Điện Biên > Huyện Mường Chà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2062, 'Thị trấn Mường Chà', '3172', 3, 142),
(2063, 'Xã Xá Tổng', '3178', 3, 142),
(2064, 'Xã Mường Tùng', '3181', 3, 142),
(2065, 'Xã Hừa Ngài', '3190', 3, 142),
(2066, 'Xã Huổi Mí', '3191', 3, 142),
(2067, 'Xã Pa Ham', '3193', 3, 142),
(2068, 'Xã Nậm Nèn', '3194', 3, 142),
(2069, 'Xã Huổi Lèng', '3196', 3, 142),
(2070, 'Xã Sa Lông', '3197', 3, 142),
(2071, 'Xã Ma Thì Hồ', '3200', 3, 142),
(2072, 'Xã Na Sang', '3201', 3, 142),
(2073, 'Xã Mường Mươn', '3202', 3, 142);

-- Tỉnh Điện Biên > Huyện Tủa Chùa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2074, 'Thị trấn Tủa Chùa', '3217', 3, 143),
(2075, 'Xã Huổi Só', '3220', 3, 143),
(2076, 'Xã Xín Chải', '3223', 3, 143),
(2077, 'Xã Tả Sìn Thàng', '3226', 3, 143),
(2078, 'Xã Lao Xả Phình', '3229', 3, 143),
(2079, 'Xã Tả Phìn', '3232', 3, 143),
(2080, 'Xã Tủa Thàng', '3235', 3, 143),
(2081, 'Xã Trung Thu', '3238', 3, 143),
(2082, 'Xã Sính Phình', '3241', 3, 143),
(2083, 'Xã Sáng Nhè', '3244', 3, 143),
(2084, 'Xã Mường Đun', '3247', 3, 143),
(2085, 'Xã Mường Báng', '3250', 3, 143);

-- Tỉnh Điện Biên > Huyện Tuần Giáo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2086, 'Thị trấn Tuần Giáo', '3253', 3, 144),
(2087, 'Xã Phình Sáng', '3259', 3, 144),
(2088, 'Xã Rạng Đông', '3260', 3, 144),
(2089, 'Xã Mùn Chung', '3262', 3, 144),
(2090, 'Xã Nà Tòng', '3263', 3, 144),
(2091, 'Xã Ta Ma', '3265', 3, 144),
(2092, 'Xã Mường Mùn', '3268', 3, 144),
(2093, 'Xã Pú Xi', '3269', 3, 144),
(2094, 'Xã Pú Nhung', '3271', 3, 144),
(2095, 'Xã Quài Nưa', '3274', 3, 144),
(2096, 'Xã Mường Thín', '3277', 3, 144),
(2097, 'Xã Tỏa Tình', '3280', 3, 144),
(2098, 'Xã Nà Sáy', '3283', 3, 144),
(2099, 'Xã Mường Khong', '3284', 3, 144),
(2100, 'Xã Quài Cang', '3289', 3, 144),
(2101, 'Xã Quài Tở', '3295', 3, 144),
(2102, 'Xã Chiềng Sinh', '3298', 3, 144),
(2103, 'Xã Chiềng Đông', '3299', 3, 144),
(2104, 'Xã Tênh Phông', '3304', 3, 144);

-- Tỉnh Điện Biên > Huyện Điện Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2105, 'Xã Mường Pồn', '3319', 3, 145),
(2106, 'Xã Thanh Nưa', '3322', 3, 145),
(2107, 'Xã Hua Thanh', '3323', 3, 145),
(2108, 'Xã Thanh Luông', '3328', 3, 145),
(2109, 'Xã Thanh Hưng', '3331', 3, 145),
(2110, 'Xã Thanh Xương', '3334', 3, 145),
(2111, 'Xã Thanh Chăn', '3337', 3, 145),
(2112, 'Xã Pa Thơm', '3340', 3, 145),
(2113, 'Xã Thanh An', '3343', 3, 145),
(2114, 'Xã Thanh Yên', '3346', 3, 145),
(2115, 'Xã Noong Luống', '3349', 3, 145),
(2116, 'Xã Noọng Hẹt', '3352', 3, 145),
(2117, 'Xã Sam Mứn', '3355', 3, 145),
(2118, 'Xã Pom Lót', '3356', 3, 145),
(2119, 'Xã Núa Ngam', '3358', 3, 145),
(2120, 'Xã Hẹ Muông', '3359', 3, 145),
(2121, 'Xã Na Ư', '3361', 3, 145),
(2122, 'Xã Mường Nhà', '3364', 3, 145),
(2123, 'Xã Na Tông', '3365', 3, 145),
(2124, 'Xã Mường Lói', '3367', 3, 145),
(2125, 'Xã Phu Luông', '3368', 3, 145);

-- Tỉnh Điện Biên > Huyện Điện Biên Đông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2126, 'Thị trấn Điện Biên Đông', '3203', 3, 146),
(2127, 'Xã Na Son', '3205', 3, 146),
(2128, 'Xã Phì Nhừ', '3208', 3, 146),
(2129, 'Xã Chiềng Sơ', '3211', 3, 146),
(2130, 'Xã Mường Luân', '3214', 3, 146),
(2131, 'Xã Pú Nhi', '3370', 3, 146),
(2132, 'Xã Nong U', '3371', 3, 146),
(2133, 'Xã Xa Dung', '3373', 3, 146),
(2134, 'Xã Keo Lôm', '3376', 3, 146),
(2135, 'Xã Luân Giới', '3379', 3, 146),
(2136, 'Xã Phình Giàng', '3382', 3, 146),
(2137, 'Xã Pú Hồng', '3383', 3, 146),
(2138, 'Xã Tìa Dình', '3384', 3, 146),
(2139, 'Xã Háng Lìa', '3385', 3, 146);

-- Tỉnh Điện Biên > Huyện Mường Ảng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2140, 'Thị trấn Mường Ảng', '3256', 3, 147),
(2141, 'Xã Mường Đăng', '3286', 3, 147),
(2142, 'Xã Ngối Cáy', '3287', 3, 147),
(2143, 'Xã Ẳng Tở', '3292', 3, 147),
(2144, 'Xã Búng Lao', '3301', 3, 147),
(2145, 'Xã Xuân Lao', '3302', 3, 147),
(2146, 'Xã Ẳng Nưa', '3307', 3, 147),
(2147, 'Xã Ẳng Cang', '3310', 3, 147),
(2148, 'Xã Nặm Lịch', '3312', 3, 147),
(2149, 'Xã Mường Lạn', '3313', 3, 147);

-- Tỉnh Điện Biên > Huyện Nậm Pồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2150, 'Xã Nậm Tin', '3156', 3, 148),
(2151, 'Xã Pa Tần', '3165', 3, 148),
(2152, 'Xã Chà Cang', '3166', 3, 148),
(2153, 'Xã Na Cô Sa', '3167', 3, 148),
(2154, 'Xã Nà Khoa', '3168', 3, 148),
(2155, 'Xã Nà Hỳ', '3169', 3, 148),
(2156, 'Xã Nà Bủng', '3170', 3, 148),
(2157, 'Xã Nậm Nhừ', '3171', 3, 148),
(2158, 'Xã Nậm Chua', '3173', 3, 148),
(2159, 'Xã Nậm Khăn', '3174', 3, 148),
(2160, 'Xã Chà Tở', '3175', 3, 148),
(2161, 'Xã Vàng Đán', '3176', 3, 148),
(2162, 'Xã Chà Nưa', '3187', 3, 148),
(2163, 'Xã Phìn Hồ', '3198', 3, 148),
(2164, 'Xã Si Pa Phìn', '3199', 3, 148);

-- Tỉnh Lai Châu > Thành phố Lai Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2165, 'Phường Quyết Thắng', '3386', 3, 149),
(2166, 'Phường Tân Phong', '3387', 3, 149),
(2167, 'Phường Quyết Tiến', '3388', 3, 149),
(2168, 'Phường Đoàn Kết', '3389', 3, 149),
(2169, 'Xã Sùng Phài', '3403', 3, 149),
(2170, 'Phường Đông Phong', '3408', 3, 149),
(2171, 'Xã San Thàng', '3409', 3, 149);

-- Tỉnh Lai Châu > Huyện Tam Đường
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2172, 'Thị trấn Tam Đường', '3390', 3, 150),
(2173, 'Xã Thèn Sin', '3394', 3, 150),
(2174, 'Xã Tả Lèng', '3400', 3, 150),
(2175, 'Xã Giang Ma', '3405', 3, 150),
(2176, 'Xã Hồ Thầu', '3406', 3, 150),
(2177, 'Xã Bình Lư', '3412', 3, 150),
(2178, 'Xã Sơn Bình', '3413', 3, 150),
(2179, 'Xã Nùng Nàng', '3415', 3, 150),
(2180, 'Xã Bản Giang', '3418', 3, 150),
(2181, 'Xã Bản Hon', '3421', 3, 150),
(2182, 'Xã Bản Bo', '3424', 3, 150),
(2183, 'Xã Nà Tăm', '3427', 3, 150),
(2184, 'Xã Khun Há', '3430', 3, 150);

-- Tỉnh Lai Châu > Huyện Mường Tè
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2185, 'Thị trấn Mường Tè', '3433', 3, 151),
(2186, 'Xã Thu Lũm', '3436', 3, 151),
(2187, 'Xã Ka Lăng', '3439', 3, 151),
(2188, 'Xã Tá Bạ', '3440', 3, 151),
(2189, 'Xã Pa ủ', '3442', 3, 151),
(2190, 'Xã Mường Tè', '3445', 3, 151),
(2191, 'Xã Pa Vệ Sử', '3448', 3, 151),
(2192, 'Xã Mù Cả', '3451', 3, 151),
(2193, 'Xã Bum Tở', '3454', 3, 151),
(2194, 'Xã Nậm Khao', '3457', 3, 151),
(2195, 'Xã Tà Tổng', '3463', 3, 151),
(2196, 'Xã Bum Nưa', '3466', 3, 151),
(2197, 'Xã Vàng San', '3467', 3, 151),
(2198, 'Xã Kan Hồ', '3469', 3, 151);

-- Tỉnh Lai Châu > Huyện Sìn Hồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2199, 'Thị trấn Sìn Hồ', '3478', 3, 152),
(2200, 'Xã Chăn Nưa', '3487', 3, 152),
(2201, 'Xã Pa Tần', '3493', 3, 152),
(2202, 'Xã Phìn Hồ', '3496', 3, 152),
(2203, 'Xã Hồng Thu', '3499', 3, 152),
(2204, 'Xã Phăng Sô Lin', '3505', 3, 152),
(2205, 'Xã Ma Quai', '3508', 3, 152),
(2206, 'Xã Lùng Thàng', '3509', 3, 152),
(2207, 'Xã Tả Phìn', '3511', 3, 152),
(2208, 'Xã Sà Dề Phìn', '3514', 3, 152),
(2209, 'Xã Nậm Tăm', '3517', 3, 152),
(2210, 'Xã Tả Ngảo', '3520', 3, 152),
(2211, 'Xã Pu Sam Cáp', '3523', 3, 152),
(2212, 'Xã Nậm Cha', '3526', 3, 152),
(2213, 'Xã Pa Khoá', '3527', 3, 152),
(2214, 'Xã Làng Mô', '3529', 3, 152),
(2215, 'Xã Noong Hẻo', '3532', 3, 152),
(2216, 'Xã Nậm Mạ', '3535', 3, 152),
(2217, 'Xã Căn Co', '3538', 3, 152),
(2218, 'Xã Tủa Sín Chải', '3541', 3, 152),
(2219, 'Xã Nậm Cuổi', '3544', 3, 152),
(2220, 'Xã Nậm Hăn', '3547', 3, 152);

-- Tỉnh Lai Châu > Huyện Phong Thổ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2221, 'Xã Lả Nhì Thàng', '3391', 3, 153),
(2222, 'Xã Huổi Luông', '3490', 3, 153),
(2223, 'Thị trấn Phong Thổ', '3549', 3, 153),
(2224, 'Xã Sì Lở Lầu', '3550', 3, 153),
(2225, 'Xã Mồ Sì San', '3553', 3, 153),
(2226, 'Xã Pa Vây Sử', '3559', 3, 153),
(2227, 'Xã Vàng Ma Chải', '3562', 3, 153),
(2228, 'Xã Tông Qua Lìn', '3565', 3, 153),
(2229, 'Xã Mù Sang', '3568', 3, 153),
(2230, 'Xã Dào San', '3571', 3, 153),
(2231, 'Xã Ma Ly Pho', '3574', 3, 153),
(2232, 'Xã Bản Lang', '3577', 3, 153),
(2233, 'Xã Hoang Thèn', '3580', 3, 153),
(2234, 'Xã Khổng Lào', '3583', 3, 153),
(2235, 'Xã Nậm Xe', '3586', 3, 153),
(2236, 'Xã Mường So', '3589', 3, 153),
(2237, 'Xã Sin Suối Hồ', '3592', 3, 153);

-- Tỉnh Lai Châu > Huyện Than Uyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2238, 'Thị trấn Than Uyên', '3595', 3, 154),
(2239, 'Xã Phúc Than', '3618', 3, 154),
(2240, 'Xã Mường Than', '3619', 3, 154),
(2241, 'Xã Mường Mít', '3625', 3, 154),
(2242, 'Xã Pha Mu', '3628', 3, 154),
(2243, 'Xã Mường Cang', '3631', 3, 154),
(2244, 'Xã Hua Nà', '3632', 3, 154),
(2245, 'Xã Tà Hừa', '3634', 3, 154),
(2246, 'Xã Mường Kim', '3637', 3, 154),
(2247, 'Xã Tà Mung', '3638', 3, 154),
(2248, 'Xã Tà Gia', '3640', 3, 154),
(2249, 'Xã Khoen On', '3643', 3, 154);

-- Tỉnh Lai Châu > Huyện Tân Uyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2250, 'Thị trấn Tân Uyên', '3598', 3, 155),
(2251, 'Xã Mường Khoa', '3601', 3, 155),
(2252, 'Xã Phúc Khoa', '3602', 3, 155),
(2253, 'Xã Thân Thuộc', '3604', 3, 155),
(2254, 'Xã Trung Đồng', '3605', 3, 155),
(2255, 'Xã Hố Mít', '3607', 3, 155),
(2256, 'Xã Nậm Cần', '3610', 3, 155),
(2257, 'Xã Nậm Sỏ', '3613', 3, 155),
(2258, 'Xã Pắc Ta', '3616', 3, 155),
(2259, 'Xã Tà Mít', '3622', 3, 155);

-- Tỉnh Lai Châu > Huyện Nậm Nhùn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2260, 'Thị trấn Nậm Nhùn', '3434', 3, 156),
(2261, 'Xã Hua Bun', '3460', 3, 156),
(2262, 'Xã Mường Mô', '3472', 3, 156),
(2263, 'Xã Nậm Chà', '3473', 3, 156),
(2264, 'Xã Nậm Manh', '3474', 3, 156),
(2265, 'Xã Nậm Hàng', '3475', 3, 156),
(2266, 'Xã Lê Lợi', '3481', 3, 156),
(2267, 'Xã Pú Đao', '3484', 3, 156),
(2268, 'Xã Nậm Pì', '3488', 3, 156),
(2269, 'Xã Nậm Ban', '3502', 3, 156),
(2270, 'Xã Trung Chải', '3503', 3, 156);

-- Tỉnh Sơn La > Thành phố Sơn La
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2271, 'Phường Chiềng Lề', '3646', 3, 157),
(2272, 'Phường Tô Hiệu', '3649', 3, 157),
(2273, 'Phường Quyết Thắng', '3652', 3, 157),
(2274, 'Phường Quyết Tâm', '3655', 3, 157),
(2275, 'Xã Chiềng Cọ', '3658', 3, 157),
(2276, 'Xã Chiềng Đen', '3661', 3, 157),
(2277, 'Xã Chiềng Xôm', '3664', 3, 157),
(2278, 'Phường Chiềng An', '3667', 3, 157),
(2279, 'Phường Chiềng Cơi', '3670', 3, 157),
(2280, 'Xã Chiềng Ngần', '3673', 3, 157),
(2281, 'Xã Hua La', '3676', 3, 157),
(2282, 'Phường Chiềng Sinh', '3679', 3, 157);

-- Tỉnh Sơn La > Huyện Quỳnh Nhai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2283, 'Xã Mường Chiên', '3682', 3, 158),
(2284, 'Xã Cà Nàng', '3685', 3, 158),
(2285, 'Xã Chiềng Khay', '3688', 3, 158),
(2286, 'Xã Mường Giôn', '3694', 3, 158),
(2287, 'Xã Pá Ma Pha Khinh', '3697', 3, 158),
(2288, 'Xã Chiềng Ơn', '3700', 3, 158),
(2289, 'Xã Mường Giàng', '3703', 3, 158),
(2290, 'Xã Chiềng Bằng', '3706', 3, 158),
(2291, 'Xã Mường Sại', '3709', 3, 158),
(2292, 'Xã Nậm ét', '3712', 3, 158),
(2293, 'Xã Chiềng Khoang', '3718', 3, 158);

-- Tỉnh Sơn La > Huyện Thuận Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2294, 'Thị trấn Thuận Châu', '3721', 3, 159),
(2295, 'Xã Phổng Lái', '3724', 3, 159),
(2296, 'Xã Mường é', '3727', 3, 159),
(2297, 'Xã Chiềng Pha', '3730', 3, 159),
(2298, 'Xã Chiềng La', '3733', 3, 159),
(2299, 'Xã Chiềng Ngàm', '3736', 3, 159),
(2300, 'Xã Liệp Tè', '3739', 3, 159),
(2301, 'Xã é Tòng', '3742', 3, 159),
(2302, 'Xã Phổng Lập', '3745', 3, 159),
(2303, 'Xã Phổng Lăng', '3748', 3, 159),
(2304, 'Xã Chiềng Ly', '3751', 3, 159),
(2305, 'Xã Noong Lay', '3754', 3, 159),
(2306, 'Xã Mường Khiêng', '3757', 3, 159),
(2307, 'Xã Mường Bám', '3760', 3, 159),
(2308, 'Xã Long Hẹ', '3763', 3, 159),
(2309, 'Xã Chiềng Bôm', '3766', 3, 159),
(2310, 'Xã Thôm Mòn', '3769', 3, 159),
(2311, 'Xã Tông Lạnh', '3772', 3, 159),
(2312, 'Xã Tông Cọ', '3775', 3, 159),
(2313, 'Xã Bó Mười', '3778', 3, 159),
(2314, 'Xã Co Mạ', '3781', 3, 159),
(2315, 'Xã Púng Tra', '3784', 3, 159),
(2316, 'Xã Chiềng Pấc', '3787', 3, 159),
(2317, 'Xã Nậm Lầu', '3790', 3, 159),
(2318, 'Xã Bon Phặng', '3793', 3, 159),
(2319, 'Xã Co Tòng', '3796', 3, 159),
(2320, 'Xã Muổi Nọi', '3799', 3, 159),
(2321, 'Xã Pá Lông', '3802', 3, 159),
(2322, 'Xã Bản Lầm', '3805', 3, 159);

-- Tỉnh Sơn La > Huyện Mường La
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2323, 'Thị trấn Ít Ong', '3808', 3, 160),
(2324, 'Xã Nậm Giôn', '3811', 3, 160),
(2325, 'Xã Chiềng Lao', '3814', 3, 160),
(2326, 'Xã Hua Trai', '3817', 3, 160),
(2327, 'Xã Ngọc Chiến', '3820', 3, 160),
(2328, 'Xã Mường Trai', '3823', 3, 160),
(2329, 'Xã Nậm Păm', '3826', 3, 160),
(2330, 'Xã Chiềng Muôn', '3829', 3, 160),
(2331, 'Xã Chiềng Ân', '3832', 3, 160),
(2332, 'Xã Pi Toong', '3835', 3, 160),
(2333, 'Xã Chiềng Công', '3838', 3, 160),
(2334, 'Xã Tạ Bú', '3841', 3, 160),
(2335, 'Xã Chiềng San', '3844', 3, 160),
(2336, 'Xã Mường Bú', '3847', 3, 160),
(2337, 'Xã Chiềng Hoa', '3850', 3, 160),
(2338, 'Xã Mường Chùm', '3853', 3, 160);

-- Tỉnh Sơn La > Huyện Bắc Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2339, 'Thị trấn Bắc Yên', '3856', 3, 161),
(2340, 'Xã Phiêng Ban', '3859', 3, 161),
(2341, 'Xã Hang Chú', '3862', 3, 161),
(2342, 'Xã Xím Vàng', '3865', 3, 161),
(2343, 'Xã Tà Xùa', '3868', 3, 161),
(2344, 'Xã Háng Đồng', '3869', 3, 161),
(2345, 'Xã Pắc Ngà', '3871', 3, 161),
(2346, 'Xã Làng Chếu', '3874', 3, 161),
(2347, 'Xã Chim Vàn', '3877', 3, 161),
(2348, 'Xã Mường Khoa', '3880', 3, 161),
(2349, 'Xã Song Pe', '3883', 3, 161),
(2350, 'Xã Hồng Ngài', '3886', 3, 161),
(2351, 'Xã Tạ Khoa', '3889', 3, 161),
(2352, 'Xã Hua Nhàn', '3890', 3, 161),
(2353, 'Xã Phiêng Côn', '3892', 3, 161),
(2354, 'Xã Chiềng Sại', '3895', 3, 161);

-- Tỉnh Sơn La > Huyện Phù Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2355, 'Thị trấn Phù Yên', '3898', 3, 162),
(2356, 'Xã Suối Tọ', '3901', 3, 162),
(2357, 'Xã Mường Thải', '3904', 3, 162),
(2358, 'Xã Mường Cơi', '3907', 3, 162),
(2359, 'Xã Quang Huy', '3910', 3, 162),
(2360, 'Xã Huy Bắc', '3913', 3, 162),
(2361, 'Xã Huy Thượng', '3916', 3, 162),
(2362, 'Xã Tân Lang', '3919', 3, 162),
(2363, 'Xã Gia Phù', '3922', 3, 162),
(2364, 'Xã Tường Phù', '3925', 3, 162),
(2365, 'Xã Huy Hạ', '3928', 3, 162),
(2366, 'Xã Huy Tân', '3931', 3, 162),
(2367, 'Xã Mường Lang', '3934', 3, 162),
(2368, 'Xã Suối Bau', '3937', 3, 162),
(2369, 'Xã Huy Tường', '3940', 3, 162),
(2370, 'Xã Mường Do', '3943', 3, 162),
(2371, 'Xã Sập Xa', '3946', 3, 162),
(2372, 'Xã Tường Thượng', '3949', 3, 162),
(2373, 'Xã Tường Tiến', '3952', 3, 162),
(2374, 'Xã Tường Phong', '3955', 3, 162),
(2375, 'Xã Tường Hạ', '3958', 3, 162),
(2376, 'Xã Kim Bon', '3961', 3, 162),
(2377, 'Xã Mường Bang', '3964', 3, 162),
(2378, 'Xã Đá Đỏ', '3967', 3, 162),
(2379, 'Xã Tân Phong', '3970', 3, 162),
(2380, 'Xã Nam Phong', '3973', 3, 162),
(2381, 'Xã Bắc Phong', '3976', 3, 162);

-- Tỉnh Sơn La > Huyện Mộc Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2382, 'Thị trấn Mộc Châu', '3979', 3, 163),
(2383, 'Thị trấn NT Mộc Châu', '3982', 3, 163),
(2384, 'Xã Chiềng Sơn', '3985', 3, 163),
(2385, 'Xã Tân Hợp', '3988', 3, 163),
(2386, 'Xã Qui Hướng', '3991', 3, 163),
(2387, 'Xã Tân Lập', '3997', 3, 163),
(2388, 'Xã Nà Mường', '4000', 3, 163),
(2389, 'Xã Tà Lai', '4003', 3, 163),
(2390, 'Xã Chiềng Hắc', '4012', 3, 163),
(2391, 'Xã Hua Păng', '4015', 3, 163),
(2392, 'Xã Chiềng Khừa', '4024', 3, 163),
(2393, 'Xã Mường Sang', '4027', 3, 163),
(2394, 'Xã Đông Sang', '4030', 3, 163),
(2395, 'Xã Phiêng Luông', '4033', 3, 163),
(2396, 'Xã Lóng Sập', '4045', 3, 163);

-- Tỉnh Sơn La > Huyện Yên Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2397, 'Thị trấn Yên Châu', '4060', 3, 164),
(2398, 'Xã Chiềng Đông', '4063', 3, 164),
(2399, 'Xã Sập Vạt', '4066', 3, 164),
(2400, 'Xã Chiềng Sàng', '4069', 3, 164),
(2401, 'Xã Chiềng Pằn', '4072', 3, 164),
(2402, 'Xã Viêng Lán', '4075', 3, 164),
(2403, 'Xã Chiềng Hặc', '4078', 3, 164),
(2404, 'Xã Mường Lựm', '4081', 3, 164),
(2405, 'Xã Chiềng On', '4084', 3, 164),
(2406, 'Xã Yên Sơn', '4087', 3, 164),
(2407, 'Xã Chiềng Khoi', '4090', 3, 164),
(2408, 'Xã Tú Nang', '4093', 3, 164),
(2409, 'Xã Lóng Phiêng', '4096', 3, 164),
(2410, 'Xã Phiêng Khoài', '4099', 3, 164),
(2411, 'Xã Chiềng Tương', '4102', 3, 164);

-- Tỉnh Sơn La > Huyện Mai Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2412, 'Thị trấn Hát Lót', '4105', 3, 165),
(2413, 'Xã Chiềng Sung', '4108', 3, 165),
(2414, 'Xã Mường Bằng', '4111', 3, 165),
(2415, 'Xã Chiềng Chăn', '4114', 3, 165),
(2416, 'Xã Mương Chanh', '4117', 3, 165),
(2417, 'Xã Chiềng Ban', '4120', 3, 165),
(2418, 'Xã Chiềng Mung', '4123', 3, 165),
(2419, 'Xã Mường Bon', '4126', 3, 165),
(2420, 'Xã Chiềng Chung', '4129', 3, 165),
(2421, 'Xã Chiềng Mai', '4132', 3, 165),
(2422, 'Xã Hát Lót', '4135', 3, 165),
(2423, 'Xã Nà Pó', '4136', 3, 165),
(2424, 'Xã Cò Nòi', '4138', 3, 165),
(2425, 'Xã Chiềng Nơi', '4141', 3, 165),
(2426, 'Xã Phiêng Cằm', '4144', 3, 165),
(2427, 'Xã Chiềng Dong', '4147', 3, 165),
(2428, 'Xã Chiềng Kheo', '4150', 3, 165),
(2429, 'Xã Chiềng Ve', '4153', 3, 165),
(2430, 'Xã Chiềng Lương', '4156', 3, 165),
(2431, 'Xã Phiêng Pằn', '4159', 3, 165),
(2432, 'Xã Nà Ơt', '4162', 3, 165),
(2433, 'Xã Tà Hộc', '4165', 3, 165);

-- Tỉnh Sơn La > Huyện Sông Mã
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2434, 'Thị trấn Sông Mã', '4168', 3, 166),
(2435, 'Xã Bó Sinh', '4171', 3, 166),
(2436, 'Xã Pú Pẩu', '4174', 3, 166),
(2437, 'Xã Chiềng Phung', '4177', 3, 166),
(2438, 'Xã Chiềng En', '4180', 3, 166),
(2439, 'Xã Mường Lầm', '4183', 3, 166),
(2440, 'Xã Nậm Ty', '4186', 3, 166),
(2441, 'Xã Đứa Mòn', '4189', 3, 166),
(2442, 'Xã Yên Hưng', '4192', 3, 166),
(2443, 'Xã Chiềng Sơ', '4195', 3, 166),
(2444, 'Xã Nà Nghịu', '4198', 3, 166),
(2445, 'Xã Nậm Mằn', '4201', 3, 166),
(2446, 'Xã Chiềng Khoong', '4204', 3, 166),
(2447, 'Xã Chiềng Cang', '4207', 3, 166),
(2448, 'Xã Huổi Một', '4210', 3, 166),
(2449, 'Xã Mường Sai', '4213', 3, 166),
(2450, 'Xã Mường Cai', '4216', 3, 166),
(2451, 'Xã Mường Hung', '4219', 3, 166),
(2452, 'Xã Chiềng Khương', '4222', 3, 166);

-- Tỉnh Sơn La > Huyện Sốp Cộp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2453, 'Xã Sam Kha', '4225', 3, 167),
(2454, 'Xã Púng Bánh', '4228', 3, 167),
(2455, 'Xã Sốp Cộp', '4231', 3, 167),
(2456, 'Xã Dồm Cang', '4234', 3, 167),
(2457, 'Xã Nậm Lạnh', '4237', 3, 167),
(2458, 'Xã Mường Lèo', '4240', 3, 167),
(2459, 'Xã Mường Và', '4243', 3, 167),
(2460, 'Xã Mường Lạn', '4246', 3, 167);

-- Tỉnh Sơn La > Huyện Vân Hồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2461, 'Xã Suối Bàng', '3994', 3, 168),
(2462, 'Xã Song Khủa', '4006', 3, 168),
(2463, 'Xã Liên Hoà', '4009', 3, 168),
(2464, 'Xã Tô Múa', '4018', 3, 168),
(2465, 'Xã Mường Tè', '4021', 3, 168),
(2466, 'Xã Chiềng Khoa', '4036', 3, 168),
(2467, 'Xã Mường Men', '4039', 3, 168),
(2468, 'Xã Quang Minh', '4042', 3, 168),
(2469, 'Xã Vân Hồ', '4048', 3, 168),
(2470, 'Xã Lóng Luông', '4051', 3, 168),
(2471, 'Xã Chiềng Yên', '4054', 3, 168),
(2472, 'Xã Chiềng Xuân', '4056', 3, 168),
(2473, 'Xã Xuân Nha', '4057', 3, 168),
(2474, 'Xã Tân Xuân', '4058', 3, 168);

-- Tỉnh Yên Bái > Thành phố Yên Bái
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2475, 'Phường Yên Thịnh', '4249', 3, 169),
(2476, 'Phường Yên Ninh', '4252', 3, 169),
(2477, 'Phường Minh Tân', '4255', 3, 169),
(2478, 'Phường Nguyễn Thái Học', '4258', 3, 169),
(2479, 'Phường Đồng Tâm', '4261', 3, 169),
(2480, 'Phường Hồng Hà', '4264', 3, 169),
(2481, 'Xã Minh Bảo', '4270', 3, 169),
(2482, 'Phường Nam Cường', '4273', 3, 169),
(2483, 'Xã Tuy Lộc', '4276', 3, 169),
(2484, 'Xã Tân Thịnh', '4279', 3, 169),
(2485, 'Xã Âu Lâu', '4540', 3, 169),
(2486, 'Xã Giới Phiên', '4543', 3, 169),
(2487, 'Phường Hợp Minh', '4546', 3, 169),
(2488, 'Xã Văn Phú', '4558', 3, 169);

-- Tỉnh Yên Bái > Thị xã Nghĩa Lộ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2489, 'Phường Pú Trạng', '4282', 3, 170),
(2490, 'Phường Trung Tâm', '4285', 3, 170),
(2491, 'Phường Tân An', '4288', 3, 170),
(2492, 'Phường Cầu Thia', '4291', 3, 170),
(2493, 'Xã Nghĩa Lợi', '4294', 3, 170),
(2494, 'Xã Nghĩa Phúc', '4297', 3, 170),
(2495, 'Xã Nghĩa An', '4300', 3, 170),
(2496, 'Xã Nghĩa Lộ', '4624', 3, 170),
(2497, 'Xã Sơn A', '4660', 3, 170),
(2498, 'Xã Phù Nham', '4663', 3, 170),
(2499, 'Xã Thanh Lương', '4675', 3, 170),
(2500, 'Xã Hạnh Sơn', '4678', 3, 170),
(2501, 'Xã Phúc Sơn', '4681', 3, 170),
(2502, 'Xã Thạch Lương', '4684', 3, 170);

-- Tỉnh Yên Bái > Huyện Lục Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2503, 'Thị trấn Yên Thế', '4303', 3, 171),
(2504, 'Xã Tân Phượng', '4306', 3, 171),
(2505, 'Xã Lâm Thượng', '4309', 3, 171),
(2506, 'Xã Khánh Thiện', '4312', 3, 171),
(2507, 'Xã Minh Chuẩn', '4315', 3, 171),
(2508, 'Xã Mai Sơn', '4318', 3, 171),
(2509, 'Xã Khai Trung', '4321', 3, 171),
(2510, 'Xã Mường Lai', '4324', 3, 171),
(2511, 'Xã An Lạc', '4327', 3, 171),
(2512, 'Xã Minh Xuân', '4330', 3, 171),
(2513, 'Xã Tô Mậu', '4333', 3, 171),
(2514, 'Xã Tân Lĩnh', '4336', 3, 171),
(2515, 'Xã Yên Thắng', '4339', 3, 171),
(2516, 'Xã Khánh Hoà', '4342', 3, 171),
(2517, 'Xã Vĩnh Lạc', '4345', 3, 171),
(2518, 'Xã Liễu Đô', '4348', 3, 171),
(2519, 'Xã Động Quan', '4351', 3, 171),
(2520, 'Xã Tân Lập', '4354', 3, 171),
(2521, 'Xã Minh Tiến', '4357', 3, 171),
(2522, 'Xã Trúc Lâu', '4360', 3, 171),
(2523, 'Xã Phúc Lợi', '4363', 3, 171),
(2524, 'Xã Phan Thanh', '4366', 3, 171),
(2525, 'Xã An Phú', '4369', 3, 171),
(2526, 'Xã Trung Tâm', '4372', 3, 171);

-- Tỉnh Yên Bái > Huyện Văn Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2527, 'Thị trấn Mậu A', '4375', 3, 172),
(2528, 'Xã Lang Thíp', '4378', 3, 172),
(2529, 'Xã Lâm Giang', '4381', 3, 172),
(2530, 'Xã Châu Quế Thượng', '4384', 3, 172),
(2531, 'Xã Châu Quế Hạ', '4387', 3, 172),
(2532, 'Xã An Bình', '4390', 3, 172),
(2533, 'Xã Quang Minh', '4393', 3, 172),
(2534, 'Xã Đông An', '4396', 3, 172),
(2535, 'Xã Đông Cuông', '4399', 3, 172),
(2536, 'Xã Phong Dụ Hạ', '4402', 3, 172),
(2537, 'Xã Mậu Đông', '4405', 3, 172),
(2538, 'Xã Ngòi A', '4408', 3, 172),
(2539, 'Xã Xuân Tầm', '4411', 3, 172),
(2540, 'Xã Tân Hợp', '4414', 3, 172),
(2541, 'Xã An Thịnh', '4417', 3, 172),
(2542, 'Xã Yên Thái', '4420', 3, 172),
(2543, 'Xã Phong Dụ Thượng', '4423', 3, 172),
(2544, 'Xã Yên Hợp', '4426', 3, 172),
(2545, 'Xã Đại Sơn', '4429', 3, 172),
(2546, 'Xã Đại Phác', '4435', 3, 172),
(2547, 'Xã Yên Phú', '4438', 3, 172),
(2548, 'Xã Xuân Ái', '4441', 3, 172),
(2549, 'Xã Viễn Sơn', '4447', 3, 172),
(2550, 'Xã Mỏ Vàng', '4450', 3, 172),
(2551, 'Xã Nà Hẩu', '4453', 3, 172);

-- Tỉnh Yên Bái > Huyện Mù Căng Chải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2552, 'Thị trấn Mù Căng Chải', '4456', 3, 173),
(2553, 'Xã Hồ Bốn', '4459', 3, 173),
(2554, 'Xã Nậm Có', '4462', 3, 173),
(2555, 'Xã Khao Mang', '4465', 3, 173),
(2556, 'Xã Mồ Dề', '4468', 3, 173),
(2557, 'Xã Chế Cu Nha', '4471', 3, 173),
(2558, 'Xã Lao Chải', '4474', 3, 173),
(2559, 'Xã Kim Nọi', '4477', 3, 173),
(2560, 'Xã Cao Phạ', '4480', 3, 173),
(2561, 'Xã La Pán Tẩn', '4483', 3, 173),
(2562, 'Xã Dế Su Phình', '4486', 3, 173),
(2563, 'Xã Chế Tạo', '4489', 3, 173),
(2564, 'Xã Púng Luông', '4492', 3, 173),
(2565, 'Xã Nậm Khắt', '4495', 3, 173);

-- Tỉnh Yên Bái > Huyện Trấn Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2566, 'Thị trấn Cổ Phúc', '4498', 3, 174),
(2567, 'Xã Tân Đồng', '4501', 3, 174),
(2568, 'Xã Báo Đáp', '4504', 3, 174),
(2569, 'Xã Thành Thịnh', '4510', 3, 174),
(2570, 'Xã Hòa Cuông', '4513', 3, 174),
(2571, 'Xã Minh Quán', '4516', 3, 174),
(2572, 'Xã Quy Mông', '4519', 3, 174),
(2573, 'Xã Cường Thịnh', '4522', 3, 174),
(2574, 'Xã Kiên Thành', '4525', 3, 174),
(2575, 'Xã Y Can', '4531', 3, 174),
(2576, 'Xã Lương Thịnh', '4537', 3, 174),
(2577, 'Xã Việt Cường', '4564', 3, 174),
(2578, 'Xã Minh Quân', '4567', 3, 174),
(2579, 'Xã Hồng Ca', '4570', 3, 174),
(2580, 'Xã Hưng Thịnh', '4573', 3, 174),
(2581, 'Xã Hưng Khánh', '4576', 3, 174),
(2582, 'Xã Việt Hồng', '4579', 3, 174),
(2583, 'Xã Vân Hội', '4582', 3, 174);

-- Tỉnh Yên Bái > Huyện Trạm Tấu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2584, 'Thị trấn Trạm Tấu', '4585', 3, 175),
(2585, 'Xã Túc Đán', '4588', 3, 175),
(2586, 'Xã Pá Lau', '4591', 3, 175),
(2587, 'Xã Xà Hồ', '4594', 3, 175),
(2588, 'Xã Phình Hồ', '4597', 3, 175),
(2589, 'Xã Trạm Tấu', '4600', 3, 175),
(2590, 'Xã Tà Si Láng', '4603', 3, 175),
(2591, 'Xã Pá Hu', '4606', 3, 175),
(2592, 'Xã Làng Nhì', '4609', 3, 175),
(2593, 'Xã Bản Công', '4612', 3, 175),
(2594, 'Xã Bản Mù', '4615', 3, 175),
(2595, 'Xã Hát Lìu', '4618', 3, 175);

-- Tỉnh Yên Bái > Huyện Văn Chấn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2596, 'Thị trấn NT Liên Sơn', '4621', 3, 176),
(2597, 'Thị trấn NT Trần Phú', '4627', 3, 176),
(2598, 'Xã Tú Lệ', '4630', 3, 176),
(2599, 'Xã Nậm Búng', '4633', 3, 176),
(2600, 'Xã Gia Hội', '4636', 3, 176),
(2601, 'Xã Sùng Đô', '4639', 3, 176),
(2602, 'Xã Nậm Mười', '4642', 3, 176),
(2603, 'Xã An Lương', '4645', 3, 176),
(2604, 'Xã Nậm Lành', '4648', 3, 176),
(2605, 'Xã Sơn Lương', '4651', 3, 176),
(2606, 'Xã Suối Quyền', '4654', 3, 176),
(2607, 'Xã Suối Giàng', '4657', 3, 176),
(2608, 'Xã Nghĩa Sơn', '4666', 3, 176),
(2609, 'Xã Suối Bu', '4669', 3, 176),
(2610, 'Thị trấn Sơn Thịnh', '4672', 3, 176),
(2611, 'Xã Đại Lịch', '4687', 3, 176),
(2612, 'Xã Đồng Khê', '4690', 3, 176),
(2613, 'Xã Cát Thịnh', '4693', 3, 176),
(2614, 'Xã Tân Thịnh', '4696', 3, 176),
(2615, 'Xã Chấn Thịnh', '4699', 3, 176),
(2616, 'Xã Bình Thuận', '4702', 3, 176),
(2617, 'Xã Thượng Bằng La', '4705', 3, 176),
(2618, 'Xã Minh An', '4708', 3, 176),
(2619, 'Xã Nghĩa Tâm', '4711', 3, 176);

-- Tỉnh Yên Bái > Huyện Yên Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2620, 'Thị trấn Yên Bình', '4714', 3, 177),
(2621, 'Thị trấn Thác Bà', '4717', 3, 177),
(2622, 'Xã Xuân Long', '4720', 3, 177),
(2623, 'Xã Cảm Nhân', '4726', 3, 177),
(2624, 'Xã Ngọc Chấn', '4729', 3, 177),
(2625, 'Xã Tân Nguyên', '4732', 3, 177),
(2626, 'Xã Phúc Ninh', '4735', 3, 177),
(2627, 'Xã Bảo Ái', '4738', 3, 177),
(2628, 'Xã Mỹ Gia', '4741', 3, 177),
(2629, 'Xã Xuân Lai', '4744', 3, 177),
(2630, 'Xã Mông Sơn', '4747', 3, 177),
(2631, 'Xã Cảm Ân', '4750', 3, 177),
(2632, 'Xã Yên Thành', '4753', 3, 177),
(2633, 'Xã Tân Hương', '4756', 3, 177),
(2634, 'Xã Phúc An', '4759', 3, 177),
(2635, 'Xã Bạch Hà', '4762', 3, 177),
(2636, 'Xã Vũ Linh', '4765', 3, 177),
(2637, 'Xã Đại Đồng', '4768', 3, 177),
(2638, 'Xã Vĩnh Kiên', '4771', 3, 177),
(2639, 'Xã Thịnh Hưng', '4777', 3, 177),
(2640, 'Xã Hán Đà', '4780', 3, 177),
(2641, 'Xã Phú Thịnh', '4783', 3, 177),
(2642, 'Xã Đại Minh', '4786', 3, 177);

-- Tỉnh Hoà Bình > Thành phố Hòa Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2643, 'Phường Thái Bình', '4789', 3, 178),
(2644, 'Phường Tân Hòa', '4792', 3, 178),
(2645, 'Phường Thịnh Lang', '4795', 3, 178),
(2646, 'Phường Hữu Nghị', '4798', 3, 178),
(2647, 'Phường Tân Thịnh', '4801', 3, 178),
(2648, 'Phường Đồng Tiến', '4804', 3, 178),
(2649, 'Phường Phương Lâm', '4807', 3, 178),
(2650, 'Xã Yên Mông', '4813', 3, 178),
(2651, 'Phường Quỳnh Lâm', '4816', 3, 178),
(2652, 'Phường Dân Chủ', '4819', 3, 178),
(2653, 'Xã Hòa Bình', '4825', 3, 178),
(2654, 'Phường Thống Nhất', '4828', 3, 178),
(2655, 'Phường Kỳ Sơn', '4894', 3, 178),
(2656, 'Xã Thịnh Minh', '4897', 3, 178),
(2657, 'Xã Hợp Thành', '4903', 3, 178),
(2658, 'Xã Quang Tiến', '4906', 3, 178),
(2659, 'Xã Mông Hóa', '4912', 3, 178),
(2660, 'Phường Trung Minh', '4918', 3, 178),
(2661, 'Xã Độc Lập', '4921', 3, 178);

-- Tỉnh Hoà Bình > Huyện Đà Bắc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2662, 'Thị trấn Đà Bắc', '4831', 3, 179),
(2663, 'Xã Nánh Nghê', '4834', 3, 179),
(2664, 'Xã Giáp Đắt', '4840', 3, 179),
(2665, 'Xã Mường Chiềng', '4846', 3, 179),
(2666, 'Xã Tân Pheo', '4849', 3, 179),
(2667, 'Xã Đồng Chum', '4852', 3, 179),
(2668, 'Xã Tân Minh', '4855', 3, 179),
(2669, 'Xã Đoàn Kết', '4858', 3, 179),
(2670, 'Xã Đồng Ruộng', '4861', 3, 179),
(2671, 'Xã Tú Lý', '4867', 3, 179),
(2672, 'Xã Trung Thành', '4870', 3, 179),
(2673, 'Xã Yên Hòa', '4873', 3, 179),
(2674, 'Xã Cao Sơn', '4876', 3, 179),
(2675, 'Xã Toàn Sơn', '4879', 3, 179),
(2676, 'Xã Hiền Lương', '4885', 3, 179),
(2677, 'Xã Tiền Phong', '4888', 3, 179),
(2678, 'Xã Vầy Nưa', '4891', 3, 179);

-- Tỉnh Hoà Bình > Huyện Lương Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2679, 'Thị trấn Lương Sơn', '4924', 3, 180),
(2680, 'Xã Lâm Sơn', '4942', 3, 180),
(2681, 'Xã Hòa Sơn', '4945', 3, 180),
(2682, 'Xã Tân Vinh', '4951', 3, 180),
(2683, 'Xã Nhuận Trạch', '4954', 3, 180),
(2684, 'Xã Cao Sơn', '4957', 3, 180),
(2685, 'Xã Cư Yên', '4960', 3, 180),
(2686, 'Xã Liên Sơn', '4969', 3, 180),
(2687, 'Xã Cao Dương', '5008', 3, 180),
(2688, 'Xã Thanh Sơn', '5041', 3, 180),
(2689, 'Xã Thanh Cao', '5047', 3, 180);

-- Tỉnh Hoà Bình > Huyện Kim Bôi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2690, 'Thị trấn Bo', '4978', 3, 181),
(2691, 'Xã Đú Sáng', '4984', 3, 181),
(2692, 'Xã Hùng Sơn', '4987', 3, 181),
(2693, 'Xã Bình Sơn', '4990', 3, 181),
(2694, 'Xã Tú Sơn', '4999', 3, 181),
(2695, 'Xã Vĩnh Tiến', '5005', 3, 181),
(2696, 'Xã Đông Bắc', '5014', 3, 181),
(2697, 'Xã Xuân Thủy', '5017', 3, 181),
(2698, 'Xã Vĩnh Đồng', '5026', 3, 181),
(2699, 'Xã Kim Lập', '5035', 3, 181),
(2700, 'Xã Hợp Tiến', '5038', 3, 181),
(2701, 'Xã Kim Bôi', '5065', 3, 181),
(2702, 'Xã Nam Thượng', '5068', 3, 181),
(2703, 'Xã Cuối Hạ', '5077', 3, 181),
(2704, 'Xã Sào Báy', '5080', 3, 181),
(2705, 'Xã Mi Hòa', '5083', 3, 181),
(2706, 'Xã Nuông Dăm', '5086', 3, 181);

-- Tỉnh Hoà Bình > Huyện Cao Phong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2707, 'Thị trấn Cao Phong', '5089', 3, 182),
(2708, 'Xã Bình Thanh', '5092', 3, 182),
(2709, 'Xã Thung Nai', '5095', 3, 182),
(2710, 'Xã Bắc Phong', '5098', 3, 182),
(2711, 'Xã Thu Phong', '5101', 3, 182),
(2712, 'Xã Hợp Phong', '5104', 3, 182),
(2713, 'Xã Tây Phong', '5110', 3, 182),
(2714, 'Xã Dũng Phong', '5116', 3, 182),
(2715, 'Xã Nam Phong', '5119', 3, 182),
(2716, 'Xã Thạch Yên', '5125', 3, 182);

-- Tỉnh Hoà Bình > Huyện Tân Lạc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2717, 'Thị trấn Mãn Đức', '5128', 3, 183),
(2718, 'Xã Suối Hoa', '5134', 3, 183),
(2719, 'Xã Phú Vinh', '5137', 3, 183),
(2720, 'Xã Phú Cường', '5140', 3, 183),
(2721, 'Xã Mỹ Hòa', '5143', 3, 183),
(2722, 'Xã Quyết Chiến', '5152', 3, 183),
(2723, 'Xã Phong Phú', '5158', 3, 183),
(2724, 'Xã Tử Nê', '5164', 3, 183),
(2725, 'Xã Thanh Hối', '5167', 3, 183),
(2726, 'Xã Ngọc Mỹ', '5170', 3, 183),
(2727, 'Xã Đông Lai', '5173', 3, 183),
(2728, 'Xã Vân Sơn', '5176', 3, 183),
(2729, 'Xã Nhân Mỹ', '5182', 3, 183),
(2730, 'Xã Lỗ Sơn', '5191', 3, 183),
(2731, 'Xã Ngổ Luông', '5194', 3, 183),
(2732, 'Xã Gia Mô', '5197', 3, 183);

-- Tỉnh Hoà Bình > Huyện Mai Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2733, 'Xã Tân Thành', '4882', 3, 184),
(2734, 'Thị trấn Mai Châu', '5200', 3, 184),
(2735, 'Xã Sơn Thủy', '5206', 3, 184),
(2736, 'Xã Pà Cò', '5209', 3, 184),
(2737, 'Xã Hang Kia', '5212', 3, 184),
(2738, 'Xã Đồng Tân', '5221', 3, 184),
(2739, 'Xã Cun Pheo', '5224', 3, 184),
(2740, 'Xã Bao La', '5227', 3, 184),
(2741, 'Xã Tòng Đậu', '5233', 3, 184),
(2742, 'Xã Nà Phòn', '5242', 3, 184),
(2743, 'Xã Săm Khóe', '5245', 3, 184),
(2744, 'Xã Chiềng Châu', '5248', 3, 184),
(2745, 'Xã Mai Hạ', '5251', 3, 184),
(2746, 'Xã Thành Sơn', '5254', 3, 184),
(2747, 'Xã Mai Hịch', '5257', 3, 184),
(2748, 'Xã Vạn Mai', '5263', 3, 184);

-- Tỉnh Hoà Bình > Huyện Lạc Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2749, 'Thị trấn Vụ Bản', '5266', 3, 185),
(2750, 'Xã Quý Hòa', '5269', 3, 185),
(2751, 'Xã Miền Đồi', '5272', 3, 185),
(2752, 'Xã Mỹ Thành', '5275', 3, 185),
(2753, 'Xã Tuân Đạo', '5278', 3, 185),
(2754, 'Xã Văn Nghĩa', '5281', 3, 185),
(2755, 'Xã Văn Sơn', '5284', 3, 185),
(2756, 'Xã Tân Lập', '5287', 3, 185),
(2757, 'Xã Nhân Nghĩa', '5290', 3, 185),
(2758, 'Xã Thượng Cốc', '5293', 3, 185),
(2759, 'Xã Quyết Thắng', '5299', 3, 185),
(2760, 'Xã Xuất Hóa', '5302', 3, 185),
(2761, 'Xã Yên Phú', '5305', 3, 185),
(2762, 'Xã Bình Hẻm', '5308', 3, 185),
(2763, 'Xã Định Cư', '5320', 3, 185),
(2764, 'Xã Chí Đạo', '5323', 3, 185),
(2765, 'Xã Ngọc Sơn', '5329', 3, 185),
(2766, 'Xã Hương Nhượng', '5332', 3, 185),
(2767, 'Xã Vũ Bình', '5335', 3, 185),
(2768, 'Xã Tự Do', '5338', 3, 185),
(2769, 'Xã Yên Nghiệp', '5341', 3, 185),
(2770, 'Xã Tân Mỹ', '5344', 3, 185),
(2771, 'Xã Ân Nghĩa', '5347', 3, 185),
(2772, 'Xã Ngọc Lâu', '5350', 3, 185);

-- Tỉnh Hoà Bình > Huyện Yên Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2773, 'Thị trấn Hàng Trạm', '5353', 3, 186),
(2774, 'Xã Lạc Sỹ', '5356', 3, 186),
(2775, 'Xã Lạc Lương', '5362', 3, 186),
(2776, 'Xã Bảo Hiệu', '5365', 3, 186),
(2777, 'Xã Đa Phúc', '5368', 3, 186),
(2778, 'Xã Hữu Lợi', '5371', 3, 186),
(2779, 'Xã Lạc Thịnh', '5374', 3, 186),
(2780, 'Xã Đoàn Kết', '5380', 3, 186),
(2781, 'Xã Phú Lai', '5383', 3, 186),
(2782, 'Xã Yên Trị', '5386', 3, 186),
(2783, 'Xã Ngọc Lương', '5389', 3, 186);

-- Tỉnh Hoà Bình > Huyện Lạc Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2784, 'Thị trấn Ba Hàng Đồi', '4981', 3, 187),
(2785, 'Thị trấn Chi Nê', '5392', 3, 187),
(2786, 'Xã Phú Nghĩa', '5395', 3, 187),
(2787, 'Xã Phú Thành', '5398', 3, 187),
(2788, 'Xã Hưng Thi', '5404', 3, 187),
(2789, 'Xã Khoan Dụ', '5413', 3, 187),
(2790, 'Xã Đồng Tâm', '5419', 3, 187),
(2791, 'Xã Yên Bồng', '5422', 3, 187),
(2792, 'Xã Thống Nhất', '5425', 3, 187),
(2793, 'Xã An Bình', '5428', 3, 187);

-- Tỉnh Thái Nguyên > Thành phố Thái Nguyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2794, 'Phường Quán Triều', '5431', 3, 188),
(2795, 'Phường Quang Vinh', '5434', 3, 188),
(2796, 'Phường Túc Duyên', '5437', 3, 188),
(2797, 'Phường Hoàng Văn Thụ', '5440', 3, 188),
(2798, 'Phường Trưng Vương', '5443', 3, 188),
(2799, 'Phường Quang Trung', '5446', 3, 188),
(2800, 'Phường Phan Đình Phùng', '5449', 3, 188),
(2801, 'Phường Tân Thịnh', '5452', 3, 188),
(2802, 'Phường Thịnh Đán', '5455', 3, 188),
(2803, 'Phường Đồng Quang', '5458', 3, 188),
(2804, 'Phường Gia Sàng', '5461', 3, 188),
(2805, 'Phường Tân Lập', '5464', 3, 188),
(2806, 'Phường Cam Giá', '5467', 3, 188),
(2807, 'Phường Phú Xá', '5470', 3, 188),
(2808, 'Phường Hương Sơn', '5473', 3, 188),
(2809, 'Phường Trung Thành', '5476', 3, 188),
(2810, 'Phường Tân Thành', '5479', 3, 188),
(2811, 'Phường Tân Long', '5482', 3, 188),
(2812, 'Xã Phúc Hà', '5485', 3, 188),
(2813, 'Xã Phúc Xuân', '5488', 3, 188),
(2814, 'Xã Quyết Thắng', '5491', 3, 188),
(2815, 'Xã Phúc Trìu', '5494', 3, 188),
(2816, 'Xã Thịnh Đức', '5497', 3, 188),
(2817, 'Phường Tích Lương', '5500', 3, 188),
(2818, 'Xã Tân Cương', '5503', 3, 188),
(2819, 'Xã Sơn Cẩm', '5653', 3, 188),
(2820, 'Phường Chùa Hang', '5659', 3, 188),
(2821, 'Xã Cao Ngạn', '5695', 3, 188),
(2822, 'Xã Linh Sơn', '5701', 3, 188),
(2823, 'Phường Đồng Bẩm', '5710', 3, 188),
(2824, 'Xã Huống Thượng', '5713', 3, 188),
(2825, 'Xã Đồng Liên', '5914', 3, 188);

-- Tỉnh Thái Nguyên > Thành phố Sông Công
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2826, 'Phường Lương Sơn', '5506', 3, 189),
(2827, 'Phường Châu Sơn', '5509', 3, 189),
(2828, 'Phường Mỏ Chè', '5512', 3, 189),
(2829, 'Phường Cải Đan', '5515', 3, 189),
(2830, 'Phường Thắng Lợi', '5518', 3, 189),
(2831, 'Phường Phố Cò', '5521', 3, 189),
(2832, 'Xã Tân Quang', '5527', 3, 189),
(2833, 'Phường Bách Quang', '5528', 3, 189),
(2834, 'Xã Bình Sơn', '5530', 3, 189),
(2835, 'Xã Bá Xuyên', '5533', 3, 189);

-- Tỉnh Thái Nguyên > Huyện Định Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2836, 'Xã Linh Thông', '5539', 3, 190),
(2837, 'Xã Lam Vỹ', '5542', 3, 190),
(2838, 'Xã Quy Kỳ', '5545', 3, 190),
(2839, 'Xã Tân Thịnh', '5548', 3, 190),
(2840, 'Xã Kim Phượng', '5551', 3, 190),
(2841, 'Xã Bảo Linh', '5554', 3, 190),
(2842, 'Xã Phúc Chu', '5560', 3, 190),
(2843, 'Xã Tân Dương', '5563', 3, 190),
(2844, 'Xã Phượng Tiến', '5566', 3, 190),
(2845, 'Thị trấn Chợ Chu', '5569', 3, 190),
(2846, 'Xã Đồng Thịnh', '5572', 3, 190),
(2847, 'Xã Định Biên', '5575', 3, 190),
(2848, 'Xã Thanh Định', '5578', 3, 190),
(2849, 'Xã Trung Hội', '5581', 3, 190),
(2850, 'Xã Trung Lương', '5584', 3, 190),
(2851, 'Xã Bình Yên', '5587', 3, 190),
(2852, 'Xã Điềm Mặc', '5590', 3, 190),
(2853, 'Xã Phú Tiến', '5593', 3, 190),
(2854, 'Xã Bộc Nhiêu', '5596', 3, 190),
(2855, 'Xã Sơn Phú', '5599', 3, 190),
(2856, 'Xã Phú Đình', '5602', 3, 190),
(2857, 'Xã Bình Thành', '5605', 3, 190);

-- Tỉnh Thái Nguyên > Huyện Phú Lương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2858, 'Thị trấn Đu', '5611', 3, 191),
(2859, 'Xã Yên Ninh', '5614', 3, 191),
(2860, 'Xã Yên Trạch', '5617', 3, 191),
(2861, 'Xã Yên Đổ', '5620', 3, 191),
(2862, 'Xã Yên Lạc', '5623', 3, 191),
(2863, 'Xã Ôn Lương', '5626', 3, 191),
(2864, 'Xã Động Đạt', '5629', 3, 191),
(2865, 'Xã Phủ Lý', '5632', 3, 191),
(2866, 'Xã Phú Đô', '5635', 3, 191),
(2867, 'Xã Hợp Thành', '5638', 3, 191),
(2868, 'Xã Tức Tranh', '5641', 3, 191),
(2869, 'Thị trấn Giang Tiên', '5644', 3, 191),
(2870, 'Xã Vô Tranh', '5647', 3, 191),
(2871, 'Xã Cổ Lũng', '5650', 3, 191);

-- Tỉnh Thái Nguyên > Huyện Đồng Hỷ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2872, 'Thị trấn Sông Cầu', '5656', 3, 192),
(2873, 'Thị trấn Trại Cau', '5662', 3, 192),
(2874, 'Xã Văn Lăng', '5665', 3, 192),
(2875, 'Xã Tân Long', '5668', 3, 192),
(2876, 'Xã Hòa Bình', '5671', 3, 192),
(2877, 'Xã Quang Sơn', '5674', 3, 192),
(2878, 'Xã Minh Lập', '5677', 3, 192),
(2879, 'Xã Văn Hán', '5680', 3, 192),
(2880, 'Xã Hóa Trung', '5683', 3, 192),
(2881, 'Xã Khe Mo', '5686', 3, 192),
(2882, 'Xã Cây Thị', '5689', 3, 192),
(2883, 'Thị trấn Hóa Thượng', '5692', 3, 192),
(2884, 'Xã Hợp Tiến', '5698', 3, 192),
(2885, 'Xã Nam Hòa', '5707', 3, 192);

-- Tỉnh Thái Nguyên > Huyện Võ Nhai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2886, 'Thị trấn Đình Cả', '5716', 3, 193),
(2887, 'Xã Sảng Mộc', '5719', 3, 193),
(2888, 'Xã Nghinh Tường', '5722', 3, 193),
(2889, 'Xã Thần Xa', '5725', 3, 193),
(2890, 'Xã Vũ Chấn', '5728', 3, 193),
(2891, 'Xã Thượng Nung', '5731', 3, 193),
(2892, 'Xã Phú Thượng', '5734', 3, 193),
(2893, 'Xã Cúc Đường', '5737', 3, 193),
(2894, 'Xã La Hiên', '5740', 3, 193),
(2895, 'Xã Lâu Thượng', '5743', 3, 193),
(2896, 'Xã Tràng Xá', '5746', 3, 193),
(2897, 'Xã Phương Giao', '5749', 3, 193),
(2898, 'Xã Liên Minh', '5752', 3, 193),
(2899, 'Xã Dân Tiến', '5755', 3, 193),
(2900, 'Xã Bình Long', '5758', 3, 193);

-- Tỉnh Thái Nguyên > Huyện Đại Từ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2901, 'Thị trấn Hùng Sơn', '5761', 3, 194),
(2902, 'Xã Phúc Lương', '5767', 3, 194),
(2903, 'Xã Minh Tiến', '5770', 3, 194),
(2904, 'Xã Yên Lãng', '5773', 3, 194),
(2905, 'Xã Đức Lương', '5776', 3, 194),
(2906, 'Xã Phú Cường', '5779', 3, 194),
(2907, 'Xã Phú Lạc', '5785', 3, 194),
(2908, 'Xã Tân Linh', '5788', 3, 194),
(2909, 'Xã Phú Thịnh', '5791', 3, 194),
(2910, 'Xã Phục Linh', '5794', 3, 194),
(2911, 'Xã Phú Xuyên', '5797', 3, 194),
(2912, 'Xã Bản Ngoại', '5800', 3, 194),
(2913, 'Xã Tiên Hội', '5803', 3, 194),
(2914, 'Xã Cù Vân', '5809', 3, 194),
(2915, 'Xã Hà Thượng', '5812', 3, 194),
(2916, 'Xã La Bằng', '5815', 3, 194),
(2917, 'Xã Hoàng Nông', '5818', 3, 194),
(2918, 'Xã Khôi Kỳ', '5821', 3, 194),
(2919, 'Xã An Khánh', '5824', 3, 194),
(2920, 'Xã Tân Thái', '5827', 3, 194),
(2921, 'Xã Bình Thuận', '5830', 3, 194),
(2922, 'Xã Lục Ba', '5833', 3, 194),
(2923, 'Xã Mỹ Yên', '5836', 3, 194),
(2924, 'Xã Văn Yên', '5842', 3, 194),
(2925, 'Xã Vạn Phú', '5845', 3, 194),
(2926, 'Xã Cát Nê', '5848', 3, 194),
(2927, 'Thị trấn Quân Chu', '5851', 3, 194);

-- Tỉnh Thái Nguyên > Thành phố Phổ Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2928, 'Phường Bãi Bông', '5854', 3, 195),
(2929, 'Phường Bắc Sơn', '5857', 3, 195),
(2930, 'Phường Ba Hàng', '5860', 3, 195),
(2931, 'Xã Phúc Tân', '5863', 3, 195),
(2932, 'Xã Phúc Thuận', '5866', 3, 195),
(2933, 'Phường Hồng Tiến', '5869', 3, 195),
(2934, 'Xã Minh Đức', '5872', 3, 195),
(2935, 'Phường Đắc Sơn', '5875', 3, 195),
(2936, 'Phường Đồng Tiến', '5878', 3, 195),
(2937, 'Xã Thành Công', '5881', 3, 195),
(2938, 'Phường Tiên Phong', '5884', 3, 195),
(2939, 'Xã Vạn Phái', '5887', 3, 195),
(2940, 'Phường Nam Tiến', '5890', 3, 195),
(2941, 'Phường Tân Hương', '5893', 3, 195),
(2942, 'Phường Đông Cao', '5896', 3, 195),
(2943, 'Phường Trung Thành', '5899', 3, 195),
(2944, 'Phường Tân Phú', '5902', 3, 195),
(2945, 'Phường Thuận Thành', '5905', 3, 195);

-- Tỉnh Thái Nguyên > Huyện Phú Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2946, 'Thị trấn Hương Sơn', '5908', 3, 196),
(2947, 'Xã Bàn Đạt', '5911', 3, 196),
(2948, 'Xã Tân Khánh', '5917', 3, 196),
(2949, 'Xã Tân Kim', '5920', 3, 196),
(2950, 'Xã Tân Thành', '5923', 3, 196),
(2951, 'Xã Đào Xá', '5926', 3, 196),
(2952, 'Xã Bảo Lý', '5929', 3, 196),
(2953, 'Xã Thượng Đình', '5932', 3, 196),
(2954, 'Xã Tân Hòa', '5935', 3, 196),
(2955, 'Xã Nhã Lộng', '5938', 3, 196),
(2956, 'Xã Điềm Thụy', '5941', 3, 196),
(2957, 'Xã Xuân Phương', '5944', 3, 196),
(2958, 'Xã Tân Đức', '5947', 3, 196),
(2959, 'Xã Úc Kỳ', '5950', 3, 196),
(2960, 'Xã Lương Phú', '5953', 3, 196),
(2961, 'Xã Nga My', '5956', 3, 196),
(2962, 'Xã Kha Sơn', '5959', 3, 196),
(2963, 'Xã Thanh Ninh', '5962', 3, 196),
(2964, 'Xã Dương Thành', '5965', 3, 196),
(2965, 'Xã Hà Châu', '5968', 3, 196);

-- Tỉnh Lạng Sơn > Thành phố Lạng Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2966, 'Phường Hoàng Văn Thụ', '5971', 3, 197),
(2967, 'Phường Tam Thanh', '5974', 3, 197),
(2968, 'Phường Vĩnh Trại', '5977', 3, 197),
(2969, 'Phường Đông Kinh', '5980', 3, 197),
(2970, 'Phường Chi Lăng', '5983', 3, 197),
(2971, 'Xã Hoàng Đồng', '5986', 3, 197),
(2972, 'Xã Quảng Lạc', '5989', 3, 197),
(2973, 'Xã Mai Pha', '5992', 3, 197);

-- Tỉnh Lạng Sơn > Huyện Tràng Định
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2974, 'Xã Khánh Long', '5998', 3, 198),
(2975, 'Xã Đoàn Kết', '6001', 3, 198),
(2976, 'Xã Quốc Khánh', '6004', 3, 198),
(2977, 'Xã Cao Minh', '6010', 3, 198),
(2978, 'Xã Chí Minh', '6013', 3, 198),
(2979, 'Xã Tri Phương', '6016', 3, 198),
(2980, 'Xã Tân Tiến', '6019', 3, 198),
(2981, 'Xã Tân Yên', '6022', 3, 198),
(2982, 'Xã Đội Cấn', '6025', 3, 198),
(2983, 'Xã Tân Minh', '6028', 3, 198),
(2984, 'Xã Kim Đồng', '6031', 3, 198),
(2985, 'Xã Chi Lăng', '6034', 3, 198),
(2986, 'Xã Trung Thành', '6037', 3, 198),
(2987, 'Thị trấn Thất Khê', '6040', 3, 198),
(2988, 'Xã Đào Viên', '6043', 3, 198),
(2989, 'Xã Đề Thám', '6046', 3, 198),
(2990, 'Xã Kháng Chiến', '6049', 3, 198),
(2991, 'Xã Hùng Sơn', '6055', 3, 198),
(2992, 'Xã Quốc Việt', '6058', 3, 198),
(2993, 'Xã Hùng Việt', '6061', 3, 198);

-- Tỉnh Lạng Sơn > Huyện Bình Gia
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(2994, 'Xã Hưng Đạo', '6067', 3, 199),
(2995, 'Xã Vĩnh Yên', '6070', 3, 199),
(2996, 'Xã Hoa Thám', '6073', 3, 199),
(2997, 'Xã Quý Hòa', '6076', 3, 199),
(2998, 'Xã Hồng Phong', '6079', 3, 199),
(2999, 'Xã Yên Lỗ', '6082', 3, 199),
(3000, 'Xã Thiện Hòa', '6085', 3, 199),
(3001, 'Xã Quang Trung', '6088', 3, 199),
(3002, 'Xã Thiện Thuật', '6091', 3, 199),
(3003, 'Xã Minh Khai', '6094', 3, 199),
(3004, 'Xã Thiện Long', '6097', 3, 199),
(3005, 'Xã Hoàng Văn Thụ', '6100', 3, 199),
(3006, 'Xã Hòa Bình', '6103', 3, 199),
(3007, 'Xã Mông Ân', '6106', 3, 199),
(3008, 'Xã Tân Hòa', '6109', 3, 199),
(3009, 'Thị trấn Bình Gia', '6112', 3, 199),
(3010, 'Xã Hồng Thái', '6115', 3, 199),
(3011, 'Xã Bình La', '6118', 3, 199),
(3012, 'Xã Tân Văn', '6121', 3, 199);

-- Tỉnh Lạng Sơn > Huyện Văn Lãng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3013, 'Thị trấn Na Sầm', '6124', 3, 200),
(3014, 'Xã Trùng Khánh', '6127', 3, 200),
(3015, 'Xã Bắc La', '6133', 3, 200),
(3016, 'Xã Thụy Hùng', '6136', 3, 200),
(3017, 'Xã Bắc Hùng', '6139', 3, 200),
(3018, 'Xã Tân Tác', '6142', 3, 200),
(3019, 'Xã Thanh Long', '6148', 3, 200),
(3020, 'Xã Hội Hoan', '6151', 3, 200),
(3021, 'Xã Bắc Việt', '6154', 3, 200),
(3022, 'Xã Hoàng Việt', '6157', 3, 200),
(3023, 'Xã Gia Miễn', '6160', 3, 200),
(3024, 'Xã Thành Hòa', '6163', 3, 200),
(3025, 'Xã Tân Thanh', '6166', 3, 200),
(3026, 'Xã Tân Mỹ', '6172', 3, 200),
(3027, 'Xã Hồng Thái', '6175', 3, 200),
(3028, 'Xã Hoàng Văn Thụ', '6178', 3, 200),
(3029, 'Xã Nhạc Kỳ', '6181', 3, 200);

-- Tỉnh Lạng Sơn > Huyện Cao Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3030, 'Thị trấn Đồng Đăng', '6184', 3, 201),
(3031, 'Thị trấn Cao Lộc', '6187', 3, 201),
(3032, 'Xã Bảo Lâm', '6190', 3, 201),
(3033, 'Xã Thanh Lòa', '6193', 3, 201),
(3034, 'Xã Cao Lâu', '6196', 3, 201),
(3035, 'Xã Thạch Đạn', '6199', 3, 201),
(3036, 'Xã Xuất Lễ', '6202', 3, 201),
(3037, 'Xã Hồng Phong', '6205', 3, 201),
(3038, 'Xã Thụy Hùng', '6208', 3, 201),
(3039, 'Xã Lộc Yên', '6211', 3, 201),
(3040, 'Xã Phú Xá', '6214', 3, 201),
(3041, 'Xã Bình Trung', '6217', 3, 201),
(3042, 'Xã Hải Yến', '6220', 3, 201),
(3043, 'Xã Hòa Cư', '6223', 3, 201),
(3044, 'Xã Hợp Thành', '6226', 3, 201),
(3045, 'Xã Công Sơn', '6232', 3, 201),
(3046, 'Xã Gia Cát', '6235', 3, 201),
(3047, 'Xã Mẫu Sơn', '6238', 3, 201),
(3048, 'Xã Xuân Long', '6241', 3, 201),
(3049, 'Xã Tân Liên', '6244', 3, 201),
(3050, 'Xã Yên Trạch', '6247', 3, 201),
(3051, 'Xã Tân Thành', '6250', 3, 201);

-- Tỉnh Lạng Sơn > Huyện Văn Quan
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3052, 'Thị trấn Văn Quan', '6253', 3, 202),
(3053, 'Xã Trấn Ninh', '6256', 3, 202),
(3054, 'Xã Liên Hội', '6268', 3, 202),
(3055, 'Xã Hòa Bình', '6274', 3, 202),
(3056, 'Xã Tú Xuyên', '6277', 3, 202),
(3057, 'Xã Điềm He', '6280', 3, 202),
(3058, 'Xã An Sơn', '6283', 3, 202),
(3059, 'Xã Khánh Khê', '6286', 3, 202),
(3060, 'Xã Lương Năng', '6292', 3, 202),
(3061, 'Xã Bình Phúc', '6298', 3, 202),
(3062, 'Xã Tân Đoàn', '6307', 3, 202),
(3063, 'Xã Tri Lễ', '6313', 3, 202),
(3064, 'Xã Tràng Phái', '6316', 3, 202),
(3065, 'Xã Yên Phúc', '6319', 3, 202),
(3066, 'Xã Hữu Lễ', '6322', 3, 202);

-- Tỉnh Lạng Sơn > Huyện Bắc Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3067, 'Thị trấn Bắc Sơn', '6325', 3, 203),
(3068, 'Xã Long Đống', '6328', 3, 203),
(3069, 'Xã Vạn Thủy', '6331', 3, 203),
(3070, 'Xã Đồng ý', '6337', 3, 203),
(3071, 'Xã Tân Tri', '6340', 3, 203),
(3072, 'Xã Bắc Quỳnh', '6343', 3, 203),
(3073, 'Xã Hưng Vũ', '6349', 3, 203),
(3074, 'Xã Tân Lập', '6352', 3, 203),
(3075, 'Xã Vũ Sơn', '6355', 3, 203),
(3076, 'Xã Chiêu Vũ', '6358', 3, 203),
(3077, 'Xã Tân Hương', '6361', 3, 203),
(3078, 'Xã Chiến Thắng', '6364', 3, 203),
(3079, 'Xã Vũ Lăng', '6367', 3, 203),
(3080, 'Xã Trấn Yên', '6370', 3, 203),
(3081, 'Xã Vũ Lễ', '6373', 3, 203),
(3082, 'Xã Nhất Hòa', '6376', 3, 203),
(3083, 'Xã Tân Thành', '6379', 3, 203),
(3084, 'Xã Nhất Tiến', '6382', 3, 203);

-- Tỉnh Lạng Sơn > Huyện Hữu Lũng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3085, 'Thị trấn Hữu Lũng', '6385', 3, 204),
(3086, 'Xã Hữu Liên', '6388', 3, 204),
(3087, 'Xã Yên Bình', '6391', 3, 204),
(3088, 'Xã Quyết Thắng', '6394', 3, 204),
(3089, 'Xã Hòa Bình', '6397', 3, 204),
(3090, 'Xã Yên Thịnh', '6400', 3, 204),
(3091, 'Xã Yên Sơn', '6403', 3, 204),
(3092, 'Xã Thiện Tân', '6406', 3, 204),
(3093, 'Xã Yên Vượng', '6412', 3, 204),
(3094, 'Xã Minh Tiến', '6415', 3, 204),
(3095, 'Xã Nhật Tiến', '6418', 3, 204),
(3096, 'Xã Thanh Sơn', '6421', 3, 204),
(3097, 'Xã Đồng Tân', '6424', 3, 204),
(3098, 'Xã Cai Kinh', '6427', 3, 204),
(3099, 'Xã Hòa Lạc', '6430', 3, 204),
(3100, 'Xã Vân Nham', '6433', 3, 204),
(3101, 'Xã Đồng Tiến', '6436', 3, 204),
(3102, 'Xã Tân Thành', '6442', 3, 204),
(3103, 'Xã Hòa Sơn', '6445', 3, 204),
(3104, 'Xã Minh Sơn', '6448', 3, 204),
(3105, 'Xã Hồ Sơn', '6451', 3, 204),
(3106, 'Xã Minh Hòa', '6457', 3, 204),
(3107, 'Xã Hòa Thắng', '6460', 3, 204);

-- Tỉnh Lạng Sơn > Huyện Chi Lăng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3108, 'Thị trấn Đồng Mỏ', '6463', 3, 205),
(3109, 'Thị trấn Chi Lăng', '6466', 3, 205),
(3110, 'Xã Vân An', '6469', 3, 205),
(3111, 'Xã Vân Thủy', '6472', 3, 205),
(3112, 'Xã Gia Lộc', '6475', 3, 205),
(3113, 'Xã Bắc Thủy', '6478', 3, 205),
(3114, 'Xã Chiến Thắng', '6481', 3, 205),
(3115, 'Xã Mai Sao', '6484', 3, 205),
(3116, 'Xã Bằng Hữu', '6487', 3, 205),
(3117, 'Xã Thượng Cường', '6490', 3, 205),
(3118, 'Xã Bằng Mạc', '6493', 3, 205),
(3119, 'Xã Nhân Lý', '6496', 3, 205),
(3120, 'Xã Lâm Sơn', '6499', 3, 205),
(3121, 'Xã Liên Sơn', '6502', 3, 205),
(3122, 'Xã Vạn Linh', '6505', 3, 205),
(3123, 'Xã Hòa Bình', '6508', 3, 205),
(3124, 'Xã Hữu Kiên', '6514', 3, 205),
(3125, 'Xã Quan Sơn', '6517', 3, 205),
(3126, 'Xã Y Tịch', '6520', 3, 205),
(3127, 'Xã Chi Lăng', '6523', 3, 205);

-- Tỉnh Lạng Sơn > Huyện Lộc Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3128, 'Thị trấn Na Dương', '6526', 3, 206),
(3129, 'Thị trấn Lộc Bình', '6529', 3, 206),
(3130, 'Xã Mẫu Sơn', '6532', 3, 206),
(3131, 'Xã Yên Khoái', '6541', 3, 206),
(3132, 'Xã Khánh Xuân', '6544', 3, 206),
(3133, 'Xã Tú Mịch', '6547', 3, 206),
(3134, 'Xã Hữu Khánh', '6550', 3, 206),
(3135, 'Xã Đồng Bục', '6553', 3, 206),
(3136, 'Xã Tam Gia', '6559', 3, 206),
(3137, 'Xã Tú Đoạn', '6562', 3, 206),
(3138, 'Xã Khuất Xá', '6565', 3, 206),
(3139, 'Xã Thống Nhất', '6577', 3, 206),
(3140, 'Xã Sàn Viên', '6589', 3, 206),
(3141, 'Xã Đông Quan', '6592', 3, 206),
(3142, 'Xã Minh Hiệp', '6595', 3, 206),
(3143, 'Xã Hữu Lân', '6598', 3, 206),
(3144, 'Xã Lợi Bác', '6601', 3, 206),
(3145, 'Xã Nam Quan', '6604', 3, 206),
(3146, 'Xã Xuân Dương', '6607', 3, 206),
(3147, 'Xã Ái Quốc', '6610', 3, 206);

-- Tỉnh Lạng Sơn > Huyện Đình Lập
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3148, 'Thị trấn Đình Lập', '6613', 3, 207),
(3149, 'Thị trấn NT Thái Bình', '6616', 3, 207),
(3150, 'Xã Bắc Xa', '6619', 3, 207),
(3151, 'Xã Bính Xá', '6622', 3, 207),
(3152, 'Xã Kiên Mộc', '6625', 3, 207),
(3153, 'Xã Đình Lập', '6628', 3, 207),
(3154, 'Xã Thái Bình', '6631', 3, 207),
(3155, 'Xã Cường Lợi', '6634', 3, 207),
(3156, 'Xã Châu Sơn', '6637', 3, 207),
(3157, 'Xã Lâm Ca', '6640', 3, 207),
(3158, 'Xã Đồng Thắng', '6643', 3, 207),
(3159, 'Xã Bắc Lãng', '6646', 3, 207);

-- Tỉnh Quảng Ninh > Thành phố Hạ Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3160, 'Phường Hà Khánh', '6649', 3, 208),
(3161, 'Phường Hà Phong', '6652', 3, 208),
(3162, 'Phường Hà Khẩu', '6655', 3, 208),
(3163, 'Phường Cao Xanh', '6658', 3, 208),
(3164, 'Phường Giếng Đáy', '6661', 3, 208),
(3165, 'Phường Hà Tu', '6664', 3, 208),
(3166, 'Phường Hà Trung', '6667', 3, 208),
(3167, 'Phường Hà Lầm', '6670', 3, 208),
(3168, 'Phường Bãi Cháy', '6673', 3, 208),
(3169, 'Phường Cao Thắng', '6676', 3, 208),
(3170, 'Phường Hùng Thắng', '6679', 3, 208),
(3171, 'Phường Trần Hưng Đạo', '6685', 3, 208),
(3172, 'Phường Hồng Hải', '6688', 3, 208),
(3173, 'Phường Hồng Gai', '6691', 3, 208),
(3174, 'Phường Bạch Đằng', '6694', 3, 208),
(3175, 'Phường Hồng Hà', '6697', 3, 208),
(3176, 'Phường Tuần Châu', '6700', 3, 208),
(3177, 'Phường Việt Hưng', '6703', 3, 208),
(3178, 'Phường Đại Yên', '6706', 3, 208),
(3179, 'Phường Hoành Bồ', '7030', 3, 208),
(3180, 'Xã Kỳ Thượng', '7033', 3, 208),
(3181, 'Xã Đồng Sơn', '7036', 3, 208),
(3182, 'Xã Tân Dân', '7039', 3, 208),
(3183, 'Xã Đồng Lâm', '7042', 3, 208),
(3184, 'Xã Hòa Bình', '7045', 3, 208),
(3185, 'Xã Vũ Oai', '7048', 3, 208),
(3186, 'Xã Dân Chủ', '7051', 3, 208),
(3187, 'Xã Quảng La', '7054', 3, 208),
(3188, 'Xã Bằng Cả', '7057', 3, 208),
(3189, 'Xã Thống Nhất', '7060', 3, 208),
(3190, 'Xã Sơn Dương', '7063', 3, 208),
(3191, 'Xã Lê Lợi', '7066', 3, 208);

-- Tỉnh Quảng Ninh > Thành phố Móng Cái
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3192, 'Phường Ka Long', '6709', 3, 209),
(3193, 'Phường Trần Phú', '6712', 3, 209),
(3194, 'Phường Ninh Dương', '6715', 3, 209),
(3195, 'Phường Trà Cổ', '6721', 3, 209),
(3196, 'Xã Hải Sơn', '6724', 3, 209),
(3197, 'Xã Bắc Sơn', '6727', 3, 209),
(3198, 'Xã Hải Đông', '6730', 3, 209),
(3199, 'Xã Hải Tiến', '6733', 3, 209),
(3200, 'Phường Hải Yên', '6736', 3, 209),
(3201, 'Xã Quảng Nghĩa', '6739', 3, 209),
(3202, 'Phường Hải Hoà', '6742', 3, 209),
(3203, 'Xã Hải Xuân', '6745', 3, 209),
(3204, 'Xã Vạn Ninh', '6748', 3, 209),
(3205, 'Phường Bình Ngọc', '6751', 3, 209),
(3206, 'Xã Vĩnh Trung', '6754', 3, 209),
(3207, 'Xã Vĩnh Thực', '6757', 3, 209);

-- Tỉnh Quảng Ninh > Thành phố Cẩm Phả
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3208, 'Phường Mông Dương', '6760', 3, 210),
(3209, 'Phường Cửa Ông', '6763', 3, 210),
(3210, 'Phường Cẩm Sơn', '6766', 3, 210),
(3211, 'Phường Cẩm Đông', '6769', 3, 210),
(3212, 'Phường Cẩm Phú', '6772', 3, 210),
(3213, 'Phường Cẩm Tây', '6775', 3, 210),
(3214, 'Phường Quang Hanh', '6778', 3, 210),
(3215, 'Phường Cẩm Thịnh', '6781', 3, 210),
(3216, 'Phường Cẩm Thủy', '6784', 3, 210),
(3217, 'Phường Cẩm Thạch', '6787', 3, 210),
(3218, 'Phường Cẩm Thành', '6790', 3, 210),
(3219, 'Phường Cẩm Trung', '6793', 3, 210),
(3220, 'Phường Cẩm Bình', '6796', 3, 210),
(3221, 'Xã Hải Hòa', '6799', 3, 210),
(3222, 'Xã Dương Huy', '6805', 3, 210);

-- Tỉnh Quảng Ninh > Thành phố Uông Bí
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3223, 'Phường Vàng Danh', '6808', 3, 211),
(3224, 'Phường Thanh Sơn', '6811', 3, 211),
(3225, 'Phường Bắc Sơn', '6814', 3, 211),
(3226, 'Phường Quang Trung', '6817', 3, 211),
(3227, 'Phường Trưng Vương', '6820', 3, 211),
(3228, 'Phường Nam Khê', '6823', 3, 211),
(3229, 'Phường Yên Thanh', '6826', 3, 211),
(3230, 'Xã Thượng Yên Công', '6829', 3, 211),
(3231, 'Phường Phương Đông', '6832', 3, 211),
(3232, 'Phường Phương Nam', '6835', 3, 211);

-- Tỉnh Quảng Ninh > Huyện Bình Liêu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3233, 'Thị trấn Bình Liêu', '6838', 3, 212),
(3234, 'Xã Hoành Mô', '6841', 3, 212),
(3235, 'Xã Đồng Tâm', '6844', 3, 212),
(3236, 'Xã Đồng Văn', '6847', 3, 212),
(3237, 'Xã Vô Ngại', '6853', 3, 212),
(3238, 'Xã Lục Hồn', '6856', 3, 212),
(3239, 'Xã Húc Động', '6859', 3, 212);

-- Tỉnh Quảng Ninh > Huyện Tiên Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3240, 'Thị trấn Tiên Yên', '6862', 3, 213),
(3241, 'Xã Hà Lâu', '6865', 3, 213),
(3242, 'Xã Đại Dực', '6868', 3, 213),
(3243, 'Xã Phong Dụ', '6871', 3, 213),
(3244, 'Xã Điền Xá', '6874', 3, 213),
(3245, 'Xã Đông Ngũ', '6877', 3, 213),
(3246, 'Xã Yên Than', '6880', 3, 213),
(3247, 'Xã Đông Hải', '6883', 3, 213),
(3248, 'Xã Hải Lạng', '6886', 3, 213),
(3249, 'Xã Tiên Lãng', '6889', 3, 213),
(3250, 'Xã Đồng Rui', '6892', 3, 213);

-- Tỉnh Quảng Ninh > Huyện Đầm Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3251, 'Thị trấn Đầm Hà', '6895', 3, 214),
(3252, 'Xã Quảng Lâm', '6898', 3, 214),
(3253, 'Xã Quảng An', '6901', 3, 214),
(3254, 'Xã Tân Bình', '6904', 3, 214),
(3255, 'Xã Dực Yên', '6910', 3, 214),
(3256, 'Xã Quảng Tân', '6913', 3, 214),
(3257, 'Xã Đầm Hà', '6916', 3, 214),
(3258, 'Xã Tân Lập', '6917', 3, 214),
(3259, 'Xã Đại Bình', '6919', 3, 214);

-- Tỉnh Quảng Ninh > Huyện Hải Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3260, 'Thị trấn Quảng Hà', '6922', 3, 215),
(3261, 'Xã Quảng Đức', '6925', 3, 215),
(3262, 'Xã Quảng Sơn', '6928', 3, 215),
(3263, 'Xã Quảng Thành', '6931', 3, 215),
(3264, 'Xã Quảng Thịnh', '6937', 3, 215),
(3265, 'Xã Quảng Minh', '6940', 3, 215),
(3266, 'Xã Quảng Chính', '6943', 3, 215),
(3267, 'Xã Quảng Long', '6946', 3, 215),
(3268, 'Xã Đường Hoa', '6949', 3, 215),
(3269, 'Xã Quảng Phong', '6952', 3, 215),
(3270, 'Xã Cái Chiên', '6967', 3, 215);

-- Tỉnh Quảng Ninh > Huyện Ba Chẽ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3271, 'Thị trấn Ba Chẽ', '6970', 3, 216),
(3272, 'Xã Thanh Sơn', '6973', 3, 216),
(3273, 'Xã Thanh Lâm', '6976', 3, 216),
(3274, 'Xã Đạp Thanh', '6979', 3, 216),
(3275, 'Xã Nam Sơn', '6982', 3, 216),
(3276, 'Xã Lương Minh', '6985', 3, 216),
(3277, 'Xã Đồn Đạc', '6988', 3, 216);

-- Tỉnh Quảng Ninh > Huyện Vân Đồn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3278, 'Thị trấn Cái Rồng', '6994', 3, 217),
(3279, 'Xã Đài Xuyên', '6997', 3, 217),
(3280, 'Xã Bình Dân', '7000', 3, 217),
(3281, 'Xã Vạn Yên', '7003', 3, 217),
(3282, 'Xã Minh Châu', '7006', 3, 217),
(3283, 'Xã Đoàn Kết', '7009', 3, 217),
(3284, 'Xã Hạ Long', '7012', 3, 217),
(3285, 'Xã Đông Xá', '7015', 3, 217),
(3286, 'Xã Bản Sen', '7018', 3, 217),
(3287, 'Xã Thắng Lợi', '7021', 3, 217),
(3288, 'Xã Quan Lạn', '7024', 3, 217),
(3289, 'Xã Ngọc Vừng', '7027', 3, 217);

-- Tỉnh Quảng Ninh > Thành phố Đông Triều
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3290, 'Phường Mạo Khê', '7069', 3, 218),
(3291, 'Xã An Sinh', '7075', 3, 218),
(3292, 'Xã Tràng Lương', '7078', 3, 218),
(3293, 'Phường Bình Khê', '7081', 3, 218),
(3294, 'Xã Việt Dân', '7084', 3, 218),
(3295, 'Phường Bình Dương', '7090', 3, 218),
(3296, 'Phường Đức Chính', '7093', 3, 218),
(3297, 'Phường Tràng An', '7096', 3, 218),
(3298, 'Xã Nguyễn Huệ', '7099', 3, 218),
(3299, 'Phường Thủy An', '7102', 3, 218),
(3300, 'Phường Xuân Sơn', '7105', 3, 218),
(3301, 'Xã Hồng Thái Tây', '7108', 3, 218),
(3302, 'Xã Hồng Thái Đông', '7111', 3, 218),
(3303, 'Phường Hoàng Quế', '7114', 3, 218),
(3304, 'Phường Yên Thọ', '7117', 3, 218),
(3305, 'Phường Hồng Phong', '7120', 3, 218),
(3306, 'Phường Kim Sơn', '7123', 3, 218),
(3307, 'Phường Hưng Đạo', '7126', 3, 218),
(3308, 'Phường Yên Đức', '7129', 3, 218);

-- Tỉnh Quảng Ninh > Thị xã Quảng Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3309, 'Phường Quảng Yên', '7132', 3, 219),
(3310, 'Phường Đông Mai', '7135', 3, 219),
(3311, 'Phường Minh Thành', '7138', 3, 219),
(3312, 'Xã Sông Khoai', '7144', 3, 219),
(3313, 'Xã Hiệp Hòa', '7147', 3, 219),
(3314, 'Phường Cộng Hòa', '7150', 3, 219),
(3315, 'Xã Tiền An', '7153', 3, 219),
(3316, 'Xã Hoàng Tân', '7156', 3, 219),
(3317, 'Phường Tân An', '7159', 3, 219),
(3318, 'Phường Yên Giang', '7162', 3, 219),
(3319, 'Phường Nam Hoà', '7165', 3, 219),
(3320, 'Phường Hà An', '7168', 3, 219),
(3321, 'Xã Cẩm La', '7171', 3, 219),
(3322, 'Phường Phong Hải', '7174', 3, 219),
(3323, 'Phường Yên Hải', '7177', 3, 219),
(3324, 'Xã Liên Hòa', '7180', 3, 219),
(3325, 'Phường Phong Cốc', '7183', 3, 219),
(3326, 'Xã Liên Vị', '7186', 3, 219),
(3327, 'Xã Tiền Phong', '7189', 3, 219);

-- Tỉnh Quảng Ninh > Huyện Cô Tô
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3328, 'Thị trấn Cô Tô', '7192', 3, 220),
(3329, 'Xã Đồng Tiến', '7195', 3, 220),
(3330, 'Xã Thanh Lân', '7198', 3, 220);

-- Tỉnh Bắc Giang > Thành phố Bắc Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3331, 'Phường Thọ Xương', '7201', 3, 221),
(3332, 'Phường Ngô Quyền', '7207', 3, 221),
(3333, 'Phường Hoàng Văn Thụ', '7210', 3, 221),
(3334, 'Phường Trần Phú', '7213', 3, 221),
(3335, 'Phường Mỹ Độ', '7216', 3, 221),
(3336, 'Phường Song Mai', '7222', 3, 221),
(3337, 'Phường Xương Giang', '7225', 3, 221),
(3338, 'Phường Đa Mai', '7228', 3, 221),
(3339, 'Phường Dĩnh Kế', '7231', 3, 221),
(3340, 'Phường Dĩnh Trì', '7441', 3, 221),
(3341, 'Phường Nham Biền', '7681', 3, 221),
(3342, 'Phường Tân An', '7682', 3, 221),
(3343, 'Phường Tân Mỹ', '7687', 3, 221),
(3344, 'Phường Hương Gián', '7690', 3, 221),
(3345, 'Xã Tân An', '7693', 3, 221),
(3346, 'Phường Đồng Sơn', '7696', 3, 221),
(3347, 'Phường Tân Tiến', '7699', 3, 221),
(3348, 'Xã Quỳnh Sơn', '7702', 3, 221),
(3349, 'Phường Song Khê', '7705', 3, 221),
(3350, 'Phường Nội Hoàng', '7708', 3, 221),
(3351, 'Phường Tiền Phong', '7711', 3, 221),
(3352, 'Xã Xuân Phú', '7714', 3, 221),
(3353, 'Phường Tân Liễu', '7717', 3, 221),
(3354, 'Xã Trí Yên', '7720', 3, 221),
(3355, 'Xã Lãng Sơn', '7723', 3, 221),
(3356, 'Xã Yên Lư', '7726', 3, 221),
(3357, 'Xã Tiến Dũng', '7729', 3, 221),
(3358, 'Xã Nham Sơn', '7732', 3, 221),
(3359, 'Xã Đức Giang', '7735', 3, 221),
(3360, 'Phường Cảnh Thụy', '7738', 3, 221),
(3361, 'Xã Tư Mại', '7741', 3, 221),
(3362, 'Xã Thắng Cương', '7744', 3, 221),
(3363, 'Xã Đồng Việt', '7747', 3, 221),
(3364, 'Xã Đồng Phúc', '7750', 3, 221);

-- Tỉnh Bắc Giang > Huyện Yên Thế
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3365, 'Xã Đồng Tiến', '7243', 3, 222),
(3366, 'Xã Canh Nậu', '7246', 3, 222),
(3367, 'Xã Xuân Lương', '7249', 3, 222),
(3368, 'Xã Tam Tiến', '7252', 3, 222),
(3369, 'Xã Đồng Vương', '7255', 3, 222),
(3370, 'Xã Đồng Hưu', '7258', 3, 222),
(3371, 'Xã Đồng Tâm', '7260', 3, 222),
(3372, 'Xã Tân Hiệp', '7261', 3, 222),
(3373, 'Xã Tiến Thắng', '7264', 3, 222),
(3374, 'Xã Đồng Lạc', '7270', 3, 222),
(3375, 'Xã Đông Sơn', '7273', 3, 222),
(3376, 'Xã Hương Vĩ', '7279', 3, 222),
(3377, 'Xã Đồng Kỳ', '7282', 3, 222),
(3378, 'Xã An Thượng', '7285', 3, 222),
(3379, 'Thị trấn Phồn Xương', '7288', 3, 222),
(3380, 'Xã Tân Sỏi', '7291', 3, 222),
(3381, 'Thị trấn Bố Hạ', '7294', 3, 222);

-- Tỉnh Bắc Giang > Huyện Tân Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3382, 'Thị trấn Nhã Nam', '7306', 3, 223),
(3383, 'Xã Tân Trung', '7309', 3, 223),
(3384, 'Xã Quang Trung', '7315', 3, 223),
(3385, 'Xã An Dương', '7321', 3, 223),
(3386, 'Xã Phúc Hòa', '7324', 3, 223),
(3387, 'Xã Liên Sơn', '7327', 3, 223),
(3388, 'Xã Hợp Đức', '7330', 3, 223),
(3389, 'Xã Lam Sơn', '7333', 3, 223),
(3390, 'Xã Cao Xá', '7336', 3, 223),
(3391, 'Thị trấn Cao Thượng', '7339', 3, 223),
(3392, 'Xã Việt Ngọc', '7342', 3, 223),
(3393, 'Xã Song Vân', '7345', 3, 223),
(3394, 'Xã Ngọc Châu', '7348', 3, 223),
(3395, 'Xã Ngọc Vân', '7351', 3, 223),
(3396, 'Xã Việt Lập', '7354', 3, 223),
(3397, 'Xã Liên Chung', '7357', 3, 223),
(3398, 'Xã Ngọc Thiện', '7360', 3, 223),
(3399, 'Xã Ngọc Lý', '7363', 3, 223),
(3400, 'Xã Quế Nham', '7366', 3, 223);

-- Tỉnh Bắc Giang > Huyện Lạng Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3401, 'Thị trấn Vôi', '7375', 3, 224),
(3402, 'Xã Nghĩa Hòa', '7378', 3, 224),
(3403, 'Xã Nghĩa Hưng', '7381', 3, 224),
(3404, 'Xã Quang Thịnh', '7384', 3, 224),
(3405, 'Xã Hương Sơn', '7387', 3, 224),
(3406, 'Xã Đào Mỹ', '7390', 3, 224),
(3407, 'Xã Tiên Lục', '7393', 3, 224),
(3408, 'Xã An Hà', '7396', 3, 224),
(3409, 'Thị trấn Kép', '7399', 3, 224),
(3410, 'Xã Hương Lạc', '7405', 3, 224),
(3411, 'Xã Dương Đức', '7408', 3, 224),
(3412, 'Xã Tân Thanh', '7411', 3, 224),
(3413, 'Xã Tân Hưng', '7417', 3, 224),
(3414, 'Xã Mỹ Thái', '7420', 3, 224),
(3415, 'Xã Xương Lâm', '7426', 3, 224),
(3416, 'Xã Xuân Hương', '7429', 3, 224),
(3417, 'Xã Tân Dĩnh', '7432', 3, 224),
(3418, 'Xã Đại Lâm', '7435', 3, 224),
(3419, 'Xã Thái Đào', '7438', 3, 224);

-- Tỉnh Bắc Giang > Huyện Lục Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3420, 'Thị trấn Đồi Ngô', '7444', 3, 225),
(3421, 'Xã Đông Hưng', '7450', 3, 225),
(3422, 'Xã Đông Phú', '7453', 3, 225),
(3423, 'Xã Tam Dị', '7456', 3, 225),
(3424, 'Xã Bảo Sơn', '7459', 3, 225),
(3425, 'Xã Bảo Đài', '7462', 3, 225),
(3426, 'Xã Thanh Lâm', '7465', 3, 225),
(3427, 'Xã Tiên Nha', '7468', 3, 225),
(3428, 'Xã Trường Giang', '7471', 3, 225),
(3429, 'Thị trấn Phương Sơn', '7477', 3, 225),
(3430, 'Xã Chu Điện', '7480', 3, 225),
(3431, 'Xã Cương Sơn', '7483', 3, 225),
(3432, 'Xã Nghĩa Phương', '7486', 3, 225),
(3433, 'Xã Vô Tranh', '7489', 3, 225),
(3434, 'Xã Bình Sơn', '7492', 3, 225),
(3435, 'Xã Lan Mẫu', '7495', 3, 225),
(3436, 'Xã Yên Sơn', '7498', 3, 225),
(3437, 'Xã Khám Lạng', '7501', 3, 225),
(3438, 'Xã Huyền Sơn', '7504', 3, 225),
(3439, 'Xã Trường Sơn', '7507', 3, 225),
(3440, 'Xã Lục Sơn', '7510', 3, 225),
(3441, 'Xã Bắc Lũng', '7513', 3, 225),
(3442, 'Xã Cẩm Lý', '7519', 3, 225),
(3443, 'Xã Đan Hội', '7522', 3, 225);

-- Tỉnh Bắc Giang > Huyện Lục Ngạn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3444, 'Xã Cấm Sơn', '7528', 3, 226),
(3445, 'Xã Tân Sơn', '7531', 3, 226),
(3446, 'Xã Phong Minh', '7534', 3, 226),
(3447, 'Xã Phong Vân', '7537', 3, 226),
(3448, 'Xã Xa Lý', '7540', 3, 226),
(3449, 'Xã Hộ Đáp', '7543', 3, 226),
(3450, 'Xã Sơn Hải', '7546', 3, 226),
(3451, 'Xã Biên Sơn', '7555', 3, 226),
(3452, 'Xã Kim Sơn', '7564', 3, 226),
(3453, 'Xã Tân Hoa', '7567', 3, 226),
(3454, 'Xã Giáp Sơn', '7570', 3, 226),
(3455, 'Thị trấn Biển Động', '7573', 3, 226),
(3456, 'Thị trấn Phì Điền', '7582', 3, 226),
(3457, 'Xã Tân Quang', '7588', 3, 226),
(3458, 'Xã Đồng Cốc', '7591', 3, 226),
(3459, 'Xã Tân Lập', '7594', 3, 226),
(3460, 'Xã Phú Nhuận', '7597', 3, 226),
(3461, 'Xã Tân Mộc', '7606', 3, 226),
(3462, 'Xã Đèo Gia', '7609', 3, 226);

-- Tỉnh Bắc Giang > Huyện Sơn Động
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3463, 'Thị trấn An Châu', '7615', 3, 227),
(3464, 'Thị trấn Tây Yên Tử', '7616', 3, 227),
(3465, 'Xã Vân Sơn', '7621', 3, 227),
(3466, 'Xã Hữu Sản', '7624', 3, 227),
(3467, 'Xã Đại Sơn', '7627', 3, 227),
(3468, 'Xã Phúc Sơn', '7630', 3, 227),
(3469, 'Xã Giáo Liêm', '7636', 3, 227),
(3470, 'Xã Cẩm Đàn', '7642', 3, 227),
(3471, 'Xã An Lạc', '7645', 3, 227),
(3472, 'Xã Vĩnh An', '7648', 3, 227),
(3473, 'Xã Yên Định', '7651', 3, 227),
(3474, 'Xã Lệ Viễn', '7654', 3, 227),
(3475, 'Xã An Bá', '7660', 3, 227),
(3476, 'Xã Tuấn Đạo', '7663', 3, 227),
(3477, 'Xã Dương Hưu', '7666', 3, 227),
(3478, 'Xã Long Sơn', '7672', 3, 227),
(3479, 'Xã Thanh Luận', '7678', 3, 227);

-- Tỉnh Bắc Giang > Thị xã Việt Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3480, 'Xã Thượng Lan', '7759', 3, 228),
(3481, 'Xã Việt Tiến', '7762', 3, 228),
(3482, 'Xã Nghĩa Trung', '7765', 3, 228),
(3483, 'Xã Minh Đức', '7768', 3, 228),
(3484, 'Xã Hương Mai', '7771', 3, 228),
(3485, 'Phường Tự Lạn', '7774', 3, 228),
(3486, 'Phường Bích Động', '7777', 3, 228),
(3487, 'Xã Trung Sơn', '7780', 3, 228),
(3488, 'Phường Hồng Thái', '7783', 3, 228),
(3489, 'Xã Tiên Sơn', '7786', 3, 228),
(3490, 'Phường Tăng Tiến', '7789', 3, 228),
(3491, 'Phường Quảng Minh', '7792', 3, 228),
(3492, 'Phường Nếnh', '7795', 3, 228),
(3493, 'Phường Ninh Sơn', '7798', 3, 228),
(3494, 'Phường Vân Trung', '7801', 3, 228),
(3495, 'Xã Vân Hà', '7804', 3, 228),
(3496, 'Phường Quang Châu', '7807', 3, 228);

-- Tỉnh Bắc Giang > Huyện Hiệp Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3497, 'Xã Đồng Tiến', '7816', 3, 229),
(3498, 'Xã Hoàng Vân', '7822', 3, 229),
(3499, 'Xã Toàn Thắng', '7825', 3, 229),
(3500, 'Xã Ngọc Sơn', '7831', 3, 229),
(3501, 'Thị trấn Thắng', '7840', 3, 229),
(3502, 'Xã Sơn Thịnh', '7843', 3, 229),
(3503, 'Xã Lương Phong', '7846', 3, 229),
(3504, 'Xã Hùng Thái', '7849', 3, 229),
(3505, 'Xã Thường Thắng', '7855', 3, 229),
(3506, 'Xã Hợp Thịnh', '7858', 3, 229),
(3507, 'Xã Danh Thắng', '7861', 3, 229),
(3508, 'Xã Mai Trung', '7864', 3, 229),
(3509, 'Xã Đoan Bái', '7867', 3, 229),
(3510, 'Thị trấn Bắc Lý', '7870', 3, 229),
(3511, 'Xã Xuân Cẩm', '7873', 3, 229),
(3512, 'Xã Hương Lâm', '7876', 3, 229),
(3513, 'Xã Đông Lỗ', '7879', 3, 229),
(3514, 'Xã Châu Minh', '7882', 3, 229),
(3515, 'Xã Mai Đình', '7885', 3, 229);

-- Tỉnh Bắc Giang > Thị xã Chũ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3516, 'Phường Chũ', '7525', 3, 230),
(3517, 'Phường Thanh Hải', '7549', 3, 230),
(3518, 'Xã Kiên Lao', '7552', 3, 230),
(3519, 'Xã Kiên Thành', '7558', 3, 230),
(3520, 'Phường Hồng Giang', '7561', 3, 230),
(3521, 'Xã Quý Sơn', '7576', 3, 230),
(3522, 'Phường Trù Hựu', '7579', 3, 230),
(3523, 'Xã Mỹ An', '7600', 3, 230),
(3524, 'Xã Nam Dương', '7603', 3, 230),
(3525, 'Phường Phượng Sơn', '7612', 3, 230);

-- Tỉnh Phú Thọ > Thành phố Việt Trì
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3526, 'Phường Dữu Lâu', '7888', 3, 231),
(3527, 'Phường Nông Trang', '7894', 3, 231),
(3528, 'Phường Tân Dân', '7897', 3, 231),
(3529, 'Phường Gia Cẩm', '7900', 3, 231),
(3530, 'Phường Tiên Cát', '7903', 3, 231),
(3531, 'Phường Thọ Sơn', '7906', 3, 231),
(3532, 'Phường Thanh Miếu', '7909', 3, 231),
(3533, 'Phường Bạch Hạc', '7912', 3, 231),
(3534, 'Phường Vân Phú', '7918', 3, 231),
(3535, 'Xã Phượng Lâu', '7921', 3, 231),
(3536, 'Xã Thụy Vân', '7924', 3, 231),
(3537, 'Phường Minh Phương', '7927', 3, 231),
(3538, 'Xã Trưng Vương', '7930', 3, 231),
(3539, 'Phường Minh Nông', '7933', 3, 231),
(3540, 'Xã Sông Lô', '7936', 3, 231),
(3541, 'Xã Kim Đức', '8281', 3, 231),
(3542, 'Xã Hùng Lô', '8287', 3, 231),
(3543, 'Xã Hy Cương', '8503', 3, 231),
(3544, 'Xã Chu Hóa', '8506', 3, 231),
(3545, 'Xã Thanh Đình', '8515', 3, 231);

-- Tỉnh Phú Thọ > Thị xã Phú Thọ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3546, 'Phường Hùng Vương', '7942', 3, 232),
(3547, 'Phường Phong Châu', '7945', 3, 232),
(3548, 'Phường Âu Cơ', '7948', 3, 232),
(3549, 'Xã Hà Lộc', '7951', 3, 232),
(3550, 'Xã Phú Hộ', '7954', 3, 232),
(3551, 'Xã Văn Lung', '7957', 3, 232),
(3552, 'Xã Thanh Minh', '7960', 3, 232),
(3553, 'Xã Hà Thạch', '7963', 3, 232),
(3554, 'Phường Thanh Vinh', '7966', 3, 232);

-- Tỉnh Phú Thọ > Huyện Đoan Hùng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3555, 'Thị trấn Đoan Hùng', '7969', 3, 233),
(3556, 'Xã Hùng Xuyên', '7975', 3, 233),
(3557, 'Xã Bằng Luân', '7981', 3, 233),
(3558, 'Xã Phú Lâm', '7987', 3, 233),
(3559, 'Xã Bằng Doãn', '7996', 3, 233),
(3560, 'Xã Chí Đám', '7999', 3, 233),
(3561, 'Xã Phúc Lai', '8005', 3, 233),
(3562, 'Xã Ngọc Quan', '8008', 3, 233),
(3563, 'Xã Hợp Nhất', '8014', 3, 233),
(3564, 'Xã Tây Cốc', '8023', 3, 233),
(3565, 'Xã Hùng Long', '8035', 3, 233),
(3566, 'Xã Yên Kiện', '8038', 3, 233),
(3567, 'Xã Chân Mộng', '8044', 3, 233),
(3568, 'Xã Ca Đình', '8050', 3, 233);

-- Tỉnh Phú Thọ > Huyện Hạ Hoà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3569, 'Thị trấn Hạ Hoà', '8053', 3, 234),
(3570, 'Xã Đại Phạm', '8056', 3, 234),
(3571, 'Xã Đan Thượng', '8062', 3, 234),
(3572, 'Xã Hà Lương', '8065', 3, 234),
(3573, 'Xã Tứ Hiệp', '8071', 3, 234),
(3574, 'Xã Hiền Lương', '8080', 3, 234),
(3575, 'Xã Phương Viên', '8089', 3, 234),
(3576, 'Xã Gia Điền', '8092', 3, 234),
(3577, 'Xã Ấm Hạ', '8095', 3, 234),
(3578, 'Xã Hương Xạ', '8104', 3, 234),
(3579, 'Xã Xuân Áng', '8110', 3, 234),
(3580, 'Xã Yên Kỳ', '8113', 3, 234),
(3581, 'Xã Minh Hạc', '8119', 3, 234),
(3582, 'Xã Lang Sơn', '8122', 3, 234),
(3583, 'Xã Bằng Giã', '8125', 3, 234),
(3584, 'Xã Yên Luật', '8128', 3, 234),
(3585, 'Xã Vô Tranh', '8131', 3, 234),
(3586, 'Xã Văn Lang', '8134', 3, 234),
(3587, 'Xã Minh Côi', '8140', 3, 234),
(3588, 'Xã Vĩnh Chân', '8143', 3, 234);

-- Tỉnh Phú Thọ > Huyện Thanh Ba
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3589, 'Thị trấn Thanh Ba', '8152', 3, 235),
(3590, 'Xã Vân Lĩnh', '8156', 3, 235),
(3591, 'Xã Đông Lĩnh', '8158', 3, 235),
(3592, 'Xã Đại An', '8161', 3, 235),
(3593, 'Xã Hanh Cù', '8164', 3, 235),
(3594, 'Xã Đồng Xuân', '8170', 3, 235),
(3595, 'Xã Quảng Yên', '8173', 3, 235),
(3596, 'Xã Ninh Dân', '8179', 3, 235),
(3597, 'Xã Võ Lao', '8194', 3, 235),
(3598, 'Xã Khải Xuân', '8197', 3, 235),
(3599, 'Xã Mạn Lạn', '8200', 3, 235),
(3600, 'Xã Hoàng Cương', '8203', 3, 235),
(3601, 'Xã Chí Tiên', '8206', 3, 235),
(3602, 'Xã Đông Thành', '8209', 3, 235),
(3603, 'Xã Sơn Cương', '8215', 3, 235),
(3604, 'Xã Thanh Hà', '8218', 3, 235),
(3605, 'Xã Đỗ Sơn', '8221', 3, 235),
(3606, 'Xã Đỗ Xuyên', '8224', 3, 235),
(3607, 'Xã Lương Lỗ', '8227', 3, 235);

-- Tỉnh Phú Thọ > Huyện Phù Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3608, 'Thị trấn Phong Châu', '8230', 3, 236),
(3609, 'Xã Phú Mỹ', '8233', 3, 236),
(3610, 'Xã Lệ Mỹ', '8234', 3, 236),
(3611, 'Xã Liên Hoa', '8236', 3, 236),
(3612, 'Xã Trạm Thản', '8239', 3, 236),
(3613, 'Xã Trị Quận', '8242', 3, 236),
(3614, 'Xã Trung Giáp', '8245', 3, 236),
(3615, 'Xã Tiên Phú', '8248', 3, 236),
(3616, 'Xã Hạ Giáp', '8251', 3, 236),
(3617, 'Xã Bảo Thanh', '8254', 3, 236),
(3618, 'Xã Phú Lộc', '8257', 3, 236),
(3619, 'Xã Gia Thanh', '8260', 3, 236),
(3620, 'Xã Tiên Du', '8263', 3, 236),
(3621, 'Xã Phú Nham', '8266', 3, 236),
(3622, 'Xã An Đạo', '8272', 3, 236),
(3623, 'Xã Bình Phú', '8275', 3, 236),
(3624, 'Xã Phù Ninh', '8278', 3, 236);

-- Tỉnh Phú Thọ > Huyện Yên Lập
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3625, 'Thị trấn Yên Lập', '8290', 3, 237),
(3626, 'Xã Mỹ Lung', '8293', 3, 237),
(3627, 'Xã Mỹ Lương', '8296', 3, 237),
(3628, 'Xã Lương Sơn', '8299', 3, 237),
(3629, 'Xã Xuân An', '8302', 3, 237),
(3630, 'Xã Xuân Viên', '8305', 3, 237),
(3631, 'Xã Xuân Thủy', '8308', 3, 237),
(3632, 'Xã Trung Sơn', '8311', 3, 237),
(3633, 'Xã Hưng Long', '8314', 3, 237),
(3634, 'Xã Nga Hoàng', '8317', 3, 237),
(3635, 'Xã Đồng Lạc', '8320', 3, 237),
(3636, 'Xã Thượng Long', '8323', 3, 237),
(3637, 'Xã Đồng Thịnh', '8326', 3, 237),
(3638, 'Xã Phúc Khánh', '8329', 3, 237),
(3639, 'Xã Minh Hòa', '8332', 3, 237),
(3640, 'Xã Ngọc Lập', '8335', 3, 237),
(3641, 'Xã Ngọc Đồng', '8338', 3, 237);

-- Tỉnh Phú Thọ > Huyện Cẩm Khê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3642, 'Thị trấn Cẩm Khê', '8341', 3, 238),
(3643, 'Xã Tiên Lương', '8344', 3, 238),
(3644, 'Xã Minh Thắng', '8350', 3, 238),
(3645, 'Xã Minh Tân', '8353', 3, 238),
(3646, 'Xã Phượng Vĩ', '8356', 3, 238),
(3647, 'Xã Tùng Khê', '8374', 3, 238),
(3648, 'Xã Tam Sơn', '8377', 3, 238),
(3649, 'Xã Văn Bán', '8380', 3, 238),
(3650, 'Xã Phong Thịnh', '8389', 3, 238),
(3651, 'Xã Phú Khê', '8398', 3, 238),
(3652, 'Xã Hương Lung', '8401', 3, 238),
(3653, 'Xã Nhật Tiến', '8413', 3, 238),
(3654, 'Xã Hùng Việt', '8416', 3, 238),
(3655, 'Xã Yên Dưỡng', '8422', 3, 238),
(3656, 'Xã Điêu Lương', '8428', 3, 238),
(3657, 'Xã Đồng Lương', '8431', 3, 238);

-- Tỉnh Phú Thọ > Huyện Tam Nông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3658, 'Thị trấn Hưng Hoá', '8434', 3, 239),
(3659, 'Xã Hiền Quan', '8440', 3, 239),
(3660, 'Xã Bắc Sơn', '8443', 3, 239),
(3661, 'Xã Thanh Uyên', '8446', 3, 239),
(3662, 'Xã Lam Sơn', '8461', 3, 239),
(3663, 'Xã Vạn Xuân', '8467', 3, 239),
(3664, 'Xã Quang Húc', '8470', 3, 239),
(3665, 'Xã Hương Nộn', '8473', 3, 239),
(3666, 'Xã Tề Lễ', '8476', 3, 239),
(3667, 'Xã Thọ Văn', '8479', 3, 239),
(3668, 'Xã Dị Nậu', '8482', 3, 239),
(3669, 'Xã Dân Quyền', '8491', 3, 239);

-- Tỉnh Phú Thọ > Huyện Lâm Thao
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3670, 'Thị trấn Lâm Thao', '8494', 3, 240),
(3671, 'Xã Tiên Kiên', '8497', 3, 240),
(3672, 'Thị trấn Hùng Sơn', '8498', 3, 240),
(3673, 'Xã Xuân Lũng', '8500', 3, 240),
(3674, 'Xã Xuân Huy', '8509', 3, 240),
(3675, 'Xã Thạch Sơn', '8512', 3, 240),
(3676, 'Xã Sơn Vi', '8518', 3, 240),
(3677, 'Xã Phùng Nguyên', '8521', 3, 240),
(3678, 'Xã Cao Xá', '8527', 3, 240),
(3679, 'Xã Vĩnh Lại', '8533', 3, 240),
(3680, 'Xã Tứ Xã', '8536', 3, 240),
(3681, 'Xã Bản Nguyên', '8539', 3, 240);

-- Tỉnh Phú Thọ > Huyện Thanh Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3682, 'Thị trấn Thanh Sơn', '8542', 3, 241),
(3683, 'Xã Sơn Hùng', '8563', 3, 241),
(3684, 'Xã Địch Quả', '8572', 3, 241),
(3685, 'Xã Giáp Lai', '8575', 3, 241),
(3686, 'Xã Thục Luyện', '8581', 3, 241),
(3687, 'Xã Võ Miếu', '8584', 3, 241),
(3688, 'Xã Thạch Khoán', '8587', 3, 241),
(3689, 'Xã Cự Thắng', '8602', 3, 241),
(3690, 'Xã Tất Thắng', '8605', 3, 241),
(3691, 'Xã Văn Miếu', '8611', 3, 241),
(3692, 'Xã Cự Đồng', '8614', 3, 241),
(3693, 'Xã Thắng Sơn', '8623', 3, 241),
(3694, 'Xã Tân Minh', '8629', 3, 241),
(3695, 'Xã Hương Cần', '8632', 3, 241),
(3696, 'Xã Khả Cửu', '8635', 3, 241),
(3697, 'Xã Đông Cửu', '8638', 3, 241),
(3698, 'Xã Tân Lập', '8641', 3, 241),
(3699, 'Xã Yên Lãng', '8644', 3, 241),
(3700, 'Xã Yên Lương', '8647', 3, 241),
(3701, 'Xã Thượng Cửu', '8650', 3, 241),
(3702, 'Xã Lương Nha', '8653', 3, 241),
(3703, 'Xã Yên Sơn', '8656', 3, 241),
(3704, 'Xã Tinh Nhuệ', '8659', 3, 241);

-- Tỉnh Phú Thọ > Huyện Thanh Thuỷ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3705, 'Xã Đào Xá', '8662', 3, 242),
(3706, 'Xã Thạch Đồng', '8665', 3, 242),
(3707, 'Xã Xuân Lộc', '8668', 3, 242),
(3708, 'Xã Tân Phương', '8671', 3, 242),
(3709, 'Thị trấn Thanh Thủy', '8674', 3, 242),
(3710, 'Xã Sơn Thủy', '8677', 3, 242),
(3711, 'Xã Bảo Yên', '8680', 3, 242),
(3712, 'Xã Đoan Hạ', '8683', 3, 242),
(3713, 'Xã Đồng Trung', '8686', 3, 242),
(3714, 'Xã Hoàng Xá', '8689', 3, 242),
(3715, 'Xã Tu Vũ', '8701', 3, 242);

-- Tỉnh Phú Thọ > Huyện Tân Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3716, 'Xã Thu Cúc', '8545', 3, 243),
(3717, 'Xã Thạch Kiệt', '8548', 3, 243),
(3718, 'Xã Thu Ngạc', '8551', 3, 243),
(3719, 'Xã Kiệt Sơn', '8554', 3, 243),
(3720, 'Xã Đồng Sơn', '8557', 3, 243),
(3721, 'Xã Lai Đồng', '8560', 3, 243),
(3722, 'Thị trấn Tân Phú', '8566', 3, 243),
(3723, 'Xã Mỹ Thuận', '8569', 3, 243),
(3724, 'Xã Tân Sơn', '8578', 3, 243),
(3725, 'Xã Xuân Đài', '8590', 3, 243),
(3726, 'Xã Minh Đài', '8593', 3, 243),
(3727, 'Xã Văn Luông', '8596', 3, 243),
(3728, 'Xã Xuân Sơn', '8599', 3, 243),
(3729, 'Xã Long Cốc', '8608', 3, 243),
(3730, 'Xã Kim Thượng', '8617', 3, 243),
(3731, 'Xã Tam Thanh', '8620', 3, 243),
(3732, 'Xã Vinh Tiền', '8626', 3, 243);

-- Tỉnh Vĩnh Phúc > Thành phố Vĩnh Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3733, 'Phường Tích Sơn', '8707', 3, 244),
(3734, 'Phường Liên Bảo', '8710', 3, 244),
(3735, 'Phường Hội Hợp', '8713', 3, 244),
(3736, 'Phường Đống Đa', '8716', 3, 244),
(3737, 'Phường Ngô Quyền', '8719', 3, 244),
(3738, 'Phường Đồng Tâm', '8722', 3, 244),
(3739, 'Phường Định Trung', '8725', 3, 244),
(3740, 'Phường Khai Quang', '8728', 3, 244),
(3741, 'Xã Thanh Trù', '8731', 3, 244);

-- Tỉnh Vĩnh Phúc > Thành phố Phúc Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3742, 'Phường Hùng Vương', '8737', 3, 245),
(3743, 'Phường Hai Bà Trưng', '8740', 3, 245),
(3744, 'Phường Phúc Thắng', '8743', 3, 245),
(3745, 'Phường Xuân Hoà', '8746', 3, 245),
(3746, 'Phường Đồng Xuân', '8747', 3, 245),
(3747, 'Xã Ngọc Thanh', '8749', 3, 245),
(3748, 'Xã Cao Minh', '8752', 3, 245),
(3749, 'Phường Nam Viêm', '8755', 3, 245),
(3750, 'Phường Tiền Châu', '8758', 3, 245);

-- Tỉnh Vĩnh Phúc > Huyện Lập Thạch
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3751, 'Thị trấn Lập Thạch', '8761', 3, 246),
(3752, 'Xã Quang Sơn', '8764', 3, 246),
(3753, 'Xã Ngọc Mỹ', '8767', 3, 246),
(3754, 'Xã Hợp Lý', '8770', 3, 246),
(3755, 'Xã Bắc Bình', '8785', 3, 246),
(3756, 'Xã Thái Hòa', '8788', 3, 246),
(3757, 'Thị trấn Hoa Sơn', '8789', 3, 246),
(3758, 'Xã Liễn Sơn', '8791', 3, 246),
(3759, 'Xã Xuân Hòa', '8794', 3, 246),
(3760, 'Xã Vân Trục', '8797', 3, 246),
(3761, 'Xã Liên Hòa', '8812', 3, 246),
(3762, 'Xã Tử Du', '8815', 3, 246),
(3763, 'Xã Bàn Giản', '8833', 3, 246),
(3764, 'Xã Xuân Lôi', '8836', 3, 246),
(3765, 'Xã Đồng Ích', '8839', 3, 246),
(3766, 'Xã Tiên Lữ', '8842', 3, 246),
(3767, 'Xã Văn Quán', '8845', 3, 246),
(3768, 'Xã Tây Sơn', '8863', 3, 246),
(3769, 'Xã Sơn Đông', '8866', 3, 246);

-- Tỉnh Vĩnh Phúc > Huyện Tam Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3770, 'Thị trấn Hợp Hòa', '8869', 3, 247),
(3771, 'Xã Hoàng Hoa', '8872', 3, 247),
(3772, 'Xã Đồng Tĩnh', '8875', 3, 247),
(3773, 'Thị trấn Kim Long', '8878', 3, 247),
(3774, 'Xã Hướng Đạo', '8881', 3, 247),
(3775, 'Xã Đạo Tú', '8884', 3, 247),
(3776, 'Xã An Hòa', '8887', 3, 247),
(3777, 'Xã Thanh Vân', '8890', 3, 247),
(3778, 'Xã Duy Phiên', '8893', 3, 247),
(3779, 'Xã Hoàng Đan', '8896', 3, 247),
(3780, 'Xã Hoàng Lâu', '8899', 3, 247),
(3781, 'Xã Hội Thịnh', '8905', 3, 247);

-- Tỉnh Vĩnh Phúc > Huyện Tam Đảo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3782, 'Thị trấn Tam Đảo', '8908', 3, 248),
(3783, 'Thị trấn Hợp Châu', '8911', 3, 248),
(3784, 'Xã Đạo Trù', '8914', 3, 248),
(3785, 'Xã Yên Dương', '8917', 3, 248),
(3786, 'Xã Bồ Lý', '8920', 3, 248),
(3787, 'Thị trấn Đại Đình', '8923', 3, 248),
(3788, 'Xã Tam Quan', '8926', 3, 248),
(3789, 'Xã Hồ Sơn', '8929', 3, 248),
(3790, 'Xã Minh Quang', '8932', 3, 248);

-- Tỉnh Vĩnh Phúc > Huyện Bình Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3791, 'Thị trấn Hương Canh', '8935', 3, 249),
(3792, 'Thị trấn Gia Khánh', '8936', 3, 249),
(3793, 'Xã Trung Mỹ', '8938', 3, 249),
(3794, 'Thị trấn Bá Hiến', '8944', 3, 249),
(3795, 'Xã Thiện Kế', '8947', 3, 249),
(3796, 'Xã Hương Sơn', '8950', 3, 249),
(3797, 'Xã Tam Hợp', '8953', 3, 249),
(3798, 'Xã Quất Lưu', '8956', 3, 249),
(3799, 'Xã Sơn Lôi', '8959', 3, 249),
(3800, 'Thị trấn Đạo Đức', '8962', 3, 249),
(3801, 'Xã Tân Phong', '8965', 3, 249),
(3802, 'Thị trấn Thanh Lãng', '8968', 3, 249),
(3803, 'Xã Phú Xuân', '8971', 3, 249);

-- Tỉnh Vĩnh Phúc > Huyện Yên Lạc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3804, 'Thị trấn Yên Lạc', '9025', 3, 250),
(3805, 'Xã Đồng Cương', '9028', 3, 250),
(3806, 'Xã Đồng Văn', '9031', 3, 250),
(3807, 'Xã Bình Định', '9034', 3, 250),
(3808, 'Xã Trung Nguyên', '9037', 3, 250),
(3809, 'Xã Tề Lỗ', '9040', 3, 250),
(3810, 'Thị trấn Tam Hồng', '9043', 3, 250),
(3811, 'Xã Yên Đồng', '9046', 3, 250),
(3812, 'Xã Văn Tiến', '9049', 3, 250),
(3813, 'Xã Nguyệt Đức', '9052', 3, 250),
(3814, 'Xã Yên Phương', '9055', 3, 250),
(3815, 'Xã Trung Kiên', '9061', 3, 250),
(3816, 'Xã Liên Châu', '9064', 3, 250),
(3817, 'Xã Đại Tự', '9067', 3, 250),
(3818, 'Xã Hồng Châu', '9070', 3, 250),
(3819, 'Xã Trung Hà', '9073', 3, 250);

-- Tỉnh Vĩnh Phúc > Huyện Vĩnh Tường
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3820, 'Thị trấn Vĩnh Tường', '9076', 3, 251),
(3821, 'Xã Kim Xá', '9079', 3, 251),
(3822, 'Xã Yên Bình', '9082', 3, 251),
(3823, 'Xã Chấn Hưng', '9085', 3, 251),
(3824, 'Xã Nghĩa Hưng', '9088', 3, 251),
(3825, 'Xã Yên Lập', '9091', 3, 251),
(3826, 'Xã Sao Đại Việt', '9097', 3, 251),
(3827, 'Xã Đại Đồng', '9100', 3, 251),
(3828, 'Xã Lũng Hoà', '9106', 3, 251),
(3829, 'Thị trấn Thổ Tang', '9112', 3, 251),
(3830, 'Xã Lương Điền', '9118', 3, 251),
(3831, 'Xã Tân Phú', '9124', 3, 251),
(3832, 'Xã Thượng Trưng', '9127', 3, 251),
(3833, 'Xã Vũ Di', '9130', 3, 251),
(3834, 'Xã Tuân Chính', '9136', 3, 251),
(3835, 'Thị trấn Tứ Trưng', '9145', 3, 251),
(3836, 'Xã Ngũ Kiên', '9148', 3, 251),
(3837, 'Xã An Nhân', '9151', 3, 251),
(3838, 'Xã Vĩnh Thịnh', '9154', 3, 251),
(3839, 'Xã Vĩnh Phú', '9157', 3, 251);

-- Tỉnh Vĩnh Phúc > Huyện Sông Lô
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3840, 'Xã Lãng Công', '8773', 3, 252),
(3841, 'Xã Quang Yên', '8776', 3, 252),
(3842, 'Xã Hải Lựu', '8782', 3, 252),
(3843, 'Xã Đồng Quế', '8800', 3, 252),
(3844, 'Xã Nhân Đạo', '8803', 3, 252),
(3845, 'Xã Đôn Nhân', '8806', 3, 252),
(3846, 'Xã Phương Khoan', '8809', 3, 252),
(3847, 'Xã Tân Lập', '8818', 3, 252),
(3848, 'Thị trấn Tam Sơn', '8824', 3, 252),
(3849, 'Xã Yên Thạch', '8830', 3, 252),
(3850, 'Xã Đồng Thịnh', '8848', 3, 252),
(3851, 'Xã Tứ Yên', '8851', 3, 252),
(3852, 'Xã Đức Bác', '8854', 3, 252),
(3853, 'Xã Cao Phong', '8860', 3, 252);

-- Tỉnh Bắc Ninh > Thành phố Bắc Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3854, 'Phường Vũ Ninh', '9163', 3, 253),
(3855, 'Phường Đáp Cầu', '9166', 3, 253),
(3856, 'Phường Thị Cầu', '9169', 3, 253),
(3857, 'Phường Kinh Bắc', '9172', 3, 253),
(3858, 'Phường Đại Phúc', '9181', 3, 253),
(3859, 'Phường Tiền Ninh Vệ', '9184', 3, 253),
(3860, 'Phường Suối Hoa', '9187', 3, 253),
(3861, 'Phường Võ Cường', '9190', 3, 253),
(3862, 'Phường Hòa Long', '9214', 3, 253),
(3863, 'Phường Vạn An', '9226', 3, 253),
(3864, 'Phường Khúc Xuyên', '9235', 3, 253),
(3865, 'Phường Phong Khê', '9244', 3, 253),
(3866, 'Phường Kim Chân', '9256', 3, 253),
(3867, 'Phường Vân Dương', '9271', 3, 253),
(3868, 'Phường Nam Sơn', '9286', 3, 253),
(3869, 'Phường Khắc Niệm', '9325', 3, 253),
(3870, 'Phường Hạp Lĩnh', '9331', 3, 253);

-- Tỉnh Bắc Ninh > Huyện Yên Phong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3871, 'Thị trấn Chờ', '9193', 3, 254),
(3872, 'Xã Dũng Liệt', '9196', 3, 254),
(3873, 'Xã Tam Đa', '9199', 3, 254),
(3874, 'Xã Tam Giang', '9202', 3, 254),
(3875, 'Xã Yên Trung', '9205', 3, 254),
(3876, 'Xã Thụy Hòa', '9208', 3, 254),
(3877, 'Xã Hòa Tiến', '9211', 3, 254),
(3878, 'Xã Đông Tiến', '9217', 3, 254),
(3879, 'Xã Yên Phụ', '9220', 3, 254),
(3880, 'Xã Trung Nghĩa', '9223', 3, 254),
(3881, 'Xã Đông Phong', '9229', 3, 254),
(3882, 'Xã Long Châu', '9232', 3, 254),
(3883, 'Xã Văn Môn', '9238', 3, 254),
(3884, 'Xã Đông Thọ', '9241', 3, 254);

-- Tỉnh Bắc Ninh > Thị xã Quế Võ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3885, 'Phường Phố Mới', '9247', 3, 255),
(3886, 'Xã Việt Thống', '9250', 3, 255),
(3887, 'Phường Đại Xuân', '9253', 3, 255),
(3888, 'Phường Nhân Hòa', '9259', 3, 255),
(3889, 'Phường Bằng An', '9262', 3, 255),
(3890, 'Phường Phương Liễu', '9265', 3, 255),
(3891, 'Phường Quế Tân', '9268', 3, 255),
(3892, 'Phường Phù Lương', '9274', 3, 255),
(3893, 'Xã Phù Lãng', '9277', 3, 255),
(3894, 'Phường Phượng Mao', '9280', 3, 255),
(3895, 'Phường Việt Hùng', '9283', 3, 255),
(3896, 'Xã Ngọc Xá', '9289', 3, 255),
(3897, 'Xã Châu Phong', '9292', 3, 255),
(3898, 'Phường Bồng Lai', '9295', 3, 255),
(3899, 'Phường Cách Bi', '9298', 3, 255),
(3900, 'Xã Đào Viên', '9301', 3, 255),
(3901, 'Xã Yên Giả', '9304', 3, 255),
(3902, 'Xã Mộ Đạo', '9307', 3, 255),
(3903, 'Xã Đức Long', '9310', 3, 255),
(3904, 'Xã Chi Lăng', '9313', 3, 255);

-- Tỉnh Bắc Ninh > Huyện Tiên Du
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3905, 'Thị trấn Lim', '9319', 3, 256),
(3906, 'Xã Phú Lâm', '9322', 3, 256),
(3907, 'Xã Nội Duệ', '9328', 3, 256),
(3908, 'Xã Liên Bão', '9334', 3, 256),
(3909, 'Xã Hiên Vân', '9337', 3, 256),
(3910, 'Xã Hoàn Sơn', '9340', 3, 256),
(3911, 'Xã Lạc Vệ', '9343', 3, 256),
(3912, 'Xã Việt Đoàn', '9346', 3, 256),
(3913, 'Xã Phật Tích', '9349', 3, 256),
(3914, 'Xã Tân Chi', '9352', 3, 256),
(3915, 'Xã Đại Đồng', '9355', 3, 256),
(3916, 'Xã Tri Phương', '9358', 3, 256),
(3917, 'Xã Minh Đạo', '9361', 3, 256),
(3918, 'Xã Cảnh Hưng', '9364', 3, 256);

-- Tỉnh Bắc Ninh > Thành phố Từ Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3919, 'Phường Đông Ngàn', '9367', 3, 257),
(3920, 'Phường Tam Sơn', '9370', 3, 257),
(3921, 'Phường Hương Mạc', '9373', 3, 257),
(3922, 'Phường Tương Giang', '9376', 3, 257),
(3923, 'Phường Phù Khê', '9379', 3, 257),
(3924, 'Phường Đồng Kỵ', '9382', 3, 257),
(3925, 'Phường Trang Hạ', '9383', 3, 257),
(3926, 'Phường Đồng Nguyên', '9385', 3, 257),
(3927, 'Phường Châu Khê', '9388', 3, 257),
(3928, 'Phường Tân Hồng', '9391', 3, 257),
(3929, 'Phường Đình Bảng', '9394', 3, 257),
(3930, 'Phường Phù Chẩn', '9397', 3, 257);

-- Tỉnh Bắc Ninh > Thị xã Thuận Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3931, 'Phường Hồ', '9400', 3, 258),
(3932, 'Xã Hoài Thượng', '9403', 3, 258),
(3933, 'Xã Đại Đồng Thành', '9406', 3, 258),
(3934, 'Xã Mão Điền', '9409', 3, 258),
(3935, 'Phường Song Hồ', '9412', 3, 258),
(3936, 'Xã Đình Tổ', '9415', 3, 258),
(3937, 'Phường An Bình', '9418', 3, 258),
(3938, 'Phường Trí Quả', '9421', 3, 258),
(3939, 'Phường Gia Đông', '9424', 3, 258),
(3940, 'Phường Thanh Khương', '9427', 3, 258),
(3941, 'Phường Trạm Lộ', '9430', 3, 258),
(3942, 'Phường Xuân Lâm', '9433', 3, 258),
(3943, 'Phường Hà Mãn', '9436', 3, 258),
(3944, 'Xã Ngũ Thái', '9439', 3, 258),
(3945, 'Xã Nguyệt Đức', '9442', 3, 258),
(3946, 'Phường Ninh Xá', '9445', 3, 258),
(3947, 'Xã Nghĩa Đạo', '9448', 3, 258),
(3948, 'Xã Song Liễu', '9451', 3, 258);

-- Tỉnh Bắc Ninh > Huyện Gia Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3949, 'Thị trấn Gia Bình', '9454', 3, 259),
(3950, 'Xã Vạn Ninh', '9457', 3, 259),
(3951, 'Xã Thái Bảo', '9460', 3, 259),
(3952, 'Xã Giang Sơn', '9463', 3, 259),
(3953, 'Xã Cao Đức', '9466', 3, 259),
(3954, 'Xã Đại Lai', '9469', 3, 259),
(3955, 'Xã Song Giang', '9472', 3, 259),
(3956, 'Xã Bình Dương', '9475', 3, 259),
(3957, 'Xã Lãng Ngâm', '9478', 3, 259),
(3958, 'Thị trấn Nhân Thắng', '9481', 3, 259),
(3959, 'Xã Xuân Lai', '9484', 3, 259),
(3960, 'Xã Đông Cứu', '9487', 3, 259),
(3961, 'Xã Đại Bái', '9490', 3, 259),
(3962, 'Xã Quỳnh Phú', '9493', 3, 259);

-- Tỉnh Bắc Ninh > Huyện Lương Tài
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3963, 'Thị trấn Thứa', '9496', 3, 260),
(3964, 'Xã An Thịnh', '9499', 3, 260),
(3965, 'Xã Trung Kênh', '9502', 3, 260),
(3966, 'Xã Phú Hòa', '9505', 3, 260),
(3967, 'Xã An Tập', '9508', 3, 260),
(3968, 'Xã Tân Lãng', '9511', 3, 260),
(3969, 'Xã Quảng Phú', '9514', 3, 260),
(3970, 'Xã Quang Minh', '9517', 3, 260),
(3971, 'Xã Trung Chính', '9523', 3, 260),
(3972, 'Xã Bình Định', '9529', 3, 260),
(3973, 'Xã Phú Lương', '9532', 3, 260),
(3974, 'Xã Lâm Thao', '9535', 3, 260);

-- Tỉnh Hải Dương > Thành phố Hải Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3975, 'Phường Cẩm Thượng', '10507', 3, 261),
(3976, 'Phường Bình Hàn', '10510', 3, 261),
(3977, 'Phường Ngọc Châu', '10513', 3, 261),
(3978, 'Phường Nhị Châu', '10514', 3, 261),
(3979, 'Phường Quang Trung', '10516', 3, 261),
(3980, 'Phường Nguyễn Trãi', '10519', 3, 261),
(3981, 'Phường Trần Hưng Đạo', '10525', 3, 261),
(3982, 'Phường Trần Phú', '10528', 3, 261),
(3983, 'Phường Thanh Bình', '10531', 3, 261),
(3984, 'Phường Tân Bình', '10532', 3, 261),
(3985, 'Phường Lê Thanh Nghị', '10534', 3, 261),
(3986, 'Phường Hải Tân', '10537', 3, 261),
(3987, 'Phường Tứ Minh', '10540', 3, 261),
(3988, 'Phường Việt Hoà', '10543', 3, 261),
(3989, 'Phường Ái Quốc', '10660', 3, 261),
(3990, 'Xã An Thượng', '10663', 3, 261),
(3991, 'Phường Nam Đồng', '10672', 3, 261),
(3992, 'Xã Quyết Thắng', '10822', 3, 261),
(3993, 'Xã Tiền Tiến', '10837', 3, 261),
(3994, 'Phường Thạch Khôi', '11002', 3, 261),
(3995, 'Xã Liên Hồng', '11005', 3, 261),
(3996, 'Phường Tân Hưng', '11011', 3, 261),
(3997, 'Xã Gia Xuyên', '11017', 3, 261),
(3998, 'Xã Ngọc Sơn', '11077', 3, 261);

-- Tỉnh Hải Dương > Thành phố Chí Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(3999, 'Phường Phả Lại', '10546', 3, 262),
(4000, 'Phường Sao Đỏ', '10549', 3, 262),
(4001, 'Phường Bến Tắm', '10552', 3, 262),
(4002, 'Xã Hoàng Hoa Thám', '10555', 3, 262),
(4003, 'Xã Bắc An', '10558', 3, 262),
(4004, 'Xã Hưng Đạo', '10561', 3, 262),
(4005, 'Xã Lê Lợi', '10564', 3, 262),
(4006, 'Phường Hoàng Tiến', '10567', 3, 262),
(4007, 'Phường Cộng Hoà', '10570', 3, 262),
(4008, 'Phường Hoàng Tân', '10573', 3, 262),
(4009, 'Phường Cổ Thành', '10576', 3, 262),
(4010, 'Phường Văn An', '10579', 3, 262),
(4011, 'Phường Chí Minh', '10582', 3, 262),
(4012, 'Phường Văn Đức', '10585', 3, 262),
(4013, 'Phường Thái Học', '10588', 3, 262),
(4014, 'Xã Nhân Huệ', '10591', 3, 262),
(4015, 'Phường An Lạc', '10594', 3, 262),
(4016, 'Phường Đồng Lạc', '10600', 3, 262),
(4017, 'Phường Tân Dân', '10603', 3, 262);

-- Tỉnh Hải Dương > Huyện Nam Sách
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4018, 'Thị trấn Nam Sách', '10606', 3, 263),
(4019, 'Xã Nam Hưng', '10609', 3, 263),
(4020, 'Xã Nam Tân', '10612', 3, 263),
(4021, 'Xã Hợp Tiến', '10615', 3, 263),
(4022, 'Xã Hiệp Cát', '10618', 3, 263),
(4023, 'Xã Quốc Tuấn', '10621', 3, 263),
(4024, 'Xã An Bình', '10630', 3, 263),
(4025, 'Xã Trần Phú', '10633', 3, 263),
(4026, 'Xã An Sơn', '10636', 3, 263),
(4027, 'Xã Cộng Hòa', '10639', 3, 263),
(4028, 'Xã Thái Tân', '10642', 3, 263),
(4029, 'Xã An Phú', '10645', 3, 263),
(4030, 'Xã Hồng Phong', '10654', 3, 263),
(4031, 'Xã Đồng Lạc', '10657', 3, 263),
(4032, 'Xã Minh Tân', '10666', 3, 263);

-- Tỉnh Hải Dương > Thị xã Kinh Môn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4033, 'Phường An Lưu', '10675', 3, 264),
(4034, 'Xã Bạch Đằng', '10678', 3, 264),
(4035, 'Phường Thất Hùng', '10681', 3, 264),
(4036, 'Xã Lê Ninh', '10684', 3, 264),
(4037, 'Phường Phạm Thái', '10693', 3, 264),
(4038, 'Phường Duy Tân', '10696', 3, 264),
(4039, 'Phường Tân Dân', '10699', 3, 264),
(4040, 'Phường Minh Tân', '10702', 3, 264),
(4041, 'Xã Quang Thành', '10705', 3, 264),
(4042, 'Xã Hiệp Hòa', '10708', 3, 264),
(4043, 'Phường Phú Thứ', '10714', 3, 264),
(4044, 'Xã Thăng Long', '10717', 3, 264),
(4045, 'Xã Lạc Long', '10720', 3, 264),
(4046, 'Phường An Sinh', '10723', 3, 264),
(4047, 'Phường Hiệp Sơn', '10726', 3, 264),
(4048, 'Xã Thượng Quận', '10729', 3, 264),
(4049, 'Phường An Phụ', '10732', 3, 264),
(4050, 'Phường Hiệp An', '10735', 3, 264),
(4051, 'Phường Long Xuyên', '10738', 3, 264),
(4052, 'Phường Thái Thịnh', '10741', 3, 264),
(4053, 'Phường Hiến Thành', '10744', 3, 264),
(4054, 'Xã Minh Hòa', '10747', 3, 264);

-- Tỉnh Hải Dương > Huyện Kim Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4055, 'Thị trấn Phú Thái', '10750', 3, 265),
(4056, 'Xã Lai Khê', '10756', 3, 265),
(4057, 'Xã Vũ Dũng', '10762', 3, 265),
(4058, 'Xã Tuấn Việt', '10768', 3, 265),
(4059, 'Xã Kim Xuyên', '10771', 3, 265),
(4060, 'Xã Ngũ Phúc', '10777', 3, 265),
(4061, 'Xã Kim Anh', '10780', 3, 265),
(4062, 'Xã Kim Liên', '10783', 3, 265),
(4063, 'Xã Kim Tân', '10786', 3, 265),
(4064, 'Xã Kim Đính', '10792', 3, 265),
(4065, 'Xã Hòa Bình', '10798', 3, 265),
(4066, 'Xã Tam Kỳ', '10801', 3, 265),
(4067, 'Xã Đồng Cẩm', '10804', 3, 265),
(4068, 'Xã Đại Đức', '10810', 3, 265);

-- Tỉnh Hải Dương > Huyện Thanh Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4069, 'Thị trấn Thanh Hà', '10813', 3, 266),
(4070, 'Xã Hồng Lạc', '10816', 3, 266),
(4071, 'Xã Tân Việt', '10825', 3, 266),
(4072, 'Xã Cẩm Việt', '10828', 3, 266),
(4073, 'Xã Thanh An', '10831', 3, 266),
(4074, 'Xã Thanh Lang', '10834', 3, 266),
(4075, 'Xã Tân An', '10840', 3, 266),
(4076, 'Xã Liên Mạc', '10843', 3, 266),
(4077, 'Xã Thanh Hải', '10846', 3, 266),
(4078, 'Xã Thanh Xuân', '10855', 3, 266),
(4079, 'Xã Thanh Tân', '10861', 3, 266),
(4080, 'Xã An Phượng', '10864', 3, 266),
(4081, 'Xã Thanh Sơn', '10867', 3, 266),
(4082, 'Xã Thanh Quang', '10876', 3, 266),
(4083, 'Xã Thanh Hồng', '10879', 3, 266),
(4084, 'Xã Vĩnh Cường', '10882', 3, 266);

-- Tỉnh Hải Dương > Huyện Cẩm Giàng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4085, 'Thị trấn Cẩm Giang', '10888', 3, 267),
(4086, 'Thị trấn Lai Cách', '10891', 3, 267),
(4087, 'Xã Cẩm Hưng', '10894', 3, 267),
(4088, 'Xã Cẩm Hoàng', '10897', 3, 267),
(4089, 'Xã Cẩm Văn', '10900', 3, 267),
(4090, 'Xã Ngọc Liên', '10903', 3, 267),
(4091, 'Xã Cẩm Vũ', '10909', 3, 267),
(4092, 'Xã Đức Chính', '10912', 3, 267),
(4093, 'Xã Định Sơn', '10918', 3, 267),
(4094, 'Xã Lương Điền', '10924', 3, 267),
(4095, 'Xã Cao An', '10927', 3, 267),
(4096, 'Xã Tân Trường', '10930', 3, 267),
(4097, 'Xã Phúc Điền', '10933', 3, 267),
(4098, 'Xã Cẩm Đông', '10939', 3, 267),
(4099, 'Xã Cẩm Đoài', '10942', 3, 267);

-- Tỉnh Hải Dương > Huyện Bình Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4100, 'Thị trấn Kẻ Sặt', '10945', 3, 268),
(4101, 'Xã Vĩnh Hưng', '10951', 3, 268),
(4102, 'Xã Hùng Thắng', '10954', 3, 268),
(4103, 'Xã Vĩnh Hồng', '10960', 3, 268),
(4104, 'Xã Long Xuyên', '10963', 3, 268),
(4105, 'Xã Tân Việt', '10966', 3, 268),
(4106, 'Xã Thúc Kháng', '10969', 3, 268),
(4107, 'Xã Tân Hồng', '10972', 3, 268),
(4108, 'Xã Hồng Khê', '10978', 3, 268),
(4109, 'Xã Thái Minh', '10981', 3, 268),
(4110, 'Xã Cổ Bì', '10984', 3, 268),
(4111, 'Xã Nhân Quyền', '10987', 3, 268),
(4112, 'Xã Thái Dương', '10990', 3, 268),
(4113, 'Xã Thái Hòa', '10993', 3, 268),
(4114, 'Xã Bình Xuyên', '10996', 3, 268);

-- Tỉnh Hải Dương > Huyện Gia Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4115, 'Thị trấn Gia Lộc', '10999', 3, 269),
(4116, 'Xã Thống Nhất', '11008', 3, 269),
(4117, 'Xã Yết Kiêu', '11020', 3, 269),
(4118, 'Xã Gia Phúc', '11035', 3, 269),
(4119, 'Xã Gia Tiến', '11038', 3, 269),
(4120, 'Xã Lê Lợi', '11041', 3, 269),
(4121, 'Xã Toàn Thắng', '11044', 3, 269),
(4122, 'Xã Hoàng Diệu', '11047', 3, 269),
(4123, 'Xã Hồng Hưng', '11050', 3, 269),
(4124, 'Xã Phạm Trấn', '11053', 3, 269),
(4125, 'Xã Đoàn Thượng', '11056', 3, 269),
(4126, 'Xã Thống Kênh', '11059', 3, 269),
(4127, 'Xã Nhật Quang', '11065', 3, 269),
(4128, 'Xã Quang Đức', '11071', 3, 269);

-- Tỉnh Hải Dương > Huyện Tứ Kỳ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4129, 'Thị trấn Tứ Kỳ', '11074', 3, 270),
(4130, 'Xã Đại Sơn', '11083', 3, 270),
(4131, 'Xã Hưng Đạo', '11086', 3, 270),
(4132, 'Xã Bình Lăng', '11092', 3, 270),
(4133, 'Xã Chí Minh', '11095', 3, 270),
(4134, 'Xã Kỳ Sơn', '11098', 3, 270),
(4135, 'Xã Quang Phục', '11101', 3, 270),
(4136, 'Xã Tân Kỳ', '11113', 3, 270),
(4137, 'Xã Quang Khải', '11116', 3, 270),
(4138, 'Xã Đại Hợp', '11119', 3, 270),
(4139, 'Xã Dân An', '11122', 3, 270),
(4140, 'Xã An Thanh', '11125', 3, 270),
(4141, 'Xã Minh Đức', '11128', 3, 270),
(4142, 'Xã Văn Tố', '11131', 3, 270),
(4143, 'Xã Quang Trung', '11134', 3, 270),
(4144, 'Xã Lạc Phượng', '11140', 3, 270),
(4145, 'Xã Tiên Động', '11143', 3, 270),
(4146, 'Xã Nguyên Giáp', '11146', 3, 270),
(4147, 'Xã Hà Kỳ', '11149', 3, 270),
(4148, 'Xã Hà Thanh', '11152', 3, 270);

-- Tỉnh Hải Dương > Huyện Ninh Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4149, 'Xã Ứng Hoè', '11161', 3, 271),
(4150, 'Xã Nghĩa An', '11164', 3, 271),
(4151, 'Xã Đức Phúc', '11167', 3, 271),
(4152, 'Xã An Đức', '11173', 3, 271),
(4153, 'Xã Tân Hương', '11179', 3, 271),
(4154, 'Xã Vĩnh Hòa', '11185', 3, 271),
(4155, 'Xã Bình Xuyên', '11188', 3, 271),
(4156, 'Xã Tân Phong', '11197', 3, 271),
(4157, 'Thị trấn Ninh Giang', '11203', 3, 271),
(4158, 'Xã Tân Quang', '11206', 3, 271),
(4159, 'Xã Hồng Dụ', '11215', 3, 271),
(4160, 'Xã Văn Hội', '11218', 3, 271),
(4161, 'Xã Hồng Phong', '11224', 3, 271),
(4162, 'Xã Hiệp Lực', '11227', 3, 271),
(4163, 'Xã Kiến Phúc', '11230', 3, 271),
(4164, 'Xã Hưng Long', '11233', 3, 271);

-- Tỉnh Hải Dương > Huyện Thanh Miện
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4165, 'Thị trấn Thanh Miện', '11239', 3, 272),
(4166, 'Xã Thanh Tùng', '11242', 3, 272),
(4167, 'Xã Phạm Kha', '11245', 3, 272),
(4168, 'Xã Ngô Quyền', '11248', 3, 272),
(4169, 'Xã Đoàn Tùng', '11251', 3, 272),
(4170, 'Xã Hồng Quang', '11254', 3, 272),
(4171, 'Xã Tân Trào', '11257', 3, 272),
(4172, 'Xã Lam Sơn', '11260', 3, 272),
(4173, 'Xã Đoàn Kết', '11263', 3, 272),
(4174, 'Xã Lê Hồng', '11266', 3, 272),
(4175, 'Xã Tứ Cường', '11269', 3, 272),
(4176, 'Xã Ngũ Hùng', '11275', 3, 272),
(4177, 'Xã Cao Thắng', '11278', 3, 272),
(4178, 'Xã Chi Lăng Bắc', '11281', 3, 272),
(4179, 'Xã Chi Lăng Nam', '11284', 3, 272),
(4180, 'Xã Thanh Giang', '11287', 3, 272),
(4181, 'Xã Hồng Phong', '11293', 3, 272);

-- Thành phố Hải Phòng > Quận Hồng Bàng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4182, 'Phường Quán Toan', '11296', 3, 273),
(4183, 'Phường Hùng Vương', '11299', 3, 273),
(4184, 'Phường Sở Dầu', '11302', 3, 273),
(4185, 'Phường Thượng Lý', '11305', 3, 273),
(4186, 'Phường Minh Khai', '11311', 3, 273),
(4187, 'Phường Hoàng Văn Thụ', '11320', 3, 273),
(4188, 'Phường Phan Bội Châu', '11323', 3, 273),
(4189, 'Phường Đại Bản', '11587', 3, 273),
(4190, 'Phường An Hưng', '11599', 3, 273),
(4191, 'Phường An Hồng', '11602', 3, 273);

-- Thành phố Hải Phòng > Quận Ngô Quyền
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4192, 'Phường Máy Chai', '11329', 3, 274),
(4193, 'Phường Vạn Mỹ', '11335', 3, 274),
(4194, 'Phường Cầu Tre', '11338', 3, 274),
(4195, 'Phường Gia Viên', '11341', 3, 274),
(4196, 'Phường Cầu Đất', '11344', 3, 274),
(4197, 'Phường Đông Khê', '11350', 3, 274),
(4198, 'Phường Đằng Giang', '11359', 3, 274),
(4199, 'Phường Lạch Tray', '11365', 3, 274);

-- Thành phố Hải Phòng > Quận Lê Chân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4200, 'Phường An Biên', '11371', 3, 275),
(4201, 'Phường Trần Nguyên Hãn', '11383', 3, 275),
(4202, 'Phường Hàng Kênh', '11395', 3, 275),
(4203, 'Phường An Dương', '11401', 3, 275),
(4204, 'Phường Dư Hàng Kênh', '11404', 3, 275),
(4205, 'Phường Kênh Dương', '11405', 3, 275),
(4206, 'Phường Vĩnh Niệm', '11407', 3, 275);

-- Thành phố Hải Phòng > Quận Hải An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4207, 'Phường Đông Hải 1', '11410', 3, 276),
(4208, 'Phường Đông Hải 2', '11411', 3, 276),
(4209, 'Phường Đằng Lâm', '11413', 3, 276),
(4210, 'Phường Thành Tô', '11414', 3, 276),
(4211, 'Phường Đằng Hải', '11416', 3, 276),
(4212, 'Phường Nam Hải', '11419', 3, 276),
(4213, 'Phường Cát Bi', '11422', 3, 276),
(4214, 'Phường Tràng Cát', '11425', 3, 276);

-- Thành phố Hải Phòng > Quận Kiến An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4215, 'Phường Đồng Hoà', '11431', 3, 277),
(4216, 'Phường Bắc Sơn', '11434', 3, 277),
(4217, 'Phường Nam Sơn', '11437', 3, 277),
(4218, 'Phường Ngọc Sơn', '11440', 3, 277),
(4219, 'Phường Trần Thành Ngọ', '11443', 3, 277),
(4220, 'Phường Văn Đẩu', '11446', 3, 277),
(4221, 'Phường Bắc Hà', '11449', 3, 277);

-- Thành phố Hải Phòng > Quận Đồ Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4222, 'Phường Ngọc Xuyên', '11455', 3, 278),
(4223, 'Phường Hải Sơn', '11458', 3, 278),
(4224, 'Phường Vạn Hương', '11461', 3, 278),
(4225, 'Phường Minh Đức', '11465', 3, 278),
(4226, 'Phường Bàng La', '11467', 3, 278),
(4227, 'Phường Hợp Đức', '11737', 3, 278);

-- Thành phố Hải Phòng > Quận Dương Kinh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4228, 'Phường Đa Phúc', '11683', 3, 279),
(4229, 'Phường Hưng Đạo', '11686', 3, 279),
(4230, 'Phường Anh Dũng', '11689', 3, 279),
(4231, 'Phường Hải Thành', '11692', 3, 279),
(4232, 'Phường Hoà Nghĩa', '11707', 3, 279),
(4233, 'Phường Tân Thành', '11740', 3, 279);

-- Thành phố Hải Phòng > Thành phố Thuỷ Nguyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4234, 'Phường Minh Đức', '11473', 3, 280),
(4235, 'Xã Liên Xuân', '11485', 3, 280),
(4236, 'Phường Lưu Kiếm', '11488', 3, 280),
(4237, 'Xã Bạch Đằng', '11500', 3, 280),
(4238, 'Xã Ninh Sơn', '11503', 3, 280),
(4239, 'Phường Quảng Thanh', '11506', 3, 280),
(4240, 'Phường Trần Hưng Đạo', '11512', 3, 280),
(4241, 'Xã Quang Trung', '11518', 3, 280),
(4242, 'Phường Lê Hồng Phong', '11521', 3, 280),
(4243, 'Phường Hoà Bình', '11527', 3, 280),
(4244, 'Phường Thủy Hà', '11530', 3, 280),
(4245, 'Phường An Lư', '11533', 3, 280),
(4246, 'Phường Phạm Ngũ Lão', '11539', 3, 280),
(4247, 'Phường Nam Triệu Giang', '11542', 3, 280),
(4248, 'Phường Tam Hưng', '11545', 3, 280),
(4249, 'Phường Lập Lễ', '11551', 3, 280),
(4250, 'Phường Thiên Hương', '11557', 3, 280),
(4251, 'Phường Thuỷ Đường', '11560', 3, 280),
(4252, 'Phường Hoàng Lâm', '11569', 3, 280),
(4253, 'Phường Hoa Động', '11572', 3, 280),
(4254, 'Phường Dương Quan', '11578', 3, 280);

-- Thành phố Hải Phòng > Quận An Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4255, 'Phường Lê Lợi', '11581', 3, 281),
(4256, 'Phường Lê Thiện', '11584', 3, 281),
(4257, 'Phường An Hoà', '11590', 3, 281),
(4258, 'Phường Hồng Phong', '11593', 3, 281),
(4259, 'Phường Tân Tiến', '11596', 3, 281),
(4260, 'Phường Nam Sơn', '11608', 3, 281),
(4261, 'Phường An Hải', '11614', 3, 281),
(4262, 'Phường Đồng Thái', '11617', 3, 281),
(4263, 'Phường An Đồng', '11623', 3, 281),
(4264, 'Phường Hồng Thái', '11626', 3, 281);

-- Thành phố Hải Phòng > Huyện An Lão
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4265, 'Thị trấn An Lão', '11629', 3, 282),
(4266, 'Xã Bát Trang', '11632', 3, 282),
(4267, 'Xã Trường Thọ', '11635', 3, 282),
(4268, 'Xã Trường Thành', '11638', 3, 282),
(4269, 'Xã An Tiến', '11641', 3, 282),
(4270, 'Xã Quang Hưng', '11644', 3, 282),
(4271, 'Xã Quang Trung', '11647', 3, 282),
(4272, 'Xã Quốc Tuấn', '11650', 3, 282),
(4273, 'Xã An Thắng', '11653', 3, 282),
(4274, 'Thị trấn Trường Sơn', '11656', 3, 282),
(4275, 'Xã Tân Dân', '11659', 3, 282),
(4276, 'Xã Thái Sơn', '11662', 3, 282),
(4277, 'Xã Tân Viên', '11665', 3, 282),
(4278, 'Xã Mỹ Đức', '11668', 3, 282),
(4279, 'Xã Chiến Thắng', '11671', 3, 282),
(4280, 'Xã An Thọ', '11674', 3, 282),
(4281, 'Xã An Thái', '11677', 3, 282);

-- Thành phố Hải Phòng > Huyện Kiến Thuỵ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4282, 'Thị trấn Núi Đối', '11680', 3, 283),
(4283, 'Xã Đông Phương', '11695', 3, 283),
(4284, 'Xã Thuận Thiên', '11698', 3, 283),
(4285, 'Xã Hữu Bằng', '11701', 3, 283),
(4286, 'Xã Đại Đồng', '11704', 3, 283),
(4287, 'Xã Ngũ Phúc', '11710', 3, 283),
(4288, 'Xã Kiến Quốc', '11713', 3, 283),
(4289, 'Xã Du Lễ', '11716', 3, 283),
(4290, 'Xã Thanh Sơn', '11722', 3, 283),
(4291, 'Xã Minh Tân', '11725', 3, 283),
(4292, 'Xã Kiến Hưng', '11728', 3, 283),
(4293, 'Xã Tân Phong', '11734', 3, 283),
(4294, 'Xã Tân Trào', '11743', 3, 283),
(4295, 'Xã Đoàn Xá', '11746', 3, 283),
(4296, 'Xã Tú Sơn', '11749', 3, 283),
(4297, 'Xã Đại Hợp', '11752', 3, 283);

-- Thành phố Hải Phòng > Huyện Tiên Lãng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4298, 'Thị trấn Tiên Lãng', '11755', 3, 284),
(4299, 'Xã Đại Thắng', '11758', 3, 284),
(4300, 'Xã Tiên Cường', '11761', 3, 284),
(4301, 'Xã Tự Cường', '11764', 3, 284),
(4302, 'Xã Quyết Tiến', '11770', 3, 284),
(4303, 'Xã Khởi Nghĩa', '11773', 3, 284),
(4304, 'Xã Tiên Thanh', '11776', 3, 284),
(4305, 'Xã Cấp Tiến', '11779', 3, 284),
(4306, 'Xã Kiến Thiết', '11782', 3, 284),
(4307, 'Xã Đoàn Lập', '11785', 3, 284),
(4308, 'Xã Tân Minh', '11791', 3, 284),
(4309, 'Xã Tiên Thắng', '11797', 3, 284),
(4310, 'Xã Tiên Minh', '11800', 3, 284),
(4311, 'Xã Bắc Hưng', '11803', 3, 284),
(4312, 'Xã Nam Hưng', '11806', 3, 284),
(4313, 'Xã Hùng Thắng', '11809', 3, 284),
(4314, 'Xã Tây Hưng', '11812', 3, 284),
(4315, 'Xã Đông Hưng', '11815', 3, 284),
(4316, 'Xã Vinh Quang', '11821', 3, 284);

-- Thành phố Hải Phòng > Huyện Vĩnh Bảo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4317, 'Thị trấn Vĩnh Bảo', '11824', 3, 285),
(4318, 'Xã Dũng Tiến', '11827', 3, 285),
(4319, 'Xã Giang Biên', '11830', 3, 285),
(4320, 'Xã Thắng Thuỷ', '11833', 3, 285),
(4321, 'Xã Trung Lập', '11836', 3, 285),
(4322, 'Xã Việt Tiến', '11839', 3, 285),
(4323, 'Xã Vĩnh An', '11842', 3, 285),
(4324, 'Xã Vĩnh Hoà', '11848', 3, 285),
(4325, 'Xã Hùng Tiến', '11851', 3, 285),
(4326, 'Xã Tân Hưng', '11857', 3, 285),
(4327, 'Xã Tân Liên', '11860', 3, 285),
(4328, 'Xã Vĩnh Hưng', '11866', 3, 285),
(4329, 'Xã Vĩnh Hải', '11875', 3, 285),
(4330, 'Xã Liên Am', '11881', 3, 285),
(4331, 'Xã Lý Học', '11884', 3, 285),
(4332, 'Xã Tam Cường', '11887', 3, 285),
(4333, 'Xã Hoà Bình', '11890', 3, 285),
(4334, 'Xã Tiền Phong', '11893', 3, 285),
(4335, 'Xã Cao Minh', '11902', 3, 285),
(4336, 'Xã Trấn Dương', '11911', 3, 285);

-- Thành phố Hải Phòng > Huyện Cát Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4337, 'Thị trấn Cát Bà', '11914', 3, 286),
(4338, 'Thị trấn Cát Hải', '11917', 3, 286),
(4339, 'Xã Nghĩa Lộ', '11920', 3, 286),
(4340, 'Xã Đồng Bài', '11923', 3, 286),
(4341, 'Xã Hoàng Châu', '11926', 3, 286),
(4342, 'Xã Văn Phong', '11929', 3, 286),
(4343, 'Xã Phù Long', '11932', 3, 286),
(4344, 'Xã Gia Luận', '11935', 3, 286),
(4345, 'Xã Hiền Hào', '11938', 3, 286),
(4346, 'Xã Trân Châu', '11941', 3, 286),
(4347, 'Xã Việt Hải', '11944', 3, 286),
(4348, 'Xã Xuân Đám', '11947', 3, 286);

-- Tỉnh Hưng Yên > Thành phố Hưng Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4349, 'Phường Lam Sơn', '11950', 3, 288),
(4350, 'Phường Hiến Nam', '11953', 3, 288),
(4351, 'Phường An Tảo', '11956', 3, 288),
(4352, 'Phường Lê Lợi', '11959', 3, 288),
(4353, 'Phường Minh Khai', '11962', 3, 288),
(4354, 'Phường Hồng Châu', '11968', 3, 288),
(4355, 'Xã Trung Nghĩa', '11971', 3, 288),
(4356, 'Xã Liên Phương', '11974', 3, 288),
(4357, 'Xã Phương Nam', '11977', 3, 288),
(4358, 'Xã Quảng Châu', '11980', 3, 288),
(4359, 'Xã Bảo Khê', '11983', 3, 288),
(4360, 'Xã Phú Cường', '12331', 3, 288),
(4361, 'Xã Hùng Cường', '12334', 3, 288),
(4362, 'Xã Tân Hưng', '12385', 3, 288),
(4363, 'Xã Hoàng Hanh', '12388', 3, 288);

-- Tỉnh Hưng Yên > Huyện Văn Lâm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4364, 'Thị trấn Như Quỳnh', '11986', 3, 289),
(4365, 'Xã Lạc Đạo', '11989', 3, 289),
(4366, 'Xã Chỉ Đạo', '11992', 3, 289),
(4367, 'Xã Đại Đồng', '11995', 3, 289),
(4368, 'Xã Việt Hưng', '11998', 3, 289),
(4369, 'Xã Tân Quang', '12001', 3, 289),
(4370, 'Xã Đình Dù', '12004', 3, 289),
(4371, 'Xã Minh Hải', '12007', 3, 289),
(4372, 'Xã Lương Tài', '12010', 3, 289),
(4373, 'Xã Trưng Trắc', '12013', 3, 289),
(4374, 'Xã Lạc Hồng', '12016', 3, 289);

-- Tỉnh Hưng Yên > Huyện Văn Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4375, 'Thị trấn Văn Giang', '12019', 3, 290),
(4376, 'Xã Xuân Quan', '12022', 3, 290),
(4377, 'Xã Cửu Cao', '12025', 3, 290),
(4378, 'Xã Phụng Công', '12028', 3, 290),
(4379, 'Xã Nghĩa Trụ', '12031', 3, 290),
(4380, 'Xã Long Hưng', '12034', 3, 290),
(4381, 'Xã Vĩnh Khúc', '12037', 3, 290),
(4382, 'Xã Liên Nghĩa', '12040', 3, 290),
(4383, 'Xã Tân Tiến', '12043', 3, 290),
(4384, 'Xã Thắng Lợi', '12046', 3, 290),
(4385, 'Xã Mễ Sở', '12049', 3, 290);

-- Tỉnh Hưng Yên > Huyện Yên Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4386, 'Thị trấn Yên Mỹ', '12052', 3, 291),
(4387, 'Xã Nguyễn Văn Linh', '12055', 3, 291),
(4388, 'Xã Đồng Than', '12061', 3, 291),
(4389, 'Xã Ngọc Long', '12064', 3, 291),
(4390, 'Xã Liêu Xá', '12067', 3, 291),
(4391, 'Xã Hoàn Long', '12070', 3, 291),
(4392, 'Xã Tân Lập', '12073', 3, 291),
(4393, 'Xã Thanh Long', '12076', 3, 291),
(4394, 'Xã Yên Phú', '12079', 3, 291),
(4395, 'Xã Trung Hòa', '12085', 3, 291),
(4396, 'Xã Việt Yên', '12091', 3, 291),
(4397, 'Xã Tân Minh', '12100', 3, 291);

-- Tỉnh Hưng Yên > Thị xã Mỹ Hào
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4398, 'Phường Bần Yên Nhân', '12103', 3, 292),
(4399, 'Phường Phan Đình Phùng', '12106', 3, 292),
(4400, 'Xã Cẩm Xá', '12109', 3, 292),
(4401, 'Xã Dương Quang', '12112', 3, 292),
(4402, 'Xã Hòa Phong', '12115', 3, 292),
(4403, 'Phường Nhân Hòa', '12118', 3, 292),
(4404, 'Phường Dị Sử', '12121', 3, 292),
(4405, 'Phường Bạch Sam', '12124', 3, 292),
(4406, 'Phường Minh Đức', '12127', 3, 292),
(4407, 'Phường Phùng Chí Kiên', '12130', 3, 292),
(4408, 'Xã Xuân Dục', '12133', 3, 292),
(4409, 'Xã Ngọc Lâm', '12136', 3, 292),
(4410, 'Xã Hưng Long', '12139', 3, 292);

-- Tỉnh Hưng Yên > Huyện Ân Thi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4411, 'Thị trấn Ân Thi', '12142', 3, 293),
(4412, 'Xã Phù Ủng', '12145', 3, 293),
(4413, 'Xã Bắc Sơn', '12148', 3, 293),
(4414, 'Xã Bãi Sậy', '12151', 3, 293),
(4415, 'Xã Đào Dương', '12154', 3, 293),
(4416, 'Xã Quang Vinh', '12157', 3, 293),
(4417, 'Xã Vân Du', '12160', 3, 293),
(4418, 'Xã Xuân Trúc', '12166', 3, 293),
(4419, 'Xã Hoàng Hoa Thám', '12169', 3, 293),
(4420, 'Xã Quảng Lãng', '12172', 3, 293),
(4421, 'Xã Đa Lộc', '12175', 3, 293),
(4422, 'Xã Đặng Lễ', '12178', 3, 293),
(4423, 'Xã Cẩm Ninh', '12181', 3, 293),
(4424, 'Xã Nguyễn Trãi', '12184', 3, 293),
(4425, 'Xã Hồ Tùng Mậu', '12190', 3, 293),
(4426, 'Xã Tiền Phong', '12193', 3, 293),
(4427, 'Xã Hồng Quang', '12196', 3, 293),
(4428, 'Xã Hạ Lễ', '12202', 3, 293);

-- Tỉnh Hưng Yên > Huyện Khoái Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4429, 'Thị trấn Khoái Châu', '12205', 3, 294),
(4430, 'Xã Đông Tảo', '12208', 3, 294),
(4431, 'Xã Bình Minh', '12211', 3, 294),
(4432, 'Xã Phạm Hồng Thái', '12214', 3, 294),
(4433, 'Xã Ông Đình', '12220', 3, 294),
(4434, 'Xã Tân Dân', '12223', 3, 294),
(4435, 'Xã Tứ Dân', '12226', 3, 294),
(4436, 'Xã An Vĩ', '12229', 3, 294),
(4437, 'Xã Đông Kết', '12232', 3, 294),
(4438, 'Xã Dân Tiến', '12238', 3, 294),
(4439, 'Xã Đồng Tiến', '12244', 3, 294),
(4440, 'Xã Tân Châu', '12247', 3, 294),
(4441, 'Xã Liên Khê', '12250', 3, 294),
(4442, 'Xã Phùng Hưng', '12253', 3, 294),
(4443, 'Xã Việt Hòa', '12256', 3, 294),
(4444, 'Xã Đông Ninh', '12259', 3, 294),
(4445, 'Xã Đại Tập', '12262', 3, 294),
(4446, 'Xã Chí Minh', '12265', 3, 294),
(4447, 'Xã Thuần Hưng', '12271', 3, 294),
(4448, 'Xã Nguyễn Huệ', '12274', 3, 294);

-- Tỉnh Hưng Yên > Huyện Kim Động
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4449, 'Thị trấn Lương Bằng', '12280', 3, 295),
(4450, 'Xã Nghĩa Dân', '12283', 3, 295),
(4451, 'Xã Toàn Thắng', '12286', 3, 295),
(4452, 'Xã Vĩnh Xá', '12289', 3, 295),
(4453, 'Xã Phạm Ngũ Lão', '12292', 3, 295),
(4454, 'Xã Phú Thọ', '12295', 3, 295),
(4455, 'Xã Đồng Thanh', '12298', 3, 295),
(4456, 'Xã Song Mai', '12301', 3, 295),
(4457, 'Xã Chính Nghĩa', '12304', 3, 295),
(4458, 'Xã Mai Động', '12313', 3, 295),
(4459, 'Xã Đức Hợp', '12316', 3, 295),
(4460, 'Xã Hùng An', '12319', 3, 295),
(4461, 'Xã Ngọc Thanh', '12322', 3, 295),
(4462, 'Xã Diên Hồng', '12325', 3, 295),
(4463, 'Xã Hiệp Cường', '12328', 3, 295);

-- Tỉnh Hưng Yên > Huyện Tiên Lữ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4464, 'Thị trấn Vương', '12337', 3, 296),
(4465, 'Xã Hưng Đạo', '12340', 3, 296),
(4466, 'Xã Nhật Tân', '12346', 3, 296),
(4467, 'Xã Lệ Xá', '12352', 3, 296),
(4468, 'Xã An Viên', '12355', 3, 296),
(4469, 'Xã Trung Dũng', '12361', 3, 296),
(4470, 'Xã Hải Thắng', '12364', 3, 296),
(4471, 'Xã Thủ Sỹ', '12367', 3, 296),
(4472, 'Xã Thiện Phiến', '12370', 3, 296),
(4473, 'Xã Thụy Lôi', '12373', 3, 296),
(4474, 'Xã Cương Chính', '12376', 3, 296);

-- Tỉnh Hưng Yên > Huyện Phù Cừ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4475, 'Thị trấn Trần Cao', '12391', 3, 297),
(4476, 'Xã Minh Tân', '12394', 3, 297),
(4477, 'Xã Phan Sào Nam', '12397', 3, 297),
(4478, 'Xã Quang Hưng', '12400', 3, 297),
(4479, 'Xã Minh Hoàng', '12403', 3, 297),
(4480, 'Xã Đoàn Đào', '12406', 3, 297),
(4481, 'Xã Tống Phan', '12409', 3, 297),
(4482, 'Xã Đình Cao', '12412', 3, 297),
(4483, 'Xã Nhật Quang', '12415', 3, 297),
(4484, 'Xã Tam Đa', '12421', 3, 297),
(4485, 'Xã Tiên Tiến', '12424', 3, 297),
(4486, 'Xã Nguyên Hòa', '12427', 3, 297),
(4487, 'Xã Tống Trân', '12430', 3, 297);

-- Tỉnh Thái Bình > Thành phố Thái Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4488, 'Phường Lê Hồng Phong', '12433', 3, 298),
(4489, 'Phường Bồ Xuyên', '12436', 3, 298),
(4490, 'Phường Đề Thám', '12439', 3, 298),
(4491, 'Phường Kỳ Bá', '12442', 3, 298),
(4492, 'Phường Quang Trung', '12445', 3, 298),
(4493, 'Phường Phú Khánh', '12448', 3, 298),
(4494, 'Phường Tiền Phong', '12451', 3, 298),
(4495, 'Phường Trần Hưng Đạo', '12452', 3, 298),
(4496, 'Phường Trần Lãm', '12454', 3, 298),
(4497, 'Xã Đông Hòa', '12457', 3, 298),
(4498, 'Phường Hoàng Diệu', '12460', 3, 298),
(4499, 'Xã Phú Xuân', '12463', 3, 298),
(4500, 'Xã Vũ Phúc', '12466', 3, 298),
(4501, 'Xã Vũ Chính', '12469', 3, 298),
(4502, 'Xã Đông Mỹ', '12817', 3, 298),
(4503, 'Xã Đông Thọ', '12820', 3, 298),
(4504, 'Xã Vũ Đông', '13084', 3, 298),
(4505, 'Xã Vũ Lạc', '13108', 3, 298),
(4506, 'Xã Tân Bình', '13225', 3, 298);

-- Tỉnh Thái Bình > Huyện Quỳnh Phụ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4507, 'Thị trấn Quỳnh Côi', '12472', 3, 299),
(4508, 'Xã An Khê', '12475', 3, 299),
(4509, 'Xã An Đồng', '12478', 3, 299),
(4510, 'Xã Quỳnh Hoa', '12481', 3, 299),
(4511, 'Xã Quỳnh Lâm', '12484', 3, 299),
(4512, 'Xã Quỳnh Thọ', '12487', 3, 299),
(4513, 'Xã An Hiệp', '12490', 3, 299),
(4514, 'Xã Quỳnh Hoàng', '12493', 3, 299),
(4515, 'Xã Quỳnh Giao', '12496', 3, 299),
(4516, 'Xã An Thái', '12499', 3, 299),
(4517, 'Xã An Cầu', '12502', 3, 299),
(4518, 'Xã Quỳnh Hồng', '12505', 3, 299),
(4519, 'Xã Quỳnh Khê', '12508', 3, 299),
(4520, 'Xã Quỳnh Minh', '12511', 3, 299),
(4521, 'Xã An Ninh', '12514', 3, 299),
(4522, 'Xã Quỳnh Ngọc', '12517', 3, 299),
(4523, 'Xã Quỳnh Hải', '12520', 3, 299),
(4524, 'Thị trấn An Bài', '12523', 3, 299),
(4525, 'Xã An Ấp', '12526', 3, 299),
(4526, 'Xã Quỳnh Hội', '12529', 3, 299),
(4527, 'Xã Châu Sơn', '12532', 3, 299),
(4528, 'Xã Quỳnh Mỹ', '12535', 3, 299),
(4529, 'Xã An Quí', '12538', 3, 299),
(4530, 'Xã An Thanh', '12541', 3, 299),
(4531, 'Xã An Vũ', '12547', 3, 299),
(4532, 'Xã An Lễ', '12550', 3, 299),
(4533, 'Xã Quỳnh Hưng', '12553', 3, 299),
(4534, 'Xã An Mỹ', '12559', 3, 299),
(4535, 'Xã Quỳnh Nguyên', '12562', 3, 299),
(4536, 'Xã An Vinh', '12565', 3, 299),
(4537, 'Xã An Dục', '12571', 3, 299),
(4538, 'Xã Đông Hải', '12574', 3, 299),
(4539, 'Xã Trang Bảo Xá', '12577', 3, 299),
(4540, 'Xã An Tràng', '12580', 3, 299),
(4541, 'Xã Đồng Tiến', '12583', 3, 299);

-- Tỉnh Thái Bình > Huyện Hưng Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4542, 'Thị trấn Hưng Hà', '12586', 3, 300),
(4543, 'Xã Quang Trung', '12589', 3, 300),
(4544, 'Xã Tân Lễ', '12592', 3, 300),
(4545, 'Xã Cộng Hòa', '12595', 3, 300),
(4546, 'Xã Canh Tân', '12601', 3, 300),
(4547, 'Xã Hòa Tiến', '12604', 3, 300),
(4548, 'Xã Tân Tiến', '12610', 3, 300),
(4549, 'Thị trấn Hưng Nhân', '12613', 3, 300),
(4550, 'Xã Đoan Hùng', '12616', 3, 300),
(4551, 'Xã Duyên Hải', '12619', 3, 300),
(4552, 'Xã Tân Hòa', '12622', 3, 300),
(4553, 'Xã Văn Cẩm', '12625', 3, 300),
(4554, 'Xã Bắc Sơn', '12628', 3, 300),
(4555, 'Xã Đông Đô', '12631', 3, 300),
(4556, 'Xã Phúc Khánh', '12634', 3, 300),
(4557, 'Xã Liên Hiệp', '12637', 3, 300),
(4558, 'Xã Tây Đô', '12640', 3, 300),
(4559, 'Xã Thống Nhất', '12643', 3, 300),
(4560, 'Xã Tiến Đức', '12646', 3, 300),
(4561, 'Xã Thái Hưng', '12649', 3, 300),
(4562, 'Xã Thái Phương', '12652', 3, 300),
(4563, 'Xã Hòa Bình', '12655', 3, 300),
(4564, 'Xã Chi Lăng', '12656', 3, 300),
(4565, 'Xã Minh Khai', '12658', 3, 300),
(4566, 'Xã Hồng An', '12661', 3, 300),
(4567, 'Xã Kim Chung', '12664', 3, 300),
(4568, 'Xã Hồng Lĩnh', '12667', 3, 300),
(4569, 'Xã Minh Tân', '12670', 3, 300),
(4570, 'Xã Văn Lang', '12673', 3, 300),
(4571, 'Xã Độc Lập', '12676', 3, 300),
(4572, 'Xã Chí Hòa', '12679', 3, 300),
(4573, 'Xã Minh Hòa', '12682', 3, 300),
(4574, 'Xã Hồng Minh', '12685', 3, 300);

-- Tỉnh Thái Bình > Huyện Đông Hưng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4575, 'Thị trấn Đông Hưng', '12688', 3, 301),
(4576, 'Xã Đông Phương', '12694', 3, 301),
(4577, 'Xã Liên An Đô', '12700', 3, 301),
(4578, 'Xã Đông Sơn', '12703', 3, 301),
(4579, 'Xã Đông Cường', '12706', 3, 301),
(4580, 'Xã Phú Lương', '12709', 3, 301),
(4581, 'Xã Mê Linh', '12712', 3, 301),
(4582, 'Xã Lô Giang', '12715', 3, 301),
(4583, 'Xã Đông La', '12718', 3, 301),
(4584, 'Xã Minh Tân', '12721', 3, 301),
(4585, 'Xã Đông Xá', '12724', 3, 301),
(4586, 'Xã Nguyên Xá', '12730', 3, 301),
(4587, 'Xã Phong Dương Tiến', '12736', 3, 301),
(4588, 'Xã Hồng Việt', '12739', 3, 301),
(4589, 'Xã Hà Giang', '12745', 3, 301),
(4590, 'Xã Đông Kinh', '12748', 3, 301),
(4591, 'Xã Đông Hợp', '12751', 3, 301),
(4592, 'Xã Thăng Long', '12754', 3, 301),
(4593, 'Xã Đông Các', '12757', 3, 301),
(4594, 'Xã Phú Châu', '12760', 3, 301),
(4595, 'Xã Liên Hoa', '12763', 3, 301),
(4596, 'Xã Đông Tân', '12769', 3, 301),
(4597, 'Xã Đông Vinh', '12772', 3, 301),
(4598, 'Xã Xuân Quang Động', '12775', 3, 301),
(4599, 'Xã Hồng Bạch', '12778', 3, 301),
(4600, 'Xã Trọng Quan', '12784', 3, 301),
(4601, 'Xã Hồng Giang', '12790', 3, 301),
(4602, 'Xã Đông Quan', '12793', 3, 301),
(4603, 'Xã Đông Á', '12802', 3, 301),
(4604, 'Xã Đông Hoàng', '12808', 3, 301),
(4605, 'Xã Đông Dương', '12811', 3, 301),
(4606, 'Xã Minh Phú', '12823', 3, 301);

-- Tỉnh Thái Bình > Huyện Thái Thụy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4607, 'Thị trấn Diêm Điền', '12826', 3, 302),
(4608, 'Xã Thụy Trường', '12832', 3, 302),
(4609, 'Xã Hồng Dũng', '12841', 3, 302),
(4610, 'Xã Thụy Quỳnh', '12844', 3, 302),
(4611, 'Xã An Tân', '12847', 3, 302),
(4612, 'Xã Thụy Ninh', '12850', 3, 302),
(4613, 'Xã Thụy Hưng', '12853', 3, 302),
(4614, 'Xã Thụy Việt', '12856', 3, 302),
(4615, 'Xã Thụy Văn', '12859', 3, 302),
(4616, 'Xã Thụy Xuân', '12862', 3, 302),
(4617, 'Xã Dương Phúc', '12865', 3, 302),
(4618, 'Xã Thụy Trình', '12868', 3, 302),
(4619, 'Xã Thụy Bình', '12871', 3, 302),
(4620, 'Xã Thụy Chính', '12874', 3, 302),
(4621, 'Xã Thụy Dân', '12877', 3, 302),
(4622, 'Xã Thụy Hải', '12880', 3, 302),
(4623, 'Xã Thụy Liên', '12889', 3, 302),
(4624, 'Xã Thụy Duyên', '12892', 3, 302),
(4625, 'Xã Thụy Thanh', '12898', 3, 302),
(4626, 'Xã Thụy Sơn', '12901', 3, 302),
(4627, 'Xã Thụy Phong', '12904', 3, 302),
(4628, 'Xã Thái Thượng', '12907', 3, 302),
(4629, 'Xã Thái Nguyên', '12910', 3, 302),
(4630, 'Xã Dương Hồng Thủy', '12916', 3, 302),
(4631, 'Xã Thái Giang', '12919', 3, 302),
(4632, 'Xã Hòa An', '12922', 3, 302),
(4633, 'Xã Sơn Hà', '12925', 3, 302),
(4634, 'Xã Thái Phúc', '12934', 3, 302),
(4635, 'Xã Thái Hưng', '12937', 3, 302),
(4636, 'Xã Thái Đô', '12940', 3, 302),
(4637, 'Xã Thái Xuyên', '12943', 3, 302),
(4638, 'Xã Mỹ Lộc', '12949', 3, 302),
(4639, 'Xã Tân Học', '12958', 3, 302),
(4640, 'Xã Thái Thịnh', '12961', 3, 302),
(4641, 'Xã Thuần Thành', '12964', 3, 302),
(4642, 'Xã Thái Thọ', '12967', 3, 302);

-- Tỉnh Thái Bình > Huyện Tiền Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4643, 'Thị trấn Tiền Hải', '12970', 3, 303),
(4644, 'Xã Đông Trà', '12976', 3, 303),
(4645, 'Xã Đông Long', '12979', 3, 303),
(4646, 'Xã Vũ Lăng', '12985', 3, 303),
(4647, 'Xã Đông Xuyên', '12988', 3, 303),
(4648, 'Xã Tây Lương', '12991', 3, 303),
(4649, 'Xã Tây Ninh', '12994', 3, 303),
(4650, 'Xã Đông Quang', '12997', 3, 303),
(4651, 'Xã Đông Hoàng', '13000', 3, 303),
(4652, 'Xã Đông Minh', '13003', 3, 303),
(4653, 'Xã An Ninh', '13012', 3, 303),
(4654, 'Xã Đông Cơ', '13018', 3, 303),
(4655, 'Xã Tây Giang', '13021', 3, 303),
(4656, 'Xã Đông Lâm', '13024', 3, 303),
(4657, 'Xã Phương Công', '13027', 3, 303),
(4658, 'Xã Ái Quốc', '13030', 3, 303),
(4659, 'Xã Nam Cường', '13036', 3, 303),
(4660, 'Xã Vân Trường', '13039', 3, 303),
(4661, 'Xã Nam Chính', '13045', 3, 303),
(4662, 'Xã Bắc Hải', '13048', 3, 303),
(4663, 'Xã Nam Thịnh', '13051', 3, 303),
(4664, 'Xã Nam Hà', '13054', 3, 303),
(4665, 'Xã Nam Tiến', '13057', 3, 303),
(4666, 'Xã Nam Trung', '13060', 3, 303),
(4667, 'Xã Nam Hồng', '13063', 3, 303),
(4668, 'Xã Nam Hưng', '13066', 3, 303),
(4669, 'Xã Nam Hải', '13069', 3, 303),
(4670, 'Xã Nam Phú', '13072', 3, 303);

-- Tỉnh Thái Bình > Huyện Kiến Xương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4671, 'Thị trấn Kiến Xương', '13075', 3, 304),
(4672, 'Xã Trà Giang', '13078', 3, 304),
(4673, 'Xã Quốc Tuấn', '13081', 3, 304),
(4674, 'Xã An Bình', '13087', 3, 304),
(4675, 'Xã Tây Sơn', '13090', 3, 304),
(4676, 'Xã Hồng Thái', '13093', 3, 304),
(4677, 'Xã Bình Nguyên', '13096', 3, 304),
(4678, 'Xã Lê Lợi', '13102', 3, 304),
(4679, 'Xã Vũ Lễ', '13111', 3, 304),
(4680, 'Xã Thanh Tân', '13114', 3, 304),
(4681, 'Xã Thống Nhất', '13120', 3, 304),
(4682, 'Xã Vũ Ninh', '13126', 3, 304),
(4683, 'Xã Vũ An', '13129', 3, 304),
(4684, 'Xã Quang Lịch', '13132', 3, 304),
(4685, 'Xã Hòa Bình', '13135', 3, 304),
(4686, 'Xã Bình Minh', '13138', 3, 304),
(4687, 'Xã Vũ Quí', '13141', 3, 304),
(4688, 'Xã Quang Bình', '13144', 3, 304),
(4689, 'Xã Vũ Trung', '13150', 3, 304),
(4690, 'Xã Vũ Công', '13156', 3, 304),
(4691, 'Xã Hồng Vũ', '13159', 3, 304),
(4692, 'Xã Quang Minh', '13162', 3, 304),
(4693, 'Xã Quang Trung', '13165', 3, 304),
(4694, 'Xã Minh Quang', '13171', 3, 304),
(4695, 'Xã Minh Tân', '13177', 3, 304),
(4696, 'Xã Nam Bình', '13180', 3, 304),
(4697, 'Xã Bình Thanh', '13183', 3, 304),
(4698, 'Xã Bình Định', '13186', 3, 304),
(4699, 'Xã Hồng Tiến', '13189', 3, 304);

-- Tỉnh Thái Bình > Huyện Vũ Thư
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4700, 'Thị trấn Vũ Thư', '13192', 3, 305),
(4701, 'Xã Hồng Lý', '13195', 3, 305),
(4702, 'Xã Đồng Thanh', '13198', 3, 305),
(4703, 'Xã Xuân Hòa', '13201', 3, 305),
(4704, 'Xã Hiệp Hòa', '13204', 3, 305),
(4705, 'Xã Phúc Thành', '13207', 3, 305),
(4706, 'Xã Tân Phong', '13210', 3, 305),
(4707, 'Xã Song Lãng', '13213', 3, 305),
(4708, 'Xã Tân Hòa', '13216', 3, 305),
(4709, 'Xã Việt Hùng', '13219', 3, 305),
(4710, 'Xã Minh Lãng', '13222', 3, 305),
(4711, 'Xã Minh Khai', '13228', 3, 305),
(4712, 'Xã Dũng Nghĩa', '13231', 3, 305),
(4713, 'Xã Minh Quang', '13234', 3, 305),
(4714, 'Xã Tam Quang', '13237', 3, 305),
(4715, 'Xã Tân Lập', '13240', 3, 305),
(4716, 'Xã Bách Thuận', '13243', 3, 305),
(4717, 'Xã Tự Tân', '13246', 3, 305),
(4718, 'Xã Song An', '13249', 3, 305),
(4719, 'Xã Trung An', '13252', 3, 305),
(4720, 'Xã Vũ Hội', '13255', 3, 305),
(4721, 'Xã Hòa Bình', '13258', 3, 305),
(4722, 'Xã Nguyên Xá', '13261', 3, 305),
(4723, 'Xã Việt Thuận', '13264', 3, 305),
(4724, 'Xã Vũ Vinh', '13267', 3, 305),
(4725, 'Xã Vũ Đoài', '13270', 3, 305),
(4726, 'Xã Vũ Tiến', '13273', 3, 305),
(4727, 'Xã Vũ Vân', '13276', 3, 305),
(4728, 'Xã Duy Nhất', '13279', 3, 305),
(4729, 'Xã Hồng Phong', '13282', 3, 305);

-- Tỉnh Hà Nam > Thành phố Phủ Lý
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4730, 'Phường Quang Trung', '13285', 3, 306),
(4731, 'Phường Lê Hồng Phong', '13291', 3, 306),
(4732, 'Phường Châu Cầu', '13294', 3, 306),
(4733, 'Phường Lam Hạ', '13303', 3, 306),
(4734, 'Xã Phù Vân', '13306', 3, 306),
(4735, 'Phường Liêm Chính', '13309', 3, 306),
(4736, 'Phường Thanh Châu', '13315', 3, 306),
(4737, 'Phường Châu Sơn', '13318', 3, 306),
(4738, 'Phường Tân Hiệp', '13366', 3, 306),
(4739, 'Xã Kim Bình', '13426', 3, 306),
(4740, 'Phường Tân Liêm', '13444', 3, 306),
(4741, 'Phường Thanh Tuyền', '13459', 3, 306),
(4742, 'Xã Đinh Xá', '13507', 3, 306),
(4743, 'Xã Trịnh Xá', '13513', 3, 306);

-- Tỉnh Hà Nam > Thị xã Duy Tiên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4744, 'Phường Đồng Văn', '13321', 3, 307),
(4745, 'Phường Hòa Mạc', '13324', 3, 307),
(4746, 'Xã Mộc Hoàn', '13327', 3, 307),
(4747, 'Phường Châu Giang', '13330', 3, 307),
(4748, 'Phường Bạch Thượng', '13333', 3, 307),
(4749, 'Phường Duy Minh', '13336', 3, 307),
(4750, 'Phường Duy Hải', '13342', 3, 307),
(4751, 'Xã Chuyên Ngoại', '13345', 3, 307),
(4752, 'Phường Yên Bắc', '13348', 3, 307),
(4753, 'Xã Trác Văn', '13351', 3, 307),
(4754, 'Phường Tiên Nội', '13354', 3, 307),
(4755, 'Phường Hoàng Đông', '13357', 3, 307),
(4756, 'Xã Yên Nam', '13360', 3, 307),
(4757, 'Xã Tiên Ngoại', '13363', 3, 307),
(4758, 'Xã Tiên Sơn', '13369', 3, 307);

-- Tỉnh Hà Nam > Thị xã Kim Bảng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4759, 'Phường Quế', '13384', 3, 308),
(4760, 'Xã Nguyễn Úy', '13387', 3, 308),
(4761, 'Phường Đại Cương', '13390', 3, 308),
(4762, 'Phường Lê Hồ', '13393', 3, 308),
(4763, 'Phường Tượng Lĩnh', '13396', 3, 308),
(4764, 'Phường Tân Tựu', '13402', 3, 308),
(4765, 'Phường Đồng Hóa', '13405', 3, 308),
(4766, 'Xã Hoàng Tây', '13408', 3, 308),
(4767, 'Phường Tân Sơn', '13411', 3, 308),
(4768, 'Xã Thụy Lôi', '13414', 3, 308),
(4769, 'Xã Văn Xá', '13417', 3, 308),
(4770, 'Xã Khả Phong', '13420', 3, 308),
(4771, 'Phường Ngọc Sơn', '13423', 3, 308),
(4772, 'Phường Ba Sao', '13429', 3, 308),
(4773, 'Xã Liên Sơn', '13432', 3, 308),
(4774, 'Phường Thi Sơn', '13435', 3, 308),
(4775, 'Xã Thanh Sơn', '13438', 3, 308);

-- Tỉnh Hà Nam > Huyện Thanh Liêm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4776, 'Thị trấn Kiện Khê', '13441', 3, 309),
(4777, 'Xã Liêm Phong', '13450', 3, 309),
(4778, 'Xã Thanh Hà', '13453', 3, 309),
(4779, 'Xã Liêm Cần', '13456', 3, 309),
(4780, 'Xã Liêm Thuận', '13465', 3, 309),
(4781, 'Xã Thanh Thủy', '13468', 3, 309),
(4782, 'Xã Thanh Phong', '13471', 3, 309),
(4783, 'Thị trấn Tân Thanh', '13474', 3, 309),
(4784, 'Xã Thanh Tân', '13477', 3, 309),
(4785, 'Xã Liêm Túc', '13480', 3, 309),
(4786, 'Xã Liêm Sơn', '13483', 3, 309),
(4787, 'Xã Thanh Hương', '13486', 3, 309),
(4788, 'Xã Thanh Nghị', '13489', 3, 309),
(4789, 'Xã Thanh Tâm', '13492', 3, 309),
(4790, 'Xã Thanh Nguyên', '13495', 3, 309),
(4791, 'Xã Thanh Hải', '13498', 3, 309);

-- Tỉnh Hà Nam > Huyện Bình Lục
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4792, 'Thị trấn Bình Mỹ', '13501', 3, 310),
(4793, 'Xã Bình Nghĩa', '13504', 3, 310),
(4794, 'Xã Tràng An', '13510', 3, 310),
(4795, 'Xã Đồng Du', '13516', 3, 310),
(4796, 'Xã Ngọc Lũ', '13519', 3, 310),
(4797, 'Xã Đồn Xá', '13525', 3, 310),
(4798, 'Xã An Ninh', '13528', 3, 310),
(4799, 'Xã Bồ Đề', '13531', 3, 310),
(4800, 'Xã Bình An', '13540', 3, 310),
(4801, 'Xã Vũ Bản', '13543', 3, 310),
(4802, 'Xã Trung Lương', '13546', 3, 310),
(4803, 'Xã An Đổ', '13552', 3, 310),
(4804, 'Xã La Sơn', '13555', 3, 310),
(4805, 'Xã Tiêu Động', '13558', 3, 310),
(4806, 'Xã An Lão', '13561', 3, 310);

-- Tỉnh Hà Nam > Huyện Lý Nhân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4807, 'Xã Hợp Lý', '13567', 3, 311),
(4808, 'Xã Nguyên Lý', '13570', 3, 311),
(4809, 'Xã Chính Lý', '13573', 3, 311),
(4810, 'Xã Chân Lý', '13576', 3, 311),
(4811, 'Xã Đạo Lý', '13579', 3, 311),
(4812, 'Xã Công Lý', '13582', 3, 311),
(4813, 'Xã Văn Lý', '13585', 3, 311),
(4814, 'Xã Bắc Lý', '13588', 3, 311),
(4815, 'Xã Đức Lý', '13591', 3, 311),
(4816, 'Xã Trần Hưng Đạo', '13594', 3, 311),
(4817, 'Thị trấn Vĩnh Trụ', '13597', 3, 311),
(4818, 'Xã Nhân Thịnh', '13600', 3, 311),
(4819, 'Xã Nhân Khang', '13606', 3, 311),
(4820, 'Xã Nhân Mỹ', '13609', 3, 311),
(4821, 'Xã Nhân Nghĩa', '13612', 3, 311),
(4822, 'Xã Nhân Chính', '13615', 3, 311),
(4823, 'Xã Nhân Bình', '13618', 3, 311),
(4824, 'Xã Phú Phúc', '13621', 3, 311),
(4825, 'Xã Xuân Khê', '13624', 3, 311),
(4826, 'Xã Tiến Thắng', '13627', 3, 311),
(4827, 'Xã Hòa Hậu', '13630', 3, 311);

-- Tỉnh Nam Định > Thành phố Nam Định
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4828, 'Phường Vị Xuyên', '13636', 3, 312),
(4829, 'Phường Trường Thi', '13657', 3, 312),
(4830, 'Phường Trần Hưng Đạo', '13666', 3, 312),
(4831, 'Phường Cửa Bắc', '13669', 3, 312),
(4832, 'Phường Năng Tĩnh', '13678', 3, 312),
(4833, 'Phường Quang Trung', '13681', 3, 312),
(4834, 'Phường Lộc Hạ', '13684', 3, 312),
(4835, 'Phường Lộc Vượng', '13687', 3, 312),
(4836, 'Phường Cửa Nam', '13690', 3, 312),
(4837, 'Phường Lộc Hòa', '13693', 3, 312),
(4838, 'Phường Nam Phong', '13696', 3, 312),
(4839, 'Phường Mỹ Xá', '13699', 3, 312),
(4840, 'Phường Nam Vân', '13705', 3, 312),
(4841, 'Phường Hưng Lộc', '13708', 3, 312),
(4842, 'Xã Mỹ Hà', '13711', 3, 312),
(4843, 'Xã Mỹ Thắng', '13717', 3, 312),
(4844, 'Xã Mỹ Trung', '13720', 3, 312),
(4845, 'Xã Mỹ Tân', '13723', 3, 312),
(4846, 'Xã Mỹ Phúc', '13726', 3, 312),
(4847, 'Xã Mỹ Thuận', '13732', 3, 312),
(4848, 'Xã Mỹ Lộc', '13735', 3, 312);

-- Tỉnh Nam Định > Huyện Vụ Bản
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4849, 'Thị trấn Gôi', '13741', 3, 313),
(4850, 'Xã Hiển Khánh', '13747', 3, 313),
(4851, 'Xã Minh Tân', '13750', 3, 313),
(4852, 'Xã Hợp Hưng', '13753', 3, 313),
(4853, 'Xã Đại An', '13756', 3, 313),
(4854, 'Xã Cộng Hòa', '13762', 3, 313),
(4855, 'Xã Trung Thành', '13765', 3, 313),
(4856, 'Xã Quang Trung', '13768', 3, 313),
(4857, 'Xã Thành Lợi', '13777', 3, 313),
(4858, 'Xã Kim Thái', '13780', 3, 313),
(4859, 'Xã Liên Minh', '13783', 3, 313),
(4860, 'Xã Đại Thắng', '13786', 3, 313),
(4861, 'Xã Tam Thanh', '13789', 3, 313),
(4862, 'Xã Vĩnh Hào', '13792', 3, 313);

-- Tỉnh Nam Định > Huyện Ý Yên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4863, 'Thị trấn Lâm', '13795', 3, 314),
(4864, 'Xã Trung Nghĩa', '13801', 3, 314),
(4865, 'Xã Tân Minh', '13807', 3, 314),
(4866, 'Xã Yên Thọ', '13810', 3, 314),
(4867, 'Xã Phú Hưng', '13819', 3, 314),
(4868, 'Xã Yên Chính', '13822', 3, 314),
(4869, 'Xã Yên Bình', '13825', 3, 314),
(4870, 'Xã Yên Mỹ', '13831', 3, 314),
(4871, 'Xã Yên Dương', '13834', 3, 314),
(4872, 'Xã Yên Khánh', '13843', 3, 314),
(4873, 'Xã Yên Phong', '13846', 3, 314),
(4874, 'Xã Yên Ninh', '13849', 3, 314),
(4875, 'Xã Yên Lương', '13852', 3, 314),
(4876, 'Xã Yên Tiến', '13861', 3, 314),
(4877, 'Xã Yên Thắng', '13864', 3, 314),
(4878, 'Xã Yên Phúc', '13867', 3, 314),
(4879, 'Xã Yên Cường', '13870', 3, 314),
(4880, 'Xã Yên Lộc', '13873', 3, 314),
(4881, 'Xã Hồng Quang', '13876', 3, 314),
(4882, 'Xã Yên Đồng', '13879', 3, 314),
(4883, 'Xã Yên Khang', '13882', 3, 314),
(4884, 'Xã Yên Nhân', '13885', 3, 314),
(4885, 'Xã Yên Trị', '13888', 3, 314);

-- Tỉnh Nam Định > Huyện Nghĩa Hưng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4886, 'Thị trấn Liễu Đề', '13891', 3, 315),
(4887, 'Thị trấn Rạng Đông', '13894', 3, 315),
(4888, 'Xã Đồng Thịnh', '13900', 3, 315),
(4889, 'Xã Nghĩa Thái', '13906', 3, 315),
(4890, 'Xã Hoàng Nam', '13909', 3, 315),
(4891, 'Xã Nghĩa Châu', '13912', 3, 315),
(4892, 'Xã Nghĩa Trung', '13915', 3, 315),
(4893, 'Xã Nghĩa Sơn', '13918', 3, 315),
(4894, 'Xã Nghĩa Lạc', '13921', 3, 315),
(4895, 'Xã Nghĩa Hồng', '13924', 3, 315),
(4896, 'Xã Nghĩa Phong', '13927', 3, 315),
(4897, 'Xã Nghĩa Phú', '13930', 3, 315),
(4898, 'Thị trấn Quỹ Nhất', '13939', 3, 315),
(4899, 'Xã Nghĩa Hùng', '13942', 3, 315),
(4900, 'Xã Nghĩa Lâm', '13945', 3, 315),
(4901, 'Xã Nghĩa Thành', '13948', 3, 315),
(4902, 'Xã Phúc Thắng', '13951', 3, 315),
(4903, 'Xã Nghĩa Lợi', '13954', 3, 315),
(4904, 'Xã Nghĩa Hải', '13957', 3, 315),
(4905, 'Xã Nam Điền', '13963', 3, 315);

-- Tỉnh Nam Định > Huyện Nam Trực
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4906, 'Thị trấn Nam Giang', '13966', 3, 316),
(4907, 'Xã Nam Điền', '13972', 3, 316),
(4908, 'Xã Nghĩa An', '13975', 3, 316),
(4909, 'Xã Nam Thắng', '13978', 3, 316),
(4910, 'Xã Hồng Quang', '13984', 3, 316),
(4911, 'Xã Tân Thịnh', '13987', 3, 316),
(4912, 'Xã Nam Cường', '13990', 3, 316),
(4913, 'Xã Nam Hồng', '13993', 3, 316),
(4914, 'Xã Nam Hùng', '13996', 3, 316),
(4915, 'Xã Nam Hoa', '13999', 3, 316),
(4916, 'Xã Nam Dương', '14002', 3, 316),
(4917, 'Xã Nam Thanh', '14005', 3, 316),
(4918, 'Xã Nam Lợi', '14008', 3, 316),
(4919, 'Xã Bình Minh', '14011', 3, 316),
(4920, 'Xã Đồng Sơn', '14014', 3, 316),
(4921, 'Xã Nam Tiến', '14017', 3, 316),
(4922, 'Xã Nam Hải', '14020', 3, 316),
(4923, 'Xã Nam Thái', '14023', 3, 316);

-- Tỉnh Nam Định > Huyện Trực Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4924, 'Thị trấn Cổ Lễ', '14026', 3, 317),
(4925, 'Xã Phương Định', '14029', 3, 317),
(4926, 'Xã Trực Chính', '14032', 3, 317),
(4927, 'Xã Trung Đông', '14035', 3, 317),
(4928, 'Xã Liêm Hải', '14038', 3, 317),
(4929, 'Xã Trực Tuấn', '14041', 3, 317),
(4930, 'Xã Việt Hùng', '14044', 3, 317),
(4931, 'Xã Trực Đạo', '14047', 3, 317),
(4932, 'Xã Trực Hưng', '14050', 3, 317),
(4933, 'Xã Trực Nội', '14053', 3, 317),
(4934, 'Thị trấn Cát Thành', '14056', 3, 317),
(4935, 'Xã Trực Thanh', '14059', 3, 317),
(4936, 'Xã Trực Khang', '14062', 3, 317),
(4937, 'Xã Trực Thuận', '14065', 3, 317),
(4938, 'Xã Trực Mỹ', '14068', 3, 317),
(4939, 'Xã Trực Đại', '14071', 3, 317),
(4940, 'Xã Trực Cường', '14074', 3, 317),
(4941, 'Thị trấn Ninh Cường', '14077', 3, 317),
(4942, 'Xã Trực Thái', '14080', 3, 317),
(4943, 'Xã Trực Hùng', '14083', 3, 317),
(4944, 'Xã Trực Thắng', '14086', 3, 317);

-- Tỉnh Nam Định > Huyện Xuân Trường
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4945, 'Thị trấn Xuân Trường', '14089', 3, 318),
(4946, 'Xã Xuân Châu', '14092', 3, 318),
(4947, 'Xã Xuân Hồng', '14095', 3, 318),
(4948, 'Xã Xuân Thành', '14098', 3, 318),
(4949, 'Xã Xuân Thượng', '14101', 3, 318),
(4950, 'Xã Xuân Giang', '14104', 3, 318),
(4951, 'Xã Xuân Tân', '14110', 3, 318),
(4952, 'Xã Xuân Ngọc', '14116', 3, 318),
(4953, 'Xã Trà Lũ', '14122', 3, 318),
(4954, 'Xã Thọ Nghiệp', '14125', 3, 318),
(4955, 'Xã Xuân Phú', '14128', 3, 318),
(4956, 'Xã Xuân Vinh', '14134', 3, 318),
(4957, 'Xã Xuân Ninh', '14143', 3, 318),
(4958, 'Xã Xuân Phúc', '14146', 3, 318);

-- Tỉnh Nam Định > Huyện Giao Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4959, 'Thị trấn Quất Lâm', '14152', 3, 319),
(4960, 'Xã Giao Hương', '14155', 3, 319),
(4961, 'Xã Hồng Thuận', '14158', 3, 319),
(4962, 'Xã Giao Thiện', '14161', 3, 319),
(4963, 'Xã Giao Thanh', '14164', 3, 319),
(4964, 'Thị trấn Giao Thủy', '14167', 3, 319),
(4965, 'Xã Bình Hòa', '14170', 3, 319),
(4966, 'Xã Giao Hà', '14176', 3, 319),
(4967, 'Xã Giao Nhân', '14179', 3, 319),
(4968, 'Xã Giao An', '14182', 3, 319),
(4969, 'Xã Giao Lạc', '14185', 3, 319),
(4970, 'Xã Giao Châu', '14188', 3, 319),
(4971, 'Xã Giao Tân', '14191', 3, 319),
(4972, 'Xã Giao Yến', '14194', 3, 319),
(4973, 'Xã Giao Xuân', '14197', 3, 319),
(4974, 'Xã Giao Thịnh', '14200', 3, 319),
(4975, 'Xã Giao Hải', '14203', 3, 319),
(4976, 'Xã Bạch Long', '14206', 3, 319),
(4977, 'Xã Giao Long', '14209', 3, 319),
(4978, 'Xã Giao Phong', '14212', 3, 319);

-- Tỉnh Nam Định > Huyện Hải Hậu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(4979, 'Thị trấn Yên Định', '14215', 3, 320),
(4980, 'Thị trấn Cồn', '14218', 3, 320),
(4981, 'Thị trấn Thịnh Long', '14221', 3, 320),
(4982, 'Xã Hải Nam', '14224', 3, 320),
(4983, 'Xã Hải Trung', '14227', 3, 320),
(4984, 'Xã Hải Minh', '14233', 3, 320),
(4985, 'Xã Hải Anh', '14236', 3, 320),
(4986, 'Xã Hải Hưng', '14248', 3, 320),
(4987, 'Xã Hải Long', '14254', 3, 320),
(4988, 'Xã Hải Đường', '14260', 3, 320),
(4989, 'Xã Hải Lộc', '14263', 3, 320),
(4990, 'Xã Hải Quang', '14266', 3, 320),
(4991, 'Xã Hải Đông', '14269', 3, 320),
(4992, 'Xã Hải Sơn', '14272', 3, 320),
(4993, 'Xã Hải Tân', '14275', 3, 320),
(4994, 'Xã Hải Phong', '14281', 3, 320),
(4995, 'Xã Hải An', '14284', 3, 320),
(4996, 'Xã Hải Tây', '14287', 3, 320),
(4997, 'Xã Hải Phú', '14293', 3, 320),
(4998, 'Xã Hải Giang', '14296', 3, 320),
(4999, 'Xã Hải Ninh', '14302', 3, 320),
(5000, 'Xã Hải Xuân', '14308', 3, 320),
(5001, 'Xã Hải Châu', '14311', 3, 320),
(5002, 'Xã Hải Hòa', '14317', 3, 320);

-- Tỉnh Ninh Bình > Thành phố Tam Điệp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5003, 'Phường Bắc Sơn', '14362', 3, 321),
(5004, 'Phường Trung Sơn', '14365', 3, 321),
(5005, 'Phường Nam Sơn', '14368', 3, 321),
(5006, 'Phường Tây Sơn', '14369', 3, 321),
(5007, 'Xã Yên Sơn', '14371', 3, 321),
(5008, 'Phường Yên Bình', '14374', 3, 321),
(5009, 'Phường Tân Bình', '14375', 3, 321),
(5010, 'Xã Quang Sơn', '14377', 3, 321),
(5011, 'Xã Đông Sơn', '14380', 3, 321);

-- Tỉnh Ninh Bình > Huyện Nho Quan
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5012, 'Xã Xích Thổ', '14386', 3, 322),
(5013, 'Xã Gia Lâm', '14389', 3, 322),
(5014, 'Xã Gia Sơn', '14392', 3, 322),
(5015, 'Xã Thạch Bình', '14395', 3, 322),
(5016, 'Xã Gia Thủy', '14398', 3, 322),
(5017, 'Xã Gia Tường', '14401', 3, 322),
(5018, 'Xã Cúc Phương', '14404', 3, 322),
(5019, 'Xã Phú Sơn', '14407', 3, 322),
(5020, 'Xã Đức Long', '14410', 3, 322),
(5021, 'Xã Lạc Vân', '14413', 3, 322),
(5022, 'Xã Đồng Phong', '14416', 3, 322),
(5023, 'Xã Yên Quang', '14419', 3, 322),
(5024, 'Xã Thượng Hòa', '14425', 3, 322),
(5025, 'Thị trấn Nho Quan', '14428', 3, 322),
(5026, 'Xã Văn Phương', '14431', 3, 322),
(5027, 'Xã Thanh Sơn', '14434', 3, 322),
(5028, 'Xã Phúc Sơn', '14437', 3, 322),
(5029, 'Xã Văn Phú', '14443', 3, 322),
(5030, 'Xã Phú Lộc', '14446', 3, 322),
(5031, 'Xã Kỳ Phú', '14449', 3, 322),
(5032, 'Xã Quỳnh Lưu', '14452', 3, 322),
(5033, 'Xã Phú Long', '14458', 3, 322),
(5034, 'Xã Quảng Lạc', '14461', 3, 322);

-- Tỉnh Ninh Bình > Huyện Gia Viễn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5035, 'Thị trấn Thịnh Vượng', '14464', 3, 323),
(5036, 'Xã Gia Hòa', '14467', 3, 323),
(5037, 'Xã Gia Hưng', '14470', 3, 323),
(5038, 'Xã Liên Sơn', '14473', 3, 323),
(5039, 'Xã Gia Thanh', '14476', 3, 323),
(5040, 'Xã Gia Vân', '14479', 3, 323),
(5041, 'Xã Gia Phú', '14482', 3, 323),
(5042, 'Xã Gia Xuân', '14485', 3, 323),
(5043, 'Xã Gia Lập', '14488', 3, 323),
(5044, 'Xã Gia Trấn', '14494', 3, 323),
(5045, 'Xã Gia Phương', '14500', 3, 323),
(5046, 'Xã Gia Tân', '14503', 3, 323),
(5047, 'Xã Tiến Thắng', '14506', 3, 323),
(5048, 'Xã Gia Trung', '14509', 3, 323),
(5049, 'Xã Gia Minh', '14512', 3, 323),
(5050, 'Xã Gia Lạc', '14515', 3, 323),
(5051, 'Xã Gia Sinh', '14521', 3, 323),
(5052, 'Xã Gia Phong', '14524', 3, 323);

-- Tỉnh Ninh Bình > Thành phố Hoa Lư
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5053, 'Phường Đông Thành', '14320', 3, 324),
(5054, 'Phường Tân Thành', '14323', 3, 324),
(5055, 'Phường Vân Giang', '14329', 3, 324),
(5056, 'Phường Bích Đào', '14332', 3, 324),
(5057, 'Phường Nam Bình', '14338', 3, 324),
(5058, 'Phường Nam Thành', '14341', 3, 324),
(5059, 'Phường Ninh Khánh', '14344', 3, 324),
(5060, 'Xã Ninh Nhất', '14347', 3, 324),
(5061, 'Xã Ninh Tiến', '14350', 3, 324),
(5062, 'Phường Ninh Phúc', '14353', 3, 324),
(5063, 'Phường Ninh Sơn', '14356', 3, 324),
(5064, 'Phường Ninh Phong', '14359', 3, 324),
(5065, 'Phường Ninh Mỹ', '14527', 3, 324),
(5066, 'Phường Ninh Giang', '14530', 3, 324),
(5067, 'Xã Trường Yên', '14533', 3, 324),
(5068, 'Xã Ninh Khang', '14536', 3, 324),
(5069, 'Xã Ninh Hòa', '14542', 3, 324),
(5070, 'Xã Ninh Hải', '14551', 3, 324),
(5071, 'Xã Ninh Vân', '14554', 3, 324),
(5072, 'Xã Ninh An', '14557', 3, 324);

-- Tỉnh Ninh Bình > Huyện Yên Khánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5073, 'Thị trấn Yên Ninh', '14560', 3, 325),
(5074, 'Xã Khánh Thiện', '14563', 3, 325),
(5075, 'Xã Khánh Phú', '14566', 3, 325),
(5076, 'Xã Khánh Hòa', '14569', 3, 325),
(5077, 'Xã Khánh Lợi', '14572', 3, 325),
(5078, 'Xã Khánh An', '14575', 3, 325),
(5079, 'Xã Khánh Cường', '14578', 3, 325),
(5080, 'Xã Khánh Cư', '14581', 3, 325),
(5081, 'Xã Khánh Hải', '14587', 3, 325),
(5082, 'Xã Khánh Trung', '14590', 3, 325),
(5083, 'Xã Khánh Mậu', '14593', 3, 325),
(5084, 'Xã Khánh Vân', '14596', 3, 325),
(5085, 'Xã Khánh Hội', '14599', 3, 325),
(5086, 'Xã Khánh Công', '14602', 3, 325),
(5087, 'Xã Khánh Thành', '14608', 3, 325),
(5088, 'Xã Khánh Nhạc', '14611', 3, 325),
(5089, 'Xã Khánh Thủy', '14614', 3, 325),
(5090, 'Xã Khánh Hồng', '14617', 3, 325);

-- Tỉnh Ninh Bình > Huyện Kim Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5091, 'Thị trấn Phát Diệm', '14620', 3, 326),
(5092, 'Thị trấn Bình Minh', '14623', 3, 326),
(5093, 'Xã Hồi Ninh', '14629', 3, 326),
(5094, 'Xã Xuân Chính', '14632', 3, 326),
(5095, 'Xã Kim Định', '14635', 3, 326),
(5096, 'Xã Ân Hòa', '14638', 3, 326),
(5097, 'Xã Hùng Tiến', '14641', 3, 326),
(5098, 'Xã Quang Thiện', '14647', 3, 326),
(5099, 'Xã Như Hòa', '14650', 3, 326),
(5100, 'Xã Chất Bình', '14653', 3, 326),
(5101, 'Xã Đồng Hướng', '14656', 3, 326),
(5102, 'Xã Kim Chính', '14659', 3, 326),
(5103, 'Xã Thượng Kiệm', '14662', 3, 326),
(5104, 'Xã Tân Thành', '14668', 3, 326),
(5105, 'Xã Yên Lộc', '14671', 3, 326),
(5106, 'Xã Lai Thành', '14674', 3, 326),
(5107, 'Xã Định Hóa', '14677', 3, 326),
(5108, 'Xã Văn Hải', '14680', 3, 326),
(5109, 'Xã Kim Tân', '14683', 3, 326),
(5110, 'Xã Kim Mỹ', '14686', 3, 326),
(5111, 'Xã Cồn Thoi', '14689', 3, 326),
(5112, 'Xã Kim Trung', '14695', 3, 326),
(5113, 'Xã Kim Đông', '14698', 3, 326);

-- Tỉnh Ninh Bình > Huyện Yên Mô
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5114, 'Thị trấn Yên Thịnh', '14701', 3, 327),
(5115, 'Xã Khánh Thượng', '14704', 3, 327),
(5116, 'Xã Khánh Dương', '14707', 3, 327),
(5117, 'Xã Yên Phong', '14719', 3, 327),
(5118, 'Xã Yên Hòa', '14722', 3, 327),
(5119, 'Xã Yên Thắng', '14725', 3, 327),
(5120, 'Xã Yên Từ', '14728', 3, 327),
(5121, 'Xã Yên Thành', '14734', 3, 327),
(5122, 'Xã Yên Nhân', '14737', 3, 327),
(5123, 'Xã Yên Mỹ', '14740', 3, 327),
(5124, 'Xã Yên Mạc', '14743', 3, 327),
(5125, 'Xã Yên Đồng', '14746', 3, 327),
(5126, 'Xã Yên Thái', '14749', 3, 327),
(5127, 'Xã Yên Lâm', '14752', 3, 327);

-- Tỉnh Thanh Hóa > Thành phố Thanh Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5128, 'Phường Hàm Rồng', '14755', 3, 328),
(5129, 'Phường Đông Thọ', '14758', 3, 328),
(5130, 'Phường Nam Ngạn', '14761', 3, 328),
(5131, 'Phường Trường Thi', '14764', 3, 328),
(5132, 'Phường Điện Biên', '14767', 3, 328),
(5133, 'Phường Phú Sơn', '14770', 3, 328),
(5134, 'Phường Lam Sơn', '14773', 3, 328),
(5135, 'Phường Ba Đình', '14776', 3, 328),
(5136, 'Phường Ngọc Trạo', '14779', 3, 328),
(5137, 'Phường Đông Vệ', '14782', 3, 328),
(5138, 'Phường Đông Sơn', '14785', 3, 328),
(5139, 'Phường Đông Cương', '14791', 3, 328),
(5140, 'Phường Đông Hương', '14794', 3, 328),
(5141, 'Phường Đông Hải', '14797', 3, 328),
(5142, 'Phường Quảng Hưng', '14800', 3, 328),
(5143, 'Phường Quảng Thắng', '14803', 3, 328),
(5144, 'Phường Quảng Thành', '14806', 3, 328),
(5145, 'Xã Thiệu Vân', '15850', 3, 328),
(5146, 'Phường Thiệu Khánh', '15856', 3, 328),
(5147, 'Phường Thiệu Dương', '15859', 3, 328),
(5148, 'Phường Tào Xuyên', '15913', 3, 328),
(5149, 'Phường Long Anh', '15922', 3, 328),
(5150, 'Phường Hoằng Quang', '15925', 3, 328),
(5151, 'Phường Hoằng Đại', '15970', 3, 328),
(5152, 'Phường Rừng Thông', '16378', 3, 328),
(5153, 'Xã Đông Hoàng', '16381', 3, 328),
(5154, 'Xã Đông Ninh', '16384', 3, 328),
(5155, 'Xã Đông Khê', '16387', 3, 328),
(5156, 'Xã Đông Hòa', '16390', 3, 328),
(5157, 'Xã Đông Yên', '16393', 3, 328),
(5158, 'Phường Đông Lĩnh', '16396', 3, 328),
(5159, 'Xã Đông Minh', '16399', 3, 328),
(5160, 'Xã Đông Thanh', '16402', 3, 328),
(5161, 'Xã Đông Tiến', '16405', 3, 328),
(5162, 'Xã Đông Khê', '16408', 3, 328),
(5163, 'Xã Đông Xuân', '16411', 3, 328),
(5164, 'Phường Đông Thịnh', '16414', 3, 328),
(5165, 'Xã Đông Văn', '16417', 3, 328),
(5166, 'Xã Đông Phú', '16420', 3, 328),
(5167, 'Xã Đông Nam', '16423', 3, 328),
(5168, 'Xã Đông Quang', '16426', 3, 328),
(5169, 'Xã Đông Vinh', '16429', 3, 328),
(5170, 'Phường Đông Tân', '16432', 3, 328),
(5171, 'Phường An Hưng', '16435', 3, 328),
(5172, 'Phường Quảng Thịnh', '16441', 3, 328),
(5173, 'Phường Quảng Đông', '16459', 3, 328),
(5174, 'Phường Quảng Cát', '16507', 3, 328),
(5175, 'Phường Quảng Phú', '16522', 3, 328),
(5176, 'Phường Quảng Tâm', '16525', 3, 328);

-- Tỉnh Thanh Hóa > Thị xã Bỉm Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5177, 'Phường Bắc Sơn', '14809', 3, 329),
(5178, 'Phường Ba Đình', '14812', 3, 329),
(5179, 'Phường Lam Sơn', '14815', 3, 329),
(5180, 'Phường Ngọc Trạo', '14818', 3, 329),
(5181, 'Phường Đông Sơn', '14821', 3, 329),
(5182, 'Phường Phú Sơn', '14823', 3, 329),
(5183, 'Xã Quang Trung', '14824', 3, 329);

-- Tỉnh Thanh Hóa > Thành phố Sầm Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5184, 'Phường Trung Sơn', '14830', 3, 330),
(5185, 'Phường Bắc Sơn', '14833', 3, 330),
(5186, 'Phường Trường Sơn', '14836', 3, 330),
(5187, 'Phường Quảng Cư', '14839', 3, 330),
(5188, 'Phường Quảng Tiến', '14842', 3, 330),
(5189, 'Xã Quảng Minh', '16513', 3, 330),
(5190, 'Xã Đại Hùng', '16516', 3, 330),
(5191, 'Phường Quảng Thọ', '16528', 3, 330),
(5192, 'Phường Quảng Châu', '16531', 3, 330),
(5193, 'Phường Quảng Vinh', '16534', 3, 330);

-- Tỉnh Thanh Hóa > Huyện Mường Lát
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5194, 'Thị trấn Mường Lát', '14845', 3, 331),
(5195, 'Xã Tam Chung', '14848', 3, 331),
(5196, 'Xã Mường Lý', '14854', 3, 331),
(5197, 'Xã Trung Lý', '14857', 3, 331),
(5198, 'Xã Quang Chiểu', '14860', 3, 331),
(5199, 'Xã Pù Nhi', '14863', 3, 331),
(5200, 'Xã Nhi Sơn', '14864', 3, 331),
(5201, 'Xã Mường Chanh', '14866', 3, 331);

-- Tỉnh Thanh Hóa > Huyện Quan Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5202, 'Thị trấn Hồi Xuân', '14869', 3, 332),
(5203, 'Xã Thành Sơn', '14872', 3, 332),
(5204, 'Xã Trung Sơn', '14875', 3, 332),
(5205, 'Xã Phú Thanh', '14878', 3, 332),
(5206, 'Xã Trung Thành', '14881', 3, 332),
(5207, 'Xã Phú Lệ', '14884', 3, 332),
(5208, 'Xã Phú Sơn', '14887', 3, 332),
(5209, 'Xã Phú Xuân', '14890', 3, 332),
(5210, 'Xã Hiền Chung', '14896', 3, 332),
(5211, 'Xã Hiền Kiệt', '14899', 3, 332),
(5212, 'Xã Nam Tiến', '14902', 3, 332),
(5213, 'Xã Thiên Phủ', '14908', 3, 332),
(5214, 'Xã Phú Nghiêm', '14911', 3, 332),
(5215, 'Xã Nam Xuân', '14914', 3, 332),
(5216, 'Xã Nam Động', '14917', 3, 332);

-- Tỉnh Thanh Hóa > Huyện Bá Thước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5217, 'Thị trấn Cành Nàng', '14923', 3, 333),
(5218, 'Xã Điền Thượng', '14926', 3, 333),
(5219, 'Xã Điền Hạ', '14929', 3, 333),
(5220, 'Xã Điền Quang', '14932', 3, 333),
(5221, 'Xã Điền Trung', '14935', 3, 333),
(5222, 'Xã Thành Sơn', '14938', 3, 333),
(5223, 'Xã Lương Ngoại', '14941', 3, 333),
(5224, 'Xã Ái Thượng', '14944', 3, 333),
(5225, 'Xã Lương Nội', '14947', 3, 333),
(5226, 'Xã Điền Lư', '14950', 3, 333),
(5227, 'Xã Lương Trung', '14953', 3, 333),
(5228, 'Xã Lũng Niêm', '14956', 3, 333),
(5229, 'Xã Lũng Cao', '14959', 3, 333),
(5230, 'Xã Hạ Trung', '14962', 3, 333),
(5231, 'Xã Cổ Lũng', '14965', 3, 333),
(5232, 'Xã Thành Lâm', '14968', 3, 333),
(5233, 'Xã Ban Công', '14971', 3, 333),
(5234, 'Xã Kỳ Tân', '14974', 3, 333),
(5235, 'Xã Văn Nho', '14977', 3, 333),
(5236, 'Xã Thiết Ống', '14980', 3, 333),
(5237, 'Xã Thiết Kế', '14986', 3, 333);

-- Tỉnh Thanh Hóa > Huyện Quan Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5238, 'Xã Trung Xuân', '14995', 3, 334),
(5239, 'Xã Trung Thượng', '14998', 3, 334),
(5240, 'Xã Trung Tiến', '14999', 3, 334),
(5241, 'Xã Trung Hạ', '15001', 3, 334),
(5242, 'Xã Sơn Hà', '15004', 3, 334),
(5243, 'Xã Tam Thanh', '15007', 3, 334),
(5244, 'Xã Sơn Thủy', '15010', 3, 334),
(5245, 'Xã Na Mèo', '15013', 3, 334),
(5246, 'Thị trấn Sơn Lư', '15016', 3, 334),
(5247, 'Xã Tam Lư', '15019', 3, 334),
(5248, 'Xã Sơn Điện', '15022', 3, 334),
(5249, 'Xã Mường Mìn', '15025', 3, 334);

-- Tỉnh Thanh Hóa > Huyện Lang Chánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5250, 'Xã Yên Khương', '15031', 3, 335),
(5251, 'Xã Yên Thắng', '15034', 3, 335),
(5252, 'Xã Trí Nang', '15037', 3, 335),
(5253, 'Xã Giao An', '15040', 3, 335),
(5254, 'Xã Giao Thiện', '15043', 3, 335),
(5255, 'Xã Tân Phúc', '15046', 3, 335),
(5256, 'Xã Tam Văn', '15049', 3, 335),
(5257, 'Xã Lâm Phú', '15052', 3, 335),
(5258, 'Thị trấn Lang Chánh', '15055', 3, 335),
(5259, 'Xã Đồng Lương', '15058', 3, 335);

-- Tỉnh Thanh Hóa > Huyện Ngọc Lặc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5260, 'Thị trấn Ngọc Lặc', '15061', 3, 336),
(5261, 'Xã Lam Sơn', '15064', 3, 336),
(5262, 'Xã Mỹ Tân', '15067', 3, 336),
(5263, 'Xã Thúy Sơn', '15070', 3, 336),
(5264, 'Xã Thạch Lập', '15073', 3, 336),
(5265, 'Xã Vân Âm', '15076', 3, 336),
(5266, 'Xã Cao Ngọc', '15079', 3, 336),
(5267, 'Xã Quang Trung', '15085', 3, 336),
(5268, 'Xã Đồng Thịnh', '15088', 3, 336),
(5269, 'Xã Ngọc Liên', '15091', 3, 336),
(5270, 'Xã Ngọc Sơn', '15094', 3, 336),
(5271, 'Xã Lộc Thịnh', '15097', 3, 336),
(5272, 'Xã Cao Thịnh', '15100', 3, 336),
(5273, 'Xã Ngọc Trung', '15103', 3, 336),
(5274, 'Xã Phùng Giáo', '15106', 3, 336),
(5275, 'Xã Phùng Minh', '15109', 3, 336),
(5276, 'Xã Phúc Thịnh', '15112', 3, 336),
(5277, 'Xã Nguyệt Ấn', '15115', 3, 336),
(5278, 'Xã Kiên Thọ', '15118', 3, 336),
(5279, 'Xã Minh Tiến', '15121', 3, 336),
(5280, 'Xã Minh Sơn', '15124', 3, 336);

-- Tỉnh Thanh Hóa > Huyện Cẩm Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5281, 'Thị trấn Phong Sơn', '15127', 3, 337),
(5282, 'Xã Cẩm Thành', '15133', 3, 337),
(5283, 'Xã Cẩm Quý', '15136', 3, 337),
(5284, 'Xã Cẩm Lương', '15139', 3, 337),
(5285, 'Xã Cẩm Thạch', '15142', 3, 337),
(5286, 'Xã Cẩm Liên', '15145', 3, 337),
(5287, 'Xã Cẩm Giang', '15148', 3, 337),
(5288, 'Xã Cẩm Bình', '15151', 3, 337),
(5289, 'Xã Cẩm Tú', '15154', 3, 337),
(5290, 'Xã Cẩm Châu', '15160', 3, 337),
(5291, 'Xã Cẩm Tâm', '15163', 3, 337),
(5292, 'Xã Cẩm Ngọc', '15169', 3, 337),
(5293, 'Xã Cẩm Long', '15172', 3, 337),
(5294, 'Xã Cẩm Yên', '15175', 3, 337),
(5295, 'Xã Cẩm Tân', '15178', 3, 337),
(5296, 'Xã Cẩm Phú', '15181', 3, 337),
(5297, 'Xã Cẩm Vân', '15184', 3, 337);

-- Tỉnh Thanh Hóa > Huyện Thạch Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5298, 'Thị trấn Kim Tân', '15187', 3, 338),
(5299, 'Thị trấn Vân Du', '15190', 3, 338),
(5300, 'Xã Thạch Lâm', '15196', 3, 338),
(5301, 'Xã Thạch Quảng', '15199', 3, 338),
(5302, 'Xã Thạch Tượng', '15202', 3, 338),
(5303, 'Xã Thạch Cẩm', '15205', 3, 338),
(5304, 'Xã Thạch Sơn', '15208', 3, 338),
(5305, 'Xã Thạch Bình', '15211', 3, 338),
(5306, 'Xã Thạch Định', '15214', 3, 338),
(5307, 'Xã Thạch Long', '15220', 3, 338),
(5308, 'Xã Thành Mỹ', '15223', 3, 338),
(5309, 'Xã Thành Yên', '15226', 3, 338),
(5310, 'Xã Thành Vinh', '15229', 3, 338),
(5311, 'Xã Thành Minh', '15232', 3, 338),
(5312, 'Xã Thành Công', '15235', 3, 338),
(5313, 'Xã Thành Tân', '15238', 3, 338),
(5314, 'Xã Thành Trực', '15241', 3, 338),
(5315, 'Xã Thành Tâm', '15247', 3, 338),
(5316, 'Xã Thành An', '15250', 3, 338),
(5317, 'Xã Thành Thọ', '15253', 3, 338),
(5318, 'Xã Thành Tiến', '15256', 3, 338),
(5319, 'Xã Thành Long', '15259', 3, 338),
(5320, 'Xã Thành Hưng', '15265', 3, 338),
(5321, 'Xã Ngọc Trạo', '15268', 3, 338);

-- Tỉnh Thanh Hóa > Huyện Hà Trung
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5322, 'Thị trấn Hà Trung', '15271', 3, 339),
(5323, 'Thị trấn Hà Long', '15274', 3, 339),
(5324, 'Xã Hà Vinh', '15277', 3, 339),
(5325, 'Xã Hà Bắc', '15280', 3, 339),
(5326, 'Xã Hoạt Giang', '15283', 3, 339),
(5327, 'Xã Yên Dương', '15286', 3, 339),
(5328, 'Xã Hà Giang', '15292', 3, 339),
(5329, 'Xã Lĩnh Toại', '15298', 3, 339),
(5330, 'Xã Hà Ngọc', '15304', 3, 339),
(5331, 'Xã Yến Sơn', '15307', 3, 339),
(5332, 'Xã Hà Sơn', '15313', 3, 339),
(5333, 'Thị trấn Hà Lĩnh', '15316', 3, 339),
(5334, 'Xã Hà Đông', '15319', 3, 339),
(5335, 'Xã Hà Tân', '15322', 3, 339),
(5336, 'Xã Hà Tiến', '15325', 3, 339),
(5337, 'Xã Hà Bình', '15328', 3, 339),
(5338, 'Xã Thái Lai', '15331', 3, 339),
(5339, 'Xã Hà Châu', '15334', 3, 339),
(5340, 'Xã Hà Hải', '15343', 3, 339);

-- Tỉnh Thanh Hóa > Huyện Vĩnh Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5341, 'Thị trấn Vĩnh Lộc', '15349', 3, 340),
(5342, 'Xã Vĩnh Quang', '15352', 3, 340),
(5343, 'Xã Vĩnh Yên', '15355', 3, 340),
(5344, 'Xã Vĩnh Tiến', '15358', 3, 340),
(5345, 'Xã Vĩnh Long', '15361', 3, 340),
(5346, 'Xã Vĩnh Phúc', '15364', 3, 340),
(5347, 'Xã Vĩnh Hưng', '15367', 3, 340),
(5348, 'Xã Vĩnh Hòa', '15376', 3, 340),
(5349, 'Xã Vĩnh Hùng', '15379', 3, 340),
(5350, 'Xã Minh Tân', '15382', 3, 340),
(5351, 'Xã Ninh Khang', '15385', 3, 340),
(5352, 'Xã Vĩnh Thịnh', '15388', 3, 340),
(5353, 'Xã Vĩnh An', '15391', 3, 340);

-- Tỉnh Thanh Hóa > Huyện Yên Định
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5354, 'Thị trấn Thống Nhất', '15397', 3, 341),
(5355, 'Thị trấn Yên Lâm', '15403', 3, 341),
(5356, 'Xã Yên Tâm', '15406', 3, 341),
(5357, 'Xã Yên Phú', '15409', 3, 341),
(5358, 'Thị trấn Quý Lộc', '15412', 3, 341),
(5359, 'Xã Yên Thọ', '15415', 3, 341),
(5360, 'Xã Yên Trung', '15418', 3, 341),
(5361, 'Xã Yên Trường', '15421', 3, 341),
(5362, 'Xã Yên Phong', '15427', 3, 341),
(5363, 'Xã Yên Thái', '15430', 3, 341),
(5364, 'Xã Yên Hùng', '15433', 3, 341),
(5365, 'Xã Yên Thịnh', '15436', 3, 341),
(5366, 'Xã Yên Ninh', '15442', 3, 341),
(5367, 'Xã Định Tăng', '15445', 3, 341),
(5368, 'Xã Định Hòa', '15448', 3, 341),
(5369, 'Xã Định Thành', '15451', 3, 341),
(5370, 'Xã Định Công', '15454', 3, 341),
(5371, 'Xã Định Tân', '15457', 3, 341),
(5372, 'Xã Định Tiến', '15460', 3, 341),
(5373, 'Xã Định Long', '15463', 3, 341),
(5374, 'Xã Định Liên', '15466', 3, 341),
(5375, 'Thị trấn Quán Lào', '15469', 3, 341),
(5376, 'Xã Định Hưng', '15472', 3, 341),
(5377, 'Xã Định Hải', '15475', 3, 341),
(5378, 'Xã Định Bình', '15478', 3, 341);

-- Tỉnh Thanh Hóa > Huyện Thọ Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5379, 'Xã Xuân Hồng', '15493', 3, 342),
(5380, 'Thị trấn Thọ Xuân', '15499', 3, 342),
(5381, 'Xã Bắc Lương', '15502', 3, 342),
(5382, 'Xã Nam Giang', '15505', 3, 342),
(5383, 'Xã Xuân Phong', '15508', 3, 342),
(5384, 'Xã Thọ Lộc', '15511', 3, 342),
(5385, 'Xã Xuân Trường', '15514', 3, 342),
(5386, 'Xã Xuân Hòa', '15517', 3, 342),
(5387, 'Xã Thọ Hải', '15520', 3, 342),
(5388, 'Xã Tây Hồ', '15523', 3, 342),
(5389, 'Xã Xuân Giang', '15526', 3, 342),
(5390, 'Xã Xuân Sinh', '15532', 3, 342),
(5391, 'Xã Xuân Hưng', '15535', 3, 342),
(5392, 'Xã Thọ Diên', '15538', 3, 342),
(5393, 'Xã Thọ Lâm', '15541', 3, 342),
(5394, 'Xã Thọ Xương', '15544', 3, 342),
(5395, 'Xã Xuân Bái', '15547', 3, 342),
(5396, 'Xã Xuân Phú', '15550', 3, 342),
(5397, 'Thị trấn Sao Vàng', '15553', 3, 342),
(5398, 'Thị trấn Lam Sơn', '15556', 3, 342),
(5399, 'Xã Xuân Thiên', '15559', 3, 342),
(5400, 'Xã Thuận Minh', '15565', 3, 342),
(5401, 'Xã Thọ Lập', '15568', 3, 342),
(5402, 'Xã Quảng Phú', '15571', 3, 342),
(5403, 'Xã Xuân Tín', '15574', 3, 342),
(5404, 'Xã Phú Xuân', '15577', 3, 342),
(5405, 'Xã Xuân Lai', '15583', 3, 342),
(5406, 'Xã Xuân Lập', '15586', 3, 342),
(5407, 'Xã Xuân Minh', '15592', 3, 342),
(5408, 'Xã Trường Xuân', '15598', 3, 342);

-- Tỉnh Thanh Hóa > Huyện Thường Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5409, 'Xã Bát Mọt', '15607', 3, 343),
(5410, 'Xã Yên Nhân', '15610', 3, 343),
(5411, 'Xã Xuân Lẹ', '15619', 3, 343),
(5412, 'Xã Vạn Xuân', '15622', 3, 343),
(5413, 'Xã Lương Sơn', '15628', 3, 343),
(5414, 'Xã Xuân Cao', '15631', 3, 343),
(5415, 'Xã Luận Thành', '15634', 3, 343),
(5416, 'Xã Luận Khê', '15637', 3, 343),
(5417, 'Xã Xuân Thắng', '15640', 3, 343),
(5418, 'Xã Xuân Lộc', '15643', 3, 343),
(5419, 'Thị trấn Thường Xuân', '15646', 3, 343),
(5420, 'Xã Xuân Dương', '15649', 3, 343),
(5421, 'Xã Thọ Thanh', '15652', 3, 343),
(5422, 'Xã Ngọc Phụng', '15655', 3, 343),
(5423, 'Xã Xuân Chinh', '15658', 3, 343),
(5424, 'Xã Tân Thành', '15661', 3, 343);

-- Tỉnh Thanh Hóa > Huyện Triệu Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5425, 'Thị trấn Triệu Sơn', '15664', 3, 344),
(5426, 'Xã Thọ Sơn', '15667', 3, 344),
(5427, 'Xã Thọ Bình', '15670', 3, 344),
(5428, 'Xã Thọ Tiến', '15673', 3, 344),
(5429, 'Xã Hợp Lý', '15676', 3, 344),
(5430, 'Xã Hợp Tiến', '15679', 3, 344),
(5431, 'Xã Hợp Thành', '15682', 3, 344),
(5432, 'Xã Triệu Thành', '15685', 3, 344),
(5433, 'Xã Hợp Thắng', '15688', 3, 344),
(5434, 'Xã Minh Sơn', '15691', 3, 344),
(5435, 'Xã Dân Lực', '15700', 3, 344),
(5436, 'Xã Dân Lý', '15703', 3, 344),
(5437, 'Xã Dân Quyền', '15706', 3, 344),
(5438, 'Xã An Nông', '15709', 3, 344),
(5439, 'Xã Văn Sơn', '15712', 3, 344),
(5440, 'Xã Thái Hòa', '15715', 3, 344),
(5441, 'Thị trấn Nưa', '15718', 3, 344),
(5442, 'Xã Đồng Lợi', '15721', 3, 344),
(5443, 'Xã Đồng Tiến', '15724', 3, 344),
(5444, 'Xã Đồng Thắng', '15727', 3, 344),
(5445, 'Xã Tiến Nông', '15730', 3, 344),
(5446, 'Xã Khuyến Nông', '15733', 3, 344),
(5447, 'Xã Xuân Lộc', '15736', 3, 344),
(5448, 'Xã Thọ Dân', '15742', 3, 344),
(5449, 'Xã Xuân Thọ', '15745', 3, 344),
(5450, 'Xã Thọ Tân', '15748', 3, 344),
(5451, 'Xã Thọ Ngọc', '15751', 3, 344),
(5452, 'Xã Thọ Cường', '15754', 3, 344),
(5453, 'Xã Thọ Phú', '15760', 3, 344),
(5454, 'Xã Thọ Thế', '15763', 3, 344),
(5455, 'Xã Nông Trường', '15766', 3, 344),
(5456, 'Xã Bình Sơn', '15769', 3, 344);

-- Tỉnh Thanh Hóa > Huyện Thiệu Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5457, 'Thị trấn Thiệu Hóa', '15772', 3, 345),
(5458, 'Xã Thiệu Ngọc', '15775', 3, 345),
(5459, 'Xã Thiệu Vũ', '15778', 3, 345),
(5460, 'Xã Thiệu Phúc', '15781', 3, 345),
(5461, 'Xã Thiệu Tiến', '15784', 3, 345),
(5462, 'Xã Thiệu Công', '15787', 3, 345),
(5463, 'Xã Thiệu Long', '15793', 3, 345),
(5464, 'Xã Thiệu Giang', '15796', 3, 345),
(5465, 'Xã Thiệu Duy', '15799', 3, 345),
(5466, 'Xã Thiệu Nguyên', '15802', 3, 345),
(5467, 'Xã Thiệu Hợp', '15805', 3, 345),
(5468, 'Xã Thiệu Thịnh', '15808', 3, 345),
(5469, 'Xã Thiệu Quang', '15811', 3, 345),
(5470, 'Xã Thiệu Thành', '15814', 3, 345),
(5471, 'Xã Thiệu Toán', '15817', 3, 345),
(5472, 'Xã Thiệu Chính', '15820', 3, 345),
(5473, 'Xã Thiệu Hòa', '15823', 3, 345),
(5474, 'Thị trấn Hậu Hiền', '15829', 3, 345),
(5475, 'Xã Thiệu Viên', '15832', 3, 345),
(5476, 'Xã Thiệu Lý', '15835', 3, 345),
(5477, 'Xã Thiệu Vận', '15838', 3, 345),
(5478, 'Xã Thiệu Trung', '15841', 3, 345),
(5479, 'Xã Tân Châu', '15847', 3, 345),
(5480, 'Xã Thiệu Giao', '15853', 3, 345);

-- Tỉnh Thanh Hóa > Huyện Hoằng Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5481, 'Thị trấn Bút Sơn', '15865', 3, 346),
(5482, 'Xã Hoằng Xuân', '15877', 3, 346),
(5483, 'Xã Hoằng Giang', '15880', 3, 346),
(5484, 'Xã Hoằng Phú', '15883', 3, 346),
(5485, 'Xã Hoằng Quỳ', '15886', 3, 346),
(5486, 'Xã Hoằng Kim', '15889', 3, 346),
(5487, 'Xã Hoằng Trung', '15892', 3, 346),
(5488, 'Xã Hoằng Trinh', '15895', 3, 346),
(5489, 'Xã Hoằng Sơn', '15901', 3, 346),
(5490, 'Xã Hoằng Cát', '15907', 3, 346),
(5491, 'Xã Hoằng Xuyên', '15910', 3, 346),
(5492, 'Xã Hoằng Quý', '15916', 3, 346),
(5493, 'Xã Hoằng Hợp', '15919', 3, 346),
(5494, 'Xã Hoằng Đức', '15928', 3, 346),
(5495, 'Xã Hoằng Hà', '15937', 3, 346),
(5496, 'Xã Hoằng Đạt', '15940', 3, 346),
(5497, 'Xã Hoằng Đạo', '15946', 3, 346),
(5498, 'Xã Hoằng Thắng', '15949', 3, 346),
(5499, 'Xã Hoằng Đồng', '15952', 3, 346),
(5500, 'Xã Hoằng Thái', '15955', 3, 346),
(5501, 'Xã Hoằng Thịnh', '15958', 3, 346),
(5502, 'Xã Hoằng Thành', '15961', 3, 346),
(5503, 'Xã Hoằng Lộc', '15964', 3, 346),
(5504, 'Xã Hoằng Trạch', '15967', 3, 346),
(5505, 'Xã Hoằng Phong', '15973', 3, 346),
(5506, 'Xã Hoằng Lưu', '15976', 3, 346),
(5507, 'Xã Hoằng Châu', '15979', 3, 346),
(5508, 'Xã Hoằng Tân', '15982', 3, 346),
(5509, 'Xã Hoằng Yến', '15985', 3, 346),
(5510, 'Xã Hoằng Tiến', '15988', 3, 346),
(5511, 'Xã Hoằng Hải', '15991', 3, 346),
(5512, 'Xã Hoằng Ngọc', '15994', 3, 346),
(5513, 'Xã Hoằng Đông', '15997', 3, 346),
(5514, 'Xã Hoằng Thanh', '16000', 3, 346),
(5515, 'Xã Hoằng Phụ', '16003', 3, 346),
(5516, 'Xã Hoằng Trường', '16006', 3, 346);

-- Tỉnh Thanh Hóa > Huyện Hậu Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5517, 'Thị trấn Hậu Lộc', '16012', 3, 347),
(5518, 'Xã Đồng Lộc', '16015', 3, 347),
(5519, 'Xã Đại Lộc', '16018', 3, 347),
(5520, 'Xã Triệu Lộc', '16021', 3, 347),
(5521, 'Xã Tiến Lộc', '16027', 3, 347),
(5522, 'Xã Lộc Sơn', '16030', 3, 347),
(5523, 'Xã Cầu Lộc', '16033', 3, 347),
(5524, 'Xã Thành Lộc', '16036', 3, 347),
(5525, 'Xã Tuy Lộc', '16042', 3, 347),
(5526, 'Xã Mỹ Lộc', '16045', 3, 347),
(5527, 'Xã Thuần Lộc', '16048', 3, 347),
(5528, 'Xã Xuân Lộc', '16057', 3, 347),
(5529, 'Xã Hoa Lộc', '16063', 3, 347),
(5530, 'Xã Liên Lộc', '16066', 3, 347),
(5531, 'Xã Quang Lộc', '16069', 3, 347),
(5532, 'Xã Phú Lộc', '16072', 3, 347),
(5533, 'Xã Hòa Lộc', '16075', 3, 347),
(5534, 'Xã Minh Lộc', '16078', 3, 347),
(5535, 'Xã Hưng Lộc', '16081', 3, 347),
(5536, 'Xã Hải Lộc', '16084', 3, 347),
(5537, 'Xã Đa Lộc', '16087', 3, 347),
(5538, 'Xã Ngư Lộc', '16090', 3, 347);

-- Tỉnh Thanh Hóa > Huyện Nga Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5539, 'Thị trấn Nga Sơn', '16093', 3, 348),
(5540, 'Xã Ba Đình', '16096', 3, 348),
(5541, 'Xã Nga Vịnh', '16099', 3, 348),
(5542, 'Xã Nga Văn', '16102', 3, 348),
(5543, 'Xã Nga Thiện', '16105', 3, 348),
(5544, 'Xã Nga Tiến', '16108', 3, 348),
(5545, 'Xã Nga Phượng', '16114', 3, 348),
(5546, 'Xã Nga Hiệp', '16120', 3, 348),
(5547, 'Xã Nga Thanh', '16123', 3, 348),
(5548, 'Xã Nga Yên', '16132', 3, 348),
(5549, 'Xã Nga Giáp', '16135', 3, 348),
(5550, 'Xã Nga Hải', '16138', 3, 348),
(5551, 'Xã Nga Thành', '16141', 3, 348),
(5552, 'Xã Nga An', '16144', 3, 348),
(5553, 'Xã Nga Phú', '16147', 3, 348),
(5554, 'Xã Nga Điền', '16150', 3, 348),
(5555, 'Xã Nga Tân', '16153', 3, 348),
(5556, 'Xã Nga Thủy', '16156', 3, 348),
(5557, 'Xã Nga Liên', '16159', 3, 348),
(5558, 'Xã Nga Thái', '16162', 3, 348),
(5559, 'Xã Nga Thạch', '16165', 3, 348),
(5560, 'Xã Nga Thắng', '16168', 3, 348),
(5561, 'Xã Nga Trường', '16171', 3, 348);

-- Tỉnh Thanh Hóa > Huyện Như Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5562, 'Thị trấn Yên Cát', '16174', 3, 349),
(5563, 'Xã Bãi Trành', '16177', 3, 349),
(5564, 'Xã Xuân Hòa', '16180', 3, 349),
(5565, 'Xã Xuân Bình', '16183', 3, 349),
(5566, 'Xã Hóa Quỳ', '16186', 3, 349),
(5567, 'Xã Cát Vân', '16195', 3, 349),
(5568, 'Xã Cát Tân', '16198', 3, 349),
(5569, 'Xã Tân Bình', '16201', 3, 349),
(5570, 'Xã Bình Lương', '16204', 3, 349),
(5571, 'Xã Thanh Quân', '16207', 3, 349),
(5572, 'Xã Thanh Xuân', '16210', 3, 349),
(5573, 'Xã Thanh Hòa', '16213', 3, 349),
(5574, 'Xã Thanh Phong', '16216', 3, 349),
(5575, 'Xã Thanh Lâm', '16219', 3, 349),
(5576, 'Xã Thanh Sơn', '16222', 3, 349),
(5577, 'Xã Thượng Ninh', '16225', 3, 349);

-- Tỉnh Thanh Hóa > Huyện Như Thanh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5578, 'Thị trấn Bến Sung', '16228', 3, 350),
(5579, 'Xã Cán Khê', '16231', 3, 350),
(5580, 'Xã Xuân Du', '16234', 3, 350),
(5581, 'Xã Phượng Nghi', '16240', 3, 350),
(5582, 'Xã Mậu Lâm', '16243', 3, 350),
(5583, 'Xã Xuân Khang', '16246', 3, 350),
(5584, 'Xã Phú Nhuận', '16249', 3, 350),
(5585, 'Xã Hải Long', '16252', 3, 350),
(5586, 'Xã Xuân Thái', '16258', 3, 350),
(5587, 'Xã Xuân Phúc', '16261', 3, 350),
(5588, 'Xã Yên Thọ', '16264', 3, 350),
(5589, 'Xã Yên Lạc', '16267', 3, 350),
(5590, 'Xã Thanh Tân', '16273', 3, 350),
(5591, 'Xã Thanh Kỳ', '16276', 3, 350);

-- Tỉnh Thanh Hóa > Huyện Nông Cống
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5592, 'Thị trấn Nông Cống', '16279', 3, 351),
(5593, 'Xã Tân Phúc', '16282', 3, 351),
(5594, 'Xã Tân Thọ', '16285', 3, 351),
(5595, 'Xã Hoàng Sơn', '16288', 3, 351),
(5596, 'Xã Tân Khang', '16291', 3, 351),
(5597, 'Xã Hoàng Giang', '16294', 3, 351),
(5598, 'Xã Trung Chính', '16297', 3, 351),
(5599, 'Xã Trung Thành', '16303', 3, 351),
(5600, 'Xã Tế Thắng', '16309', 3, 351),
(5601, 'Xã Tế Lợi', '16315', 3, 351),
(5602, 'Xã Tế Nông', '16318', 3, 351),
(5603, 'Xã Minh Nghĩa', '16321', 3, 351),
(5604, 'Xã Minh Khôi', '16324', 3, 351),
(5605, 'Xã Vạn Hòa', '16327', 3, 351),
(5606, 'Xã Trường Trung', '16330', 3, 351),
(5607, 'Xã Vạn Thắng', '16333', 3, 351),
(5608, 'Xã Trường Giang', '16336', 3, 351),
(5609, 'Xã Vạn Thiện', '16339', 3, 351),
(5610, 'Xã Thăng Long', '16342', 3, 351),
(5611, 'Xã Trường Minh', '16345', 3, 351),
(5612, 'Xã Trường Sơn', '16348', 3, 351),
(5613, 'Xã Thăng Bình', '16351', 3, 351),
(5614, 'Xã Công Liêm', '16354', 3, 351),
(5615, 'Xã Tượng Văn', '16357', 3, 351),
(5616, 'Xã Thăng Thọ', '16360', 3, 351),
(5617, 'Xã Tượng Lĩnh', '16363', 3, 351),
(5618, 'Xã Tượng Sơn', '16366', 3, 351),
(5619, 'Xã Công Chính', '16369', 3, 351),
(5620, 'Xã Yên Mỹ', '16375', 3, 351);

-- Tỉnh Thanh Hóa > Huyện Quảng Xương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5621, 'Thị trấn Tân Phong', '16438', 3, 352),
(5622, 'Xã Quảng Trạch', '16447', 3, 352),
(5623, 'Xã Quảng Đức', '16453', 3, 352),
(5624, 'Xã Quảng Định', '16456', 3, 352),
(5625, 'Xã Quảng Nhân', '16462', 3, 352),
(5626, 'Xã Quảng Ninh', '16465', 3, 352),
(5627, 'Xã Quảng Bình', '16468', 3, 352),
(5628, 'Xã Quảng Hợp', '16471', 3, 352),
(5629, 'Xã Quảng Văn', '16474', 3, 352),
(5630, 'Xã Quảng Long', '16477', 3, 352),
(5631, 'Xã Quảng Yên', '16480', 3, 352),
(5632, 'Xã Quảng Hòa', '16483', 3, 352),
(5633, 'Xã Quảng Khê', '16489', 3, 352),
(5634, 'Xã Quảng Trung', '16492', 3, 352),
(5635, 'Xã Quảng Chính', '16495', 3, 352),
(5636, 'Xã Quảng Ngọc', '16498', 3, 352),
(5637, 'Xã Quảng Trường', '16501', 3, 352),
(5638, 'Xã Quảng Phúc', '16510', 3, 352),
(5639, 'Xã Quảng Giao', '16519', 3, 352),
(5640, 'Xã Quảng Hải', '16540', 3, 352),
(5641, 'Xã Quảng Lưu', '16543', 3, 352),
(5642, 'Xã Quảng Lộc', '16546', 3, 352),
(5643, 'Xã Tiên Trang', '16549', 3, 352),
(5644, 'Xã Quảng Nham', '16552', 3, 352),
(5645, 'Xã Quảng Thạch', '16555', 3, 352),
(5646, 'Xã Quảng Thái', '16558', 3, 352);

-- Tỉnh Thanh Hóa > Thị xã Nghi Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5647, 'Phường Hải Hòa', '16561', 3, 353),
(5648, 'Phường Hải Châu', '16564', 3, 353),
(5649, 'Xã Thanh Thủy', '16567', 3, 353),
(5650, 'Xã Thanh Sơn', '16570', 3, 353),
(5651, 'Phường Hải Ninh', '16576', 3, 353),
(5652, 'Xã Anh Sơn', '16579', 3, 353),
(5653, 'Xã Ngọc Lĩnh', '16582', 3, 353),
(5654, 'Phường Hải An', '16585', 3, 353),
(5655, 'Xã Các Sơn', '16591', 3, 353),
(5656, 'Phường Tân Dân', '16594', 3, 353),
(5657, 'Phường Hải Lĩnh', '16597', 3, 353),
(5658, 'Xã Định Hải', '16600', 3, 353),
(5659, 'Xã Phú Sơn', '16603', 3, 353),
(5660, 'Phường Ninh Hải', '16606', 3, 353),
(5661, 'Phường Nguyên Bình', '16609', 3, 353),
(5662, 'Xã Hải Nhân', '16612', 3, 353),
(5663, 'Phường Bình Minh', '16618', 3, 353),
(5664, 'Phường Hải Thanh', '16621', 3, 353),
(5665, 'Xã Phú Lâm', '16624', 3, 353),
(5666, 'Phường Xuân Lâm', '16627', 3, 353),
(5667, 'Phường Trúc Lâm', '16630', 3, 353),
(5668, 'Phường Hải Bình', '16633', 3, 353),
(5669, 'Xã Tân Trường', '16636', 3, 353),
(5670, 'Xã Tùng Lâm', '16639', 3, 353),
(5671, 'Phường Tĩnh Hải', '16642', 3, 353),
(5672, 'Phường Mai Lâm', '16645', 3, 353),
(5673, 'Xã Trường Lâm', '16648', 3, 353),
(5674, 'Phường Hải Thượng', '16654', 3, 353),
(5675, 'Xã Nghi Sơn', '16657', 3, 353),
(5676, 'Xã Hải Hà', '16660', 3, 353);

-- Tỉnh Nghệ An > Thành phố Vinh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5677, 'Phường Đông Vĩnh', '16663', 3, 354),
(5678, 'Phường Hà Huy Tập', '16666', 3, 354),
(5679, 'Phường Lê Lợi', '16669', 3, 354),
(5680, 'Phường Quán Bàu', '16670', 3, 354),
(5681, 'Phường Hưng Bình', '16672', 3, 354),
(5682, 'Phường Hưng Phúc', '16673', 3, 354),
(5683, 'Phường Hưng Dũng', '16675', 3, 354),
(5684, 'Phường Cửa Nam', '16678', 3, 354),
(5685, 'Phường Quang Trung', '16681', 3, 354),
(5686, 'Phường Trường Thi', '16690', 3, 354),
(5687, 'Phường Bến Thủy', '16693', 3, 354),
(5688, 'Phường Trung Đô', '16699', 3, 354),
(5689, 'Phường Nghi Phú', '16702', 3, 354),
(5690, 'Phường Hưng Đông', '16705', 3, 354),
(5691, 'Phường Hưng Lộc', '16708', 3, 354),
(5692, 'Xã Hưng Hòa', '16711', 3, 354),
(5693, 'Phường Vinh Tân', '16714', 3, 354),
(5694, 'Phường Nghi Thuỷ', '16717', 3, 354),
(5695, 'Phường Nghi Tân', '16720', 3, 354),
(5696, 'Phường Thu Thuỷ', '16723', 3, 354),
(5697, 'Phường Nghi Hòa', '16726', 3, 354),
(5698, 'Phường Nghi Hải', '16729', 3, 354),
(5699, 'Phường Nghi Hương', '16732', 3, 354),
(5700, 'Phường Nghi Thu', '16735', 3, 354),
(5701, 'Xã Nghi Phong', '17902', 3, 354),
(5702, 'Xã Nghi Xuân', '17905', 3, 354),
(5703, 'Xã Nghi Liên', '17908', 3, 354),
(5704, 'Xã Nghi Ân', '17914', 3, 354),
(5705, 'Xã Phúc Thọ', '17917', 3, 354),
(5706, 'Xã Nghi Kim', '17920', 3, 354),
(5707, 'Phường Nghi Đức', '17923', 3, 354),
(5708, 'Xã Nghi Thái', '17926', 3, 354),
(5709, 'Xã Hưng Chính', '18013', 3, 354);

-- Tỉnh Nghệ An > Thị xã Thái Hoà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5710, 'Phường Hoà Hiếu', '16939', 3, 355),
(5711, 'Phường Quang Phong', '16993', 3, 355),
(5712, 'Phường Quang Tiến', '16994', 3, 355),
(5713, 'Phường Long Sơn', '17003', 3, 355),
(5714, 'Xã Nghĩa Tiến', '17005', 3, 355),
(5715, 'Xã Nghĩa Mỹ', '17008', 3, 355),
(5716, 'Xã Tây Hiếu', '17011', 3, 355),
(5717, 'Xã Nghĩa Thuận', '17014', 3, 355),
(5718, 'Xã Đông Hiếu', '17017', 3, 355);

-- Tỉnh Nghệ An > Huyện Quế Phong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5719, 'Thị trấn Kim Sơn', '16738', 3, 356),
(5720, 'Xã Thông Thụ', '16741', 3, 356),
(5721, 'Xã Đồng Văn', '16744', 3, 356),
(5722, 'Xã Hạnh Dịch', '16747', 3, 356),
(5723, 'Xã Tiền Phong', '16750', 3, 356),
(5724, 'Xã Nậm Giải', '16753', 3, 356),
(5725, 'Xã Tri Lễ', '16756', 3, 356),
(5726, 'Xã Châu Kim', '16759', 3, 356),
(5727, 'Xã Mường Nọc', '16763', 3, 356),
(5728, 'Xã Châu Thôn', '16765', 3, 356),
(5729, 'Xã Nậm Nhoóng', '16768', 3, 356),
(5730, 'Xã Quang Phong', '16771', 3, 356),
(5731, 'Xã Căm Muộn', '16774', 3, 356);

-- Tỉnh Nghệ An > Huyện Quỳ Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5732, 'Thị trấn Tân Lạc', '16777', 3, 357),
(5733, 'Xã Châu Bính', '16780', 3, 357),
(5734, 'Xã Châu Thuận', '16783', 3, 357),
(5735, 'Xã Châu Hội', '16786', 3, 357),
(5736, 'Xã Châu Nga', '16789', 3, 357),
(5737, 'Xã Châu Tiến', '16792', 3, 357),
(5738, 'Xã Châu Hạnh', '16795', 3, 357),
(5739, 'Xã Châu Thắng', '16798', 3, 357),
(5740, 'Xã Châu Phong', '16801', 3, 357),
(5741, 'Xã Châu Bình', '16804', 3, 357),
(5742, 'Xã Châu Hoàn', '16807', 3, 357),
(5743, 'Xã Diên Lãm', '16810', 3, 357);

-- Tỉnh Nghệ An > Huyện Kỳ Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5744, 'Thị trấn Mường Xén', '16813', 3, 358),
(5745, 'Xã Mỹ Lý', '16816', 3, 358),
(5746, 'Xã Bắc Lý', '16819', 3, 358),
(5747, 'Xã Keng Đu', '16822', 3, 358),
(5748, 'Xã Đoọc Mạy', '16825', 3, 358),
(5749, 'Xã Huồi Tụ', '16828', 3, 358),
(5750, 'Xã Mường Lống', '16831', 3, 358),
(5751, 'Xã Na Loi', '16834', 3, 358),
(5752, 'Xã Nậm Cắn', '16837', 3, 358),
(5753, 'Xã Bảo Nam', '16840', 3, 358),
(5754, 'Xã Phà Đánh', '16843', 3, 358),
(5755, 'Xã Bảo Thắng', '16846', 3, 358),
(5756, 'Xã Hữu Lập', '16849', 3, 358),
(5757, 'Xã Tà Cạ', '16852', 3, 358),
(5758, 'Xã Chiêu Lưu', '16855', 3, 358),
(5759, 'Xã Mường Típ', '16858', 3, 358),
(5760, 'Xã Hữu Kiệm', '16861', 3, 358),
(5761, 'Xã Tây Sơn', '16864', 3, 358),
(5762, 'Xã Mường Ải', '16867', 3, 358),
(5763, 'Xã Na Ngoi', '16870', 3, 358),
(5764, 'Xã Nậm Càn', '16873', 3, 358);

-- Tỉnh Nghệ An > Huyện Tương Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5765, 'Thị trấn Thạch Giám', '16876', 3, 359),
(5766, 'Xã Mai Sơn', '16879', 3, 359),
(5767, 'Xã Nhôn Mai', '16882', 3, 359),
(5768, 'Xã Hữu Khuông', '16885', 3, 359),
(5769, 'Xã Yên Tĩnh', '16900', 3, 359),
(5770, 'Xã Nga My', '16903', 3, 359),
(5771, 'Xã Xiêng My', '16904', 3, 359),
(5772, 'Xã Lưỡng Minh', '16906', 3, 359),
(5773, 'Xã Yên Hòa', '16909', 3, 359),
(5774, 'Xã Yên Na', '16912', 3, 359),
(5775, 'Xã Lưu Kiền', '16915', 3, 359),
(5776, 'Xã Xá Lượng', '16921', 3, 359),
(5777, 'Xã Tam Thái', '16924', 3, 359),
(5778, 'Xã Tam Đình', '16927', 3, 359),
(5779, 'Xã Yên Thắng', '16930', 3, 359),
(5780, 'Xã Tam Quang', '16933', 3, 359),
(5781, 'Xã Tam Hợp', '16936', 3, 359);

-- Tỉnh Nghệ An > Huyện Nghĩa Đàn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5782, 'Thị trấn Nghĩa Đàn', '16941', 3, 360),
(5783, 'Xã Nghĩa Mai', '16942', 3, 360),
(5784, 'Xã Nghĩa Yên', '16945', 3, 360),
(5785, 'Xã Nghĩa Lạc', '16948', 3, 360),
(5786, 'Xã Nghĩa Lâm', '16951', 3, 360),
(5787, 'Xã Nghĩa Sơn', '16954', 3, 360),
(5788, 'Xã Nghĩa Lợi', '16957', 3, 360),
(5789, 'Xã Nghĩa Bình', '16960', 3, 360),
(5790, 'Xã Nghĩa Minh', '16966', 3, 360),
(5791, 'Xã Nghĩa Thọ', '16969', 3, 360),
(5792, 'Xã Nghĩa Hưng', '16972', 3, 360),
(5793, 'Xã Nghĩa Hồng', '16975', 3, 360),
(5794, 'Xã Nghĩa Trung', '16981', 3, 360),
(5795, 'Xã Nghĩa Hội', '16984', 3, 360),
(5796, 'Xã Nghĩa Thành', '16987', 3, 360),
(5797, 'Xã Nghĩa Đức', '17020', 3, 360),
(5798, 'Xã Nghĩa An', '17023', 3, 360),
(5799, 'Xã Nghĩa Long', '17026', 3, 360),
(5800, 'Xã Nghĩa Lộc', '17029', 3, 360),
(5801, 'Xã Nghĩa Khánh', '17032', 3, 360);

-- Tỉnh Nghệ An > Huyện Quỳ Hợp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5802, 'Thị trấn Quỳ Hợp', '17035', 3, 361),
(5803, 'Xã Yên Hợp', '17038', 3, 361),
(5804, 'Xã Châu Tiến', '17041', 3, 361),
(5805, 'Xã Châu Hồng', '17044', 3, 361),
(5806, 'Xã Đồng Hợp', '17047', 3, 361),
(5807, 'Xã Châu Thành', '17050', 3, 361),
(5808, 'Xã Liên Hợp', '17053', 3, 361),
(5809, 'Xã Châu Lộc', '17056', 3, 361),
(5810, 'Xã Tam Hợp', '17059', 3, 361),
(5811, 'Xã Châu Cường', '17062', 3, 361),
(5812, 'Xã Châu Quang', '17065', 3, 361),
(5813, 'Xã Thọ Hợp', '17068', 3, 361),
(5814, 'Xã Minh Hợp', '17071', 3, 361),
(5815, 'Xã Nghĩa Xuân', '17074', 3, 361),
(5816, 'Xã Châu Thái', '17077', 3, 361),
(5817, 'Xã Châu Đình', '17080', 3, 361),
(5818, 'Xã Văn Lợi', '17083', 3, 361),
(5819, 'Xã Nam Sơn', '17086', 3, 361),
(5820, 'Xã Châu Lý', '17089', 3, 361),
(5821, 'Xã Hạ Sơn', '17092', 3, 361),
(5822, 'Xã Bắc Sơn', '17095', 3, 361);

-- Tỉnh Nghệ An > Huyện Quỳnh Lưu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5823, 'Xã Quỳnh Thắng', '17101', 3, 362),
(5824, 'Xã Quỳnh Tân', '17119', 3, 362),
(5825, 'Xã Quỳnh Châu', '17122', 3, 362),
(5826, 'Xã Tân Sơn', '17140', 3, 362),
(5827, 'Xã Quỳnh Văn', '17143', 3, 362),
(5828, 'Xã Ngọc Sơn', '17146', 3, 362),
(5829, 'Xã Quỳnh Tam', '17149', 3, 362),
(5830, 'Xã Quỳnh Sơn', '17152', 3, 362),
(5831, 'Xã Quỳnh Thạch', '17155', 3, 362),
(5832, 'Xã Quỳnh Bảng', '17158', 3, 362),
(5833, 'Xã Quỳnh Thanh', '17164', 3, 362),
(5834, 'Xã Quỳnh Hậu', '17167', 3, 362),
(5835, 'Xã Quỳnh Lâm', '17170', 3, 362),
(5836, 'Xã Quỳnh Đôi', '17173', 3, 362),
(5837, 'Xã Minh Lương', '17176', 3, 362),
(5838, 'Thị trấn Cầu Giát', '17179', 3, 362),
(5839, 'Xã Quỳnh Yên', '17182', 3, 362),
(5840, 'Xã Bình Sơn', '17185', 3, 362),
(5841, 'Xã Quỳnh Diễn', '17191', 3, 362),
(5842, 'Xã Quỳnh Giang', '17197', 3, 362),
(5843, 'Xã An Hòa', '17206', 3, 362),
(5844, 'Xã Phú Nghĩa', '17209', 3, 362),
(5845, 'Xã Văn Hải', '17212', 3, 362),
(5846, 'Xã Thuận Long', '17218', 3, 362),
(5847, 'Xã Tân Thắng', '17224', 3, 362);

-- Tỉnh Nghệ An > Huyện Con Cuông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5848, 'Xã Bình Chuẩn', '17230', 3, 363),
(5849, 'Xã Lạng Khê', '17233', 3, 363),
(5850, 'Xã Cam Lâm', '17236', 3, 363),
(5851, 'Xã Thạch Ngàn', '17239', 3, 363),
(5852, 'Xã Đôn Phục', '17242', 3, 363),
(5853, 'Xã Mậu Đức', '17245', 3, 363),
(5854, 'Xã Châu Khê', '17248', 3, 363),
(5855, 'Xã Chi Khê', '17251', 3, 363),
(5856, 'Thị trấn Trà Lân', '17254', 3, 363),
(5857, 'Xã Yên Khê', '17257', 3, 363),
(5858, 'Xã Lục Dạ', '17260', 3, 363),
(5859, 'Xã Môn Sơn', '17263', 3, 363);

-- Tỉnh Nghệ An > Huyện Tân Kỳ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5860, 'Thị trấn Tân Kỳ', '17266', 3, 364),
(5861, 'Xã Tân Hợp', '17269', 3, 364),
(5862, 'Xã Tân Phú', '17272', 3, 364),
(5863, 'Xã Tân Xuân', '17275', 3, 364),
(5864, 'Xã Giai Xuân', '17278', 3, 364),
(5865, 'Xã Bình Hợp', '17281', 3, 364),
(5866, 'Xã Nghĩa Đồng', '17284', 3, 364),
(5867, 'Xã Đồng Văn', '17287', 3, 364),
(5868, 'Xã Nghĩa Thái', '17290', 3, 364),
(5869, 'Xã Hoàn Long', '17296', 3, 364),
(5870, 'Xã Nghĩa Phúc', '17299', 3, 364),
(5871, 'Xã Tiên Kỳ', '17302', 3, 364),
(5872, 'Xã Tân An', '17305', 3, 364),
(5873, 'Xã Nghĩa Dũng', '17308', 3, 364),
(5874, 'Xã Kỳ Sơn', '17314', 3, 364),
(5875, 'Xã Hương Sơn', '17317', 3, 364),
(5876, 'Xã Kỳ Tân', '17320', 3, 364),
(5877, 'Xã Phú Sơn', '17323', 3, 364),
(5878, 'Xã Tân Hương', '17325', 3, 364),
(5879, 'Xã Nghĩa Hành', '17326', 3, 364);

-- Tỉnh Nghệ An > Huyện Anh Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5880, 'Thị trấn Kim Nhan', '17329', 3, 365),
(5881, 'Xã Thọ Sơn', '17332', 3, 365),
(5882, 'Xã Thành Sơn', '17335', 3, 365),
(5883, 'Xã Bình Sơn', '17338', 3, 365),
(5884, 'Xã Tam Đỉnh', '17344', 3, 365),
(5885, 'Xã Hùng Sơn', '17347', 3, 365),
(5886, 'Xã Cẩm Sơn', '17350', 3, 365),
(5887, 'Xã Đức Sơn', '17353', 3, 365),
(5888, 'Xã Tường Sơn', '17356', 3, 365),
(5889, 'Xã Hoa Sơn', '17357', 3, 365),
(5890, 'Xã Tào Sơn', '17359', 3, 365),
(5891, 'Xã Vĩnh Sơn', '17362', 3, 365),
(5892, 'Xã Lạng Sơn', '17365', 3, 365),
(5893, 'Xã Hội Sơn', '17368', 3, 365),
(5894, 'Xã Phúc Sơn', '17374', 3, 365),
(5895, 'Xã Long Sơn', '17377', 3, 365),
(5896, 'Xã Khai Sơn', '17380', 3, 365),
(5897, 'Xã Lĩnh Sơn', '17383', 3, 365),
(5898, 'Xã Cao Sơn', '17386', 3, 365);

-- Tỉnh Nghệ An > Huyện Diễn Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5899, 'Xã Diễn Lâm', '17392', 3, 366),
(5900, 'Xã Diễn Đoài', '17395', 3, 366),
(5901, 'Xã Diễn Trường', '17398', 3, 366),
(5902, 'Xã Diễn Yên', '17401', 3, 366),
(5903, 'Xã Diễn Hoàng', '17404', 3, 366),
(5904, 'Xã Diễn Mỹ', '17410', 3, 366),
(5905, 'Xã Diễn Hồng', '17413', 3, 366),
(5906, 'Xã Diễn Phong', '17416', 3, 366),
(5907, 'Xã Hùng Hải', '17419', 3, 366),
(5908, 'Xã Diễn Liên', '17425', 3, 366),
(5909, 'Xã Diễn Vạn', '17428', 3, 366),
(5910, 'Xã Diễn Kim', '17431', 3, 366),
(5911, 'Xã Diễn Kỷ', '17434', 3, 366),
(5912, 'Xã Xuân Tháp', '17437', 3, 366),
(5913, 'Xã Diễn Thái', '17440', 3, 366),
(5914, 'Xã Diễn Đồng', '17443', 3, 366),
(5915, 'Xã Hạnh Quảng', '17449', 3, 366),
(5916, 'Xã Ngọc Bích', '17452', 3, 366),
(5917, 'Xã Diễn Nguyên', '17458', 3, 366),
(5918, 'Xã Diễn Hoa', '17461', 3, 366),
(5919, 'Thị trấn Diễn Thành', '17464', 3, 366),
(5920, 'Xã Diễn Phúc', '17467', 3, 366),
(5921, 'Xã Diễn Cát', '17476', 3, 366),
(5922, 'Xã Diễn Thịnh', '17479', 3, 366),
(5923, 'Xã Diễn Tân', '17482', 3, 366),
(5924, 'Xã Minh Châu', '17485', 3, 366),
(5925, 'Xã Diễn Thọ', '17488', 3, 366),
(5926, 'Xã Diễn Lợi', '17491', 3, 366),
(5927, 'Xã Diễn Lộc', '17494', 3, 366),
(5928, 'Xã Diễn Trung', '17497', 3, 366),
(5929, 'Xã Diễn An', '17500', 3, 366),
(5930, 'Xã Diễn Phú', '17503', 3, 366);

-- Tỉnh Nghệ An > Huyện Yên Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5931, 'Thị trấn Hoa Thành', '17506', 3, 367),
(5932, 'Xã Mã Thành', '17509', 3, 367),
(5933, 'Xã Tiến Thành', '17510', 3, 367),
(5934, 'Xã Lăng Thành', '17512', 3, 367),
(5935, 'Xã Tân Thành', '17515', 3, 367),
(5936, 'Xã Đức Thành', '17518', 3, 367),
(5937, 'Xã Kim Thành', '17521', 3, 367),
(5938, 'Xã Hậu Thành', '17524', 3, 367),
(5939, 'Xã Đô Thành', '17527', 3, 367),
(5940, 'Xã Thọ Thành', '17530', 3, 367),
(5941, 'Xã Quang Thành', '17533', 3, 367),
(5942, 'Xã Tây Thành', '17536', 3, 367),
(5943, 'Xã Phúc Thành', '17539', 3, 367),
(5944, 'Xã Phú Thành', '17542', 3, 367),
(5945, 'Xã Đồng Thành', '17545', 3, 367),
(5946, 'Xã Tăng Thành', '17554', 3, 367),
(5947, 'Xã Văn Thành', '17557', 3, 367),
(5948, 'Xã Thịnh Thành', '17560', 3, 367),
(5949, 'Xã Xuân Thành', '17566', 3, 367),
(5950, 'Xã Bắc Thành', '17569', 3, 367),
(5951, 'Xã Đông Thành', '17572', 3, 367),
(5952, 'Xã Trung Thành', '17575', 3, 367),
(5953, 'Xã Long Thành', '17578', 3, 367),
(5954, 'Xã Minh Thành', '17581', 3, 367),
(5955, 'Xã Nam Thành', '17584', 3, 367),
(5956, 'Xã Vĩnh Thành', '17587', 3, 367),
(5957, 'Xã Viên Thành', '17596', 3, 367),
(5958, 'Xã Liên Thành', '17602', 3, 367),
(5959, 'Xã Bảo Thành', '17605', 3, 367),
(5960, 'Xã Mỹ Thành', '17608', 3, 367),
(5961, 'Xã Vân Tụ', '17611', 3, 367),
(5962, 'Xã Sơn Thành', '17614', 3, 367);

-- Tỉnh Nghệ An > Huyện Đô Lương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5963, 'Thị trấn Đô Lương', '17617', 3, 368),
(5964, 'Xã Giang Sơn Đông', '17619', 3, 368),
(5965, 'Xã Giang Sơn Tây', '17620', 3, 368),
(5966, 'Xã Bạch Ngọc', '17623', 3, 368),
(5967, 'Xã Bồi Sơn', '17626', 3, 368),
(5968, 'Xã Hồng Sơn', '17629', 3, 368),
(5969, 'Xã Bài Sơn', '17632', 3, 368),
(5970, 'Xã Bắc Sơn', '17638', 3, 368),
(5971, 'Xã Tràng Sơn', '17641', 3, 368),
(5972, 'Xã Thượng Sơn', '17644', 3, 368),
(5973, 'Xã Hòa Sơn', '17647', 3, 368),
(5974, 'Xã Đặng Sơn', '17650', 3, 368),
(5975, 'Xã Đông Sơn', '17653', 3, 368),
(5976, 'Xã Nam Sơn', '17656', 3, 368),
(5977, 'Xã Lưu Sơn', '17659', 3, 368),
(5978, 'Xã Yên Sơn', '17662', 3, 368),
(5979, 'Xã Văn Sơn', '17665', 3, 368),
(5980, 'Xã Đà Sơn', '17668', 3, 368),
(5981, 'Xã Lạc Sơn', '17671', 3, 368),
(5982, 'Xã Tân Sơn', '17674', 3, 368),
(5983, 'Xã Thái Sơn', '17677', 3, 368),
(5984, 'Xã Quang Sơn', '17680', 3, 368),
(5985, 'Xã Thịnh Sơn', '17683', 3, 368),
(5986, 'Xã Trung Sơn', '17686', 3, 368),
(5987, 'Xã Xuân Sơn', '17689', 3, 368),
(5988, 'Xã Minh Sơn', '17692', 3, 368),
(5989, 'Xã Thuận Sơn', '17695', 3, 368),
(5990, 'Xã Nhân Sơn', '17698', 3, 368),
(5991, 'Xã Hiến Sơn', '17701', 3, 368),
(5992, 'Xã Mỹ Sơn', '17704', 3, 368),
(5993, 'Xã Trù Sơn', '17707', 3, 368),
(5994, 'Xã Đại Sơn', '17710', 3, 368);

-- Tỉnh Nghệ An > Huyện Thanh Chương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(5995, 'Thị trấn Dùng', '17713', 3, 369),
(5996, 'Xã Cát Văn', '17716', 3, 369),
(5997, 'Xã Minh Sơn', '17719', 3, 369),
(5998, 'Xã Hạnh Lâm', '17722', 3, 369),
(5999, 'Xã Thanh Sơn', '17723', 3, 369),
(6000, 'Xã Phong Thịnh', '17728', 3, 369),
(6001, 'Xã Thanh Phong', '17731', 3, 369),
(6002, 'Xã Thanh Mỹ', '17734', 3, 369),
(6003, 'Xã Thanh Tiên', '17737', 3, 369),
(6004, 'Xã Thanh Liên', '17743', 3, 369),
(6005, 'Xã Đại Đồng', '17749', 3, 369),
(6006, 'Xã Thanh Ngọc', '17755', 3, 369),
(6007, 'Xã Thanh Hương', '17758', 3, 369),
(6008, 'Xã Ngọc Lâm', '17759', 3, 369),
(6009, 'Xã Đồng Văn', '17764', 3, 369),
(6010, 'Xã Ngọc Sơn', '17767', 3, 369),
(6011, 'Xã Thanh Thịnh', '17770', 3, 369),
(6012, 'Xã Thanh An', '17773', 3, 369),
(6013, 'Xã Thanh Quả', '17776', 3, 369),
(6014, 'Xã Xuân Dương', '17779', 3, 369),
(6015, 'Xã Minh Tiến', '17785', 3, 369),
(6016, 'Xã Kim Bảng', '17791', 3, 369),
(6017, 'Xã Thanh Thủy', '17797', 3, 369),
(6018, 'Xã Thanh Hà', '17806', 3, 369),
(6019, 'Xã Thanh Tùng', '17812', 3, 369),
(6020, 'Xã Thanh Lâm', '17815', 3, 369),
(6021, 'Xã Mai Giang', '17818', 3, 369),
(6022, 'Xã Thanh Xuân', '17821', 3, 369),
(6023, 'Xã Thanh Đức', '17824', 3, 369);

-- Tỉnh Nghệ An > Huyện Nghi Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6024, 'Thị trấn Quán Hành', '17827', 3, 370),
(6025, 'Xã Nghi Văn', '17830', 3, 370),
(6026, 'Xã Nghi Yên', '17833', 3, 370),
(6027, 'Xã Nghi Tiến', '17836', 3, 370),
(6028, 'Xã Nghi Hưng', '17839', 3, 370),
(6029, 'Xã Nghi Đồng', '17842', 3, 370),
(6030, 'Xã Nghi Thiết', '17845', 3, 370),
(6031, 'Xã Nghi Lâm', '17848', 3, 370),
(6032, 'Xã Nghi Quang', '17851', 3, 370),
(6033, 'Xã Nghi Kiều', '17854', 3, 370),
(6034, 'Xã Nghi Mỹ', '17857', 3, 370),
(6035, 'Xã Nghi Phương', '17860', 3, 370),
(6036, 'Xã Nghi Thuận', '17863', 3, 370),
(6037, 'Xã Nghi Long', '17866', 3, 370),
(6038, 'Xã Nghi Xá', '17869', 3, 370),
(6039, 'Xã Khánh Hợp', '17878', 3, 370),
(6040, 'Xã Nghi Công Bắc', '17884', 3, 370),
(6041, 'Xã Nghi Công Nam', '17887', 3, 370),
(6042, 'Xã Nghi Thạch', '17890', 3, 370),
(6043, 'Xã Nghi Trung', '17893', 3, 370),
(6044, 'Xã Thịnh Trường', '17896', 3, 370),
(6045, 'Xã Diên Hoa', '17899', 3, 370),
(6046, 'Xã Nghi Vạn', '17911', 3, 370);

-- Tỉnh Nghệ An > Huyện Nam Đàn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6047, 'Xã Nam Hưng', '17932', 3, 371),
(6048, 'Xã Nghĩa Thái', '17935', 3, 371),
(6049, 'Xã Nam Thanh', '17938', 3, 371),
(6050, 'Xã Nam Anh', '17941', 3, 371),
(6051, 'Xã Nam Xuân', '17944', 3, 371),
(6052, 'Thị trấn Nam Đàn', '17950', 3, 371),
(6053, 'Xã Nam Lĩnh', '17953', 3, 371),
(6054, 'Xã Nam Giang', '17956', 3, 371),
(6055, 'Xã Xuân Hòa', '17959', 3, 371),
(6056, 'Xã Hùng Tiến', '17962', 3, 371),
(6057, 'Xã Thượng Tân Lộc', '17968', 3, 371),
(6058, 'Xã Kim Liên', '17971', 3, 371),
(6059, 'Xã Xuân Hồng', '17980', 3, 371),
(6060, 'Xã Nam Cát', '17983', 3, 371),
(6061, 'Xã Khánh Sơn', '17986', 3, 371),
(6062, 'Xã Trung Phúc Cường', '17989', 3, 371),
(6063, 'Xã Nam Kim', '17998', 3, 371);

-- Tỉnh Nghệ An > Huyện Hưng Nguyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6064, 'Thị trấn Hưng Nguyên', '18001', 3, 372),
(6065, 'Xã Hưng Trung', '18004', 3, 372),
(6066, 'Xã Hưng Yên', '18007', 3, 372),
(6067, 'Xã Hưng Yên Bắc', '18008', 3, 372),
(6068, 'Xã Hưng Tây', '18010', 3, 372),
(6069, 'Xã Hưng Đạo', '18016', 3, 372),
(6070, 'Xã Thịnh Mỹ', '18022', 3, 372),
(6071, 'Xã Hưng Lĩnh', '18025', 3, 372),
(6072, 'Xã Thông Tân', '18028', 3, 372),
(6073, 'Xã Hưng Nghĩa', '18037', 3, 372),
(6074, 'Xã Phúc Lợi', '18040', 3, 372),
(6075, 'Xã Long Xá', '18043', 3, 372),
(6076, 'Xã Châu Nhân', '18052', 3, 372),
(6077, 'Xã Xuân Lam', '18055', 3, 372),
(6078, 'Xã Hưng Thành', '18064', 3, 372);

-- Tỉnh Nghệ An > Thị xã Hoàng Mai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6079, 'Xã Quỳnh Vinh', '17104', 3, 373),
(6080, 'Xã Quỳnh Lộc', '17107', 3, 373),
(6081, 'Phường Quỳnh Thiện', '17110', 3, 373),
(6082, 'Xã Quỳnh Lập', '17113', 3, 373),
(6083, 'Xã Quỳnh Trang', '17116', 3, 373),
(6084, 'Phường Mai Hùng', '17125', 3, 373),
(6085, 'Phường Quỳnh Dị', '17128', 3, 373),
(6086, 'Phường Quỳnh Xuân', '17131', 3, 373),
(6087, 'Phường Quỳnh Phương', '17134', 3, 373),
(6088, 'Xã Quỳnh Liên', '17137', 3, 373);

-- Tỉnh Hà Tĩnh > Thành phố Hà Tĩnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6089, 'Phường Nam Hà', '18073', 3, 374),
(6090, 'Phường Bắc Hà', '18077', 3, 374),
(6091, 'Phường Tân Giang', '18079', 3, 374),
(6092, 'Phường Đại Nài', '18082', 3, 374),
(6093, 'Phường Hà Huy Tập', '18085', 3, 374),
(6094, 'Phường Thạch Trung', '18088', 3, 374),
(6095, 'Phường Thạch Quý', '18091', 3, 374),
(6096, 'Phường Trần Phú', '18094', 3, 374),
(6097, 'Phường Văn Yên', '18097', 3, 374),
(6098, 'Phường Thạch Hạ', '18100', 3, 374),
(6099, 'Phường Đồng Môn', '18103', 3, 374),
(6100, 'Phường Thạch Hưng', '18109', 3, 374),
(6101, 'Xã Thạch Bình', '18112', 3, 374),
(6102, 'Xã Thạch Hải', '18571', 3, 374),
(6103, 'Xã Đỉnh Bàn', '18595', 3, 374),
(6104, 'Xã Hộ Độ', '18598', 3, 374),
(6105, 'Xã Thạch Khê', '18604', 3, 374),
(6106, 'Xã Thạch Trị', '18619', 3, 374),
(6107, 'Xã Thạch Lạc', '18622', 3, 374),
(6108, 'Xã Tượng Sơn', '18628', 3, 374),
(6109, 'Xã Thạch Văn', '18631', 3, 374),
(6110, 'Xã Thạch Thắng', '18637', 3, 374),
(6111, 'Xã Thạch Đài', '18643', 3, 374),
(6112, 'Xã Thạch Hội', '18649', 3, 374),
(6113, 'Xã Tân Lâm Hương', '18652', 3, 374),
(6114, 'Xã Cẩm Bình', '18685', 3, 374),
(6115, 'Xã Cẩm Vịnh', '18691', 3, 374);

-- Tỉnh Hà Tĩnh > Thị xã Hồng Lĩnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6116, 'Phường Bắc Hồng', '18115', 3, 375),
(6117, 'Phường Nam Hồng', '18118', 3, 375),
(6118, 'Phường Trung Lương', '18121', 3, 375),
(6119, 'Phường Đức Thuận', '18124', 3, 375),
(6120, 'Phường Đậu Liêu', '18127', 3, 375),
(6121, 'Xã Thuận Lộc', '18130', 3, 375);

-- Tỉnh Hà Tĩnh > Huyện Hương Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6122, 'Thị trấn Phố Châu', '18133', 3, 376),
(6123, 'Thị trấn Tây Sơn', '18136', 3, 376),
(6124, 'Xã Sơn Hồng', '18139', 3, 376),
(6125, 'Xã Sơn Tiến', '18142', 3, 376),
(6126, 'Xã Sơn Lâm', '18145', 3, 376),
(6127, 'Xã Sơn Lễ', '18148', 3, 376),
(6128, 'Xã Sơn Giang', '18157', 3, 376),
(6129, 'Xã Sơn Lĩnh', '18160', 3, 376),
(6130, 'Xã An Hòa Thịnh', '18163', 3, 376),
(6131, 'Xã Sơn Tây', '18172', 3, 376),
(6132, 'Xã Sơn Ninh', '18175', 3, 376),
(6133, 'Xã Châu Bình', '18178', 3, 376),
(6134, 'Xã Tân Mỹ Hà', '18181', 3, 376),
(6135, 'Xã Quang Diệm', '18184', 3, 376),
(6136, 'Xã Sơn Trung', '18187', 3, 376),
(6137, 'Xã Sơn Bằng', '18190', 3, 376),
(6138, 'Xã Sơn Kim 1', '18196', 3, 376),
(6139, 'Xã Sơn Kim 2', '18199', 3, 376),
(6140, 'Xã Mỹ Long', '18202', 3, 376),
(6141, 'Xã Kim Hoa', '18211', 3, 376),
(6142, 'Xã Sơn Phú', '18217', 3, 376),
(6143, 'Xã Hàm Trường', '18223', 3, 376);

-- Tỉnh Hà Tĩnh > Huyện Đức Thọ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6144, 'Thị trấn Đức Thọ', '18229', 3, 377),
(6145, 'Xã Quang Vĩnh', '18235', 3, 377),
(6146, 'Xã Tùng Châu', '18241', 3, 377),
(6147, 'Xã Trường Sơn', '18244', 3, 377),
(6148, 'Xã Liên Minh', '18247', 3, 377),
(6149, 'Xã Yên Hồ', '18253', 3, 377),
(6150, 'Xã Tùng Ảnh', '18259', 3, 377),
(6151, 'Xã Bùi La Nhân', '18262', 3, 377),
(6152, 'Xã Thanh Bình Thịnh', '18274', 3, 377),
(6153, 'Xã Lâm Trung Thủy', '18277', 3, 377),
(6154, 'Xã Hòa Lạc', '18280', 3, 377),
(6155, 'Xã Tân Dân', '18283', 3, 377),
(6156, 'Xã An Dũng', '18298', 3, 377),
(6157, 'Xã Đức Đồng', '18304', 3, 377),
(6158, 'Xã Đức Lạng', '18307', 3, 377),
(6159, 'Xã Tân Hương', '18310', 3, 377);

-- Tỉnh Hà Tĩnh > Huyện Vũ Quang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6160, 'Thị trấn Vũ Quang', '18313', 3, 378),
(6161, 'Xã Ân Phú', '18316', 3, 378),
(6162, 'Xã Đức Giang', '18319', 3, 378),
(6163, 'Xã Đức Lĩnh', '18322', 3, 378),
(6164, 'Xã Thọ Điền', '18325', 3, 378),
(6165, 'Xã Đức Hương', '18328', 3, 378),
(6166, 'Xã Đức Bồng', '18331', 3, 378),
(6167, 'Xã Đức Liên', '18334', 3, 378),
(6168, 'Xã Hương Minh', '18340', 3, 378),
(6169, 'Xã Quang Thọ', '18343', 3, 378);

-- Tỉnh Hà Tĩnh > Huyện Nghi Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6170, 'Thị trấn Xuân An', '18352', 3, 379),
(6171, 'Xã Xuân Hội', '18355', 3, 379),
(6172, 'Xã Đan Trường', '18358', 3, 379),
(6173, 'Xã Xuân Phổ', '18364', 3, 379),
(6174, 'Xã Xuân Hải', '18367', 3, 379),
(6175, 'Xã Xuân Giang', '18370', 3, 379),
(6176, 'Thị trấn Tiên Điền', '18373', 3, 379),
(6177, 'Xã Xuân Yên', '18376', 3, 379),
(6178, 'Xã Xuân Mỹ', '18379', 3, 379),
(6179, 'Xã Xuân Thành', '18382', 3, 379),
(6180, 'Xã Xuân Viên', '18385', 3, 379),
(6181, 'Xã Xuân Hồng', '18388', 3, 379),
(6182, 'Xã Cỗ Đạm', '18391', 3, 379),
(6183, 'Xã Xuân Liên', '18394', 3, 379),
(6184, 'Xã Xuân Lĩnh', '18397', 3, 379),
(6185, 'Xã Xuân Lam', '18400', 3, 379),
(6186, 'Xã Cương Gián', '18403', 3, 379);

-- Tỉnh Hà Tĩnh > Huyện Can Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6187, 'Thị trấn Nghèn', '18406', 3, 380),
(6188, 'Xã Thiên Lộc', '18415', 3, 380),
(6189, 'Xã Thuần Thiện', '18418', 3, 380),
(6190, 'Xã Vượng Lộc', '18427', 3, 380),
(6191, 'Xã Thanh Lộc', '18433', 3, 380),
(6192, 'Xã Kim Song Trường', '18436', 3, 380),
(6193, 'Xã Thường Nga', '18439', 3, 380),
(6194, 'Xã Tùng Lộc', '18445', 3, 380),
(6195, 'Xã Phú Lộc', '18454', 3, 380),
(6196, 'Xã Gia Hanh', '18463', 3, 380),
(6197, 'Xã Khánh Vĩnh Yên', '18466', 3, 380),
(6198, 'Xã Xuân Lộc', '18475', 3, 380),
(6199, 'Xã Thượng Lộc', '18478', 3, 380),
(6200, 'Xã Quang Lộc', '18481', 3, 380),
(6201, 'Thị trấn Đồng Lộc', '18484', 3, 380),
(6202, 'Xã Mỹ Lộc', '18487', 3, 380),
(6203, 'Xã Sơn Lộc', '18490', 3, 380);

-- Tỉnh Hà Tĩnh > Huyện Hương Khê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6204, 'Thị trấn Hương Khê', '18496', 3, 381),
(6205, 'Xã Điền Mỹ', '18499', 3, 381),
(6206, 'Xã Hà Linh', '18502', 3, 381),
(6207, 'Xã Hương Thủy', '18505', 3, 381),
(6208, 'Xã Hòa Hải', '18508', 3, 381),
(6209, 'Xã Phúc Đồng', '18514', 3, 381),
(6210, 'Xã Hương Giang', '18517', 3, 381),
(6211, 'Xã Lộc Yên', '18520', 3, 381),
(6212, 'Xã Hương Bình', '18523', 3, 381),
(6213, 'Xã Hương Long', '18526', 3, 381),
(6214, 'Xã Phú Gia', '18529', 3, 381),
(6215, 'Xã Gia Phố', '18532', 3, 381),
(6216, 'Xã Hương Đô', '18538', 3, 381),
(6217, 'Xã Hương Vĩnh', '18541', 3, 381),
(6218, 'Xã Hương Xuân', '18544', 3, 381),
(6219, 'Xã Phúc Trạch', '18547', 3, 381),
(6220, 'Xã Hương Trà', '18550', 3, 381),
(6221, 'Xã Hương Trạch', '18553', 3, 381),
(6222, 'Xã Hương Lâm', '18556', 3, 381),
(6223, 'Xã Hương Liên', '18559', 3, 381);

-- Tỉnh Hà Tĩnh > Huyện Thạch Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6224, 'Xã Tân Lộc', '18409', 3, 382),
(6225, 'Xã Hồng Lộc', '18412', 3, 382),
(6226, 'Xã Thịnh Lộc', '18421', 3, 382),
(6227, 'Xã Bình An', '18430', 3, 382),
(6228, 'Xã Bình Lộc', '18448', 3, 382),
(6229, 'Xã Ích Hậu', '18457', 3, 382),
(6230, 'Xã Phù Lưu', '18493', 3, 382),
(6231, 'Thị trấn Thạch Hà', '18562', 3, 382),
(6232, 'Xã Ngọc Sơn', '18565', 3, 382),
(6233, 'Thị trấn Lộc Hà', '18568', 3, 382),
(6234, 'Xã Thạch Mỹ', '18577', 3, 382),
(6235, 'Xã Thạch Kim', '18580', 3, 382),
(6236, 'Xã Thạch Châu', '18583', 3, 382),
(6237, 'Xã Thạch Kênh', '18586', 3, 382),
(6238, 'Xã Thạch Sơn', '18589', 3, 382),
(6239, 'Xã Thạch Liên', '18592', 3, 382),
(6240, 'Xã Việt Tiến', '18601', 3, 382),
(6241, 'Xã Thạch Long', '18607', 3, 382),
(6242, 'Xã Thạch Ngọc', '18625', 3, 382),
(6243, 'Xã Lưu Vĩnh Sơn', '18634', 3, 382),
(6244, 'Xã Thạch Xuân', '18658', 3, 382),
(6245, 'Xã Nam Điền', '18667', 3, 382),
(6246, 'Xã Mai Phụ', '18670', 3, 382);

-- Tỉnh Hà Tĩnh > Huyện Cẩm Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6247, 'Thị trấn Cẩm Xuyên', '18673', 3, 383),
(6248, 'Thị trấn Thiên Cầm', '18676', 3, 383),
(6249, 'Xã Yên Hòa', '18679', 3, 383),
(6250, 'Xã Cẩm Dương', '18682', 3, 383),
(6251, 'Xã Cẩm Thành', '18694', 3, 383),
(6252, 'Xã Cẩm Quang', '18697', 3, 383),
(6253, 'Xã Cẩm Thạch', '18706', 3, 383),
(6254, 'Xã Cẩm Nhượng', '18709', 3, 383),
(6255, 'Xã Nam Phúc Thăng', '18712', 3, 383),
(6256, 'Xã Cẩm Duệ', '18715', 3, 383),
(6257, 'Xã Cẩm Lĩnh', '18721', 3, 383),
(6258, 'Xã Cẩm Quan', '18724', 3, 383),
(6259, 'Xã Cẩm Hà', '18727', 3, 383),
(6260, 'Xã Cẩm Lộc', '18730', 3, 383),
(6261, 'Xã Cẩm Hưng', '18733', 3, 383),
(6262, 'Xã Cẩm Thịnh', '18736', 3, 383),
(6263, 'Xã Cẩm Mỹ', '18739', 3, 383),
(6264, 'Xã Cẩm Trung', '18742', 3, 383),
(6265, 'Xã Cẩm Sơn', '18745', 3, 383),
(6266, 'Xã Cẩm Lạc', '18748', 3, 383),
(6267, 'Xã Cẩm Minh', '18751', 3, 383);

-- Tỉnh Hà Tĩnh > Huyện Kỳ Anh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6268, 'Xã Kỳ Xuân', '18757', 3, 384),
(6269, 'Xã Kỳ Bắc', '18760', 3, 384),
(6270, 'Xã Kỳ Phú', '18763', 3, 384),
(6271, 'Xã Kỳ Phong', '18766', 3, 384),
(6272, 'Xã Kỳ Tiến', '18769', 3, 384),
(6273, 'Xã Kỳ Giang', '18772', 3, 384),
(6274, 'Thị trấn Kỳ Đồng', '18775', 3, 384),
(6275, 'Xã Kỳ Khang', '18778', 3, 384),
(6276, 'Xã Kỳ Văn', '18784', 3, 384),
(6277, 'Xã Kỳ Trung', '18787', 3, 384),
(6278, 'Xã Kỳ Thọ', '18790', 3, 384),
(6279, 'Xã Kỳ Tây', '18793', 3, 384),
(6280, 'Xã Kỳ Thượng', '18799', 3, 384),
(6281, 'Xã Kỳ Hải', '18802', 3, 384),
(6282, 'Xã Kỳ Thư', '18805', 3, 384),
(6283, 'Xã Kỳ Châu', '18811', 3, 384),
(6284, 'Xã Kỳ Tân', '18814', 3, 384),
(6285, 'Xã Lâm Hợp', '18838', 3, 384),
(6286, 'Xã Kỳ Sơn', '18844', 3, 384),
(6287, 'Xã Kỳ Lạc', '18850', 3, 384);

-- Tỉnh Hà Tĩnh > Thị xã Kỳ Anh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6288, 'Phường Hưng Trí', '18754', 3, 385),
(6289, 'Phường Kỳ Ninh', '18781', 3, 385),
(6290, 'Xã Kỳ Lợi', '18796', 3, 385),
(6291, 'Xã Kỳ Hà', '18808', 3, 385),
(6292, 'Phường Kỳ Trinh', '18820', 3, 385),
(6293, 'Phường Kỳ Thịnh', '18823', 3, 385),
(6294, 'Xã Kỳ Hoa', '18829', 3, 385),
(6295, 'Phường Kỳ Phương', '18832', 3, 385),
(6296, 'Phường Kỳ Long', '18835', 3, 385),
(6297, 'Phường Kỳ Liên', '18841', 3, 385),
(6298, 'Phường Kỳ Nam', '18847', 3, 385);

-- Tỉnh Quảng Bình > Thành Phố Đồng Hới
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6299, 'Phường Hải Thành', '18853', 3, 386),
(6300, 'Phường Đồng Phú', '18856', 3, 386),
(6301, 'Phường Bắc Lý', '18859', 3, 386),
(6302, 'Phường Nam Lý', '18865', 3, 386),
(6303, 'Phường Đồng Hải', '18868', 3, 386),
(6304, 'Phường Đồng Sơn', '18871', 3, 386),
(6305, 'Phường Phú Hải', '18874', 3, 386),
(6306, 'Phường Bắc Nghĩa', '18877', 3, 386),
(6307, 'Phường Đức Ninh Đông', '18880', 3, 386),
(6308, 'Xã Quang Phú', '18883', 3, 386),
(6309, 'Xã Lộc Ninh', '18886', 3, 386),
(6310, 'Xã Bảo Ninh', '18889', 3, 386),
(6311, 'Xã Nghĩa Ninh', '18892', 3, 386),
(6312, 'Xã Thuận Đức', '18895', 3, 386),
(6313, 'Xã Đức Ninh', '18898', 3, 386);

-- Tỉnh Quảng Bình > Huyện Minh Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6314, 'Thị trấn Quy Đạt', '18901', 3, 387),
(6315, 'Xã Dân Hóa', '18904', 3, 387),
(6316, 'Xã Trọng Hóa', '18907', 3, 387),
(6317, 'Xã Hồng Hóa', '18913', 3, 387),
(6318, 'Xã Tân Thành', '18919', 3, 387),
(6319, 'Xã Hóa Hợp', '18922', 3, 387),
(6320, 'Xã Xuân Hóa', '18925', 3, 387),
(6321, 'Xã Yên Hóa', '18928', 3, 387),
(6322, 'Xã Minh Hóa', '18931', 3, 387),
(6323, 'Xã Tân Hóa', '18934', 3, 387),
(6324, 'Xã Hóa Sơn', '18937', 3, 387),
(6325, 'Xã Trung Hóa', '18943', 3, 387),
(6326, 'Xã Thượng Hóa', '18946', 3, 387);

-- Tỉnh Quảng Bình > Huyện Tuyên Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6327, 'Thị trấn Đồng Lê', '18949', 3, 388),
(6328, 'Xã Hương Hóa', '18952', 3, 388),
(6329, 'Xã Kim Hóa', '18955', 3, 388),
(6330, 'Xã Thanh Hóa', '18958', 3, 388),
(6331, 'Xã Thanh Thạch', '18961', 3, 388),
(6332, 'Xã Thuận Hóa', '18964', 3, 388),
(6333, 'Xã Lâm Hóa', '18967', 3, 388),
(6334, 'Xã Lê Hóa', '18970', 3, 388),
(6335, 'Xã Sơn Hóa', '18973', 3, 388),
(6336, 'Xã Đồng Hóa', '18976', 3, 388),
(6337, 'Xã Ngư Hóa', '18979', 3, 388),
(6338, 'Xã Thạch Hóa', '18985', 3, 388),
(6339, 'Xã Đức Hóa', '18988', 3, 388),
(6340, 'Xã Phong Hóa', '18991', 3, 388),
(6341, 'Xã Mai Hóa', '18994', 3, 388),
(6342, 'Xã Tiến Hóa', '18997', 3, 388),
(6343, 'Xã Châu Hóa', '19000', 3, 388),
(6344, 'Xã Cao Quảng', '19003', 3, 388),
(6345, 'Xã Văn Hóa', '19006', 3, 388);

-- Tỉnh Quảng Bình > Huyện Quảng Trạch
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6346, 'Xã Quảng Hợp', '19012', 3, 389),
(6347, 'Xã Quảng Kim', '19015', 3, 389),
(6348, 'Xã Quảng Đông', '19018', 3, 389),
(6349, 'Xã Quảng Phú', '19021', 3, 389),
(6350, 'Xã Quảng Châu', '19024', 3, 389),
(6351, 'Xã Quảng Thạch', '19027', 3, 389),
(6352, 'Xã Quảng Lưu', '19030', 3, 389),
(6353, 'Xã Quảng Tùng', '19033', 3, 389),
(6354, 'Xã Cảnh Dương', '19036', 3, 389),
(6355, 'Xã Quảng Tiến', '19039', 3, 389),
(6356, 'Xã Quảng Hưng', '19042', 3, 389),
(6357, 'Xã Quảng Xuân', '19045', 3, 389),
(6358, 'Xã Liên Trường', '19051', 3, 389),
(6359, 'Xã Quảng Phương', '19057', 3, 389),
(6360, 'Xã Phù Cảnh', '19063', 3, 389),
(6361, 'Xã Quảng Thanh', '19072', 3, 389);

-- Tỉnh Quảng Bình > Huyện Bố Trạch
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6362, 'Thị trấn Hoàn Lão', '19111', 3, 390),
(6363, 'Thị trấn NT Việt Trung', '19114', 3, 390),
(6364, 'Xã Xuân Trạch', '19117', 3, 390),
(6365, 'Xã Hạ Mỹ', '19123', 3, 390),
(6366, 'Xã Bắc Trạch', '19126', 3, 390),
(6367, 'Xã Lâm Trạch', '19129', 3, 390),
(6368, 'Xã Thanh Trạch', '19132', 3, 390),
(6369, 'Xã Liên Trạch', '19135', 3, 390),
(6370, 'Xã Phúc Trạch', '19138', 3, 390),
(6371, 'Xã Cự Nẫm', '19141', 3, 390),
(6372, 'Xã Hải Phú', '19144', 3, 390),
(6373, 'Xã Thượng Trạch', '19147', 3, 390),
(6374, 'Xã Sơn Lộc', '19150', 3, 390),
(6375, 'Xã Hưng Trạch', '19156', 3, 390),
(6376, 'Xã Đồng Trạch', '19159', 3, 390),
(6377, 'Xã Đức Trạch', '19162', 3, 390),
(6378, 'Thị trấn Phong Nha', '19165', 3, 390),
(6379, 'Xã Vạn Trạch', '19168', 3, 390),
(6380, 'Xã Phú Định', '19174', 3, 390),
(6381, 'Xã Trung Trạch', '19177', 3, 390),
(6382, 'Xã Tây Trạch', '19180', 3, 390),
(6383, 'Xã Hòa Trạch', '19183', 3, 390),
(6384, 'Xã Đại Trạch', '19186', 3, 390),
(6385, 'Xã Nhân Trạch', '19189', 3, 390),
(6386, 'Xã Tân Trạch', '19192', 3, 390),
(6387, 'Xã Lý Nam', '19198', 3, 390);

-- Tỉnh Quảng Bình > Huyện Quảng Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6388, 'Xã Trường Sơn', '19204', 3, 391),
(6389, 'Thị trấn Quán Hàu', '19207', 3, 391),
(6390, 'Xã Vĩnh Ninh', '19210', 3, 391),
(6391, 'Xã Võ Ninh', '19213', 3, 391),
(6392, 'Xã Hải Ninh', '19216', 3, 391),
(6393, 'Xã Hàm Ninh', '19219', 3, 391),
(6394, 'Xã Duy Ninh', '19222', 3, 391),
(6395, 'Xã Gia Ninh', '19225', 3, 391),
(6396, 'Xã Trường Xuân', '19228', 3, 391),
(6397, 'Xã Hiền Ninh', '19231', 3, 391),
(6398, 'Xã Tân Ninh', '19234', 3, 391),
(6399, 'Xã Xuân Ninh', '19237', 3, 391),
(6400, 'Xã An Ninh', '19240', 3, 391),
(6401, 'Xã Vạn Ninh', '19243', 3, 391);

-- Tỉnh Quảng Bình > Huyện Lệ Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6402, 'Thị trấn NT Lệ Ninh', '19246', 3, 392),
(6403, 'Thị trấn Kiến Giang', '19249', 3, 392),
(6404, 'Xã Hồng Thủy', '19252', 3, 392),
(6405, 'Xã Ngư Thủy Bắc', '19255', 3, 392),
(6406, 'Xã Hoa Thủy', '19258', 3, 392),
(6407, 'Xã Thanh Thủy', '19261', 3, 392),
(6408, 'Xã An Thủy', '19264', 3, 392),
(6409, 'Xã Phong Thủy', '19267', 3, 392),
(6410, 'Xã Cam Thủy', '19270', 3, 392),
(6411, 'Xã Ngân Thủy', '19273', 3, 392),
(6412, 'Xã Sơn Thủy', '19276', 3, 392),
(6413, 'Xã Lộc Thủy', '19279', 3, 392),
(6414, 'Xã Liên Thủy', '19285', 3, 392),
(6415, 'Xã Hưng Thủy', '19288', 3, 392),
(6416, 'Xã Dương Thủy', '19291', 3, 392),
(6417, 'Xã Tân Thủy', '19294', 3, 392),
(6418, 'Xã Phú Thủy', '19297', 3, 392),
(6419, 'Xã Xuân Thủy', '19300', 3, 392),
(6420, 'Xã Mỹ Thủy', '19303', 3, 392),
(6421, 'Xã Ngư Thủy', '19306', 3, 392),
(6422, 'Xã Mai Thủy', '19309', 3, 392),
(6423, 'Xã Sen Thủy', '19312', 3, 392),
(6424, 'Xã Thái Thủy', '19315', 3, 392),
(6425, 'Xã Kim Thủy', '19318', 3, 392),
(6426, 'Xã Trường Thủy', '19321', 3, 392),
(6427, 'Xã Lâm Thủy', '19327', 3, 392);

-- Tỉnh Quảng Bình > Thị xã Ba Đồn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6428, 'Phường Ba Đồn', '19009', 3, 393),
(6429, 'Phường Quảng Long', '19060', 3, 393),
(6430, 'Phường Quảng Thọ', '19066', 3, 393),
(6431, 'Xã Quảng Tiên', '19069', 3, 393),
(6432, 'Xã Quảng Trung', '19075', 3, 393),
(6433, 'Phường Quảng Phong', '19078', 3, 393),
(6434, 'Phường Quảng Thuận', '19081', 3, 393),
(6435, 'Xã Quảng Tân', '19084', 3, 393),
(6436, 'Xã Quảng Hải', '19087', 3, 393),
(6437, 'Xã Quảng Sơn', '19090', 3, 393),
(6438, 'Xã Quảng Lộc', '19093', 3, 393),
(6439, 'Xã Quảng Thủy', '19096', 3, 393),
(6440, 'Xã Quảng Văn', '19099', 3, 393),
(6441, 'Phường Quảng Phúc', '19102', 3, 393),
(6442, 'Xã Quảng Hòa', '19105', 3, 393),
(6443, 'Xã Quảng Minh', '19108', 3, 393);

-- Tỉnh Quảng Trị > Thành phố Đông Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6444, 'Phường Đông Giang', '19330', 3, 394),
(6445, 'Phường 1', '19333', 3, 394),
(6446, 'Phường Đông Lễ', '19336', 3, 394),
(6447, 'Phường Đông Thanh', '19339', 3, 394),
(6448, 'Phường 2', '19342', 3, 394),
(6449, 'Phường 4', '19345', 3, 394),
(6450, 'Phường 5', '19348', 3, 394),
(6451, 'Phường Đông Lương', '19351', 3, 394),
(6452, 'Phường 3', '19354', 3, 394);

-- Tỉnh Quảng Trị > Thị xã Quảng Trị
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6453, 'Phường 1', '19357', 3, 395),
(6454, 'Phường An Đôn', '19358', 3, 395),
(6455, 'Phường 2', '19360', 3, 395),
(6456, 'Phường 3', '19361', 3, 395),
(6457, 'Xã Hải Lệ', '19705', 3, 395);

-- Tỉnh Quảng Trị > Huyện Vĩnh Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6458, 'Thị trấn Hồ Xá', '19363', 3, 396),
(6459, 'Thị trấn Bến Quan', '19366', 3, 396),
(6460, 'Xã Vĩnh Thái', '19369', 3, 396),
(6461, 'Xã Vĩnh Tú', '19372', 3, 396),
(6462, 'Xã Vĩnh Chấp', '19375', 3, 396),
(6463, 'Xã Trung Nam', '19378', 3, 396),
(6464, 'Xã Kim Thạch', '19384', 3, 396),
(6465, 'Xã Vĩnh Long', '19387', 3, 396),
(6466, 'Xã Vĩnh Khê', '19393', 3, 396),
(6467, 'Xã Vĩnh Hòa', '19396', 3, 396),
(6468, 'Xã Vĩnh Thủy', '19402', 3, 396),
(6469, 'Xã Vĩnh Lâm', '19405', 3, 396),
(6470, 'Xã Hiền Thành', '19408', 3, 396),
(6471, 'Thị trấn Cửa Tùng', '19414', 3, 396),
(6472, 'Xã Vĩnh Hà', '19417', 3, 396),
(6473, 'Xã Vĩnh Sơn', '19420', 3, 396),
(6474, 'Xã Vĩnh Giang', '19423', 3, 396),
(6475, 'Xã Vĩnh Ô', '19426', 3, 396);

-- Tỉnh Quảng Trị > Huyện Hướng Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6476, 'Thị trấn Khe Sanh', '19429', 3, 397),
(6477, 'Thị trấn Lao Bảo', '19432', 3, 397),
(6478, 'Xã Hướng Lập', '19435', 3, 397),
(6479, 'Xã Hướng Việt', '19438', 3, 397),
(6480, 'Xã Hướng Phùng', '19441', 3, 397),
(6481, 'Xã Hướng Sơn', '19444', 3, 397),
(6482, 'Xã Hướng Linh', '19447', 3, 397),
(6483, 'Xã Tân Hợp', '19450', 3, 397),
(6484, 'Xã Hướng Tân', '19453', 3, 397),
(6485, 'Xã Tân Thành', '19456', 3, 397),
(6486, 'Xã Tân Long', '19459', 3, 397),
(6487, 'Xã Tân Lập', '19462', 3, 397),
(6488, 'Xã Tân Liên', '19465', 3, 397),
(6489, 'Xã Húc', '19468', 3, 397),
(6490, 'Xã Thuận', '19471', 3, 397),
(6491, 'Xã Hướng Lộc', '19474', 3, 397),
(6492, 'Xã Ba Tầng', '19477', 3, 397),
(6493, 'Xã Thanh', '19480', 3, 397),
(6494, 'Xã A Dơi', '19483', 3, 397),
(6495, 'Xã Lìa', '19489', 3, 397),
(6496, 'Xã Xy', '19492', 3, 397);

-- Tỉnh Quảng Trị > Huyện Gio Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6497, 'Thị trấn Gio Linh', '19495', 3, 398),
(6498, 'Thị trấn Cửa Việt', '19496', 3, 398),
(6499, 'Xã Trung Giang', '19498', 3, 398),
(6500, 'Xã Trung Hải', '19501', 3, 398),
(6501, 'Xã Trung Sơn', '19504', 3, 398),
(6502, 'Xã Phong Bình', '19507', 3, 398),
(6503, 'Xã Gio Mỹ', '19510', 3, 398),
(6504, 'Xã Gio Hải', '19519', 3, 398),
(6505, 'Xã Gio An', '19522', 3, 398),
(6506, 'Xã Linh Trường', '19534', 3, 398),
(6507, 'Xã Gio Sơn', '19537', 3, 398),
(6508, 'Xã Gio Mai', '19543', 3, 398),
(6509, 'Xã Hải Thái', '19546', 3, 398),
(6510, 'Xã Gio Quang', '19552', 3, 398);

-- Tỉnh Quảng Trị > Huyện Đa Krông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6511, 'Thị trấn Krông Klang', '19555', 3, 399),
(6512, 'Xã Mò Ó', '19558', 3, 399),
(6513, 'Xã Hướng Hiệp', '19561', 3, 399),
(6514, 'Xã Đa Krông', '19564', 3, 399),
(6515, 'Xã Triệu Nguyên', '19567', 3, 399),
(6516, 'Xã Ba Lòng', '19570', 3, 399),
(6517, 'Xã Ba Nang', '19576', 3, 399),
(6518, 'Xã Tà Long', '19579', 3, 399),
(6519, 'Xã Húc Nghì', '19582', 3, 399),
(6520, 'Xã A Vao', '19585', 3, 399),
(6521, 'Xã Tà Rụt', '19588', 3, 399),
(6522, 'Xã A Bung', '19591', 3, 399),
(6523, 'Xã A Ngo', '19594', 3, 399);

-- Tỉnh Quảng Trị > Huyện Cam Lộ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6524, 'Thị trấn Cam Lộ', '19597', 3, 400),
(6525, 'Xã Cam Tuyền', '19600', 3, 400),
(6526, 'Xã Thanh An', '19603', 3, 400),
(6527, 'Xã Cam Thủy', '19606', 3, 400),
(6528, 'Xã Cam Thành', '19612', 3, 400),
(6529, 'Xã Cam Hiếu', '19615', 3, 400),
(6530, 'Xã Cam Chính', '19618', 3, 400),
(6531, 'Xã Cam Nghĩa', '19621', 3, 400);

-- Tỉnh Quảng Trị > Huyện Triệu Phong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6532, 'Thị trấn Ái Tử', '19624', 3, 401),
(6533, 'Xã Triệu Tân', '19627', 3, 401),
(6534, 'Xã Triệu Phước', '19633', 3, 401),
(6535, 'Xã Triệu Độ', '19636', 3, 401),
(6536, 'Xã Triệu Trạch', '19639', 3, 401),
(6537, 'Xã Triệu Thuận', '19642', 3, 401),
(6538, 'Xã Triệu Đại', '19645', 3, 401),
(6539, 'Xã Triệu Hòa', '19648', 3, 401),
(6540, 'Xã Triệu Cơ', '19654', 3, 401),
(6541, 'Xã Triệu Long', '19657', 3, 401),
(6542, 'Xã Triệu Tài', '19660', 3, 401),
(6543, 'Xã Triệu Trung', '19666', 3, 401),
(6544, 'Xã Triệu Ái', '19669', 3, 401),
(6545, 'Xã Triệu Thượng', '19672', 3, 401),
(6546, 'Xã Triệu Giang', '19675', 3, 401),
(6547, 'Xã Triệu Thành', '19678', 3, 401);

-- Tỉnh Quảng Trị > Huyện Hải Lăng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6548, 'Thị trấn Diên Sanh', '19681', 3, 402),
(6549, 'Xã Hải An', '19684', 3, 402),
(6550, 'Xã Hải Bình', '19687', 3, 402),
(6551, 'Xã Hải Quy', '19693', 3, 402),
(6552, 'Xã Hải Hưng', '19699', 3, 402),
(6553, 'Xã Hải Phú', '19702', 3, 402),
(6554, 'Xã Hải Thượng', '19708', 3, 402),
(6555, 'Xã Hải Dương', '19711', 3, 402),
(6556, 'Xã Hải Định', '19714', 3, 402),
(6557, 'Xã Hải Lâm', '19717', 3, 402),
(6558, 'Xã Hải Phong', '19726', 3, 402),
(6559, 'Xã Hải Trường', '19729', 3, 402),
(6560, 'Xã Hải Sơn', '19735', 3, 402),
(6561, 'Xã Hải Chánh', '19738', 3, 402),
(6562, 'Xã Hải Khê', '19741', 3, 402);

-- Thành phố Huế > Quận Thuận Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6563, 'Phường Vỹ Dạ', '19777', 3, 404),
(6564, 'Phường Phường Đúc', '19780', 3, 404),
(6565, 'Phường Vĩnh Ninh', '19783', 3, 404),
(6566, 'Phường Phú Hội', '19786', 3, 404),
(6567, 'Phường Phú Nhuận', '19789', 3, 404),
(6568, 'Phường Xuân Phú', '19792', 3, 404),
(6569, 'Phường Trường An', '19795', 3, 404),
(6570, 'Phường Phước Vĩnh', '19798', 3, 404),
(6571, 'Phường An Cựu', '19801', 3, 404),
(6572, 'Phường Thuỷ Biều', '19807', 3, 404),
(6573, 'Phường Thuỷ Xuân', '19813', 3, 404),
(6574, 'Phường An Đông', '19815', 3, 404),
(6575, 'Phường An Tây', '19816', 3, 404),
(6576, 'Phường Thuận An', '19900', 3, 404),
(6577, 'Phường Dương Nỗ', '19909', 3, 404),
(6578, 'Phường Phú Thượng', '19930', 3, 404),
(6579, 'Phường Thủy Vân', '19963', 3, 404),
(6580, 'Phường Thủy Bằng', '19981', 3, 404),
(6581, 'Phường Hương Phong', '20002', 3, 404);

-- Thành phố Huế > Quận Phú Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6582, 'Phường Tây Lộc', '19750', 3, 405),
(6583, 'Phường Thuận Lộc', '19753', 3, 405),
(6584, 'Phường Gia Hội', '19756', 3, 405),
(6585, 'Phường Phú Hậu', '19759', 3, 405),
(6586, 'Phường Thuận Hòa', '19762', 3, 405),
(6587, 'Phường Đông Ba', '19768', 3, 405),
(6588, 'Phường Kim Long', '19774', 3, 405),
(6589, 'Phường An Hòa', '19803', 3, 405),
(6590, 'Phường Hương Sơ', '19804', 3, 405),
(6591, 'Phường Hương Long', '19810', 3, 405),
(6592, 'Phường Hương Vinh', '20014', 3, 405),
(6593, 'Phường Hương An', '20023', 3, 405),
(6594, 'Phường Long Hồ', '20029', 3, 405);

-- Thành phố Huế > Thị xã Phong Điền
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6595, 'Phường Phong Thu', '19819', 3, 406),
(6596, 'Xã Phong Thạnh', '19825', 3, 406),
(6597, 'Phường Phong Phú', '19828', 3, 406),
(6598, 'Xã Phong Bình', '19831', 3, 406),
(6599, 'Xã Phong Chương', '19837', 3, 406),
(6600, 'Phường Phong Hải', '19843', 3, 406),
(6601, 'Phường Phong Hòa', '19846', 3, 406),
(6602, 'Phường Phong Hiền', '19852', 3, 406),
(6603, 'Xã Phong Mỹ', '19855', 3, 406),
(6604, 'Phường Phong An', '19858', 3, 406),
(6605, 'Xã Phong Xuân', '19861', 3, 406),
(6606, 'Xã Phong Sơn', '19864', 3, 406);

-- Thành phố Huế > Huyện Quảng Điền
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6607, 'Thị trấn Sịa', '19867', 3, 407),
(6608, 'Xã Quảng Thái', '19870', 3, 407),
(6609, 'Xã Quảng Ngạn', '19873', 3, 407),
(6610, 'Xã Quảng Lợi', '19876', 3, 407),
(6611, 'Xã Quảng Công', '19879', 3, 407),
(6612, 'Xã Quảng Phước', '19882', 3, 407),
(6613, 'Xã Quảng Vinh', '19885', 3, 407),
(6614, 'Xã Quảng An', '19888', 3, 407),
(6615, 'Xã Quảng Thành', '19891', 3, 407),
(6616, 'Xã Quảng Thọ', '19894', 3, 407),
(6617, 'Xã Quảng Phú', '19897', 3, 407);

-- Thành phố Huế > Huyện Phú Vang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6618, 'Xã Phú Thuận', '19903', 3, 408),
(6619, 'Xã Phú An', '19912', 3, 408),
(6620, 'Xã Phú Hải', '19915', 3, 408),
(6621, 'Xã Phú Xuân', '19918', 3, 408),
(6622, 'Xã Phú Diên', '19921', 3, 408),
(6623, 'Xã Phú Mỹ', '19927', 3, 408),
(6624, 'Xã Phú Hồ', '19933', 3, 408),
(6625, 'Xã Vinh Xuân', '19936', 3, 408),
(6626, 'Xã Phú Lương', '19939', 3, 408),
(6627, 'Thị trấn Phú Đa', '19942', 3, 408),
(6628, 'Xã Vinh Thanh', '19945', 3, 408),
(6629, 'Xã Vinh An', '19948', 3, 408),
(6630, 'Xã Phú Gia', '19954', 3, 408),
(6631, 'Xã Vinh Hà', '19957', 3, 408);

-- Thành phố Huế > Thị xã Hương Thủy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6632, 'Phường Phú Bài', '19960', 3, 409),
(6633, 'Xã Thủy Thanh', '19966', 3, 409),
(6634, 'Phường Thủy Dương', '19969', 3, 409),
(6635, 'Phường Thủy Phương', '19972', 3, 409),
(6636, 'Phường Thủy Châu', '19975', 3, 409),
(6637, 'Phường Thủy Lương', '19978', 3, 409),
(6638, 'Xã Thủy Tân', '19984', 3, 409),
(6639, 'Xã Thủy Phù', '19987', 3, 409),
(6640, 'Xã Phú Sơn', '19990', 3, 409),
(6641, 'Xã Dương Hòa', '19993', 3, 409);

-- Thành phố Huế > Thị xã Hương Trà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6642, 'Phường Tứ Hạ', '19996', 3, 410),
(6643, 'Xã Hương Toàn', '20005', 3, 410),
(6644, 'Phường Hương Vân', '20008', 3, 410),
(6645, 'Phường Hương Văn', '20011', 3, 410),
(6646, 'Phường Hương Xuân', '20017', 3, 410),
(6647, 'Phường Hương Chữ', '20020', 3, 410),
(6648, 'Xã Hương Bình', '20026', 3, 410),
(6649, 'Xã Bình Tiến', '20035', 3, 410),
(6650, 'Xã Bình Thành', '20041', 3, 410);

-- Thành phố Huế > Huyện A Lưới
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6651, 'Thị trấn A Lưới', '20044', 3, 411),
(6652, 'Xã Hồng Vân', '20047', 3, 411),
(6653, 'Xã Hồng Hạ', '20050', 3, 411),
(6654, 'Xã Hồng Kim', '20053', 3, 411),
(6655, 'Xã Trung Sơn', '20056', 3, 411),
(6656, 'Xã Hương Nguyên', '20059', 3, 411),
(6657, 'Xã Hồng Bắc', '20065', 3, 411),
(6658, 'Xã A Ngo', '20068', 3, 411),
(6659, 'Xã Sơn Thủy', '20071', 3, 411),
(6660, 'Xã Phú Vinh', '20074', 3, 411),
(6661, 'Xã Hương Phong', '20080', 3, 411),
(6662, 'Xã Quảng Nhâm', '20083', 3, 411),
(6663, 'Xã Hồng Thượng', '20086', 3, 411),
(6664, 'Xã Hồng Thái', '20089', 3, 411),
(6665, 'Xã A Roàng', '20095', 3, 411),
(6666, 'Xã Đông Sơn', '20098', 3, 411),
(6667, 'Xã Lâm Đớt', '20101', 3, 411),
(6668, 'Xã Hồng Thủy', '20104', 3, 411);

-- Thành phố Huế > Huyện Phú Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6669, 'Thị trấn Phú Lộc', '20107', 3, 412),
(6670, 'Thị trấn Lăng Cô', '20110', 3, 412),
(6671, 'Xã Vinh Mỹ', '20113', 3, 412),
(6672, 'Xã Vinh Hưng', '20116', 3, 412),
(6673, 'Xã Giang Hải', '20122', 3, 412),
(6674, 'Xã Vinh Hiền', '20125', 3, 412),
(6675, 'Xã Lộc Bổn', '20128', 3, 412),
(6676, 'Thị trấn Lộc Sơn', '20131', 3, 412),
(6677, 'Xã Lộc Bình', '20134', 3, 412),
(6678, 'Xã Lộc Vĩnh', '20137', 3, 412),
(6679, 'Xã Lộc An', '20140', 3, 412),
(6680, 'Xã Lộc Điền', '20143', 3, 412),
(6681, 'Xã Lộc Thủy', '20146', 3, 412),
(6682, 'Xã Lộc Trì', '20149', 3, 412),
(6683, 'Xã Lộc Tiến', '20152', 3, 412),
(6684, 'Xã Lộc Hòa', '20155', 3, 412),
(6685, 'Xã Xuân Lộc', '20158', 3, 412),
(6686, 'Thị trấn Khe Tre', '20161', 3, 412),
(6687, 'Xã Hương Phú', '20164', 3, 412),
(6688, 'Xã Hương Sơn', '20167', 3, 412),
(6689, 'Xã Hương Lộc', '20170', 3, 412),
(6690, 'Xã Thượng Quảng', '20173', 3, 412),
(6691, 'Xã Hương Hòa', '20176', 3, 412),
(6692, 'Xã Hương Xuân', '20179', 3, 412),
(6693, 'Xã Hương Hữu', '20182', 3, 412),
(6694, 'Xã Thượng Lộ', '20185', 3, 412),
(6695, 'Xã Thượng Long', '20188', 3, 412),
(6696, 'Xã Thượng Nhật', '20191', 3, 412);

-- Thành phố Đà Nẵng > Quận Liên Chiểu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6697, 'Phường Hòa Hiệp Bắc', '20194', 3, 413),
(6698, 'Phường Hòa Hiệp Nam', '20195', 3, 413),
(6699, 'Phường Hòa Khánh Bắc', '20197', 3, 413),
(6700, 'Phường Hòa Khánh Nam', '20198', 3, 413),
(6701, 'Phường Hòa Minh', '20200', 3, 413);

-- Thành phố Đà Nẵng > Quận Thanh Khê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6702, 'Phường Thanh Khê Tây', '20206', 3, 414),
(6703, 'Phường Thanh Khê Đông', '20207', 3, 414),
(6704, 'Phường Xuân Hà', '20209', 3, 414),
(6705, 'Phường Chính Gián', '20215', 3, 414),
(6706, 'Phường Thạc Gián', '20218', 3, 414),
(6707, 'Phường An Khê', '20224', 3, 414);

-- Thành phố Đà Nẵng > Quận Hải Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6708, 'Phường Thanh Bình', '20227', 3, 415),
(6709, 'Phường Thuận Phước', '20230', 3, 415),
(6710, 'Phường Thạch Thang', '20233', 3, 415),
(6711, 'Phường Hải Châu', '20236', 3, 415),
(6712, 'Phường Phước Ninh', '20242', 3, 415),
(6713, 'Phường Hòa Thuận Tây', '20245', 3, 415),
(6714, 'Phường Bình Thuận', '20254', 3, 415),
(6715, 'Phường Hòa Cường Bắc', '20257', 3, 415),
(6716, 'Phường Hòa Cường Nam', '20258', 3, 415);

-- Thành phố Đà Nẵng > Quận Sơn Trà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6717, 'Phường Thọ Quang', '20263', 3, 416),
(6718, 'Phường Nại Hiên Đông', '20266', 3, 416),
(6719, 'Phường Mân Thái', '20269', 3, 416),
(6720, 'Phường An Hải Bắc', '20272', 3, 416),
(6721, 'Phường Phước Mỹ', '20275', 3, 416),
(6722, 'Phường An Hải Nam', '20278', 3, 416);

-- Thành phố Đà Nẵng > Quận Ngũ Hành Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6723, 'Phường Mỹ An', '20284', 3, 417),
(6724, 'Phường Khuê Mỹ', '20285', 3, 417),
(6725, 'Phường Hoà Quý', '20287', 3, 417),
(6726, 'Phường Hoà Hải', '20290', 3, 417);

-- Thành phố Đà Nẵng > Quận Cẩm Lệ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6727, 'Phường Khuê Trung', '20260', 3, 418),
(6728, 'Phường Hòa Phát', '20305', 3, 418),
(6729, 'Phường Hòa An', '20306', 3, 418),
(6730, 'Phường Hòa Thọ Tây', '20311', 3, 418),
(6731, 'Phường Hòa Thọ Đông', '20312', 3, 418),
(6732, 'Phường Hòa Xuân', '20314', 3, 418);

-- Thành phố Đà Nẵng > Huyện Hòa Vang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6733, 'Xã Hòa Bắc', '20293', 3, 419),
(6734, 'Xã Hòa Liên', '20296', 3, 419),
(6735, 'Xã Hòa Ninh', '20299', 3, 419),
(6736, 'Xã Hòa Sơn', '20302', 3, 419),
(6737, 'Xã Hòa Nhơn', '20308', 3, 419),
(6738, 'Xã Hòa Phú', '20317', 3, 419),
(6739, 'Xã Hòa Phong', '20320', 3, 419),
(6740, 'Xã Hòa Châu', '20323', 3, 419),
(6741, 'Xã Hòa Tiến', '20326', 3, 419),
(6742, 'Xã Hòa Phước', '20329', 3, 419),
(6743, 'Xã Hòa Khương', '20332', 3, 419);

-- Tỉnh Quảng Nam > Thành phố Tam Kỳ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6744, 'Phường Tân Thạnh', '20335', 3, 421),
(6745, 'Phường An Mỹ', '20341', 3, 421),
(6746, 'Phường Hòa Hương', '20344', 3, 421),
(6747, 'Phường An Xuân', '20347', 3, 421),
(6748, 'Phường An Sơn', '20350', 3, 421),
(6749, 'Phường Trường Xuân', '20353', 3, 421),
(6750, 'Phường An Phú', '20356', 3, 421),
(6751, 'Xã Tam Thanh', '20359', 3, 421),
(6752, 'Xã Tam Thăng', '20362', 3, 421),
(6753, 'Xã Tam Phú', '20371', 3, 421),
(6754, 'Phường Hoà Thuận', '20375', 3, 421),
(6755, 'Xã Tam Ngọc', '20389', 3, 421);

-- Tỉnh Quảng Nam > Thành phố Hội An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6756, 'Phường Minh An', '20398', 3, 422),
(6757, 'Phường Tân An', '20401', 3, 422),
(6758, 'Phường Cẩm Phô', '20404', 3, 422),
(6759, 'Phường Thanh Hà', '20407', 3, 422),
(6760, 'Phường Sơn Phong', '20410', 3, 422),
(6761, 'Phường Cẩm Châu', '20413', 3, 422),
(6762, 'Phường Cửa Đại', '20416', 3, 422),
(6763, 'Phường Cẩm An', '20419', 3, 422),
(6764, 'Xã Cẩm Hà', '20422', 3, 422),
(6765, 'Xã Cẩm Kim', '20425', 3, 422),
(6766, 'Phường Cẩm Nam', '20428', 3, 422),
(6767, 'Xã Cẩm Thanh', '20431', 3, 422),
(6768, 'Xã Tân Hiệp', '20434', 3, 422);

-- Tỉnh Quảng Nam > Huyện Tây Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6769, 'Xã Ch''ơm', '20437', 3, 423),
(6770, 'Xã Ga Ri', '20440', 3, 423),
(6771, 'Xã A Xan', '20443', 3, 423),
(6772, 'Xã Tr''Hy', '20446', 3, 423),
(6773, 'Xã Lăng', '20449', 3, 423),
(6774, 'Xã A Nông', '20452', 3, 423),
(6775, 'Xã A Tiêng', '20455', 3, 423),
(6776, 'Xã Bha Lê', '20458', 3, 423),
(6777, 'Xã A Vương', '20461', 3, 423),
(6778, 'Xã Dang', '20464', 3, 423);

-- Tỉnh Quảng Nam > Huyện Đông Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6779, 'Thị trấn P Rao', '20467', 3, 424),
(6780, 'Xã Tà Lu', '20470', 3, 424),
(6781, 'Xã Sông Kôn', '20473', 3, 424),
(6782, 'Xã Jơ Ngây', '20476', 3, 424),
(6783, 'Xã A Ting', '20479', 3, 424),
(6784, 'Xã Tư', '20482', 3, 424),
(6785, 'Xã Ba', '20485', 3, 424),
(6786, 'Xã A Rooi', '20488', 3, 424),
(6787, 'Xã Za Hung', '20491', 3, 424),
(6788, 'Xã Mà Cooi', '20494', 3, 424),
(6789, 'Xã Ka Dăng', '20497', 3, 424);

-- Tỉnh Quảng Nam > Huyện Đại Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6790, 'Thị trấn Ái Nghĩa', '20500', 3, 425),
(6791, 'Xã Đại Sơn', '20503', 3, 425),
(6792, 'Xã Đại Lãnh', '20506', 3, 425),
(6793, 'Xã Đại Hưng', '20509', 3, 425),
(6794, 'Xã Đại Hồng', '20512', 3, 425),
(6795, 'Xã Đại Đồng', '20515', 3, 425),
(6796, 'Xã Đại Quang', '20518', 3, 425),
(6797, 'Xã Đại Nghĩa', '20521', 3, 425),
(6798, 'Xã Đại Hiệp', '20524', 3, 425),
(6799, 'Xã Đại Thạnh', '20527', 3, 425),
(6800, 'Xã Đại Chánh', '20530', 3, 425),
(6801, 'Xã Đại Tân', '20533', 3, 425),
(6802, 'Xã Đại Phong', '20536', 3, 425),
(6803, 'Xã Đại Minh', '20539', 3, 425),
(6804, 'Xã Đại Thắng', '20542', 3, 425),
(6805, 'Xã Đại Cường', '20545', 3, 425),
(6806, 'Xã Đại An', '20547', 3, 425),
(6807, 'Xã Đại Hòa', '20548', 3, 425);

-- Tỉnh Quảng Nam > Thị xã Điện Bàn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6808, 'Phường Vĩnh Điện', '20551', 3, 426),
(6809, 'Xã Điện Tiến', '20554', 3, 426),
(6810, 'Xã Điện Hòa', '20557', 3, 426),
(6811, 'Phường Điện Thắng Bắc', '20560', 3, 426),
(6812, 'Phường Điện Thắng Trung', '20561', 3, 426),
(6813, 'Phường Điện Thắng Nam', '20562', 3, 426),
(6814, 'Phường Điện Ngọc', '20563', 3, 426),
(6815, 'Xã Điện Hồng', '20566', 3, 426),
(6816, 'Xã Điện Thọ', '20569', 3, 426),
(6817, 'Xã Điện Phước', '20572', 3, 426),
(6818, 'Phường Điện An', '20575', 3, 426),
(6819, 'Phường Điện Nam Bắc', '20578', 3, 426),
(6820, 'Phường Điện Nam Trung', '20579', 3, 426),
(6821, 'Phường Điện Nam Đông', '20580', 3, 426),
(6822, 'Phường Điện Dương', '20581', 3, 426),
(6823, 'Xã Điện Quang', '20584', 3, 426),
(6824, 'Xã Điện Trung', '20587', 3, 426),
(6825, 'Xã Điện Phong', '20590', 3, 426),
(6826, 'Phường Điện Minh', '20593', 3, 426),
(6827, 'Phường Điện Phương', '20596', 3, 426);

-- Tỉnh Quảng Nam > Huyện Duy Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6828, 'Thị trấn Nam Phước', '20599', 3, 427),
(6829, 'Xã Duy Phú', '20605', 3, 427),
(6830, 'Xã Duy Tân', '20608', 3, 427),
(6831, 'Xã Duy Hòa', '20611', 3, 427),
(6832, 'Xã Duy Châu', '20614', 3, 427),
(6833, 'Xã Duy Trinh', '20617', 3, 427),
(6834, 'Xã Duy Sơn', '20620', 3, 427),
(6835, 'Xã Duy Trung', '20623', 3, 427),
(6836, 'Xã Duy Phước', '20626', 3, 427),
(6837, 'Xã Duy Thành', '20629', 3, 427),
(6838, 'Xã Duy Vinh', '20632', 3, 427),
(6839, 'Xã Duy Nghĩa', '20635', 3, 427),
(6840, 'Xã Duy Hải', '20638', 3, 427);

-- Tỉnh Quảng Nam > Huyện Quế Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6841, 'Thị trấn Đông Phú', '20641', 3, 428),
(6842, 'Xã Quế Xuân 1', '20644', 3, 428),
(6843, 'Xã Quế Xuân 2', '20647', 3, 428),
(6844, 'Xã Quế Phú', '20650', 3, 428),
(6845, 'Thị trấn Hương An', '20651', 3, 428),
(6846, 'Thị trấn Trung Phước', '20656', 3, 428),
(6847, 'Xã Quế Hiệp', '20659', 3, 428),
(6848, 'Xã Quế Thuận', '20662', 3, 428),
(6849, 'Xã Quế Mỹ', '20665', 3, 428),
(6850, 'Xã Ninh Phước', '20668', 3, 428),
(6851, 'Xã Phước Ninh', '20669', 3, 428),
(6852, 'Xã Quế Lộc', '20671', 3, 428),
(6853, 'Xã Quế Phước', '20674', 3, 428),
(6854, 'Xã Quế Long', '20677', 3, 428),
(6855, 'Xã Quế Châu', '20680', 3, 428),
(6856, 'Xã Quế Phong', '20683', 3, 428),
(6857, 'Xã Quế An', '20686', 3, 428),
(6858, 'Xã Quế Minh', '20689', 3, 428),
(6859, 'Xã Quế Lâm', '20692', 3, 428);

-- Tỉnh Quảng Nam > Huyện Nam Giang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6860, 'Thị trấn Thạnh Mỹ', '20695', 3, 429),
(6861, 'Xã Laêê', '20698', 3, 429),
(6862, 'Xã Chơ Chun', '20699', 3, 429),
(6863, 'Xã Zuôich', '20701', 3, 429),
(6864, 'Xã Tà Pơơ', '20702', 3, 429),
(6865, 'Xã La Dêê', '20704', 3, 429),
(6866, 'Xã Đắc Tôi', '20705', 3, 429),
(6867, 'Xã Chà Vàl', '20707', 3, 429),
(6868, 'Xã Tà Bhinh', '20710', 3, 429),
(6869, 'Xã Cà Dy', '20713', 3, 429),
(6870, 'Xã Đắc Pre', '20716', 3, 429),
(6871, 'Xã Đắc Pring', '20719', 3, 429);

-- Tỉnh Quảng Nam > Huyện Phước Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6872, 'Thị trấn Khâm Đức', '20722', 3, 430),
(6873, 'Xã Phước Xuân', '20725', 3, 430),
(6874, 'Xã Phước Hiệp', '20728', 3, 430),
(6875, 'Xã Phước Hoà', '20729', 3, 430),
(6876, 'Xã Phước Đức', '20731', 3, 430),
(6877, 'Xã Phước Năng', '20734', 3, 430),
(6878, 'Xã Phước Mỹ', '20737', 3, 430),
(6879, 'Xã Phước Chánh', '20740', 3, 430),
(6880, 'Xã Phước Công', '20743', 3, 430),
(6881, 'Xã Phước Kim', '20746', 3, 430),
(6882, 'Xã Phước Lộc', '20749', 3, 430),
(6883, 'Xã Phước Thành', '20752', 3, 430);

-- Tỉnh Quảng Nam > Huyện Hiệp Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6884, 'Xã Quế Tân', '20758', 3, 431),
(6885, 'Xã Quế Thọ', '20764', 3, 431),
(6886, 'Xã Bình Lâm', '20767', 3, 431),
(6887, 'Xã Sông Trà', '20770', 3, 431),
(6888, 'Xã Phước Trà', '20773', 3, 431),
(6889, 'Xã Phước Gia', '20776', 3, 431),
(6890, 'Thị trấn Tân Bình', '20779', 3, 431),
(6891, 'Xã Quế Lưu', '20782', 3, 431),
(6892, 'Xã Thăng Phước', '20785', 3, 431),
(6893, 'Xã Bình Sơn', '20788', 3, 431);

-- Tỉnh Quảng Nam > Huyện Thăng Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6894, 'Thị trấn Hà Lam', '20791', 3, 432),
(6895, 'Xã Bình Dương', '20794', 3, 432),
(6896, 'Xã Bình Giang', '20797', 3, 432),
(6897, 'Xã Bình Nguyên', '20800', 3, 432),
(6898, 'Xã Bình Phục', '20803', 3, 432),
(6899, 'Xã Bình Triều', '20806', 3, 432),
(6900, 'Xã Bình Đào', '20809', 3, 432),
(6901, 'Xã Bình Minh', '20812', 3, 432),
(6902, 'Xã Bình Lãnh', '20815', 3, 432),
(6903, 'Xã Bình Trị', '20818', 3, 432),
(6904, 'Xã Bình Định', '20821', 3, 432),
(6905, 'Xã Bình Quý', '20824', 3, 432),
(6906, 'Xã Bình Phú', '20827', 3, 432),
(6907, 'Xã Bình Tú', '20833', 3, 432),
(6908, 'Xã Bình Sa', '20836', 3, 432),
(6909, 'Xã Bình Hải', '20839', 3, 432),
(6910, 'Xã Bình Quế', '20842', 3, 432),
(6911, 'Xã Bình An', '20845', 3, 432),
(6912, 'Xã Bình Trung', '20848', 3, 432),
(6913, 'Xã Bình Nam', '20851', 3, 432);

-- Tỉnh Quảng Nam > Huyện Tiên Phước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6914, 'Thị trấn Tiên Kỳ', '20854', 3, 433),
(6915, 'Xã Tiên Sơn', '20857', 3, 433),
(6916, 'Xã Tiên Hà', '20860', 3, 433),
(6917, 'Xã Tiên Châu', '20866', 3, 433),
(6918, 'Xã Tiên Lãnh', '20869', 3, 433),
(6919, 'Xã Tiên Ngọc', '20872', 3, 433),
(6920, 'Xã Tiên Hiệp', '20875', 3, 433),
(6921, 'Xã Tiên Cảnh', '20878', 3, 433),
(6922, 'Xã Tiên Mỹ', '20881', 3, 433),
(6923, 'Xã Tiên Phong', '20884', 3, 433),
(6924, 'Xã Tiên Thọ', '20887', 3, 433),
(6925, 'Xã Tiên An', '20890', 3, 433),
(6926, 'Xã Tiên Lộc', '20893', 3, 433),
(6927, 'Xã Tiên Lập', '20896', 3, 433);

-- Tỉnh Quảng Nam > Huyện Bắc Trà My
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6928, 'Thị trấn Trà My', '20899', 3, 434),
(6929, 'Xã Trà Sơn', '20900', 3, 434),
(6930, 'Xã Trà Kót', '20902', 3, 434),
(6931, 'Xã Trà Nú', '20905', 3, 434),
(6932, 'Xã Trà Đông', '20908', 3, 434),
(6933, 'Xã Trà Dương', '20911', 3, 434),
(6934, 'Xã Trà Giang', '20914', 3, 434),
(6935, 'Xã Trà Bui', '20917', 3, 434),
(6936, 'Xã Trà Đốc', '20920', 3, 434),
(6937, 'Xã Trà Tân', '20923', 3, 434),
(6938, 'Xã Trà Giác', '20926', 3, 434),
(6939, 'Xã Trà Giáp', '20929', 3, 434),
(6940, 'Xã Trà Ka', '20932', 3, 434);

-- Tỉnh Quảng Nam > Huyện Nam Trà My
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6941, 'Xã Trà Leng', '20935', 3, 435),
(6942, 'Xã Trà Dơn', '20938', 3, 435),
(6943, 'Xã Trà Tập', '20941', 3, 435),
(6944, 'Xã Trà Mai', '20944', 3, 435),
(6945, 'Xã Trà Cang', '20947', 3, 435),
(6946, 'Xã Trà Linh', '20950', 3, 435),
(6947, 'Xã Trà Nam', '20953', 3, 435),
(6948, 'Xã Trà Don', '20956', 3, 435),
(6949, 'Xã Trà Vân', '20959', 3, 435),
(6950, 'Xã Trà Vinh', '20962', 3, 435);

-- Tỉnh Quảng Nam > Huyện Núi Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6951, 'Thị trấn Núi Thành', '20965', 3, 436),
(6952, 'Xã Tam Xuân I', '20968', 3, 436),
(6953, 'Xã Tam Xuân II', '20971', 3, 436),
(6954, 'Xã Tam Tiến', '20974', 3, 436),
(6955, 'Xã Tam Sơn', '20977', 3, 436),
(6956, 'Xã Tam Thạnh', '20980', 3, 436),
(6957, 'Xã Tam Anh Bắc', '20983', 3, 436),
(6958, 'Xã Tam Anh Nam', '20984', 3, 436),
(6959, 'Xã Tam Hòa', '20986', 3, 436),
(6960, 'Xã Tam Hiệp', '20989', 3, 436),
(6961, 'Xã Tam Hải', '20992', 3, 436),
(6962, 'Xã Tam Giang', '20995', 3, 436),
(6963, 'Xã Tam Quang', '20998', 3, 436),
(6964, 'Xã Tam Nghĩa', '21001', 3, 436),
(6965, 'Xã Tam Mỹ Tây', '21004', 3, 436),
(6966, 'Xã Tam Mỹ Đông', '21005', 3, 436),
(6967, 'Xã Tam Trà', '21007', 3, 436);

-- Tỉnh Quảng Nam > Huyện Phú Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6968, 'Thị trấn Phú Thịnh', '20364', 3, 437),
(6969, 'Xã Tam Thành', '20365', 3, 437),
(6970, 'Xã Tam An', '20368', 3, 437),
(6971, 'Xã Tam Đàn', '20374', 3, 437),
(6972, 'Xã Tam Lộc', '20377', 3, 437),
(6973, 'Xã Tam Phước', '20380', 3, 437),
(6974, 'Xã Tam Thái', '20386', 3, 437),
(6975, 'Xã Tam Đại', '20387', 3, 437),
(6976, 'Xã Tam Dân', '20392', 3, 437),
(6977, 'Xã Tam Lãnh', '20395', 3, 437);

-- Tỉnh Quảng Ngãi > Thành phố Quảng Ngãi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(6978, 'Phường Lê Hồng Phong', '21010', 3, 438),
(6979, 'Phường Trần Phú', '21013', 3, 438),
(6980, 'Phường Quảng Phú', '21016', 3, 438),
(6981, 'Phường Nghĩa Chánh', '21019', 3, 438),
(6982, 'Phường Trần Hưng Đạo', '21022', 3, 438),
(6983, 'Phường Nguyễn Nghiêm', '21025', 3, 438),
(6984, 'Phường Nghĩa Lộ', '21028', 3, 438),
(6985, 'Phường Chánh Lộ', '21031', 3, 438),
(6986, 'Xã Nghĩa Dũng', '21034', 3, 438),
(6987, 'Xã Nghĩa Dõng', '21037', 3, 438),
(6988, 'Phường Trương Quang Trọng', '21172', 3, 438),
(6989, 'Xã Tịnh Hòa', '21187', 3, 438),
(6990, 'Xã Tịnh Kỳ', '21190', 3, 438),
(6991, 'Xã Tịnh Thiện', '21199', 3, 438),
(6992, 'Xã Tịnh Ấn Đông', '21202', 3, 438),
(6993, 'Xã Tịnh Châu', '21208', 3, 438),
(6994, 'Xã Tịnh Khê', '21211', 3, 438),
(6995, 'Xã Tịnh Long', '21214', 3, 438),
(6996, 'Xã Tịnh Ấn Tây', '21223', 3, 438),
(6997, 'Xã Tịnh An', '21232', 3, 438),
(6998, 'Xã Nghĩa Hà', '21256', 3, 438),
(6999, 'Xã An Phú', '21262', 3, 438);

-- Tỉnh Quảng Ngãi > Huyện Bình Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7000, 'Thị trấn Châu Ổ', '21040', 3, 439),
(7001, 'Xã Bình Thuận', '21043', 3, 439),
(7002, 'Xã Bình Thạnh', '21046', 3, 439),
(7003, 'Xã Bình Đông', '21049', 3, 439),
(7004, 'Xã Bình Chánh', '21052', 3, 439),
(7005, 'Xã Bình Nguyên', '21055', 3, 439),
(7006, 'Xã Bình Khương', '21058', 3, 439),
(7007, 'Xã Bình Trị', '21061', 3, 439),
(7008, 'Xã Bình An', '21064', 3, 439),
(7009, 'Xã Bình Hải', '21067', 3, 439),
(7010, 'Xã Bình Dương', '21070', 3, 439),
(7011, 'Xã Bình Phước', '21073', 3, 439),
(7012, 'Xã Bình Hòa', '21079', 3, 439),
(7013, 'Xã Bình Trung', '21082', 3, 439),
(7014, 'Xã Bình Minh', '21085', 3, 439),
(7015, 'Xã Bình Long', '21088', 3, 439),
(7016, 'Xã Bình Thanh', '21091', 3, 439),
(7017, 'Xã Bình Chương', '21100', 3, 439),
(7018, 'Xã Bình Hiệp', '21103', 3, 439),
(7019, 'Xã Bình Mỹ', '21106', 3, 439),
(7020, 'Xã Bình Tân Phú', '21109', 3, 439),
(7021, 'Xã Bình Châu', '21112', 3, 439);

-- Tỉnh Quảng Ngãi > Huyện Trà Bồng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7022, 'Thị trấn Trà Xuân', '21115', 3, 440),
(7023, 'Xã Trà Giang', '21118', 3, 440),
(7024, 'Xã Trà Thủy', '21121', 3, 440),
(7025, 'Xã Trà Hiệp', '21124', 3, 440),
(7026, 'Xã Trà Bình', '21127', 3, 440),
(7027, 'Xã Trà Phú', '21130', 3, 440),
(7028, 'Xã Trà Lâm', '21133', 3, 440),
(7029, 'Xã Trà Tân', '21136', 3, 440),
(7030, 'Xã Trà Sơn', '21139', 3, 440),
(7031, 'Xã Trà Bùi', '21142', 3, 440),
(7032, 'Xã Trà Thanh', '21145', 3, 440),
(7033, 'Xã Sơn Trà', '21148', 3, 440),
(7034, 'Xã Trà Phong', '21154', 3, 440),
(7035, 'Xã Hương Trà', '21157', 3, 440),
(7036, 'Xã Trà Xinh', '21163', 3, 440),
(7037, 'Xã Trà Tây', '21166', 3, 440);

-- Tỉnh Quảng Ngãi > Huyện Sơn Tịnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7038, 'Xã Tịnh Thọ', '21175', 3, 441),
(7039, 'Xã Tịnh Trà', '21178', 3, 441),
(7040, 'Xã Tịnh Phong', '21181', 3, 441),
(7041, 'Xã Tịnh Hiệp', '21184', 3, 441),
(7042, 'Xã Tịnh Bình', '21193', 3, 441),
(7043, 'Xã Tịnh Đông', '21196', 3, 441),
(7044, 'Xã Tịnh Bắc', '21205', 3, 441),
(7045, 'Xã Tịnh Sơn', '21217', 3, 441),
(7046, 'Thị trấn Tịnh Hà', '21220', 3, 441),
(7047, 'Xã Tịnh Giang', '21226', 3, 441),
(7048, 'Xã Tịnh Minh', '21229', 3, 441);

-- Tỉnh Quảng Ngãi > Huyện Tư Nghĩa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7049, 'Thị trấn La Hà', '21235', 3, 442),
(7050, 'Thị trấn Sông Vệ', '21238', 3, 442),
(7051, 'Xã Nghĩa Lâm', '21241', 3, 442),
(7052, 'Xã Nghĩa Thắng', '21244', 3, 442),
(7053, 'Xã Nghĩa Thuận', '21247', 3, 442),
(7054, 'Xã Nghĩa Kỳ', '21250', 3, 442),
(7055, 'Xã Nghĩa Sơn', '21259', 3, 442),
(7056, 'Xã Nghĩa Hòa', '21268', 3, 442),
(7057, 'Xã Nghĩa Điền', '21271', 3, 442),
(7058, 'Xã Nghĩa Thương', '21274', 3, 442),
(7059, 'Xã Nghĩa Trung', '21277', 3, 442),
(7060, 'Xã Nghĩa Hiệp', '21280', 3, 442),
(7061, 'Xã Nghĩa Phương', '21283', 3, 442);

-- Tỉnh Quảng Ngãi > Huyện Sơn Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7062, 'Thị trấn Di Lăng', '21289', 3, 443),
(7063, 'Xã Sơn Hạ', '21292', 3, 443),
(7064, 'Xã Sơn Thành', '21295', 3, 443),
(7065, 'Xã Sơn Nham', '21298', 3, 443),
(7066, 'Xã Sơn Bao', '21301', 3, 443),
(7067, 'Xã Sơn Linh', '21304', 3, 443),
(7068, 'Xã Sơn Giang', '21307', 3, 443),
(7069, 'Xã Sơn Trung', '21310', 3, 443),
(7070, 'Xã Sơn Thượng', '21313', 3, 443),
(7071, 'Xã Sơn Cao', '21316', 3, 443),
(7072, 'Xã Sơn Hải', '21319', 3, 443),
(7073, 'Xã Sơn Thủy', '21322', 3, 443),
(7074, 'Xã Sơn Kỳ', '21325', 3, 443),
(7075, 'Xã Sơn Ba', '21328', 3, 443);

-- Tỉnh Quảng Ngãi > Huyện Sơn Tây
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7076, 'Xã Sơn Bua', '21331', 3, 444),
(7077, 'Xã Sơn Mùa', '21334', 3, 444),
(7078, 'Xã Sơn Liên', '21335', 3, 444),
(7079, 'Xã Sơn Tân', '21337', 3, 444),
(7080, 'Xã Sơn Màu', '21338', 3, 444),
(7081, 'Xã Sơn Dung', '21340', 3, 444),
(7082, 'Xã Sơn Long', '21341', 3, 444),
(7083, 'Xã Sơn Tinh', '21343', 3, 444),
(7084, 'Xã Sơn Lập', '21346', 3, 444);

-- Tỉnh Quảng Ngãi > Huyện Minh Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7085, 'Xã Long Sơn', '21349', 3, 445),
(7086, 'Xã Long Mai', '21352', 3, 445),
(7087, 'Xã Thanh An', '21355', 3, 445),
(7088, 'Xã Long Môn', '21358', 3, 445),
(7089, 'Xã Long Hiệp', '21361', 3, 445);

-- Tỉnh Quảng Ngãi > Huyện Nghĩa Hành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7090, 'Thị trấn Chợ Chùa', '21364', 3, 446),
(7091, 'Xã Hành Thuận', '21367', 3, 446),
(7092, 'Xã Hành Dũng', '21370', 3, 446),
(7093, 'Xã Hành Trung', '21373', 3, 446),
(7094, 'Xã Hành Nhân', '21376', 3, 446),
(7095, 'Xã Hành Đức', '21379', 3, 446),
(7096, 'Xã Hành Minh', '21382', 3, 446),
(7097, 'Xã Hành Phước', '21385', 3, 446),
(7098, 'Xã Hành Thiện', '21388', 3, 446),
(7099, 'Xã Hành Thịnh', '21391', 3, 446),
(7100, 'Xã Hành Tín Tây', '21394', 3, 446),
(7101, 'Xã Hành Tín Đông', '21397', 3, 446);

-- Tỉnh Quảng Ngãi > Huyện Mộ Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7102, 'Thị trấn Mộ Đức', '21400', 3, 447),
(7103, 'Xã Thắng Lợi', '21406', 3, 447),
(7104, 'Xã Đức Nhuận', '21409', 3, 447),
(7105, 'Xã Đức Chánh', '21412', 3, 447),
(7106, 'Xã Đức Hiệp', '21415', 3, 447),
(7107, 'Xã Đức Minh', '21418', 3, 447),
(7108, 'Xã Đức Thạnh', '21421', 3, 447),
(7109, 'Xã Đức Hòa', '21424', 3, 447),
(7110, 'Xã Đức Tân', '21427', 3, 447),
(7111, 'Xã Đức Phú', '21430', 3, 447),
(7112, 'Xã Đức Phong', '21433', 3, 447),
(7113, 'Xã Đức Lân', '21436', 3, 447);

-- Tỉnh Quảng Ngãi > Thị xã Đức Phổ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7114, 'Phường Nguyễn Nghiêm', '21439', 3, 448),
(7115, 'Xã Phổ An', '21442', 3, 448),
(7116, 'Xã Phổ Phong', '21445', 3, 448),
(7117, 'Xã Phổ Thuận', '21448', 3, 448),
(7118, 'Phường Phổ Văn', '21451', 3, 448),
(7119, 'Phường Phổ Quang', '21454', 3, 448),
(7120, 'Xã Phổ Nhơn', '21457', 3, 448),
(7121, 'Phường Phổ Ninh', '21460', 3, 448),
(7122, 'Phường Phổ Minh', '21463', 3, 448),
(7123, 'Phường Phổ Vinh', '21466', 3, 448),
(7124, 'Phường Phổ Hòa', '21469', 3, 448),
(7125, 'Xã Phổ Cường', '21472', 3, 448),
(7126, 'Xã Phổ Khánh', '21475', 3, 448),
(7127, 'Phường Phổ Thạnh', '21478', 3, 448),
(7128, 'Xã Phổ Châu', '21481', 3, 448);

-- Tỉnh Quảng Ngãi > Huyện Ba Tơ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7129, 'Thị trấn Ba Tơ', '21484', 3, 449),
(7130, 'Xã Ba Điền', '21487', 3, 449),
(7131, 'Xã Ba Vinh', '21490', 3, 449),
(7132, 'Xã Ba Thành', '21493', 3, 449),
(7133, 'Xã Ba Động', '21496', 3, 449),
(7134, 'Xã Ba Dinh', '21499', 3, 449),
(7135, 'Xã Ba Giang', '21500', 3, 449),
(7136, 'Xã Ba Liên', '21502', 3, 449),
(7137, 'Xã Ba Ngạc', '21505', 3, 449),
(7138, 'Xã Ba Khâm', '21508', 3, 449),
(7139, 'Xã Ba Cung', '21511', 3, 449),
(7140, 'Xã Ba Tiêu', '21517', 3, 449),
(7141, 'Xã Ba Trang', '21520', 3, 449),
(7142, 'Xã Ba Tô', '21523', 3, 449),
(7143, 'Xã Ba Bích', '21526', 3, 449),
(7144, 'Xã Ba Vì', '21529', 3, 449),
(7145, 'Xã Ba Lế', '21532', 3, 449),
(7146, 'Xã Ba Nam', '21535', 3, 449),
(7147, 'Xã Ba Xa', '21538', 3, 449);

-- Tỉnh Bình Định > Thành phố Quy Nhơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7148, 'Phường Nhơn Bình', '21550', 3, 451),
(7149, 'Phường Nhơn Phú', '21553', 3, 451),
(7150, 'Phường Đống Đa', '21556', 3, 451),
(7151, 'Phường Trần Quang Diệu', '21559', 3, 451),
(7152, 'Phường Hải Cảng', '21562', 3, 451),
(7153, 'Phường Quang Trung', '21565', 3, 451),
(7154, 'Phường Ngô Mây', '21577', 3, 451),
(7155, 'Phường Trần Phú', '21580', 3, 451),
(7156, 'Phường Thị Nại', '21583', 3, 451),
(7157, 'Phường Bùi Thị Xuân', '21589', 3, 451),
(7158, 'Phường Nguyễn Văn Cừ', '21592', 3, 451),
(7159, 'Phường Ghềnh Ráng', '21595', 3, 451),
(7160, 'Xã Nhơn Lý', '21598', 3, 451),
(7161, 'Xã Nhơn Hội', '21601', 3, 451),
(7162, 'Xã Nhơn Hải', '21604', 3, 451),
(7163, 'Xã Nhơn Châu', '21607', 3, 451),
(7164, 'Xã Phước Mỹ', '21991', 3, 451);

-- Tỉnh Bình Định > Huyện An Lão
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7165, 'Thị trấn An Lão', '21609', 3, 452),
(7166, 'Xã An Hưng', '21610', 3, 452),
(7167, 'Xã An Trung', '21613', 3, 452),
(7168, 'Xã An Dũng', '21616', 3, 452),
(7169, 'Xã An Vinh', '21619', 3, 452),
(7170, 'Xã An Toàn', '21622', 3, 452),
(7171, 'Xã An Tân', '21625', 3, 452),
(7172, 'Xã An Hòa', '21628', 3, 452),
(7173, 'Xã An Quang', '21631', 3, 452),
(7174, 'Xã An Nghĩa', '21634', 3, 452);

-- Tỉnh Bình Định > Thị xã Hoài Nhơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7175, 'Phường Tam Quan', '21637', 3, 453),
(7176, 'Phường Bồng Sơn', '21640', 3, 453),
(7177, 'Xã Hoài Sơn', '21643', 3, 453),
(7178, 'Xã Hoài Châu Bắc', '21646', 3, 453),
(7179, 'Xã Hoài Châu', '21649', 3, 453),
(7180, 'Xã Hoài Phú', '21652', 3, 453),
(7181, 'Phường Tam Quan Bắc', '21655', 3, 453),
(7182, 'Phường Tam Quan Nam', '21658', 3, 453),
(7183, 'Phường Hoài Hảo', '21661', 3, 453),
(7184, 'Phường Hoài Thanh Tây', '21664', 3, 453),
(7185, 'Phường Hoài Thanh', '21667', 3, 453),
(7186, 'Phường Hoài Hương', '21670', 3, 453),
(7187, 'Phường Hoài Tân', '21673', 3, 453),
(7188, 'Xã Hoài Hải', '21676', 3, 453),
(7189, 'Phường Hoài Xuân', '21679', 3, 453),
(7190, 'Xã Hoài Mỹ', '21682', 3, 453),
(7191, 'Phường Hoài Đức', '21685', 3, 453);

-- Tỉnh Bình Định > Huyện Hoài Ân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7192, 'Thị trấn Tăng Bạt Hổ', '21688', 3, 454),
(7193, 'Xã Ân Hảo Tây', '21690', 3, 454),
(7194, 'Xã Ân Hảo Đông', '21691', 3, 454),
(7195, 'Xã Ân Sơn', '21694', 3, 454),
(7196, 'Xã Ân Mỹ', '21697', 3, 454),
(7197, 'Xã Đak Mang', '21700', 3, 454),
(7198, 'Xã Ân Tín', '21703', 3, 454),
(7199, 'Xã Ân Thạnh', '21706', 3, 454),
(7200, 'Xã Ân Phong', '21709', 3, 454),
(7201, 'Xã Ân Đức', '21712', 3, 454),
(7202, 'Xã Ân Hữu', '21715', 3, 454),
(7203, 'Xã Bok Tới', '21718', 3, 454),
(7204, 'Xã Ân Tường Tây', '21721', 3, 454),
(7205, 'Xã Ân Tường Đông', '21724', 3, 454),
(7206, 'Xã Ân Nghĩa', '21727', 3, 454);

-- Tỉnh Bình Định > Huyện Phù Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7207, 'Thị trấn Phù Mỹ', '21730', 3, 455),
(7208, 'Thị trấn Bình Dương', '21733', 3, 455),
(7209, 'Xã Mỹ Đức', '21736', 3, 455),
(7210, 'Xã Mỹ Châu', '21739', 3, 455),
(7211, 'Xã Mỹ Thắng', '21742', 3, 455),
(7212, 'Xã Mỹ Lộc', '21745', 3, 455),
(7213, 'Xã Mỹ Lợi', '21748', 3, 455),
(7214, 'Xã Mỹ An', '21751', 3, 455),
(7215, 'Xã Mỹ Phong', '21754', 3, 455),
(7216, 'Xã Mỹ Trinh', '21757', 3, 455),
(7217, 'Xã Mỹ Thọ', '21760', 3, 455),
(7218, 'Xã Mỹ Hòa', '21763', 3, 455),
(7219, 'Xã Mỹ Thành', '21766', 3, 455),
(7220, 'Xã Mỹ Chánh', '21769', 3, 455),
(7221, 'Xã Mỹ Quang', '21772', 3, 455),
(7222, 'Xã Mỹ Hiệp', '21775', 3, 455),
(7223, 'Xã Mỹ Tài', '21778', 3, 455),
(7224, 'Xã Mỹ Cát', '21781', 3, 455),
(7225, 'Xã Mỹ Chánh Tây', '21784', 3, 455);

-- Tỉnh Bình Định > Huyện Vĩnh Thạnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7226, 'Thị trấn Vĩnh Thạnh', '21786', 3, 456),
(7227, 'Xã Vĩnh Sơn', '21787', 3, 456),
(7228, 'Xã Vĩnh Kim', '21790', 3, 456),
(7229, 'Xã Vĩnh Hiệp', '21796', 3, 456),
(7230, 'Xã Vĩnh Hảo', '21799', 3, 456),
(7231, 'Xã Vĩnh Hòa', '21801', 3, 456),
(7232, 'Xã Vĩnh Thịnh', '21802', 3, 456),
(7233, 'Xã Vĩnh Thuận', '21804', 3, 456),
(7234, 'Xã Vĩnh Quang', '21805', 3, 456);

-- Tỉnh Bình Định > Huyện Tây Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7235, 'Thị trấn Phú Phong', '21808', 3, 457),
(7236, 'Xã Bình Tân', '21811', 3, 457),
(7237, 'Xã Tây Thuận', '21814', 3, 457),
(7238, 'Xã Bình Thuận', '21817', 3, 457),
(7239, 'Xã Tây Giang', '21820', 3, 457),
(7240, 'Xã Bình Thành', '21823', 3, 457),
(7241, 'Xã Tây An', '21826', 3, 457),
(7242, 'Xã Bình Hòa', '21829', 3, 457),
(7243, 'Xã Tây Bình', '21832', 3, 457),
(7244, 'Xã Bình Tường', '21835', 3, 457),
(7245, 'Xã Tây Vinh', '21838', 3, 457),
(7246, 'Xã Vĩnh An', '21841', 3, 457),
(7247, 'Xã Tây Xuân', '21844', 3, 457),
(7248, 'Xã Bình Nghi', '21847', 3, 457),
(7249, 'Xã Tây Phú', '21850', 3, 457);

-- Tỉnh Bình Định > Huyện Phù Cát
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7250, 'Thị trấn Ngô Mây', '21853', 3, 458),
(7251, 'Xã Cát Sơn', '21856', 3, 458),
(7252, 'Xã Cát Minh', '21859', 3, 458),
(7253, 'Thị trấn Cát Khánh', '21862', 3, 458),
(7254, 'Xã Cát Tài', '21865', 3, 458),
(7255, 'Xã Cát Lâm', '21868', 3, 458),
(7256, 'Xã Cát Hanh', '21871', 3, 458),
(7257, 'Xã Cát Thành', '21874', 3, 458),
(7258, 'Xã Cát Trinh', '21877', 3, 458),
(7259, 'Xã Cát Hải', '21880', 3, 458),
(7260, 'Xã Cát Hiệp', '21883', 3, 458),
(7261, 'Xã Cát Nhơn', '21886', 3, 458),
(7262, 'Xã Cát Hưng', '21889', 3, 458),
(7263, 'Xã Cát Tường', '21892', 3, 458),
(7264, 'Xã Cát Tân', '21895', 3, 458),
(7265, 'Thị trấn Cát Tiến', '21898', 3, 458),
(7266, 'Xã Cát Thắng', '21901', 3, 458),
(7267, 'Xã Cát Chánh', '21904', 3, 458);

-- Tỉnh Bình Định > Thị xã An Nhơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7268, 'Phường Bình Định', '21907', 3, 459),
(7269, 'Phường Đập Đá', '21910', 3, 459),
(7270, 'Xã Nhơn Mỹ', '21913', 3, 459),
(7271, 'Phường Nhơn Thành', '21916', 3, 459),
(7272, 'Xã Nhơn Hạnh', '21919', 3, 459),
(7273, 'Xã Nhơn Hậu', '21922', 3, 459),
(7274, 'Xã Nhơn Phong', '21925', 3, 459),
(7275, 'Xã Nhơn An', '21928', 3, 459),
(7276, 'Xã Nhơn Phúc', '21931', 3, 459),
(7277, 'Phường Nhơn Hưng', '21934', 3, 459),
(7278, 'Xã Nhơn Khánh', '21937', 3, 459),
(7279, 'Xã Nhơn Lộc', '21940', 3, 459),
(7280, 'Phường Nhơn Hoà', '21943', 3, 459),
(7281, 'Xã Nhơn Tân', '21946', 3, 459),
(7282, 'Xã Nhơn Thọ', '21949', 3, 459);

-- Tỉnh Bình Định > Huyện Tuy Phước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7283, 'Thị trấn Tuy Phước', '21952', 3, 460),
(7284, 'Thị trấn Diêu Trì', '21955', 3, 460),
(7285, 'Xã Phước Thắng', '21958', 3, 460),
(7286, 'Xã Phước Hưng', '21961', 3, 460),
(7287, 'Xã Phước Quang', '21964', 3, 460),
(7288, 'Xã Phước Hòa', '21967', 3, 460),
(7289, 'Xã Phước Sơn', '21970', 3, 460),
(7290, 'Xã Phước Hiệp', '21973', 3, 460),
(7291, 'Xã Phước Lộc', '21976', 3, 460),
(7292, 'Xã Phước Nghĩa', '21979', 3, 460),
(7293, 'Xã Phước Thuận', '21982', 3, 460),
(7294, 'Xã Phước An', '21985', 3, 460),
(7295, 'Xã Phước Thành', '21988', 3, 460);

-- Tỉnh Bình Định > Huyện Vân Canh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7296, 'Thị trấn Vân Canh', '21994', 3, 461),
(7297, 'Xã Canh Liên', '21997', 3, 461),
(7298, 'Xã Canh Hiệp', '22000', 3, 461),
(7299, 'Xã Canh Vinh', '22003', 3, 461),
(7300, 'Xã Canh Hiển', '22006', 3, 461),
(7301, 'Xã Canh Thuận', '22009', 3, 461),
(7302, 'Xã Canh Hòa', '22012', 3, 461);

-- Tỉnh Phú Yên > Thành phố Tuy Hoà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7303, 'Phường 1', '22015', 3, 462),
(7304, 'Phường 2', '22018', 3, 462),
(7305, 'Phường 9', '22024', 3, 462),
(7306, 'Phường 4', '22030', 3, 462),
(7307, 'Phường 5', '22033', 3, 462),
(7308, 'Phường 7', '22036', 3, 462),
(7309, 'Phường Phú Thạnh', '22040', 3, 462),
(7310, 'Phường Phú Đông', '22041', 3, 462),
(7311, 'Xã Hòa Kiến', '22042', 3, 462),
(7312, 'Xã Bình Kiến', '22045', 3, 462),
(7313, 'Xã An Phú', '22162', 3, 462),
(7314, 'Phường Phú Lâm', '22240', 3, 462);

-- Tỉnh Phú Yên > Thị xã Sông Cầu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7315, 'Phường Xuân Phú', '22051', 3, 463),
(7316, 'Xã Xuân Lâm', '22052', 3, 463),
(7317, 'Phường Xuân Thành', '22053', 3, 463),
(7318, 'Xã Xuân Hải', '22054', 3, 463),
(7319, 'Xã Xuân Lộc', '22057', 3, 463),
(7320, 'Xã Xuân Bình', '22060', 3, 463),
(7321, 'Xã Xuân Cảnh', '22066', 3, 463),
(7322, 'Xã Xuân Thịnh', '22069', 3, 463),
(7323, 'Xã Xuân Phương', '22072', 3, 463),
(7324, 'Phường Xuân Yên', '22073', 3, 463),
(7325, 'Xã Xuân Thọ 1', '22075', 3, 463),
(7326, 'Phường Xuân Đài', '22076', 3, 463),
(7327, 'Xã Xuân Thọ 2', '22078', 3, 463);

-- Tỉnh Phú Yên > Huyện Đồng Xuân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7328, 'Thị trấn La Hai', '22081', 3, 464),
(7329, 'Xã Đa Lộc', '22084', 3, 464),
(7330, 'Xã Phú Mỡ', '22087', 3, 464),
(7331, 'Xã Xuân Lãnh', '22090', 3, 464),
(7332, 'Xã Xuân Long', '22093', 3, 464),
(7333, 'Xã Xuân Quang 1', '22096', 3, 464),
(7334, 'Xã Xuân Sơn Bắc', '22099', 3, 464),
(7335, 'Xã Xuân Quang 2', '22102', 3, 464),
(7336, 'Xã Xuân Sơn Nam', '22105', 3, 464),
(7337, 'Xã Xuân Quang 3', '22108', 3, 464),
(7338, 'Xã Xuân Phước', '22111', 3, 464);

-- Tỉnh Phú Yên > Huyện Tuy An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7339, 'Thị trấn Chí Thạnh', '22114', 3, 465),
(7340, 'Xã An Dân', '22117', 3, 465),
(7341, 'Xã An Ninh Tây', '22120', 3, 465),
(7342, 'Xã An Ninh Đông', '22123', 3, 465),
(7343, 'Xã An Thạch', '22126', 3, 465),
(7344, 'Xã An Định', '22129', 3, 465),
(7345, 'Xã An Nghiệp', '22132', 3, 465),
(7346, 'Xã An Cư', '22138', 3, 465),
(7347, 'Xã An Xuân', '22141', 3, 465),
(7348, 'Xã An Lĩnh', '22144', 3, 465),
(7349, 'Xã An Hòa Hải', '22147', 3, 465),
(7350, 'Xã An Hiệp', '22150', 3, 465),
(7351, 'Xã An Mỹ', '22153', 3, 465),
(7352, 'Xã An Chấn', '22156', 3, 465),
(7353, 'Xã An Thọ', '22159', 3, 465);

-- Tỉnh Phú Yên > Huyện Sơn Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7354, 'Thị trấn Củng Sơn', '22165', 3, 466),
(7355, 'Xã Phước Tân', '22168', 3, 466),
(7356, 'Xã Sơn Hội', '22171', 3, 466),
(7357, 'Xã Sơn Định', '22174', 3, 466),
(7358, 'Xã Sơn Long', '22177', 3, 466),
(7359, 'Xã Cà Lúi', '22180', 3, 466),
(7360, 'Xã Sơn Phước', '22183', 3, 466),
(7361, 'Xã Sơn Xuân', '22186', 3, 466),
(7362, 'Xã Sơn Nguyên', '22189', 3, 466),
(7363, 'Xã Eachà Rang', '22192', 3, 466),
(7364, 'Xã Krông Pa', '22195', 3, 466),
(7365, 'Xã Suối Bạc', '22198', 3, 466),
(7366, 'Xã Sơn Hà', '22201', 3, 466),
(7367, 'Xã Suối Trai', '22204', 3, 466);

-- Tỉnh Phú Yên > Huyện Sông Hinh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7368, 'Thị trấn Hai Riêng', '22207', 3, 467),
(7369, 'Xã Ea Lâm', '22210', 3, 467),
(7370, 'Xã Đức Bình Tây', '22213', 3, 467),
(7371, 'Xã Ea Bá', '22216', 3, 467),
(7372, 'Xã Sơn Giang', '22219', 3, 467),
(7373, 'Xã Đức Bình Đông', '22222', 3, 467),
(7374, 'Xã EaBar', '22225', 3, 467),
(7375, 'Xã EaBia', '22228', 3, 467),
(7376, 'Xã EaTrol', '22231', 3, 467),
(7377, 'Xã Sông Hinh', '22234', 3, 467),
(7378, 'Xã Ealy', '22237', 3, 467);

-- Tỉnh Phú Yên > Huyện Tây Hoà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7379, 'Xã Sơn Thành Tây', '22249', 3, 468),
(7380, 'Xã Sơn Thành Đông', '22250', 3, 468),
(7381, 'Xã Hòa Bình 1', '22252', 3, 468),
(7382, 'Thị trấn Phú Thứ', '22255', 3, 468),
(7383, 'Xã Hòa Phong', '22264', 3, 468),
(7384, 'Xã Hòa Phú', '22270', 3, 468),
(7385, 'Xã Hòa Tân Tây', '22273', 3, 468),
(7386, 'Xã Hòa Đồng', '22276', 3, 468),
(7387, 'Xã Hòa Mỹ Đông', '22285', 3, 468),
(7388, 'Xã Hòa Mỹ Tây', '22288', 3, 468),
(7389, 'Xã Hòa Thịnh', '22294', 3, 468);

-- Tỉnh Phú Yên > Huyện Phú Hoà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7390, 'Xã Hòa Quang Bắc', '22303', 3, 469),
(7391, 'Xã Hòa Quang Nam', '22306', 3, 469),
(7392, 'Xã Hòa Hội', '22309', 3, 469),
(7393, 'Xã Hòa Trị', '22312', 3, 469),
(7394, 'Xã Hòa An', '22315', 3, 469),
(7395, 'Xã Hòa Định Đông', '22318', 3, 469),
(7396, 'Thị trấn Phú Hoà', '22319', 3, 469),
(7397, 'Xã Hòa Định Tây', '22321', 3, 469),
(7398, 'Xã Hòa Thắng', '22324', 3, 469);

-- Tỉnh Phú Yên > Thị xã Đông Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7399, 'Xã Hòa Thành', '22243', 3, 470),
(7400, 'Phường Hòa Hiệp Bắc', '22246', 3, 470),
(7401, 'Phường Hoà Vinh', '22258', 3, 470),
(7402, 'Phường Hoà Hiệp Trung', '22261', 3, 470),
(7403, 'Xã Hòa Tân Đông', '22267', 3, 470),
(7404, 'Phường Hòa Xuân Tây', '22279', 3, 470),
(7405, 'Phường Hòa Hiệp Nam', '22282', 3, 470),
(7406, 'Xã Hòa Xuân Đông', '22291', 3, 470),
(7407, 'Xã Hòa Tâm', '22297', 3, 470),
(7408, 'Xã Hòa Xuân Nam', '22300', 3, 470);

-- Tỉnh Khánh Hòa > Thành phố Nha Trang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7409, 'Phường Vĩnh Hòa', '22327', 3, 471),
(7410, 'Phường Vĩnh Hải', '22330', 3, 471),
(7411, 'Phường Vĩnh Phước', '22333', 3, 471),
(7412, 'Phường Ngọc Hiệp', '22336', 3, 471),
(7413, 'Phường Vĩnh Thọ', '22339', 3, 471),
(7414, 'Phường Vạn Thạnh', '22348', 3, 471),
(7415, 'Phường Phương Sài', '22351', 3, 471),
(7416, 'Phường Phước Hải', '22357', 3, 471),
(7417, 'Phường Lộc Thọ', '22363', 3, 471),
(7418, 'Phường Tân Tiến', '22366', 3, 471),
(7419, 'Phường Phước Hòa', '22372', 3, 471),
(7420, 'Phường Vĩnh Nguyên', '22375', 3, 471),
(7421, 'Phường Phước Long', '22378', 3, 471),
(7422, 'Phường Vĩnh Trường', '22381', 3, 471),
(7423, 'Xã Vĩnh Lương', '22384', 3, 471),
(7424, 'Xã Vĩnh Phương', '22387', 3, 471),
(7425, 'Xã Vĩnh Ngọc', '22390', 3, 471),
(7426, 'Xã Vĩnh Thạnh', '22393', 3, 471),
(7427, 'Xã Vĩnh Trung', '22396', 3, 471),
(7428, 'Xã Vĩnh Hiệp', '22399', 3, 471),
(7429, 'Xã Vĩnh Thái', '22402', 3, 471),
(7430, 'Xã Phước Đồng', '22405', 3, 471);

-- Tỉnh Khánh Hòa > Thành phố Cam Ranh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7431, 'Phường Cam Nghĩa', '22408', 3, 472),
(7432, 'Phường Cam Phúc Bắc', '22411', 3, 472),
(7433, 'Phường Cam Phúc Nam', '22414', 3, 472),
(7434, 'Phường Cam Lộc', '22417', 3, 472),
(7435, 'Phường Cam Phú', '22420', 3, 472),
(7436, 'Phường Ba Ngòi', '22423', 3, 472),
(7437, 'Phường Cam Thuận', '22426', 3, 472),
(7438, 'Phường Cam Lợi', '22429', 3, 472),
(7439, 'Phường Cam Linh', '22432', 3, 472),
(7440, 'Xã Cam Thành Nam', '22468', 3, 472),
(7441, 'Xã Cam Phước Đông', '22474', 3, 472),
(7442, 'Xã Cam Thịnh Tây', '22477', 3, 472),
(7443, 'Xã Cam Thịnh Đông', '22480', 3, 472),
(7444, 'Xã Cam Lập', '22483', 3, 472),
(7445, 'Xã Cam Bình', '22486', 3, 472);

-- Tỉnh Khánh Hòa > Huyện Cam Lâm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7446, 'Xã Cam Tân', '22435', 3, 473),
(7447, 'Xã Cam Hòa', '22438', 3, 473),
(7448, 'Xã Cam Hải Đông', '22441', 3, 473),
(7449, 'Xã Cam Hải Tây', '22444', 3, 473),
(7450, 'Xã Sơn Tân', '22447', 3, 473),
(7451, 'Xã Cam Hiệp Bắc', '22450', 3, 473),
(7452, 'Thị trấn Cam Đức', '22453', 3, 473),
(7453, 'Xã Cam Hiệp Nam', '22456', 3, 473),
(7454, 'Xã Cam Phước Tây', '22459', 3, 473),
(7455, 'Xã Cam Thành Bắc', '22462', 3, 473),
(7456, 'Xã Cam An Bắc', '22465', 3, 473),
(7457, 'Xã Cam An Nam', '22471', 3, 473),
(7458, 'Xã Suối Cát', '22708', 3, 473),
(7459, 'Xã Suối Tân', '22711', 3, 473);

-- Tỉnh Khánh Hòa > Huyện Vạn Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7460, 'Thị trấn Vạn Giã', '22489', 3, 474),
(7461, 'Xã Đại Lãnh', '22492', 3, 474),
(7462, 'Xã Vạn Phước', '22495', 3, 474),
(7463, 'Xã Vạn Long', '22498', 3, 474),
(7464, 'Xã Vạn Bình', '22501', 3, 474),
(7465, 'Xã Vạn Thọ', '22504', 3, 474),
(7466, 'Xã Vạn Khánh', '22507', 3, 474),
(7467, 'Xã Vạn Phú', '22510', 3, 474),
(7468, 'Xã Vạn Lương', '22513', 3, 474),
(7469, 'Xã Vạn Thắng', '22516', 3, 474),
(7470, 'Xã Vạn Thạnh', '22519', 3, 474),
(7471, 'Xã Xuân Sơn', '22522', 3, 474),
(7472, 'Xã Vạn Hưng', '22525', 3, 474);

-- Tỉnh Khánh Hòa > Thị xã Ninh Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7473, 'Phường Ninh Hiệp', '22528', 3, 475),
(7474, 'Xã Ninh Sơn', '22531', 3, 475),
(7475, 'Xã Ninh Tây', '22534', 3, 475),
(7476, 'Xã Ninh Thượng', '22537', 3, 475),
(7477, 'Xã Ninh An', '22540', 3, 475),
(7478, 'Phường Ninh Hải', '22543', 3, 475),
(7479, 'Xã Ninh Thọ', '22546', 3, 475),
(7480, 'Xã Ninh Trung', '22549', 3, 475),
(7481, 'Xã Ninh Sim', '22552', 3, 475),
(7482, 'Xã Ninh Xuân', '22555', 3, 475),
(7483, 'Xã Ninh Thân', '22558', 3, 475),
(7484, 'Phường Ninh Diêm', '22561', 3, 475),
(7485, 'Xã Ninh Đông', '22564', 3, 475),
(7486, 'Phường Ninh Thủy', '22567', 3, 475),
(7487, 'Phường Ninh Đa', '22570', 3, 475),
(7488, 'Xã Ninh Phụng', '22573', 3, 475),
(7489, 'Xã Ninh Bình', '22576', 3, 475),
(7490, 'Xã Ninh Phú', '22582', 3, 475),
(7491, 'Xã Ninh Tân', '22585', 3, 475),
(7492, 'Xã Ninh Quang', '22588', 3, 475),
(7493, 'Phường Ninh Giang', '22591', 3, 475),
(7494, 'Phường Ninh Hà', '22594', 3, 475),
(7495, 'Xã Ninh Hưng', '22597', 3, 475),
(7496, 'Xã Ninh Lộc', '22600', 3, 475),
(7497, 'Xã Ninh Ích', '22603', 3, 475),
(7498, 'Xã Ninh Phước', '22606', 3, 475);

-- Tỉnh Khánh Hòa > Huyện Khánh Vĩnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7499, 'Thị trấn Khánh Vĩnh', '22609', 3, 476),
(7500, 'Xã Khánh Hiệp', '22612', 3, 476),
(7501, 'Xã Khánh Bình', '22615', 3, 476),
(7502, 'Xã Khánh Trung', '22618', 3, 476),
(7503, 'Xã Khánh Đông', '22621', 3, 476),
(7504, 'Xã Khánh Thượng', '22624', 3, 476),
(7505, 'Xã Khánh Nam', '22627', 3, 476),
(7506, 'Xã Sông Cầu', '22630', 3, 476),
(7507, 'Xã Giang Ly', '22633', 3, 476),
(7508, 'Xã Cầu Bà', '22636', 3, 476),
(7509, 'Xã Liên Sang', '22639', 3, 476),
(7510, 'Xã Khánh Thành', '22642', 3, 476),
(7511, 'Xã Khánh Phú', '22645', 3, 476),
(7512, 'Xã Sơn Thái', '22648', 3, 476);

-- Tỉnh Khánh Hòa > Huyện Diên Khánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7513, 'Thị trấn Diên Khánh', '22651', 3, 477),
(7514, 'Xã Diên Lâm', '22654', 3, 477),
(7515, 'Xã Diên Điền', '22657', 3, 477),
(7516, 'Xã Xuân Đồng', '22660', 3, 477),
(7517, 'Xã Diên Sơn', '22663', 3, 477),
(7518, 'Xã Diên Phú', '22669', 3, 477),
(7519, 'Xã Diên Thọ', '22672', 3, 477),
(7520, 'Xã Diên Phước', '22675', 3, 477),
(7521, 'Xã Diên Lạc', '22678', 3, 477),
(7522, 'Xã Diên Tân', '22681', 3, 477),
(7523, 'Xã Diên Hòa', '22684', 3, 477),
(7524, 'Xã Diên Thạnh', '22687', 3, 477),
(7525, 'Xã Diên Toàn', '22690', 3, 477),
(7526, 'Xã Diên An', '22693', 3, 477),
(7527, 'Xã Bình Lộc', '22696', 3, 477),
(7528, 'Xã Suối Hiệp', '22702', 3, 477),
(7529, 'Xã Suối Tiên', '22705', 3, 477);

-- Tỉnh Khánh Hòa > Huyện Khánh Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7530, 'Thị trấn Tô Hạp', '22714', 3, 478),
(7531, 'Xã Thành Sơn', '22717', 3, 478),
(7532, 'Xã Sơn Lâm', '22720', 3, 478),
(7533, 'Xã Sơn Hiệp', '22723', 3, 478),
(7534, 'Xã Sơn Bình', '22726', 3, 478),
(7535, 'Xã Sơn Trung', '22729', 3, 478),
(7536, 'Xã Ba Cụm Bắc', '22732', 3, 478),
(7537, 'Xã Ba Cụm Nam', '22735', 3, 478);

-- Tỉnh Khánh Hòa > Huyện Trường Sa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7538, 'Thị trấn Trường Sa', '22736', 3, 479),
(7539, 'Xã Song Tử Tây', '22737', 3, 479),
(7540, 'Xã Sinh Tồn', '22739', 3, 479);

-- Tỉnh Ninh Thuận > Thành phố Phan Rang - Tháp Chàm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7541, 'Phường Đô Vinh', '22738', 3, 480),
(7542, 'Phường Phước Mỹ', '22741', 3, 480),
(7543, 'Phường Bảo An', '22744', 3, 480),
(7544, 'Phường Phủ Hà', '22750', 3, 480),
(7545, 'Phường Kinh Dinh', '22759', 3, 480),
(7546, 'Phường Đạo Long', '22762', 3, 480),
(7547, 'Phường Đài Sơn', '22765', 3, 480),
(7548, 'Phường Đông Hải', '22768', 3, 480),
(7549, 'Phường Mỹ Đông', '22771', 3, 480),
(7550, 'Xã Thành Hải', '22774', 3, 480),
(7551, 'Phường Văn Hải', '22777', 3, 480),
(7552, 'Phường Mỹ Bình', '22779', 3, 480),
(7553, 'Phường Mỹ Hải', '22780', 3, 480);

-- Tỉnh Ninh Thuận > Huyện Bác Ái
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7554, 'Xã Phước Bình', '22783', 3, 481),
(7555, 'Xã Phước Hòa', '22786', 3, 481),
(7556, 'Xã Phước Tân', '22789', 3, 481),
(7557, 'Xã Phước Tiến', '22792', 3, 481),
(7558, 'Xã Phước Thắng', '22795', 3, 481),
(7559, 'Xã Phước Thành', '22798', 3, 481),
(7560, 'Xã Phước Đại', '22801', 3, 481),
(7561, 'Xã Phước Chính', '22804', 3, 481),
(7562, 'Xã Phước Trung', '22807', 3, 481);

-- Tỉnh Ninh Thuận > Huyện Ninh Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7563, 'Thị trấn Tân Sơn', '22810', 3, 482),
(7564, 'Xã Lâm Sơn', '22813', 3, 482),
(7565, 'Xã Lương Sơn', '22816', 3, 482),
(7566, 'Xã Quảng Sơn', '22819', 3, 482),
(7567, 'Xã Mỹ Sơn', '22822', 3, 482),
(7568, 'Xã Hòa Sơn', '22825', 3, 482),
(7569, 'Xã Ma Nới', '22828', 3, 482),
(7570, 'Xã Nhơn Sơn', '22831', 3, 482);

-- Tỉnh Ninh Thuận > Huyện Ninh Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7571, 'Thị trấn Khánh Hải', '22834', 3, 483),
(7572, 'Xã Vĩnh Hải', '22846', 3, 483),
(7573, 'Xã Phương Hải', '22852', 3, 483),
(7574, 'Xã Tân Hải', '22855', 3, 483),
(7575, 'Xã Xuân Hải', '22858', 3, 483),
(7576, 'Xã Hộ Hải', '22861', 3, 483),
(7577, 'Xã Tri Hải', '22864', 3, 483),
(7578, 'Xã Nhơn Hải', '22867', 3, 483),
(7579, 'Xã Thanh Hải', '22868', 3, 483);

-- Tỉnh Ninh Thuận > Huyện Ninh Phước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7580, 'Thị trấn Phước Dân', '22870', 3, 484),
(7581, 'Xã Phước Sơn', '22873', 3, 484),
(7582, 'Xã Phước Thái', '22876', 3, 484),
(7583, 'Xã Phước Hậu', '22879', 3, 484),
(7584, 'Xã Phước Thuận', '22882', 3, 484),
(7585, 'Xã An Hải', '22888', 3, 484),
(7586, 'Xã Phước Hữu', '22891', 3, 484),
(7587, 'Xã Phước Hải', '22894', 3, 484),
(7588, 'Xã Phước Vinh', '22912', 3, 484);

-- Tỉnh Ninh Thuận > Huyện Thuận Bắc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7589, 'Xã Phước Chiến', '22837', 3, 485),
(7590, 'Xã Công Hải', '22840', 3, 485),
(7591, 'Xã Phước Kháng', '22843', 3, 485),
(7592, 'Xã Lợi Hải', '22849', 3, 485),
(7593, 'Xã Bắc Sơn', '22853', 3, 485),
(7594, 'Xã Bắc Phong', '22856', 3, 485);

-- Tỉnh Ninh Thuận > Huyện Thuận Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7595, 'Xã Phước Hà', '22885', 3, 486),
(7596, 'Xã Phước Nam', '22897', 3, 486),
(7597, 'Xã Phước Ninh', '22898', 3, 486),
(7598, 'Xã Nhị Hà', '22900', 3, 486),
(7599, 'Xã Phước Dinh', '22903', 3, 486),
(7600, 'Xã Phước Minh', '22906', 3, 486),
(7601, 'Xã Phước Diêm', '22909', 3, 486),
(7602, 'Xã Cà Ná', '22910', 3, 486);

-- Tỉnh Bình Thuận > Thành phố Phan Thiết
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7603, 'Phường Mũi Né', '22915', 3, 487),
(7604, 'Phường Hàm Tiến', '22918', 3, 487),
(7605, 'Phường Phú Hài', '22921', 3, 487),
(7606, 'Phường Phú Thủy', '22924', 3, 487),
(7607, 'Phường Phú Tài', '22927', 3, 487),
(7608, 'Phường Phú Trinh', '22930', 3, 487),
(7609, 'Phường Xuân An', '22933', 3, 487),
(7610, 'Phường Thanh Hải', '22936', 3, 487),
(7611, 'Phường Lạc Đạo', '22945', 3, 487),
(7612, 'Phường Bình Hưng', '22951', 3, 487),
(7613, 'Phường Đức Long', '22954', 3, 487),
(7614, 'Xã Thiện Nghiệp', '22957', 3, 487),
(7615, 'Xã Phong Nẫm', '22960', 3, 487),
(7616, 'Xã Tiến Lợi', '22963', 3, 487),
(7617, 'Xã Tiến Thành', '22966', 3, 487);

-- Tỉnh Bình Thuận > Thị xã La Gi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7618, 'Phường Phước Hội', '23231', 3, 488),
(7619, 'Phường Phước Lộc', '23232', 3, 488),
(7620, 'Phường Tân Thiện', '23234', 3, 488),
(7621, 'Phường Tân An', '23235', 3, 488),
(7622, 'Phường Bình Tân', '23237', 3, 488),
(7623, 'Xã Tân Hải', '23245', 3, 488),
(7624, 'Xã Tân Tiến', '23246', 3, 488),
(7625, 'Xã Tân Bình', '23248', 3, 488),
(7626, 'Xã Tân Phước', '23268', 3, 488);

-- Tỉnh Bình Thuận > Huyện Tuy Phong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7627, 'Thị trấn Liên Hương', '22969', 3, 489),
(7628, 'Thị trấn Phan Rí Cửa', '22972', 3, 489),
(7629, 'Xã Phan Dũng', '22975', 3, 489),
(7630, 'Xã Phong Phú', '22978', 3, 489),
(7631, 'Xã Vĩnh Hảo', '22981', 3, 489),
(7632, 'Xã Vĩnh Tân', '22984', 3, 489),
(7633, 'Xã Phú Lạc', '22987', 3, 489),
(7634, 'Xã Phước Thể', '22990', 3, 489),
(7635, 'Xã Hòa Minh', '22993', 3, 489),
(7636, 'Xã Chí Công', '22996', 3, 489),
(7637, 'Xã Bình Thạnh', '22999', 3, 489);

-- Tỉnh Bình Thuận > Huyện Bắc Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7638, 'Thị trấn Chợ Lầu', '23005', 3, 490),
(7639, 'Xã Phan Sơn', '23008', 3, 490),
(7640, 'Xã Phan Lâm', '23011', 3, 490),
(7641, 'Xã Bình An', '23014', 3, 490),
(7642, 'Xã Phan Điền', '23017', 3, 490),
(7643, 'Xã Hải Ninh', '23020', 3, 490),
(7644, 'Xã Sông Lũy', '23023', 3, 490),
(7645, 'Xã Phan Tiến', '23026', 3, 490),
(7646, 'Xã Sông Bình', '23029', 3, 490),
(7647, 'Thị trấn Lương Sơn', '23032', 3, 490),
(7648, 'Xã Phan Hòa', '23035', 3, 490),
(7649, 'Xã Phan Thanh', '23038', 3, 490),
(7650, 'Xã Hồng Thái', '23041', 3, 490),
(7651, 'Xã Phan Hiệp', '23044', 3, 490),
(7652, 'Xã Bình Tân', '23047', 3, 490),
(7653, 'Xã Phan Rí Thành', '23050', 3, 490),
(7654, 'Xã Hòa Thắng', '23053', 3, 490),
(7655, 'Xã Hồng Phong', '23056', 3, 490);

-- Tỉnh Bình Thuận > Huyện Hàm Thuận Bắc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7656, 'Thị trấn Ma Lâm', '23059', 3, 491),
(7657, 'Thị trấn Phú Long', '23062', 3, 491),
(7658, 'Xã La Dạ', '23065', 3, 491),
(7659, 'Xã Đông Tiến', '23068', 3, 491),
(7660, 'Xã Thuận Hòa', '23071', 3, 491),
(7661, 'Xã Đông Giang', '23074', 3, 491),
(7662, 'Xã Hàm Phú', '23077', 3, 491),
(7663, 'Xã Hồng Liêm', '23080', 3, 491),
(7664, 'Xã Thuận Minh', '23083', 3, 491),
(7665, 'Xã Hồng Sơn', '23086', 3, 491),
(7666, 'Xã Hàm Trí', '23089', 3, 491),
(7667, 'Xã Hàm Đức', '23092', 3, 491),
(7668, 'Xã Hàm Liêm', '23095', 3, 491),
(7669, 'Xã Hàm Chính', '23098', 3, 491),
(7670, 'Xã Hàm Hiệp', '23101', 3, 491),
(7671, 'Xã Hàm Thắng', '23104', 3, 491),
(7672, 'Xã Đa Mi', '23107', 3, 491);

-- Tỉnh Bình Thuận > Huyện Hàm Thuận Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7673, 'Thị trấn Thuận Nam', '23110', 3, 492),
(7674, 'Xã Mỹ Thạnh', '23113', 3, 492),
(7675, 'Xã Hàm Cần', '23116', 3, 492),
(7676, 'Xã Mương Mán', '23119', 3, 492),
(7677, 'Xã Hàm Thạnh', '23122', 3, 492),
(7678, 'Xã Hàm Kiệm', '23125', 3, 492),
(7679, 'Xã Hàm Cường', '23128', 3, 492),
(7680, 'Xã Hàm Mỹ', '23131', 3, 492),
(7681, 'Xã Tân Lập', '23134', 3, 492),
(7682, 'Xã Hàm Minh', '23137', 3, 492),
(7683, 'Xã Thuận Quí', '23140', 3, 492),
(7684, 'Xã Tân Thuận', '23143', 3, 492),
(7685, 'Xã Tân Thành', '23146', 3, 492);

-- Tỉnh Bình Thuận > Huyện Tánh Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7686, 'Thị trấn Lạc Tánh', '23149', 3, 493),
(7687, 'Xã Bắc Ruộng', '23152', 3, 493),
(7688, 'Xã Nghị Đức', '23158', 3, 493),
(7689, 'Xã La Ngâu', '23161', 3, 493),
(7690, 'Xã Huy Khiêm', '23164', 3, 493),
(7691, 'Xã Măng Tố', '23167', 3, 493),
(7692, 'Xã Đức Phú', '23170', 3, 493),
(7693, 'Xã Đồng Kho', '23173', 3, 493),
(7694, 'Xã Gia An', '23176', 3, 493),
(7695, 'Xã Đức Bình', '23179', 3, 493),
(7696, 'Xã Gia Huynh', '23182', 3, 493),
(7697, 'Xã Đức Thuận', '23185', 3, 493),
(7698, 'Xã Suối Kiết', '23188', 3, 493);

-- Tỉnh Bình Thuận > Huyện Đức Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7699, 'Thị trấn Võ Xu', '23191', 3, 494),
(7700, 'Thị trấn Đức Tài', '23194', 3, 494),
(7701, 'Xã Đa Kai', '23197', 3, 494),
(7702, 'Xã Sùng Nhơn', '23200', 3, 494),
(7703, 'Xã Mê Pu', '23203', 3, 494),
(7704, 'Xã Nam Chính', '23206', 3, 494),
(7705, 'Xã Đức Hạnh', '23212', 3, 494),
(7706, 'Xã Đức Tín', '23215', 3, 494),
(7707, 'Xã Vũ Hoà', '23218', 3, 494),
(7708, 'Xã Tân Hà', '23221', 3, 494),
(7709, 'Xã Đông Hà', '23224', 3, 494),
(7710, 'Xã Trà Tân', '23227', 3, 494);

-- Tỉnh Bình Thuận > Huyện Hàm Tân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7711, 'Thị trấn Tân Minh', '23230', 3, 495),
(7712, 'Thị trấn Tân Nghĩa', '23236', 3, 495),
(7713, 'Xã Sông Phan', '23239', 3, 495),
(7714, 'Xã Tân Phúc', '23242', 3, 495),
(7715, 'Xã Tân Đức', '23251', 3, 495),
(7716, 'Xã Tân Thắng', '23254', 3, 495),
(7717, 'Xã Thắng Hải', '23255', 3, 495),
(7718, 'Xã Tân Hà', '23257', 3, 495),
(7719, 'Xã Tân Xuân', '23260', 3, 495),
(7720, 'Xã Sơn Mỹ', '23266', 3, 495);

-- Tỉnh Bình Thuận > Huyện Phú Quí
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7721, 'Xã Ngũ Phụng', '23272', 3, 496),
(7722, 'Xã Long Hải', '23275', 3, 496),
(7723, 'Xã Tam Thanh', '23278', 3, 496);

-- Tỉnh Kon Tum > Thành phố Kon Tum
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7724, 'Phường Quang Trung', '23281', 3, 497),
(7725, 'Phường Duy Tân', '23284', 3, 497),
(7726, 'Phường Quyết Thắng', '23287', 3, 497),
(7727, 'Phường Trường Chinh', '23290', 3, 497),
(7728, 'Phường Thắng Lợi', '23293', 3, 497),
(7729, 'Phường Ngô Mây', '23296', 3, 497),
(7730, 'Phường Thống Nhất', '23299', 3, 497),
(7731, 'Phường Lê Lợi', '23302', 3, 497),
(7732, 'Phường Nguyễn Trãi', '23305', 3, 497),
(7733, 'Phường Trần Hưng Đạo', '23308', 3, 497),
(7734, 'Xã Đắk Cấm', '23311', 3, 497),
(7735, 'Xã Kroong', '23314', 3, 497),
(7736, 'Xã Ngọk Bay', '23317', 3, 497),
(7737, 'Xã Vinh Quang', '23320', 3, 497),
(7738, 'Xã Đắk Blà', '23323', 3, 497),
(7739, 'Xã Ia Chim', '23326', 3, 497),
(7740, 'Xã Đăk Năng', '23327', 3, 497),
(7741, 'Xã Đoàn Kết', '23329', 3, 497),
(7742, 'Xã Chư Hreng', '23332', 3, 497),
(7743, 'Xã Đắk Rơ Wa', '23335', 3, 497),
(7744, 'Xã Hòa Bình', '23338', 3, 497);

-- Tỉnh Kon Tum > Huyện Đắk Glei
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7745, 'Thị trấn Đắk Glei', '23341', 3, 498),
(7746, 'Xã Đắk Blô', '23344', 3, 498),
(7747, 'Xã Đắk Man', '23347', 3, 498),
(7748, 'Xã Đắk Nhoong', '23350', 3, 498),
(7749, 'Xã Đắk Pék', '23353', 3, 498),
(7750, 'Xã Đắk Choong', '23356', 3, 498),
(7751, 'Xã Xốp', '23359', 3, 498),
(7752, 'Xã Mường Hoong', '23362', 3, 498),
(7753, 'Xã Ngọc Linh', '23365', 3, 498),
(7754, 'Xã Đắk Long', '23368', 3, 498),
(7755, 'Xã Đắk KRoong', '23371', 3, 498),
(7756, 'Xã Đắk Môn', '23374', 3, 498);

-- Tỉnh Kon Tum > Huyện Ngọc Hồi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7757, 'Thị trấn Plei Kần', '23377', 3, 499),
(7758, 'Xã Đắk Ang', '23380', 3, 499),
(7759, 'Xã Đắk Dục', '23383', 3, 499),
(7760, 'Xã Đắk Nông', '23386', 3, 499),
(7761, 'Xã Đắk Xú', '23389', 3, 499),
(7762, 'Xã Đắk Kan', '23392', 3, 499),
(7763, 'Xã Bờ Y', '23395', 3, 499),
(7764, 'Xã Sa Loong', '23398', 3, 499);

-- Tỉnh Kon Tum > Huyện Đắk Tô
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7765, 'Thị trấn Đắk Tô', '23401', 3, 500),
(7766, 'Xã Đắk Rơ Nga', '23427', 3, 500),
(7767, 'Xã Ngọk Tụ', '23428', 3, 500),
(7768, 'Xã Đắk Trăm', '23430', 3, 500),
(7769, 'Xã Văn Lem', '23431', 3, 500),
(7770, 'Xã Kon Đào', '23434', 3, 500),
(7771, 'Xã Tân Cảnh', '23437', 3, 500),
(7772, 'Xã Diên Bình', '23440', 3, 500),
(7773, 'Xã Pô Kô', '23443', 3, 500);

-- Tỉnh Kon Tum > Huyện Kon Plông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7774, 'Xã Đắk Nên', '23452', 3, 501),
(7775, 'Xã Đắk Ring', '23455', 3, 501),
(7776, 'Xã Măng Buk', '23458', 3, 501),
(7777, 'Xã Đắk Tăng', '23461', 3, 501),
(7778, 'Xã Ngok Tem', '23464', 3, 501),
(7779, 'Xã Pờ Ê', '23467', 3, 501),
(7780, 'Xã Măng Cành', '23470', 3, 501),
(7781, 'Thị trấn Măng Đen', '23473', 3, 501),
(7782, 'Xã Hiếu', '23476', 3, 501);

-- Tỉnh Kon Tum > Huyện Kon Rẫy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7783, 'Thị trấn Đắk Rve', '23479', 3, 502),
(7784, 'Xã Đắk Kôi', '23482', 3, 502),
(7785, 'Xã Đắk Tơ Lung', '23485', 3, 502),
(7786, 'Xã Đắk Ruồng', '23488', 3, 502),
(7787, 'Xã Đắk Pne', '23491', 3, 502),
(7788, 'Xã Đắk Tờ Re', '23494', 3, 502),
(7789, 'Xã Tân Lập', '23497', 3, 502);

-- Tỉnh Kon Tum > Huyện Đắk Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7790, 'Thị trấn Đắk Hà', '23500', 3, 503),
(7791, 'Xã Đắk PXi', '23503', 3, 503),
(7792, 'Xã Đăk Long', '23504', 3, 503),
(7793, 'Xã Đắk HRing', '23506', 3, 503),
(7794, 'Xã Đắk Ui', '23509', 3, 503),
(7795, 'Xã Đăk Ngọk', '23510', 3, 503),
(7796, 'Xã Đắk Mar', '23512', 3, 503),
(7797, 'Xã Ngok Wang', '23515', 3, 503),
(7798, 'Xã Ngok Réo', '23518', 3, 503),
(7799, 'Xã Hà Mòn', '23521', 3, 503),
(7800, 'Xã Đắk La', '23524', 3, 503);

-- Tỉnh Kon Tum > Huyện Sa Thầy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7801, 'Thị trấn Sa Thầy', '23527', 3, 504),
(7802, 'Xã Rơ Kơi', '23530', 3, 504),
(7803, 'Xã Sa Nhơn', '23533', 3, 504),
(7804, 'Xã Hơ Moong', '23534', 3, 504),
(7805, 'Xã Mô Rai', '23536', 3, 504),
(7806, 'Xã Sa Sơn', '23539', 3, 504),
(7807, 'Xã Sa Nghĩa', '23542', 3, 504),
(7808, 'Xã Sa Bình', '23545', 3, 504),
(7809, 'Xã Ya Xiêr', '23548', 3, 504),
(7810, 'Xã Ya Tăng', '23551', 3, 504),
(7811, 'Xã Ya ly', '23554', 3, 504);

-- Tỉnh Kon Tum > Huyện Tu Mơ Rông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7812, 'Xã Ngọc Lây', '23404', 3, 505),
(7813, 'Xã Đắk Na', '23407', 3, 505),
(7814, 'Xã Măng Ri', '23410', 3, 505),
(7815, 'Xã Ngọc Yêu', '23413', 3, 505),
(7816, 'Xã Đắk Sao', '23416', 3, 505),
(7817, 'Xã Đắk Rơ Ông', '23417', 3, 505),
(7818, 'Xã Đắk Tờ Kan', '23419', 3, 505),
(7819, 'Xã Tu Mơ Rông', '23422', 3, 505),
(7820, 'Xã Đắk Hà', '23425', 3, 505),
(7821, 'Xã Tê Xăng', '23446', 3, 505),
(7822, 'Xã Văn Xuôi', '23449', 3, 505);

-- Tỉnh Kon Tum > Huyện Ia H'' Drai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7823, 'Xã Ia Đal', '23535', 3, 506),
(7824, 'Xã Ia Dom', '23537', 3, 506),
(7825, 'Xã Ia Tơi', '23538', 3, 506);

-- Tỉnh Gia Lai > Thành phố Pleiku
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7826, 'Phường Yên Đỗ', '23557', 3, 507),
(7827, 'Phường Diên Hồng', '23560', 3, 507),
(7828, 'Phường Ia Kring', '23563', 3, 507),
(7829, 'Phường Hội Thương', '23566', 3, 507),
(7830, 'Phường Hội Phú', '23569', 3, 507),
(7831, 'Phường Phù Đổng', '23570', 3, 507),
(7832, 'Phường Hoa Lư', '23572', 3, 507),
(7833, 'Phường Tây Sơn', '23575', 3, 507),
(7834, 'Phường Thống Nhất', '23578', 3, 507),
(7835, 'Phường Đống Đa', '23579', 3, 507),
(7836, 'Phường Trà Bá', '23581', 3, 507),
(7837, 'Phường Thắng Lợi', '23582', 3, 507),
(7838, 'Phường Yên Thế', '23584', 3, 507),
(7839, 'Phường Chi Lăng', '23586', 3, 507),
(7840, 'Xã Biển Hồ', '23590', 3, 507),
(7841, 'Xã Trà Đa', '23596', 3, 507),
(7842, 'Xã Chư Á', '23599', 3, 507),
(7843, 'Xã An Phú', '23602', 3, 507),
(7844, 'Xã Diên Phú', '23605', 3, 507),
(7845, 'Xã Ia Kênh', '23608', 3, 507),
(7846, 'Xã Gào', '23611', 3, 507);

-- Tỉnh Gia Lai > Thị xã An Khê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7847, 'Phường An Bình', '23614', 3, 508),
(7848, 'Phường Tây Sơn', '23617', 3, 508),
(7849, 'Phường An Phú', '23620', 3, 508),
(7850, 'Phường An Tân', '23623', 3, 508),
(7851, 'Xã Tú An', '23626', 3, 508),
(7852, 'Xã Xuân An', '23627', 3, 508),
(7853, 'Xã Cửu An', '23629', 3, 508),
(7854, 'Phường An Phước', '23630', 3, 508),
(7855, 'Xã Song An', '23632', 3, 508),
(7856, 'Phường Ngô Mây', '23633', 3, 508),
(7857, 'Xã Thành An', '23635', 3, 508);

-- Tỉnh Gia Lai > Thị xã Ayun Pa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7858, 'Phường Cheo Reo', '24041', 3, 509),
(7859, 'Phường Hòa Bình', '24042', 3, 509),
(7860, 'Phường Đoàn Kết', '24044', 3, 509),
(7861, 'Phường Sông Bờ', '24045', 3, 509),
(7862, 'Xã Ia RBol', '24064', 3, 509),
(7863, 'Xã Chư Băh', '24065', 3, 509),
(7864, 'Xã Ia RTô', '24070', 3, 509),
(7865, 'Xã Ia Sao', '24073', 3, 509);

-- Tỉnh Gia Lai > Huyện KBang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7866, 'Thị trấn KBang', '23638', 3, 510),
(7867, 'Xã Kon Pne', '23641', 3, 510),
(7868, 'Xã Đăk Roong', '23644', 3, 510),
(7869, 'Xã Sơn Lang', '23647', 3, 510),
(7870, 'Xã KRong', '23650', 3, 510),
(7871, 'Xã Sơ Pai', '23653', 3, 510),
(7872, 'Xã Lơ Ku', '23656', 3, 510),
(7873, 'Xã Đông', '23659', 3, 510),
(7874, 'Xã Đak SMar', '23660', 3, 510),
(7875, 'Xã Nghĩa An', '23662', 3, 510),
(7876, 'Xã Tơ Tung', '23665', 3, 510),
(7877, 'Xã Kông Lơng Khơng', '23668', 3, 510),
(7878, 'Xã Kông Bơ La', '23674', 3, 510);

-- Tỉnh Gia Lai > Huyện Đăk Đoa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7879, 'Thị trấn Đăk Đoa', '23677', 3, 511),
(7880, 'Xã Hà Đông', '23680', 3, 511),
(7881, 'Xã Đăk Sơmei', '23683', 3, 511),
(7882, 'Xã Đăk Krong', '23684', 3, 511),
(7883, 'Xã Hải Yang', '23686', 3, 511),
(7884, 'Xã Kon Gang', '23689', 3, 511),
(7885, 'Xã Hà Bầu', '23692', 3, 511),
(7886, 'Xã Nam Yang', '23695', 3, 511),
(7887, 'Xã K'' Dang', '23698', 3, 511),
(7888, 'Xã H'' Neng', '23701', 3, 511),
(7889, 'Xã Tân Bình', '23704', 3, 511),
(7890, 'Xã Glar', '23707', 3, 511),
(7891, 'Xã A Dơk', '23710', 3, 511),
(7892, 'Xã Trang', '23713', 3, 511),
(7893, 'Xã HNol', '23714', 3, 511),
(7894, 'Xã Ia Pết', '23716', 3, 511),
(7895, 'Xã Ia Băng', '23719', 3, 511);

-- Tỉnh Gia Lai > Huyện Chư Păh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7896, 'Thị trấn Phú Hòa', '23722', 3, 512),
(7897, 'Xã Hà Tây', '23725', 3, 512),
(7898, 'Xã Ia Khươl', '23728', 3, 512),
(7899, 'Xã Ia Phí', '23731', 3, 512),
(7900, 'Thị trấn Ia Ly', '23734', 3, 512),
(7901, 'Xã Ia Mơ Nông', '23737', 3, 512),
(7902, 'Xã Ia Kreng', '23738', 3, 512),
(7903, 'Xã Đăk Tơ Ver', '23740', 3, 512),
(7904, 'Xã Hòa Phú', '23743', 3, 512),
(7905, 'Xã Chư Đăng Ya', '23746', 3, 512),
(7906, 'Xã Ia Ka', '23749', 3, 512),
(7907, 'Xã Ia Nhin', '23752', 3, 512),
(7908, 'Xã Nghĩa Hòa', '23755', 3, 512),
(7909, 'Xã Nghĩa Hưng', '23761', 3, 512);

-- Tỉnh Gia Lai > Huyện Ia Grai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7910, 'Thị trấn Ia Kha', '23764', 3, 513),
(7911, 'Xã Ia Sao', '23767', 3, 513),
(7912, 'Xã Ia Yok', '23768', 3, 513),
(7913, 'Xã Ia Hrung', '23770', 3, 513),
(7914, 'Xã Ia Bă', '23771', 3, 513),
(7915, 'Xã Ia Khai', '23773', 3, 513),
(7916, 'Xã Ia KRai', '23776', 3, 513),
(7917, 'Xã Ia Grăng', '23778', 3, 513),
(7918, 'Xã Ia Tô', '23779', 3, 513),
(7919, 'Xã Ia O', '23782', 3, 513),
(7920, 'Xã Ia Dêr', '23785', 3, 513),
(7921, 'Xã Ia Chia', '23788', 3, 513),
(7922, 'Xã Ia Pếch', '23791', 3, 513);

-- Tỉnh Gia Lai > Huyện Mang Yang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7923, 'Thị trấn Kon Dơng', '23794', 3, 514),
(7924, 'Xã Ayun', '23797', 3, 514),
(7925, 'Xã Đak Jơ Ta', '23798', 3, 514),
(7926, 'Xã Đak Ta Ley', '23799', 3, 514),
(7927, 'Xã Hra', '23800', 3, 514),
(7928, 'Xã Đăk Yă', '23803', 3, 514),
(7929, 'Xã Đăk Djrăng', '23806', 3, 514),
(7930, 'Xã Lơ Pang', '23809', 3, 514),
(7931, 'Xã Kon Thụp', '23812', 3, 514),
(7932, 'Xã Đê Ar', '23815', 3, 514),
(7933, 'Xã Kon Chiêng', '23818', 3, 514),
(7934, 'Xã Đăk Trôi', '23821', 3, 514);

-- Tỉnh Gia Lai > Huyện Kông Chro
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7935, 'Thị trấn Kông Chro', '23824', 3, 515),
(7936, 'Xã Chư Krêy', '23827', 3, 515),
(7937, 'Xã An Trung', '23830', 3, 515),
(7938, 'Xã Kông Yang', '23833', 3, 515),
(7939, 'Xã Đăk Tơ Pang', '23836', 3, 515),
(7940, 'Xã SRó', '23839', 3, 515),
(7941, 'Xã Đắk Kơ Ning', '23840', 3, 515),
(7942, 'Xã Đăk Song', '23842', 3, 515),
(7943, 'Xã Đăk Pling', '23843', 3, 515),
(7944, 'Xã Yang Trung', '23845', 3, 515),
(7945, 'Xã Đăk Pơ Pho', '23846', 3, 515),
(7946, 'Xã Ya Ma', '23848', 3, 515),
(7947, 'Xã Chơ Long', '23851', 3, 515),
(7948, 'Xã Yang Nam', '23854', 3, 515);

-- Tỉnh Gia Lai > Huyện Đức Cơ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7949, 'Thị trấn Chư Ty', '23857', 3, 516),
(7950, 'Xã Ia Dơk', '23860', 3, 516),
(7951, 'Xã Ia Krêl', '23863', 3, 516),
(7952, 'Xã Ia Din', '23866', 3, 516),
(7953, 'Xã Ia Kla', '23869', 3, 516),
(7954, 'Xã Ia Dom', '23872', 3, 516),
(7955, 'Xã Ia Lang', '23875', 3, 516),
(7956, 'Xã Ia Kriêng', '23878', 3, 516),
(7957, 'Xã Ia Pnôn', '23881', 3, 516),
(7958, 'Xã Ia Nan', '23884', 3, 516);

-- Tỉnh Gia Lai > Huyện Chư Prông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7959, 'Thị trấn Chư Prông', '23887', 3, 517),
(7960, 'Xã Ia Kly', '23888', 3, 517),
(7961, 'Xã Bình Giáo', '23890', 3, 517),
(7962, 'Xã Ia Drăng', '23893', 3, 517),
(7963, 'Xã Thăng Hưng', '23896', 3, 517),
(7964, 'Xã Bàu Cạn', '23899', 3, 517),
(7965, 'Xã Ia Phìn', '23902', 3, 517),
(7966, 'Xã Ia Băng', '23905', 3, 517),
(7967, 'Xã Ia Tôr', '23908', 3, 517),
(7968, 'Xã Ia Boòng', '23911', 3, 517),
(7969, 'Xã Ia O', '23914', 3, 517),
(7970, 'Xã Ia Púch', '23917', 3, 517),
(7971, 'Xã Ia Me', '23920', 3, 517),
(7972, 'Xã Ia Vê', '23923', 3, 517),
(7973, 'Xã Ia Bang', '23924', 3, 517),
(7974, 'Xã Ia Pia', '23926', 3, 517),
(7975, 'Xã Ia Ga', '23929', 3, 517),
(7976, 'Xã Ia Lâu', '23932', 3, 517),
(7977, 'Xã Ia Piơr', '23935', 3, 517),
(7978, 'Xã Ia Mơ', '23938', 3, 517);

-- Tỉnh Gia Lai > Huyện Chư Sê
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7979, 'Thị trấn Chư Sê', '23941', 3, 518),
(7980, 'Xã Ia Tiêm', '23944', 3, 518),
(7981, 'Xã Chư Pơng', '23945', 3, 518),
(7982, 'Xã Bar Măih', '23946', 3, 518),
(7983, 'Xã Bờ Ngoong', '23947', 3, 518),
(7984, 'Xã Ia Glai', '23950', 3, 518),
(7985, 'Xã AL Bá', '23953', 3, 518),
(7986, 'Xã Kông HTok', '23954', 3, 518),
(7987, 'Xã AYun', '23956', 3, 518),
(7988, 'Xã Ia HLốp', '23959', 3, 518),
(7989, 'Xã Ia Blang', '23962', 3, 518),
(7990, 'Xã Dun', '23965', 3, 518),
(7991, 'Xã Ia Pal', '23966', 3, 518),
(7992, 'Xã H Bông', '23968', 3, 518),
(7993, 'Xã Ia Ko', '23977', 3, 518);

-- Tỉnh Gia Lai > Huyện Đăk Pơ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(7994, 'Xã Hà Tam', '23989', 3, 519),
(7995, 'Xã An Thành', '23992', 3, 519),
(7996, 'Thị trấn Đak Pơ', '23995', 3, 519),
(7997, 'Xã Yang Bắc', '23998', 3, 519),
(7998, 'Xã Cư An', '24001', 3, 519),
(7999, 'Xã Tân An', '24004', 3, 519),
(8000, 'Xã Phú An', '24007', 3, 519),
(8001, 'Xã Ya Hội', '24010', 3, 519);

-- Tỉnh Gia Lai > Huyện Ia Pa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8002, 'Xã Pờ Tó', '24013', 3, 520),
(8003, 'Xã Chư Răng', '24016', 3, 520),
(8004, 'Xã Ia KDăm', '24019', 3, 520),
(8005, 'Xã Kim Tân', '24022', 3, 520),
(8006, 'Xã Chư Mố', '24025', 3, 520),
(8007, 'Xã Ia Tul', '24028', 3, 520),
(8008, 'Xã Ia Ma Rơn', '24031', 3, 520),
(8009, 'Xã Ia Broăi', '24034', 3, 520),
(8010, 'Xã Ia Trok', '24037', 3, 520);

-- Tỉnh Gia Lai > Huyện Krông Pa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8011, 'Thị trấn Phú Túc', '24076', 3, 521),
(8012, 'Xã Ia RSai', '24079', 3, 521),
(8013, 'Xã Ia RSươm', '24082', 3, 521),
(8014, 'Xã Chư Gu', '24085', 3, 521),
(8015, 'Xã Đất Bằng', '24088', 3, 521),
(8016, 'Xã Ia Mláh', '24091', 3, 521),
(8017, 'Xã Chư Drăng', '24094', 3, 521),
(8018, 'Xã Phú Cần', '24097', 3, 521),
(8019, 'Xã Ia HDreh', '24100', 3, 521),
(8020, 'Xã Ia RMok', '24103', 3, 521),
(8021, 'Xã Chư Ngọc', '24106', 3, 521),
(8022, 'Xã Uar', '24109', 3, 521),
(8023, 'Xã Chư Rcăm', '24112', 3, 521),
(8024, 'Xã Krông Năng', '24115', 3, 521);

-- Tỉnh Gia Lai > Huyện Phú Thiện
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8025, 'Thị trấn Phú Thiện', '24043', 3, 522),
(8026, 'Xã Chư A Thai', '24046', 3, 522),
(8027, 'Xã Ayun Hạ', '24048', 3, 522),
(8028, 'Xã Ia Ake', '24049', 3, 522),
(8029, 'Xã Ia Sol', '24052', 3, 522),
(8030, 'Xã Ia Piar', '24055', 3, 522),
(8031, 'Xã Ia Peng', '24058', 3, 522),
(8032, 'Xã Chrôh Pơnan', '24060', 3, 522),
(8033, 'Xã Ia Hiao', '24061', 3, 522),
(8034, 'Xã Ia Yeng', '24067', 3, 522);

-- Tỉnh Gia Lai > Huyện Chư Pưh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8035, 'Thị trấn Nhơn Hoà', '23942', 3, 523),
(8036, 'Xã Ia Hrú', '23971', 3, 523),
(8037, 'Xã Ia Rong', '23972', 3, 523),
(8038, 'Xã Ia Dreng', '23974', 3, 523),
(8039, 'Xã Ia Hla', '23978', 3, 523),
(8040, 'Xã Chư Don', '23980', 3, 523),
(8041, 'Xã Ia Phang', '23983', 3, 523),
(8042, 'Xã Ia Le', '23986', 3, 523),
(8043, 'Xã Ia BLứ', '23987', 3, 523);

-- Tỉnh Đắk Lắk > Thành phố Buôn Ma Thuột
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8044, 'Phường Tân Lập', '24118', 3, 524),
(8045, 'Phường Tân Hòa', '24121', 3, 524),
(8046, 'Phường Tân An', '24124', 3, 524),
(8047, 'Phường Thành Nhất', '24130', 3, 524),
(8048, 'Phường Thành Công', '24133', 3, 524),
(8049, 'Phường Tân Lợi', '24136', 3, 524),
(8050, 'Phường Tân Thành', '24142', 3, 524),
(8051, 'Phường Tân Tiến', '24145', 3, 524),
(8052, 'Phường Tự An', '24148', 3, 524),
(8053, 'Phường Ea Tam', '24151', 3, 524),
(8054, 'Phường Khánh Xuân', '24154', 3, 524),
(8055, 'Xã Hòa Thuận', '24157', 3, 524),
(8056, 'Xã Cư ÊBur', '24160', 3, 524),
(8057, 'Xã Ea Tu', '24163', 3, 524),
(8058, 'Xã Hòa Thắng', '24166', 3, 524),
(8059, 'Xã Ea Kao', '24169', 3, 524),
(8060, 'Xã Hòa Phú', '24172', 3, 524),
(8061, 'Xã Hòa Khánh', '24175', 3, 524),
(8062, 'Xã Hòa Xuân', '24178', 3, 524);

-- Tỉnh Đắk Lắk > Thị xã Buôn Hồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8063, 'Phường An Lạc', '24305', 3, 525),
(8064, 'Phường An Bình', '24308', 3, 525),
(8065, 'Phường Thiện An', '24311', 3, 525),
(8066, 'Phường Đạt Hiếu', '24318', 3, 525),
(8067, 'Phường Đoàn Kết', '24322', 3, 525),
(8068, 'Xã Ea Drông', '24328', 3, 525),
(8069, 'Phường Thống Nhất', '24331', 3, 525),
(8070, 'Phường Bình Tân', '24332', 3, 525),
(8071, 'Xã Ea Siên', '24334', 3, 525),
(8072, 'Xã Bình Thuận', '24337', 3, 525),
(8073, 'Xã Cư Bao', '24340', 3, 525);

-- Tỉnh Đắk Lắk > Huyện Ea H''leo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8074, 'Thị trấn Ea Drăng', '24181', 3, 526),
(8075, 'Xã Ea H''leo', '24184', 3, 526),
(8076, 'Xã Ea Sol', '24187', 3, 526),
(8077, 'Xã Ea Ral', '24190', 3, 526),
(8078, 'Xã Ea Wy', '24193', 3, 526),
(8079, 'Xã Cư A Mung', '24194', 3, 526),
(8080, 'Xã Cư Mốt', '24196', 3, 526),
(8081, 'Xã Ea Hiao', '24199', 3, 526),
(8082, 'Xã Ea Khal', '24202', 3, 526),
(8083, 'Xã Dliê Yang', '24205', 3, 526),
(8084, 'Xã Ea Tir', '24207', 3, 526),
(8085, 'Xã Ea Nam', '24208', 3, 526);

-- Tỉnh Đắk Lắk > Huyện Ea Súp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8086, 'Thị trấn Ea Súp', '24211', 3, 527),
(8087, 'Xã Ia Lốp', '24214', 3, 527),
(8088, 'Xã Ia JLơi', '24215', 3, 527),
(8089, 'Xã Ea Rốk', '24217', 3, 527),
(8090, 'Xã Ya Tờ Mốt', '24220', 3, 527),
(8091, 'Xã Ia RVê', '24221', 3, 527),
(8092, 'Xã Ea Lê', '24223', 3, 527),
(8093, 'Xã Cư KBang', '24226', 3, 527),
(8094, 'Xã Ea Bung', '24229', 3, 527),
(8095, 'Xã Cư M''Lan', '24232', 3, 527);

-- Tỉnh Đắk Lắk > Huyện Buôn Đôn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8096, 'Xã Krông Na', '24235', 3, 528),
(8097, 'Xã Ea Huar', '24238', 3, 528),
(8098, 'Xã Ea Wer', '24241', 3, 528),
(8099, 'Xã Tân Hoà', '24244', 3, 528),
(8100, 'Xã Cuôr KNia', '24247', 3, 528),
(8101, 'Xã Ea Bar', '24250', 3, 528),
(8102, 'Xã Ea Nuôl', '24253', 3, 528);

-- Tỉnh Đắk Lắk > Huyện Cư M''gar
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8103, 'Thị trấn Ea Pốk', '24256', 3, 529),
(8104, 'Thị trấn Quảng Phú', '24259', 3, 529),
(8105, 'Xã Quảng Tiến', '24262', 3, 529),
(8106, 'Xã Ea Kuêh', '24264', 3, 529),
(8107, 'Xã Ea Kiết', '24265', 3, 529),
(8108, 'Xã Ea Tar', '24268', 3, 529),
(8109, 'Xã Cư Dliê M''nông', '24271', 3, 529),
(8110, 'Xã Ea H''đinh', '24274', 3, 529),
(8111, 'Xã Ea Tul', '24277', 3, 529),
(8112, 'Xã Ea KPam', '24280', 3, 529),
(8113, 'Xã Ea M''DRóh', '24283', 3, 529),
(8114, 'Xã Quảng Hiệp', '24286', 3, 529),
(8115, 'Xã Cư M''gar', '24289', 3, 529),
(8116, 'Xã Ea D''Rơng', '24292', 3, 529),
(8117, 'Xã Ea M''nang', '24295', 3, 529),
(8118, 'Xã Cư Suê', '24298', 3, 529),
(8119, 'Xã Cuor Đăng', '24301', 3, 529);

-- Tỉnh Đắk Lắk > Huyện Krông Búk
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8120, 'Xã Cư Né', '24307', 3, 530),
(8121, 'Xã Chư KBô', '24310', 3, 530),
(8122, 'Xã Cư Pơng', '24313', 3, 530),
(8123, 'Xã Ea Sin', '24314', 3, 530),
(8124, 'Thị trấn Pơng Drang', '24316', 3, 530),
(8125, 'Xã Tân Lập', '24317', 3, 530),
(8126, 'Xã Ea Ngai', '24319', 3, 530);

-- Tỉnh Đắk Lắk > Huyện Krông Năng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8127, 'Thị trấn Krông Năng', '24343', 3, 531),
(8128, 'Xã ĐLiê Ya', '24346', 3, 531),
(8129, 'Xã Ea Tóh', '24349', 3, 531),
(8130, 'Xã Ea Tam', '24352', 3, 531),
(8131, 'Xã Phú Lộc', '24355', 3, 531),
(8132, 'Xã Tam Giang', '24358', 3, 531),
(8133, 'Xã Ea Puk', '24359', 3, 531),
(8134, 'Xã Ea Dăh', '24360', 3, 531),
(8135, 'Xã Ea Hồ', '24361', 3, 531),
(8136, 'Xã Phú Xuân', '24364', 3, 531),
(8137, 'Xã Cư Klông', '24367', 3, 531),
(8138, 'Xã Ea Tân', '24370', 3, 531);

-- Tỉnh Đắk Lắk > Huyện Ea Kar
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8139, 'Thị trấn Ea Kar', '24373', 3, 532),
(8140, 'Thị trấn Ea Knốp', '24376', 3, 532),
(8141, 'Xã Ea Sô', '24379', 3, 532),
(8142, 'Xã Ea Sar', '24380', 3, 532),
(8143, 'Xã Xuân Phú', '24382', 3, 532),
(8144, 'Xã Cư Huê', '24385', 3, 532),
(8145, 'Xã Ea Tih', '24388', 3, 532),
(8146, 'Xã Ea Đar', '24391', 3, 532),
(8147, 'Xã Ea Kmút', '24394', 3, 532),
(8148, 'Xã Cư Ni', '24397', 3, 532),
(8149, 'Xã Ea Păl', '24400', 3, 532),
(8150, 'Xã Cư Prông', '24401', 3, 532),
(8151, 'Xã Ea Ô', '24403', 3, 532),
(8152, 'Xã Cư ELang', '24404', 3, 532),
(8153, 'Xã Cư Bông', '24406', 3, 532),
(8154, 'Xã Cư Jang', '24409', 3, 532);

-- Tỉnh Đắk Lắk > Huyện M''Đrắk
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8155, 'Thị trấn M''Đrắk', '24412', 3, 533),
(8156, 'Xã Cư Prao', '24415', 3, 533),
(8157, 'Xã Ea Pil', '24418', 3, 533),
(8158, 'Xã Ea Lai', '24421', 3, 533),
(8159, 'Xã Ea H''MLay', '24424', 3, 533),
(8160, 'Xã Krông Jing', '24427', 3, 533),
(8161, 'Xã Ea M'' Doal', '24430', 3, 533),
(8162, 'Xã Ea Riêng', '24433', 3, 533),
(8163, 'Xã Cư M''ta', '24436', 3, 533),
(8164, 'Xã Cư K Róa', '24439', 3, 533),
(8165, 'Xã Krông Á', '24442', 3, 533),
(8166, 'Xã Cư San', '24444', 3, 533),
(8167, 'Xã Ea Trang', '24445', 3, 533);

-- Tỉnh Đắk Lắk > Huyện Krông Bông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8168, 'Thị trấn Krông Kmar', '24448', 3, 534),
(8169, 'Xã Dang Kang', '24451', 3, 534),
(8170, 'Xã Cư KTy', '24454', 3, 534),
(8171, 'Xã Hòa Thành', '24457', 3, 534),
(8172, 'Xã Hòa Phong', '24463', 3, 534),
(8173, 'Xã Hòa Lễ', '24466', 3, 534),
(8174, 'Xã Yang Reh', '24469', 3, 534),
(8175, 'Xã Ea Trul', '24472', 3, 534),
(8176, 'Xã Khuê Ngọc Điền', '24475', 3, 534),
(8177, 'Xã Cư Pui', '24478', 3, 534),
(8178, 'Xã Hòa Sơn', '24481', 3, 534),
(8179, 'Xã Cư Drăm', '24484', 3, 534),
(8180, 'Xã Yang Mao', '24487', 3, 534);

-- Tỉnh Đắk Lắk > Huyện Krông Pắc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8181, 'Thị trấn Phước An', '24490', 3, 535),
(8182, 'Xã KRông Búk', '24493', 3, 535),
(8183, 'Xã Ea Kly', '24496', 3, 535),
(8184, 'Xã Ea Kênh', '24499', 3, 535),
(8185, 'Xã Ea Phê', '24502', 3, 535),
(8186, 'Xã Ea KNuec', '24505', 3, 535),
(8187, 'Xã Ea Yông', '24508', 3, 535),
(8188, 'Xã Hòa An', '24511', 3, 535),
(8189, 'Xã Ea Kuăng', '24514', 3, 535),
(8190, 'Xã Hòa Đông', '24517', 3, 535),
(8191, 'Xã Ea Hiu', '24520', 3, 535),
(8192, 'Xã Hòa Tiến', '24523', 3, 535),
(8193, 'Xã Tân Tiến', '24526', 3, 535),
(8194, 'Xã Vụ Bổn', '24529', 3, 535),
(8195, 'Xã Ea Uy', '24532', 3, 535),
(8196, 'Xã Ea Yiêng', '24535', 3, 535);

-- Tỉnh Đắk Lắk > Huyện Krông A Na
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8197, 'Thị trấn Buôn Trấp', '24538', 3, 536),
(8198, 'Xã Dray Sáp', '24556', 3, 536),
(8199, 'Xã Ea Na', '24559', 3, 536),
(8200, 'Xã Ea Bông', '24565', 3, 536),
(8201, 'Xã Băng A Drênh', '24568', 3, 536),
(8202, 'Xã Dur KMăl', '24571', 3, 536),
(8203, 'Xã Bình Hòa', '24574', 3, 536),
(8204, 'Xã Quảng Điền', '24577', 3, 536);

-- Tỉnh Đắk Lắk > Huyện Lắk
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8205, 'Thị trấn Liên Sơn', '24580', 3, 537),
(8206, 'Xã Yang Tao', '24583', 3, 537),
(8207, 'Xã Bông Krang', '24586', 3, 537),
(8208, 'Xã Đắk Liêng', '24589', 3, 537),
(8209, 'Xã Buôn Triết', '24592', 3, 537),
(8210, 'Xã Buôn Tría', '24595', 3, 537),
(8211, 'Xã Đắk Phơi', '24598', 3, 537),
(8212, 'Xã Đắk Nuê', '24601', 3, 537),
(8213, 'Xã Krông Nô', '24604', 3, 537),
(8214, 'Xã Nam Ka', '24607', 3, 537),
(8215, 'Xã Ea R''Bin', '24610', 3, 537);

-- Tỉnh Đắk Lắk > Huyện Cư Kuin
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8216, 'Xã Ea Ning', '24540', 3, 538),
(8217, 'Xã Cư Ê Wi', '24541', 3, 538),
(8218, 'Xã Ea Ktur', '24544', 3, 538),
(8219, 'Xã Ea Tiêu', '24547', 3, 538),
(8220, 'Xã Ea BHốk', '24550', 3, 538),
(8221, 'Xã Ea Hu', '24553', 3, 538),
(8222, 'Xã Dray Bhăng', '24561', 3, 538),
(8223, 'Xã Hòa Hiệp', '24562', 3, 538);

-- Tỉnh Đắk Nông > Thành phố Gia Nghĩa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8224, 'Phường Nghĩa Đức', '24611', 3, 539),
(8225, 'Phường Nghĩa Thành', '24612', 3, 539),
(8226, 'Phường Nghĩa Phú', '24614', 3, 539),
(8227, 'Phường Nghĩa Tân', '24615', 3, 539),
(8228, 'Phường Nghĩa Trung', '24617', 3, 539),
(8229, 'Xã Đăk R''Moan', '24618', 3, 539),
(8230, 'Phường Quảng Thành', '24619', 3, 539),
(8231, 'Xã Đắk Nia', '24628', 3, 539);

-- Tỉnh Đắk Nông > Huyện Đăk Glong
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8232, 'Xã Quảng Sơn', '24616', 3, 540),
(8233, 'Xã Quảng Hoà', '24620', 3, 540),
(8234, 'Xã Đắk Ha', '24622', 3, 540),
(8235, 'Xã Đắk R''Măng', '24625', 3, 540),
(8236, 'Xã Quảng Khê', '24631', 3, 540),
(8237, 'Xã Đắk Plao', '24634', 3, 540),
(8238, 'Xã Đắk Som', '24637', 3, 540);

-- Tỉnh Đắk Nông > Huyện Cư Jút
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8239, 'Thị trấn Ea T''Ling', '24640', 3, 541),
(8240, 'Xã Đắk Wil', '24643', 3, 541),
(8241, 'Xã Ea Pô', '24646', 3, 541),
(8242, 'Xã Nam Dong', '24649', 3, 541),
(8243, 'Xã Đắk DRông', '24652', 3, 541),
(8244, 'Xã Tâm Thắng', '24655', 3, 541),
(8245, 'Xã Cư Knia', '24658', 3, 541),
(8246, 'Xã Trúc Sơn', '24661', 3, 541);

-- Tỉnh Đắk Nông > Huyện Đắk Mil
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8247, 'Thị trấn Đắk Mil', '24664', 3, 542),
(8248, 'Xã Đắk Lao', '24667', 3, 542),
(8249, 'Xã Đắk R''La', '24670', 3, 542),
(8250, 'Xã Đắk Gằn', '24673', 3, 542),
(8251, 'Xã Đức Mạnh', '24676', 3, 542),
(8252, 'Xã Đắk N''Drót', '24677', 3, 542),
(8253, 'Xã Long Sơn', '24678', 3, 542),
(8254, 'Xã Đắk Sắk', '24679', 3, 542),
(8255, 'Xã Thuận An', '24682', 3, 542),
(8256, 'Xã Đức Minh', '24685', 3, 542);

-- Tỉnh Đắk Nông > Huyện Krông Nô
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8257, 'Thị trấn Đắk Mâm', '24688', 3, 543),
(8258, 'Xã Đắk Sôr', '24691', 3, 543),
(8259, 'Xã Nam Xuân', '24692', 3, 543),
(8260, 'Xã Buôn Choah', '24694', 3, 543),
(8261, 'Xã Nam Đà', '24697', 3, 543),
(8262, 'Xã Tân Thành', '24699', 3, 543),
(8263, 'Xã Đắk Drô', '24700', 3, 543),
(8264, 'Xã Nâm Nung', '24703', 3, 543),
(8265, 'Xã Đức Xuyên', '24706', 3, 543),
(8266, 'Xã Đắk Nang', '24709', 3, 543),
(8267, 'Xã Quảng Phú', '24712', 3, 543),
(8268, 'Xã Nâm N''Đir', '24715', 3, 543);

-- Tỉnh Đắk Nông > Huyện Đắk Song
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8269, 'Thị trấn Đức An', '24717', 3, 544),
(8270, 'Xã Đắk Môl', '24718', 3, 544),
(8271, 'Xã Đắk Hòa', '24719', 3, 544),
(8272, 'Xã Nam Bình', '24721', 3, 544),
(8273, 'Xã Thuận Hà', '24722', 3, 544),
(8274, 'Xã Thuận Hạnh', '24724', 3, 544),
(8275, 'Xã Đắk N''Dung', '24727', 3, 544),
(8276, 'Xã Nâm N''Jang', '24728', 3, 544),
(8277, 'Xã Trường Xuân', '24730', 3, 544);

-- Tỉnh Đắk Nông > Huyện Đắk R''Lấp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8278, 'Thị trấn Kiến Đức', '24733', 3, 545),
(8279, 'Xã Quảng Tín', '24745', 3, 545),
(8280, 'Xã Đắk Wer', '24750', 3, 545),
(8281, 'Xã Nhân Cơ', '24751', 3, 545),
(8282, 'Xã Kiến Thành', '24754', 3, 545),
(8283, 'Xã Nghĩa Thắng', '24756', 3, 545),
(8284, 'Xã Đạo Nghĩa', '24757', 3, 545),
(8285, 'Xã Đắk Sin', '24760', 3, 545),
(8286, 'Xã Hưng Bình', '24761', 3, 545),
(8287, 'Xã Đắk Ru', '24763', 3, 545),
(8288, 'Xã Nhân Đạo', '24766', 3, 545);

-- Tỉnh Đắk Nông > Huyện Tuy Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8289, 'Xã Quảng Trực', '24736', 3, 546),
(8290, 'Xã Đắk Búk So', '24739', 3, 546),
(8291, 'Xã Quảng Tâm', '24740', 3, 546),
(8292, 'Xã Đắk R''Tíh', '24742', 3, 546),
(8293, 'Xã Đắk Ngo', '24746', 3, 546),
(8294, 'Xã Quảng Tân', '24748', 3, 546);

-- Tỉnh Lâm Đồng > Thành phố Đà Lạt
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8295, 'Phường 7', '24769', 3, 547),
(8296, 'Phường 8', '24772', 3, 547),
(8297, 'Phường 12', '24775', 3, 547),
(8298, 'Phường 9', '24778', 3, 547),
(8299, 'Phường 2', '24781', 3, 547),
(8300, 'Phường 1', '24784', 3, 547),
(8301, 'Phường 6', '24787', 3, 547),
(8302, 'Phường 5', '24790', 3, 547),
(8303, 'Phường 4', '24793', 3, 547),
(8304, 'Phường 10', '24796', 3, 547),
(8305, 'Phường 11', '24799', 3, 547),
(8306, 'Phường 3', '24802', 3, 547),
(8307, 'Xã Xuân Thọ', '24805', 3, 547),
(8308, 'Xã Tà Nung', '24808', 3, 547),
(8309, 'Xã Trạm Hành', '24810', 3, 547),
(8310, 'Xã Xuân Trường', '24811', 3, 547);

-- Tỉnh Lâm Đồng > Thành phố Bảo Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8311, 'Phường Lộc Phát', '24814', 3, 548),
(8312, 'Phường Lộc Tiến', '24817', 3, 548),
(8313, 'Phường 2', '24820', 3, 548),
(8314, 'Phường 1', '24823', 3, 548),
(8315, 'Phường B''lao', '24826', 3, 548),
(8316, 'Phường Lộc Sơn', '24829', 3, 548),
(8317, 'Xã Đạm Bri', '24832', 3, 548),
(8318, 'Xã Lộc Thanh', '24835', 3, 548),
(8319, 'Xã Lộc Nga', '24838', 3, 548),
(8320, 'Xã Lộc Châu', '24841', 3, 548),
(8321, 'Xã Đại Lào', '24844', 3, 548);

-- Tỉnh Lâm Đồng > Huyện Đam Rông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8322, 'Xã Đạ Tông', '24853', 3, 549),
(8323, 'Xã Đạ Long', '24856', 3, 549),
(8324, 'Xã Đạ M'' Rong', '24859', 3, 549),
(8325, 'Xã Liêng Srônh', '24874', 3, 549),
(8326, 'Xã Đạ Rsal', '24875', 3, 549),
(8327, 'Xã Rô Men', '24877', 3, 549),
(8328, 'Xã Phi Liêng', '24886', 3, 549),
(8329, 'Xã Đạ K'' Nàng', '24889', 3, 549);

-- Tỉnh Lâm Đồng > Huyện Lạc Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8330, 'Thị trấn Lạc Dương', '24846', 3, 550),
(8331, 'Xã Đạ Chais', '24847', 3, 550),
(8332, 'Xã Đạ Nhim', '24848', 3, 550),
(8333, 'Xã Đưng KNớ', '24850', 3, 550),
(8334, 'Xã Lát', '24862', 3, 550),
(8335, 'Xã Đạ Sar', '24865', 3, 550);

-- Tỉnh Lâm Đồng > Huyện Lâm Hà
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8336, 'Thị trấn Nam Ban', '24868', 3, 551),
(8337, 'Thị trấn Đinh Văn', '24871', 3, 551),
(8338, 'Xã Phú Sơn', '24880', 3, 551),
(8339, 'Xã Phi Tô', '24883', 3, 551),
(8340, 'Xã Mê Linh', '24892', 3, 551),
(8341, 'Xã Đạ Đờn', '24895', 3, 551),
(8342, 'Xã Phúc Thọ', '24898', 3, 551),
(8343, 'Xã Đông Thanh', '24901', 3, 551),
(8344, 'Xã Gia Lâm', '24904', 3, 551),
(8345, 'Xã Tân Thanh', '24907', 3, 551),
(8346, 'Xã Tân Văn', '24910', 3, 551),
(8347, 'Xã Hoài Đức', '24913', 3, 551),
(8348, 'Xã Tân Hà', '24916', 3, 551),
(8349, 'Xã Liên Hà', '24919', 3, 551),
(8350, 'Xã Đan Phượng', '24922', 3, 551),
(8351, 'Xã Nam Hà', '24925', 3, 551);

-- Tỉnh Lâm Đồng > Huyện Đơn Dương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8352, 'Thị trấn D''Ran', '24928', 3, 552),
(8353, 'Thị trấn Thạnh Mỹ', '24931', 3, 552),
(8354, 'Xã Lạc Xuân', '24934', 3, 552),
(8355, 'Xã Đạ Ròn', '24937', 3, 552),
(8356, 'Xã Lạc Lâm', '24940', 3, 552),
(8357, 'Xã Ka Đô', '24943', 3, 552),
(8358, 'Xã Ka Đơn', '24949', 3, 552),
(8359, 'Xã Tu Tra', '24952', 3, 552),
(8360, 'Xã Quảng Lập', '24955', 3, 552);

-- Tỉnh Lâm Đồng > Huyện Đức Trọng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8361, 'Thị trấn Liên Nghĩa', '24958', 3, 553),
(8362, 'Xã Hiệp An', '24961', 3, 553),
(8363, 'Xã Liên Hiệp', '24964', 3, 553),
(8364, 'Xã Hiệp Thạnh', '24967', 3, 553),
(8365, 'Xã Bình Thạnh', '24970', 3, 553),
(8366, 'Xã N''Thol Hạ', '24973', 3, 553),
(8367, 'Xã Tân Hội', '24976', 3, 553),
(8368, 'Xã Tân Thành', '24979', 3, 553),
(8369, 'Xã Phú Hội', '24982', 3, 553),
(8370, 'Xã Ninh Gia', '24985', 3, 553),
(8371, 'Xã Tà Năng', '24988', 3, 553),
(8372, 'Xã Đa Quyn', '24989', 3, 553),
(8373, 'Xã Tà Hine', '24991', 3, 553),
(8374, 'Xã Đà Loan', '24994', 3, 553),
(8375, 'Xã Ninh Loan', '24997', 3, 553);

-- Tỉnh Lâm Đồng > Huyện Di Linh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8376, 'Thị trấn Di Linh', '25000', 3, 554),
(8377, 'Xã Đinh Trang Thượng', '25003', 3, 554),
(8378, 'Xã Tân Thượng', '25006', 3, 554),
(8379, 'Xã Tân Lâm', '25007', 3, 554),
(8380, 'Xã Tân Châu', '25009', 3, 554),
(8381, 'Xã Tân Nghĩa', '25012', 3, 554),
(8382, 'Xã Gia Hiệp', '25015', 3, 554),
(8383, 'Xã Đinh Lạc', '25018', 3, 554),
(8384, 'Xã Tam Bố', '25021', 3, 554),
(8385, 'Xã Đinh Trang Hòa', '25024', 3, 554),
(8386, 'Xã Liên Đầm', '25027', 3, 554),
(8387, 'Xã Gung Ré', '25030', 3, 554),
(8388, 'Xã Bảo Thuận', '25033', 3, 554),
(8389, 'Xã Hòa Ninh', '25036', 3, 554),
(8390, 'Xã Hòa Trung', '25039', 3, 554),
(8391, 'Xã Hòa Nam', '25042', 3, 554),
(8392, 'Xã Hòa Bắc', '25045', 3, 554),
(8393, 'Xã Sơn Điền', '25048', 3, 554),
(8394, 'Xã Gia Bắc', '25051', 3, 554);

-- Tỉnh Lâm Đồng > Huyện Bảo Lâm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8395, 'Thị trấn Lộc Thắng', '25054', 3, 555),
(8396, 'Xã Lộc Bảo', '25057', 3, 555),
(8397, 'Xã Lộc Lâm', '25060', 3, 555),
(8398, 'Xã Lộc Phú', '25063', 3, 555),
(8399, 'Xã Lộc Bắc', '25066', 3, 555),
(8400, 'Xã B'' Lá', '25069', 3, 555),
(8401, 'Xã Lộc Ngãi', '25072', 3, 555),
(8402, 'Xã Lộc Quảng', '25075', 3, 555),
(8403, 'Xã Lộc Tân', '25078', 3, 555),
(8404, 'Xã Lộc Đức', '25081', 3, 555),
(8405, 'Xã Lộc An', '25084', 3, 555),
(8406, 'Xã Tân Lạc', '25087', 3, 555),
(8407, 'Xã Lộc Thành', '25090', 3, 555),
(8408, 'Xã Lộc Nam', '25093', 3, 555);

-- Tỉnh Lâm Đồng > Huyện Đạ Huoai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8409, 'Thị trấn Đạ M''ri', '25096', 3, 556),
(8410, 'Thị trấn Ma Đa Guôi', '25099', 3, 556),
(8411, 'Xã Đạ M''ri', '25102', 3, 556),
(8412, 'Xã Hà Lâm', '25105', 3, 556),
(8413, 'Xã Đạ Oai', '25111', 3, 556),
(8414, 'Xã Bà Gia', '25114', 3, 556),
(8415, 'Xã Ma Đa Guôi', '25117', 3, 556),
(8416, 'Thị trấn Đạ Tẻh', '25126', 3, 556),
(8417, 'Xã An Nhơn', '25129', 3, 556),
(8418, 'Xã Quốc Oai', '25132', 3, 556),
(8419, 'Xã Mỹ Đức', '25135', 3, 556),
(8420, 'Xã Quảng Trị', '25138', 3, 556),
(8421, 'Xã Đạ Lây', '25141', 3, 556),
(8422, 'Xã Đạ Kho', '25153', 3, 556),
(8423, 'Xã Đạ Pal', '25156', 3, 556),
(8424, 'Thị trấn Cát Tiên', '25159', 3, 556),
(8425, 'Xã Tiên Hoàng', '25162', 3, 556),
(8426, 'Xã Phước Cát 2', '25165', 3, 556),
(8427, 'Xã Gia Viễn', '25168', 3, 556),
(8428, 'Xã Nam Ninh', '25171', 3, 556),
(8429, 'Xã Mỹ Lâm', '25174', 3, 556),
(8430, 'Xã Tư Nghĩa', '25177', 3, 556),
(8431, 'Thị trấn Phước Cát', '25180', 3, 556),
(8432, 'Xã Đức Phổ', '25183', 3, 556),
(8433, 'Xã Phù Mỹ', '25186', 3, 556),
(8434, 'Xã Quảng Ngãi', '25189', 3, 556),
(8435, 'Xã Đồng Nai Thượng', '25192', 3, 556);

-- Tỉnh Bình Phước > Thị xã Phước Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8436, 'Phường Thác Mơ', '25216', 3, 557),
(8437, 'Phường Long Thủy', '25217', 3, 557),
(8438, 'Phường Phước Bình', '25219', 3, 557),
(8439, 'Phường Long Phước', '25220', 3, 557),
(8440, 'Phường Sơn Giang', '25237', 3, 557),
(8441, 'Xã Long Giang', '25245', 3, 557),
(8442, 'Xã Phước Tín', '25249', 3, 557);

-- Tỉnh Bình Phước > Thành phố Đồng Xoài
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8443, 'Phường Tân Phú', '25195', 3, 558),
(8444, 'Phường Tân Đồng', '25198', 3, 558),
(8445, 'Phường Tân Bình', '25201', 3, 558),
(8446, 'Phường Tân Xuân', '25204', 3, 558),
(8447, 'Phường Tân Thiện', '25205', 3, 558),
(8448, 'Xã Tân Thành', '25207', 3, 558),
(8449, 'Phường Tiến Thành', '25210', 3, 558),
(8450, 'Xã Tiến Hưng', '25213', 3, 558);

-- Tỉnh Bình Phước > Thị xã Bình Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8451, 'Phường Hưng Chiến', '25320', 3, 559),
(8452, 'Phường An Lộc', '25324', 3, 559),
(8453, 'Phường Phú Thịnh', '25325', 3, 559),
(8454, 'Phường Phú Đức', '25326', 3, 559),
(8455, 'Xã Thanh Lương', '25333', 3, 559),
(8456, 'Xã Thanh Phú', '25336', 3, 559);

-- Tỉnh Bình Phước > Huyện Bù Gia Mập
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8457, 'Xã Bù Gia Mập', '25222', 3, 560),
(8458, 'Xã Đak Ơ', '25225', 3, 560),
(8459, 'Xã Đức Hạnh', '25228', 3, 560),
(8460, 'Xã Phú Văn', '25229', 3, 560),
(8461, 'Xã Đa Kia', '25231', 3, 560),
(8462, 'Xã Phước Minh', '25232', 3, 560),
(8463, 'Xã Bình Thắng', '25234', 3, 560),
(8464, 'Xã Phú Nghĩa', '25267', 3, 560);

-- Tỉnh Bình Phước > Huyện Lộc Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8465, 'Thị trấn Lộc Ninh', '25270', 3, 561),
(8466, 'Xã Lộc Hòa', '25273', 3, 561),
(8467, 'Xã Lộc An', '25276', 3, 561),
(8468, 'Xã Lộc Tấn', '25279', 3, 561),
(8469, 'Xã Lộc Thạnh', '25280', 3, 561),
(8470, 'Xã Lộc Hiệp', '25282', 3, 561),
(8471, 'Xã Lộc Thiện', '25285', 3, 561),
(8472, 'Xã Lộc Thuận', '25288', 3, 561),
(8473, 'Xã Lộc Quang', '25291', 3, 561),
(8474, 'Xã Lộc Phú', '25292', 3, 561),
(8475, 'Xã Lộc Thành', '25294', 3, 561),
(8476, 'Xã Lộc Thái', '25297', 3, 561),
(8477, 'Xã Lộc Điền', '25300', 3, 561),
(8478, 'Xã Lộc Hưng', '25303', 3, 561),
(8479, 'Xã Lộc Thịnh', '25305', 3, 561),
(8480, 'Xã Lộc Khánh', '25306', 3, 561);

-- Tỉnh Bình Phước > Huyện Bù Đốp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8481, 'Thị trấn Thanh Bình', '25308', 3, 562),
(8482, 'Xã Hưng Phước', '25309', 3, 562),
(8483, 'Xã Phước Thiện', '25310', 3, 562),
(8484, 'Xã Thiện Hưng', '25312', 3, 562),
(8485, 'Xã Thanh Hòa', '25315', 3, 562),
(8486, 'Xã Tân Thành', '25318', 3, 562),
(8487, 'Xã Tân Tiến', '25321', 3, 562);

-- Tỉnh Bình Phước > Huyện Hớn Quản
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8488, 'Xã Thanh An', '25327', 3, 563),
(8489, 'Xã An Khương', '25330', 3, 563),
(8490, 'Xã An Phú', '25339', 3, 563),
(8491, 'Xã Tân Lợi', '25342', 3, 563),
(8492, 'Xã Tân Hưng', '25345', 3, 563),
(8493, 'Xã Minh Đức', '25348', 3, 563),
(8494, 'Xã Minh Tâm', '25349', 3, 563),
(8495, 'Xã Phước An', '25351', 3, 563),
(8496, 'Xã Thanh Bình', '25354', 3, 563),
(8497, 'Thị trấn Tân Khai', '25357', 3, 563),
(8498, 'Xã Đồng Nơ', '25360', 3, 563),
(8499, 'Xã Tân Hiệp', '25361', 3, 563),
(8500, 'Xã Tân Quan', '25438', 3, 563);

-- Tỉnh Bình Phước > Huyện Đồng Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8501, 'Thị trấn Tân Phú', '25363', 3, 564),
(8502, 'Xã Thuận Lợi', '25366', 3, 564),
(8503, 'Xã Đồng Tâm', '25369', 3, 564),
(8504, 'Xã Tân Phước', '25372', 3, 564),
(8505, 'Xã Tân Hưng', '25375', 3, 564),
(8506, 'Xã Tân Lợi', '25378', 3, 564),
(8507, 'Xã Tân Lập', '25381', 3, 564),
(8508, 'Xã Tân Hòa', '25384', 3, 564),
(8509, 'Xã Thuận Phú', '25387', 3, 564),
(8510, 'Xã Đồng Tiến', '25390', 3, 564),
(8511, 'Xã Tân Tiến', '25393', 3, 564);

-- Tỉnh Bình Phước > Huyện Bù Đăng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8512, 'Thị trấn Đức Phong', '25396', 3, 565),
(8513, 'Xã Đường 10', '25398', 3, 565),
(8514, 'Xã Đak Nhau', '25399', 3, 565),
(8515, 'Xã Phú Sơn', '25400', 3, 565),
(8516, 'Xã Thọ Sơn', '25402', 3, 565),
(8517, 'Xã Bình Minh', '25404', 3, 565),
(8518, 'Xã Bom Bo', '25405', 3, 565),
(8519, 'Xã Minh Hưng', '25408', 3, 565),
(8520, 'Xã Đoàn Kết', '25411', 3, 565),
(8521, 'Xã Đồng Nai', '25414', 3, 565),
(8522, 'Xã Đức Liễu', '25417', 3, 565),
(8523, 'Xã Thống Nhất', '25420', 3, 565),
(8524, 'Xã Nghĩa Trung', '25423', 3, 565),
(8525, 'Xã Nghĩa Bình', '25424', 3, 565),
(8526, 'Xã Đăng Hà', '25426', 3, 565),
(8527, 'Xã Phước Sơn', '25429', 3, 565);

-- Tỉnh Bình Phước > Thị xã Chơn Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8528, 'Phường Hưng Long', '25432', 3, 566),
(8529, 'Phường Thành Tâm', '25433', 3, 566),
(8530, 'Xã Minh Lập', '25435', 3, 566),
(8531, 'Xã Quang Minh', '25439', 3, 566),
(8532, 'Phường Minh Hưng', '25441', 3, 566),
(8533, 'Phường Minh Long', '25444', 3, 566),
(8534, 'Phường Minh Thành', '25447', 3, 566),
(8535, 'Xã Nha Bích', '25450', 3, 566),
(8536, 'Xã Minh Thắng', '25453', 3, 566);

-- Tỉnh Bình Phước > Huyện Phú Riềng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8537, 'Xã Long Bình', '25240', 3, 567),
(8538, 'Xã Bình Tân', '25243', 3, 567),
(8539, 'Xã Bình Sơn', '25244', 3, 567),
(8540, 'Xã Long Hưng', '25246', 3, 567),
(8541, 'Xã Phước Tân', '25250', 3, 567),
(8542, 'Xã Bù Nho', '25252', 3, 567),
(8543, 'Xã Long Hà', '25255', 3, 567),
(8544, 'Xã Long Tân', '25258', 3, 567),
(8545, 'Xã Phú Trung', '25261', 3, 567),
(8546, 'Xã Phú Riềng', '25264', 3, 567);

-- Tỉnh Tây Ninh > Thành phố Tây Ninh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8547, 'Phường 1', '25456', 3, 568),
(8548, 'Phường 3', '25459', 3, 568),
(8549, 'Phường 4', '25462', 3, 568),
(8550, 'Phường Hiệp Ninh', '25465', 3, 568),
(8551, 'Phường 2', '25468', 3, 568),
(8552, 'Xã Thạnh Tân', '25471', 3, 568),
(8553, 'Xã Tân Bình', '25474', 3, 568),
(8554, 'Xã Bình Minh', '25477', 3, 568),
(8555, 'Phường Ninh Sơn', '25480', 3, 568),
(8556, 'Phường Ninh Thạnh', '25483', 3, 568);

-- Tỉnh Tây Ninh > Huyện Tân Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8557, 'Thị trấn Tân Biên', '25486', 3, 569),
(8558, 'Xã Tân Lập', '25489', 3, 569),
(8559, 'Xã Thạnh Bắc', '25492', 3, 569),
(8560, 'Xã Tân Bình', '25495', 3, 569),
(8561, 'Xã Thạnh Bình', '25498', 3, 569),
(8562, 'Xã Thạnh Tây', '25501', 3, 569),
(8563, 'Xã Hòa Hiệp', '25504', 3, 569),
(8564, 'Xã Tân Phong', '25507', 3, 569),
(8565, 'Xã Mỏ Công', '25510', 3, 569),
(8566, 'Xã Trà Vong', '25513', 3, 569);

-- Tỉnh Tây Ninh > Huyện Tân Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8567, 'Thị trấn Tân Châu', '25516', 3, 570),
(8568, 'Xã Tân Hà', '25519', 3, 570),
(8569, 'Xã Tân Đông', '25522', 3, 570),
(8570, 'Xã Tân Hội', '25525', 3, 570),
(8571, 'Xã Tân Hòa', '25528', 3, 570),
(8572, 'Xã Suối Ngô', '25531', 3, 570),
(8573, 'Xã Suối Dây', '25534', 3, 570),
(8574, 'Xã Tân Hiệp', '25537', 3, 570),
(8575, 'Xã Thạnh Đông', '25540', 3, 570),
(8576, 'Xã Tân Thành', '25543', 3, 570),
(8577, 'Xã Tân Phú', '25546', 3, 570),
(8578, 'Xã Tân Hưng', '25549', 3, 570);

-- Tỉnh Tây Ninh > Huyện Dương Minh Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8579, 'Thị trấn Dương Minh Châu', '25552', 3, 571),
(8580, 'Xã Suối Đá', '25555', 3, 571),
(8581, 'Xã Phan', '25558', 3, 571),
(8582, 'Xã Phước Ninh', '25561', 3, 571),
(8583, 'Xã Phước Minh', '25564', 3, 571),
(8584, 'Xã Bàu Năng', '25567', 3, 571),
(8585, 'Xã Chà Là', '25570', 3, 571),
(8586, 'Xã Cầu Khởi', '25573', 3, 571),
(8587, 'Xã Bến Củi', '25576', 3, 571),
(8588, 'Xã Lộc Ninh', '25579', 3, 571),
(8589, 'Xã Truông Mít', '25582', 3, 571);

-- Tỉnh Tây Ninh > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8590, 'Thị trấn Châu Thành', '25585', 3, 572),
(8591, 'Xã Hảo Đước', '25588', 3, 572),
(8592, 'Xã Phước Vinh', '25591', 3, 572),
(8593, 'Xã Đồng Khởi', '25594', 3, 572),
(8594, 'Xã Thái Bình', '25597', 3, 572),
(8595, 'Xã An Cơ', '25600', 3, 572),
(8596, 'Xã Biên Giới', '25603', 3, 572),
(8597, 'Xã Hòa Thạnh', '25606', 3, 572),
(8598, 'Xã Trí Bình', '25609', 3, 572),
(8599, 'Xã Hòa Hội', '25612', 3, 572),
(8600, 'Xã An Bình', '25615', 3, 572),
(8601, 'Xã Thanh Điền', '25618', 3, 572),
(8602, 'Xã Thành Long', '25621', 3, 572),
(8603, 'Xã Ninh Điền', '25624', 3, 572),
(8604, 'Xã Long Vĩnh', '25627', 3, 572);

-- Tỉnh Tây Ninh > Thị xã Hòa Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8605, 'Phường Long Hoa', '25630', 3, 573),
(8606, 'Phường Hiệp Tân', '25633', 3, 573),
(8607, 'Phường Long Thành Bắc', '25636', 3, 573),
(8608, 'Xã Trường Hòa', '25639', 3, 573),
(8609, 'Xã Trường Đông', '25642', 3, 573),
(8610, 'Phường Long Thành Trung', '25645', 3, 573),
(8611, 'Xã Trường Tây', '25648', 3, 573),
(8612, 'Xã Long Thành Nam', '25651', 3, 573);

-- Tỉnh Tây Ninh > Huyện Gò Dầu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8613, 'Thị trấn Gò Dầu', '25654', 3, 574),
(8614, 'Xã Thạnh Đức', '25657', 3, 574),
(8615, 'Xã Cẩm Giang', '25660', 3, 574),
(8616, 'Xã Hiệp Thạnh', '25663', 3, 574),
(8617, 'Xã Bàu Đồn', '25666', 3, 574),
(8618, 'Xã Phước Thạnh', '25669', 3, 574),
(8619, 'Xã Phước Đông', '25672', 3, 574),
(8620, 'Xã Phước Trạch', '25675', 3, 574),
(8621, 'Xã Thanh Phước', '25678', 3, 574);

-- Tỉnh Tây Ninh > Huyện Bến Cầu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8622, 'Thị trấn Bến Cầu', '25681', 3, 575),
(8623, 'Xã Long Chữ', '25684', 3, 575),
(8624, 'Xã Long Phước', '25687', 3, 575),
(8625, 'Xã Long Giang', '25690', 3, 575),
(8626, 'Xã Tiên Thuận', '25693', 3, 575),
(8627, 'Xã Long Khánh', '25696', 3, 575),
(8628, 'Xã Lợi Thuận', '25699', 3, 575),
(8629, 'Xã Long Thuận', '25702', 3, 575),
(8630, 'Xã An Thạnh', '25705', 3, 575);

-- Tỉnh Tây Ninh > Thị xã Trảng Bàng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8631, 'Phường Trảng Bàng', '25708', 3, 576),
(8632, 'Xã Đôn Thuận', '25711', 3, 576),
(8633, 'Xã Hưng Thuận', '25714', 3, 576),
(8634, 'Phường Lộc Hưng', '25717', 3, 576),
(8635, 'Phường Gia Lộc', '25720', 3, 576),
(8636, 'Phường Gia Bình', '25723', 3, 576),
(8637, 'Xã Phước Bình', '25729', 3, 576),
(8638, 'Phường An Tịnh', '25732', 3, 576),
(8639, 'Phường An Hòa', '25735', 3, 576),
(8640, 'Xã Phước Chỉ', '25738', 3, 576);

-- Tỉnh Bình Dương > Thành phố Thủ Dầu Một
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8641, 'Phường Hiệp Thành', '25741', 3, 577),
(8642, 'Phường Phú Lợi', '25744', 3, 577),
(8643, 'Phường Phú Cường', '25747', 3, 577),
(8644, 'Phường Phú Hòa', '25750', 3, 577),
(8645, 'Phường Phú Thọ', '25753', 3, 577),
(8646, 'Phường Chánh Nghĩa', '25756', 3, 577),
(8647, 'Phường Định Hoà', '25759', 3, 577),
(8648, 'Phường Hoà Phú', '25760', 3, 577),
(8649, 'Phường Phú Mỹ', '25762', 3, 577),
(8650, 'Phường Phú Tân', '25763', 3, 577),
(8651, 'Phường Tân An', '25765', 3, 577),
(8652, 'Phường Hiệp An', '25768', 3, 577),
(8653, 'Phường Tương Bình Hiệp', '25771', 3, 577),
(8654, 'Phường Chánh Mỹ', '25774', 3, 577);

-- Tỉnh Bình Dương > Huyện Bàu Bàng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8655, 'Xã Trừ Văn Thố', '25816', 3, 578),
(8656, 'Xã Cây Trường II', '25819', 3, 578),
(8657, 'Thị trấn Lai Uyên', '25822', 3, 578),
(8658, 'Xã Tân Hưng', '25825', 3, 578),
(8659, 'Xã Long Nguyên', '25828', 3, 578),
(8660, 'Xã Hưng Hòa', '25831', 3, 578),
(8661, 'Xã Lai Hưng', '25834', 3, 578);

-- Tỉnh Bình Dương > Huyện Dầu Tiếng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8662, 'Thị trấn Dầu Tiếng', '25777', 3, 579),
(8663, 'Xã Minh Hoà', '25780', 3, 579),
(8664, 'Xã Minh Thạnh', '25783', 3, 579),
(8665, 'Xã Minh Tân', '25786', 3, 579),
(8666, 'Xã Định An', '25789', 3, 579),
(8667, 'Xã Long Hoà', '25792', 3, 579),
(8668, 'Xã Định Thành', '25795', 3, 579),
(8669, 'Xã Định Hiệp', '25798', 3, 579),
(8670, 'Xã An Lập', '25801', 3, 579),
(8671, 'Xã Long Tân', '25804', 3, 579),
(8672, 'Xã Thanh An', '25807', 3, 579),
(8673, 'Xã Thanh Tuyền', '25810', 3, 579);

-- Tỉnh Bình Dương > Thành phố Bến Cát
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8674, 'Phường Mỹ Phước', '25813', 3, 580),
(8675, 'Phường Chánh Phú Hòa', '25837', 3, 580),
(8676, 'Phường An Điền', '25840', 3, 580),
(8677, 'Phường An Tây', '25843', 3, 580),
(8678, 'Phường Thới Hòa', '25846', 3, 580),
(8679, 'Phường Hòa Lợi', '25849', 3, 580),
(8680, 'Phường Tân Định', '25852', 3, 580),
(8681, 'Xã Phú An', '25855', 3, 580);

-- Tỉnh Bình Dương > Huyện Phú Giáo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8682, 'Thị trấn Phước Vĩnh', '25858', 3, 581),
(8683, 'Xã An Linh', '25861', 3, 581),
(8684, 'Xã Phước Sang', '25864', 3, 581),
(8685, 'Xã An Thái', '25865', 3, 581),
(8686, 'Xã An Long', '25867', 3, 581),
(8687, 'Xã An Bình', '25870', 3, 581),
(8688, 'Xã Tân Hiệp', '25873', 3, 581),
(8689, 'Xã Tam Lập', '25876', 3, 581),
(8690, 'Xã Tân Long', '25879', 3, 581),
(8691, 'Xã Vĩnh Hoà', '25882', 3, 581),
(8692, 'Xã Phước Hoà', '25885', 3, 581);

-- Tỉnh Bình Dương > Thành phố Tân Uyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8693, 'Phường Uyên Hưng', '25888', 3, 582),
(8694, 'Phường Tân Phước Khánh', '25891', 3, 582),
(8695, 'Phường Vĩnh Tân', '25912', 3, 582),
(8696, 'Phường Hội Nghĩa', '25915', 3, 582),
(8697, 'Phường Tân Hiệp', '25920', 3, 582),
(8698, 'Phường Khánh Bình', '25921', 3, 582),
(8699, 'Phường Phú Chánh', '25924', 3, 582),
(8700, 'Xã Bạch Đằng', '25930', 3, 582),
(8701, 'Phường Tân Vĩnh Hiệp', '25933', 3, 582),
(8702, 'Phường Thạnh Phước', '25936', 3, 582),
(8703, 'Xã Thạnh Hội', '25937', 3, 582),
(8704, 'Phường Thái Hòa', '25939', 3, 582);

-- Tỉnh Bình Dương > Thành phố Dĩ An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8705, 'Phường Dĩ An', '25942', 3, 583),
(8706, 'Phường Tân Bình', '25945', 3, 583),
(8707, 'Phường Tân Đông Hiệp', '25948', 3, 583),
(8708, 'Phường Bình An', '25951', 3, 583),
(8709, 'Phường Bình Thắng', '25954', 3, 583),
(8710, 'Phường Đông Hòa', '25957', 3, 583),
(8711, 'Phường An Bình', '25960', 3, 583);

-- Tỉnh Bình Dương > Thành phố Thuận An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8712, 'Phường An Thạnh', '25963', 3, 584),
(8713, 'Phường Lái Thiêu', '25966', 3, 584),
(8714, 'Phường Bình Chuẩn', '25969', 3, 584),
(8715, 'Phường Thuận Giao', '25972', 3, 584),
(8716, 'Phường An Phú', '25975', 3, 584),
(8717, 'Phường Hưng Định', '25978', 3, 584),
(8718, 'Xã An Sơn', '25981', 3, 584),
(8719, 'Phường Bình Nhâm', '25984', 3, 584),
(8720, 'Phường Bình Hòa', '25987', 3, 584),
(8721, 'Phường Vĩnh Phú', '25990', 3, 584);

-- Tỉnh Bình Dương > Huyện Bắc Tân Uyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8722, 'Xã Tân Định', '25894', 3, 585),
(8723, 'Xã Bình Mỹ', '25897', 3, 585),
(8724, 'Thị trấn Tân Bình', '25900', 3, 585),
(8725, 'Xã Tân Lập', '25903', 3, 585),
(8726, 'Thị trấn Tân Thành', '25906', 3, 585),
(8727, 'Xã Đất Cuốc', '25907', 3, 585),
(8728, 'Xã Hiếu Liêm', '25908', 3, 585),
(8729, 'Xã Lạc An', '25909', 3, 585),
(8730, 'Xã Tân Mỹ', '25918', 3, 585),
(8731, 'Xã Thường Tân', '25927', 3, 585);

-- Tỉnh Đồng Nai > Thành phố Biên Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8732, 'Phường Trảng Dài', '25993', 3, 586),
(8733, 'Phường Tân Phong', '25996', 3, 586),
(8734, 'Phường Tân Biên', '25999', 3, 586),
(8735, 'Phường Hố Nai', '26002', 3, 586),
(8736, 'Phường Tân Hòa', '26005', 3, 586),
(8737, 'Phường Tân Hiệp', '26008', 3, 586),
(8738, 'Phường Bửu Long', '26011', 3, 586),
(8739, 'Phường Tân Mai', '26014', 3, 586),
(8740, 'Phường Tam Hiệp', '26017', 3, 586),
(8741, 'Phường Long Bình', '26020', 3, 586),
(8742, 'Phường Quang Vinh', '26023', 3, 586),
(8743, 'Phường Thống Nhất', '26029', 3, 586),
(8744, 'Phường Trung Dũng', '26041', 3, 586),
(8745, 'Phường Bình Đa', '26047', 3, 586),
(8746, 'Phường An Bình', '26050', 3, 586),
(8747, 'Phường Bửu Hòa', '26053', 3, 586),
(8748, 'Phường Long Bình Tân', '26056', 3, 586),
(8749, 'Phường Tân Vạn', '26059', 3, 586),
(8750, 'Phường Tân Hạnh', '26062', 3, 586),
(8751, 'Phường Hiệp Hòa', '26065', 3, 586),
(8752, 'Phường Hóa An', '26068', 3, 586),
(8753, 'Phường An Hòa', '26371', 3, 586),
(8754, 'Phường Tam Phước', '26374', 3, 586),
(8755, 'Phường Phước Tân', '26377', 3, 586),
(8756, 'Xã Long Hưng', '26380', 3, 586);

-- Tỉnh Đồng Nai > Thành phố Long Khánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8757, 'Phường Xuân Bình', '26077', 3, 587),
(8758, 'Phường Xuân An', '26080', 3, 587),
(8759, 'Phường Xuân Hoà', '26083', 3, 587),
(8760, 'Phường Phú Bình', '26086', 3, 587),
(8761, 'Xã Bình Lộc', '26089', 3, 587),
(8762, 'Xã Bảo Quang', '26092', 3, 587),
(8763, 'Phường Suối Tre', '26095', 3, 587),
(8764, 'Phường Bảo Vinh', '26098', 3, 587),
(8765, 'Phường Xuân Lập', '26101', 3, 587),
(8766, 'Phường Bàu Sen', '26104', 3, 587),
(8767, 'Xã Bàu Trâm', '26107', 3, 587),
(8768, 'Phường Xuân Tân', '26110', 3, 587),
(8769, 'Xã Hàng Gòn', '26113', 3, 587);

-- Tỉnh Đồng Nai > Huyện Tân Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8770, 'Thị trấn Tân Phú', '26116', 3, 588),
(8771, 'Xã Dak Lua', '26119', 3, 588),
(8772, 'Xã Nam Cát Tiên', '26122', 3, 588),
(8773, 'Xã Phú An', '26125', 3, 588),
(8774, 'Xã Tà Lài', '26131', 3, 588),
(8775, 'Xã Phú Lập', '26134', 3, 588),
(8776, 'Xã Phú Thịnh', '26140', 3, 588),
(8777, 'Xã Thanh Sơn', '26143', 3, 588),
(8778, 'Xã Phú Sơn', '26146', 3, 588),
(8779, 'Xã Phú Xuân', '26149', 3, 588),
(8780, 'Xã Phú Lộc', '26152', 3, 588),
(8781, 'Xã Phú Lâm', '26155', 3, 588),
(8782, 'Xã Phú Bình', '26158', 3, 588),
(8783, 'Xã Phú Thanh', '26161', 3, 588),
(8784, 'Xã Trà Cổ', '26164', 3, 588),
(8785, 'Xã Phú Điền', '26167', 3, 588);

-- Tỉnh Đồng Nai > Huyện Vĩnh Cửu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8786, 'Thị trấn Vĩnh An', '26170', 3, 589),
(8787, 'Xã Phú Lý', '26173', 3, 589),
(8788, 'Xã Trị An', '26176', 3, 589),
(8789, 'Xã Tân An', '26179', 3, 589),
(8790, 'Xã Vĩnh Tân', '26182', 3, 589),
(8791, 'Xã Bình Lợi', '26185', 3, 589),
(8792, 'Xã Thạnh Phú', '26188', 3, 589),
(8793, 'Xã Thiện Tân', '26191', 3, 589),
(8794, 'Xã Tân Bình', '26194', 3, 589),
(8795, 'Xã Mã Đà', '26200', 3, 589);

-- Tỉnh Đồng Nai > Huyện Định Quán
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8796, 'Thị trấn Định Quán', '26206', 3, 590),
(8797, 'Xã Thanh Sơn', '26209', 3, 590),
(8798, 'Xã Phú Tân', '26212', 3, 590),
(8799, 'Xã Phú Vinh', '26215', 3, 590),
(8800, 'Xã Phú Lợi', '26218', 3, 590),
(8801, 'Xã Phú Hòa', '26221', 3, 590),
(8802, 'Xã Ngọc Định', '26224', 3, 590),
(8803, 'Xã La Ngà', '26227', 3, 590),
(8804, 'Xã Gia Canh', '26230', 3, 590),
(8805, 'Xã Phú Ngọc', '26233', 3, 590),
(8806, 'Xã Phú Cường', '26236', 3, 590),
(8807, 'Xã Túc Trưng', '26239', 3, 590),
(8808, 'Xã Phú Túc', '26242', 3, 590),
(8809, 'Xã Suối Nho', '26245', 3, 590);

-- Tỉnh Đồng Nai > Huyện Trảng Bom
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8810, 'Thị trấn Trảng Bom', '26248', 3, 591),
(8811, 'Xã Thanh Bình', '26251', 3, 591),
(8812, 'Xã Cây Gáo', '26254', 3, 591),
(8813, 'Xã Bàu Hàm', '26257', 3, 591),
(8814, 'Xã Sông Thao', '26260', 3, 591),
(8815, 'Xã Sông Trầu', '26263', 3, 591),
(8816, 'Xã Đông Hoà', '26266', 3, 591),
(8817, 'Xã Bắc Sơn', '26269', 3, 591),
(8818, 'Xã Hố Nai 3', '26272', 3, 591),
(8819, 'Xã Tây Hoà', '26275', 3, 591),
(8820, 'Xã Bình Minh', '26278', 3, 591),
(8821, 'Xã Trung Hoà', '26281', 3, 591),
(8822, 'Xã Đồi 61', '26284', 3, 591),
(8823, 'Xã Hưng Thịnh', '26287', 3, 591),
(8824, 'Xã Quảng Tiến', '26290', 3, 591),
(8825, 'Xã Giang Điền', '26293', 3, 591),
(8826, 'Xã An Viễn', '26296', 3, 591);

-- Tỉnh Đồng Nai > Huyện Thống Nhất
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8827, 'Xã Gia Tân 1', '26299', 3, 592),
(8828, 'Xã Gia Tân 2', '26302', 3, 592),
(8829, 'Xã Gia Tân 3', '26305', 3, 592),
(8830, 'Xã Gia Kiệm', '26308', 3, 592),
(8831, 'Xã Quang Trung', '26311', 3, 592),
(8832, 'Xã Bàu Hàm 2', '26314', 3, 592),
(8833, 'Xã Hưng Lộc', '26317', 3, 592),
(8834, 'Xã Lộ 25', '26320', 3, 592),
(8835, 'Xã Xuân Thiện', '26323', 3, 592),
(8836, 'Thị trấn Dầu Giây', '26326', 3, 592);

-- Tỉnh Đồng Nai > Huyện Cẩm Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8837, 'Xã Sông Nhạn', '26329', 3, 593),
(8838, 'Xã Xuân Quế', '26332', 3, 593),
(8839, 'Xã Nhân Nghĩa', '26335', 3, 593),
(8840, 'Xã Xuân Đường', '26338', 3, 593),
(8841, 'Thị trấn Long Giao', '26341', 3, 593),
(8842, 'Xã Xuân Mỹ', '26344', 3, 593),
(8843, 'Xã Thừa Đức', '26347', 3, 593),
(8844, 'Xã Bảo Bình', '26350', 3, 593),
(8845, 'Xã Xuân Bảo', '26353', 3, 593),
(8846, 'Xã Xuân Tây', '26356', 3, 593),
(8847, 'Xã Xuân Đông', '26359', 3, 593),
(8848, 'Xã Sông Ray', '26362', 3, 593),
(8849, 'Xã Lâm San', '26365', 3, 593);

-- Tỉnh Đồng Nai > Huyện Long Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8850, 'Thị trấn Long Thành', '26368', 3, 594),
(8851, 'Xã An Phước', '26383', 3, 594),
(8852, 'Xã Bình An', '26386', 3, 594),
(8853, 'Xã Long Đức', '26389', 3, 594),
(8854, 'Xã Lộc An', '26392', 3, 594),
(8855, 'Xã Bình Sơn', '26395', 3, 594),
(8856, 'Xã Tam An', '26398', 3, 594),
(8857, 'Xã Cẩm Đường', '26401', 3, 594),
(8858, 'Xã Long An', '26404', 3, 594),
(8859, 'Xã Bàu Cạn', '26410', 3, 594),
(8860, 'Xã Long Phước', '26413', 3, 594),
(8861, 'Xã Phước Bình', '26416', 3, 594),
(8862, 'Xã Tân Hiệp', '26419', 3, 594),
(8863, 'Xã Phước Thái', '26422', 3, 594);

-- Tỉnh Đồng Nai > Huyện Xuân Lộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8864, 'Thị trấn Gia Ray', '26425', 3, 595),
(8865, 'Xã Xuân Bắc', '26428', 3, 595),
(8866, 'Xã Suối Cao', '26431', 3, 595),
(8867, 'Xã Xuân Thành', '26434', 3, 595),
(8868, 'Xã Xuân Thọ', '26437', 3, 595),
(8869, 'Xã Xuân Trường', '26440', 3, 595),
(8870, 'Xã Xuân Hòa', '26443', 3, 595),
(8871, 'Xã Xuân Hưng', '26446', 3, 595),
(8872, 'Xã Xuân Tâm', '26449', 3, 595),
(8873, 'Xã Suối Cát', '26452', 3, 595),
(8874, 'Xã Xuân Hiệp', '26455', 3, 595),
(8875, 'Xã Xuân Phú', '26458', 3, 595),
(8876, 'Xã Xuân Định', '26461', 3, 595),
(8877, 'Xã Bảo Hoà', '26464', 3, 595),
(8878, 'Xã Lang Minh', '26467', 3, 595);

-- Tỉnh Đồng Nai > Huyện Nhơn Trạch
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8879, 'Xã Phước Thiền', '26470', 3, 596),
(8880, 'Xã Long Tân', '26473', 3, 596),
(8881, 'Xã Đại Phước', '26476', 3, 596),
(8882, 'Thị trấn Hiệp Phước', '26479', 3, 596),
(8883, 'Xã Phú Hữu', '26482', 3, 596),
(8884, 'Xã Phú Hội', '26485', 3, 596),
(8885, 'Xã Phú Thạnh', '26488', 3, 596),
(8886, 'Xã Phú Đông', '26491', 3, 596),
(8887, 'Xã Long Thọ', '26494', 3, 596),
(8888, 'Xã Vĩnh Thanh', '26497', 3, 596),
(8889, 'Xã Phước Khánh', '26500', 3, 596),
(8890, 'Xã Phước An', '26503', 3, 596);

-- Tỉnh Bà Rịa - Vũng Tàu > Thành phố Vũng Tàu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8891, 'Phường 1', '26506', 3, 597),
(8892, 'Phường Thắng Tam', '26508', 3, 597),
(8893, 'Phường 2', '26509', 3, 597),
(8894, 'Phường 3', '26512', 3, 597),
(8895, 'Phường 4', '26515', 3, 597),
(8896, 'Phường 5', '26518', 3, 597),
(8897, 'Phường Thắng Nhì', '26521', 3, 597),
(8898, 'Phường 7', '26524', 3, 597),
(8899, 'Phường Nguyễn An Ninh', '26526', 3, 597),
(8900, 'Phường 8', '26527', 3, 597),
(8901, 'Phường 9', '26530', 3, 597),
(8902, 'Phường Thắng Nhất', '26533', 3, 597),
(8903, 'Phường Rạch Dừa', '26535', 3, 597),
(8904, 'Phường 10', '26536', 3, 597),
(8905, 'Phường 11', '26539', 3, 597),
(8906, 'Phường 12', '26542', 3, 597),
(8907, 'Xã Long Sơn', '26545', 3, 597);

-- Tỉnh Bà Rịa - Vũng Tàu > Thành phố Bà Rịa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8908, 'Phường Phước Hưng', '26548', 3, 598),
(8909, 'Phường Phước Nguyên', '26554', 3, 598),
(8910, 'Phường Long Toàn', '26557', 3, 598),
(8911, 'Phường Long Tâm', '26558', 3, 598),
(8912, 'Phường Phước Trung', '26560', 3, 598),
(8913, 'Phường Long Hương', '26563', 3, 598),
(8914, 'Phường Kim Dinh', '26566', 3, 598),
(8915, 'Xã Tân Hưng', '26567', 3, 598),
(8916, 'Xã Long Phước', '26569', 3, 598),
(8917, 'Xã Hoà Long', '26572', 3, 598);

-- Tỉnh Bà Rịa - Vũng Tàu > Huyện Châu Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8918, 'Xã Bàu Chinh', '26574', 3, 599),
(8919, 'Thị trấn Ngãi Giao', '26575', 3, 599),
(8920, 'Xã Bình Ba', '26578', 3, 599),
(8921, 'Xã Suối Nghệ', '26581', 3, 599),
(8922, 'Xã Xuân Sơn', '26584', 3, 599),
(8923, 'Xã Sơn Bình', '26587', 3, 599),
(8924, 'Xã Bình Giã', '26590', 3, 599),
(8925, 'Xã Bình Trung', '26593', 3, 599),
(8926, 'Xã Xà Bang', '26596', 3, 599),
(8927, 'Xã Cù Bị', '26599', 3, 599),
(8928, 'Xã Láng Lớn', '26602', 3, 599),
(8929, 'Xã Quảng Thành', '26605', 3, 599),
(8930, 'Thị trấn Kim Long', '26608', 3, 599),
(8931, 'Xã Suối Rao', '26611', 3, 599),
(8932, 'Xã Đá Bạc', '26614', 3, 599),
(8933, 'Xã Nghĩa Thành', '26617', 3, 599);

-- Tỉnh Bà Rịa - Vũng Tàu > Huyện Xuyên Mộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8934, 'Thị trấn Phước Bửu', '26620', 3, 600),
(8935, 'Xã Phước Thuận', '26623', 3, 600),
(8936, 'Xã Phước Tân', '26626', 3, 600),
(8937, 'Xã Xuyên Mộc', '26629', 3, 600),
(8938, 'Xã Bông Trang', '26632', 3, 600),
(8939, 'Xã Tân Lâm', '26635', 3, 600),
(8940, 'Xã Bàu Lâm', '26638', 3, 600),
(8941, 'Xã Hòa Bình', '26641', 3, 600),
(8942, 'Xã Hòa Hưng', '26644', 3, 600),
(8943, 'Xã Hòa Hiệp', '26647', 3, 600),
(8944, 'Xã Hòa Hội', '26650', 3, 600),
(8945, 'Xã Bưng Riềng', '26653', 3, 600),
(8946, 'Xã Bình Châu', '26656', 3, 600);

-- Tỉnh Bà Rịa - Vũng Tàu > Huyện Long Đất
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8947, 'Thị trấn Long Điền', '26659', 3, 601),
(8948, 'Thị trấn Long Hải', '26662', 3, 601),
(8949, 'Xã Tam An', '26668', 3, 601),
(8950, 'Xã Phước Tỉnh', '26674', 3, 601),
(8951, 'Xã Phước Hưng', '26677', 3, 601),
(8952, 'Thị trấn Đất Đỏ', '26680', 3, 601),
(8953, 'Xã Phước Long Thọ', '26683', 3, 601),
(8954, 'Xã Phước Hội', '26686', 3, 601),
(8955, 'Thị trấn Phước Hải', '26689', 3, 601),
(8956, 'Xã Long Tân', '26695', 3, 601),
(8957, 'Xã Láng Dài', '26698', 3, 601);

-- Tỉnh Bà Rịa - Vũng Tàu > Thị xã Phú Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8958, 'Phường Phú Mỹ', '26704', 3, 602),
(8959, 'Xã Tân Hoà', '26707', 3, 602),
(8960, 'Xã Tân Hải', '26710', 3, 602),
(8961, 'Phường Phước Hoà', '26713', 3, 602),
(8962, 'Phường Tân Phước', '26716', 3, 602),
(8963, 'Phường Mỹ Xuân', '26719', 3, 602),
(8964, 'Xã Sông Xoài', '26722', 3, 602),
(8965, 'Phường Hắc Dịch', '26725', 3, 602),
(8966, 'Xã Châu Pha', '26728', 3, 602),
(8967, 'Xã Tóc Tiên', '26731', 3, 602);

-- Thành phố Hồ Chí Minh > Quận 1
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8968, 'Phường Tân Định', '26734', 3, 604),
(8969, 'Phường Đa Kao', '26737', 3, 604),
(8970, 'Phường Bến Nghé', '26740', 3, 604),
(8971, 'Phường Bến Thành', '26743', 3, 604),
(8972, 'Phường Nguyễn Thái Bình', '26746', 3, 604),
(8973, 'Phường Phạm Ngũ Lão', '26749', 3, 604),
(8974, 'Phường Cầu Ông Lãnh', '26752', 3, 604),
(8975, 'Phường Cô Giang', '26755', 3, 604),
(8976, 'Phường Nguyễn Cư Trinh', '26758', 3, 604),
(8977, 'Phường Cầu Kho', '26761', 3, 604);

-- Thành phố Hồ Chí Minh > Quận 12
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8978, 'Phường Thạnh Xuân', '26764', 3, 605),
(8979, 'Phường Thạnh Lộc', '26767', 3, 605),
(8980, 'Phường Hiệp Thành', '26770', 3, 605),
(8981, 'Phường Thới An', '26773', 3, 605),
(8982, 'Phường Tân Chánh Hiệp', '26776', 3, 605),
(8983, 'Phường An Phú Đông', '26779', 3, 605),
(8984, 'Phường Tân Thới Hiệp', '26782', 3, 605),
(8985, 'Phường Trung Mỹ Tây', '26785', 3, 605),
(8986, 'Phường Tân Hưng Thuận', '26787', 3, 605),
(8987, 'Phường Đông Hưng Thuận', '26788', 3, 605),
(8988, 'Phường Tân Thới Nhất', '26791', 3, 605);

-- Thành phố Hồ Chí Minh > Quận Gò Vấp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(8989, 'Phường 15', '26872', 3, 606),
(8990, 'Phường 17', '26875', 3, 606),
(8991, 'Phường 6', '26876', 3, 606),
(8992, 'Phường 16', '26878', 3, 606),
(8993, 'Phường 12', '26881', 3, 606),
(8994, 'Phường 14', '26882', 3, 606),
(8995, 'Phường 10', '26884', 3, 606),
(8996, 'Phường 5', '26887', 3, 606),
(8997, 'Phường 1', '26890', 3, 606),
(8998, 'Phường 8', '26898', 3, 606),
(8999, 'Phường 11', '26899', 3, 606),
(9000, 'Phường 3', '26902', 3, 606);

-- Thành phố Hồ Chí Minh > Quận Bình Thạnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9001, 'Phường 13', '26905', 3, 607),
(9002, 'Phường 11', '26908', 3, 607),
(9003, 'Phường 27', '26911', 3, 607),
(9004, 'Phường 26', '26914', 3, 607),
(9005, 'Phường 12', '26917', 3, 607),
(9006, 'Phường 25', '26920', 3, 607),
(9007, 'Phường 5', '26923', 3, 607),
(9008, 'Phường 7', '26926', 3, 607),
(9009, 'Phường 14', '26935', 3, 607),
(9010, 'Phường 2', '26941', 3, 607),
(9011, 'Phường 1', '26944', 3, 607),
(9012, 'Phường 17', '26950', 3, 607),
(9013, 'Phường 22', '26956', 3, 607),
(9014, 'Phường 19', '26959', 3, 607),
(9015, 'Phường 28', '26962', 3, 607);

-- Thành phố Hồ Chí Minh > Quận Tân Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9016, 'Phường 2', '26965', 3, 608),
(9017, 'Phường 4', '26968', 3, 608),
(9018, 'Phường 12', '26971', 3, 608),
(9019, 'Phường 13', '26974', 3, 608),
(9020, 'Phường 1', '26977', 3, 608),
(9021, 'Phường 3', '26980', 3, 608),
(9022, 'Phường 11', '26983', 3, 608),
(9023, 'Phường 7', '26986', 3, 608),
(9024, 'Phường 5', '26989', 3, 608),
(9025, 'Phường 10', '26992', 3, 608),
(9026, 'Phường 6', '26995', 3, 608),
(9027, 'Phường 8', '26998', 3, 608),
(9028, 'Phường 9', '27001', 3, 608),
(9029, 'Phường 14', '27004', 3, 608),
(9030, 'Phường 15', '27007', 3, 608);

-- Thành phố Hồ Chí Minh > Quận Tân Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9031, 'Phường Tân Sơn Nhì', '27010', 3, 609),
(9032, 'Phường Tây Thạnh', '27013', 3, 609),
(9033, 'Phường Sơn Kỳ', '27016', 3, 609),
(9034, 'Phường Tân Quý', '27019', 3, 609),
(9035, 'Phường Tân Thành', '27022', 3, 609),
(9036, 'Phường Phú Thọ Hòa', '27025', 3, 609),
(9037, 'Phường Phú Thạnh', '27028', 3, 609),
(9038, 'Phường Phú Trung', '27031', 3, 609),
(9039, 'Phường Hòa Thạnh', '27034', 3, 609),
(9040, 'Phường Hiệp Tân', '27037', 3, 609),
(9041, 'Phường Tân Thới Hòa', '27040', 3, 609);

-- Thành phố Hồ Chí Minh > Quận Phú Nhuận
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9042, 'Phường 4', '27043', 3, 610),
(9043, 'Phường 5', '27046', 3, 610),
(9044, 'Phường 9', '27049', 3, 610),
(9045, 'Phường 7', '27052', 3, 610),
(9046, 'Phường 1', '27058', 3, 610),
(9047, 'Phường 2', '27061', 3, 610),
(9048, 'Phường 8', '27064', 3, 610),
(9049, 'Phường 15', '27067', 3, 610),
(9050, 'Phường 10', '27070', 3, 610),
(9051, 'Phường 11', '27073', 3, 610),
(9052, 'Phường 13', '27085', 3, 610);

-- Thành phố Hồ Chí Minh > Thành phố Thủ Đức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9053, 'Phường Linh Xuân', '26794', 3, 611),
(9054, 'Phường Bình Chiểu', '26797', 3, 611),
(9055, 'Phường Linh Trung', '26800', 3, 611),
(9056, 'Phường Tam Bình', '26803', 3, 611),
(9057, 'Phường Tam Phú', '26806', 3, 611),
(9058, 'Phường Hiệp Bình Phước', '26809', 3, 611),
(9059, 'Phường Hiệp Bình Chánh', '26812', 3, 611),
(9060, 'Phường Linh Chiểu', '26815', 3, 611),
(9061, 'Phường Linh Tây', '26818', 3, 611),
(9062, 'Phường Linh Đông', '26821', 3, 611),
(9063, 'Phường Bình Thọ', '26824', 3, 611),
(9064, 'Phường Trường Thọ', '26827', 3, 611),
(9065, 'Phường Long Bình', '26830', 3, 611),
(9066, 'Phường Long Thạnh Mỹ', '26833', 3, 611),
(9067, 'Phường Tân Phú', '26836', 3, 611),
(9068, 'Phường Hiệp Phú', '26839', 3, 611),
(9069, 'Phường Tăng Nhơn Phú A', '26842', 3, 611),
(9070, 'Phường Tăng Nhơn Phú B', '26845', 3, 611),
(9071, 'Phường Phước Long B', '26848', 3, 611),
(9072, 'Phường Phước Long A', '26851', 3, 611),
(9073, 'Phường Trường Thạnh', '26854', 3, 611),
(9074, 'Phường Long Phước', '26857', 3, 611),
(9075, 'Phường Long Trường', '26860', 3, 611),
(9076, 'Phường Phước Bình', '26863', 3, 611),
(9077, 'Phường Phú Hữu', '26866', 3, 611),
(9078, 'Phường Thảo Điền', '27088', 3, 611),
(9079, 'Phường An Phú', '27091', 3, 611),
(9080, 'Phường An Khánh', '27094', 3, 611),
(9081, 'Phường Bình Trưng Đông', '27097', 3, 611),
(9082, 'Phường Bình Trưng Tây', '27100', 3, 611),
(9083, 'Phường Cát Lái', '27109', 3, 611),
(9084, 'Phường Thạnh Mỹ Lợi', '27112', 3, 611),
(9085, 'Phường An Lợi Đông', '27115', 3, 611),
(9086, 'Phường Thủ Thiêm', '27118', 3, 611);

-- Thành phố Hồ Chí Minh > Quận 3
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9087, 'Phường 14', '27127', 3, 612),
(9088, 'Phường 12', '27130', 3, 612),
(9089, 'Phường 11', '27133', 3, 612),
(9090, 'Phường Võ Thị Sáu', '27139', 3, 612),
(9091, 'Phường 9', '27142', 3, 612),
(9092, 'Phường 4', '27148', 3, 612),
(9093, 'Phường 5', '27151', 3, 612),
(9094, 'Phường 3', '27154', 3, 612),
(9095, 'Phường 2', '27157', 3, 612),
(9096, 'Phường 1', '27160', 3, 612);

-- Thành phố Hồ Chí Minh > Quận 10
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9097, 'Phường 15', '27163', 3, 613),
(9098, 'Phường 13', '27166', 3, 613),
(9099, 'Phường 14', '27169', 3, 613),
(9100, 'Phường 12', '27172', 3, 613),
(9101, 'Phường 10', '27178', 3, 613),
(9102, 'Phường 9', '27181', 3, 613),
(9103, 'Phường 1', '27184', 3, 613),
(9104, 'Phường 8', '27187', 3, 613),
(9105, 'Phường 2', '27190', 3, 613),
(9106, 'Phường 4', '27193', 3, 613),
(9107, 'Phường 6', '27202', 3, 613);

-- Thành phố Hồ Chí Minh > Quận 11
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9108, 'Phường 15', '27208', 3, 614),
(9109, 'Phường 5', '27211', 3, 614),
(9110, 'Phường 14', '27214', 3, 614),
(9111, 'Phường 11', '27217', 3, 614),
(9112, 'Phường 3', '27220', 3, 614),
(9113, 'Phường 10', '27223', 3, 614),
(9114, 'Phường 8', '27229', 3, 614),
(9115, 'Phường 7', '27238', 3, 614),
(9116, 'Phường 1', '27247', 3, 614),
(9117, 'Phường 16', '27253', 3, 614);

-- Thành phố Hồ Chí Minh > Quận 4
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9118, 'Phường 13', '27259', 3, 615),
(9119, 'Phường 9', '27265', 3, 615),
(9120, 'Phường 8', '27271', 3, 615),
(9121, 'Phường 18', '27277', 3, 615),
(9122, 'Phường 4', '27283', 3, 615),
(9123, 'Phường 3', '27286', 3, 615),
(9124, 'Phường 16', '27289', 3, 615),
(9125, 'Phường 2', '27292', 3, 615),
(9126, 'Phường 15', '27295', 3, 615),
(9127, 'Phường 1', '27298', 3, 615);

-- Thành phố Hồ Chí Minh > Quận 5
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9128, 'Phường 4', '27301', 3, 616),
(9129, 'Phường 9', '27304', 3, 616),
(9130, 'Phường 2', '27307', 3, 616),
(9131, 'Phường 12', '27310', 3, 616),
(9132, 'Phường 7', '27316', 3, 616),
(9133, 'Phường 1', '27325', 3, 616),
(9134, 'Phường 11', '27328', 3, 616),
(9135, 'Phường 14', '27331', 3, 616),
(9136, 'Phường 5', '27334', 3, 616),
(9137, 'Phường 13', '27343', 3, 616);

-- Thành phố Hồ Chí Minh > Quận 6
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9138, 'Phường 14', '27346', 3, 617),
(9139, 'Phường 13', '27349', 3, 617),
(9140, 'Phường 9', '27352', 3, 617),
(9141, 'Phường 12', '27358', 3, 617),
(9142, 'Phường 2', '27361', 3, 617),
(9143, 'Phường 11', '27364', 3, 617),
(9144, 'Phường 8', '27376', 3, 617),
(9145, 'Phường 1', '27379', 3, 617),
(9146, 'Phường 7', '27382', 3, 617),
(9147, 'Phường 10', '27385', 3, 617);

-- Thành phố Hồ Chí Minh > Quận 8
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9148, 'Phường Rạch Ông', '27397', 3, 618),
(9149, 'Phường Hưng Phú', '27403', 3, 618),
(9150, 'Phường 4', '27409', 3, 618),
(9151, 'Phường Xóm Củi', '27415', 3, 618),
(9152, 'Phường 5', '27418', 3, 618),
(9153, 'Phường 14', '27421', 3, 618),
(9154, 'Phường 6', '27424', 3, 618),
(9155, 'Phường 15', '27427', 3, 618),
(9156, 'Phường 16', '27430', 3, 618),
(9157, 'Phường 7', '27433', 3, 618);

-- Thành phố Hồ Chí Minh > Quận Bình Tân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9158, 'Phường Bình Hưng Hòa', '27436', 3, 619),
(9159, 'Phường Bình Hưng Hoà A', '27439', 3, 619),
(9160, 'Phường Bình Hưng Hoà B', '27442', 3, 619),
(9161, 'Phường Bình Trị Đông', '27445', 3, 619),
(9162, 'Phường Bình Trị Đông A', '27448', 3, 619),
(9163, 'Phường Bình Trị Đông B', '27451', 3, 619),
(9164, 'Phường Tân Tạo', '27454', 3, 619),
(9165, 'Phường Tân Tạo A', '27457', 3, 619),
(9166, 'Phường An Lạc', '27460', 3, 619),
(9167, 'Phường An Lạc A', '27463', 3, 619);

-- Thành phố Hồ Chí Minh > Quận 7
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9168, 'Phường Tân Thuận Đông', '27466', 3, 620),
(9169, 'Phường Tân Thuận Tây', '27469', 3, 620),
(9170, 'Phường Tân Kiểng', '27472', 3, 620),
(9171, 'Phường Tân Hưng', '27475', 3, 620),
(9172, 'Phường Bình Thuận', '27478', 3, 620),
(9173, 'Phường Tân Quy', '27481', 3, 620),
(9174, 'Phường Phú Thuận', '27484', 3, 620),
(9175, 'Phường Tân Phú', '27487', 3, 620),
(9176, 'Phường Tân Phong', '27490', 3, 620),
(9177, 'Phường Phú Mỹ', '27493', 3, 620);

-- Thành phố Hồ Chí Minh > Huyện Củ Chi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9178, 'Thị trấn Củ Chi', '27496', 3, 621),
(9179, 'Xã Phú Mỹ Hưng', '27499', 3, 621),
(9180, 'Xã An Phú', '27502', 3, 621),
(9181, 'Xã Trung Lập Thượng', '27505', 3, 621),
(9182, 'Xã An Nhơn Tây', '27508', 3, 621),
(9183, 'Xã Nhuận Đức', '27511', 3, 621),
(9184, 'Xã Phạm Văn Cội', '27514', 3, 621),
(9185, 'Xã Phú Hòa Đông', '27517', 3, 621),
(9186, 'Xã Trung Lập Hạ', '27520', 3, 621),
(9187, 'Xã Trung An', '27523', 3, 621),
(9188, 'Xã Phước Thạnh', '27526', 3, 621),
(9189, 'Xã Phước Hiệp', '27529', 3, 621),
(9190, 'Xã Tân An Hội', '27532', 3, 621),
(9191, 'Xã Phước Vĩnh An', '27535', 3, 621),
(9192, 'Xã Thái Mỹ', '27538', 3, 621),
(9193, 'Xã Tân Thạnh Tây', '27541', 3, 621),
(9194, 'Xã Hòa Phú', '27544', 3, 621),
(9195, 'Xã Tân Thạnh Đông', '27547', 3, 621),
(9196, 'Xã Bình Mỹ', '27550', 3, 621),
(9197, 'Xã Tân Phú Trung', '27553', 3, 621),
(9198, 'Xã Tân Thông Hội', '27556', 3, 621);

-- Thành phố Hồ Chí Minh > Huyện Hóc Môn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9199, 'Thị trấn Hóc Môn', '27559', 3, 622),
(9200, 'Xã Tân Hiệp', '27562', 3, 622),
(9201, 'Xã Nhị Bình', '27565', 3, 622),
(9202, 'Xã Đông Thạnh', '27568', 3, 622),
(9203, 'Xã Tân Thới Nhì', '27571', 3, 622),
(9204, 'Xã Thới Tam Thôn', '27574', 3, 622),
(9205, 'Xã Xuân Thới Sơn', '27577', 3, 622),
(9206, 'Xã Tân Xuân', '27580', 3, 622),
(9207, 'Xã Xuân Thới Đông', '27583', 3, 622),
(9208, 'Xã Trung Chánh', '27586', 3, 622),
(9209, 'Xã Xuân Thới Thượng', '27589', 3, 622),
(9210, 'Xã Bà Điểm', '27592', 3, 622);

-- Thành phố Hồ Chí Minh > Huyện Bình Chánh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9211, 'Thị trấn Tân Túc', '27595', 3, 623),
(9212, 'Xã Phạm Văn Hai', '27598', 3, 623),
(9213, 'Xã Vĩnh Lộc A', '27601', 3, 623),
(9214, 'Xã Vĩnh Lộc B', '27604', 3, 623),
(9215, 'Xã Bình Lợi', '27607', 3, 623),
(9216, 'Xã Lê Minh Xuân', '27610', 3, 623),
(9217, 'Xã Tân Nhựt', '27613', 3, 623),
(9218, 'Xã Tân Kiên', '27616', 3, 623),
(9219, 'Xã Bình Hưng', '27619', 3, 623),
(9220, 'Xã Phong Phú', '27622', 3, 623),
(9221, 'Xã An Phú Tây', '27625', 3, 623),
(9222, 'Xã Hưng Long', '27628', 3, 623),
(9223, 'Xã Đa Phước', '27631', 3, 623),
(9224, 'Xã Tân Quý Tây', '27634', 3, 623),
(9225, 'Xã Bình Chánh', '27637', 3, 623),
(9226, 'Xã Quy Đức', '27640', 3, 623);

-- Thành phố Hồ Chí Minh > Huyện Nhà Bè
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9227, 'Thị trấn Nhà Bè', '27643', 3, 624),
(9228, 'Xã Phước Kiển', '27646', 3, 624),
(9229, 'Xã Phước Lộc', '27649', 3, 624),
(9230, 'Xã Nhơn Đức', '27652', 3, 624),
(9231, 'Xã Phú Xuân', '27655', 3, 624),
(9232, 'Xã Long Thới', '27658', 3, 624),
(9233, 'Xã Hiệp Phước', '27661', 3, 624);

-- Thành phố Hồ Chí Minh > Huyện Cần Giờ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9234, 'Thị trấn Cần Thạnh', '27664', 3, 625),
(9235, 'Xã Bình Khánh', '27667', 3, 625),
(9236, 'Xã Tam Thôn Hiệp', '27670', 3, 625),
(9237, 'Xã An Thới Đông', '27673', 3, 625),
(9238, 'Xã Thạnh An', '27676', 3, 625),
(9239, 'Xã Long Hòa', '27679', 3, 625),
(9240, 'Xã Lý Nhơn', '27682', 3, 625);

-- Tỉnh Long An > Thành phố Tân An
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9241, 'Phường 5', '27685', 3, 626),
(9242, 'Phường 4', '27691', 3, 626),
(9243, 'Phường Tân Khánh', '27692', 3, 626),
(9244, 'Phường 1', '27694', 3, 626),
(9245, 'Phường 3', '27697', 3, 626),
(9246, 'Phường 7', '27698', 3, 626),
(9247, 'Phường 6', '27700', 3, 626),
(9248, 'Xã Hướng Thọ Phú', '27703', 3, 626),
(9249, 'Xã Nhơn Thạnh Trung', '27706', 3, 626),
(9250, 'Xã Lợi Bình Nhơn', '27709', 3, 626),
(9251, 'Xã Bình Tâm', '27712', 3, 626),
(9252, 'Phường Khánh Hậu', '27715', 3, 626),
(9253, 'Xã An Vĩnh Ngãi', '27718', 3, 626);

-- Tỉnh Long An > Thị xã Kiến Tường
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9254, 'Phường 1', '27787', 3, 627),
(9255, 'Phường 2', '27788', 3, 627),
(9256, 'Xã Thạnh Trị', '27790', 3, 627),
(9257, 'Xã Bình Hiệp', '27793', 3, 627),
(9258, 'Xã Bình Tân', '27799', 3, 627),
(9259, 'Xã Tuyên Thạnh', '27805', 3, 627),
(9260, 'Phường 3', '27806', 3, 627),
(9261, 'Xã Thạnh Hưng', '27817', 3, 627);

-- Tỉnh Long An > Huyện Tân Hưng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9262, 'Thị trấn Tân Hưng', '27721', 3, 628),
(9263, 'Xã Hưng Hà', '27724', 3, 628),
(9264, 'Xã Hưng Điền B', '27727', 3, 628),
(9265, 'Xã Hưng Điền', '27730', 3, 628),
(9266, 'Xã Thạnh Hưng', '27733', 3, 628),
(9267, 'Xã Hưng Thạnh', '27736', 3, 628),
(9268, 'Xã Vĩnh Thạnh', '27739', 3, 628),
(9269, 'Xã Vĩnh Châu B', '27742', 3, 628),
(9270, 'Xã Vĩnh Lợi', '27745', 3, 628),
(9271, 'Xã Vĩnh Đại', '27748', 3, 628),
(9272, 'Xã Vĩnh Châu A', '27751', 3, 628),
(9273, 'Xã Vĩnh Bửu', '27754', 3, 628);

-- Tỉnh Long An > Huyện Vĩnh Hưng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9274, 'Thị trấn Vĩnh Hưng', '27757', 3, 629),
(9275, 'Xã Hưng Điền A', '27760', 3, 629),
(9276, 'Xã Khánh Hưng', '27763', 3, 629),
(9277, 'Xã Thái Trị', '27766', 3, 629),
(9278, 'Xã Vĩnh Trị', '27769', 3, 629),
(9279, 'Xã Thái Bình Trung', '27772', 3, 629),
(9280, 'Xã Vĩnh Bình', '27775', 3, 629),
(9281, 'Xã Vĩnh Thuận', '27778', 3, 629),
(9282, 'Xã Tuyên Bình', '27781', 3, 629),
(9283, 'Xã Tuyên Bình Tây', '27784', 3, 629);

-- Tỉnh Long An > Huyện Mộc Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9284, 'Xã Bình Hòa Tây', '27796', 3, 630),
(9285, 'Xã Bình Thạnh', '27802', 3, 630),
(9286, 'Xã Bình Hòa Trung', '27808', 3, 630),
(9287, 'Xã Bình Hòa Đông', '27811', 3, 630),
(9288, 'Thị trấn Bình Phong Thạnh', '27814', 3, 630),
(9289, 'Xã Tân Lập', '27820', 3, 630),
(9290, 'Xã Tân Thành', '27823', 3, 630);

-- Tỉnh Long An > Huyện Tân Thạnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9291, 'Thị trấn Tân Thạnh', '27826', 3, 631),
(9292, 'Xã Bắc Hòa', '27829', 3, 631),
(9293, 'Xã Hậu Thạnh Tây', '27832', 3, 631),
(9294, 'Xã Nhơn Hòa Lập', '27835', 3, 631),
(9295, 'Xã Tân Lập', '27838', 3, 631),
(9296, 'Xã Hậu Thạnh Đông', '27841', 3, 631),
(9297, 'Xã Nhơn Hoà', '27844', 3, 631),
(9298, 'Xã Kiến Bình', '27847', 3, 631),
(9299, 'Xã Tân Thành', '27850', 3, 631),
(9300, 'Xã Tân Bình', '27853', 3, 631),
(9301, 'Xã Tân Ninh', '27856', 3, 631),
(9302, 'Xã Nhơn Ninh', '27859', 3, 631),
(9303, 'Xã Tân Hòa', '27862', 3, 631);

-- Tỉnh Long An > Huyện Thạnh Hóa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9304, 'Thị trấn Thạnh Hóa', '27865', 3, 632),
(9305, 'Xã Tân Hiệp', '27868', 3, 632),
(9306, 'Xã Thuận Bình', '27871', 3, 632),
(9307, 'Xã Thạnh Phước', '27874', 3, 632),
(9308, 'Xã Thạnh Phú', '27877', 3, 632),
(9309, 'Xã Thuận Nghĩa Hòa', '27880', 3, 632),
(9310, 'Xã Thủy Đông', '27883', 3, 632),
(9311, 'Xã Thủy Tây', '27886', 3, 632),
(9312, 'Xã Tân Tây', '27889', 3, 632),
(9313, 'Xã Tân Đông', '27892', 3, 632),
(9314, 'Xã Thạnh An', '27895', 3, 632);

-- Tỉnh Long An > Huyện Đức Huệ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9315, 'Thị trấn Đông Thành', '27898', 3, 633),
(9316, 'Xã Mỹ Quý Đông', '27901', 3, 633),
(9317, 'Xã Mỹ Thạnh Bắc', '27904', 3, 633),
(9318, 'Xã Mỹ Quý Tây', '27907', 3, 633),
(9319, 'Xã Mỹ Thạnh Tây', '27910', 3, 633),
(9320, 'Xã Mỹ Thạnh Đông', '27913', 3, 633),
(9321, 'Xã Bình Thành', '27916', 3, 633),
(9322, 'Xã Bình Hòa Bắc', '27919', 3, 633),
(9323, 'Xã Bình Hòa Hưng', '27922', 3, 633),
(9324, 'Xã Bình Hòa Nam', '27925', 3, 633),
(9325, 'Xã Mỹ Bình', '27928', 3, 633);

-- Tỉnh Long An > Huyện Đức Hòa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9326, 'Thị trấn Hậu Nghĩa', '27931', 3, 634),
(9327, 'Thị trấn Hiệp Hòa', '27934', 3, 634),
(9328, 'Thị trấn Đức Hòa', '27937', 3, 634),
(9329, 'Xã Lộc Giang', '27940', 3, 634),
(9330, 'Xã An Ninh Đông', '27943', 3, 634),
(9331, 'Xã An Ninh Tây', '27946', 3, 634),
(9332, 'Xã Tân Mỹ', '27949', 3, 634),
(9333, 'Xã Hiệp Hòa', '27952', 3, 634),
(9334, 'Xã Đức Lập Thượng', '27955', 3, 634),
(9335, 'Xã Đức Lập Hạ', '27958', 3, 634),
(9336, 'Xã Tân Phú', '27961', 3, 634),
(9337, 'Xã Mỹ Hạnh Bắc', '27964', 3, 634),
(9338, 'Xã Đức Hòa Thượng', '27967', 3, 634),
(9339, 'Xã Hòa Khánh Tây', '27970', 3, 634),
(9340, 'Xã Hòa Khánh Đông', '27973', 3, 634),
(9341, 'Xã Mỹ Hạnh Nam', '27976', 3, 634),
(9342, 'Xã Hòa Khánh Nam', '27979', 3, 634),
(9343, 'Xã Đức Hòa Đông', '27982', 3, 634),
(9344, 'Xã Đức Hòa Hạ', '27985', 3, 634),
(9345, 'Xã Hựu Thạnh', '27988', 3, 634);

-- Tỉnh Long An > Huyện Bến Lức
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9346, 'Thị trấn Bến Lức', '27991', 3, 635),
(9347, 'Xã Thạnh Lợi', '27994', 3, 635),
(9348, 'Xã Lương Bình', '27997', 3, 635),
(9349, 'Xã Thạnh Hòa', '28000', 3, 635),
(9350, 'Xã Lương Hòa', '28003', 3, 635),
(9351, 'Xã Tân Bửu', '28009', 3, 635),
(9352, 'Xã An Thạnh', '28012', 3, 635),
(9353, 'Xã Bình Đức', '28015', 3, 635),
(9354, 'Xã Mỹ Yên', '28018', 3, 635),
(9355, 'Xã Thanh Phú', '28021', 3, 635),
(9356, 'Xã Long Hiệp', '28024', 3, 635),
(9357, 'Xã Thạnh Đức', '28027', 3, 635),
(9358, 'Xã Phước Lợi', '28030', 3, 635),
(9359, 'Xã Nhựt Chánh', '28033', 3, 635);

-- Tỉnh Long An > Huyện Thủ Thừa
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9360, 'Thị trấn Thủ Thừa', '28036', 3, 636),
(9361, 'Xã Long Thạnh', '28039', 3, 636),
(9362, 'Xã Tân Thành', '28042', 3, 636),
(9363, 'Xã Long Thuận', '28045', 3, 636),
(9364, 'Xã Mỹ Lạc', '28048', 3, 636),
(9365, 'Xã Mỹ Thạnh', '28051', 3, 636),
(9366, 'Xã Bình An', '28054', 3, 636),
(9367, 'Xã Nhị Thành', '28057', 3, 636),
(9368, 'Xã Mỹ An', '28060', 3, 636),
(9369, 'Xã Bình Thạnh', '28063', 3, 636),
(9370, 'Xã Mỹ Phú', '28066', 3, 636),
(9371, 'Xã Tân Long', '28072', 3, 636);

-- Tỉnh Long An > Huyện Tân Trụ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9372, 'Thị trấn Tân Trụ', '28075', 3, 637),
(9373, 'Xã Tân Bình', '28078', 3, 637),
(9374, 'Xã Quê Mỹ Thạnh', '28084', 3, 637),
(9375, 'Xã Lạc Tấn', '28087', 3, 637),
(9376, 'Xã Bình Trinh Đông', '28090', 3, 637),
(9377, 'Xã Tân Phước Tây', '28093', 3, 637),
(9378, 'Xã Bình Lãng', '28096', 3, 637),
(9379, 'Xã Bình Tịnh', '28099', 3, 637),
(9380, 'Xã Đức Tân', '28102', 3, 637),
(9381, 'Xã Nhựt Ninh', '28105', 3, 637);

-- Tỉnh Long An > Huyện Cần Đước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9382, 'Thị trấn Cần Đước', '28108', 3, 638),
(9383, 'Xã Long Trạch', '28111', 3, 638),
(9384, 'Xã Long Khê', '28114', 3, 638),
(9385, 'Xã Long Định', '28117', 3, 638),
(9386, 'Xã Phước Vân', '28120', 3, 638),
(9387, 'Xã Long Hòa', '28123', 3, 638),
(9388, 'Xã Long Cang', '28126', 3, 638),
(9389, 'Xã Long Sơn', '28129', 3, 638),
(9390, 'Xã Tân Trạch', '28132', 3, 638),
(9391, 'Xã Mỹ Lệ', '28135', 3, 638),
(9392, 'Xã Tân Lân', '28138', 3, 638),
(9393, 'Xã Phước Tuy', '28141', 3, 638),
(9394, 'Xã Long Hựu Đông', '28144', 3, 638),
(9395, 'Xã Tân Ân', '28147', 3, 638),
(9396, 'Xã Phước Đông', '28150', 3, 638),
(9397, 'Xã Long Hựu Tây', '28153', 3, 638),
(9398, 'Xã Tân Chánh', '28156', 3, 638);

-- Tỉnh Long An > Huyện Cần Giuộc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9399, 'Thị trấn Cần Giuộc', '28159', 3, 639),
(9400, 'Xã Phước Lý', '28162', 3, 639),
(9401, 'Xã Long Thượng', '28165', 3, 639),
(9402, 'Xã Long Hậu', '28168', 3, 639),
(9403, 'Xã Phước Hậu', '28174', 3, 639),
(9404, 'Xã Mỹ Lộc', '28177', 3, 639),
(9405, 'Xã Phước Lại', '28180', 3, 639),
(9406, 'Xã Phước Lâm', '28183', 3, 639),
(9407, 'Xã Thuận Thành', '28189', 3, 639),
(9408, 'Xã Phước Vĩnh Tây', '28192', 3, 639),
(9409, 'Xã Phước Vĩnh Đông', '28195', 3, 639),
(9410, 'Xã Long An', '28198', 3, 639),
(9411, 'Xã Long Phụng', '28201', 3, 639),
(9412, 'Xã Đông Thạnh', '28204', 3, 639),
(9413, 'Xã Tân Tập', '28207', 3, 639);

-- Tỉnh Long An > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9414, 'Thị trấn Tầm Vu', '28210', 3, 640),
(9415, 'Xã Bình Quới', '28213', 3, 640),
(9416, 'Xã Hòa Phú', '28216', 3, 640),
(9417, 'Xã Phú Ngãi Trị', '28219', 3, 640),
(9418, 'Xã Vĩnh Công', '28222', 3, 640),
(9419, 'Xã Thuận Mỹ', '28225', 3, 640),
(9420, 'Xã Hiệp Thạnh', '28228', 3, 640),
(9421, 'Xã Phước Tân Hưng', '28231', 3, 640),
(9422, 'Xã Thanh Phú Long', '28234', 3, 640),
(9423, 'Xã Dương Xuân Hội', '28237', 3, 640),
(9424, 'Xã An Lục Long', '28240', 3, 640),
(9425, 'Xã Long Trì', '28243', 3, 640),
(9426, 'Xã Thanh Vĩnh Đông', '28246', 3, 640);

-- Tỉnh Tiền Giang > Thành phố Mỹ Tho
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9427, 'Phường 5', '28249', 3, 641),
(9428, 'Phường 4', '28252', 3, 641),
(9429, 'Phường 1', '28261', 3, 641),
(9430, 'Phường 2', '28264', 3, 641),
(9431, 'Phường 6', '28270', 3, 641),
(9432, 'Phường 9', '28273', 3, 641),
(9433, 'Phường 10', '28276', 3, 641),
(9434, 'Phường Tân Long', '28279', 3, 641),
(9435, 'Xã Đạo Thạnh', '28282', 3, 641),
(9436, 'Xã Trung An', '28285', 3, 641),
(9437, 'Xã Mỹ Phong', '28288', 3, 641),
(9438, 'Xã Tân Mỹ Chánh', '28291', 3, 641),
(9439, 'Xã Phước Thạnh', '28567', 3, 641),
(9440, 'Xã Thới Sơn', '28591', 3, 641);

-- Tỉnh Tiền Giang > Thành phố Gò Công
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9441, 'Phường 2', '28297', 3, 642),
(9442, 'Phường 1', '28300', 3, 642),
(9443, 'Phường 5', '28306', 3, 642),
(9444, 'Phường Long Hưng', '28309', 3, 642),
(9445, 'Phường Long Thuận', '28312', 3, 642),
(9446, 'Phường Long Chánh', '28315', 3, 642),
(9447, 'Phường Long Hòa', '28318', 3, 642),
(9448, 'Xã Bình Đông', '28708', 3, 642),
(9449, 'Xã Bình Xuân', '28717', 3, 642),
(9450, 'Xã Tân Trung', '28729', 3, 642);

-- Tỉnh Tiền Giang > Thị xã Cai Lậy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9451, 'Phường 1', '28435', 3, 643),
(9452, 'Phường 2', '28436', 3, 643),
(9453, 'Phường 3', '28437', 3, 643),
(9454, 'Phường 4', '28439', 3, 643),
(9455, 'Phường 5', '28440', 3, 643),
(9456, 'Xã Mỹ Phước Tây', '28447', 3, 643),
(9457, 'Xã Mỹ Hạnh Đông', '28450', 3, 643),
(9458, 'Xã Mỹ Hạnh Trung', '28453', 3, 643),
(9459, 'Xã Tân Phú', '28459', 3, 643),
(9460, 'Xã Tân Bình', '28462', 3, 643),
(9461, 'Xã Tân Hội', '28468', 3, 643),
(9462, 'Phường Nhị Mỹ', '28474', 3, 643),
(9463, 'Xã Nhị Quý', '28477', 3, 643),
(9464, 'Xã Thanh Hòa', '28480', 3, 643),
(9465, 'Xã Phú Quý', '28483', 3, 643),
(9466, 'Xã Long Khánh', '28486', 3, 643);

-- Tỉnh Tiền Giang > Huyện Tân Phước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9467, 'Thị trấn Mỹ Phước', '28321', 3, 644),
(9468, 'Xã Tân Hòa Đông', '28324', 3, 644),
(9469, 'Xã Thạnh Tân', '28327', 3, 644),
(9470, 'Xã Thạnh Mỹ', '28330', 3, 644),
(9471, 'Xã Thạnh Hoà', '28333', 3, 644),
(9472, 'Xã Phú Mỹ', '28336', 3, 644),
(9473, 'Xã Tân Hòa Thành', '28339', 3, 644),
(9474, 'Xã Hưng Thạnh', '28342', 3, 644),
(9475, 'Xã Tân Lập 1', '28345', 3, 644),
(9476, 'Xã Tân Hòa Tây', '28348', 3, 644),
(9477, 'Xã Tân Lập 2', '28354', 3, 644),
(9478, 'Xã Phước Lập', '28357', 3, 644);

-- Tỉnh Tiền Giang > Huyện Cái Bè
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9479, 'Thị trấn Cái Bè', '28360', 3, 645),
(9480, 'Xã Hậu Mỹ Bắc B', '28363', 3, 645),
(9481, 'Xã Hậu Mỹ Bắc A', '28366', 3, 645),
(9482, 'Xã Mỹ Trung', '28369', 3, 645),
(9483, 'Xã Hậu Mỹ Trinh', '28372', 3, 645),
(9484, 'Xã Hậu Mỹ Phú', '28375', 3, 645),
(9485, 'Xã Mỹ Tân', '28378', 3, 645),
(9486, 'Xã Mỹ Lợi B', '28381', 3, 645),
(9487, 'Xã Thiện Trung', '28384', 3, 645),
(9488, 'Xã Mỹ Hội', '28387', 3, 645),
(9489, 'Xã An Cư', '28390', 3, 645),
(9490, 'Xã Hậu Thành', '28393', 3, 645),
(9491, 'Xã Mỹ Lợi A', '28396', 3, 645),
(9492, 'Xã Hòa Khánh', '28399', 3, 645),
(9493, 'Xã Thiện Trí', '28402', 3, 645),
(9494, 'Xã Mỹ Đức Đông', '28405', 3, 645),
(9495, 'Xã Mỹ Đức Tây', '28408', 3, 645),
(9496, 'Xã Đông Hòa Hiệp', '28411', 3, 645),
(9497, 'Xã An Thái Đông', '28414', 3, 645),
(9498, 'Xã Tân Hưng', '28417', 3, 645),
(9499, 'Xã Mỹ Lương', '28420', 3, 645),
(9500, 'Xã Tân Thanh', '28423', 3, 645),
(9501, 'Xã An Thái Trung', '28426', 3, 645),
(9502, 'Xã An Hữu', '28429', 3, 645),
(9503, 'Xã Hòa Hưng', '28432', 3, 645);

-- Tỉnh Tiền Giang > Huyện Cai Lậy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9504, 'Xã Thạnh Lộc', '28438', 3, 646),
(9505, 'Xã Mỹ Thành Bắc', '28441', 3, 646),
(9506, 'Xã Phú Cường', '28444', 3, 646),
(9507, 'Xã Mỹ Thành Nam', '28456', 3, 646),
(9508, 'Xã Phú Nhuận', '28465', 3, 646),
(9509, 'Thị trấn Bình Phú', '28471', 3, 646),
(9510, 'Xã Cẩm Sơn', '28489', 3, 646),
(9511, 'Xã Phú An', '28492', 3, 646),
(9512, 'Xã Mỹ Long', '28495', 3, 646),
(9513, 'Xã Long Tiên', '28498', 3, 646),
(9514, 'Xã Hiệp Đức', '28501', 3, 646),
(9515, 'Xã Long Trung', '28504', 3, 646),
(9516, 'Xã Hội Xuân', '28507', 3, 646),
(9517, 'Xã Tân Phong', '28510', 3, 646),
(9518, 'Xã Tam Bình', '28513', 3, 646),
(9519, 'Xã Ngũ Hiệp', '28516', 3, 646);

-- Tỉnh Tiền Giang > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9520, 'Thị trấn Tân Hiệp', '28519', 3, 647),
(9521, 'Xã Tân Hội Đông', '28522', 3, 647),
(9522, 'Xã Tân Hương', '28525', 3, 647),
(9523, 'Xã Tân Lý Đông', '28528', 3, 647),
(9524, 'Xã Thân Cửu Nghĩa', '28534', 3, 647),
(9525, 'Xã Tam Hiệp', '28537', 3, 647),
(9526, 'Xã Điềm Hy', '28540', 3, 647),
(9527, 'Xã Nhị Bình', '28543', 3, 647),
(9528, 'Xã Đông Hòa', '28549', 3, 647),
(9529, 'Xã Long Định', '28552', 3, 647),
(9530, 'Xã Long An', '28558', 3, 647),
(9531, 'Xã Long Hưng', '28561', 3, 647),
(9532, 'Xã Bình Trưng', '28564', 3, 647),
(9533, 'Xã Thạnh Phú', '28570', 3, 647),
(9534, 'Xã Bàn Long', '28573', 3, 647),
(9535, 'Xã Vĩnh Kim', '28576', 3, 647),
(9536, 'Xã Bình Đức', '28579', 3, 647),
(9537, 'Xã Song Thuận', '28582', 3, 647),
(9538, 'Xã Kim Sơn', '28585', 3, 647),
(9539, 'Xã Phú Phong', '28588', 3, 647);

-- Tỉnh Tiền Giang > Huyện Chợ Gạo
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9540, 'Thị trấn Chợ Gạo', '28594', 3, 648),
(9541, 'Xã Trung Hòa', '28597', 3, 648),
(9542, 'Xã Hòa Tịnh', '28600', 3, 648),
(9543, 'Xã Mỹ Tịnh An', '28603', 3, 648),
(9544, 'Xã Tân Bình Thạnh', '28606', 3, 648),
(9545, 'Xã Phú Kiết', '28609', 3, 648),
(9546, 'Xã Lương Hòa Lạc', '28612', 3, 648),
(9547, 'Xã Thanh Bình', '28615', 3, 648),
(9548, 'Xã Quơn Long', '28618', 3, 648),
(9549, 'Xã Bình Phục Nhứt', '28621', 3, 648),
(9550, 'Xã Đăng Hưng Phước', '28624', 3, 648),
(9551, 'Xã Tân Thuận Bình', '28627', 3, 648),
(9552, 'Xã Song Bình', '28630', 3, 648),
(9553, 'Xã Bình Phan', '28633', 3, 648),
(9554, 'Xã Long Bình Điền', '28636', 3, 648),
(9555, 'Xã An Thạnh Thủy', '28639', 3, 648),
(9556, 'Xã Xuân Đông', '28642', 3, 648),
(9557, 'Xã Hòa Định', '28645', 3, 648),
(9558, 'Xã Bình Ninh', '28648', 3, 648);

-- Tỉnh Tiền Giang > Huyện Gò Công Tây
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9559, 'Thị trấn Vĩnh Bình', '28651', 3, 649),
(9560, 'Xã Đồng Sơn', '28654', 3, 649),
(9561, 'Xã Bình Phú', '28657', 3, 649),
(9562, 'Xã Đồng Thạnh', '28660', 3, 649),
(9563, 'Xã Thành Công', '28663', 3, 649),
(9564, 'Xã Bình Nhì', '28666', 3, 649),
(9565, 'Xã Yên Luông', '28669', 3, 649),
(9566, 'Xã Thạnh Trị', '28672', 3, 649),
(9567, 'Xã Thạnh Nhựt', '28675', 3, 649),
(9568, 'Xã Long Vĩnh', '28678', 3, 649),
(9569, 'Xã Bình Tân', '28681', 3, 649),
(9570, 'Xã Vĩnh Hựu', '28684', 3, 649),
(9571, 'Xã Long Bình', '28687', 3, 649);

-- Tỉnh Tiền Giang > Huyện Gò Công Đông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9572, 'Thị trấn Tân Hòa', '28702', 3, 650),
(9573, 'Xã Tăng Hoà', '28705', 3, 650),
(9574, 'Xã Tân Phước', '28711', 3, 650),
(9575, 'Xã Gia Thuận', '28714', 3, 650),
(9576, 'Thị trấn Vàm Láng', '28720', 3, 650),
(9577, 'Xã Tân Tây', '28723', 3, 650),
(9578, 'Xã Kiểng Phước', '28726', 3, 650),
(9579, 'Xã Tân Đông', '28732', 3, 650),
(9580, 'Xã Bình Ân', '28735', 3, 650),
(9581, 'Xã Tân Điền', '28738', 3, 650),
(9582, 'Xã Bình Nghị', '28741', 3, 650),
(9583, 'Xã Phước Trung', '28744', 3, 650),
(9584, 'Xã Tân Thành', '28747', 3, 650);

-- Tỉnh Tiền Giang > Huyện Tân Phú Đông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9585, 'Xã Tân Thới', '28690', 3, 651),
(9586, 'Xã Tân Phú', '28693', 3, 651),
(9587, 'Xã Phú Thạnh', '28696', 3, 651),
(9588, 'Xã Tân Thạnh', '28699', 3, 651),
(9589, 'Xã Phú Đông', '28750', 3, 651),
(9590, 'Xã Phú Tân', '28753', 3, 651);

-- Tỉnh Bến Tre > Thành phố Bến Tre
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9591, 'Phường Phú Khương', '28756', 3, 652),
(9592, 'Phường Phú Tân', '28757', 3, 652),
(9593, 'Phường 8', '28759', 3, 652),
(9594, 'Phường 6', '28762', 3, 652),
(9595, 'Phường An Hội', '28777', 3, 652),
(9596, 'Phường 7', '28780', 3, 652),
(9597, 'Xã Sơn Đông', '28783', 3, 652),
(9598, 'Xã Phú Hưng', '28786', 3, 652),
(9599, 'Xã Bình Phú', '28789', 3, 652),
(9600, 'Xã Mỹ Thạnh An', '28792', 3, 652),
(9601, 'Xã Nhơn Thạnh', '28795', 3, 652),
(9602, 'Xã Phú Nhuận', '28798', 3, 652);

-- Tỉnh Bến Tre > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9603, 'Xã Tân Thạch', '28804', 3, 653),
(9604, 'Xã Qưới Sơn', '28807', 3, 653),
(9605, 'Thị trấn Châu Thành', '28810', 3, 653),
(9606, 'Xã Giao Long', '28813', 3, 653),
(9607, 'Xã Phú Túc', '28819', 3, 653),
(9608, 'Xã Phú Đức', '28822', 3, 653),
(9609, 'Xã An Phước', '28828', 3, 653),
(9610, 'Xã Tam Phước', '28831', 3, 653),
(9611, 'Xã Thành Triệu', '28834', 3, 653),
(9612, 'Xã Tân Phú', '28840', 3, 653),
(9613, 'Xã Quới Thành', '28843', 3, 653),
(9614, 'Xã Phước Thạnh', '28846', 3, 653),
(9615, 'Xã Tiên Long', '28852', 3, 653),
(9616, 'Xã Tường Đa', '28855', 3, 653),
(9617, 'Xã Hữu Định', '28858', 3, 653),
(9618, 'Thị trấn Tiên Thủy', '28861', 3, 653);

-- Tỉnh Bến Tre > Huyện Chợ Lách
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9619, 'Thị trấn Chợ Lách', '28870', 3, 654),
(9620, 'Xã Phú Phụng', '28873', 3, 654),
(9621, 'Xã Sơn Định', '28876', 3, 654),
(9622, 'Xã Vĩnh Bình', '28879', 3, 654),
(9623, 'Xã Hòa Nghĩa', '28882', 3, 654),
(9624, 'Xã Long Thới', '28885', 3, 654),
(9625, 'Xã Phú Sơn', '28888', 3, 654),
(9626, 'Xã Tân Thiềng', '28891', 3, 654),
(9627, 'Xã Vĩnh Thành', '28894', 3, 654),
(9628, 'Xã Vĩnh Hòa', '28897', 3, 654),
(9629, 'Xã Hưng Khánh Trung B', '28900', 3, 654);

-- Tỉnh Bến Tre > Huyện Mỏ Cày Nam
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9630, 'Thị trấn Mỏ Cày', '28903', 3, 655),
(9631, 'Xã Định Thủy', '28930', 3, 655),
(9632, 'Xã Đa Phước Hội', '28939', 3, 655),
(9633, 'Xã Tân Hội', '28940', 3, 655),
(9634, 'Xã Phước Hiệp', '28942', 3, 655),
(9635, 'Xã Bình Khánh', '28945', 3, 655),
(9636, 'Xã An Thạnh', '28951', 3, 655),
(9637, 'Xã An Định', '28957', 3, 655),
(9638, 'Xã Thành Thới B', '28960', 3, 655),
(9639, 'Xã Tân Trung', '28963', 3, 655),
(9640, 'Xã An Thới', '28966', 3, 655),
(9641, 'Xã Thành Thới A', '28969', 3, 655),
(9642, 'Xã Minh Đức', '28972', 3, 655),
(9643, 'Xã Ngãi Đăng', '28975', 3, 655),
(9644, 'Xã Cẩm Sơn', '28978', 3, 655),
(9645, 'Xã Hương Mỹ', '28981', 3, 655);

-- Tỉnh Bến Tre > Huyện Giồng Trôm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9646, 'Thị trấn Giồng Trôm', '28984', 3, 656),
(9647, 'Xã Phong Nẫm', '28987', 3, 656),
(9648, 'Xã Mỹ Thạnh', '28993', 3, 656),
(9649, 'Xã Châu Hòa', '28996', 3, 656),
(9650, 'Xã Lương Hòa', '28999', 3, 656),
(9651, 'Xã Lương Quới', '29002', 3, 656),
(9652, 'Xã Lương Phú', '29005', 3, 656),
(9653, 'Xã Châu Bình', '29008', 3, 656),
(9654, 'Xã Thuận Điền', '29011', 3, 656),
(9655, 'Xã Sơn Phú', '29014', 3, 656),
(9656, 'Xã Bình Hoà', '29017', 3, 656),
(9657, 'Xã Phước Long', '29020', 3, 656),
(9658, 'Xã Hưng Phong', '29023', 3, 656),
(9659, 'Xã Long Mỹ', '29026', 3, 656),
(9660, 'Xã Tân Hào', '29029', 3, 656),
(9661, 'Xã Bình Thành', '29032', 3, 656),
(9662, 'Xã Tân Thanh', '29035', 3, 656),
(9663, 'Xã Tân Lợi Thạnh', '29038', 3, 656),
(9664, 'Xã Thạnh Phú Đông', '29041', 3, 656),
(9665, 'Xã Hưng Nhượng', '29044', 3, 656),
(9666, 'Xã Hưng Lễ', '29047', 3, 656);

-- Tỉnh Bến Tre > Huyện Bình Đại
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9667, 'Thị trấn Bình Đại', '29050', 3, 657),
(9668, 'Xã Tam Hiệp', '29053', 3, 657),
(9669, 'Xã Long Định', '29056', 3, 657),
(9670, 'Xã Long Hòa', '29059', 3, 657),
(9671, 'Xã Phú Thuận', '29062', 3, 657),
(9672, 'Xã Vang Quới Tây', '29065', 3, 657),
(9673, 'Xã Vang Quới Đông', '29068', 3, 657),
(9674, 'Xã Châu Hưng', '29071', 3, 657),
(9675, 'Xã Lộc Thuận', '29077', 3, 657),
(9676, 'Xã Định Trung', '29080', 3, 657),
(9677, 'Xã Thới Lai', '29083', 3, 657),
(9678, 'Xã Bình Thới', '29086', 3, 657),
(9679, 'Xã Phú Long', '29089', 3, 657),
(9680, 'Xã Bình Thắng', '29092', 3, 657),
(9681, 'Xã Thạnh Trị', '29095', 3, 657),
(9682, 'Xã Đại Hòa Lộc', '29098', 3, 657),
(9683, 'Xã Thừa Đức', '29101', 3, 657),
(9684, 'Xã Thạnh Phước', '29104', 3, 657),
(9685, 'Xã Thới Thuận', '29107', 3, 657);

-- Tỉnh Bến Tre > Huyện Ba Tri
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9686, 'Thị trấn Ba Tri', '29110', 3, 658),
(9687, 'Xã Mỹ Hòa', '29116', 3, 658),
(9688, 'Xã Tân Xuân', '29119', 3, 658),
(9689, 'Xã Mỹ Chánh', '29122', 3, 658),
(9690, 'Xã Bảo Thạnh', '29125', 3, 658),
(9691, 'Xã An Phú Trung', '29128', 3, 658),
(9692, 'Xã Mỹ Thạnh', '29131', 3, 658),
(9693, 'Xã Mỹ Nhơn', '29134', 3, 658),
(9694, 'Xã Phước Ngãi', '29137', 3, 658),
(9695, 'Xã An Ngãi Trung', '29143', 3, 658),
(9696, 'Xã Phú Lễ', '29146', 3, 658),
(9697, 'Xã An Bình Tây', '29149', 3, 658),
(9698, 'Xã Bảo Thuận', '29152', 3, 658),
(9699, 'Xã Tân Hưng', '29155', 3, 658),
(9700, 'Xã An Ngãi Tây', '29158', 3, 658),
(9701, 'Xã An Hiệp', '29161', 3, 658),
(9702, 'Xã Vĩnh Hòa', '29164', 3, 658),
(9703, 'Xã Tân Thủy', '29167', 3, 658),
(9704, 'Xã Vĩnh An', '29170', 3, 658),
(9705, 'Xã An Đức', '29173', 3, 658),
(9706, 'Xã An Hòa Tây', '29176', 3, 658),
(9707, 'Thị trấn Tiệm Tôm', '29179', 3, 658);

-- Tỉnh Bến Tre > Huyện Thạnh Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9708, 'Thị trấn Thạnh Phú', '29182', 3, 659),
(9709, 'Xã Phú Khánh', '29185', 3, 659),
(9710, 'Xã Đại Điền', '29188', 3, 659),
(9711, 'Xã Quới Điền', '29191', 3, 659),
(9712, 'Xã Tân Phong', '29194', 3, 659),
(9713, 'Xã Mỹ Hưng', '29197', 3, 659),
(9714, 'Xã An Thạnh', '29200', 3, 659),
(9715, 'Xã Thới Thạnh', '29203', 3, 659),
(9716, 'Xã Hòa Lợi', '29206', 3, 659),
(9717, 'Xã An Điền', '29209', 3, 659),
(9718, 'Xã Bình Thạnh', '29212', 3, 659),
(9719, 'Xã An Thuận', '29215', 3, 659),
(9720, 'Xã An Quy', '29218', 3, 659),
(9721, 'Xã Thạnh Hải', '29221', 3, 659),
(9722, 'Xã An Nhơn', '29224', 3, 659),
(9723, 'Xã Giao Thạnh', '29227', 3, 659),
(9724, 'Xã Thạnh Phong', '29230', 3, 659),
(9725, 'Xã Mỹ An', '29233', 3, 659);

-- Tỉnh Bến Tre > Huyện Mỏ Cày Bắc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9726, 'Xã Phú Mỹ', '28889', 3, 660),
(9727, 'Xã Hưng Khánh Trung A', '28901', 3, 660),
(9728, 'Xã Thanh Tân', '28906', 3, 660),
(9729, 'Xã Thạnh Ngãi', '28909', 3, 660),
(9730, 'Xã Tân Phú Tây', '28912', 3, 660),
(9731, 'Thị trấn Phước Mỹ Trung', '28915', 3, 660),
(9732, 'Xã Tân Thành Bình', '28918', 3, 660),
(9733, 'Xã Thành An', '28921', 3, 660),
(9734, 'Xã Hòa Lộc', '28924', 3, 660),
(9735, 'Xã Tân Thanh Tây', '28927', 3, 660),
(9736, 'Xã Tân Bình', '28933', 3, 660),
(9737, 'Xã Nhuận Phú Tân', '28936', 3, 660),
(9738, 'Xã Khánh Thạnh Tân', '28948', 3, 660);

-- Tỉnh Trà Vinh > Thành phố Trà Vinh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9739, 'Phường 4', '29236', 3, 661),
(9740, 'Phường 1', '29239', 3, 661),
(9741, 'Phường 3', '29242', 3, 661),
(9742, 'Phường 5', '29248', 3, 661),
(9743, 'Phường 7', '29254', 3, 661),
(9744, 'Phường 8', '29257', 3, 661),
(9745, 'Phường 9', '29260', 3, 661),
(9746, 'Xã Long Đức', '29263', 3, 661);

-- Tỉnh Trà Vinh > Huyện Càng Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9747, 'Thị trấn Càng Long', '29266', 3, 662),
(9748, 'Xã Mỹ Cẩm', '29269', 3, 662),
(9749, 'Xã An Trường A', '29272', 3, 662),
(9750, 'Xã An Trường', '29275', 3, 662),
(9751, 'Xã Huyền Hội', '29278', 3, 662),
(9752, 'Xã Tân An', '29281', 3, 662),
(9753, 'Xã Tân Bình', '29284', 3, 662),
(9754, 'Xã Bình Phú', '29287', 3, 662),
(9755, 'Xã Phương Thạnh', '29290', 3, 662),
(9756, 'Xã Đại Phúc', '29293', 3, 662),
(9757, 'Xã Đại Phước', '29296', 3, 662),
(9758, 'Xã Nhị Long Phú', '29299', 3, 662),
(9759, 'Xã Nhị Long', '29302', 3, 662),
(9760, 'Xã Đức Mỹ', '29305', 3, 662);

-- Tỉnh Trà Vinh > Huyện Cầu Kè
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9761, 'Thị trấn Cầu Kè', '29308', 3, 663),
(9762, 'Xã Hòa Ân', '29311', 3, 663),
(9763, 'Xã Châu Điền', '29314', 3, 663),
(9764, 'Xã An Phú Tân', '29317', 3, 663),
(9765, 'Xã Hoà Tân', '29320', 3, 663),
(9766, 'Xã Ninh Thới', '29323', 3, 663),
(9767, 'Xã Phong Phú', '29326', 3, 663),
(9768, 'Xã Phong Thạnh', '29329', 3, 663),
(9769, 'Xã Tam Ngãi', '29332', 3, 663),
(9770, 'Xã Thông Hòa', '29335', 3, 663),
(9771, 'Xã Thạnh Phú', '29338', 3, 663);

-- Tỉnh Trà Vinh > Huyện Tiểu Cần
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9772, 'Thị trấn Tiểu Cần', '29341', 3, 664),
(9773, 'Thị trấn Cầu Quan', '29344', 3, 664),
(9774, 'Xã Phú Cần', '29347', 3, 664),
(9775, 'Xã Hiếu Tử', '29350', 3, 664),
(9776, 'Xã Hiếu Trung', '29353', 3, 664),
(9777, 'Xã Long Thới', '29356', 3, 664),
(9778, 'Xã Hùng Hòa', '29359', 3, 664),
(9779, 'Xã Tân Hùng', '29362', 3, 664),
(9780, 'Xã Tập Ngãi', '29365', 3, 664),
(9781, 'Xã Ngãi Hùng', '29368', 3, 664),
(9782, 'Xã Tân Hòa', '29371', 3, 664);

-- Tỉnh Trà Vinh > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9783, 'Thị trấn Châu Thành', '29374', 3, 665),
(9784, 'Xã Đa Lộc', '29377', 3, 665),
(9785, 'Xã Mỹ Chánh', '29380', 3, 665),
(9786, 'Xã Thanh Mỹ', '29383', 3, 665),
(9787, 'Xã Lương Hoà A', '29386', 3, 665),
(9788, 'Xã Lương Hòa', '29389', 3, 665),
(9789, 'Xã Song Lộc', '29392', 3, 665),
(9790, 'Xã Nguyệt Hóa', '29395', 3, 665),
(9791, 'Xã Hòa Thuận', '29398', 3, 665),
(9792, 'Xã Hòa Lợi', '29401', 3, 665),
(9793, 'Xã Phước Hảo', '29404', 3, 665),
(9794, 'Xã Hưng Mỹ', '29407', 3, 665),
(9795, 'Xã Hòa Minh', '29410', 3, 665),
(9796, 'Xã Long Hòa', '29413', 3, 665);

-- Tỉnh Trà Vinh > Huyện Cầu Ngang
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9797, 'Thị trấn Cầu Ngang', '29416', 3, 666),
(9798, 'Thị trấn Mỹ Long', '29419', 3, 666),
(9799, 'Xã Mỹ Long Bắc', '29422', 3, 666),
(9800, 'Xã Mỹ Long Nam', '29425', 3, 666),
(9801, 'Xã Mỹ Hòa', '29428', 3, 666),
(9802, 'Xã Vĩnh Kim', '29431', 3, 666),
(9803, 'Xã Kim Hòa', '29434', 3, 666),
(9804, 'Xã Hiệp Hòa', '29437', 3, 666),
(9805, 'Xã Thuận Hòa', '29440', 3, 666),
(9806, 'Xã Long Sơn', '29443', 3, 666),
(9807, 'Xã Nhị Trường', '29446', 3, 666),
(9808, 'Xã Trường Thọ', '29449', 3, 666),
(9809, 'Xã Hiệp Mỹ Đông', '29452', 3, 666),
(9810, 'Xã Hiệp Mỹ Tây', '29455', 3, 666),
(9811, 'Xã Thạnh Hòa Sơn', '29458', 3, 666);

-- Tỉnh Trà Vinh > Huyện Trà Cú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9812, 'Thị trấn Trà Cú', '29461', 3, 667),
(9813, 'Thị trấn Định An', '29462', 3, 667),
(9814, 'Xã Phước Hưng', '29464', 3, 667),
(9815, 'Xã Tập Sơn', '29467', 3, 667),
(9816, 'Xã Tân Sơn', '29470', 3, 667),
(9817, 'Xã An Quảng Hữu', '29473', 3, 667),
(9818, 'Xã Lưu Nghiệp Anh', '29476', 3, 667),
(9819, 'Xã Ngãi Xuyên', '29479', 3, 667),
(9820, 'Xã Kim Sơn', '29482', 3, 667),
(9821, 'Xã Thanh Sơn', '29485', 3, 667),
(9822, 'Xã Hàm Giang', '29488', 3, 667),
(9823, 'Xã Hàm Tân', '29489', 3, 667),
(9824, 'Xã Đại An', '29491', 3, 667),
(9825, 'Xã Định An', '29494', 3, 667),
(9826, 'Xã Ngọc Biên', '29503', 3, 667),
(9827, 'Xã Long Hiệp', '29506', 3, 667),
(9828, 'Xã Tân Hiệp', '29509', 3, 667);

-- Tỉnh Trà Vinh > Huyện Duyên Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9829, 'Xã Đôn Xuân', '29497', 3, 668),
(9830, 'Xã Đôn Châu', '29500', 3, 668),
(9831, 'Thị trấn Long Thành', '29513', 3, 668),
(9832, 'Xã Long Khánh', '29521', 3, 668),
(9833, 'Xã Ngũ Lạc', '29530', 3, 668),
(9834, 'Xã Long Vĩnh', '29533', 3, 668),
(9835, 'Xã Đông Hải', '29536', 3, 668);

-- Tỉnh Trà Vinh > Thị xã Duyên Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9836, 'Phường 1', '29512', 3, 669),
(9837, 'Xã Long Toàn', '29515', 3, 669),
(9838, 'Phường 2', '29516', 3, 669),
(9839, 'Xã Long Hữu', '29518', 3, 669),
(9840, 'Xã Dân Thành', '29524', 3, 669),
(9841, 'Xã Trường Long Hòa', '29527', 3, 669),
(9842, 'Xã Hiệp Thạnh', '29539', 3, 669);

-- Tỉnh Vĩnh Long > Thành phố Vĩnh Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9843, 'Phường 9', '29542', 3, 670),
(9844, 'Phường 5', '29545', 3, 670),
(9845, 'Phường 1', '29551', 3, 670),
(9846, 'Phường 4', '29554', 3, 670),
(9847, 'Phường 3', '29557', 3, 670),
(9848, 'Phường 8', '29560', 3, 670),
(9849, 'Phường Tân Ngãi', '29563', 3, 670),
(9850, 'Phường Tân Hòa', '29566', 3, 670),
(9851, 'Phường Tân Hội', '29569', 3, 670),
(9852, 'Phường Trường An', '29572', 3, 670);

-- Tỉnh Vĩnh Long > Huyện Long Hồ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9853, 'Xã Đồng Phú', '29578', 3, 671),
(9854, 'Xã Bình Hòa Phước', '29581', 3, 671),
(9855, 'Xã Hòa Ninh', '29584', 3, 671),
(9856, 'Xã An Bình', '29587', 3, 671),
(9857, 'Xã Thanh Đức', '29590', 3, 671),
(9858, 'Xã Tân Hạnh', '29593', 3, 671),
(9859, 'Xã Phước Hậu', '29596', 3, 671),
(9860, 'Xã Long Phước', '29599', 3, 671),
(9861, 'Thị trấn Long Hồ', '29602', 3, 671),
(9862, 'Xã Lộc Hòa', '29605', 3, 671),
(9863, 'Xã Long An', '29608', 3, 671),
(9864, 'Xã Phú Quới', '29611', 3, 671),
(9865, 'Xã Thạnh Quới', '29614', 3, 671),
(9866, 'Xã Hòa Phú', '29617', 3, 671);

-- Tỉnh Vĩnh Long > Huyện Mang Thít
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9867, 'Xã Mỹ An', '29623', 3, 672),
(9868, 'Xã Mỹ Phước', '29626', 3, 672),
(9869, 'Xã An Phước', '29629', 3, 672),
(9870, 'Xã Nhơn Phú', '29632', 3, 672),
(9871, 'Xã Long Mỹ', '29635', 3, 672),
(9872, 'Xã Hòa Tịnh', '29638', 3, 672),
(9873, 'Thị trấn Cái Nhum', '29641', 3, 672),
(9874, 'Xã Bình Phước', '29644', 3, 672),
(9875, 'Xã Chánh An', '29647', 3, 672),
(9876, 'Xã Tân An Hội', '29650', 3, 672),
(9877, 'Xã Tân Long', '29653', 3, 672),
(9878, 'Xã Tân Long Hội', '29656', 3, 672);

-- Tỉnh Vĩnh Long > Huyện Vũng Liêm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9879, 'Thị trấn Vũng Liêm', '29659', 3, 673),
(9880, 'Xã Tân Quới Trung', '29662', 3, 673),
(9881, 'Xã Quới Thiện', '29665', 3, 673),
(9882, 'Xã Quới An', '29668', 3, 673),
(9883, 'Xã Trung Chánh', '29671', 3, 673),
(9884, 'Xã Tân An Luông', '29674', 3, 673),
(9885, 'Xã Thanh Bình', '29677', 3, 673),
(9886, 'Xã Trung Thành Tây', '29680', 3, 673),
(9887, 'Xã Trung Hiệp', '29683', 3, 673),
(9888, 'Xã Hiếu Phụng', '29686', 3, 673),
(9889, 'Xã Trung Thành Đông', '29689', 3, 673),
(9890, 'Xã Trung Thành', '29692', 3, 673),
(9891, 'Xã Trung Hiếu', '29695', 3, 673),
(9892, 'Xã Trung Ngãi', '29698', 3, 673),
(9893, 'Xã Hiếu Thuận', '29701', 3, 673),
(9894, 'Xã Trung Nghĩa', '29704', 3, 673),
(9895, 'Xã Trung An', '29707', 3, 673),
(9896, 'Xã Hiếu Nhơn', '29710', 3, 673),
(9897, 'Xã Hiếu Thành', '29713', 3, 673),
(9898, 'Xã Hiếu Nghĩa', '29716', 3, 673);

-- Tỉnh Vĩnh Long > Huyện Tam Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9899, 'Thị trấn Tam Bình', '29719', 3, 674),
(9900, 'Xã Tân Lộc', '29722', 3, 674),
(9901, 'Xã Phú Thịnh', '29725', 3, 674),
(9902, 'Xã Hậu Lộc', '29728', 3, 674),
(9903, 'Xã Hòa Thạnh', '29731', 3, 674),
(9904, 'Xã Hoà Lộc', '29734', 3, 674),
(9905, 'Xã Phú Lộc', '29737', 3, 674),
(9906, 'Xã Song Phú', '29740', 3, 674),
(9907, 'Xã Hòa Hiệp', '29743', 3, 674),
(9908, 'Xã Mỹ Lộc', '29746', 3, 674),
(9909, 'Xã Tân Phú', '29749', 3, 674),
(9910, 'Xã Long Phú', '29752', 3, 674),
(9911, 'Xã Mỹ Thạnh Trung', '29755', 3, 674),
(9912, 'Xã Loan Mỹ', '29761', 3, 674),
(9913, 'Xã Ngãi Tứ', '29764', 3, 674),
(9914, 'Xã Bình Ninh', '29767', 3, 674);

-- Tỉnh Vĩnh Long > Thị xã Bình Minh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9915, 'Phường Cái Vồn', '29770', 3, 675),
(9916, 'Phường Thành Phước', '29771', 3, 675),
(9917, 'Xã Thuận An', '29806', 3, 675),
(9918, 'Xã Đông Thạnh', '29809', 3, 675),
(9919, 'Xã Đông Bình', '29812', 3, 675),
(9920, 'Phường Đông Thuận', '29813', 3, 675),
(9921, 'Xã Mỹ Hòa', '29815', 3, 675),
(9922, 'Xã Đông Thành', '29818', 3, 675);

-- Tỉnh Vĩnh Long > Huyện Trà Ôn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9923, 'Thị trấn Trà Ôn', '29821', 3, 676),
(9924, 'Xã Xuân Hiệp', '29824', 3, 676),
(9925, 'Xã Nhơn Bình', '29827', 3, 676),
(9926, 'Xã Hòa Bình', '29830', 3, 676),
(9927, 'Xã Thới Hòa', '29833', 3, 676),
(9928, 'Xã Trà Côn', '29836', 3, 676),
(9929, 'Xã Tân Mỹ', '29839', 3, 676),
(9930, 'Xã Hựu Thành', '29842', 3, 676),
(9931, 'Xã Vĩnh Xuân', '29845', 3, 676),
(9932, 'Xã Thuận Thới', '29848', 3, 676),
(9933, 'Xã Phú Thành', '29851', 3, 676),
(9934, 'Xã Lục Sỹ Thành', '29857', 3, 676),
(9935, 'Xã Tích Thiện', '29860', 3, 676);

-- Tỉnh Vĩnh Long > Huyện Bình Tân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9936, 'Xã Tân Thành', '29776', 3, 677),
(9937, 'Xã Thành Trung', '29779', 3, 677),
(9938, 'Xã Tân An Thạnh', '29782', 3, 677),
(9939, 'Xã Tân Lược', '29785', 3, 677),
(9940, 'Xã Nguyễn Văn Thảnh', '29788', 3, 677),
(9941, 'Xã Thành Lợi', '29791', 3, 677),
(9942, 'Xã Mỹ Thuận', '29794', 3, 677),
(9943, 'Xã Tân Bình', '29797', 3, 677),
(9944, 'Thị trấn Tân Quới', '29800', 3, 677);

-- Tỉnh Đồng Tháp > Thành phố Cao Lãnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9945, 'Phường 1', '29869', 3, 678),
(9946, 'Phường 4', '29872', 3, 678),
(9947, 'Phường 3', '29875', 3, 678),
(9948, 'Phường 6', '29878', 3, 678),
(9949, 'Phường Mỹ Ngãi', '29881', 3, 678),
(9950, 'Xã Mỹ Tân', '29884', 3, 678),
(9951, 'Xã Mỹ Trà', '29887', 3, 678),
(9952, 'Phường Mỹ Phú', '29888', 3, 678),
(9953, 'Xã Tân Thuận Tây', '29890', 3, 678),
(9954, 'Phường Hoà Thuận', '29892', 3, 678),
(9955, 'Xã Hòa An', '29893', 3, 678),
(9956, 'Xã Tân Thuận Đông', '29896', 3, 678),
(9957, 'Xã Tịnh Thới', '29899', 3, 678);

-- Tỉnh Đồng Tháp > Thành phố Sa Đéc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9958, 'Phường 3', '29902', 3, 679),
(9959, 'Phường 1', '29905', 3, 679),
(9960, 'Phường 4', '29908', 3, 679),
(9961, 'Phường 2', '29911', 3, 679),
(9962, 'Xã Tân Khánh Đông', '29914', 3, 679),
(9963, 'Phường Tân Quy Đông', '29917', 3, 679),
(9964, 'Phường An Hoà', '29919', 3, 679),
(9965, 'Xã Tân Quy Tây', '29920', 3, 679),
(9966, 'Xã Tân Phú Đông', '29923', 3, 679);

-- Tỉnh Đồng Tháp > Thành phố Hồng Ngự
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9967, 'Phường An Lộc', '29954', 3, 680),
(9968, 'Phường An Thạnh', '29955', 3, 680),
(9969, 'Xã Bình Thạnh', '29959', 3, 680),
(9970, 'Xã Tân Hội', '29965', 3, 680),
(9971, 'Phường An Lạc', '29978', 3, 680),
(9972, 'Phường An Bình B', '29986', 3, 680),
(9973, 'Phường An Bình A', '29989', 3, 680);

-- Tỉnh Đồng Tháp > Huyện Tân Hồng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9974, 'Thị trấn Sa Rài', '29926', 3, 681),
(9975, 'Xã Tân Hộ Cơ', '29929', 3, 681),
(9976, 'Xã Thông Bình', '29932', 3, 681),
(9977, 'Xã Bình Phú', '29935', 3, 681),
(9978, 'Xã Tân Thành A', '29938', 3, 681),
(9979, 'Xã Tân Thành B', '29941', 3, 681),
(9980, 'Xã Tân Phước', '29944', 3, 681),
(9981, 'Xã Tân Công Chí', '29947', 3, 681),
(9982, 'Xã An Phước', '29950', 3, 681);

-- Tỉnh Đồng Tháp > Huyện Hồng Ngự
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9983, 'Xã Thường Phước 1', '29956', 3, 682),
(9984, 'Xã Thường Thới Hậu A', '29962', 3, 682),
(9985, 'Thị trấn Thường Thới Tiền', '29971', 3, 682),
(9986, 'Xã Thường Phước 2', '29974', 3, 682),
(9987, 'Xã Thường Lạc', '29977', 3, 682),
(9988, 'Xã Long Khánh A', '29980', 3, 682),
(9989, 'Xã Long Khánh B', '29983', 3, 682),
(9990, 'Xã Long Thuận', '29992', 3, 682),
(9991, 'Xã Phú Thuận B', '29995', 3, 682),
(9992, 'Xã Phú Thuận A', '29998', 3, 682);

-- Tỉnh Đồng Tháp > Huyện Tam Nông
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(9993, 'Thị trấn Tràm Chim', '30001', 3, 683),
(9994, 'Xã Hoà Bình', '30004', 3, 683),
(9995, 'Xã Tân Công Sính', '30007', 3, 683),
(9996, 'Xã Phú Hiệp', '30010', 3, 683),
(9997, 'Xã Phú Đức', '30013', 3, 683),
(9998, 'Xã Phú Thành B', '30016', 3, 683),
(9999, 'Xã An Hòa', '30019', 3, 683),
(10000, 'Xã An Long', '30022', 3, 683),
(10001, 'Xã Phú Cường', '30025', 3, 683),
(10002, 'Xã Phú Ninh', '30028', 3, 683),
(10003, 'Xã Phú Thọ', '30031', 3, 683),
(10004, 'Xã Phú Thành A', '30034', 3, 683);

-- Tỉnh Đồng Tháp > Huyện Tháp Mười
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10005, 'Thị trấn Mỹ An', '30037', 3, 684),
(10006, 'Xã Thạnh Lợi', '30040', 3, 684),
(10007, 'Xã Hưng Thạnh', '30043', 3, 684),
(10008, 'Xã Trường Xuân', '30046', 3, 684),
(10009, 'Xã Tân Kiều', '30049', 3, 684),
(10010, 'Xã Mỹ Hòa', '30052', 3, 684),
(10011, 'Xã Mỹ Quý', '30055', 3, 684),
(10012, 'Xã Mỹ Đông', '30058', 3, 684),
(10013, 'Xã Đốc Binh Kiều', '30061', 3, 684),
(10014, 'Xã Mỹ An', '30064', 3, 684),
(10015, 'Xã Phú Điền', '30067', 3, 684),
(10016, 'Xã Láng Biển', '30070', 3, 684),
(10017, 'Xã Thanh Mỹ', '30073', 3, 684);

-- Tỉnh Đồng Tháp > Huyện Cao Lãnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10018, 'Thị trấn Mỹ Thọ', '30076', 3, 685),
(10019, 'Xã Gáo Giồng', '30079', 3, 685),
(10020, 'Xã Phương Thịnh', '30082', 3, 685),
(10021, 'Xã Ba Sao', '30085', 3, 685),
(10022, 'Xã Phong Mỹ', '30088', 3, 685),
(10023, 'Xã Tân Nghĩa', '30091', 3, 685),
(10024, 'Xã Phương Trà', '30094', 3, 685),
(10025, 'Xã Nhị Mỹ', '30097', 3, 685),
(10026, 'Xã Mỹ Thọ', '30100', 3, 685),
(10027, 'Xã Tân Hội Trung', '30103', 3, 685),
(10028, 'Xã An Bình', '30106', 3, 685),
(10029, 'Xã Mỹ Hội', '30109', 3, 685),
(10030, 'Xã Mỹ Hiệp', '30112', 3, 685),
(10031, 'Xã Mỹ Long', '30115', 3, 685),
(10032, 'Xã Bình Hàng Trung', '30118', 3, 685),
(10033, 'Xã Mỹ Xương', '30121', 3, 685),
(10034, 'Xã Bình Hàng Tây', '30124', 3, 685),
(10035, 'Xã Bình Thạnh', '30127', 3, 685);

-- Tỉnh Đồng Tháp > Huyện Thanh Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10036, 'Thị trấn Thanh Bình', '30130', 3, 686),
(10037, 'Xã Tân Quới', '30133', 3, 686),
(10038, 'Xã Tân Hòa', '30136', 3, 686),
(10039, 'Xã An Phong', '30139', 3, 686),
(10040, 'Xã Phú Lợi', '30142', 3, 686),
(10041, 'Xã Tân Mỹ', '30145', 3, 686),
(10042, 'Xã Bình Tấn', '30148', 3, 686),
(10043, 'Xã Tân Huề', '30151', 3, 686),
(10044, 'Xã Tân Bình', '30154', 3, 686),
(10045, 'Xã Tân Thạnh', '30157', 3, 686),
(10046, 'Xã Tân Phú', '30160', 3, 686),
(10047, 'Xã Bình Thành', '30163', 3, 686),
(10048, 'Xã Tân Long', '30166', 3, 686);

-- Tỉnh Đồng Tháp > Huyện Lấp Vò
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10049, 'Thị trấn Lấp Vò', '30169', 3, 687),
(10050, 'Xã Mỹ An Hưng A', '30172', 3, 687),
(10051, 'Xã Tân Mỹ', '30175', 3, 687),
(10052, 'Xã Mỹ An Hưng B', '30178', 3, 687),
(10053, 'Xã Tân Khánh Trung', '30181', 3, 687),
(10054, 'Xã Long Hưng A', '30184', 3, 687),
(10055, 'Xã Vĩnh Thạnh', '30187', 3, 687),
(10056, 'Xã Long Hưng B', '30190', 3, 687),
(10057, 'Xã Bình Thành', '30193', 3, 687),
(10058, 'Xã Định An', '30196', 3, 687),
(10059, 'Xã Định Yên', '30199', 3, 687),
(10060, 'Xã Hội An Đông', '30202', 3, 687),
(10061, 'Xã Bình Thạnh Trung', '30205', 3, 687);

-- Tỉnh Đồng Tháp > Huyện Lai Vung
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10062, 'Thị trấn Lai Vung', '30208', 3, 688),
(10063, 'Xã Tân Dương', '30211', 3, 688),
(10064, 'Xã Hòa Thành', '30214', 3, 688),
(10065, 'Xã Long Hậu', '30217', 3, 688),
(10066, 'Xã Tân Phước', '30220', 3, 688),
(10067, 'Xã Hòa Long', '30223', 3, 688),
(10068, 'Xã Tân Thành', '30226', 3, 688),
(10069, 'Xã Long Thắng', '30229', 3, 688),
(10070, 'Xã Vĩnh Thới', '30232', 3, 688),
(10071, 'Xã Tân Hòa', '30235', 3, 688),
(10072, 'Xã Định Hòa', '30238', 3, 688),
(10073, 'Xã Phong Hòa', '30241', 3, 688);

-- Tỉnh Đồng Tháp > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10074, 'Thị trấn Cái Tàu Hạ', '30244', 3, 689),
(10075, 'Xã An Hiệp', '30247', 3, 689),
(10076, 'Xã An Nhơn', '30250', 3, 689),
(10077, 'Xã Tân Nhuận Đông', '30253', 3, 689),
(10078, 'Xã Tân Bình', '30256', 3, 689),
(10079, 'Xã Tân Phú Trung', '30259', 3, 689),
(10080, 'Xã Phú Long', '30262', 3, 689),
(10081, 'Xã An Phú Thuận', '30265', 3, 689),
(10082, 'Xã Phú Hựu', '30268', 3, 689),
(10083, 'Xã An Khánh', '30271', 3, 689),
(10084, 'Xã Tân Phú', '30274', 3, 689),
(10085, 'Xã Hòa Tân', '30277', 3, 689);

-- Tỉnh An Giang > Thành phố Long Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10086, 'Phường Mỹ Bình', '30280', 3, 690),
(10087, 'Phường Mỹ Long', '30283', 3, 690),
(10088, 'Phường Mỹ Xuyên', '30286', 3, 690),
(10089, 'Phường Bình Đức', '30289', 3, 690),
(10090, 'Phường Bình Khánh', '30292', 3, 690),
(10091, 'Phường Mỹ Phước', '30295', 3, 690),
(10092, 'Phường Mỹ Quý', '30298', 3, 690),
(10093, 'Phường Mỹ Thới', '30301', 3, 690),
(10094, 'Phường Mỹ Thạnh', '30304', 3, 690),
(10095, 'Phường Mỹ Hòa', '30307', 3, 690),
(10096, 'Xã Mỹ Khánh', '30310', 3, 690),
(10097, 'Xã Mỹ Hoà Hưng', '30313', 3, 690);

-- Tỉnh An Giang > Thành phố Châu Đốc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10098, 'Phường Châu Phú B', '30316', 3, 691),
(10099, 'Phường Châu Phú A', '30319', 3, 691),
(10100, 'Phường Vĩnh Mỹ', '30322', 3, 691),
(10101, 'Phường Núi Sam', '30325', 3, 691),
(10102, 'Phường Vĩnh Ngươn', '30328', 3, 691),
(10103, 'Xã Vĩnh Tế', '30331', 3, 691),
(10104, 'Xã Vĩnh Châu', '30334', 3, 691);

-- Tỉnh An Giang > Huyện An Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10105, 'Thị trấn An Phú', '30337', 3, 692),
(10106, 'Xã Khánh An', '30340', 3, 692),
(10107, 'Thị trấn Long Bình', '30341', 3, 692),
(10108, 'Xã Khánh Bình', '30343', 3, 692),
(10109, 'Xã Quốc Thái', '30346', 3, 692),
(10110, 'Xã Nhơn Hội', '30349', 3, 692),
(10111, 'Xã Phú Hữu', '30352', 3, 692),
(10112, 'Xã Phú Hội', '30355', 3, 692),
(10113, 'Xã Phước Hưng', '30358', 3, 692),
(10114, 'Xã Vĩnh Lộc', '30361', 3, 692),
(10115, 'Xã Vĩnh Hậu', '30364', 3, 692),
(10116, 'Xã Vĩnh Trường', '30367', 3, 692),
(10117, 'Xã Vĩnh Hội Đông', '30370', 3, 692),
(10118, 'Thị trấn Đa Phước', '30373', 3, 692);

-- Tỉnh An Giang > Thị xã Tân Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10119, 'Phường Long Thạnh', '30376', 3, 693),
(10120, 'Phường Long Hưng', '30377', 3, 693),
(10121, 'Phường Long Châu', '30378', 3, 693),
(10122, 'Xã Phú Lộc', '30379', 3, 693),
(10123, 'Xã Vĩnh Xương', '30382', 3, 693),
(10124, 'Xã Vĩnh Hòa', '30385', 3, 693),
(10125, 'Xã Tân Thạnh', '30387', 3, 693),
(10126, 'Xã Tân An', '30388', 3, 693),
(10127, 'Xã Long An', '30391', 3, 693),
(10128, 'Phường Long Phú', '30394', 3, 693),
(10129, 'Xã Châu Phong', '30397', 3, 693),
(10130, 'Xã Phú Vĩnh', '30400', 3, 693),
(10131, 'Xã Lê Chánh', '30403', 3, 693),
(10132, 'Phường Long Sơn', '30412', 3, 693);

-- Tỉnh An Giang > Huyện Phú Tân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10133, 'Thị trấn Phú Mỹ', '30406', 3, 694),
(10134, 'Thị trấn Chợ Vàm', '30409', 3, 694),
(10135, 'Xã Long Hoà', '30415', 3, 694),
(10136, 'Xã Phú Long', '30418', 3, 694),
(10137, 'Xã Phú Lâm', '30421', 3, 694),
(10138, 'Xã Phú Hiệp', '30424', 3, 694),
(10139, 'Xã Phú Thạnh', '30427', 3, 694),
(10140, 'Xã Hoà Lạc', '30430', 3, 694),
(10141, 'Xã Phú Thành', '30433', 3, 694),
(10142, 'Xã Phú An', '30436', 3, 694),
(10143, 'Xã Phú Xuân', '30439', 3, 694),
(10144, 'Xã Hiệp Xương', '30442', 3, 694),
(10145, 'Xã Phú Bình', '30445', 3, 694),
(10146, 'Xã Phú Thọ', '30448', 3, 694),
(10147, 'Xã Phú Hưng', '30451', 3, 694),
(10148, 'Xã Bình Thạnh Đông', '30454', 3, 694),
(10149, 'Xã Tân Hòa', '30457', 3, 694),
(10150, 'Xã Tân Trung', '30460', 3, 694);

-- Tỉnh An Giang > Huyện Châu Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10151, 'Thị trấn Cái Dầu', '30463', 3, 695),
(10152, 'Xã Khánh Hòa', '30466', 3, 695),
(10153, 'Xã Mỹ Đức', '30469', 3, 695),
(10154, 'Xã Mỹ Phú', '30472', 3, 695),
(10155, 'Xã Ô Long Vỹ', '30475', 3, 695),
(10156, 'Thị trấn Vĩnh Thạnh Trung', '30478', 3, 695),
(10157, 'Xã Thạnh Mỹ Tây', '30481', 3, 695),
(10158, 'Xã Bình Long', '30484', 3, 695),
(10159, 'Xã Bình Mỹ', '30487', 3, 695),
(10160, 'Xã Bình Thủy', '30490', 3, 695),
(10161, 'Xã Đào Hữu Cảnh', '30493', 3, 695),
(10162, 'Xã Bình Phú', '30496', 3, 695),
(10163, 'Xã Bình Chánh', '30499', 3, 695);

-- Tỉnh An Giang > Thị xã Tịnh Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10164, 'Phường Nhà Bàng', '30502', 3, 696),
(10165, 'Phường Chi Lăng', '30505', 3, 696),
(10166, 'Phường Núi Voi', '30508', 3, 696),
(10167, 'Phường Nhơn Hưng', '30511', 3, 696),
(10168, 'Phường An Phú', '30514', 3, 696),
(10169, 'Phường Thới Sơn', '30517', 3, 696),
(10170, 'Phường Tịnh Biên', '30520', 3, 696),
(10171, 'Xã Văn Giáo', '30523', 3, 696),
(10172, 'Xã An Cư', '30526', 3, 696),
(10173, 'Xã An Nông', '30529', 3, 696),
(10174, 'Xã Vĩnh Trung', '30532', 3, 696),
(10175, 'Xã Tân Lợi', '30535', 3, 696),
(10176, 'Xã An Hảo', '30538', 3, 696),
(10177, 'Xã Tân Lập', '30541', 3, 696);

-- Tỉnh An Giang > Huyện Tri Tôn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10178, 'Thị trấn Tri Tôn', '30544', 3, 697),
(10179, 'Thị trấn Ba Chúc', '30547', 3, 697),
(10180, 'Xã Lạc Quới', '30550', 3, 697),
(10181, 'Xã Lê Trì', '30553', 3, 697),
(10182, 'Xã Vĩnh Gia', '30556', 3, 697),
(10183, 'Xã Vĩnh Phước', '30559', 3, 697),
(10184, 'Xã Châu Lăng', '30562', 3, 697),
(10185, 'Xã Lương Phi', '30565', 3, 697),
(10186, 'Xã Lương An Trà', '30568', 3, 697),
(10187, 'Xã Tà Đảnh', '30571', 3, 697),
(10188, 'Xã Núi Tô', '30574', 3, 697),
(10189, 'Xã An Tức', '30577', 3, 697),
(10190, 'Thị trấn Cô Tô', '30580', 3, 697),
(10191, 'Xã Tân Tuyến', '30583', 3, 697),
(10192, 'Xã Ô Lâm', '30586', 3, 697);

-- Tỉnh An Giang > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10193, 'Thị trấn An Châu', '30589', 3, 698),
(10194, 'Xã An Hòa', '30592', 3, 698),
(10195, 'Xã Cần Đăng', '30595', 3, 698),
(10196, 'Xã Vĩnh Hanh', '30598', 3, 698),
(10197, 'Xã Bình Thạnh', '30601', 3, 698),
(10198, 'Thị trấn Vĩnh Bình', '30604', 3, 698),
(10199, 'Xã Bình Hòa', '30607', 3, 698),
(10200, 'Xã Vĩnh An', '30610', 3, 698),
(10201, 'Xã Hòa Bình Thạnh', '30613', 3, 698),
(10202, 'Xã Vĩnh Lợi', '30616', 3, 698),
(10203, 'Xã Vĩnh Nhuận', '30619', 3, 698),
(10204, 'Xã Tân Phú', '30622', 3, 698),
(10205, 'Xã Vĩnh Thành', '30625', 3, 698);

-- Tỉnh An Giang > Huyện Chợ Mới
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10206, 'Thị trấn Chợ Mới', '30628', 3, 699),
(10207, 'Thị trấn Mỹ Luông', '30631', 3, 699),
(10208, 'Xã Kiến An', '30634', 3, 699),
(10209, 'Xã Mỹ Hội Đông', '30637', 3, 699),
(10210, 'Xã Long Điền A', '30640', 3, 699),
(10211, 'Xã Tấn Mỹ', '30643', 3, 699),
(10212, 'Xã Long Điền B', '30646', 3, 699),
(10213, 'Xã Kiến Thành', '30649', 3, 699),
(10214, 'Xã Mỹ Hiệp', '30652', 3, 699),
(10215, 'Xã Mỹ An', '30655', 3, 699),
(10216, 'Xã Nhơn Mỹ', '30658', 3, 699),
(10217, 'Xã Long Giang', '30661', 3, 699),
(10218, 'Xã Long Kiến', '30664', 3, 699),
(10219, 'Xã Bình Phước Xuân', '30667', 3, 699),
(10220, 'Xã An Thạnh Trung', '30670', 3, 699),
(10221, 'Thị trấn Hội An', '30673', 3, 699),
(10222, 'Xã Hòa Bình', '30676', 3, 699),
(10223, 'Xã Hòa An', '30679', 3, 699);

-- Tỉnh An Giang > Huyện Thoại Sơn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10224, 'Thị trấn Núi Sập', '30682', 3, 700),
(10225, 'Thị trấn Phú Hoà', '30685', 3, 700),
(10226, 'Thị trấn Óc Eo', '30688', 3, 700),
(10227, 'Xã Tây Phú', '30691', 3, 700),
(10228, 'Xã An Bình', '30692', 3, 700),
(10229, 'Xã Vĩnh Phú', '30694', 3, 700),
(10230, 'Xã Vĩnh Trạch', '30697', 3, 700),
(10231, 'Xã Phú Thuận', '30700', 3, 700),
(10232, 'Xã Vĩnh Chánh', '30703', 3, 700),
(10233, 'Xã Định Mỹ', '30706', 3, 700),
(10234, 'Xã Định Thành', '30709', 3, 700),
(10235, 'Xã Mỹ Phú Đông', '30712', 3, 700),
(10236, 'Xã Vọng Đông', '30715', 3, 700),
(10237, 'Xã Vĩnh Khánh', '30718', 3, 700),
(10238, 'Xã Thoại Giang', '30721', 3, 700),
(10239, 'Xã Bình Thành', '30724', 3, 700),
(10240, 'Xã Vọng Thê', '30727', 3, 700);

-- Tỉnh Kiên Giang > Thành phố Rạch Giá
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10241, 'Phường Vĩnh Thanh', '30733', 3, 701),
(10242, 'Phường Vĩnh Quang', '30736', 3, 701),
(10243, 'Phường Vĩnh Hiệp', '30739', 3, 701),
(10244, 'Phường Vĩnh Thanh Vân', '30742', 3, 701),
(10245, 'Phường Vĩnh Lạc', '30745', 3, 701),
(10246, 'Phường An Hòa', '30748', 3, 701),
(10247, 'Phường An Bình', '30751', 3, 701),
(10248, 'Phường Rạch Sỏi', '30754', 3, 701),
(10249, 'Phường Vĩnh Lợi', '30757', 3, 701),
(10250, 'Phường Vĩnh Thông', '30760', 3, 701),
(10251, 'Xã Phi Thông', '30763', 3, 701);

-- Tỉnh Kiên Giang > Thành phố Hà Tiên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10252, 'Phường Tô Châu', '30766', 3, 702),
(10253, 'Phường Đông Hồ', '30769', 3, 702),
(10254, 'Phường Bình San', '30772', 3, 702),
(10255, 'Phường Pháo Đài', '30775', 3, 702),
(10256, 'Phường Mỹ Đức', '30778', 3, 702),
(10257, 'Xã Tiên Hải', '30781', 3, 702),
(10258, 'Xã Thuận Yên', '30784', 3, 702);

-- Tỉnh Kiên Giang > Huyện Kiên Lương
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10259, 'Thị trấn Kiên Lương', '30787', 3, 703),
(10260, 'Xã Kiên Bình', '30790', 3, 703),
(10261, 'Xã Hòa Điền', '30802', 3, 703),
(10262, 'Xã Dương Hòa', '30805', 3, 703),
(10263, 'Xã Bình An', '30808', 3, 703),
(10264, 'Xã Bình Trị', '30809', 3, 703),
(10265, 'Xã Sơn Hải', '30811', 3, 703),
(10266, 'Xã Hòn Nghệ', '30814', 3, 703);

-- Tỉnh Kiên Giang > Huyện Hòn Đất
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10267, 'Thị trấn Hòn Đất', '30817', 3, 704),
(10268, 'Thị trấn Sóc Sơn', '30820', 3, 704),
(10269, 'Xã Bình Sơn', '30823', 3, 704),
(10270, 'Xã Bình Giang', '30826', 3, 704),
(10271, 'Xã Mỹ Thái', '30828', 3, 704),
(10272, 'Xã Nam Thái Sơn', '30829', 3, 704),
(10273, 'Xã Mỹ Hiệp Sơn', '30832', 3, 704),
(10274, 'Xã Sơn Kiên', '30835', 3, 704),
(10275, 'Xã Sơn Bình', '30836', 3, 704),
(10276, 'Xã Mỹ Thuận', '30838', 3, 704),
(10277, 'Xã Lình Huỳnh', '30840', 3, 704),
(10278, 'Xã Thổ Sơn', '30841', 3, 704),
(10279, 'Xã Mỹ Lâm', '30844', 3, 704),
(10280, 'Xã Mỹ Phước', '30847', 3, 704);

-- Tỉnh Kiên Giang > Huyện Tân Hiệp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10281, 'Thị trấn Tân Hiệp', '30850', 3, 705),
(10282, 'Xã Tân Hội', '30853', 3, 705),
(10283, 'Xã Tân Thành', '30856', 3, 705),
(10284, 'Xã Tân Hiệp B', '30859', 3, 705),
(10285, 'Xã Tân Hoà', '30860', 3, 705),
(10286, 'Xã Thạnh Đông B', '30862', 3, 705),
(10287, 'Xã Thạnh Đông', '30865', 3, 705),
(10288, 'Xã Tân Hiệp A', '30868', 3, 705),
(10289, 'Xã Tân An', '30871', 3, 705),
(10290, 'Xã Thạnh Đông A', '30874', 3, 705),
(10291, 'Xã Thạnh Trị', '30877', 3, 705);

-- Tỉnh Kiên Giang > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10292, 'Thị trấn Minh Lương', '30880', 3, 706),
(10293, 'Xã Mong Thọ A', '30883', 3, 706),
(10294, 'Xã Mong Thọ B', '30886', 3, 706),
(10295, 'Xã Mong Thọ', '30887', 3, 706),
(10296, 'Xã Giục Tượng', '30889', 3, 706),
(10297, 'Xã Vĩnh Hòa Hiệp', '30892', 3, 706),
(10298, 'Xã Vĩnh Hoà Phú', '30893', 3, 706),
(10299, 'Xã Minh Hòa', '30895', 3, 706),
(10300, 'Xã Bình An', '30898', 3, 706),
(10301, 'Xã Thạnh Lộc', '30901', 3, 706);

-- Tỉnh Kiên Giang > Huyện Giồng Riềng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10302, 'Thị trấn Giồng Riềng', '30904', 3, 707),
(10303, 'Xã Thạnh Hưng', '30907', 3, 707),
(10304, 'Xã Thạnh Phước', '30910', 3, 707),
(10305, 'Xã Thạnh Lộc', '30913', 3, 707),
(10306, 'Xã Thạnh Hòa', '30916', 3, 707),
(10307, 'Xã Thạnh Bình', '30917', 3, 707),
(10308, 'Xã Bàn Thạch', '30919', 3, 707),
(10309, 'Xã Bàn Tân Định', '30922', 3, 707),
(10310, 'Xã Ngọc Thành', '30925', 3, 707),
(10311, 'Xã Ngọc Chúc', '30928', 3, 707),
(10312, 'Xã Ngọc Thuận', '30931', 3, 707),
(10313, 'Xã Hòa Hưng', '30934', 3, 707),
(10314, 'Xã Hoà Lợi', '30937', 3, 707),
(10315, 'Xã Hoà An', '30940', 3, 707),
(10316, 'Xã Long Thạnh', '30943', 3, 707),
(10317, 'Xã Vĩnh Thạnh', '30946', 3, 707),
(10318, 'Xã Vĩnh Phú', '30947', 3, 707),
(10319, 'Xã Hòa Thuận', '30949', 3, 707),
(10320, 'Xã Ngọc Hoà', '30950', 3, 707);

-- Tỉnh Kiên Giang > Huyện Gò Quao
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10321, 'Thị trấn Gò Quao', '30952', 3, 708),
(10322, 'Xã Vĩnh Hòa Hưng Bắc', '30955', 3, 708),
(10323, 'Xã Định Hòa', '30958', 3, 708),
(10324, 'Xã Thới Quản', '30961', 3, 708),
(10325, 'Xã Định An', '30964', 3, 708),
(10326, 'Xã Thủy Liễu', '30967', 3, 708),
(10327, 'Xã Vĩnh Hòa Hưng Nam', '30970', 3, 708),
(10328, 'Xã Vĩnh Phước A', '30973', 3, 708),
(10329, 'Xã Vĩnh Phước B', '30976', 3, 708),
(10330, 'Xã Vĩnh Tuy', '30979', 3, 708),
(10331, 'Xã Vĩnh Thắng', '30982', 3, 708);

-- Tỉnh Kiên Giang > Huyện An Biên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10332, 'Thị trấn Thứ Ba', '30985', 3, 709),
(10333, 'Xã Tây Yên', '30988', 3, 709),
(10334, 'Xã Tây Yên A', '30991', 3, 709),
(10335, 'Xã Nam Yên', '30994', 3, 709),
(10336, 'Xã Hưng Yên', '30997', 3, 709),
(10337, 'Xã Nam Thái', '31000', 3, 709),
(10338, 'Xã Nam Thái A', '31003', 3, 709),
(10339, 'Xã Đông Thái', '31006', 3, 709),
(10340, 'Xã Đông Yên', '31009', 3, 709);

-- Tỉnh Kiên Giang > Huyện An Minh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10341, 'Thị trấn Thứ Mười Một', '31018', 3, 710),
(10342, 'Xã Thuận Hoà', '31021', 3, 710),
(10343, 'Xã Đông Hòa', '31024', 3, 710),
(10344, 'Xã Đông Thạnh', '31030', 3, 710),
(10345, 'Xã Tân Thạnh', '31031', 3, 710),
(10346, 'Xã Đông Hưng', '31033', 3, 710),
(10347, 'Xã Đông Hưng A', '31036', 3, 710),
(10348, 'Xã Đông Hưng B', '31039', 3, 710),
(10349, 'Xã Vân Khánh', '31042', 3, 710),
(10350, 'Xã Vân Khánh Đông', '31045', 3, 710),
(10351, 'Xã Vân Khánh Tây', '31048', 3, 710);

-- Tỉnh Kiên Giang > Huyện Vĩnh Thuận
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10352, 'Thị trấn Vĩnh Thuận', '31051', 3, 711),
(10353, 'Xã Vĩnh Bình Bắc', '31060', 3, 711),
(10354, 'Xã Vĩnh Bình Nam', '31063', 3, 711),
(10355, 'Xã Bình Minh', '31064', 3, 711),
(10356, 'Xã Vĩnh Thuận', '31069', 3, 711),
(10357, 'Xã Tân Thuận', '31072', 3, 711),
(10358, 'Xã Phong Đông', '31074', 3, 711),
(10359, 'Xã Vĩnh Phong', '31075', 3, 711);

-- Tỉnh Kiên Giang > Thành phố Phú Quốc
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10360, 'Phường Dương Đông', '31078', 3, 712),
(10361, 'Phường An Thới', '31081', 3, 712),
(10362, 'Xã Cửa Cạn', '31084', 3, 712),
(10363, 'Xã Gành Dầu', '31087', 3, 712),
(10364, 'Xã Cửa Dương', '31090', 3, 712),
(10365, 'Xã Hàm Ninh', '31093', 3, 712),
(10366, 'Xã Dương Tơ', '31096', 3, 712),
(10367, 'Xã Bãi Thơm', '31102', 3, 712),
(10368, 'Xã Thổ Châu', '31105', 3, 712);

-- Tỉnh Kiên Giang > Huyện Kiên Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10369, 'Xã Hòn Tre', '31108', 3, 713),
(10370, 'Xã Lại Sơn', '31111', 3, 713),
(10371, 'Xã An Sơn', '31114', 3, 713),
(10372, 'Xã Nam Du', '31115', 3, 713);

-- Tỉnh Kiên Giang > Huyện U Minh Thượng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10373, 'Xã Thạnh Yên', '31012', 3, 714),
(10374, 'Xã Thạnh Yên A', '31015', 3, 714),
(10375, 'Xã An Minh Bắc', '31027', 3, 714),
(10376, 'Xã Vĩnh Hòa', '31054', 3, 714),
(10377, 'Xã Hoà Chánh', '31057', 3, 714),
(10378, 'Xã Minh Thuận', '31066', 3, 714);

-- Tỉnh Kiên Giang > Huyện Giang Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10379, 'Xã Vĩnh Phú', '30791', 3, 715),
(10380, 'Xã Vĩnh Điều', '30793', 3, 715),
(10381, 'Xã Tân Khánh Hòa', '30796', 3, 715),
(10382, 'Xã Phú Lợi', '30797', 3, 715),
(10383, 'Xã Phú Mỹ', '30799', 3, 715);

-- Thành phố Cần Thơ > Quận Ninh Kiều
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10384, 'Phường Cái Khế', '31117', 3, 716),
(10385, 'Phường An Hòa', '31120', 3, 716),
(10386, 'Phường Thới Bình', '31123', 3, 716),
(10387, 'Phường Tân An', '31135', 3, 716),
(10388, 'Phường Xuân Khánh', '31144', 3, 716),
(10389, 'Phường Hưng Lợi', '31147', 3, 716),
(10390, 'Phường An Khánh', '31149', 3, 716),
(10391, 'Phường An Bình', '31150', 3, 716);

-- Thành phố Cần Thơ > Quận Ô Môn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10392, 'Phường Châu Văn Liêm', '31153', 3, 717),
(10393, 'Phường Thới Hòa', '31154', 3, 717),
(10394, 'Phường Thới Long', '31156', 3, 717),
(10395, 'Phường Long Hưng', '31157', 3, 717),
(10396, 'Phường Thới An', '31159', 3, 717),
(10397, 'Phường Phước Thới', '31162', 3, 717),
(10398, 'Phường Trường Lạc', '31165', 3, 717);

-- Thành phố Cần Thơ > Quận Bình Thuỷ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10399, 'Phường Bình Thủy', '31168', 3, 718),
(10400, 'Phường Trà An', '31169', 3, 718),
(10401, 'Phường Trà Nóc', '31171', 3, 718),
(10402, 'Phường Thới An Đông', '31174', 3, 718),
(10403, 'Phường An Thới', '31177', 3, 718),
(10404, 'Phường Bùi Hữu Nghĩa', '31178', 3, 718),
(10405, 'Phường Long Hòa', '31180', 3, 718),
(10406, 'Phường Long Tuyền', '31183', 3, 718);

-- Thành phố Cần Thơ > Quận Cái Răng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10407, 'Phường Lê Bình', '31186', 3, 719),
(10408, 'Phường Hưng Phú', '31189', 3, 719),
(10409, 'Phường Hưng Thạnh', '31192', 3, 719),
(10410, 'Phường Ba Láng', '31195', 3, 719),
(10411, 'Phường Thường Thạnh', '31198', 3, 719),
(10412, 'Phường Phú Thứ', '31201', 3, 719),
(10413, 'Phường Tân Phú', '31204', 3, 719);

-- Thành phố Cần Thơ > Quận Thốt Nốt
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10414, 'Phường Thốt Nốt', '31207', 3, 720),
(10415, 'Phường Thới Thuận', '31210', 3, 720),
(10416, 'Phường Thuận An', '31212', 3, 720),
(10417, 'Phường Tân Lộc', '31213', 3, 720),
(10418, 'Phường Trung Nhứt', '31216', 3, 720),
(10419, 'Phường Thạnh Hoà', '31217', 3, 720),
(10420, 'Phường Trung Kiên', '31219', 3, 720),
(10421, 'Phường Tân Hưng', '31227', 3, 720),
(10422, 'Phường Thuận Hưng', '31228', 3, 720);

-- Thành phố Cần Thơ > Huyện Vĩnh Thạnh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10423, 'Xã Vĩnh Bình', '31211', 3, 721),
(10424, 'Thị trấn Thanh An', '31231', 3, 721),
(10425, 'Thị trấn Vĩnh Thạnh', '31232', 3, 721),
(10426, 'Xã Thạnh Mỹ', '31234', 3, 721),
(10427, 'Xã Vĩnh Trinh', '31237', 3, 721),
(10428, 'Xã Thạnh An', '31240', 3, 721),
(10429, 'Xã Thạnh Tiến', '31241', 3, 721),
(10430, 'Xã Thạnh Thắng', '31243', 3, 721),
(10431, 'Xã Thạnh Lợi', '31244', 3, 721),
(10432, 'Xã Thạnh Qưới', '31246', 3, 721),
(10433, 'Xã Thạnh Lộc', '31252', 3, 721);

-- Thành phố Cần Thơ > Huyện Cờ Đỏ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10434, 'Xã Trung An', '31222', 3, 722),
(10435, 'Xã Trung Thạnh', '31225', 3, 722),
(10436, 'Xã Thạnh Phú', '31249', 3, 722),
(10437, 'Xã Trung Hưng', '31255', 3, 722),
(10438, 'Thị trấn Cờ Đỏ', '31261', 3, 722),
(10439, 'Xã Thới Hưng', '31264', 3, 722),
(10440, 'Xã Đông Hiệp', '31273', 3, 722),
(10441, 'Xã Đông Thắng', '31274', 3, 722),
(10442, 'Xã Thới Đông', '31276', 3, 722),
(10443, 'Xã Thới Xuân', '31277', 3, 722);

-- Thành phố Cần Thơ > Huyện Phong Điền
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10444, 'Thị trấn Phong Điền', '31299', 3, 723),
(10445, 'Xã Nhơn Ái', '31300', 3, 723),
(10446, 'Xã Giai Xuân', '31303', 3, 723),
(10447, 'Xã Tân Thới', '31306', 3, 723),
(10448, 'Xã Trường Long', '31309', 3, 723),
(10449, 'Xã Mỹ Khánh', '31312', 3, 723),
(10450, 'Xã Nhơn Nghĩa', '31315', 3, 723);

-- Thành phố Cần Thơ > Huyện Thới Lai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10451, 'Thị trấn Thới Lai', '31258', 3, 724),
(10452, 'Xã Thới Thạnh', '31267', 3, 724),
(10453, 'Xã Tân Thạnh', '31268', 3, 724),
(10454, 'Xã Xuân Thắng', '31270', 3, 724),
(10455, 'Xã Đông Bình', '31279', 3, 724),
(10456, 'Xã Đông Thuận', '31282', 3, 724),
(10457, 'Xã Thới Tân', '31285', 3, 724),
(10458, 'Xã Trường Thắng', '31286', 3, 724),
(10459, 'Xã Định Môn', '31288', 3, 724),
(10460, 'Xã Trường Thành', '31291', 3, 724),
(10461, 'Xã Trường Xuân', '31294', 3, 724),
(10462, 'Xã Trường Xuân A', '31297', 3, 724),
(10463, 'Xã Trường Xuân B', '31298', 3, 724);

-- Tỉnh Hậu Giang > Thành phố Vị Thanh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10464, 'Phường I', '31318', 3, 725),
(10465, 'Phường III', '31321', 3, 725),
(10466, 'Phường IV', '31324', 3, 725),
(10467, 'Phường V', '31327', 3, 725),
(10468, 'Phường VII', '31330', 3, 725),
(10469, 'Xã Vị Tân', '31333', 3, 725),
(10470, 'Xã Hoả Lựu', '31336', 3, 725),
(10471, 'Xã Tân Tiến', '31338', 3, 725),
(10472, 'Xã Hoả Tiến', '31339', 3, 725);

-- Tỉnh Hậu Giang > Thành phố Ngã Bảy
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10473, 'Phường Ngã Bảy', '31340', 3, 726),
(10474, 'Phường Lái Hiếu', '31341', 3, 726),
(10475, 'Phường Hiệp Thành', '31343', 3, 726),
(10476, 'Phường Hiệp Lợi', '31344', 3, 726),
(10477, 'Xã Đại Thành', '31411', 3, 726),
(10478, 'Xã Tân Thành', '31414', 3, 726);

-- Tỉnh Hậu Giang > Huyện Châu Thành A
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10479, 'Thị trấn Một Ngàn', '31342', 3, 727),
(10480, 'Xã Tân Hoà', '31345', 3, 727),
(10481, 'Thị trấn Bảy Ngàn', '31346', 3, 727),
(10482, 'Xã Trường Long Tây', '31348', 3, 727),
(10483, 'Xã Trường Long A', '31351', 3, 727),
(10484, 'Xã Nhơn Nghĩa A', '31357', 3, 727),
(10485, 'Thị trấn Rạch Gòi', '31359', 3, 727),
(10486, 'Xã Thạnh Xuân', '31360', 3, 727),
(10487, 'Thị trấn Cái Tắc', '31362', 3, 727),
(10488, 'Xã Tân Phú Thạnh', '31363', 3, 727);

-- Tỉnh Hậu Giang > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10489, 'Thị trấn Ngã Sáu', '31366', 3, 728),
(10490, 'Xã Đông Thạnh', '31369', 3, 728),
(10491, 'Xã Đông Phú', '31375', 3, 728),
(10492, 'Xã Phú Hữu', '31378', 3, 728),
(10493, 'Xã Phú Tân', '31379', 3, 728),
(10494, 'Thị trấn Mái Dầm', '31381', 3, 728),
(10495, 'Xã Đông Phước', '31384', 3, 728),
(10496, 'Xã Đông Phước A', '31387', 3, 728);

-- Tỉnh Hậu Giang > Huyện Phụng Hiệp
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10497, 'Thị trấn Kinh Cùng', '31393', 3, 729),
(10498, 'Thị trấn Cây Dương', '31396', 3, 729),
(10499, 'Xã Tân Bình', '31399', 3, 729),
(10500, 'Xã Bình Thành', '31402', 3, 729),
(10501, 'Xã Thạnh Hòa', '31405', 3, 729),
(10502, 'Xã Long Thạnh', '31408', 3, 729),
(10503, 'Xã Phụng Hiệp', '31417', 3, 729),
(10504, 'Xã Hòa Mỹ', '31420', 3, 729),
(10505, 'Xã Hòa An', '31423', 3, 729),
(10506, 'Xã Phương Bình', '31426', 3, 729),
(10507, 'Xã Hiệp Hưng', '31429', 3, 729),
(10508, 'Xã Tân Phước Hưng', '31432', 3, 729),
(10509, 'Thị trấn Búng Tàu', '31433', 3, 729),
(10510, 'Xã Phương Phú', '31435', 3, 729),
(10511, 'Xã Tân Long', '31438', 3, 729);

-- Tỉnh Hậu Giang > Huyện Vị Thuỷ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10512, 'Thị trấn Nàng Mau', '31441', 3, 730),
(10513, 'Xã Vị Trung', '31444', 3, 730),
(10514, 'Xã Vị Thuỷ', '31447', 3, 730),
(10515, 'Xã Vị Thắng', '31450', 3, 730),
(10516, 'Xã Vĩnh Thuận Tây', '31453', 3, 730),
(10517, 'Xã Vĩnh Trung', '31456', 3, 730),
(10518, 'Xã Vĩnh Tường', '31459', 3, 730),
(10519, 'Xã Vị Đông', '31462', 3, 730),
(10520, 'Xã Vị Thanh', '31465', 3, 730),
(10521, 'Xã Vị Bình', '31468', 3, 730);

-- Tỉnh Hậu Giang > Huyện Long Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10522, 'Xã Thuận Hưng', '31483', 3, 731),
(10523, 'Xã Thuận Hòa', '31484', 3, 731),
(10524, 'Xã Vĩnh Thuận Đông', '31486', 3, 731),
(10525, 'Thị trấn Vĩnh Viễn', '31489', 3, 731),
(10526, 'Xã Vĩnh Viễn A', '31490', 3, 731),
(10527, 'Xã Lương Tâm', '31492', 3, 731),
(10528, 'Xã Lương Nghĩa', '31493', 3, 731),
(10529, 'Xã Xà Phiên', '31495', 3, 731);

-- Tỉnh Hậu Giang > Thị xã Long Mỹ
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10530, 'Phường Thuận An', '31471', 3, 732),
(10531, 'Phường Trà Lồng', '31472', 3, 732),
(10532, 'Phường Bình Thạnh', '31473', 3, 732),
(10533, 'Xã Long Bình', '31474', 3, 732),
(10534, 'Phường Vĩnh Tường', '31475', 3, 732),
(10535, 'Xã Long Trị', '31477', 3, 732),
(10536, 'Xã Long Trị A', '31478', 3, 732),
(10537, 'Xã Long Phú', '31480', 3, 732),
(10538, 'Xã Tân Phú', '31481', 3, 732);

-- Tỉnh Sóc Trăng > Thành phố Sóc Trăng
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10539, 'Phường 5', '31498', 3, 733),
(10540, 'Phường 7', '31501', 3, 733),
(10541, 'Phường 8', '31504', 3, 733),
(10542, 'Phường 6', '31507', 3, 733),
(10543, 'Phường 2', '31510', 3, 733),
(10544, 'Phường 4', '31516', 3, 733),
(10545, 'Phường 3', '31519', 3, 733),
(10546, 'Phường 1', '31522', 3, 733),
(10547, 'Phường 10', '31525', 3, 733);

-- Tỉnh Sóc Trăng > Huyện Châu Thành
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10548, 'Thị trấn Châu Thành', '31569', 3, 734),
(10549, 'Xã Hồ Đắc Kiện', '31570', 3, 734),
(10550, 'Xã Phú Tâm', '31573', 3, 734),
(10551, 'Xã Thuận Hòa', '31576', 3, 734),
(10552, 'Xã Phú Tân', '31582', 3, 734),
(10553, 'Xã Thiện Mỹ', '31585', 3, 734),
(10554, 'Xã An Hiệp', '31594', 3, 734),
(10555, 'Xã An Ninh', '31600', 3, 734);

-- Tỉnh Sóc Trăng > Huyện Kế Sách
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10556, 'Thị trấn Kế Sách', '31528', 3, 735),
(10557, 'Thị trấn An Lạc Thôn', '31531', 3, 735),
(10558, 'Xã Xuân Hòa', '31534', 3, 735),
(10559, 'Xã Phong Nẫm', '31537', 3, 735),
(10560, 'Xã An Lạc Tây', '31540', 3, 735),
(10561, 'Xã Trinh Phú', '31543', 3, 735),
(10562, 'Xã Ba Trinh', '31546', 3, 735),
(10563, 'Xã Thới An Hội', '31549', 3, 735),
(10564, 'Xã Nhơn Mỹ', '31552', 3, 735),
(10565, 'Xã Kế Thành', '31555', 3, 735),
(10566, 'Xã Kế An', '31558', 3, 735),
(10567, 'Xã Đại Hải', '31561', 3, 735),
(10568, 'Xã An Mỹ', '31564', 3, 735);

-- Tỉnh Sóc Trăng > Huyện Mỹ Tú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10569, 'Thị trấn Huỳnh Hữu Nghĩa', '31567', 3, 736),
(10570, 'Xã Long Hưng', '31579', 3, 736),
(10571, 'Xã Hưng Phú', '31588', 3, 736),
(10572, 'Xã Mỹ Hương', '31591', 3, 736),
(10573, 'Xã Mỹ Tú', '31597', 3, 736),
(10574, 'Xã Mỹ Phước', '31603', 3, 736),
(10575, 'Xã Thuận Hưng', '31606', 3, 736),
(10576, 'Xã Mỹ Thuận', '31609', 3, 736),
(10577, 'Xã Phú Mỹ', '31612', 3, 736);

-- Tỉnh Sóc Trăng > Huyện Cù Lao Dung
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10578, 'Thị trấn Cù Lao Dung', '31615', 3, 737),
(10579, 'Xã An Thạnh 1', '31618', 3, 737),
(10580, 'Xã An Thạnh Tây', '31621', 3, 737),
(10581, 'Xã An Thạnh Đông', '31624', 3, 737),
(10582, 'Xã Đại Ân 1', '31627', 3, 737),
(10583, 'Xã An Thạnh 2', '31630', 3, 737),
(10584, 'Xã An Thạnh 3', '31633', 3, 737),
(10585, 'Xã An Thạnh Nam', '31636', 3, 737);

-- Tỉnh Sóc Trăng > Huyện Long Phú
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10586, 'Thị trấn Long Phú', '31639', 3, 738),
(10587, 'Xã Song Phụng', '31642', 3, 738),
(10588, 'Thị trấn Đại Ngãi', '31645', 3, 738),
(10589, 'Xã Hậu Thạnh', '31648', 3, 738),
(10590, 'Xã Long Đức', '31651', 3, 738),
(10591, 'Xã Trường Khánh', '31654', 3, 738),
(10592, 'Xã Phú Hữu', '31657', 3, 738),
(10593, 'Xã Tân Hưng', '31660', 3, 738),
(10594, 'Xã Châu Khánh', '31663', 3, 738),
(10595, 'Xã Tân Thạnh', '31666', 3, 738),
(10596, 'Xã Long Phú', '31669', 3, 738);

-- Tỉnh Sóc Trăng > Huyện Mỹ Xuyên
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10597, 'Thị trấn Mỹ Xuyên', '31684', 3, 739),
(10598, 'Xã Đại Tâm', '31690', 3, 739),
(10599, 'Xã Tham Đôn', '31693', 3, 739),
(10600, 'Xã Thạnh Phú', '31708', 3, 739),
(10601, 'Xã Ngọc Đông', '31711', 3, 739),
(10602, 'Xã Thạnh Quới', '31714', 3, 739),
(10603, 'Xã Hòa Tú 1', '31717', 3, 739),
(10604, 'Xã Gia Hòa 1', '31720', 3, 739),
(10605, 'Xã Ngọc Tố', '31723', 3, 739),
(10606, 'Xã Gia Hòa 2', '31726', 3, 739),
(10607, 'Xã Hòa Tú II', '31729', 3, 739);

-- Tỉnh Sóc Trăng > Thị xã Ngã Năm
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10608, 'Phường 1', '31732', 3, 740),
(10609, 'Phường 2', '31735', 3, 740),
(10610, 'Xã Vĩnh Quới', '31738', 3, 740),
(10611, 'Xã Tân Long', '31741', 3, 740),
(10612, 'Xã Long Bình', '31744', 3, 740),
(10613, 'Phường 3', '31747', 3, 740),
(10614, 'Xã Mỹ Bình', '31750', 3, 740),
(10615, 'Xã Mỹ Quới', '31753', 3, 740);

-- Tỉnh Sóc Trăng > Huyện Thạnh Trị
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10616, 'Thị trấn Phú Lộc', '31756', 3, 741),
(10617, 'Thị trấn Hưng Lợi', '31757', 3, 741),
(10618, 'Xã Lâm Tân', '31759', 3, 741),
(10619, 'Xã Thạnh Tân', '31762', 3, 741),
(10620, 'Xã Lâm Kiết', '31765', 3, 741),
(10621, 'Xã Tuân Tức', '31768', 3, 741),
(10622, 'Xã Vĩnh Thành', '31771', 3, 741),
(10623, 'Xã Thạnh Trị', '31774', 3, 741),
(10624, 'Xã Vĩnh Lợi', '31777', 3, 741),
(10625, 'Xã Châu Hưng', '31780', 3, 741);

-- Tỉnh Sóc Trăng > Thị xã Vĩnh Châu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10626, 'Phường 1', '31783', 3, 742),
(10627, 'Xã Hòa Đông', '31786', 3, 742),
(10628, 'Phường Khánh Hòa', '31789', 3, 742),
(10629, 'Xã Vĩnh Hiệp', '31792', 3, 742),
(10630, 'Xã Vĩnh Hải', '31795', 3, 742),
(10631, 'Xã Lạc Hòa', '31798', 3, 742),
(10632, 'Phường 2', '31801', 3, 742),
(10633, 'Phường Vĩnh Phước', '31804', 3, 742),
(10634, 'Xã Vĩnh Tân', '31807', 3, 742),
(10635, 'Xã Lai Hòa', '31810', 3, 742);

-- Tỉnh Sóc Trăng > Huyện Trần Đề
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10636, 'Xã Đại Ân 2', '31672', 3, 743),
(10637, 'Thị trấn Trần Đề', '31673', 3, 743),
(10638, 'Xã Liêu Tú', '31675', 3, 743),
(10639, 'Xã Lịch Hội Thượng', '31678', 3, 743),
(10640, 'Thị trấn Lịch Hội Thượng', '31679', 3, 743),
(10641, 'Xã Trung Bình', '31681', 3, 743),
(10642, 'Xã Tài Văn', '31687', 3, 743),
(10643, 'Xã Viên An', '31696', 3, 743),
(10644, 'Xã Thạnh Thới An', '31699', 3, 743),
(10645, 'Xã Thạnh Thới Thuận', '31702', 3, 743),
(10646, 'Xã Viên Bình', '31705', 3, 743);

-- Tỉnh Bạc Liêu > Thành phố Bạc Liêu
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10647, 'Phường 2', '31813', 3, 744),
(10648, 'Phường 3', '31816', 3, 744),
(10649, 'Phường 5', '31819', 3, 744),
(10650, 'Phường 7', '31822', 3, 744),
(10651, 'Phường 1', '31825', 3, 744),
(10652, 'Phường 8', '31828', 3, 744),
(10653, 'Phường Nhà Mát', '31831', 3, 744),
(10654, 'Xã Vĩnh Trạch', '31834', 3, 744),
(10655, 'Xã Vĩnh Trạch Đông', '31837', 3, 744),
(10656, 'Xã Hiệp Thành', '31840', 3, 744);

-- Tỉnh Bạc Liêu > Huyện Hồng Dân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10657, 'Thị trấn Ngan Dừa', '31843', 3, 745),
(10658, 'Xã Ninh Quới', '31846', 3, 745),
(10659, 'Xã Ninh Quới A', '31849', 3, 745),
(10660, 'Xã Ninh Hòa', '31852', 3, 745),
(10661, 'Xã Lộc Ninh', '31855', 3, 745),
(10662, 'Xã Vĩnh Lộc', '31858', 3, 745),
(10663, 'Xã Vĩnh Lộc A', '31861', 3, 745),
(10664, 'Xã Ninh Thạnh Lợi A', '31863', 3, 745),
(10665, 'Xã Ninh Thạnh Lợi', '31864', 3, 745);

-- Tỉnh Bạc Liêu > Huyện Phước Long
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10666, 'Thị trấn Phước Long', '31867', 3, 746),
(10667, 'Xã Vĩnh Phú Đông', '31870', 3, 746),
(10668, 'Xã Vĩnh Phú Tây', '31873', 3, 746),
(10669, 'Xã Phước Long', '31876', 3, 746),
(10670, 'Xã Hưng Phú', '31879', 3, 746),
(10671, 'Xã Vĩnh Thanh', '31882', 3, 746),
(10672, 'Xã Phong Thạnh Tây A', '31885', 3, 746),
(10673, 'Xã Phong Thạnh Tây B', '31888', 3, 746);

-- Tỉnh Bạc Liêu > Huyện Vĩnh Lợi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10674, 'Xã Vĩnh Hưng', '31894', 3, 747),
(10675, 'Xã Vĩnh Hưng A', '31897', 3, 747),
(10676, 'Thị trấn Châu Hưng', '31900', 3, 747),
(10677, 'Xã Châu Hưng A', '31903', 3, 747),
(10678, 'Xã Hưng Thành', '31906', 3, 747),
(10679, 'Xã Hưng Hội', '31909', 3, 747),
(10680, 'Xã Châu Thới', '31912', 3, 747),
(10681, 'Xã Long Thạnh', '31921', 3, 747);

-- Tỉnh Bạc Liêu > Thị xã Giá Rai
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10682, 'Phường 1', '31942', 3, 748),
(10683, 'Phường Hộ Phòng', '31945', 3, 748),
(10684, 'Xã Phong Thạnh Đông', '31948', 3, 748),
(10685, 'Phường Láng Tròn', '31951', 3, 748),
(10686, 'Xã Phong Tân', '31954', 3, 748),
(10687, 'Xã Tân Phong', '31957', 3, 748),
(10688, 'Xã Phong Thạnh', '31960', 3, 748),
(10689, 'Xã Phong Thạnh A', '31963', 3, 748),
(10690, 'Xã Phong Thạnh Tây', '31966', 3, 748),
(10691, 'Xã Tân Thạnh', '31969', 3, 748);

-- Tỉnh Bạc Liêu > Huyện Đông Hải
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10692, 'Thị trấn Gành Hào', '31972', 3, 749),
(10693, 'Xã Long Điền Đông', '31975', 3, 749),
(10694, 'Xã Long Điền Đông A', '31978', 3, 749),
(10695, 'Xã Long Điền', '31981', 3, 749),
(10696, 'Xã Long Điền Tây', '31984', 3, 749),
(10697, 'Xã Điền Hải', '31985', 3, 749),
(10698, 'Xã An Trạch', '31987', 3, 749),
(10699, 'Xã An Trạch A', '31988', 3, 749),
(10700, 'Xã An Phúc', '31990', 3, 749),
(10701, 'Xã Định Thành', '31993', 3, 749),
(10702, 'Xã Định Thành A', '31996', 3, 749);

-- Tỉnh Bạc Liêu > Huyện Hoà Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10703, 'Thị trấn Hòa Bình', '31891', 3, 750),
(10704, 'Xã Minh Diệu', '31915', 3, 750),
(10705, 'Xã Vĩnh Bình', '31918', 3, 750),
(10706, 'Xã Vĩnh Mỹ B', '31924', 3, 750),
(10707, 'Xã Vĩnh Hậu', '31927', 3, 750),
(10708, 'Xã Vĩnh Hậu A', '31930', 3, 750),
(10709, 'Xã Vĩnh Mỹ A', '31933', 3, 750),
(10710, 'Xã Vĩnh Thịnh', '31936', 3, 750);

-- Tỉnh Cà Mau > Thành phố Cà Mau
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10711, 'Phường 9', '31999', 3, 751),
(10712, 'Phường 2', '32002', 3, 751),
(10713, 'Phường 1', '32005', 3, 751),
(10714, 'Phường 5', '32008', 3, 751),
(10715, 'Phường 8', '32014', 3, 751),
(10716, 'Phường 6', '32017', 3, 751),
(10717, 'Phường 7', '32020', 3, 751),
(10718, 'Phường Tân Xuyên', '32022', 3, 751),
(10719, 'Xã An Xuyên', '32023', 3, 751),
(10720, 'Phường Tân Thành', '32025', 3, 751),
(10721, 'Xã Tân Thành', '32026', 3, 751),
(10722, 'Xã Tắc Vân', '32029', 3, 751),
(10723, 'Xã Lý Văn Lâm', '32032', 3, 751),
(10724, 'Xã Định Bình', '32035', 3, 751),
(10725, 'Xã Hòa Thành', '32038', 3, 751),
(10726, 'Xã Hòa Tân', '32041', 3, 751);

-- Tỉnh Cà Mau > Huyện U Minh
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10727, 'Thị trấn U Minh', '32044', 3, 752),
(10728, 'Xã Khánh Hòa', '32047', 3, 752),
(10729, 'Xã Khánh Thuận', '32048', 3, 752),
(10730, 'Xã Khánh Tiến', '32050', 3, 752),
(10731, 'Xã Nguyễn Phích', '32053', 3, 752),
(10732, 'Xã Khánh Lâm', '32056', 3, 752),
(10733, 'Xã Khánh An', '32059', 3, 752),
(10734, 'Xã Khánh Hội', '32062', 3, 752);

-- Tỉnh Cà Mau > Huyện Thới Bình
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10735, 'Thị trấn Thới Bình', '32065', 3, 753),
(10736, 'Xã Biển Bạch', '32068', 3, 753),
(10737, 'Xã Tân Bằng', '32069', 3, 753),
(10738, 'Xã Trí Phải', '32071', 3, 753),
(10739, 'Xã Trí Lực', '32072', 3, 753),
(10740, 'Xã Biển Bạch Đông', '32074', 3, 753),
(10741, 'Xã Thới Bình', '32077', 3, 753),
(10742, 'Xã Tân Phú', '32080', 3, 753),
(10743, 'Xã Tân Lộc Bắc', '32083', 3, 753),
(10744, 'Xã Tân Lộc', '32086', 3, 753),
(10745, 'Xã Tân Lộc Đông', '32089', 3, 753),
(10746, 'Xã Hồ Thị Kỷ', '32092', 3, 753);

-- Tỉnh Cà Mau > Huyện Trần Văn Thời
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10747, 'Thị trấn Trần Văn Thời', '32095', 3, 754),
(10748, 'Thị trấn Sông Đốc', '32098', 3, 754),
(10749, 'Xã Khánh Bình Tây Bắc', '32101', 3, 754),
(10750, 'Xã Khánh Bình Tây', '32104', 3, 754),
(10751, 'Xã Trần Hợi', '32107', 3, 754),
(10752, 'Xã Khánh Lộc', '32108', 3, 754),
(10753, 'Xã Khánh Bình', '32110', 3, 754),
(10754, 'Xã Khánh Hưng', '32113', 3, 754),
(10755, 'Xã Khánh Bình Đông', '32116', 3, 754),
(10756, 'Xã Khánh Hải', '32119', 3, 754),
(10757, 'Xã Lợi An', '32122', 3, 754),
(10758, 'Xã Phong Điền', '32124', 3, 754),
(10759, 'Xã Phong Lạc', '32125', 3, 754);

-- Tỉnh Cà Mau > Huyện Cái Nước
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10760, 'Thị trấn Cái Nước', '32128', 3, 755),
(10761, 'Xã Thạnh Phú', '32130', 3, 755),
(10762, 'Xã Lương Thế Trân', '32131', 3, 755),
(10763, 'Xã Phú Hưng', '32134', 3, 755),
(10764, 'Xã Tân Hưng', '32137', 3, 755),
(10765, 'Xã Hưng Mỹ', '32140', 3, 755),
(10766, 'Xã Hoà Mỹ', '32141', 3, 755),
(10767, 'Xã Đông Hưng', '32142', 3, 755),
(10768, 'Xã Đông Thới', '32143', 3, 755),
(10769, 'Xã Tân Hưng Đông', '32146', 3, 755),
(10770, 'Xã Trần Thới', '32149', 3, 755);

-- Tỉnh Cà Mau > Huyện Đầm Dơi
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10771, 'Thị trấn Đầm Dơi', '32152', 3, 756),
(10772, 'Xã Tạ An Khương', '32155', 3, 756),
(10773, 'Xã Tạ An Khương Đông', '32158', 3, 756),
(10774, 'Xã Trần Phán', '32161', 3, 756),
(10775, 'Xã Tân Trung', '32162', 3, 756),
(10776, 'Xã Tân Đức', '32164', 3, 756),
(10777, 'Xã Tân Thuận', '32167', 3, 756),
(10778, 'Xã Tạ An Khương Nam', '32170', 3, 756),
(10779, 'Xã Tân Duyệt', '32173', 3, 756),
(10780, 'Xã Tân Dân', '32174', 3, 756),
(10781, 'Xã Tân Tiến', '32176', 3, 756),
(10782, 'Xã Quách Phẩm Bắc', '32179', 3, 756),
(10783, 'Xã Quách Phẩm', '32182', 3, 756),
(10784, 'Xã Thanh Tùng', '32185', 3, 756),
(10785, 'Xã Ngọc Chánh', '32186', 3, 756),
(10786, 'Xã Nguyễn Huân', '32188', 3, 756);

-- Tỉnh Cà Mau > Huyện Năm Căn
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10787, 'Thị trấn Năm Căn', '32191', 3, 757),
(10788, 'Xã Hàm Rồng', '32194', 3, 757),
(10789, 'Xã Hiệp Tùng', '32197', 3, 757),
(10790, 'Xã Đất Mới', '32200', 3, 757),
(10791, 'Xã Lâm Hải', '32201', 3, 757),
(10792, 'Xã Hàng Vịnh', '32203', 3, 757),
(10793, 'Xã Tam Giang', '32206', 3, 757),
(10794, 'Xã Tam Giang Đông', '32209', 3, 757);

-- Tỉnh Cà Mau > Huyện Phú Tân
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10795, 'Thị trấn Cái Đôi Vàm', '32212', 3, 758),
(10796, 'Xã Phú Thuận', '32214', 3, 758),
(10797, 'Xã Phú Mỹ', '32215', 3, 758),
(10798, 'Xã Phú Tân', '32218', 3, 758),
(10799, 'Xã Tân Hải', '32221', 3, 758),
(10800, 'Xã Việt Thắng', '32224', 3, 758),
(10801, 'Xã Tân Hưng Tây', '32227', 3, 758),
(10802, 'Xã Rạch Chèo', '32228', 3, 758),
(10803, 'Xã Nguyễn Việt Khái', '32230', 3, 758);

-- Tỉnh Cà Mau > Huyện Ngọc Hiển
INSERT INTO administrative_units (id, name, code, level, parent_id) VALUES
(10804, 'Xã Tam Giang Tây', '32233', 3, 759),
(10805, 'Xã Tân Ân Tây', '32236', 3, 759),
(10806, 'Xã Viên An Đông', '32239', 3, 759),
(10807, 'Xã Viên An', '32242', 3, 759),
(10808, 'Thị trấn Rạch Gốc', '32244', 3, 759),
(10809, 'Xã Tân Ân', '32245', 3, 759),
(10810, 'Xã Đất Mũi', '32248', 3, 759);

-- Reset sequence to max id
SELECT setval('administrative_units_id_seq', 10810);
