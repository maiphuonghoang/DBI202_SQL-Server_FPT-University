--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 22 - Database Design (Phần 8)

 CREATE DATABASE DBDESIGN_PHONEBOOK
 USE DBDESIGN_PHONEBOOK

CREATE TABLE PhoneBookV3_1
 (
	Nick nvarchar(30),
	Phone char(11), -- chỉ 1 số phone hoy 
 )
 -- MỞ RỘNG TABLE THEO CHIỀU DỌC, AI CÓ NHIỀU SIM THÌ THÊM DÒNG

SELECT * FROM PhoneBookV3_1
INSERT INTO PhoneBookV3_1 VALUES (N'hoangnt', '098x')

INSERT INTO PhoneBookV3_1 VALUES (N'annguyen', '090x')
INSERT INTO PhoneBookV3_1 VALUES (N'annguyen', '091x')

INSERT INTO PhoneBookV3_1 VALUES (N'binhle', '090x')
INSERT INTO PhoneBookV3_1 VALUES (N'binhle', '091x')
INSERT INTO PhoneBookV3_1 VALUES (N'binhle', '092x')

--*****	PHÂN TÍCH
--	>>>>> ƯU ĐIỂM: SELECT PHONE LÀ RA ĐC TẤT CẢ CÁC SỐ luôn
--> Thống kê số lượng số điện thoại mỗi người xài, mấy sim???
SELECT Nick, COUNT(*) AS [No Phones] FROM PhoneBookV3_1 
						GROUP BY Nick
--> ko bị null, muốn thêm bao nhiêu phone thì thêm 

--> TRIẾT LÍ THIẾT KẾ: CỐ GẮNG GIỮ NGUYÊN CÁI TỦ, CHỈ THÊM ĐỒ,
--						   KO THÊM CỘT CỦA TABLE, CHỈ CẦN THÊM DÒNG NẾU CÓ BIẾN ĐỘNG SỐ LƯỢNG 

/*	>>>>> NHƯỢC ĐIỂM 
--	1.SQL. Cho tui biết các số di động của mọi người 
--  2.Cho tui biết số để bàn, ở nhà của anh binhle???
	--> Ko biết số phone X nào đó thuộc loại nào?!

	Vi phạm PK, redundancy, hoangnt lặp lại nhiều lần làm gì khi mới lưu 
	nick thôi, còn fullname, title, tên cty, email,...
*/
--	TRÁNH BỊ REDUNDANCY, PK -> TÁCH BẢNG, PHẦN LẶP LẠI RA 1 CHỖ KHÁC 

----------------------------------------------------------------------------
--	TA CẦN GIẢI QUYẾT PHONE NÀY THUỘC LOẠI NÀO 

CREATE TABLE PhoneBookV3_2
 (
	Nick nvarchar(30),
	Phone char(11), -- chỉ 1 số phone hoy, CẦN GIẢI NGHĨA THÊM SỐ NÀY LÀ SỐ GÌ 
	PhoneType nvarchar(20) -- 090x Home, 091x Work 
 )

SELECT * FROM PhoneBookV3_2
INSERT INTO PhoneBookV3_2 VALUES (N'hoangnt', '098x', 'Cell')

INSERT INTO PhoneBookV3_2 VALUES (N'annguyen', '090x', 'CELL')
INSERT INTO PhoneBookV3_2 VALUES (N'annguyen', '091x', 'Home')

INSERT INTO PhoneBookV3_2 VALUES (N'binhle', '090x', 'Work')
INSERT INTO PhoneBookV3_2 VALUES (N'binhle', '091x', 'cell')
INSERT INTO PhoneBookV3_2 VALUES (N'binhle', '092x', 'cell')

--	PHÂN TÍCH
--	*ƯU ĐIỂM
--	Count ngon, group by theo nick, theo loại phone 
--  where theo loại phone ngon
SELECT * FROM PhoneBookV3_2 WHERE PhoneType = 'Cell'

--	*NHƯỢC ĐIỂM
--	Redundancy trên info của nick/full/cty/email/năm sinh 

-- MỘT KHI BỊ TRÙNG LẶP INFO, LẶP LẠI INFO, REDUNDANCY, CHỈ CÓ 1 SOLUTION 
-- KO CHO TRÙNG, TỨC LÀ XH 1 LẦN, TỨC LÀ RA BẢNG KHÁC -> DECOMPOSITION PHÂN RÃ 


