--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 18 - Database Design (Phần 4)
--								CONSTRAINT GÀI TRÊN CẤU TRÚC TABLE 
-- KHÓA NGOẠI LÀ KHÓA CHÍNH ĐI XUẤT NGOẠI RA TABLE KHÁC
-- KHÓA NGOẠI KHÁC KHÓA CHÍNH Ở CHỖ
--		NÓ LÀ KHÓA CHÍNH Ở TABLE KHÁC 
--		ĐƯỢC PHÉP TRÙNG 
-- FOREIGN KEY DÀNH CHO VIỆC JOIN SAU NÀY 
--							 THAM CHIẾU TÍNH NHẤT QUÁN CỦA DỮ LIỆU 

CREATE DATABASE DBDESIGN_ONEMANY

USE DBDESIGN_ONEMANY 

--	XÉT VỀ MQH 1N THÌ 1 PHẢI XUẤT HIỆN TRƯỚC, NHIỀU XUẤT HIỆN SAU 
--					  phải có chuyên ngành thì mới có students 
--	TABLE 1 TẠO TRƯỚC, TABLE N TẠO SAU  

CREATE TABLE MajorV1
(
	MajorID char(2) PRIMARY KEY,  -- mặc định dbe tự tạo tên rb
	MajorName nvarchar(40) NOT NULL 
	--,...
)
-- CHÈN DATA - MUA QUẦN ÁO BỎ VÔ TỦ 
INSERT INTO MajorV1 VALUES ('SE', N'Kĩ thuật phần mềm')
INSERT INTO MajorV1 VALUES ('IA', N'An toàn thông tin')

CREATE TABLE StudentV1
(	
	StudentID char(8), 
	CONSTRAINT PK_STUDENTV1 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime NULL,
	[Address] nvarchar(50) NULL, -- ko cần null cx đc vì mặc định nó là null rồi 

	MID char(2)  -- tên cột khóa ngoại/tham chiếu ko cần trùng bên 1-Key 
				 --	NHƯNG BẮT BUỘC TRÙNG 100% KIỂU DỮ LIỆU, 
				 -- QUAN TRỌNG LÀ CẦN THAM CHIẾU DATA HOY 					
)
--DROP TABLE StudentV1

INSERT INTO StudentV1 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE')

--	THIẾT KẾ TRÊN SAI vì...KO CÓ THAM CHIẾU GIỮA MajorID của /Student VS. Major phía trên  
INSERT INTO StudentV1 VALUES ('SE2', N'Lê', N'Bình', NULL, NULL, 'AH')

SELECT * FROM StudentV1
SELECT * FROM MajorV1

CREATE TABLE MajorV2
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
CREATE TABLE StudentV2
(	
	StudentID char(8), 
	CONSTRAINT PK_STUDENTV2 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 

	-- MajorID char(2)	REFERENCES MajorV2(MajorID)  --câu tắt 
	-- tớ chọn chuyên ngành ở trên kia kìa, xin tham chiếu trên kia 
	MajorID char(2) FOREIGN KEY	REFERENCES MajorV2(MajorID) --full 
) --nếu chạy table N này trước mà k chạy table 1 trước CHỬI vì k có cái mà tham chiếu  
  --	Foreign key 'FK__StudentV2__Major__4BAC3F29' references invalid table 'MajorV2'.
  --	MajorID char(2)	REFERENCES MajorV2(MajorID) đây là 1 rb nên nó đẻ ra RB THAM CHIẾU tên FK__StudentV2__Major__4BAC3F29

INSERT INTO MajorV2 VALUES ('SE', N'Kĩ thuật phần mềm')
INSERT INTO MajorV2 VALUES ('IA', N'An toàn thông tin')

INSERT INTO StudentV2 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE')
INSERT INTO StudentV2 VALUES ('SE2', N'Lê', N'Bình', NULL, NULL, 'AH')

SELECT * FROM StudentV2

DROP TABLE StudentV2 -- xóa đc 
DROP TABLE MajorV2 --<Could not drop object 'MajorV2' because it is referenced by a FOREIGN KEY constraint.>
				   -- k đc xóa vì nó đc tham chiếu từ thằng khác 

--	KO ĐC XÓA TABLE 1 NẾU NÓ ĐANG ĐC THAM CHIẾU BỞI THẰNG KHÁC 
--	NẾU CÓ MỐI QUAN HỆ 1-N, XÓA N TRƯỚC RỒI XÓA 1 SAU 

