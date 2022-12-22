--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 23 - Database Design (Phần 9)

 

CREATE TABLE PersonV5_1
(	Nick nvarchar(30), 
	Title nvarchar(30),
	Company nvarchar(40)
)
CREATE TABLE PhoneBookV5_1_
(
	Phone char(11), 
	PhoneType nvarchar(20), -- CHO GÕ TRỰC TIẾP LOẠI PHONE, GÂY NÊN LỘN XỘN LOẠI PHONE CELL, DD, MOBILE
							-- THỐNG KÊ KHÓ KHĂN, OR, VÀ CÒN TIẾP TỤC SỬA OR NỮA DO CHO GÕ TỰ DO
							-- HẠN CHẾ KO CHO GÕ LỘN XỘN =, TỨC LÀ PHẢI GÕ/CHỌN THEO AI ĐÓ CÓ TRƯỚC, FK 
	Nick nvarchar(30)		-- éo cần fk, chỉ cần join vẫn okie 
)
/*CREATE TABLE PhoneBookV5_1_
(
	Phone char(11), 
	--PhoneType nvarchar(20), 
	Nick nvarchar(30)		
)*/
CREATE TABLE PhoneBookV5_1
(
	Phone char(11), 
	--PhoneType nvarchar(20), 
	TypeName nvarchar(20) REFERENCES PhoneTypeV5_1(TypeName),
	Nick nvarchar(30)	
	
)-- TABLE MỚI XUẤT HIỆN, LƯU LOẠI PHONE, KO CHO GÕ LUNG TUNG ~~~~ TABLE PROVINCE, CITY, COUNTRY, SEMESTER  

CREATE TABLE PhoneTypeV5_1
(
	TypeName nvarchar(20) --cần thêm cái này là khóa chính nè, vì bảng này bị tham chiếu bởi PhoneBookV5_1
)
SELECT * FROM PhoneTypeV5_1

-- ko mún xóa table mà vẫn thêm khóa chính  
ALTER TABLE PhoneTypeV5_1 
	  ADD CONSTRAINT PK_PhoneTypeV5_1 PRIMARY KEY (TypeName)
ALTER TABLE PhoneTypeV5_1 
	  ADD PRIMARY KEY (TypeName)
	--<Cannot define PRIMARY KEY constraint on nullable column in table 'PhoneTypeV5_1'.>
	--do TypeName nvarchar(20) k ghi gì cả thì mặc định là NULL, null làm sao làm key được 
ALTER TABLE PhoneTypeV5_1 ALTER COLUMN TypeName nvarchar(20) NOT NULL 
			--câu này chạy trước câu khóa chính 

INSERT INTO PhoneTypeV5_1 VALUES (N'Di động')
INSERT INTO PhoneTypeV5_1 VALUES (N'Nhà/Để bàn')
INSERT INTO PhoneTypeV5_1 VALUES (N'Công ty')

SELECT * FROM PersonV5_1
SELECT * FROM PhoneBookV5_1

INSERT INTO PersonV5_1 VALUES (N'hoangnt', 'Lecturer', 'FPTU HCMC')
INSERT INTO PersonV5_1 VALUES (N'annguyen', 'Student', 'FPTU HCMC')
INSERT INTO PersonV5_1 VALUES (N'binhle', 'Student', 'FPTU HLL')

-- dữ liệu của /* */, thêm đc do chưa gán FK 
INSERT INTO PhoneBookV5_1 VALUES ('098x', 'Cell', N'hoangnt')
 
INSERT INTO PhoneBookV5_1 VALUES ('090x', 'CELL', N'annguyen')
INSERT INTO PhoneBookV5_1 VALUES ('091x', 'Home', N'annguyen')

INSERT INTO PhoneBookV5_1 VALUES ('090x', 'Work', N'binhle')
INSERT INTO PhoneBookV5_1 VALUES ('091x', 'cell', N'binhle')
INSERT INTO PhoneBookV5_1 VALUES ('092x', 'cell', N'binhle')
-- dữ liệu của /* */

SELECT * FROM PhoneTypeV5_1
SELECT * FROM PersonV5_1
SELECT * FROM PhoneBookV5_1
INSERT INTO PhoneBookV5_1 VALUES ('098x', 'Cell', N'hoangnt') -- chửi, vi phạm FK 
INSERT INTO PhoneBookV5_1 VALUES ('098x', N'Di động', N'hoangnt') -- ok 

INSERT INTO PhoneTypeV5_1 VALUES ('Cha dượng ngọt ngào') --quên chưa có unicode 
DELETE FROM PhoneTypeV5_1 WHERE TypeName = 'Cha du?ng ng?t ngào'--xóa đi để làm lại 
INSERT INTO PhoneTypeV5_1 VALUES (N'Cha dượng ngọt ngào')--ổn 

INSERT INTO PhoneBookV5_1 VALUES ('098x', N'Sugar Daddy', N'binhle') --chửi
INSERT INTO PhoneBookV5_1 VALUES ('098x', N'cha dượng ngọt ngào', N'binhle')

-- ===============================================

CREATE TABLE PersonV5
(	Nick nvarchar(30) PRIMARY KEY, -- CÒN CẦN BÀN THÊM VỀ PK HERE/ĐỂ ĐẠT PERFORMANCE 
	Title nvarchar(30),
	Company nvarchar(40)
)
CREATE TABLE PhoneTypeV5
(
	TypeName nvarchar(20) NOT NULL, -- CÒN CẦN BÀN THÊM VỀ PK HERE/ĐỂ ĐẠT PERFORMANCE 
	PRIMARY KEY (TypeName),
)
CREATE TABLE PhoneBookV5
(
	Phone char(11) NOT NULL,		-- số điện thoại là số mấy 
	
	TypeName nvarchar(20) REFERENCES PhoneTypeV5(TypeName),  -- nó thuộc loại mẹ gì 
	
	Nick nvarchar(30) REFERENCES PersonV5 (Nick),		-- của thằng ku nào
	-- loại gì & của ai, ko gõ lung tung 

	CONSTRAINT PK_PhoneBookV5 PRIMARY KEY (Phone)
)


CREATE TABLE Person
(
	Nick nvarchar(20) PRIMARY KEY,
	Title nvarchar(20),
	Company nvarchar(20)
)
CREATE TABLE PhoneType
(
	TypeName nvarchar(20) NOT NULL,
	PRIMARY KEY (TypeName)
)
CREATE TABLE PhoneBook
(
	Nick nvarchar(20) REFERENCES Person(Nick),
	TypeName nvarchar(20) REFERENCES PhoneType(TypeName),
	phoneNumber nvarchar(20) PRIMARY KEY 
)




