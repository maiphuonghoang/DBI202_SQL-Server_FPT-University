--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 24 - Database Design (Phần 10)

--	THIẾT KẾ ĐẦU TIÊN: GOM TẤT CẢ TRONG 1 TABLE
--	Đặc điểm chính là cột, value đđ chính là cell
--	Thông tin chích ngừa bao gồm: tên: An Nguyễn, cccd: 123456789..,

CREATE DATABASE DBDESIGN_VACCINATION
USE DBDESIGN_VACCINATION

--DROP TABLE VaccinationV1
CREATE TABLE VaccinationV1
(
	ID char(11) PRIMARY KEY,
	LastName nvarchar(30),
	FirstName nvarchar(30), --sort heng, FullName là sort họ đó 
	Phone varchar(11) NOT NULL UNIQUE,  -- CONSTRAINT, CẤM TRÙNG
										-- cấm trùng nhưng hok phải là PK
										-- key ứng viên, candidate key 
	InjectionInfo nvarchar(255)
)
--cách thiết kế này lưu trữ các mũi chích của mình đc ko? - ĐƯỢC 
SELECT * FROM VaccinationV1

INSERT INTO VaccinationV1 VALUES ('000000001', N'NGUYỄN', N'AN', '090x', 
								 	N'AZ Ngày 28.09.2021 ĐH FPT | AZ Ngày 28.10.2021 BV LÊ VĂN THỊNH, Q.TĐ')

-- PHÂN TÍCH:
-- ƯU	: DỄ LƯU TRỮ, SELECT, CÓ NGAY, đa tri tốt trong vụ này!!!
-- NHƯỢC: THỐNG KÊ ÉO ĐC, ÍT NHẤT ĐI CẮT CHUỖI, CĂNG!!! BỊ CĂNG DO ĐA TRỊ 

-- SOLUTION: CẦN QUAN THỐNG KÊ, TÍNH TOÁN SỐ LIỆU (? MŨI, AZ CÓ BAO NGƯỜI...)
-- TÁCH CỘT, TÁCH BẢNG 

CREATE TABLE VaccinationV2
(
	ID char(11) PRIMARY KEY,
	LastName nvarchar(30),
	FirstName nvarchar(30), 
	Phone varchar(11) NOT NULL UNIQUE,  
	
	--InjectionInfo nvarchar(255)
	Dose1 nvarchar(100), -- AZ, Astra, AstraZenneca... 25.9.2021, ĐH FPT - COMPOSSITE (phức hợp)
	Dose2 nvarchar(100)  -- AZ, AZ, ...
) -- //ĐA TRỊ TÁCH THÀNH CỘT 

--	PHÂN TÍCH:
--	*ƯU		: gọn gàng, select gọn gàng 
--	*NHƯỢC  : NULL!!!, Thêm mũi nhắc 3, 4 hàng năm thì sao 
--					   chỉ vì vài người, mà ta phải chừa chỗ null
--			  THỐNG KÊ!!! Cột composite chưa cho mình đc thống kê 

-- MULTI-VALUED CELL: MỘT CELL CHỨA NHIỀU INFO ĐỘC LẬP BÌNH ĐẲNG VỀ NGỮ NGHĨA
--					Ví dụ: Address: 1/1 LL, Q.1, TP.HCM; 1/1 Man Thiện, P.5, TP.TĐ
--										thường trú			tạm trú
--					GÓI COMBO, NHIỀU ĐỒ TRONG 1 CELL
--					ĐỌC: CÓ 2 ĐỊA CHỈ 
--					Đa trị chẻ mỗi miếng vẫn là thế 

-- COMPOSITE VALUE CELL: Một value duy nhất, mỗi value này gom nhiều miếng nhỏ hơn 
--						 nhiều miếng nhỏ hơn, mỗi miếng có 1 vai trò riêng 
--						 gom chung lại thành 1 thứ khác 
--						 Address: 1/1 Man Thiện, P.5, TP.HCM
--						 FullName: Hoàng Ngọc Trinh -> cả: tên gọi đầy đủ
--								   first midd last
--						 Composite chẻ mỗi miếng ngữ nghĩa khác hoàn toàn 

