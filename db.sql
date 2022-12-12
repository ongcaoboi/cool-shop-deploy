-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 11, 2022 at 12:27 PM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `coolshop6`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `Proc_product_GetPaging`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_product_GetPaging` (IN `v_Offset` INT, IN `v_Limit` INT, IN `v_Sort` VARCHAR(100), IN `v_Where` VARCHAR(1000))  SQL SECURITY INVOKER
    COMMENT '\r\n  -- Author:        NVDIA\r\n  -- Created date:  10/5/2022\r\n  -- Description:   Lấy danh sách sản phẩm và tổng số sản phẩm, tổng số  có phân trang\r\n  -- Modified by:   \r\n  -- Code chạy thử: CALL `hust.21h.2022.nvdia`.Proc_product_GetPaging(0, 10, NULL, "EmployeeName like ''%Dìa%''");'
BEGIN
  -- Kiểm tra nếu tham số đầu vào v_Where bị NULL --> gán giá trị cho v_Where = ''
  -- --> Kiểm tra giá trị v_Where nếu = '' thì set v_Where = '1=1'
  -- SELECT * FROM employee WHERE 1=1;
  IF IFNULL(v_Where, '') = '' THEN
    SET v_Where = '1=1';
  END IF;

  -- Kiểm tra nếu tham số đầu vào v_Sort bị NULL --> gán giá trị cho v_Sort = ''
  -- --> Kiểm tra giá trị v_Sort nếu = '' thì set v_Sort = 'ModifiedDate DESC'
  -- SELECT * FROM employee WHERE 1=1 ORDER BY ModifiedDate DESC;
  IF IFNULL(v_Sort, '') = '' THEN
    SET v_Sort = 'Rate DESC';
  END IF;

  IF v_Limit = -1 THEN
    SET @filterQuery = CONCAT('SELECT * FROM product WHERE ', v_Where, ' ORDER BY ', v_Sort);
  ELSE
    SET @filterQuery = CONCAT('SELECT * FROM product WHERE ', v_Where, ' ORDER BY ', v_Sort, ' LIMIT ', v_Offset, ',', v_Limit);
  END IF;

  -- filterQuery và @filterQuery có ý nghĩa khác nhau
  -- filterQuery là 1 statement
  -- @filterQuery là 1 biến có kiểu dữ liệu là string
  PREPARE/*Cấp vùng nhớ và chuyển câu lệnh về dạng có thể excute*/ filterQuery FROM @filterQuery;
  EXECUTE/*Chạy*/ filterQuery;
  DEALLOCATE/*Giải phóng vùng nhớ*/ PREPARE filterQuery;

  -- Lấy ra tổng số bản ghi thỏa mãn điều kiện lọc
  SET @filterQuery = CONCAT('SELECT count(ProductID) AS TotalCount FROM product WHERE ', v_Where);
  PREPARE filterQuery FROM @filterQuery;
  EXECUTE filterQuery;
  DEALLOCATE PREPARE filterQuery;
END$$

DROP PROCEDURE IF EXISTS `Proc_product_GetPaging_1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_product_GetPaging_1` (IN `v_Offset` INT, IN `v_Limit` INT, IN `v_Sort` VARCHAR(100), IN `v_Where` VARCHAR(1000), IN `v_GroupBy` VARCHAR(100))  SQL SECURITY INVOKER
    COMMENT '\r\n  -- Author:        NVDIA\r\n  -- Created date:  10/5/2022\r\n  -- Description:   Lấy danh sách sản phẩm và tổng số sản phẩm, tổng số  có phân trang\r\n  -- Modified by:   \r\n  -- Code chạy thử: CALL `hust.21h.2022.nvdia`.Proc_product_GetPaging(0, 10, NULL, "EmployeeName like ''%Dìa%''");'
BEGIN
  -- Kiểm tra nếu tham số đầu vào v_Where bị NULL --> gán giá trị cho v_Where = ''
  -- --> Kiểm tra giá trị v_Where nếu = '' thì set v_Where = '1=1'
  -- SELECT * FROM employee WHERE 1=1;
  IF IFNULL(v_Where, '') = '' THEN
    SET v_Where = '1=1';
  END IF;

  -- Kiểm tra nếu tham số đầu vào v_Sort bị NULL --> gán giá trị cho v_Sort = ''
  -- --> Kiểm tra giá trị v_Sort nếu = '' thì set v_Sort = 'ModifiedDate DESC'
  -- SELECT * FROM employee WHERE 1=1 ORDER BY ModifiedDate DESC;
  IF IFNULL(v_Sort, '') = '' THEN
    SET v_Sort = 'Rate DESC';
  END IF;

  IF v_Limit = -1 THEN
    SET @filterQuery = CONCAT('SELECT * FROM product LEFT JOIN productincategory on product.ProductID=productincategory.ProductID LEFT JOIN productdetails on product.ProductID=productdetails.ProductID WHERE ', v_Where,v_GroupBy, ' ORDER BY ', v_Sort);
  ELSE
    SET @filterQuery = CONCAT('SELECT * FROM product LEFT JOIN productincategory on product.ProductID=productincategory.ProductID LEFT JOIN productdetails on product.ProductID=productdetails.ProductID WHERE ', v_Where,v_GroupBy, ' ORDER BY ', v_Sort, ' LIMIT ', v_Offset, ',', v_Limit);
  END IF;

  -- filterQuery và @filterQuery có ý nghĩa khác nhau
  -- filterQuery là 1 statement
  -- @filterQuery là 1 biến có kiểu dữ liệu là string
  PREPARE/*Cấp vùng nhớ và chuyển câu lệnh về dạng có thể excute*/ filterQuery FROM @filterQuery;
  EXECUTE/*Chạy*/ filterQuery;
  DEALLOCATE/*Giải phóng vùng nhớ*/ PREPARE filterQuery;

  -- Lấy ra tổng số bản ghi thỏa mãn điều kiện lọc
  SET @filterQuery = CONCAT('SELECT count(DISTINCT product.ProductID) AS TotalCount FROM product LEFT JOIN productincategory on product.ProductID=productincategory.ProductID LEFT JOIN productdetails on product.ProductID=productdetails.ProductID WHERE ', v_Where);
  PREPARE filterQuery FROM @filterQuery;
  EXECUTE filterQuery;
  DEALLOCATE PREPARE filterQuery;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
CREATE TABLE IF NOT EXISTS `brand` (
  `BrandID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID nhãn hiệu',
  `BrandName` varchar(50) NOT NULL COMMENT 'Tên Nhãn hiệu',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả ',
  PRIMARY KEY (`BrandID`),
  UNIQUE KEY `BrandName` (`BrandName`)
) ENGINE=InnoDB AUTO_INCREMENT=11 AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Nhãn hiệu';

--
-- Dumping data for table `brand`
--

INSERT INTO `brand` (`BrandID`, `BrandName`, `Description`) VALUES
(1, 'Adidas', ''),
(2, 'Nike', NULL),
(3, 'GUCCI', NULL),
(4, 'LOUIS VUITTON', NULL),
(5, 'DIOR', NULL),
(6, 'HERMES', NULL),
(7, 'DOLCE', NULL),
(8, 'GABBANA', NULL),
(9, 'VERSACE', NULL),
(10, 'PRADA', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` char(36) NOT NULL COMMENT 'ID người dùng',
  `ProductID` char(36) NOT NULL COMMENT 'ID sản phẩm',
  `SizeID` varchar(20) NOT NULL COMMENT 'Id size',
  `ColorID` varchar(20) NOT NULL COMMENT 'Id màu sắc',
  `ProductName` varchar(100) NOT NULL COMMENT 'Tên sản phẩm',
  `ProductImage` varchar(500) DEFAULT NULL COMMENT 'Đường dẫn ảnh',
  `Price` decimal(19,2) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL COMMENT 'Số lượng sản phẩm',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='Giỏ hàng';

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `UserID`, `ProductID`, `SizeID`, `ColorID`, `ProductName`, `ProductImage`, `Price`, `Quantity`) VALUES
(1, '3caed185-542d-11ed-906d-0242ac130002', '4148606d-f5b6-4b89-9290-442c4b606db9', 'L', 'Vang001', 'Áo in hình doraemon', '20221013-082223z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', '100000.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `CategoryID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Danh mục ID',
  `CategoryName` varchar(50) NOT NULL COMMENT 'Tên danh mục',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả',
  `Slug` varchar(50) DEFAULT NULL COMMENT 'SEO',
  `IsShow` tinyint(1) DEFAULT '1',
  `parentId` int(11) DEFAULT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `CategoryName` (`CategoryName`)
) ENGINE=InnoDB AUTO_INCREMENT=23 AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng danh mục sản phẩm';

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryID`, `CategoryName`, `Description`, `Slug`, `IsShow`, `parentId`) VALUES
(13, 'Thời trang nam', NULL, NULL, 1, NULL),
(14, 'Thời trang nữ', NULL, NULL, 1, NULL),
(15, 'Áo thun nam', NULL, NULL, 1, 13),
(16, 'Áo thun nữ', NULL, NULL, 1, 14),
(17, 'Quần nam', NULL, NULL, 1, 13),
(18, 'Quần nữ', NULL, NULL, 1, 14),
(19, 'Quần jean nam', NULL, NULL, 1, 13),
(20, 'Quần jean nữ', NULL, NULL, 1, 14),
(21, 'Quý ông', NULL, NULL, 1, NULL),
(22, 'Quần jean', NULL, NULL, 1, 17);

-- --------------------------------------------------------

--
-- Table structure for table `color`
--

DROP TABLE IF EXISTS `color`;
CREATE TABLE IF NOT EXISTS `color` (
  `ColorID` varchar(20) NOT NULL COMMENT 'Màu sắc ID',
  `ColorName` varchar(50) NOT NULL COMMENT 'Tên màu sắc',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả',
  PRIMARY KEY (`ColorID`),
  UNIQUE KEY `ColorName` (`ColorName`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng Màu sắc';

--
-- Dumping data for table `color`
--

INSERT INTO `color` (`ColorID`, `ColorName`, `Description`) VALUES
('Do001', 'Đỏ', NULL),
('Tim001', 'Tím', NULL),
('Vang001', 'Vàng', NULL),
('Xanh001', 'Xanh nước biển', NULL),
('Xanh002', 'Xanh lá', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gallery`
--

