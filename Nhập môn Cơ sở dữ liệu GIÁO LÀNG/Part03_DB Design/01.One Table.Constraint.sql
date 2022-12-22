--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 20 - Database Design (Phần 6)

--	PHẦN NÀY THÍ NGHIỆM CÁC LOẠI RÀNG BUỘC - CONSTRAINT - QUY TẮC GÀI TRÊN DATA 
/*
	1. RÀNG BUỘC PRIMARY KEY
	tạm thời chấp nhận PK là 1 cột (tương lai có thể nhiều cột) mà giá trị 
	của nó trên mọi dòng/mọi cell của cột này ko trùng lại, mục đích dùng để 
	WHERE ra đc 1 dòng duy nhất 
	VALUE CỦA KEY CÓ THỂ ĐC TẠO RA THEO 3 CÁCH 
	CÁCH 1: TỰ NHẬP = TAY, DB ENGINE SẼ TỰ KIỂM TRA GIÙM MÌNH CÓ TRÙNG HAY KO?
			NẾU TRÙNG DB ENGINE TỰ BÁO VI PHẠM PK CONSTRAINT - HỌC RỒI UI/UX

	CÁCH 2: ÉO CẦN NHẬP = TAY CÁI VALUE CỦA PK, MÁY/DB ENGINE TỰ GENERATE CHO MÌNH 
			1 CON SỐ KO TRÙNG LẠI!!!!! CON SỐ TỰ TĂNG, CON SỐ HEXA 
*/

-- THỰC HÀNH
--	Thiết kế table lưu thông tin đăng kí event nào đó (giống đk qua GG Form)
--	thông tin cần lưu trữ: số thứ tự đăng kí, tên full name email,
--	ngày giờ đăng kí, số di động 
--	* Phân tích 
--	ngày giờ đk: ko bắt nhập, default
--	số thứ tự: nhập vào là bậy rồi!!! tự gán chứ!!!
--	email, phone: ko cho trùng heng, 1 email 1 lần đk 
--	...

USE DBDESIGN_ONETABLE

CREATE TABLE RegistrationV1
(
	SEQ int PRIMARY KEY, -- PHẢI TỰ NHẬP STT, VỚ VẨN 
	FirstName nvarchar(10),
	LastName nvarchar(30),
	Email varchar(50),	-- CẤM TRÙNG LÀM SAO???
	Phone varchar(11),
	RegDate datetime DEFAULT GETDATE() -- CONSTRAINT DEFAULT 
)

CREATE TABLE Registration
(
	SEQ int PRIMARY KEY IDENTITY, -- mặc định đi từ 1, nhảy ++ cho người sau 
										--IDENTITY(1, 1) hơi thừa 
								  -- IDENTITY(1,5), từ 1, 6, 11, 16, ... bước nhảy 5 
	FirstName nvarchar(10),
	LastName nvarchar(30),
	Email varchar(50),	-- CẤM TRÙNG LÀM SAO???
	Phone varchar(11),
	RegDate datetime DEFAULT GETDATE() -- CONSTRAINT DEFAULT 
)
-- ĐĂNG KÍ EVENT 
INSERT INTO Registration VALUES (N'An', N'Nguyễn', 'an@...', '090x')
	--báo lỗi, k map đc các cột rõ ràng | 4/6 thông tin 

INSERT INTO Registration VALUES (N'An', N'Nguyễn', 'an@...', '090x', null)  
	-- k cần nhập cột tự tăng nhưng các cột khác phải đầy đủ | 5/6 thông tin 
SELECT * FROM Registration

INSERT INTO Registration (FirstName, LastName, Email, Phone)
			VALUES (N'Bình', N'Lê', 'binh@...', '091x')     -- time default rồi
INSERT INTO Registration VALUES(N'Cường', N'Võ', 'cuong@...', '092x', NULL) --STT3

-- XÓA 1 DÒNG CÓ AUTO GENERATED KEY, THÌ TABLE SẼ LỦNG SỐ, DB ENGINE KO LẤP CHỖ LỦNG
-- 1 2 3 4 5 6, XÓA 3, CÒN 1 2 4 5 6, ĐĂNG KÍ TIẾP TÍNH TỪ 7 
DELETE FROM Registration WHERE FirstName = 'An'--xóa STT1
INSERT INTO Registration VALUES(N'Dũng ', N'Trần', 'cuong@...', '092x', NULL)--STT4

-------------------------
--Cách vẽ thực thể, insert SQL bằng tool 