--			COMPOSITE GỘP N INFO VÀO TRONG 1 CELL, DỄ, NHANH LÀ ƯU ĐIỂM, NHẬP 1 CHUỖI DÀI LÀ XONG 
--						NHƯỢC ĐIỂM: ÉO THỐNG KÊ TỐT, ÉO SORT ĐC
--						FullName sort làm sao 
--			COMPOSITE SẼ TÁCH CỘT, VÌ MÌNH ĐÃ CỐ TRƯỚC ĐÓ GOM N THỨ KHÁC NHAU ĐỂ LÀM RA 1 THỨ KHÁC  
--							TÁCH CỘT SẼ TRẢ LẠI ĐÚNG NGỮ NGHĨA CHO TỪNG THẰNG 

-- VÌ SỐ LẦN CHÍCH CÒN CÓ THỂ GIA TĂNG CHO TỪNG NGƯỜI, MŨI 2, MŨI NHẮC, MŨI THƯỜNG NIÊN 
-- AI CHÍCH NHIỀU THÌ NHIỀU DÒNG, HAY HƠN HẲN 
CREATE TABLE PersonV3 
(
	ID char(11) PRIMARY KEY,
	LastName nvarchar(30),
	FirstName nvarchar(30), 
	Phone varchar(11) NOT NULL UNIQUE  
)
CREATE TABLE VaccinationV3
(
	Dose nvarchar(100), --COMPOSITE 
	PersonID char(11) REFERENCES PersonV3(ID)

)-- //ĐA TRỊ TÁCH THÀNH DÒNG 

-- PHÂN TÍCH:
-- ƯU	: CHÍCH THÊM NHÁT NÀO, THÊM DÒNG NHÁT ĐÓ, CHẤP 10 MŨI ĐỦ CHỖ LƯU, KO ẢNH HƯỞNG NGƯỜI CHƯA CHÍCH 
-- NHƯỢC: THỐNG KÊ ÉO ĐC
--	COMPOSITE PHẢI TÁCH TIẾP THÀNH CỘT CỘT CỘT CỘT, TRẢ LẠI ĐÚNG Ý NGHĨA CHO TỪNG 
--	MIẾNG INFO NHỎ 

CREATE TABLE PersonV4 
(
	ID char(11) PRIMARY KEY,
	LastName nvarchar(30),
	FirstName nvarchar(30), 
	Phone varchar(11) NOT NULL UNIQUE  
)
CREATE TABLE VaccinationV4
(
	--Dose nvarchar(100), --COMPOSITE -> tách cột hoy 
	Does int, --liều chích số 1
	InjDate datetime, --ngày giờ chích 
	Vaccine nvarchar(50), --tên vaccine 
	Lot nvarchar(20),
	Location nvarchar(50),

	PersonID char(11) REFERENCES PersonV4(ID)
)

INSERT INTO PersonV4 VALUES('00000000001', N'NGUYỄN', N'AN', NULL) --ko  vào bảng đc do unique 
INSERT INTO PersonV4 VALUES('00000000002', N'LÊ', N'BÌNH', '090x')

SELECT * FROM PersonV4 -- id02 vào 
SELECT * FROM VaccinationV4

INSERT INTO  VaccinationV4
	VALUES (1, GETDATE(), 'AZ', NULL, NULL, '00000000001') -- vi phạm FK do id01 chưa vào 

DELETE FROM PersonV4 WHERE ID = '00000000002'
INSERT INTO PersonV4 VALUES('00000000001', N'NGUYỄN', N'AN', '090x') 
INSERT INTO PersonV4 VALUES('00000000002', N'LÊ', N'BÌNH', '091x')
INSERT INTO  VaccinationV4
	VALUES (1, GETDATE(), 'AZ', NULL, NULL, '00000000001') --oki 
	

-- IN RA XANH VÀNG CHO MỖI NGƯỜI 
SELECT * FROM PersonV4 p INNER JOIN VaccinationV4 v
						 ON p.ID = v.PersonID       --1 người 
SELECT * FROM PersonV4 p LEFT JOIN VaccinationV4 v
						 ON p.ID = v.PersonID       -- 2 người 

SELECT p.ID, p.FirstName, COUNT(*) AS 'No Doses' FROM PersonV4 p LEFT JOIN VaccinationV4 v
							  ON p.ID = v.PersonID
							  GROUP BY p.ID, p.FirstName  -- (1,1) sai  bình có 1 dòng kha khá null do chưa chích 

