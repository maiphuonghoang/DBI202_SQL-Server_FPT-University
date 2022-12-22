--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 16 - Database Design (Phần 2)

CREATE DATABASE DBDESIGN_ONETABLE 
/*	CREATE DÙNG ĐỂ TẠO CẤU TRÚC LƯU TRỮ/DÀN KHUNG/THÙNG CHỨA DÙNG LƯU TRỮ DATA/INFO
	TƯƠNG ĐƯƠNG VIỆC XÂY PHÒNG CHỨA ĐỒ - DATABASE 
				MUA TỦ ĐỂ TRONG PHÒNG  - TABLE 
	1 DB CHỨA NHIỀU TABLE - 1 PHÒNG CÓ NHIỀU TỦ 
							1 NHÀ CÓ NHIỀU PHÒNG 
	TẠO RA CẤU TRÚC LƯU TRỮ - CHƯA NÓI DATA BỎ VÀO - DDL (PHÂN NHÁNH CỦA SQL) 
*/

USE DBDESIGN_ONETABLE

--	Tạo table lưu trữ hồ sơ sv: mã số (phân biệt các sv với nhau), tên, dob, địa chỉ...
--	1 SV ~~~ 1 OBJECT ~~~ 1 ENTITY 
--	1 TABLE DÙNG LƯU TRỮ NHIỀU ENTITY 
CREATE TABLE StudentV1
(			--V1 chưa gài CONSTRAINT 
	StudentID char(8),
	LastName nvarchar(40), --tại sao ko gộp fullname cho rồi???
	FirstName nvarchar(10),  --n: lưu kí tự Unicode tiếng Việt 
	DOB datetime,
	[Address] nvarchar(50)
)
--DROP TABLE StudentV1

--	SQL Server | Oracle (Oracle/Java) - muốn k có đối thủ thì mua lại luôn đối thủ | 
--	DB (IBM) | MySQL | PostgeSQL | SQLite | MS Access (Office) 
--xem câu lệnh dùng techonthenet 

-- CHAR: ít/không thay đổi về kích thước 
-- CHAR(50) tên có 8 nhưng nó vẫn cấp trong database 50 kí tự
--			về mặt dung lượng trên đĩa cứng, lưu trữ to lên
--			vì k xài hết vẫn cấp - fixed kích thước 
--	VARCHAR(50)	khai báo tối đa 50 nhưng xài bao nhiêu cấp bấy nhiêu 
--			tiết kiệm hơn về mặt lưu trữ
--			nhưng xử lí sẽ lâu hơn do nó phải căn ke 
--			khoảng độ trên đĩa cứng để nó tìm đc chiều dài kích thước 

-- THAO TÁC TRÊN DATA/MÓN ĐỒ TRONG TỦ/TRONG TABLE - DML/DQL (dành riêng cho SELECT) 
SELECT * FROM StudentV1

--	ĐƯA DATA VÀO TABLE/MUA ĐỒ QUẦN ÁO BỎ VÀO TỦ 
INSERT INTO StudentV1 VALUES ('SE123456', N'Nguyễn', N'An', '2003-1-1', N'TP.Hồ Chí Minh') -- ĐƯA HẾT VÀO CÁC CỘT, SV FULL KO CHE THÔNG TIN 

--	MỘT SỐ CỘT CHƯA THÈM NHẬP INFO, ĐƯỢC QUYỀN BỎ TRỐNG NẾU CỘT CHO PHÉP TRỐNG VALUE
--	DEFAULT KHI ĐÓNG CÁI TỦ/MUA TỦ/ THIẾT KẾ TỦ, MẶC ĐỊNH NULL
INSERT INTO StudentV1 VALUES ('SE123457', N'Bình', N'Lê', '2003-2-1', NULL) 
--	TÊN THÀNH PHỐ LÀ NULL, WHERE = 'NULL' OKIE VÌ NÓ LÀ DATA
--	NULL Ở CÂU TRÊN WHERE ADRESS IS NULL 
INSERT INTO StudentV1 VALUES ('SE123458', N'Cường', N'Võ', '2003-2-1', N'NULL') 

-- TUI CHỈ MÚN LƯU VÀI INFO, KO ĐỦ SỐ CỘT, MIỄM CỘT CÒN LẠI CHO PHÉP BỎ TRỐNG 
INSERT INTO StudentV1 (StudentID, LastName, FirstName)
					  VALUES ('SE123459', N'Trần', N'Dũng')
INSERT INTO StudentV1 (FirstName, LastName, StudentID) --đảo thứ tự các cột cũng ok 
					  VALUES (N'Phạm', N'Em','SE123460')