---------------------------------------------------------------------
--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 19 - Database Design (Phần 5)

--	THÊM KỸ THUẬT VIẾT FK, Y CHANG CÁCH VIẾT CỦA PK
CREATE TABLE MajorV3
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
CREATE TABLE StudentV3
(	
	StudentID char(8) PRIMARY KEY, 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 
	
	-- MajorID char(2) FOREIGN KEY REFERENCES MajorV3(MajorID)
	MajorID char(2),
	CONSTRAINT FK_StudentV3_MajorV3 FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID)
)

-- TA CÓ QUYỀN GỠ 1 RÀNG BUỘC ĐÃ THIẾT LẬP !!!
-- sửa ngăn tủ, sủa cấu trúc chứ k phải data 
ALTER TABLE StudentV3 DROP CONSTRAINT FK_StudentV3_MajorV3
-- BỔ SUNG LẠI 1 RÀNG BUỘC KHÁC 
ALTER TABLE StudentV3 ADD CONSTRAINT FK_StudentV3_MajorV3 
			FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID)

SELECT * FROM MajorV3  -- RỖNG
SELECT * FROM StudentV3-- RỖNG

-- LÚC NÀY INSERT LÀ CHẾT, DO THAM CHIẾU 
INSERT INTO StudentV3 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE')
--		<The INSERT statement conflicted with the FOREIGN KEY constraint "FK_StudentV3_MajorV3".>

INSERT INTO MajorV3 VALUES ('SE', N'Kĩ thuật phần mềm')
INSERT INTO StudentV3 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE') --chạy 
INSERT INTO StudentV3 VALUES ('SE2', N'Nguyễn', N'An', NULL, NULL, 'GD') --chửi 

INSERT INTO MajorV3 VALUES ('AH', N'Ahihi đồ ngok')
INSERT INTO StudentV3 VALUES ('AH1', N'Lê', N'Vui Vẻ', NULL, NULL, 'AH')

--	Nếu bề trên thay đổi (table 1) thì con dân sẽ thế nào (table N) ???

--	THAO TÁC MẠNH TAY TRÊN DATA/MÓN ĐỒ QUẦN ÁO TRONG TỦ - DML (UPDATE & DELETE)
DELETE FROM StudentV3 -- CỰC KÌ NGUY HIỂM KHI THIẾU WHERE, XÓA HẾT DATA!!!
DELETE FROM StudentV3 WHERE StudentID = 'ah1'

SELECT * FROM MajorV3  -- SE, AH
SELECT * FROM StudentV3 -- 1 SE, O AH 

-- Nếu lúc này xóa AH ở Major thì có sao ko?
DELETE FROM MajorV3 WHERE MajorID = 'AH' -- xóa đc vì k có thằng nào tham chiếu đến 
SELECT * FROM MajorV3  -- SE
SELECT * FROM StudentV3 -- 1 SE

INSERT INTO MajorV3 VALUES ('AH', N'Ahihi đồ ngok')
INSERT INTO StudentV3 VALUES ('AH1', N'Lê', N'Vui Vẻ', NULL, NULL, 'AH')
DELETE FROM MajorV3 WHERE MajorID = 'AH' -- ko xóa đc vì có tham chiếu 
										 -- nhưng khi muốn xóa cái trên mà cái tham chiếu cũng mất thì...

--  GÀI THÊM HÀNH XỬ KHI XÓA, SỬA DATA Ở RÀNG BUỘC KHÓA NGOẠI/DÍNH KHÓA CHÍNH LUÔN
--	HIỆU ỨNG DOMINO, SỤP ĐỔ DÂY CHUYỀN, 1 XÓA, N ĐI SẠCH >>>>> CASCADE DELETE 
--										1 SỬA, N BỊ SỬA THEO >>>>> CASCADR UPDATE 

--	NGAY LÚC DESIGN TABLE/CREATE TABLE ĐÃ PHẢI TÍNH VỤ NÀY RỒI 
--	VẪN CÓ THỂ SỬA SAU NÀY KHI CÓ DATA, CÓ THỂ CÓ TROUBLE 

ALTER TABLE StudentV3 DROP CONSTRAINT FK_StudentV3_MajorV3 
	-- XÓA RB KHÓA NGOẠI BỊ THIẾU VIỆC GÀI THÊM RULE NHỎ LIÊN QUAN XÓA SỬA DATA 
ALTER TABLE StudentV3 ADD CONSTRAINT FK_StudentV3_MajorV3 
					  FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID) --//No Action 
					  ON DELETE CASCADE 
					  ON UPDATE CASCADE 