SELECT p.ID, p.FirstName, COUNT(Does) AS 'No Doses' FROM PersonV4 p LEFT JOIN VaccinationV4 v
							  ON p.ID = v.PersonID
							  GROUP BY p.ID, p.FirstName  --(1,0)

-- CÚ ĂN TIỀN XANH ĐỎ 
SELECT p.ID, p.FirstName, IIF(COUNT(v.Does) = 0, 
												'NOOP', 
												 IIF(COUNT(v.Does) = 1, 'YELLOW', 'GREEN')  
							  )
						  AS STATUS 
FROM PersonV4 p LEFT JOIN VaccinationV4 v
							  ON p.ID = v.PersonID
							  GROUP BY p.ID, p.FirstName 
			--00000000001	AN	YELLOW
			--00000000002	BÌNH	NOOP

INSERT INTO  VaccinationV4
	VALUES (2, GETDATE(), 'AZ', NULL, NULL, '00000000001') 
			--00000000001	AN	GREEN
			--00000000002	BÌNH	NOOP



----------------------------------------------------------------------

CREATE TABLE VaccinationV1
(
	ID char(11) PRIMARY KEY, 
	LastName nvarchar(20),
	FirstName nvarchar(10), --sort heng, FullName là sort họ đó 
	Phone varchar(11) NOT NULL UNIQUE, --constraint UNIQUE-cấm trùng nhưng ko phải là key CANDIDATE  
	InjectionInfo nvarchar(255)
)

CREATE TABLE VaccinationV2
(
	ID char(11) PRIMARY KEY, 
	LastName nvarchar(20),
	FirstName nvarchar(10),
	Phone varchar(11) NOT NULL UNIQUE, 

	Dose1 nvarchar(100), --AZ, Astra, ...25.9.2021, ĐH FPT - COMPOSITE (phức hợp)
	Dose2 nvarchar(100)
)

CREATE TABLE PersonV3
(	ID char(11) PRIMARY KEY, 
	LastName nvarchar(20),
	FirstName nvarchar(10),
	Phone varchar(11) NOT NULL UNIQUE, 
)
CREATE TABLE VaccinationV3
(						--tên vaccine	ngày chích	địa điểm  -> liều chích 
	Dose nvarchar(100), --AZ, Astra, ...25.9.2021, ĐH FPT - COMPOSITE (phức hợp),gom n thứ thành 1 thứ 
	PersonID char(11) REFERENCES PersonV3(ID)
)

CREATE TABLE PersonV4
(	ID char(11) PRIMARY KEY, 
	LastName nvarchar(20),
	FirstName nvarchar(10),
	Phone varchar(11) NOT NULL UNIQUE, 
)
CREATE TABLE VaccinationV4
(	
	Dose int, --liều số 1
	InjDate date, --giờ chích 
	Vaccine nvarchar(50),--loại 
	Lot nvarchar(20),--số lô 
	[Location] nvarchar(50),--địa điểm 
	PersonID char(11) REFERENCES PersonV4(ID)
)
SELECT * FROM PersonV4 p INNER JOIN VaccinationV4 v ON p.ID = v.PersonID -- 1 người 
SELECT * FROM PersonV4 p LEFT JOIN VaccinationV4 v ON p.ID = v.PersonID --2 người 
--đếm số mũi tiêm của mỗi người 
SELECT p.ID, p.FirstName, COUNT(*) FROM PersonV4 p LEFT JOIN VaccinationV4 v ON p.ID = v.PersonID GROUP BY P.FirstName, P.ID --sai 1&1
SELECT p.ID, p.FirstName, COUNT(Does) FROM PersonV4 p LEFT JOIN VaccinationV4 v ON p.ID = v.PersonID GROUP BY P.FirstName, P.ID --0&1

SELECT p.ID, p.FirstName, IIF(COUNT(v.Does) = 0, 'NOOP', IIF(COUNT(v.Does) = 1, 'YELLOW', 'GREEN')) AS STATUS
FROM PersonV4 p LEFT JOIN VaccinationV4 v ON p.ID = v.PersonID GROUP BY P.FirstName, P.ID 




