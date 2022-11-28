-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Nov 28, 2022 at 02:25 PM
-- Server version: 5.7.39
-- PHP Version: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `coolshop`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_product_GetPaging` (IN `v_Offset` INT, IN `v_Limit` INT, IN `v_Sort` VARCHAR(100), IN `v_Where` VARCHAR(1000))  SQL SECURITY INVOKER COMMENT '\r\n  -- Author:        NVDIA\r\n  -- Created date:  10/5/2022\r\n  -- Description:   Lấy danh sách sản phẩm và tổng số sản phẩm, tổng số  có phân trang\r\n  -- Modified by:   \r\n  -- Code chạy thử: CALL `hust.21h.2022.nvdia`.Proc_product_GetPaging(0, 10, NULL, "EmployeeName like ''%Dìa%''");' BEGIN
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

CREATE TABLE `brand` (
	  `BrandID` int(11) NOT NULL COMMENT 'ID nhãn hiệu',
	  `BrandName` varchar(50) NOT NULL COMMENT 'Tên Nhãn hiệu',
	  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả '
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Nhãn hiệu';

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

CREATE TABLE `cart` (
	  `id` int(11) NOT NULL,
	  `UserID` char(36) NOT NULL COMMENT 'ID người dùng',
	  `ProductID` char(36) NOT NULL COMMENT 'ID sản phẩm',
	  `SizeID` varchar(20) NOT NULL COMMENT 'Id size',
	  `ColorID` varchar(20) NOT NULL COMMENT 'Id màu sắc',
	  `ProductName` varchar(100) NOT NULL COMMENT 'Tên sản phẩm',
	  `ProductImage` varchar(500) DEFAULT NULL COMMENT 'Đường dẫn ảnh',
	  `Price` decimal(19,2) DEFAULT NULL,
	  `Quantity` int(11) DEFAULT NULL COMMENT 'Số lượng sản phẩm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Giỏ hàng';

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
	  `CategoryID` int(11) NOT NULL COMMENT 'Danh mục ID',
	  `CategoryName` varchar(50) NOT NULL COMMENT 'Tên danh mục',
	  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả',
	  `Slug` varchar(50) DEFAULT NULL COMMENT 'SEO',
	  `IsShow` tinyint(1) DEFAULT '1',
	  `parentId` int(11) DEFAULT NULL
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Bảng danh mục sản phẩm';

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

CREATE TABLE `color` (
	  `ColorID` varchar(20) NOT NULL COMMENT 'Màu sắc ID',
	  `ColorName` varchar(50) NOT NULL COMMENT 'Tên màu sắc',
	  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả'
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

CREATE TABLE `gallery` (
	  `GalleryID` int(11) NOT NULL COMMENT 'ID ảnh trưng bày',
	  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
	  `Thumbnail` varchar(255) DEFAULT NULL COMMENT 'Hình ảnh nhỏ'
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Ảnh trưng bày nhỏ';

--
-- Dumping data for table `gallery`
--

INSERT INTO `gallery` (`GalleryID`, `ProductID`, `Thumbnail`) VALUES
(3, '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'image.png'),
(4, '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'image.png'),
(5, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221013-083202ao-training-F50-den-phoi-hong-2015-2016-VN-600x800.jpg'),
(6, '60e57f80-33cf-435a-a5fe-4e6affaad7a6', '20221013-083202ao-training-F50-den-phoi-hong-2015-2016-VN-600x800.jpg'),
(16, '64a59a25-2488-54b0-f6b4-c8af08a50c`Price`, `Promotion`, `OrderID`) VALUES
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

CREATE TABLE `orders` (
	  `OrderID` char(36) NOT NULL COMMENT 'Id hóa đơn',
	  `UserID` char(36) NOT NULL COMMENT 'Id người dùng',
	  `OrderstatusID` varchar(50) NOT NULL COMMENT 'Id trạng thái',
	  `PhoneShip` varchar(12) DEFAULT NULL COMMENT 'Số điện thoại',
	  `AddresShip` varchar(100) DEFAULT NULL COMMENT 'Địa chỉ',
	  `NameShip` varchar(255) DEFAULT NULL COMMENT 'Tên người ship',
	  `Note` varchar(255) DEFAULT NULL COMMENT 'Ghi chú thông tin cần thiết',
	  `CreateDate` datetime DEFAULT NULL COMMENT 'Ngày tạo',
	  `UpdateDate` datetime DEFAULT NULL COMMENT 'Ngày cập nhật'
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

CREATE TABLE `orderstatus` (
	  `OrderstatusID` varchar(50) NOT NULL COMMENT 'Key trạng thái',
	  `Name` varchar(50) DEFAULT NULL COMMENT 'Tên trạng thái',
	  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả'
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

CREATE TABLE `product` (
	  `ProductID` char(36) NOT NULL COMMENT 'ID sản phẩm',
	  `BrandID` int(11) NOT NULL COMMENT 'ID nhãn hiệu',
	  `ProductName` varchar(100) NOT NULL COMMENT 'Tên sản phẩm',
	  `Price` decimal(19,2) NOT NULL COMMENT 'Giá sản phẩm',
	  `Image` varchar(500) NOT NULL COMMENT 'Hình ảnh sản phẩm',
	  `Rate` double NOT NULL COMMENT 'Đánh giá sản phẩm',
	  `Slug` varchar(50) DEFAULT NULL COMMENT 'SEO',
	  `Description` varchar(255) DEFAULT NULL,
	  `CreatedDate` date DEFAULT NULL COMMENT 'Ngày tạo',
	  ` CreatedBy` varchar(50) DEFAULT NULL COMMENT 'Người tạo',
	  ` ModifiedDate` date DEFAULT NULL COMMENT 'Ngày chỉnh sửa',
	  `ModifiedBy` varchar(50) DEFAULT NULL COMMENT 'Người chỉnh sửa gần nhất',
	  `DeletedDate` date DEFAULT NULL COMMENT 'Ngày xóa gần nhất'
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Sản phẩm';

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `BrandID`, `ProductName`, `Price`, `Image`, `Rate`, `Slug`, `Description`, `CreatedDate`, ` CreatedBy`, ` ModifiedDate`, `ModifiedBy`, `DeletedDate`) VALUES
('4148606d-f5b6-4b89-9290-442c4b606db9', 4, 'Áo in hình doraemon', '100000.00', '20221013-082223z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 0, 'ao-in-hinh-doraemon', 'Áo thun in hình doraemon ', NULL, NULL, NULL, NULL, NULL),
('46b34359-bda9-484b-b9f2-32b6c03ba877', 4, 'Áo mỏng manh dễ rách', '200001.00', '20221017-210751z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 3.4, 'ao-mong-manh-de-rach', 'Thật sự không hiểu tại sao chiếc áo này được tạo ra nữa', NULL, NULL, NULL, NULL, NULL),
('60e57f80-33cf-435a-a5fe-4e6affaad7a6', 4, 'quần đá bóng', '1000.00', '20221101-124730ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 0, 'quan-da-bong', 'rfdfsf', NULL, NULL, NULL, NULL, NULL),
('64a59a25-2488-54b0-f6b4-c8af08a50cbf', 1, 'Áo thun nam mùa hè ', '618.80', '20221019-224035f5ffd3d1b2d9a0db1cffaaac2a7d8b9e.jpg', 3.5, 'aothunnammuahe-1-1', 'asdfsdf', NULL, NULL, NULL, NULL, NULL),
('674934cc-42cf-20cf-1d4a-aea48a10ed18', 2, 'Áo thun nữ mùa hè', '943.35', '20221019-224043ao-training-F50-den-phoi-hong-2015-2016-VN-600x800.jpg', 0, 'aothunnumuahe-1-1', 'asdfsdafasdf', NULL, NULL, NULL, NULL, NULL),
('7329c45c-2033-41a8-9365-21447cf28831', 4, 'Áo guci', '250000.00', '20221114-130649ao-training-F50-den-phoi-hong-2015-2016-VN-600x800.jpg', 0, 'ao-guci', 'áo đẹp hàng hiệu', NULL, NULL, NULL, NULL, NULL),
('77440a14-11da-4729-a4eb-43ce6c1a5c83', 9, 'Áo dầy cộm', '300000.00', '20221013-074658ao-polo-nam-lyle-and-scott-at60-1520256880-54.jpg', 0, 'ao-day-com-1', 'sdfjsd', NULL, NULL, NULL, NULL, NULL),
('c22edc73-1e37-4208-8637-46844daad0fa', 2, 'áo đi bơi', '1000.00', '20221019-222409z1028862000850_88526d597c8a4af07970acc8cdbe680e (1).jpg', 0, 'ao-di-boi', 'asdfasdf', NULL, NULL, NULL, NULL, NULL),
('ff204830-f606-4c8a-8706-7d251ad3c558', 8, 'Chiếu áo màu hường', '1243985.00', '20221013-07471932179fbdbac9c410e1a949acd46ab64d.jpeg', 0, 'chieu-ao-mau-huong-1', 'hiiihi', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `productdetails`
--

CREATE TABLE `productdetails` (
	  `ProductDetailsID` char(36) NOT NULL COMMENT 'ID thông tin chi tiết sản phẩm',
	  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
	  `ColorID` varchar(20) DEFAULT NULL COMMENT 'ID màu sắc',
	  `SizeID` varchar(20) DEFAULT NULL COMMENT 'ID size',
	  `Quantity` int(11) DEFAULT NULL COMMENT 'Số lượng sản phẩm'
) ENGINE=InnoDB AVG_ROW_LENGTH=8192 DEFAULT CHARSET=utf8mb4 COMMENT='Thông tin chi tiết sản phẩm';

--
-- Dumping data for table `productdetails`
--

INSERT INTO `productdetails` (`ProductDetailsID`, `ProductID`, `ColorID`, `SizeID`, `Quantity`) VALUES
('03abecc6-0f76-40d6-ae24-5900f530327a', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'XXL', 4),
('0d741f2f-ee05-406d-9b63-6b61f766f5cf', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'M', 5),
('0e0f2977-e4cb-4602-91f3-3228160044e8', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'XXL', 3),
('173477e0-d8d0-4c1d-897b-5c1cfb4d6ccc', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XXXL', 0),
('196d815a-4fc1-11ed-8139-0242ac140002', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'XXL', 4),
('1f92981f-c034-413e-a3d5-8295c448d216', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'XXL', 0),
('2c6e8ac1-a2be-4399-bd0d-c9ba65dd11bd', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Xanh001', 'M', 12),
('3ced912d-4a22-429c-8732-80616abb89a8', '7329c45c-2033-41a8-9365-21447cf28831', 'Do001', 'S', 0),
('3e6510d4-a611-4fd9-be9c-a3f5f354aa49', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'M', 0),
('444d831f-2fc0-444a-928a-e3ba77267877', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'M', 0),
('4ae0993e-bebd-4051-a14d-eeade78f226d', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Xanh001', 'XL', 3),
('4e5b7576-4fc1-11ed-8139-0242ac140002', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Vang001', 'S', 0),
('53e410a2-7af5-444f-b648-84d570f9de6e', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XXL', 0),
('5e6695e2-5aad-3241-6c1a-bb545470e80c', '64a59a25-2488-54b0-f6b4-c8af08a50cbf', 'Do001', 'XL', 61),
('60ed9de1-0249-44c0-ba42-75868324a6be', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Tim001', 'M', 0),
('65970e2d-f852-41b6-961a-e6d6e2fbe18a', '7329c45c-2033-41a8-9365-21447cf28831', 'Do001', 'L', 0),
('68bc7bca-e03b-4154-9c48-e53d8fac7171', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Tim001', 'S', 0),
('6d1b6674-60be-4ae6-b143-9ee3dadcc1d4', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'L', 1),
('72c5a2d7-0bfd-4afd-8648-c41c4cf295c9', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'M', 0),
('756c19a3-2b1b-4d23-94d7-2e95a76e3144', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Tim001', 'L', 3),
('76a103d1-20c1-48c1-b525-8b2c54840898', 'ff204830-f606-4c8a-8706-7d251ad3c558', 'Do001', 'M', 0),
('77d4d69c-c968-4422-add2-6ff0cbdf514e', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Do001', 'L', 4),
('78074279-ebec-4dce-8806-193e585d6ce8', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Tim001', 'M', 2),
('7e8083b6-4fc1-11ed-8139-0242ac140002', '674934cc-42cf-20cf-1d4a-aea48a10ed18', 'Tim001', 'M', 0),
('7ebe7f93-13b5-461a-ad71-04e4fbe28950', 'ff204830-f606-4c8a-8706-7d251ad3c558', 'Do001', 'S', 0),
('8a33585c-5390-4d96-920c-1788de6d2b91', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'S', 0),
('8e8b7391-37bb-4e7c-a0d7-f50b472af8c8', '7329c45c-2033-41a8-9365-21447cf28831', 'Tim001', 'L', 0),
('9354b0b3-e9cb-402f-8c86-9928bc40f62f', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'M', 0),
('a0da78c5-5d11-4677-af66-1eea4880f1e3', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XS', 3),
('a8df396f-bdf2-464c-9288-1b7dbbe87bc5', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'S', 0),
('a8e50c40-127b-4b6a-91d8-dfffb3200ca2', '60e57f80-33cf-435a-a5fe-4e6affaad7a6', 'Tim001', 'XL', 0),
('bc7c5812-d0c7-42ba-a286-6c649582cd0e', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh001', 'S', 0),
('bfa867e3-bc8f-47fb-a82c-50de0d511d75', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Vang001', 'L', 26),
('c1513936-cac2-4965-8797-90e599fb9829', '77440a14-11da-4729-a4eb-43ce6c1a5c83', 'Vang001', 'XL', 0),
('c420cd46-8a96-4aa6-b955-e67968cbd046', '7329c45c-2033-41a8-9365-21447cf28831', 'Tim001', 'S', 0),
('c858e5a5-c5e9-48d4-b748-26ca0c0b5edf', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Xanh002', 'L', 0),
('d0278479-f83e-4b73-b632-8d43e5f0508e', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'M', 0),
('db32da2e-9005-44d7-a5d0-04944a83b67e', '4148606d-f5b6-4b89-9290-442c4b606db9', 'Tim001', 'L', 3),
('ecaddd1a-204f-4924-b179-bf6cb9f7b288', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Do001', 'XXL', 0),
('f7fe536c-18e6-4a13-9cab-6386eed91a20', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Xanh002', 'S', 0),
('f888647c-7370-4797-95a4-3ac8a55b6f24', '46b34359-bda9-484b-b9f2-32b6c03ba877', 'Vang001', 'S', 0),
('fac6f520-6cd0-4dcf-8676-09e8cf34b5ce', 'c22edc73-1e37-4208-8637-46844daad0fa', 'Do001', 'M', 0);

-- --------------------------------------------------------

--
-- Table structure for table `productincategory`
--

CREATE TABLE `productincategory` (
	  `ProductID` char(36) DEFAULT NULL COMMENT 'ID sản phẩm',
	  `CategoryID` int(11) DEFAULT NULL COMMENT 'ID danh mục'
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
('7329c45c-2033-41a8-9365-21447cf28831', 17);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
	  `RoleID` varchar(20) NOT NULL,
	  `RoleName` varchar(50) NOT NULL COMMENT 'Tên quyền'
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

CREATE TABLE `size` (
	  `SizeID` varchar(20) NOT NULL COMMENT 'ID size',
	  `SizeName` varchar(50) NOT NULL COMMENT 'Tên size',
	  `Description` varchar(255) DEFAULT NULL COMMENT 'Mô tả'
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

CREATE TABLE `user` (
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
	  `RoleID` varchar(20) DEFAULT NULL COMMENT 'Id quyền truy cập'
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
-- Indexes for dumped tables
--

--
-- Indexes for table `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`BrandID`),
  ADD UNIQUE KEY `BrandName` (`BrandName`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`),
  ADD UNIQUE KEY `CategoryName` (`CategoryName`);

--
-- Indexes for table `color`
--
ALTER TABLE `color`
  ADD PRIMARY KEY (`ColorID`),
  ADD UNIQUE KEY `ColorName` (`ColorName`);

--
-- Indexes for table `gallery`
--
ALTER TABLE `gallery`
  ADD PRIMARY KEY (`GalleryID`),
  ADD KEY `FK_gallery_product_ProductID` (`ProductID`);

--
-- Indexes for table `orderdetail`
--
ALTER TABLE `orderdetail`
  ADD PRIMARY KEY (`OrderdetailID`),
  ADD KEY `FK_orderdetail_order_OrderID` (`OrderID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `FK_orders_orderstatus_` (`OrderstatusID`);

--
-- Indexes for table `orderstatus`
--
ALTER TABLE `orderstatus`
  ADD PRIMARY KEY (`OrderstatusID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ProductID`),
  ADD UNIQUE KEY `ProductName` (`ProductName`);

--
-- Indexes for table `productdetails`
--
ALTER TABLE `productdetails`
  ADD PRIMARY KEY (`ProductDetailsID`),
  ADD KEY `FK_productdetails_color_ColorID` (`ColorID`),
  ADD KEY `FK_productdetails_product_ProductID` (`ProductID`),
  ADD KEY `FK_productdetails_size_SizeID` (`SizeID`);

--
-- Indexes for table `productincategory`
--
ALTER TABLE `productincategory`
  ADD KEY `FK_productincategory_ category_CategoryID` (`CategoryID`),
  ADD KEY `FK_productincategory_Product_ProductID` (`ProductID`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`RoleID`),
  ADD UNIQUE KEY `role_name` (`RoleName`);

--
-- Indexes for table `size`
--
ALTER TABLE `size`
  ADD PRIMARY KEY (`SizeID`),
  ADD UNIQUE KEY `SizeName` (`SizeName`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `user_name` (`Username`),
  ADD KEY `FK_user_role_RoleID` (`RoleID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brand`
--
ALTER TABLE `brand`
  MODIFY `BrandID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID nhãn hiệu', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Danh mục ID', AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `gallery`
--
ALTER TABLE `gallery`
  MODIFY `GalleryID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID ảnh trưng bày', AUTO_INCREMENT=22;

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