--	UPDATE DML, MẠNH MẼ, SỬA DATA ĐANG CÓ 
UPDATE MajorV3 SET MajorID = 'AK' -- CẨN THẬN NẾU KO CÓ WHERE, TOÀN BỘ TABLE BỊ ẢNH HƯỞNG 
								  -- TRỪ UPDATE CỘT KEY do rb khóa chính 
UPDATE MajorV3 SET MajorID = 'AK' WHERE MajorID = 'AH'

-- SỤP ĐỔ, XÓA 1, N ĐI SẠCH SẼ
-- XÓA CHUYÊN NGÀNH AHIHI, XEM SAO??? CÒN SV NÀO HOK 
DELETE FROM MajorV3 WHERE MajorID = 'AK' -- sv ah1 lên đường luôn 

--	CÒN 2 CÁI GÀI NỮA LIÊN QUAN ĐẾN TÍNH ĐỒNG BỘ NHẤT QUÁN DATA/CONSISTENCY 
--	SET NULL VÀ DEFAULT
--	KHI 1 XÓA, N VỀ NULL
--	KHI 1 XÓA, N VỀ DEFAULT (1 giá trị đặt trước) 

-- cột MajorID của Student phải cho phép null <MajorID char(2)>,

-- ******** CHỐT HẠ
-- XÓA BÊN 1 TỨC LÀ MẤT BÊN 1, KO LẼ SỤP ĐỔ CẢ ĐÁM BÊN N, KO HAY, NÊN CHỌN ĐƯA BÊN N VỀ NULL
-- UPDATE BÊN 1, BÊN 1 VẪN CÒN GIỮ DÒNG/ROW, BÊN N NÊN ĐỒNG BỘ THEO, ĂN THEOM CASCADE 
ALTER TABLE StudentV3 DROP CONSTRAINT FK_StudentV3_MajorV3 
	
ALTER TABLE StudentV3 ADD CONSTRAINT FK_StudentV3_MajorV3 
					  FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID) --//No Action 
					  ON DELETE SET NULL -- XÓA CHO MỒ CÔI, BƠ VƠ, NULL, TỪ TỪ TÍNH 
					  ON UPDATE CASCADE  -- SỬA BỊ ẢNH HƯỞNG DÂY CHUYỀN
SELECT * FROM MajorV3  
SELECT * FROM StudentV3
UPDATE MajorV3 SET MajorID = 'AK' WHERE MajorID = 'AH'
DELETE FROM MajorV3 WHERE MajorID = 'AK' -- về null đó 

-- Cho sv bơ vơ chuyên ngành về học SE
UPDATE StudentV3 SET MajorID = 'SE' -- TOÀN TRƯỜNG HỌC SE ẤY, TOANG 
UPDATE StudentV3 SET MajorID = 'SE' WHERE StudentID = 'AH1' --đúng 
UPDATE StudentV3 SET MajorID = 'SE' WHERE MajorID IS NULL 


--DROP TABLE StudentV3_1
CREATE TABLE StudentV3_1
(	
	StudentID char(8) PRIMARY KEY, 
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 
	
	MajorID char(2) DEFAULT 'SE',
	CONSTRAINT FK_StudentV3_1_MajorV3 
			   FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID)
			   ON DELETE SET DEFAULT
			   ON UPDATE CASCADE 
)
-- ALTER TABLE StudentV3_1 ADD CONSTRAINT...  GIỐNG Ở V3 

INSERT INTO StudentV3_1 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE')
INSERT INTO MajorV3 VALUES ('AH', N'Ahihi đồ ngok')
INSERT INTO StudentV3_1 VALUES ('AH1', N'Lê', N'Vui Vẻ', NULL, NULL, 'AH')

SELECT * FROM MajorV3  
SELECT * FROM StudentV3_1
DELETE FROM MajorV3 WHERE MajorID = 'AH' -- gtri bên student về SE 

-- CHO SV KO CHỌN CHUYÊN NGÀNH, HẮN SẼ HỌC GÌ??? HỌC SE ĐẤY 
--											 	<MajorID char(2) DEFAULT 'SE',>
INSERT INTO StudentV3_1 (StudentID, LastName, FirstName) 
					VALUES  ('SE2', N'Phạm', N'Bình')
	--<SE2     	Phạm	Bình	NULL	NULL	SE>