INSERT INTO StudentV1 (FirstName, LastName, StudentID) 
					  VALUES (NULL, NULL, NULL) -- SIÊU NGUY HIỂM, SV TOÀN INFO BỎ TRỐNG 
												-- GÀI CÁCH ĐƯA DATA VÀO CÁC CỘT SAO CHO HỢP LÍ 
												-- CONSTRAINT TRÊN DATA/CELL/COLUMN 

-- CÚ NGUY HIỂM NÀY CÒN LỚN HƠN!!!!!!!!!!!!!!!!! 
INSERT INTO StudentV1 (FirstName, LastName, StudentID) 
					  VALUES (N'Đỗ', N'Giang','SE123460')
-- TRÙNG MÃ SỐ KO CHẤP NHẬN ĐƯỢC, KO XĐ ĐC 1 SV -- GÀI RÀNG BUỘC DỮ LIỆU QUAN TRỌNG NÀY 
--												   CỘT MÀ VALUE CẤM TRÙNG TRÊN MỌI CELL CÙNG CỘT
--												   DÙNG LÀM CHÌA KHÓA/KEY ĐỂ TÌM RA/MỞ RA/XĐ 
--												   DUY NHẤT 1 INFO, DÒNG, 1 SV, 1 ENTITY, 1 OBJECT 
--												   CỘT NÀY ĐC GỌI LÀ PRIMARY KEY 

SELECT * FROM StudentV1 WHERE StudentID = 'se123460'




-- GÀI CÁCH ĐƯA DATA VÀO TABLE ĐỂ KO CÓ NHỮNG HIỆN TƯỢNG BẤT THƯỜNG, 1 DÒNG TRỐNG TRƠN, KEY TRÙNG
-- KEY NULL - DEFAULT THIẾT KẾ CHO PHÉP NULL TẤT CẢ 
-- GÀI - CONSTRAINTS 
CREATE TABLE StudentV2
(	
	StudentID char(8) PRIMARY KEY, -- bao hàm luôn NOT NULL - bắt buộc đưa data + cấm trùng 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,-- NOT NULL ~~ (* đỏ) registration/sign-up 
	DOB datetime,
	[Address] nvarchar(50)
)

SELECT * FROM StudentV2

INSERT INTO StudentV2 VALUES ('SE123456', N'Nguyễn', N'An', '2003-1-1', N'TP.Hồ Chí Minh') 

-- thử coi, qua mặt đc ko
INSERT INTO StudentV2 (StudentID, FirstName, LastName) 
					  VALUES (NULL, NULL, NULL)       --gẫy
					  
INSERT INTO StudentV2 (StudentID, FirstName, LastName) 
					  VALUES ('AHIHI', NULL, NULL)	--gẫy

-- coi có đc trùng mã số sv hay ko?  -- gẫy luôn 
INSERT INTO StudentV2 VALUES ('SE123456', N'Nguyễn', N'An', '2003-1-1', N'TP.Hồ Chí Minh') 
-- thử tiếp PK 
INSERT INTO StudentV2 VALUES ('GD123456', N'Nguyễn', N'An', '2003-1-1', N'TP.Hồ Chí Minh') 

INSERT INTO StudentV2 VALUES ('SE123457', N'Lê', N'Bình', '2003-2-1', NULL) --okie 

INSERT INTO StudentV2 VALUES ('SE123458', N'Võ', N'Cường')
			-- ko insert hết số cột thì phải liệt kê tên cột 
			-- mơ hồ, k biết insert vào đâu 
INSERT INTO StudentV2 VALUES ('SE123458', N'Võ', N'Cường', null, null) --okie

INSERT INTO StudentV2 (StudentID, LastName, FirstName)
					  VALUES ('SE123459', N'Trần', N'Dũng')

INSERT INTO StudentV2  
					  VALUES (NULL, NULL, NULL, NULL, NULL) -- GẪY 3 CHỖ NULL 


CREATE TABLE StudentV3
(	
	StudentID char(8) PRIMARY KEY, ---- thừa từ NOT NULL, do primary key bao hàm luôn NOT NULL
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime NULL ,
	[Address] nvarchar(50) NULL -- thừa từ NULL, do default là vậy 
)




CREATE TABLE StudentV4
(	
	StudentID char(8), 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50),
	PRIMARY KEY(StudentID)
)
INSERT INTO StudentV4 (StudentID, LastName, FirstName)
					  VALUES (NULL, N'Trần', N'Dũng') --gẫy cứ có primary key dù bất cứ chỗ nào cũng là not null 