DROP TABLE IF EXISTS `gallery`;
CREATE TABLE IF NOT EXISTS `gallery` (
  `GalleryID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID ảnh trưng bày',
  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
  `Thumbnail` varchar(255) DEFAULT NULL COMMENT 'Hình ảnh nhỏ',
  PRIMARY KEY (`GalleryID`),
  KEY `FK_gallery_product_ProductID` (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=107 AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Ảnh trưng bày nhỏ';

--
-- Dumping data for table `gallery`
--

INSERT INTO `gallery` (`GalleryID`, `ProductID`, `Thumbnail`) VALUES
(3, '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'image.png'),
(4, '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'image.png'),
(16, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-132511ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg'),
(17, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-132511f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg'),
(18, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-13251132179fbdbac9c410e1a949acd46ab64d.jpeg'),
(19, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-132511pho__ng_adidas__1.jpg'),
(20, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-152823Adidas-Manchester-United.jpg'),
(21, '64a59a25-2488-54b0-f6b4-c8af08a50cbf', '20221101-15282332179fbdbac9c410e1a949acd46ab64d.jpeg'),
(22, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221202-121351sp2_1.png'),
(23, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221202-121351sp2_2.png'),
(24, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221202-121351sp2_3.png'),
(25, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221202-121351sp2_5.png'),
(26, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221202-121351sp2_6.png'),
(27, 'b08607cf-cb93-4dcf-b796-794adba7d426', '20221202-133613sp2_1.png'),
(28, 'b08607cf-cb93-4dcf-b796-794adba7d426', '20221202-133613sp2_2.png'),
(29, 'b08607cf-cb93-4dcf-b796-794adba7d426', '20221202-133613sp2_3.png'),
(30, 'b08607cf-cb93-4dcf-b796-794adba7d426', '20221202-133613sp2_5.png'),
(31, 'b08607cf-cb93-4dcf-b796-794adba7d426', '20221202-133613sp2_6.png'),
(32, '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', '20221202-134046sp3_1.png'),
(33, '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', '20221202-134046sp3_2.png'),
(34, '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', '20221202-134046sp3_3.png'),
(35, '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', '20221202-134046sp3_5.png'),
(36, '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', '20221202-134046sp3_6.png'),
(37, 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', '20221202-134314sp4_4.png'),
(38, 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', '20221202-134314sp4_5.png'),
(39, 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', '20221202-134314sp4_1.png'),
(40, 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', '20221202-134314sp4_2.png'),
(41, 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', '20221202-134314sp4_3.png'),
(42, '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', '20221202-134516sp5_1.png'),
(43, '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', '20221202-134516sp5_2.png'),
(44, '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', '20221202-134516sp5_3.png'),
(45, '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', '20221202-134516sp5_5.png'),
(46, '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', '20221202-134516sp5_6.png'),
(47, '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', '20221202-134839sp9_4.png'),
(48, '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', '20221202-134839sp9_1.png'),
(49, '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', '20221202-134839sp9_2.png'),
(50, '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', '20221202-134839sp9_3.png'),
(51, 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', '20221202-135029sp14_4.png'),
(52, 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', '20221202-135029sp14_1.png'),
(53, 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', '20221202-135029sp14_2.png'),
(54, 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', '20221202-135029sp14_3.png'),
(55, '92b87850-3ff0-4004-ab0a-bd8350ce5bf9', '20221202-135223sp19_4.png'),
(56, '92b87850-3ff0-4004-ab0a-bd8350ce5bf9', '20221202-135223sp19_1.png'),
(57, '92b87850-3ff0-4004-ab0a-bd8350ce5bf9', '20221202-135223sp19_2.png'),
(58, '92b87850-3ff0-4004-ab0a-bd8350ce5bf9', '20221202-135223sp19_3.png'),
(59, 'c7535de6-b85f-4b2b-bb26-551397636a72', '20221202-135617sp6_4.png'),
(60, 'c7535de6-b85f-4b2b-bb26-551397636a72', '20221202-135617sp6_1.png'),
(61, 'c7535de6-b85f-4b2b-bb26-551397636a72', '20221202-135617sp6_2.png'),
(62, 'c7535de6-b85f-4b2b-bb26-551397636a72', '20221202-135617sp6_3.png'),
(63, '8d13786f-4afe-4586-971f-86f957f005a5', '20221207-193255sp7_4.png'),
(64, '8d13786f-4afe-4586-971f-86f957f005a5', '20221207-193255sp7_1.png'),
(65, '8d13786f-4afe-4586-971f-86f957f005a5', '20221207-193255sp7_2.png'),
(66, '8d13786f-4afe-4586-971f-86f957f005a5', '20221207-193255sp7_3.png'),
(67, 'b7ca8237-abc8-49bb-a819-d410012d95d5', '20221207-193622sp8_4.png'),
(68, 'b7ca8237-abc8-49bb-a819-d410012d95d5', '20221207-193622sp8_1.png'),
(69, 'b7ca8237-abc8-49bb-a819-d410012d95d5', '20221207-193622sp8_2.png'),
(70, 'b7ca8237-abc8-49bb-a819-d410012d95d5', '20221207-193622sp8_3.png'),
(71, '234462fc-a6a0-4283-b528-eeceb6599fba', '20221207-193901sp12_4.png'),
(72, '234462fc-a6a0-4283-b528-eeceb6599fba', '20221207-193901sp12_1.png'),
(73, '234462fc-a6a0-4283-b528-eeceb6599fba', '20221207-193901sp12_2.png'),
(74, '234462fc-a6a0-4283-b528-eeceb6599fba', '20221207-193901sp12_3.png'),
(75, '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', '20221207-204239sp13_4.png'),
(76, '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', '20221207-204239sp13_1.png'),
(77, '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', '20221207-204239sp13_2.png'),
(78, '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', '20221207-204239sp13_3.png'),
(79, '319b6893-71e1-4084-9045-c869bba4d544', '20221207-204644sp16_4.png'),
(80, '319b6893-71e1-4084-9045-c869bba4d544', '20221207-204644sp16_1.png'),
(81, '319b6893-71e1-4084-9045-c869bba4d544', '20221207-204644sp16_2.png'),
(82, '319b6893-71e1-4084-9045-c869bba4d544', '20221207-204644sp16_3.png'),
(83, '215a297f-0c0f-4eff-91cf-69402436d6f1', '20221207-205154sp17_4.png'),
(84, '215a297f-0c0f-4eff-91cf-69402436d6f1', '20221207-205154sp17_1.png'),
(85, '215a297f-0c0f-4eff-91cf-69402436d6f1', '20221207-205154sp17_2.png'),
(86, '215a297f-0c0f-4eff-91cf-69402436d6f1', '20221207-205154sp17_3.png'),
(87, '5c1de774-95b5-4e37-be90-2b329b70a375', '20221207-205319sp20_4.png'),
(88, '5c1de774-95b5-4e37-be90-2b329b70a375', '20221207-205319sp20_1.png'),
(89, '5c1de774-95b5-4e37-be90-2b329b70a375', '20221207-205319sp20_2.png'),
(90, '5c1de774-95b5-4e37-be90-2b329b70a375', '20221207-205319sp20_3.png'),
(91, '2afaae77-ed2b-4cc0-8241-c54ae7eda137', '20221207-205544sp10_4.png'),
(92, '2afaae77-ed2b-4cc0-8241-c54ae7eda137', '20221207-205544sp10_1.png'),
(93, '2afaae77-ed2b-4cc0-8241-c54ae7eda137', '20221207-205544sp10_2.png'),
(94, '2afaae77-ed2b-4cc0-8241-c54ae7eda137', '20221207-205544sp10_3.png'),
(95, '394f8331-8574-4010-91c0-9cd69f0c8608', '20221207-205720sp11_4.png'),
(96, '394f8331-8574-4010-91c0-9cd69f0c8608', '20221207-205720sp11_1.png'),
(97, '394f8331-8574-4010-91c0-9cd69f0c8608', '20221207-205720sp11_2.png'),
(98, '394f8331-8574-4010-91c0-9cd69f0c8608', '20221207-205720sp11_3.png'),
(99, '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', '20221207-205917sp15_4.png'),
(100, '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', '20221207-205917sp15_1.png'),
(101, '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', '20221207-205917sp15_2.png'),
(102, '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', '20221207-205917sp15_3.png'),
(103, '2e96922b-180d-4048-a33b-3263c15cfd22', '20221207-210047sp18_4.png'),
(104, '2e96922b-180d-4048-a33b-3263c15cfd22', '20221207-210047sp18_1.png'),
(105, '2e96922b-180d-4048-a33b-3263c15cfd22', '20221207-210047sp18_2.png'),
(106, '2e96922b-180d-4048-a33b-3263c15cfd22', '20221207-210047sp18_3.png');

-- --------------------------------------------------------

--
-- Table structure for table `orderdetail`
--

DROP TABLE IF EXISTS `orderdetail`;
CREATE TABLE IF NOT EXISTS `orderdetail` (
  `OrderdetailID` char(36) NOT NULL COMMENT 'ID chi tiết order',
  `ProductID` char(36) DEFAULT NULL COMMENT 'ID product',
  `ProductName` varchar(100) NOT NULL,
  `ProductImage` varchar(500) NOT NULL,
  `SizeID` varchar(20) DEFAULT NULL COMMENT 'Id size',
  `ColorID` varchar(20) DEFAULT NULL COMMENT 'Color id',
  `Qunatity` int(11) DEFAULT NULL COMMENT 'Số lượng',
  `Price` decimal(19,2) DEFAULT NULL COMMENT 'Giá',
  `Promotion` varchar(50) DEFAULT NULL COMMENT 'Giảm giá',
  `OrderID` char(36) DEFAULT NULL,
  PRIMARY KEY (`OrderdetailID`),
  KEY `FK_orderdetail_order_OrderID` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Chi tiết hóa đơn';

--
-- Dumping data for table `orderdetail`
--

INSERT INTO `orderdetail` (`OrderdetailID`, `ProductID`, `ProductName`, `ProductImage`, `SizeID`, `ColorID`, `Qunatity`, `Price`, `Promotion`, `OrderID`) VALUES
('0ad76b0b-e4cd-4e27-abf1-240d371484e6', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Áo dầy cộm', '20221013-074658ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 'XS', 'Vang001', 1, '300000.00', NULL, 'a8d79bb7-1f14-4778-8df0-c836c3af8461'),
('0f9ee1f9-aa0a-432b-b3a9-f2dbed23d19c', 'c22edc73-1e37-4208-8637-46844daad0fa', 'áo đi bơi', '20221019-222409z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 'M', 'Tim001', 1, '1000.00', NULL, '3c83cb55-00d8-4ee8-b742-192965555563'),
('35db2a4b-a3dd-4cce-920c-b3ff9a843094', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Áo in hình doraemon', '20221013-082223z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 'L', 'Xanh002', 1, '100000.00', NULL, '56805966-fddf-4bf9-8065-9a3b33ac591f'),
('66ff0a07-cd0c-4a2b-a662-1bd936bef2f9', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Áo thun nam mùa hè ', '20221019-224035f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg', 'XL', 'Do001', 1, '618.80', NULL, 'd87e6067-b15f-470a-a34c-03e7cdb5df9a'),
('77cd37fb-083c-42eb-ad45-96f9fc6a7702', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Áo dầy cộm', '20221013-074658ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 'L', 'Vang001', 2, '300000.00', NULL, '7a5bae24-f53a-4eb3-bb57-3197a88197d5'),
('92763a5f-6f79-496c-bcd0-38f3c17e3d07', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Áo in hình doraemon', '20221013-082223z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 'L', 'Vang001', 3, '100000.00', NULL, '92f08e0f-5940-4234-8786-d94f3430b729'),
('cb5769ae-9c03-4470-b81b-f9ce5973430a', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'quần đá bóng', '20221101-124730ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 'XL', 'Xanh001', 1, '1000.00', NULL, 'a7ab3372-a830-476d-ba5c-588ce179fec4'),
('d9544312-d0a3-407d-8494-8b55caedeac8', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Áo thun nam mùa hè ', '20221019-224035f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg', 'S', 'Vang001', 5, '618.80', NULL, '56805966-fddf-4bf9-8065-9a3b33ac591f'),
('dc84867d-95e8-4c03-81e6-40b9908aaea7', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Áo thun nam mùa hè ', '20221019-224035f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg', 'S', 'Vang001', 1, '618.80', NULL, '92f08e0f-5940-4234-8786-d94f3430b729'),
('e29520a9-9c54-4f1c-8de6-8c6df5a15d69', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Áo mỏng manh dễ rách', '20221017-210751z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 'XXL', 'Xanh002', 1, '200001.00', NULL, '3c83cb55-00d8-4ee8-b742-192965555563');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` char(36) NOT NULL COMMENT 'Id hóa đơn',
  `UserID` char(36) NOT NULL COMMENT 'Id người dùng',
  `OrderstatusID` varchar(50) NOT NULL COMMENT 'Id trạng thái',
  `PhoneShip` varchar(12) DEFAULT NULL COMMENT 'Số điện thoại',
  `AddresShip` varchar(100) DEFAULT NULL COMMENT 'Địa chỉ',
  `NameShip` varchar(255) DEFAULT NULL COMMENT 'Tên người ship',
  `Note` varchar(255) DEFAULT NULL COMMENT 'Ghi chú thông tin cần thiết',
  `CreateDate` datetime DEFAULT NULL COMMENT 'Ngày tạo',
  `UpdateDate` datetime DEFAULT NULL COMMENT 'Ngày cập nhật',
  PRIMARY KEY (`OrderID`),
  KEY `FK_orders_orderstatus_` (`OrderstatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hóa đơn';

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `UserID`, `OrderstatusID`, `PhoneShip`, `AddresShip`, `NameShip`, `Note`, `CreateDate`, `UpdateDate`) VALUES
('3c83cb55-00d8-4ee8-b742-192965555563', '3caed185-542d-11ed-906d-0242ac130002', 'confirm', '0987654321', 'gia lai', 'Phuong Nam', '', '2022-11-16 21:41:11', '2022-11-16 21:47:51'),
('56805966-fddf-4bf9-8065-9a3b33ac591f', '3caed185-542d-11ed-906d-0242ac130002', 'deliveredToTransporter', '0987654321', 'Gia Lai', 'Anh', 'hihi', '2022-11-09 00:00:00', '2022-11-15 22:06:16'),
('7a5bae24-f53a-4eb3-bb57-3197a88197d5', '3caed185-542d-11ed-906d-0242ac130002', 'confirm', '01234567889', 'Gia Lai', 'anh', 'hihi', '2022-11-09 00:00:00', '2022-11-15 17:11:19'),
('92f08e0f-5940-4234-8786-d94f3430b729', '3caed185-542d-11ed-906d-0242ac130002', 'cancelled', '0987654321', 'Gia Lai', 'anh', 'giao nhanh', '2022-11-10 08:15:34', '2022-11-15 22:12:05'),
('a7ab3372-a830-476d-ba5c-588ce179fec4', '3caed185-542d-11ed-906d-0242ac130002', 'confirm', '0987654321', 'gia lai', 'Phuong Nam', '', '2022-11-14 21:57:26', '2022-11-16 21:47:14'),
('a8d79bb7-1f14-4778-8df0-c836c3af8461', '3caed185-542d-11ed-906d-0242ac130002', 'waitForPay', '0346374638', 'Nhon Hoa', 'Trug', 'a', '2022-11-09 00:00:00', '2022-11-15 22:12:22'),
('d87e6067-b15f-470a-a34c-03e7cdb5df9a', '3caed185-542d-11ed-906d-0242ac130002', 'delivered', '0987654321', '', 'Phuong Nam', '', '2022-11-14 21:56:07', '2022-11-15 22:13:42');

-- --------------------------------------------------------

--
-- Table structure for table `orderstatus`
--

DROP TABLE IF EXISTS `orderstatus`;
CREATE TABLE IF NOT EXISTS `orderstatus` (
  `OrderstatusID` varchar(50) NOT NULL COMMENT 'Key trạng thái',
  `Name` varchar(50) DEFAULT NULL COMMENT 'Tên trạng thái',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả',
  PRIMARY KEY (`OrderstatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Trạng thái hóa đơn';

--
-- Dumping data for table `orderstatus`
--

INSERT INTO `orderstatus` (`OrderstatusID`, `Name`, `Description`) VALUES
('cancelled', 'Đã hủy', NULL),
('confirm', 'Đã xác nhận đơn hàng', 'Đơn hàng đã được xác nhận'),
('created', 'Chờ xác nhận', 'Đơn hàng mới được tạo'),
('delivered', 'Đã giao hàng', NULL),
('deliveredToTransporter', 'Giao hàng cho đơn vị vận chuyển', NULL),
('shipping', 'Đang giao hàng', NULL),
('waitForPay', 'Chờ thanh toán', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `ProductID` char(36) NOT NULL COMMENT 'ID sản phẩm',
  `BrandID` int(11) NOT NULL COMMENT 'ID nhãn hiệu',
  `ProductName` varchar(100) NOT NULL COMMENT 'Tên sản phẩm',
  `Price` decimal(19,2) NOT NULL COMMENT 'Giá sản phẩm',
  `Image` varchar(500) NOT NULL COMMENT 'Hình ảnh sản phẩm',
  `Rate` double NOT NULL COMMENT 'Đánh giá sản phẩm',
  `Slug` varchar(50) DEFAULT NULL COMMENT 'SEO',
  `Description` varchar(2000) DEFAULT NULL,
  `CreatedDate` date DEFAULT NULL COMMENT 'Ngày tạo',
  ` CreatedBy` varchar(50) DEFAULT NULL COMMENT 'Người tạo',
  ` ModifiedDate` date DEFAULT NULL COMMENT 'Ngày chỉnh sửa',
  `ModifiedBy` varchar(50) DEFAULT NULL COMMENT 'Người chỉnh sửa gần nhất',
  `DeletedDate` date DEFAULT NULL COMMENT 'Ngày xóa gần nhất',
  PRIMARY KEY (`ProductID`),
  UNIQUE KEY `ProductName` (`ProductName`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Sản phẩm';

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `BrandID`, `ProductName`, `Price`, `Image`, `Rate`, `Slug`, `Description`, `CreatedDate`, ` CreatedBy`, ` ModifiedDate`, `ModifiedBy`, `DeletedDate`) VALUES
('11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 5, 'Áo thu đỏ dior', '653000.00', '20221207-204222sp13_2.png', 0, 'ao-thu-do-dior', 'Kích thước: Có bốn kích thước (SML XL XXL) có sẵn cho danh sách sau. xin vui lòng cho phép 1-2 cm khác do đo lường thủ công, cảm ơn (Tất cả các phép đo bằng cm và xin lưu ý 1 cm = 0.39 inch)', NULL, NULL, NULL, NULL, NULL),
('20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', 3, 'Áo polo gucci trẻ trung', '500000.00', '20221202-134828sp9_1.png', 0, 'ao-polo-gucci-tre-trung', '* * Chi tiết sản phẩm áo polo nam cổ bẻ:\r\n- Chất liệu: \r\n+ Chất liệu vải cá sấu Cotton xuất xịn, chuẩn form cao cấp không xù lông, bề mặt vải mượt và bóng, thoáng mát, mang vận động vẫn thích hợp.\r\n+ Áo polo nam co giãn 4 chiều, bền, có thể giặt máy nhờ 5% sợi Spandex. Chất liệu thun cá sấu cao cấp không xù lông, bề mặt vải mượt và bóng, thoáng mát, mang vận động vẫn thích hợp.\r\n\r\n- Màu sắc, kích cỡ và thiết kế của áo polo nam cổ bẻ:\r\n+ Màu sắc: 3 màu (đen / xanh / tím )\r\n+ Kích cỡ: M, L, XL, XXL\r\n+ Áo phông polo form regular giúp người mang luôn cảm thấy thoải mái và tự tin.\r\n+ Thiết kế tối giản, cổ ve lật, 2 cúc. Bo viền bằng len gân. Thiết kế áo polo nam cổ bẻ trơn tạo sự đơn giản thanh lịch nhưng vô cùng đẳng cấp, tạo ấn tượng mạnh với người nhìn.', NULL, NULL, NULL, NULL, NULL),
('215a297f-0c0f-4eff-91cf-69402436d6f1', 5, 'Áo sơ mi DIOR Nam Đẹp', '9231012.00', '20221207-205138sp17_2.png', 0, 'ao-so-mi-dior-nam-dep', '- Chất liệu: Vải cotton lụa cao cấp,không nhăn, không xù, không phai màu\r\n- Đường may tỉ mỉ, chắc chắn, không có chỉ thừa\r\n- Bề mặt vải bóng mượt, sang trọng và đem lại cảm giác vô cùng mềm mại khi tiếp xúc với làn da của bạn\r\n- Công dụng: mặc ở nhà, mặc đi chơi, đi làm, đi dự tiệc\r\n- Thiết kế hiện đại, trẻ trung, năng động. Dễ phối đồ\r\n- Đủ size: M - L - XL - XXL\r\n\r\nHướng dẫn sử dụng sản phẩm:\r\n- Giặt máy thoải mái, lộn ngược trước khi giặt\r\n- không phơi trực tiếp dưới ánh nắng mặt trời\r\n', NULL, NULL, NULL, NULL, NULL),
('234462fc-a6a0-4283-b528-eeceb6599fba', 6, 'Áo thu sư tử hermes', '75000000.00', '20221207-193852sp12_4.png', 0, 'ao-thu-su-tu-hermes', 'Mới 100%.\r\nChất liệu: cotton\r\nKích thước: Có bốn kích thước (SML XL XXL) có sẵn cho danh sách sau. xin vui lòng cho phép 1-2 cm khác do đo lường thủ công, cảm ơn (Tất cả các phép đo bằng cm và xin lưu ý 1 cm = 0.39 inch)\r\nGợi ý để chọn kích thước phù hợp:\r\n1. Sử dụng quần áo tương tự để so sánh với kích thước.\r\n2. Chọn kích thước lớn hơn nếu kích thước của bạn giống với biểu đồ Kích thước đo lường phẳng\r\nLưu ý:\r\nVì các máy tính khác nhau hiển thị màu sắc khác nhau, màu sắc của mặt hàng thực tế có thể khác một chút so với các hình ảnh trên, cảm ơn sự thông cảm của bạn.', NULL, NULL, NULL, NULL, NULL),
('2afaae77-ed2b-4cc0-8241-c54ae7eda137', 4, 'Áo thun nam nữ Louis', '50000213.00', '20221207-205526sp10_3.png', 0, 'ao-thun-nam-nu-louis', '💓 THÔNG TIN SẢN PHẨM 💓\r\n👍THIẾT KẾ MỚI CHUẨN FORM DÁNG\r\n❖ ➫ Chất liệu áo: vải cotton 100% cao cấp\r\n❖ ➫ SIZE S M L XL\r\n_S từ 40>49\r\n_M từ 50>59\r\n_L từ 60> 69\r\n_XL từ 70>80\r\n', NULL, NULL, NULL, NULL, NULL),
('2e96922b-180d-4048-a33b-3263c15cfd22', 4, 'Áo thun nam Lisou Vatcer', '5921311.00', '20221207-210030sp18_4.png', 0, 'ao-thun-nam-lisou-vatcer', 'Gửi hàng đến kho trong vòng 24 giờ Giao hàng đến kho trong vòng 24 giờ!\r\nHàng tồn kho lớn trong kho Nếu bạn cần số lượng quần lớn, bạn có thể liên hệ trực tiếp với chúng tôi!\r\n❤️Chúng tôi sản xuất và bán trực tiếp tại nhà máy, có thể gửi gói hàng nhanh chóng', NULL, NULL, NULL, NULL, NULL),
('3163c21c-25ea-4ec8-a6a3-99864cde1bd3', 1, 'Áo adidas phiên bản 2019', '1000.00', '20221202-134505sp5_3.png', 0, 'ao-adidas-phien-ban-2019', 'Sản phẩm thời trang cao cấp 2019', NULL, NULL, NULL, NULL, NULL),
('319b6893-71e1-4084-9045-c869bba4d544', 5, 'Áo thu đen bạc dior', '925000.00', '20221207-204620sp16_2.png', 0, 'ao-thu-den-bac-dior', 'Thời gian ship siêu nhanh :\r\nThành Phố : 1-2 ngày ( tùy khu vực và đơn vị vận chuyển )\r\nHuyện Xã : 2-5 ngày ( tùy khu vực và đơn vị vận chuyển )\r\n\r\n✔ Cam kết 100% sản phẩm là ẢNH THẬT shop tự chụp ( có kèm video mỗi sản phẩm ), quý khách hoàn toàn yên tâm khi mua và sử dụng sản phẩm.\r\n✔ HOÀN TIỀN 100% nếu khách nhận hàng không hài lòng về chất lượng.\r\n✔ ĐỔI TRẢ HÀNG trong 7 ngày với sản phẩm chưa sử dụng.\r\nĐối với sản phẩm shop gửi bị lỗi hoặc nhầm size, TANYA FASHION chịu hoàn toàn phí đổi hàng !\r\n✔ Bao giá toàn sàn hàng chuẩn cùng chất lượng\r\nBẠN TRAO SHOP NIỀM TIN – SHOP TRAO BẠN SỰ HÀI LÒNG TUYỆT ĐỐI !!!', NULL, NULL, NULL, NULL, NULL),
('394f8331-8574-4010-91c0-9cd69f0c8608', 4, 'Áp thun nữ Louis trắng đẹp', '7635721.00', '20221207-205703sp11_4.png', 0, 'ap-thun-nu-louis-trang-dep', '💓 THÔNG TIN SẢN PHẨM 💓\r\n👍THIẾT KẾ MỚI CHUẨN FORM DÁNG\r\n❖ ➫ Chất liệu áo: vải cotton 100% cao cấp\r\n❖ ➫ SIZE S M L XL\r\n_S từ 45>54\r\n_M từ 55>64\r\n_L từ 65>74\r\n_XL từ 75>85\r\n', NULL, NULL, NULL, NULL, NULL),
('4148606d-f5b6-4b89-9290-442c4b606db9', 4, 'Áo in hình doraemon', '100000.00', '20221013-082223z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 0, 'ao-in-hinh-doraemon', 'Áo thun in hình doraemon ', NULL, NULL, NULL, NULL, NULL),
('46b34359-bda9-484b-b9f2-32b6c03ba877', 4, 'Áo mỏng manh dễ rách', '200001.00', '20221017-210751z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 3.4, 'ao-mong-manh-de-rach', 'Thật sự không hiểu tại sao chiếc áo này được tạo ra nữa', NULL, NULL, NULL, NULL, NULL),
('50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 1, 'Áo thun nam Forever Sport', '900000.00', '20221202-134034sp3_5.png', 0, 'ao-thun-nam-forever-sport', 'Quý khách vui lòng nhắn tin cho shop trong vòng 1 ngày sau khi nhận được hàng để được hỗ trợ trong trường hợp cần xuất hóa đơn đỏ (VAT) cho sản phẩm đã mua tại Shopee.\r\nQuá thời gian nhận được hàng đã nêu, shop xin được phép không hỗ trợ dù trong bất kỳ trường hợp nào.\r\nThe legacy of adidas is an ever-evolving story. But no matter how it grows, no matter the direction, the root stays firmly planted in sport. Which is made clear here on this t-shirt, because it straight up says it. A colourful graphic runner in the \"O\" really drives the idea home. Soft cotton makes this an easy go-to. No thought or effort required. Just comfort.\r\n- Regular fit\r\n- Ribbed crewneck\r\n- 100% cotton single jersey', NULL, NULL, NULL, NULL, NULL),
('5c1de774-95b5-4e37-be90-2b329b70a375', 5, 'Áo Thun Nam màu trơn Cổ Bẻ Ngắn Tay', '967311.00', '20221207-205307sp20_1.png', 0, 'ao-thun-nam-mau-tron-co-be-ngan-tay', 'Áo Thun Nam màu trơn Cổ Bẻ Ngắn Tay,ÁO Phông Nam Dáng Ôm Thời Trang Cam Cấp\r\nThời trang nam xuất khẩu - chuyên cung cấp các mặt hàng thời trang nam: quần tây, áo sơ mi, áo thun, quần short.. chất liệu cao cấp, giá thành hợp lý, sỉ lẻ giá tốt.  Là địa chỉ mua hàng đáng tin cậy của bạn !\r\nThông tin sản phẩm: Áo phông nam cổ bẻ việt nam xuất khẩu\r\n- Áo cotton 100% cổ bẻ, ngắn tay.\r\n- Made in Vietnam.\r\n- Form dáng body vừa người , phù hợp du lịch, du xuân, dạo phố, picnic, cafe....\r\n- Áothun nam cổ bẻ họa tiết trẻ trung.\r\n- Áo thun nam  là trang phục giúp các chàng trai làm mới phong cách của chính mình.\r\n- Thiết kế cổ bẻ xẻ trụ đơn giản, cực kỳ năng động, khỏe khoắn, nhưng vẫn không kém phần sành điệu, hợp mốt.', NULL, NULL, NULL, NULL, NULL),
('60e57f80-33cf-435a-a5fe-4e6affaad7a6', 4, 'Áo thể thao', '1000.00', '20221202-121401sp2_5.png', 0, 'quan-da-bong', 'Quý khách vui lòng nhắn tin cho shop trong vòng 1 ngày sau khi nhận được hàng để được hỗ trợ trong trường hợp cần xuất hóa đơn đỏ (VAT) cho sản phẩm đã mua tại Shopee.\r\nQuá thời gian nhận được hàng đã nêu, shop xin được phép không hỗ trợ dù trong bất kỳ trường hợp nào.\r\nLuôn có thứ được yêu thích hơn hẳn, kể cả trong số các món đồ basic của bạn. Chiếc áo thun adidas này có đầy đủ những chi tiết xuất sắc. Logo Ba Lá đặc trưng ở cả mặt trước và mặt sau. Chất liệu cotton dễ chịu. Người ta gọi đó là trung thành. Còn bạn chỉ cần nhìn là biết đâu là đồ tốt. \r\n \r\n Các sản phẩm cotton của chúng tôi giúp hỗ trợ ngành trồng bông bền vững. Đây chính là mong muốn của chúng tôi hướng tới chấm dứt rác thải nhựa.\r\n- Cổ tròn có gân sọc\r\n- Vải jersey một mặt phải làm từ 100% cotton\r\n- Cảm giác mềm mại\r\n- Logo Ba Lá cỡ lớn sau lưng\r\n- Dáng loose fit', NULL, NULL, NULL, NULL, NULL),
('64a59a25-2488-54b0-f6b4-c8af08a50cbf', 1, 'Áo thun nam mùa hè ', '618.80', '20221019-224035f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg', 0, 'aothunnammuahe-1-1', 'asdfsdf', NULL, NULL, NULL, NULL, NULL),
('674934cc-42cf-20cf-1d4a-aea48a10ed18', 2, 'Áo thun nữ mùa hè', '943.35', '20221019-224043ao-training-F50-den-phoi-hong-2015-2016-VN-600x800.jpg', 0, 'aothunnumuahe-1-1', 'asdfsdafasdf', NULL, NULL, NULL, NULL, NULL),
('68875d07-d07e-4745-b700-c7e1d87639ac', 2, 'Áo nike in logo nam nữ', '1000.00', '20221202-140026sp7_4.png', 0, 'ao-nike-in-logo-nam-nu', 'Thông tin sản phẩm: Áo thun in logo dành cho cả nam và nữ, cổ tròn, form rộng\r\n- Chất liệu: vải cotton mát - mướt - mịn, co giãn 4 chiều, không bị nhăn và thấm hút mồ hôi.\r\n- Đường may chuẩn xác, tỉ mỉ, chắc chắn.\r\n- Mặc đi chơi, hội hè, tụ tập cùng bạn bè, hay hàng ngày đều có thể phối với nhiều phong cách.\r\n- Thiết kế trẻ trung, năng động.', NULL, NULL, NULL, NULL, NULL),
('7329c45c-2033-41a8-9365-21447cf28831', 4, 'Áo guci', '250000.00', '20221202-140153sp9_2.png', 0, 'ao-guci', 'áo đẹp hàng hiệu', NULL, NULL, NULL, NULL, NULL),
('73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 4, 'Áo thun Louis Vuitton cổ len tròn', '726313311.00', '20221207-205838sp15_4.png', 0, 'ao-thun-louis-vuitton-co-len-tron', 'THÔNG TIN SẢN PHẨM \r\n- Tên sản phẩm : Áo thun Louis Vuitton cổ len tròn , bo viền cổ , chữ thêu( dành cho cả nam và nữ ) \r\n- Chất liệu : Vải cotton co dãn , mềm mát , không xù , không phai , thấm hút mồ hôi\r\nQUY ĐỊNH ĐỔI TRẢ, BẢO HÀNH ', NULL, NULL, NULL, NULL, NULL),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 9, 'Áo dầy cộm', '300000.00', '20221013-074658ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 0, 'ao-day-com-1', 'sdfjsd', NULL, NULL, NULL, NULL, NULL),
('8d13786f-4afe-4586-971f-86f957f005a5', 2, 'Áo thun in logo dành cho cả nam và nữ', '1000.00', '20221207-193240sp7_3.png', 0, 'ao-thun-in-logo-danh-cho-ca-nam-va-nu', 'Áo thun là món đồ \" Không thể thiếu \" trong tủ đồ của mọi người. Mẫu mã và màu sắc đa dạng, thiết kế bắt mắt, bắt kịp mọi xu hướng mới nhất hiện nay\r\nÁo có chiều dài tay áo dài hơn so với áo thun nam ngắn tay, thường dài gần đến khuỷu tay hoặc qua khuỷu tay, xuất hiện ở những áo thun unisex.\r\nHƯỚNG DẪN SỬ DỤNG: Áo thun in logo dành cho cả nam và nữ, cổ tròn, form rộng\r\n- Nhớ lộn trái khi giặt.\r\n- Không nên giặt máy trong 7 ngày đầu.\r\n- Không ngâm hay sử dụng thuốc tẩy.\r\n- Khi phơi lộn trái áo và không phơi trực tiếp dưới ánh nắng mặt trời.', NULL, NULL, NULL, NULL, NULL),
('92b87850-3ff0-4004-ab0a-bd8350ce5bf9', 3, 'Áo gucci cặp đôi', '500000.00', '20221202-135211sp19_1.png', 0, 'ao-gucci-cap-doi', 'Vải / Chất liệu: Khác / Khác\r\nPhù hợp: Vừa vặn\r\nChiều dài tay áo: tay áo ngắn\r\nChi tiết kiểu quần áo: màu trơn\r\nIn ấn\r\nCái nút\r\nPhong cách: Hàn Quốc\r\nĐộ tuổi thích hợp: Người trẻ tuổi (18-25 tuổi) ', NULL, NULL, NULL, NULL, NULL),
('b08607cf-cb93-4dcf-b796-794adba7d426', 1, 'Áo thể thao nam nữ', '70000000.00', '20221202-133555sp2_5.png', 0, 'ao-the-thao-nam-nu', ' Các sản phẩm cotton của chúng tôi giúp hỗ trợ ngành trồng bông bền vững. Đây chính là mong muốn của chúng tôi hướng tới chấm dứt rác thải nhựa.', NULL, NULL, NULL, NULL, NULL),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 2, 'Áo thun nam cổ tròn tay ngắn Depstyle PT82', '1000.00', '20221207-193612sp8_3.png', 0, 'ao-thun-nam-co-tron-tay-ngan-depstyle-pt82', '🔰 HƯỚNG DẪN CHỌN SIZE ÁO\r\nSize M : phù hợp với bạn có cân nặng từ 45 - 55kg.\r\nSize L : phù hợp với bạn có cân nặng từ 55 - 64kg.\r\nSize XL : phù hợp với bạn có cân nặng 64 - 72kg.\r\nSize 2XL : phù hợp với bạn có cân nặng 72 - 80kg.\r\nSize 3XL : phù hợp với bạn có cân nặng 80 - 88kg.\r\nSize 4XL : phù hợp với bạn có cân nặng 88 - 95kg.\r\n👉 Lưu ý : Với người lớn tuổi, bụng to thì nên chọn lớn hơn 1 size để mặc thoải mái hơn.', NULL, NULL, NULL, NULL, NULL),
('c22edc73-1e37-4208-8637-46844daad0fa', 2, 'áo đi bơi', '1000.00', '20221019-222409z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 0, 'ao-di-boi', 'asdfasdf', NULL, NULL, NULL, NULL, NULL),
('c7535de6-b85f-4b2b-bb26-551397636a72', 2, 'Áo nike dáng Unisex', '1000.00', '20221202-135603sp6_4.png', 0, 'ao-nike-dang-unisex', 'Áo Thun dáng Unisex, phong cách Streetwear	\r\n	\r\n-Size M: dưới 50kg, Cao dưới 1m70	\r\n-Size L: từ 56-75kg , Cao dưới 1m80	\r\n-Size XL: từ 75-110 kg, Cao dưới 1m85	\r\n\r\n🥝 🍓 Ngập tràn mẫu mới 🍓 🥝	\r\n🌸 Vải đẹp Cotton 100%  , không xù , không co rút , mềm mịn dày dặn , hút mồ hôi cực nhanh, mặc siêu mát .	\r\n	', NULL, NULL, NULL, NULL, NULL),
('e531fdab-cb12-479c-aba4-b3d293b2e6ed', 1, 'Áo adidas phiên bản 2021', '8000000.00', '20221202-134259sp4_5.png', 0, 'ao-adidas-phien-ban-2021', 'Quý khách vui lòng nhắn tin cho shop trong vòng 1 ngày sau khi nhận được hàng để được hỗ trợ trong trường hợp cần xuất hóa đơn đỏ (VAT) cho sản phẩm đã mua tại Shopee.\r\nQuá thời gian nhận được hàng đã nêu, shop xin được phép không hỗ trợ dù trong bất kỳ trường hợp nào.\r\nCông nghệ giày adidas 4D phát triển dựa trên nền tảng cải tiến. Công nghệ này mang lại cảm giác thoải mái chưa từng có trong từng chuyển động của bạn. Chiếc áo thun adidas này không phải là giày hay sử dụng công nghệ 4D, nhưng lấy cảm hứng từ đó và mang lại sự thoải mái tương đương dưới một dạng thức mới — chất vải jersey cotton siêu mềm mại. Hãy diện áo và hòa mình vào nguồn cảm hứng tích cực mà chiếc áo này mang lại.\r\n- Dáng regular fit\r\n- Cổ tròn có gân sọc\r\n- Vải single jersey làm từ 100% cotton', NULL, NULL, NULL, NULL, NULL),
('e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 3, 'Áo gucci doremon nữ', '1000.00', '20221202-135018sp14_4.png', 0, 'ao-gucci-doremon-nu', 'Thương hiệu : Gucci G C\r\nSize : S-XL\r\nMàu sắc : trắng\r\nChất liệu :  cao cấp', NULL, NULL, NULL, NULL, NULL),
('ff204830-f606-4c8a-8706-7d251ad3c558', 8, 'Chiếu áo màu hường', '1243985.00', '20221013-07471932179fbdbac9c410e1a949acd46ab64d.jpeg', 0, 'chieu-ao-mau-huong-1', 'hiiihi', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `productdetails`
--

DROP TABLE IF EXISTS `productdetails`;
CREATE TABLE IF NOT EXISTS `productdetails` (
  `ProductDetailsID` char(36) NOT NULL COMMENT 'ID thông tin chi tiết sản phẩm',
  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
  `ColorID` varchar(20) DEFAULT NULL COMMENT 'ID màu sắc',
  `SizeID` varchar(20) DEFAULT NULL COMMENT 'ID size',
  `Quantity` int(11) DEFAULT NULL COMMENT 'Số lượng sản phẩm',
  PRIMARY KEY (`ProductDetailsID`),
  KEY `FK_productdetails_color_ColorID` (`ColorID`),
  KEY `FK_productdetails_product_ProductID` (`ProductID`),
  KEY `FK_productdetails_size_SizeID` (`SizeID`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Thông tin chi tiết sản phẩm';

--
-- Dumping data for table `productdetails`
--

INSERT INTO `productdetails` (`ProductDetailsID`, `ProductID`, `ColorID`, `SizeID`, `Quantity`) VALUES
('01103f01-8568-4ca7-86e9-dfe6ce93a2fc', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'XXL', 1),
('01d6efef-544d-4cac-84b5-9a3e4260f14a', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'L', 1),
('03abecc6-0f76-40d6-ae24-5900f530327a', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'XXL', 4),
('070e9d5c-7803-4690-b421-b1967926036d', 'b7ca8237-abc8-49bb-a819-d410012d95d5', 'Tim001', 'L', 1),
('078830c8-1fae-4cc1-af26-47f1518d5dbd', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'XL', 1),
('08bfbedf-3d0f-46f6-8c86-ff682e633403', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'XXXL', 0),
('0ae2f15b-9653-4a89-97a4-ae45d213f6b0', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'XXL', 0),
('0d741f2f-ee05-406d-9b63-6b61f766f5cf', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'M', 5),
('0e0f2977-e4cb-4602-91f3-3228160044e8', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'XXL', 3),
('0e631ec6-addc-44aa-8d37-a84b2351f323', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'XL', 1),
('0eae62b3-ab4c-491d-bc08-bf2007aa4164', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'XS', 1),
('0fd62622-7af6-4dce-b0b7-55dc40131819', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'XXL', 1),
('15f1c6d1-5203-45ee-b461-ee734e3ae6ff', 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 'Xanh001', 'XXL', 1),
('173477e0-d8d0-4c1d-897b-5c1cfb4d6ccc', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XXXL', 0),
('196d815a-4fc1-11ed-8139-0242ac140002', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'XXL', 4),
('1a99fcff-c942-4087-a0d7-ebc8b247114c', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Xanh001', 'XL', 3),
('1add0202-4cca-448f-b0ca-7f334e46c5ac', '2e96922b-180d-4048-a33b-3263c15cfd22', 'Tim001', 'M', 5),
('1c906cce-d0c8-491c-b751-b92f4dc9bc52', '2afaae77-ed2b-4cc0-8241-c54ae7eda137', 'Vang001', 'S', 5),
('1f92981f-c034-413e-a3d5-8295c448d216', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'XXL', 0),
('21bc967c-2a7d-4b6c-b989-a202bc51af02', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Do001', 'M', 1),
('228e097b-c2d4-48d6-840c-69522d085b88', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'L', 0),
('2487eb2b-f9e0-4efb-8f3b-e9f1396b9599', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'L', 1),
('25e6cda2-ae86-444c-9f66-61c352fafb1e', '8d13786f-4afe-4586-971f-86f957f005a5', 'Tim001', 'L', 2),
('26f02e5a-ca43-481d-a033-adb1ae667132', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'S', 0),
('271eb62b-bea1-4039-9003-3d3c92a7e420', 'b7ca8237-abc8-49bb-a819-d410012d95d5', 'Xanh001', 'XS', 3),
('29b02114-f0fa-4bd2-8766-7dc08e652b6c', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'XXL', 1),
('2acd7fdf-2cee-4d1a-95ab-3256cb0624ad', '8d13786f-4afe-4586-971f-86f957f005a5', 'Do001', 'L', 5),
('2c6e8ac1-a2be-4399-bd0d-c9ba65dd11bd', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Xanh001', 'M', 12),
('2c880562-156e-476b-957d-cd449a4df142', '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', 'Vang001', 'XS', 1),
('2ebe2c6a-9c1f-4380-98d8-820fcf619db3', '215a297f-0c0f-4eff-91cf-69402436d6f1', 'Tim001', 'M', 0),
('2f05d896-e0df-40e8-a558-22f2cb484c52', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'XS', 1),
('33ccc207-09f6-4b7e-8b00-223e9f7c5d93', '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 'Tim001', 'M', 0),
('362293fd-4683-4cf4-bcfb-808ef1b5ef51', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'L', 0),
('3cae7338-9ee3-4aa8-a260-d2f745cddf45', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Xanh001', 'XL', 3),
('3ced912d-4a22-429c-8732-80616abb89a8', '7329c45c-2033-41a8-9365-21447cf28831', 'Do001', 'S', 0),
('3e18914e-d3ae-4426-b633-6c5aa5327f8e', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'M', 0),
('3e6510d4-a611-4fd9-be9c-a3f5f354aa49', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'M', 0),
('3fb60e46-002d-4904-bcb6-d9853ba6fe91', 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 'Xanh001', 'XL', 5),
('444d831f-2fc0-444a-928a-e3ba77267877', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'M', 0),
('45c56df0-27b5-42b2-9180-933d271db4db', '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 'Tim001', 'L', 0),
('468724d0-bca3-4a6d-a7d3-09f5f4b7e809', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'S', 1),
('4ae0993e-bebd-4051-a14d-eeade78f226d', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Xanh001', 'XL', 3),
('4b832bdd-7242-4127-90eb-e7258f364733', '2afaae77-ed2b-4cc0-8241-c54ae7eda137', 'Vang001', 'XL', 5),
('4c11ebad-5bc4-493f-b11c-6d988af04bf5', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'XS', 1),
('4e5b7576-4fc1-11ed-8139-0242ac140002', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Vang001', 'S', 0),
('53e410a2-7af5-444f-b648-84d570f9de6e', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XXL', 0),
('544072f0-3949-4f10-ac06-3a1290d4223c', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'M', 1),
('56ab956f-9dd3-412e-81bf-8de3d0a31789', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'S', 1),
('584dfd8a-4f66-4fd6-90bd-e2946f1c3269', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Xanh001', 'XS', 5),
('5a2e67a8-e0bd-435d-82bf-24f16a888493', '394f8331-8574-4010-91c0-9cd69f0c8608', 'Tim001', 'XL', 3),
('5db1c138-600c-4d2c-a3d2-a723611c585d', '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 'Vang001', 'L', 0),
('5e6695e2-5aad-3241-6c1a-bb545470e80c', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Do001', 'XL', 61),
('5fc776ed-b1af-435f-b095-cd1e0c73b5ee', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Xanh001', 'M', 5),
('60ed9de1-0249-44c0-ba42-75868324a6be', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Tim001', 'M', 0),
('65970e2d-f852-41b6-961a-e6d6e2fbe18a', '7329c45c-2033-41a8-9365-21447cf28831', 'Do001', 'L', 0),
('677e4e22-c770-4282-a266-1e2a241f6aaf', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Tim001', 'XL', 7),
('68bc7bca-e03b-4154-9c48-e53d8fac7171', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'S', 0),
('6d1b6674-60be-4ae6-b143-9ee3dadcc1d4', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'L', 1),
('6fe89d6e-03e6-444b-9dcc-ba769bb62ade', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Xanh001', 'XXL', 7),
('7118fc4a-831c-4997-82e9-79c1b6c5f955', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'XL', 0),
('7193fcfa-f9ae-49c6-9c7e-26ea57b9898b', '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', 'Tim001', 'M', 1),
('72c5a2d7-0bfd-4afd-8648-c41c4cf295c9', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'M', 0),
('756c19a3-2b1b-4d23-94d7-2e95a76e3144', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Tim001', 'L', 3),
('76a103d1-20c1-48c1-b525-8b2c54840898', 'ff204830-f606-4c8a-8706-7d251ad3c558', 'Do001', 'M', 0),
('77459142-0754-4874-aab5-c9e2694c99fc', '5c1de774-95b5-4e37-be90-2b329b70a375', 'Vang001', 'S', 0),
('779e0364-d733-45cc-b075-f8e3319d81b0', '2afaae77-ed2b-4cc0-8241-c54ae7eda137', 'Vang001', 'M', 5),
('77d4d69c-c968-4422-add2-6ff0cbdf514e', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Do001', 'L', 4),
('78074279-ebec-4dce-8806-193e585d6ce8', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Tim001', 'M', 2),
('79567788-eadb-4b6f-a10b-cffbcdc2f0d9', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'XL', 0),
('7a3a5a43-d1e3-4d12-9663-f3b148593e97', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'XL', 0),
('7c256c5c-d93f-449d-bdd2-666fc8bfc634', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Vang001', 'XXL', 9),
('7e6059ca-96ea-41e4-a530-b5cd03fdff32', 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', 'Xanh001', 'S', 1),
('7e8083b6-4fc1-11ed-8139-0242ac140002', '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'Tim001', 'M', 0),
('7ebe7f93-13b5-461a-ad71-04e4fbe28950', 'ff204830-f606-4c8a-8706-7d251ad3c558', 'Do001', 'S', 0),
('8a33585c-5390-4d96-920c-1788de6d2b91', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'S', 0),
('8a525e39-d50c-41e3-b73a-48aac8e80392', 'b7ca8237-abc8-49bb-a819-d410012d95d5', 'Tim001', 'XS', 7),
('8aac23b8-a6b9-4488-be3f-d33dc27c1f65', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'XXXL', 0),
('8c269f4d-6150-4467-913f-06bab768b204', '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 'Tim001', 'S', 1),
('8e8b7391-37bb-4e7c-a0d7-f50b472af8c8', '7329c45c-2033-41a8-9365-21447cf28831', 'Tim001', 'L', 0),
('921e11cd-5bde-48a4-9e11-44c323bc9e2e', '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 'Tim001', 'XL', 5),
('9354b0b3-e9cb-402f-8c86-9928bc40f62f', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'M', 0),
('942d9dc6-f613-4de4-801d-36cc3014729f', '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 'Vang001', 'XL', 9),
('97e67b73-6cc7-4199-842c-ad1fb3735c97', '20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', 'Vang001', 'S', 2),
('991e3d36-0395-4646-949d-ed9aee3278d9', '50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 'Vang001', 'S', 10),
('9c85bf87-2729-414c-8f83-65588465a0ad', '8d13786f-4afe-4586-971f-86f957f005a5', 'Tim001', 'M', 7),
('9fd0c158-6654-4b88-afed-49f5693d61c9', 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', 'Vang001', 'XS', 2),
('a0198dcb-67a7-49fb-828e-8541ecf59643', 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', 'Vang001', 'S', 3),
('a0da78c5-5d11-4677-af66-1eea4880f1e3', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XS', 3),
('a1ce4ab0-d8ce-46c2-971d-67273ef344ac', '2afaae77-ed2b-4cc0-8241-c54ae7eda137', 'Vang001', 'L', 5),
('a3307e5f-9a85-488f-a5b7-a7f90b8b92f1', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Xanh001', 'M', 5),
('a8df396f-bdf2-464c-9288-1b7dbbe87bc5', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'S', 0),
('a8e50c40-127b-4b6a-91d8-dfffb3200ca2', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Tim001', 'XL', 0),
('ab238919-615c-43d1-b690-f8ed1f7bb744', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'S', 0),
('ab2ed3c1-874c-48a0-bede-e51edc2542d8', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'S', 0),
('b4c354ce-c72f-430c-ba13-329f94742d70', 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 'Tim001', 'XXL', 6),
('b5003376-5233-4b44-a42a-5ca01c5ad48e', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'M', 0),
('ba8a9892-1595-4550-b00a-f300e918eb4e', '3163c21c-25ea-4ec8-a6a3-99864cde1bd3', 'Vang001', 'M', 2),
('bb7bccbd-80f5-4171-8e5a-3dab15a23b75', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Do001', 'XXXL', 0),
('bb963951-0eb6-4cc3-891d-a9b9efa7759b', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'XS', 0),
('bc7c5812-d0c7-42ba-a286-6c649582cd0e', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'S', 0),
('bfa867e3-bc8f-47fb-a82c-50de0d511d75', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Vang001', 'L', 26),
('c1513936-cac2-4965-8797-90e599fb9829', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XL', 0),
('c420cd46-8a96-4aa6-b955-e67968cbd046', '7329c45c-2033-41a8-9365-21447cf28831', 'Tim001', 'S', 0),
('c6a230af-ddfd-4b4e-ae1f-5216a2e7b868', '8d13786f-4afe-4586-971f-86f957f005a5', 'Do001', 'M', 9),
('c858e5a5-c5e9-48d4-b748-26ca0c0b5edf', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Xanh002', 'L', 0),
('c9622669-4c99-4528-b746-1eea7ac0b2d8', '215a297f-0c0f-4eff-91cf-69402436d6f1', 'Tim001', 'L', 0),
('ce3f1dad-725e-49de-986a-06801db7ae92', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'XXXL', 0),
('d0278479-f83e-4b73-b632-8d43e5f0508e', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'M', 0),
('d526af60-b059-497b-8ca5-d7f59bffa6e0', '11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 'Vang001', 'M', 0),
('d639b457-b43d-4385-b41f-6e7f9c7341ac', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Vang001', 'M', 1),
('db2c7bab-7645-412d-b11d-b436c37b6969', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Do001', 'XL', 1),
('db32da2e-9005-44d7-a5d0-04944a83b67e', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Tim001', 'L', 3),
('dbf6ecec-dbbf-4dfa-9ae0-0270c123e8d3', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'M', 0),
('dcb75480-70a7-47fc-97b4-0bd69b88427b', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Tim001', 'M', 2),
('ddb74e24-e65f-48b5-8c26-afda84c48286', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh002', 'XS', 0),
('e7bea2ee-c46e-441c-8ef9-63bf4e4b0128', 'b08607cf-cb93-4dcf-b796-794adba7d426', 'Vang001', 'XL', 1),
('e86c8bb9-e3e0-46a1-b3fc-d470a01237ee', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Tim001', 'M', 0),
('e8e731ad-a773-4185-95cb-b789a7a73f0b', '319b6893-71e1-4084-9045-c869bba4d544', 'Do001', 'S', 4),
('e90ad519-a3ed-4279-87cb-b716eef6b1a0', 'e531fdab-cb12-479c-aba4-b3d293b2e6ed', 'Xanh001', 'XS', 5),
('ea5e2c78-cd3c-4a40-811a-8c2689abd238', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'XXXL', 0),
('ec305296-7915-4637-8989-1b7802b71f0c', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Xanh001', 'XXL', 0),
('ecaddd1a-204f-4924-b179-bf6cb9f7b288', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'XXL', 0),
('f5568e87-4fc7-4ae1-9324-6b92780ade54', 'e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 'Tim001', 'XL', 4),
('f7fe536c-18e6-4a13-9cab-6386eed91a20', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'S', 0),
('f888647c-7370-4797-95a4-3ac8a55b6f24', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'S', 0),
('faaf23e1-88cc-45cb-92e8-0951ea7b0eec', '73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 'Vang001', 'L', 0),
('fac6f520-6cd0-4dcf-8676-09e8cf34b5ce', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Do001', 'M', 0),
('fbb4193a-693b-4477-a76b-f6f6a4d2af12', 'b7ca8237-abc8-49bb-a819-d410012d95d5', 'Xanh001', 'L', 9),
('fec85db0-1b2c-4ff3-bb0e-531f15890564', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Do001', 'XS', 5),
('ff19094f-a8da-4584-ac57-9c1897d76121', 'c7535de6-b85f-4b2b-bb26-551397636a72', 'Tim001', 'XS', 1);

-- --------------------------------------------------------

--
-- Table structure for table `productincategory`
--

DROP TABLE IF EXISTS `productincategory`;
CREATE TABLE IF NOT EXISTS `productincategory` (
  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
  `CategoryID` int(11) DEFAULT NULL COMMENT 'ID danh mục',
  KEY `FK_productincategory_ category_CategoryID` (`CategoryID`),
  KEY `FK_productincategory_Product_ProductID` (`ProductID`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng sản phẩm trong danh mục';

--
-- Dumping data for table `productincategory`
--

INSERT INTO `productincategory` (`ProductID`, `CategoryID`) VALUES
('64a59a25-2488-54b0-f6b4-c8af08a50cbf', 13),
('64a59a25-2488-54b0-f6b4-c8af08a50cbf', 15),
('674934cc-42cf-20cf-1d4a-aea48a10ed18', 16),
('674934cc-42cf-20cf-1d4a-aea48a10ed18', 14),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 13),
('ff204830-f606-4c8a-8706-7d251ad3c558', 13),
('ff204830-f606-4c8a-8706-7d251ad3c558', 14),
('ff204830-f606-4c8a-8706-7d251ad3c558', 15),
('ff204830-f606-4c8a-8706-7d251ad3c558', 16),
('60e57f80-33cf-435a-a5fe-4e6affaad7a6', 17),
('46b34359-bda9-484b-b9f2-32b6c03ba877', 20),
('46b34359-bda9-484b-b9f2-32b6c03ba877', 17),
('4148606d-f5b6-4b89-9290-442c4b606db9', 18),
('4148606d-f5b6-4b89-9290-442c4b606db9', 20),
('c22edc73-1e37-4208-8637-46844daad0fa', 13),
('c22edc73-1e37-4208-8637-46844daad0fa', 15),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 18),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 14),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 15),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 19),
('4148606d-f5b6-4b89-9290-442c4b606db9', 15),
('4148606d-f5b6-4b89-9290-442c4b606db9', 16),
('7329c45c-2033-41a8-9365-21447cf28831', 13),
('7329c45c-2033-41a8-9365-21447cf28831', 17),
('b08607cf-cb93-4dcf-b796-794adba7d426', 13),
('b08607cf-cb93-4dcf-b796-794adba7d426', 14),
('b08607cf-cb93-4dcf-b796-794adba7d426', 15),
('50b712ee-4fe4-47e7-81fa-dcbdd633f2e0', 13),
('e531fdab-cb12-479c-aba4-b3d293b2e6ed', 13),
('3163c21c-25ea-4ec8-a6a3-99864cde1bd3', 13),
('20054a5c-b9f1-4e61-a482-b7fc4a6f5eec', 13),
('e94efcc3-100a-4db9-a6f5-b89e1918d4ba', 16),
('92b87850-3ff0-4004-ab0a-bd8350ce5bf9', 13),
('92b87850-3ff0-4004-ab0a-bd8350ce5bf9', 16),
('92b87850-3ff0-4004-ab0a-bd8350ce5bf9', 15),
('c7535de6-b85f-4b2b-bb26-551397636a72', 13),
('c7535de6-b85f-4b2b-bb26-551397636a72', 15),
('68875d07-d07e-4745-b700-c7e1d87639ac', 13),
('68875d07-d07e-4745-b700-c7e1d87639ac', 14),
('68875d07-d07e-4745-b700-c7e1d87639ac', 16),
('68875d07-d07e-4745-b700-c7e1d87639ac', 15),
('8d13786f-4afe-4586-971f-86f957f005a5', 13),
('8d13786f-4afe-4586-971f-86f957f005a5', 14),
('8d13786f-4afe-4586-971f-86f957f005a5', 15),
('8d13786f-4afe-4586-971f-86f957f005a5', 16),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 13),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 17),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 14),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 15),
('b7ca8237-abc8-49bb-a819-d410012d95d5', 16),
('234462fc-a6a0-4283-b528-eeceb6599fba', 13),
('234462fc-a6a0-4283-b528-eeceb6599fba', 15),
('234462fc-a6a0-4283-b528-eeceb6599fba', 16),
('234462fc-a6a0-4283-b528-eeceb6599fba', 14),
('11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 13),
('11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 15),
('11bf1e27-7aec-4fbc-a0ae-aebcc28f59cb', 16),
('319b6893-71e1-4084-9045-c869bba4d544', 13),
('319b6893-71e1-4084-9045-c869bba4d544', 15),
('215a297f-0c0f-4eff-91cf-69402436d6f1', 13),
('215a297f-0c0f-4eff-91cf-69402436d6f1', 15),
('5c1de774-95b5-4e37-be90-2b329b70a375', 13),
('5c1de774-95b5-4e37-be90-2b329b70a375', 15),
('2afaae77-ed2b-4cc0-8241-c54ae7eda137', 13),
('2afaae77-ed2b-4cc0-8241-c54ae7eda137', 14),
('2afaae77-ed2b-4cc0-8241-c54ae7eda137', 15),
('2afaae77-ed2b-4cc0-8241-c54ae7eda137', 16),
('394f8331-8574-4010-91c0-9cd69f0c8608', 14),
('394f8331-8574-4010-91c0-9cd69f0c8608', 16),
('73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 13),
('73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 14),
('73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 15),
('73c8add7-bddd-4b08-a763-9a47dfe4d2a8', 16),
('2e96922b-180d-4048-a33b-3263c15cfd22', 13),
('2e96922b-180d-4048-a33b-3263c15cfd22', 15);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `RoleID` varchar(20) NOT NULL,
  `RoleName` varchar(50) NOT NULL COMMENT 'Tên quyền',
  PRIMARY KEY (`RoleID`),
  UNIQUE KEY `role_name` (`RoleName`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng quyền ';

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`RoleID`, `RoleName`) VALUES
('customer', 'Khách hàng'),
('admin', 'Quản trị viên');

-- --------------------------------------------------------

--
-- Table structure for table `size`
--

DROP TABLE IF EXISTS `size`;
CREATE TABLE IF NOT EXISTS `size` (
  `SizeID` varchar(20) NOT NULL COMMENT 'ID size',
  `SizeName` varchar(50) NOT NULL COMMENT 'Tên size',
  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả',
  PRIMARY KEY (`SizeID`),
  UNIQUE KEY `SizeName` (`SizeName`)
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Size quần áo';

--
-- Dumping data for table `size`
--

INSERT INTO `size` (`SizeID`, `SizeName`, `Description`) VALUES
('L', 'L', 'Vòng ngưc:88-92, Vòng eo:70-72, Vòng mông:88-89, Chiều cao:1m55-1m57 '),
('M', 'M', 'Vòng ngưc:83-87, Vòng eo:68-69, Vòng mông:86-87, Chiều cao:1m52-1m54 '),
('S', 'S', 'Vòng ngưc:78-82, Vòng eo:66-67, Vòng mông:83-85, Chiều cao:1m49-1m51 '),
('XL', 'XL', 'Vòng ngưc:93-97, Vòng eo:73-74, Vòng mông:90-92, Chiều cao:1m58-1m60 '),
('XS', 'XS', 'Vòng ngưc:74-77, Vòng eo:63-65, Vòng mông:80-82, Chiều cao:1m46-1m48 '),
('XXL', '2XL', 'Vòng ngưc:98-102, Vòng eo:75-77, Vòng mông:93-95, Chiều cao:1m61-1m63 '),
('XXXL', '3XL', 'Vòng ngưc:103-112, Vòng eo:78-99, Vòng mông:96-99, Chiều cao:1m64-1m69 ');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `UserID` char(36) NOT NULL COMMENT 'Id admin và nhân viên',
  `Username` varchar(50) NOT NULL COMMENT 'Tên đăng nhập',
  `Password` varchar(50) NOT NULL COMMENT 'Mật khẩu',
  `PhoneNumber` varchar(50) DEFAULT NULL COMMENT 'Số điện thoại',
  `Address` varchar(50) DEFAULT NULL COMMENT 'Địa chỉ',
  `Fullname` varchar(50) DEFAULT NULL COMMENT 'Tên đày đủ',
  `LastOperatingTime` date NOT NULL COMMENT 'Thời gian đăng nhập lần cuối',
  `CreatedDate` date DEFAULT NULL COMMENT 'Ngày tạo',
  `CreatedBy` varchar(50) DEFAULT NULL COMMENT 'Người tạo',
  `ModifiedDate` date DEFAULT NULL COMMENT 'Ngày chỉnh sửa gần nhất',
  `ModifiedBy` varchar(50) DEFAULT NULL COMMENT 'Người chỉnh sửa',
  `DeletedDate` date DEFAULT NULL,
  `RoleID` varchar(20) DEFAULT NULL COMMENT 'Id quyền truy cập',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `user_name` (`Username`),
  KEY `FK_user_role_RoleID` (`RoleID`)
) ENGINE=InnoDB AVG_ROW_LENGTH=4096 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng thông tin admin và nhân viên';

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserID`, `Username`, `Password`, `PhoneNumber`, `Address`, `Fullname`, `LastOperatingTime`, `CreatedDate`, `CreatedBy`, `ModifiedDate`, `ModifiedBy`, `DeletedDate`, `RoleID`) VALUES
('3caebdc6-542d-11ed-906d-0242ac130002', 'admin', '21232f297a57a5a743894a0e4a801fc3', '0123456789', 'gia lai', 'Tao là chúa tể', '2022-10-25', NULL, NULL, NULL, NULL, NULL, 'admin'),
('3caed185-542d-11ed-906d-0242ac130002', 'customer', '202cb962ac59075b964b07152d234b70', '0987654321', 'gia lai', 'Phuong Nam', '2022-10-25', NULL, NULL, NULL, NULL, NULL, 'customer'),
('6c124a45-1a84-4f80-b752-83a51423c829', 'haha', '202cb962ac59075b964b07152d234b70', '01234567891', NULL, 'haha', '2022-11-10', '2022-11-10', NULL, NULL, NULL, NULL, 'customer'),
('741c0789-b1fa-4110-be66-aed92c7006d3', 'anh', '202cb962ac59075b964b07152d234b70', '0987654321', NULL, 'anh', '0001-01-01', '0001-01-01', NULL, NULL, NULL, NULL, 'customer'),
('ab245631-c3fe-40be-842a-3f6f85af0860', 'hihi', '202cb962ac59075b964b07152d234b70', '0987654321', NULL, 'hihi', '2022-11-10', '2022-11-10', NULL, NULL, NULL, NULL, 'customer'),
('e3b9908c-a53d-4772-8df9-1d146e17691d', 'tuan', '202cb962ac59075b964b07152d234b70', '0987654321', NULL, 'tuan', '2022-11-10', '2022-11-10', NULL, NULL, NULL, NULL, 'customer');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `gallery`
--
ALTER TABLE `gallery`
  ADD CONSTRAINT `FK_gallery_product_ProductID` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `productdetails`
--
ALTER TABLE `productdetails`
  ADD CONSTRAINT `FK_productdetails_color_ColorID` FOREIGN KEY (`ColorID`) REFERENCES `color` (`ColorID`),
  ADD CONSTRAINT `FK_productdetails_product_ProductID` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  ADD CONSTRAINT `FK_productdetails_size_SizeID` FOREIGN KEY (`SizeID`) REFERENCES `size` (`SizeID`);

--
-- Constraints for table `productincategory`
--
ALTER TABLE `productincategory`
  ADD CONSTRAINT `FK_productincategory_ category_CategoryID` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`),
  ADD CONSTRAINT `FK_productincategory_Product_ProductID` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK_user_role_RoleID` FOREIGN KEY (`RoleID`) REFERENCES `role` (`RoleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
