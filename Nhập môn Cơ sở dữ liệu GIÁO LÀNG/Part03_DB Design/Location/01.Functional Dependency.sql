--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 26 - Database Design (Phần 12)

CREATE DATABASE DBDESIGN_VNLOCATIONS
USE DBDESIGN_VNLOCATIONS

--Thiết kế csdl lưu đc thông tin phường/xã, quận/huyện, tình/tpho 
--chính là 1 phần địa chỉ được tách ra cho nhu cầu thống kê 
--nó là 1 phần của Composite field 
--|SEQ|Dose|InjDate|Vacinne (FK LK)|Lot|Địa chỉ chích - compo|
--|SEQ|Dose|InjDate|Vacinne (FK LK)|Lot|Số nhà|Phường-Quận-Tỉnh|

--XÉT RIÊNG PHƯỜNG-QUẬN-TỈNH RÕ RÀNG 3 CỘT LOOK UP 
CREATE TABLE Locations 
(
	province nvarchar(30),
	district nvarchar(30),
	ward nvarchar(30) 
)
SELECT * FROM Locations

--	File text có dấu tab \t được gọi tên là file csv, hàm ý nghĩa hàng cột dữ luêij 
--		từ file này vào Excel 30s
--		SQL Server cho phép copy&paste CSV trực tiếp vào trong table!!! thay vì dùng lệnh insert into 
--		Database -> Table -> table -> Insert 200 row -> mũi tên -> CTRL V 

--PHÂN TÍCH TABLE 
--1. TRÙNG LẶP CỤM INFO TỈNH-QUẬN
--2. LOOK UP TRÊN PROVINCE, DISTRICT (WARD)
--3. SỰ PHỤ THUỘC LOGIC GIỮA TỈNH VÀ DISTRICT (WARD)
--	 FUNCTIONAL DEPENDENCY - FD - PHỤ THUỘC HÀM 
--	 CÓ 1 CÁI ÁNH XẠ, MỐI QUAN HỆ GIỮA A VÀ B, PROVINCE VS. DISTRICT 
--		CỨ CHỌN TP.HCM -> Q1, Q2, Q3,...
--		Y = F(X) = X^2, CỨ CHỌN F(2) -> 4 
--	 TÁCH LOOK UP VÌ DỄ NHẤT 
--	 RA 1 TABLE, PHẦN TABLE CÒN LẠI THÌ FK SANG LOOKUP 
--				 Vaccination(liều chích, tên vaccine) 
--										FK sang Vaccine(tên-vaccine)  

--CHỈ LOOK UP 63 TỈNH, KO CHO CHỌN LỘN XỘN 

CREATE TABLE Province  
(
	PName nvarchar(30)
)
SELECT * FROM Province 
SELECT * FROM Locations -- 10581 dòng ứng với 10581 xã/phường khác nhau 
						-- nhưng chỉ có 63 tỉnh thành lặp lại 
SELECT province FROM Locations -- 10581 
SELECT DISTINCT province FROM Locations -- 63, giống cục thống kê 
--dùng nó để insert sang table lookup 

	--CÁCH INSERT THỨ 1
INSERT INTO Province VALUES (N'Thành phố Cần Thơ')
INSERT INTO Province VALUES (N'Tỉnh Vĩnh Long')
DELETE FROM Province --xóa hết bảng thêm bằng cách cũ
	--CÁCH INSERT THỨ 2
INSERT INTO Province VALUES (N'Thành phố Cần Thơ'), (N'Tỉnh Vĩnh Long')
	--TUYỆT CHIÊU INSERT THỨ 3
	--COPY PASTE ĐÃ HỌC CHO 10K DÒNG 

	--TUYỆT CHIÊU INSERT THỨ 4 
--INSERT INTO Province VALUES CÓ 63 TỈNH THÀNH LÀ NGON - TA XÀI KIỂU SUB-QUERY TRONG CÂU LỆNH INSERT 
INSERT INTO Province SELECT DISTINCT province FROM Locations

SELECT COUNT(*) FROM Locations -- 10581 
SELECT COUNT(province) FROM Locations -- 10581 
SELECT COUNT(DISTINCT province) FROM Locations -- 63 


--TẠO TABLE LOOK UP QUẬN/HUYỆN 
CREATE TABLE District 
(
	DName nvarchar(30)
)