-- # Tools: POWER DESIGNER VS. VISUAL PARADIGM
-- Visual Paradigm Enterprise
-- GENERATE TỪ ERD - Entity Relational Diagram TRONG TOOL THIẾT KẾ 
CREATE TABLE StudentV5
(	
	StudentID char(8) NOT NULL, 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50),
	PRIMARY KEY(StudentID)
)


--------------------------------------------------------------------------------------------------
--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 17 - Database Design (Phần 3)
/*
	HỌC THÊM VỀ CÁI CONSTRAINTS - TRONG ĐÓ PK CONSTRAINT 
	Ràng buộc là cách ta/db designer ép cell/cột nào đó value phải ntn 
	Đặt ra quy tắc/rule cho việc nhập data 
	Vì có nhiều quy tắc, nên tránh nhầm lẫn, dễ kiểm soát ta sẽ có quyền 
	đặt tên cho các quy tắc, constraint name 
	Ví dụ: Má ở nhà đặt quy tắc/nội quy cho mình 
	Rule #1: Vào SG học thật tốt nha con. Tốt: điểm tb >= 8.0 && ko rớt môn nào 
			 && 9 học kì ra trường && ko đổi chuyên ngành 
	Rule #2: Tối đi chơi về nhà sớm. Sớm: trong tối cùng ngày, trước 10h khuya 
	Rule #3: ???
	TÊN RÀNG BUỘC/QUY TẮC						NỘI DUNG/CÁI DATA ĐC GÀI VÀO
		PK_?????									PRIMARY KEY (ko trùng)
		VD:[PK__StudentV__32C52A7998411091]
	Mặc định các DB Engine nó tự đặt tên cho các RB nó thấy khi bạn gõ lệnh DDL 
	DB En cho mình cơ chế tự đặt tên RB 
*/
CREATE TABLE StudentV6
(	
	StudentID char(8), 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50),
	-- PRIMARY KEY(StudentID) -- tự db engine đặt tên cho rb 
	CONSTRAINT PK_STUDENTV6 PRIMARY KEY(StudentID) -- mình tự đặt tên rb 
												   -- khi có từ CONSTRAINT bắt buộc phải có tên rb 
)

--	DÂN PRO ĐÔI KHI CÒN LÀM CÁCH SAU. NGƯỜI TA TÁCH HẲN VIỆC TẠO RB KHÓA CHÍNH, KHÓA NGOẠI 
--	RA HẲN CẤU TRÚC TABLE, TỨC LÀ CREATE TABLE CHỈ CHỨA TÊN CẤU TRÚC - CỘT - DOMAIN
--	TẠO TABLE XONG RỒI CHỈNH SỬA TABLE - SỬA CÁI TỦ CHỨ KO PHẢI DATA TRONG TỦ 
CREATE TABLE StudentV7
(	
	StudentID char(8) NOT NULL, 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50),
	-- PRIMARY KEY(StudentID) 
	-- CONSTRAINT PK_STUDENTV6 PRIMARY KEY(StudentID)
)
ALTER TABLE StudentV7 ADD CONSTRAINT PK_STUDENTV7 PRIMARY KEY(StudentID)

--	XÓA 1 RÀNG BUỘC ĐC KO, ĐC, CHO ADD THÌ CHO DROP 
ALTER TABLE StudentV7 DROP CONSTRAINT PK_STUDENTV7  

ALTER TABLE StudentV2 DROP CONSTRAINT PK__StudentV__32C52A7998411091







------------------------------------------------------------------------
-- # học lại 
CREATE TABLE StudentV1
(			--V1 chưa gài CONSTRAINT hệ quả: dữ liệu bị trùng, k thể phân biệt entity  
	StudentID char(8),
	LastName nvarchar(40), 
	FirstName nvarchar(10),  --các thuộc tính ko ghi gì cả 
	DOB datetime,			 --mặc định giá trị của chúng có thể NULL 
	[Address] nvarchar(50)	 --các cột được cho phép bỏ trống 
)
INSERT INTO StudentV1 VALUES('SE1', N'Nguyễn', N'An', '2003', N'HCM') -- đưa đầy đủ thông tin 
--một số cột chưa thèm nhập info, được quyền bỏ trống nếu cột cho phép trống value 
--DEFAULT KHI ĐÓNG CÁI TỦ/MUA TỦ/THIẾT KẾ TỦ, MẶC ĐỊNH NULL
INSERT INTO StudentV1 VALUES ('SE2', 'Lê', N'Bình', '2003', NULL)
INSERT INTO StudentV1 VALUES ('SE3', N'Võ', N'Cường', '2003', N'NULL')
		-- Tên thành phố là Null, WHERE = 'NULL' OKIE VÌ NÓ LÀ DATA
		-- NULL Ở CÂU TRÊN PHẢI WHERE ADDRESS IS NULL 
