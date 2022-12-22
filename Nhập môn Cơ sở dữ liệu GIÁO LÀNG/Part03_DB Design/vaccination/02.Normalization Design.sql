--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 25 - Database Design (Phần 11)

--	*PHÂN TÍCH
--	Cột Vaccine cho phép gõ các giá trị tên VC một cách tự do -> inconsistency 
--	AZ, Astra, AstraZeneca, Astra Zeneca
--	>>>>> có mùi của dropdown, mùi của combo box >>>>> Lookup table 
--	ko cho gõ mà cho chọn từ danh sách có sẵn...
--	tham chiếu từ danh sách có sẵn 
--	Vaccine phải tách thành table CHA, TABLE 1, ĐÁM CON ĐÁM N PHẢI REFERENCE VỀ 

USE DBDESIGN_VACCINATION

CREATE TABLE PersonV5 
(
	ID char(11) PRIMARY KEY,
	LastName nvarchar(30),
	FirstName nvarchar(30), 
	Phone varchar(11) NOT NULL UNIQUE  
)

CREATE TABLE VaccineV5
(
	VaccineName varchar(30) PRIMARY KEY 
	-- còn hãng sx, địa chỉ hãng, thông tin về lâm sàng...
)
-- PRIMARY KEY MÀ LÀ VARCHAR() LÀM GIẢM HIỆU NĂNG VỀ THỰC THI QUERY
-- CHẠY CHẬM, THƯỜNG NGƯỜI TA SẼ CHỌN PK LÀ CON SỐ LÀ TỐT NHẤT, TỐT NHÌ CHAR 
-- tìm data trên đĩa cứng nhanh hơn 
-- SẼ GIẢNG RIÊNG 1 BUỔI VỀ PRIMARY KEY (PK, FK, CK, SPK, NK, SRK-AK)

INSERT INTO VaccineV5 VALUES ('AstraZeneca')
INSERT INTO VaccineV5 VALUES ('Pfizer')
INSERT INTO VaccineV5 VALUES ('Verocell')
INSERT INTO VaccineV5 VALUES ('Moderna')

CREATE TABLE VaccinationV5
(
	SEQ int IDENTITY PRIMARY KEY, -- CỨ TĂNG MÃI MÃI ĐI, 2 TỶ 1 MẤY LẦN CHÍCH 
	Does int, --liều chích số 1, 2 có thể lặp lại cho mỗi người, ko thể là PK
	InjDate datetime, --ngày giờ chích 
	Vaccine varchar(30) REFERENCES VaccineV5(VaccineName), 
	--tên vaccine KO CHO GÕ TỰ DO,  PHẢI THAM CHIẾU 
	Lot nvarchar(20),
	Location nvarchar(50), -- nơi chích bản chất là COMPOSITE, nếu có nhu cầu thống kê thì tách thành CỘT CITY, QUẬN/HUYỆN
						   -- LẠI LÀ LOOKUP NẾU MUỐN, ĐỂ KO GÕ LUNG TUNG, THỐNG KÊ TIỆN TỪNG ĐƠN VỊ 
	PersonID char(11) REFERENCES PersonV4(ID)
	
	-- FOREIGN KEY (Vaccine) REFERENCES VaccineV5(VaccineName)
	-- CONSTRAINT FK_VCN_VC FOREIGN KEY (Vaccine) REFERENCES VaccineV5(VaccineName)
)


--	CHỐT HẠ: TÁCH ĐA TRỊ HAY COMPOSITE DỰA TRÊN NHU CẦU 
--			 THỐNG KÊ NẾU CÓ CỦA DỮ LIỆU TA LƯU TRỮ!!!
--			 GOM BẢNG -> TÌM ĐA TRỊ TÌM COMPOSITE, TÌM LOOKUP TÁCH THEO 
--						 NHU CẦU!!!

SELECT * FROM PersonV5
SELECT * FROM VaccinationV5
SELECT * FROM VaccineV5

INSERT INTO PersonV5 VALUES('00000000001', N'NGUYỄN', N'AN', '090x') 
INSERT INTO PersonV5 VALUES('00000000002', N'LÊ', N'BÌNH', '091x')
INSERT INTO PersonV5 VALUES('00000000003', N'CƯỜNG', N'VÕ', '092x')


INSERT INTO  VaccinationV5
	VALUES (1, GETDATE(), 'AstraZeneca', NULL, NULL, '00000000001') --SEQ1
INSERT INTO  VaccinationV5
	VALUES (2, '2021-12-20', 'AstraZeneca', NULL, NULL, '00000000001')--SEQ2

INSERT INTO  VaccinationV5
	VALUES (3, '2021-12-20', 'AZ', NULL, NULL, '00000000001') -- thất bại, ko có loại vaccinre gõ tay AZ
													--SEQ tăng mẹ nó thành số 3 

INSERT INTO  VaccinationV5
	VALUES (1, '2021-12-20', 'Verocell', NULL, NULL, '00000000002')	--SEQ4, số 3 bị lủng
	

-- THỐNG KÊ ĐC NHỮNG GÌ 
-- 1. Có bao nhiêu mũi vaccine AZ đã đc chích (chích bao nhát, ko care người chích)
--	Output: loại vaccine, tổng số mũi đã chích 
SELECT Vaccine, COUNT(*) FROM VaccinationV5 WHERE Vaccine = 'AstraZeneca' GROUP BY Vaccine

-- 2. Ngày x có bn mũi đã đc chích 
--	Output: ngày, tổng số mũi chích 
SELECT InjDate, COUNT(*) FROM VaccinationV5 WHERE YEAR(InjDate) = 2021 AND MONTH(InjDate) = 12 GROUP BY InjDate