--có bao nhiêu quận ở VN 
SELECT district FROM Locations -- 10581 quận đc lặp lại ứng với 10581 phường khác nhau 
SELECT DISTINCT district FROM Locations -- 683 dòng, 683 quận khác nhau 
--RẤT CẨN THẬN KHI CHƠI VỚI QUẬN/HUYỆN 
--TIỀN GIANG, VĨNH LONG, TRÀ VINH, ĐỀU CÓ HUYỆN 'CHÂU THÀNH'
--BẢNG DISTRICT CHỈ CÓ 1 CHÂU THÀNH, LÁT HỒI!!! -GIỜ TẠM THỜI BỎ QUA CÂU CHUYỆN NÀY 
--PK của District ko thể là TÊN QUẬN/HUYỆN ĐC!

--CHÈN VÀO TABLE QUẬN 
INSERT INTO District SELECT DISTINCT district FROM Locations
SELECT * FROM District

--------------------------------------------------------------------------------------
--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 27 - Database Design (Phần 13)

--	FK/LOOK UP CHỈ GIẢI QUYẾT CÂU CHUYỆN NHẬP ĐÚNG VALUE CHƯA 
--	CHỨ KO GIẢI QUYẾT GIỮA TỈNH VS. HUYỆN CÓ PHỤ THUỘC LẪN NHAU 
--  NẾU GIỮA CÁC CỘT CÓ PHỤ THUỘC LẪN NHAU -> ĐEM CỘT TO RA CHỖ KHÁC ĐỂ PHÁ VỠ SỰ PHỤ THUỘC 

--PROVINCE và DISTRICT CÓ SỰ PHỤ THUỘC LẪN NHAU, TỪ THẰNG NÀY SUY ĐC RA THẰNG KIA 
--NHÌN QUẬN CÓ THỂ ĐOÁN TP (CHIỀU NÀY KO CHẮC AN TOÀN)
--							nhìn Châu Thành, sao đoán đc tỉnh? Sóc Trăng, Trà Vinh, Vĩnh Long  
--NHÌN TP ĐOÁN RA QUẬN (HỢP LÍ VỀ SUY LUẬN)
--							Vĩnh Long -> Mang Thít, Vũng Liêm, Châu Thành 
--							Sóc Trăng -> ...				   Châu Thành 
-- FD Functional Dependency NÊN ĐỌC LÀ PROVINCE -> DISTRICT 
-- Chẩn 1 đa trị, chuẩn 2 composite key, chuẩn 3 phụ thuộc bắc cầu 
-- TABLE CHỨA CÁC FD KIỂU PHỤ THUỘC NGANG GIỮA CÁC CỘT -> SUY NGHĨ TÁCH BẢNG 
-- TÁCH THẲNG VẾ TRÁI & PHẢI, RA TABLE KHÁC! TÁCH XONG THÌ PHẢI FK CHO PHẦN CÒN LẠI 

--SAU KHI TÁCH TA CÓ TRONG TAY 3 TABLE 
--PROVINCE (PName)

--		DISTRICT (DName, PName (FK lên trên))

--			WARD (WName phường nào, quận nào DName FK lên Quận)

--GIẢI PHÁP "DỞ" CHO HUYỆN CHÂU THÀNH CỦA 3 TỈNH MIỀN TÂY!!! 
--HIỆN TẠI DÙNG NATURAL KEY, KEY TỰ NHIÊN - DÙNG TÊN CỦA TỈNH, HUYỆN LÀM KEY 
--GIẢI PHÁP TỐT HƠN: 
--DÙNG KEY TỰ GÁN, TỰ TĂNG, KEY THAY THẾ, KEY GIẢ (SURRPGATE KEY/ARTIFICIAL KEY)

--PHIÊN BẢN ĐẸP NHƯNG VẪN CÒN CHÚT CHÂU THÀNH 
DROP TABLE Province
DROP TABLE District

CREATE TABLE Province 
(
	PName nvarchar(30) PRIMARY KEY 
)
INSERT INTO Province SELECT DISTINCT province FROM Locations
SELECT * FROM Province