--lưu vài info, ko đủ số cột, miễn cột còn lại cho phép bỏ trống 
INSERT INTO StudentV1(StudentID, LastName, FirstName) VALUES ('SE4', N'Trần', N'Dũng')
INSERT INTO StudentV1(LastName, FirstName, StudentID) VALUES (N'Trần', N'Dũng', 'SE5') --đổi thứ tự nhập đc nè 

/* STUDENTV1 
SE123456	Nguyễn	An		2003-01-01 00:00:00.000	TP.Hồ Chí Minh
SE123457	Bình	Lê		2003-02-01 00:00:00.000	NULL
SE123458	Cường	Võ		2003-02-01 00:00:00.000	NULL
SE123459	Trần	Dũng	NULL					NULL
SE123460	Em		Phạm	NULL					NULL
NULL		NULL	NULL	NULL					NULL
SE123460	Giang	Đỗ		NULL					NULL				//TRÙNG MÃ SỐ KHÔNG CHẤP NHẬN ĐC, ID là cột value cấm trùng trên mọi cell 
*/
CREATE TABLE StudentV2
(   --C1 PK 
	StudentID char(8) PRIMARY KEY, --PK bao hàm luôn NOT NULL - bắt buộc đưa data, cấm trùng 
	LastName nvarchar(10) NOT NULL,
	FirstName nvarchar(10) NOT NULL, 
	DOB datetime,
	Address nvarchar(50)
)
SELECT * FROM StudentV2
INSERT INTO StudentV2 (StudentID, FirstName, LastName) VALUES (NULL, NULL, NULL) 
					--gẫy do mình đã gài NOT NULL vào 3 biến này 
INSERT INTO StudentV2 (StudentID, FirstName, LastName) VALUES ('AHIHI', NULL, NULL) 
					--gẫy do mình đã gài NOT NULL vào 2 biến name
INSERT INTO StudentV2 VALUES ('SE123456', N'Nguyễn', N'An', '2003-1-1', N'TP.Hồ Chí Minh') 
					--gẫy do trùng id
INSERT INTO StudentV2 VALUES ('SE123458', N'Võ', N'Cường')
					--gẫy do bối rối vì không biết thêm vào cột nào 

CREATE TABLE StudentV4
(
	StudentID char(8) NOT NULL, 
	LastName nvarchar(10) NOT NULL,
	FirstName nvarchar(10) NOT NULL, 
	DOB datetime,
	Address nvarchar(50),
	PRIMARY KEY(StudentID) --C2 PK 
		--TỰ DB ENGINE ĐẶT TÊN CHO RÀNG BUỘC 
)
CREATE TABLE StudentV6
(
	StudentID char(8), 
	LastName nvarchar(10) NOT NULL,
	FirstName nvarchar(10) NOT NULL, 
	DOB datetime,
	Address nvarchar(50),
	CONSTRAINT PK_STUDENTV6 PRIMARY KEY(StudentID)
		--MÌNH TỰ ĐẶT TÊN CHO RÀNG BUỘC 
)
CREATE TABLE StudentV7
(
	StudentID char(8), 
	LastName nvarchar(10) NOT NULL,
	FirstName nvarchar(10) NOT NULL, 
	DOB datetime,
	Address nvarchar(50),

	--tách hẳn việc tạo RB khóa chính, khóa ngoại ra hẳn cấu trúc table, 
	--tức là create table chỉ chứa tên cấu trúc - cột -domain
	--cách này gọi là tạo table xong rồi chỉnh sửa table 
	--				- sửa cái tủ/ngăn đồ trong tủ chứ ko phải data trong tủ 
	--PHẢI DÙNG LỆNH ALTER ĐỂ CHỈNH SỬA CẤU TRÚC 
)
ALTER TABLE StudentV7 ADD CONSTRAINT PK_STUDENTV7 PRIMARY KEY (StudentID) -- THÊM RÀNG BUỘC BÊN NGOÀI 
ALTER TABLE StudentV7 DROP CONSTRAINT PK_STUDENTV7 --XÓA RÀNG BUỘC MÌNH ĐẶT, CHO ADD THÌ CHO DROP 
ALTER TABLE StudentV2 DROP CONSTRAINT PK__StudentV__32C52A7998411091 --XÓA RB DB ĐẶT, LẤY ĐC CÁI TÊN DB ĐẶT TRONG KEY LÀ OK  