--================================HỌC LẠI 
--TABLE 1 TẠO TRƯỚC, TABLE N TẠO SAU 
--XÓA N TRƯỚC, XÓA 1 SAU 
CREATE TABLE MajorV1
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
INSERT INTO MajorV1 VALUES ('SE', N'KTPM')
INSERT INTO MajorV1 VALUES ('IA', N'ATTT')

CREATE TABLE StudentV1
(
	StudentID char(8), --PRIMARY KEY,
	CONSTRAINT PK_STUDENTV1 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime NULL,
	[Address] nvarchar(50) NULL,
	MID char(2) -- tên cột khóa ngoại/tham chiếu ko cần trùng bên 1-key 
				-- nhưng bắt buộc trùng 100% kiểu dữ liệu vì bản chất cần tham chiếu data hoy 
)
INSERT INTO StudentV1 VALUES ('SE1', N'Nguyễn', N'An', NULL, NULL, 'SE')--vào đc 
--	THIẾT KẾ TRÊN SAI vì 2 table độc lập, KO CÓ THAM CHIẾU GIỮA MajorID của /Student VS. Major phía trên  
INSERT INTO StudentV1 VALUES ('SE2', N'Lê', N'Bình', NULL, NULL, 'AH')--vào đc 
SELECT * FROM MajorV1
SELECT * FROM StudentV1

CREATE TABLE MajorV2
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
CREATE TABLE StudentV2
(	
	StudentID char(8), 
	CONSTRAINT PK_STUDENTV2 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 
	MajorID char(2) REFERENCES MajorV2(MajorID)
					--tham chiếu đến bảng cột mẹ nào 
	MajorID char(2) FOREIGN KEY REFERENCES MajorV2(MajorID)
					--tao là khóa ngoại tham chiếu đến bảng cột mẹ nào 
)

--KO ĐC XÓA TABLE 1 NẾU NÓ ĐANG ĐƯỢC THAM CHIẾU TỚI TABLE KHÁC
DROP TABLE MajorV2
--NẾU CÓ MQH 1-N, XÓA N TRƯỚC RỒI XÓA 1 SAU 

CREATE TABLE MajorV3
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
CREATE TABLE StudentV3
(	
	StudentID char(8), 
	CONSTRAINT PK_STUDENTV3 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 
	MajorID char(2) REFERENCES MajorV2(MajorID)
		--cột này là khóa ngoại tham chiếu đến 
	MajorID char(2) FOREIGN KEY REFERENCES MajorV2(MajorID)
	MajorID char(2),
	CONSTRAINT FK_StudentV3_MajorV3 FOREIGN KEY(MajorID) REFERENCES MajorV3(MajorID)
		--khóa ngoại móc từ sv3 sang major3 --khóa ngoại trên cột nào 
)

/*
	CỘT DATATYPE PRIMARY KEY;
	
	CỘT DATATYPE
	CONSTRAINT	NameRB	 PRIMARY KEY (trên cột)

	=================================================================

	CỘT DATATYPE             REFERENCES BẢNG(CỘT của bảng kia)
	CỘT DATATYPE FOREIGN KEY REFERENCES BẢNG(CỘT của bảng kia);

	CỘT DATATYPE,
	CONSTRAINT	NameRB	 FOREIGN KEY (trên cột)	REFERENCES BẢNG(CỘT của bảng kia)
			 RB...		khóa ngoại			     tham chiếu đến 

*/
--GỠ RB 
ALTER TABLE StudentV3 DROP CONSTRAINT FK_StudentV3_MajorV3 --gỡ khi chưa có dữ liệu 
ALTER TABLE StudentV3 ADD CONSTRAINT FK_StudentV3_MajorV3 FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID)

DELETE FROM StudentV3 --CỰC KÌ NGUY HIỂM KHI THIẾU WHERE, XÓA HẾT DATA TRONG BẢNG 
-- ~~ SELECT * FROM TABLE WHERE 
DELETE FROM StudentV3 WHERE StudentID = 'SE1'
DELETE FROM MajorV3 WHERE MajorID = 'AH'
--GÀI THÊM HANHF XỬ KHI XÓA, SỬA DATA Ở RB KHÓA NGOẠI/DÍNH KHÓA CHÍNH LUÔN 
--HIỆU ỨNG DOMINO, SỤP ĐỔ DÂY CHUYỀN, 1 XÓA N ĐI SẠCH -> CASCADE DELETE 
--									  1 SỬA N BỊ SỬA THEO -> CASCADE UPDATE 
--Vì sửa cấu trúc table nên ngay lúc design table/CREATE TABLE phải hoàn thành rồi 
--vẫn có thể sửa sau này khi có data, có thể có trouble 
--LIÊN QUAN ĐẾN CẤU TRÚC CỦA CÁI TỦ CREATE/ ALTER/ DROP
ALTER TABLE StudentV3 DROP CONSTRAINT FK_StudentV3_MajorV3 --khi đã có data ở 2 bảng chưa chắc ok
	--XÓA RB KHÓA NGOẠI BỊ THIẾU VIỆC GÀI THÊM RULE NHỎ LIÊN QUAN ĐẾN XÓA SỬA DATA 