CREATE TABLE District  
(
	DName nvarchar(30) PRIMARY KEY, --HOK CÓ 2 CHÂU THÀNH CỦA 3 TỈNH MIỀN TÂY 
	--Quận nào vậy

	--và thuộc về tỉnh/thành phố nào vậy 
	PName nvarchar(30) REFERENCES Province(PName)
						--THAM CHIẾU ĐỂ KO NHẬP TỈNH KO TỒN TẠI, TỈNH AHIHI 
						--CÒN CHUYỆN NHẬP ĐÚNG HUYỆN NÀY CỦA TỈNH KIA HAY KO THÌ THUỘC VỀ NGƯỜI NHẬP LIỆU 
)
INSERT INTO District SELECT DISTINCT district FROM Locations
SELECT * FROM District
SELECT district, province FROM Locations --10581, bị cắt cột P.X 
SELECT DISTINCT district, province FROM Locations ORDER BY district --699 # 683 
/*
Huyện Cát Tiên	Tỉnh Lâm Đồng
Huyện Cầu Kè	Tỉnh Trà Vinh
Huyện Cầu Ngang	Tỉnh Trà Vinh
Huyện Châu Đức	Tỉnh Bà Rịa - Vũng Tàu
Huyện Châu Phú	Tỉnh An Giang
Huyện Châu Thành	Tỉnh An Giang
Huyện Châu Thành	Tỉnh Bến Tre
Huyện Châu Thành	Tỉnh Đồng Tháp
Huyện Châu Thành	Tỉnh Hậu Giang
Huyện Châu Thành	Tỉnh Kiên Giang
Huyện Châu Thành	Tỉnh Long An
Huyện Châu Thành	Tỉnh Sóc Trăng
Huyện Châu Thành	Tỉnh Tây Ninh
Huyện Châu Thành	Tỉnh Tiền Giang
Huyện Châu Thành	Tỉnh Trà Vinh
Huyện Châu Thành A	Tỉnh Hậu Giang
Huyện Chi Lăng	Tỉnh Lạng Sơn
*/
--Trong trường hợp này rõ ràng ko thể insert bảng này vào district vì DName là PK 
--Để cho Huyện Châu Thành Tỉnh An Giang # Huyện Châu Thành Tỉnh Bến Tre -> Composite Key, key gồm 2 cột 

--=======================================
DROP TABLE District
DROP TABLE Province
CREATE TABLE Province 
(
	PName nvarchar(30) PRIMARY KEY 
)
INSERT INTO Province SELECT DISTINCT province FROM Locations
SELECT * FROM Province

CREATE TABLE District  
(
	DName nvarchar(30) NOT NULL,
	--Quận nào vậy
	--và thuộc về tỉnh/thành phố nào vậy 
	PName nvarchar(30) NOT NULL REFERENCES Province(PName)
	PRIMARY KEY (DName, PName) 		
)
INSERT INTO District SELECT DISTINCT district, province FROM Locations
--699 quận, có rất nhiều Châu Thành của 6 tỉnh miền Tây
SELECT * FROM District

--hỏi thử: TP HCM có những quận nào 
SELECT DName FROM District WHERE PName = N'Thành phố Hồ Chí Minh'
SELECT DName FROM District WHERE PName = N'Tỉnh Long An'

--THÀNH PHẦN ĐÔNG DATA NHẤT LÀ WARD/PHƯỜNG, CÓ 10581 DÒNG 
--ỨNG VỚI VÔ SỐ LẶP LẠI CÁC QUẬN, FK
--xã có trùng tên hem???
CREATE TABLE Ward 
(
	WName nvarchar(30),
	--xã phường ơi, bạn ở quận nào?
	DName nvarchar(30) --REFERENCES District(DName), tạm thời bỏ chỗ tham chiếu này vì nó chỉ cho tham chiếu đến 1 cột 
)
--xã phường liệu rằng có trùng hay ko 
SELECT * FROM Locations --10581
SELECT COUNT(DISTINCT ward) FROM Locations --7884, TRÙNG TÊN 3000 TÊN 
SELECT ward FROM Locations ORDER BY ward

INSERT INTO Ward SELECT ward, district FROM Locations --10581
SELECT * FROM Ward

--cho tui xem các phường của Q1 TP.HCM 
SELECT * FROM Ward WHERE DName = N'Quận 1' --<nhớ có N để hiểu tviet>

--******Huyện Châu Thành của tỉnh Tiền giang có những xã nào -- 23 xã 
SELECT * FROM District d, Ward w WHERE w.DName = d.DName AND d.PName = N'Tỉnh Tiền Giang' AND d.DName = N'Huyện Châu Thành'
SELECT * FROM District d INNER JOIN Ward w ON w.DName = d.DName WHERE d.PName = N'Tỉnh Tiền Giang' AND d.DName = N'Huyện Châu Thành'--139
SELECT * FROM District d INNER JOIN Ward w ON w.DName = d.DName WHERE d.PName = N'Tỉnh Sóc Trăng' AND d.DName = N'Huyện Châu Thành' --139 
	-- ko phải do FK, FK chỉ để tham chiếu nhập đúng k
	-- đây là do k biết huyện châu thành nào của tỉnh nào 

--giải pháp này chỉ đúng cho những huyện trùng tên 
SELECT w.*, d.PName FROM District d INNER JOIN Ward w ON w.DName = d.DName WHERE d.PName = N'Tỉnh Bến Tre' AND d.DName = N'Huyện Ba Tri' --23