-- 3. Thống kê số mũi chích của mỗi cá nhân 
--	Output: CCCD, Tên (full), di động, số mũi đã chích (0,1,2,3)
SELECT p.ID, COUNT(v.Vaccine) FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID GROUP BY p.ID 

-- 4. In ra thông tin chích của mỗi cá nhân 
--	Output: CCCD, Tên (full), di động, số mũi đã chích (0,1,2,3), MÀU SẮC 
SELECT p.ID, p.FirstName + ' ' + p.LastName AS FullName, p.Phone, COUNT(v.Vaccine) AS [No Does] , 
IIF (COUNT(v.Vaccine) = 0, 'NOOP', IIF(COUNT(v.Vaccine) = 1, 'RED', IIF(COUNT(v.Vaccine) = 2, 'YELLOW', 'GREEN'))) AS STATUS
FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID GROUP BY p.ID, p.FirstName, p.Phone, p.LastName

	--	   ID		FullName	Phone	No Does		STATUS 
	--00000000001	AN NGUYỄN	090x		2		YELLOW
	--00000000002	BÌNH LÊ		091x		1		RED
	--00000000003	VÕ CƯỜNG	092x		0		NOOP
 
-- 5. Có bn công dân đã chích ít nhất 1 mũi vaccine 
SELECT p.ID, COUNT(v.Vaccine) AS [No Does] FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID GROUP BY p.ID 
HAVING COUNT(v.Vaccine) >=1

-- 6. Những công dân nào chưa chích mũi nào?
--	Output: CCCD, Tên
SELECT p.ID, p.FirstName + ' ' + p.LastName AS FullName, COUNT(v.Vaccine) AS [No Does] 
FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID GROUP BY p.ID, p.FirstName, p.LastName
HAVING COUNT(v.Vaccine) = 0

-- 7. Công dân có CCCD X đã chích những mũi nào 
--	Output: CCCD, Tên, thông tin chích (in gộp + chuỗi, tái nhập composite) 
SELECT p.ID, p.FirstName + ' ' + p.LastName AS FullName, 
CAST(v.Does AS VARCHAR(1)) + ' | ' + CONVERT(VARCHAR(20), v.InjDate) + ' | ' + v.Vaccine + ' ' + ' | '  AS [Injection Info] 
FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID 
	--	ID			FullName		Injection Info
	--00000000001	AN NGUYỄN	1 | Aug 26 2022  2:15PM | AstraZeneca  | 
	--00000000001	AN NGUYỄN	2 | Dec 20 2021 12:00AM | AstraZeneca  | 
	--00000000002	BÌNH LÊ		1 | Dec 20 2021 12:00AM | Verocell  | 
	--00000000003	VÕ CƯỜNG	NULL

SELECT p.ID, p.FirstName + ' ' + p.LastName AS FullName, 
CAST(v.Does AS VARCHAR(1)) + ' | ' + CONVERT(VARCHAR(20), v.InjDate) + ' | ' + v.Vaccine  + ' | ' + v.Location AS [Injection Info] 
FROM PersonV5 p LEFT JOIN VaccinationV5 v ON p.ID = v.PersonID		
	--KO ĐC + NULL VÀO ĐÂY <NOT NULL + NULL = NULL)
	--	ID			FullName		Injection Info
	--00000000001	AN NGUYỄN		NULL
	--00000000001	AN NGUYỄN		NULL
	--00000000002	BÌNH LÊ			NULL
	--00000000003	VÕ CƯỜNG		NULL

-- 8. Thống kê số mũi vaccine đã chích của mỗi loại vaccine 
SELECT  * FROM VaccinationV5 vc RIGHT JOIN VaccineV5 v ON vc.Vaccine = v.VaccineName
	--SEQ	Does		InjDate				Vaccine		Lot	   Location	PersonID	VaccineName 
	--1		1		2022-08-26 14:15:28.330	AstraZeneca	NULL	NULL	00000000001	AstraZeneca
	--2		2		2021-12-20 00:00:00.000	AstraZeneca	NULL	NULL	00000000001	AstraZeneca
	--NULL	NULL	NULL					NULL		NULL	NULL	NULL		Moderna
	--NULL	NULL	NULL					NULL		NULL	NULL	NULL		Pfizer
	--4		1		2021-12-20 00:00:00.000	Verocell	NULL	NULL	00000000002	Verocell

SELECT  v.VaccineName, COUNT(vc.Vaccine) AS Number FROM VaccinationV5 vc RIGHT JOIN VaccineV5 v --COUNT(NULL) LÀ TOANG 
					ON vc.Vaccine = v.VaccineName
					GROUP BY v.VaccineName
					-- WHERE DATE CHÍCH LÀ THỐNG KÊ THEO NGÀY 
					-- QUẬN HUYỆN NỮA LÀ THỐNG KÊ NGÀY, QUẬN 
	--VaccineName	Number 
	--AstraZeneca	  2
	--Moderna		  0
	--Pfizer		  0
	--Verocell		  1


/*
	PersonV5 --< VaccinationV5 >-- VaccineV5
	MQH N-N: 1 NGƯỜI CHÍCH NHIỀU VACCINE, 1 VACCINE CÓ NHIỀU NGƯỜI CHÍCH 
	MQH N-N ĐƯỢC TÁCH THÀNH BẢNG TRUNG GIAN, KÉO KEY 2 THẰNG LÀM KHÓA NGOẠI 
*/