ALTER TABLE StudentV3 CONSTRAINT FK_StudentV3)_MajorV3 FOREIGN KEY (MajorID) REFERENCES MajorV3(MajorID) 
								ON DELETE CASCADE ON UPDATE CASCADE 
UPDATE MajorV3 SET MajorID = 'AK'--CŨNG CỰC KÌ NGUY HIỂM KHI THIẾU WHERE 
								--SỬA TẤT CẢ LUÔN. But ở đây ko sửa đc vì nó là khóa chính rồi 
UPDATE MajorV3 SET MajorID = 'AK' WHERE MajorID ='AH'
--XÓA Ở TRÊN, Ở DƯỚI ĐI SẠCH CASCDE ĐÓ 
DELETE FROM MajorV3 WHERE MajorID = 'AK'

--CÒN 2 GÀI NỮA LIÊN QUAN ĐẾN TÍNH ĐỔNG BỘ NHẤT QUÁN DATA/CONSISTENCY 
--	SET NULL & DEFAULT
--	KHI 1 XÓA, N VỀ NULL
--	KHI 1 XÓA, N VỀ DEFAULT 
/*
AH	Ahihi đồ ngok
SE	Kĩ thuật phần mềm
										@
AH1     	Lê	Vui Vẻ	NULL	NULL	AH   
SE1     	Nguyễn	An	NULL	NULL	SE

nếu ahihi mà xóa chiến lược là: để đảm bảo ko mâu thuẫn thì 
@ phải xóa hoặc cho @ bằng null  
	Nếu cột @ cho phép null thì chuyên ngành chưa xác định, đương nhiên muốn làm đc điều này thì bản thân cột này phải cho phéo null đã 
	   MajorID char(2), CONSTRAINT... còn nếu là MajorID char(2) NOT NULL, CONSTRAINT... toang 
*/
ALTER TABLE TAB1 ADD CONSTRAINT FK_TAB1_TBA2 FOREIGN KEY (ID) REFERENCES TAB2(ID)
		ON DELETE SET NULL --xóa bên 1 tức là mất bên 1, ko lẻ sụp đổ cả đám bên n, ko hay, nên chọn đưa n về null - đảm bảo đc tính giữ đc càng nhiều dữ liệu càng tốt 
		ON UPDATE CASCADE --update bên 1, bên n nên đồng bộ theo, ăn theo
UPDATE StudentV3 SET MajorID = 'SE' -- toàn trường học SE ấy, toang  
UPDATE StudentV3 SET MajorID = 'SE' WHERE StudentID = 'AK'--tất cả thằng ak thành se, do update đã được gài thêm rule 
UPDATE StudentV3 SET MajorID = 'SE' WHERE MajorID IS NULL 

CREATE TABLE MajorV4
(
	MajorID char(2) PRIMARY KEY, 
	MajorName nvarchar(40) NOT NULL 
)
CREATE TABLE StudentV4
(	
	StudentID char(8), 
	CONSTRAINT PK_STUDENTV3 PRIMARY KEY(StudentID),
	LastName nvarchar(40) NOT NULL, 
	FirstName nvarchar(10)NOT NULL,
	DOB datetime,
	[Address] nvarchar(50), 
	MajorID char(2) REFERENCES MajorV4(MajorID)

	MajorID char(2) DEFAULT 'SE',
	CONSTRAINT FK_StudentV3_MajorV3 FOREIGN KEY(MajorID) REFERENCES MajorV4(MajorID)
	ON UPDATE CASCADE ON DELETE SET DEFAULT  		
)--add rule trong bảng hoặc add sau cx đc
ALTER TABLE StudentV4	CONSTRAINT FK_StudentV3_MajorV4 FOREIGN KEY(MajorID) REFERENCES MajorV4(MajorID)
	ON UPDATE CASCADE ON DELETE SET DEFAULT  
	
