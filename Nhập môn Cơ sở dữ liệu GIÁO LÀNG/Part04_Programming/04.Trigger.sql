
-- TRIGGER
-- TRIGGER LÀ 1 HÀM VOID, KO NHẬN THAM SỐ, KO TRẢ VỀ
-- NÓ LÀM NHIỆM VỤ GÁC CỔNG 1 TABLE NÀO ĐÓ, NẾU CÓ SỰ THAY ĐỔI DATA TRONG TABLE
-- NÓ SẼ TỰ ĐỘNG ĐC THỰC THI, CHẠY
-- DÙNG ĐỂ KIỂM TRA/ĐẢM BẢO TÍNH TOÀN VẸN/NHẤT QUÁN/CONSISTENCY CỦA DỮ LIỆU
-- HOẶC DÙNG ĐỂ KIỂM TRA CÁC RÀNG BUỘC MÀ SQL CHUẨN KO THỂ CUNG CẤP ĐỦ 

-- CHỈ TỰ GỌI LIÊN QUAN ĐẾN TABLE NÀO ĐÓ  VÀ LIÊN QUAN ĐẾN 3 LỆNH INSERT, UPDATE, DELETE
-- GẮN CHẶT VỚI 1 TABLE, NHƯNG KO CẤM CODE CỦA NÓ CAN THIỆP TABLE KHÁC
-- 1 TABLE KO ÉP PHẢI CÓ  TRIGGER 

USE DBDESIGN_PROGRAMMING 
CREATE TABLE [Event]
(
	ID int IDENTITY PRIMARY KEY,
	Name nvarchar(30) NOT NULL 
)

SELECT * FROM Event

GO
--Trigger gắn chặt với table Event trên sự kiện INSERT 
CREATE TRIGGER TR_CheckInsertionOnEvent 
ON Event	-- gắn với table nào
FOR INSERT	-- for hành động nào
AS
BEGIN
	PRINT 'You have just inserted a record in Event table'
END

GO

EXEC PR_InsertEvent N'Blockchain & Game' -- kiểm tra xem có thông báo 1 câu khi insert an event 


-- PHÁ HÔI: KO CHO INSERT VÀO TABLE EVENT
GO
CREATE TRIGGER TR_ForbidInsertionEvent ON Event
FOR INSERT 
AS
BEGIN
	PRINT 'You have just inserted a record in Event table. Sorry'
	ROLLBACK --cấm, undo những gì đã xảy ra khi insert 
END
GO

EXEC PR_InsertEvent N'Thổi nến và Tài chính 4.0'
SELECT * FROM Event -- ko có thổi nến 

DROP TRIGGER TR_ForbidInsertionEvent
DROP TRIGGER TR_CheckInsertionOnEvent


-- KIỂM TRA KO CHO INSERT QUÁ 5 RECORDS/EVENTS
-- SQL CÓ THỂ ĐẾM, QUYẾT ĐỊNH ĐẾM XONG LÀM GÌ TIẾP -> LẬP TRÌNH!!! -> TRIGGER CHẶN KO CHO VÀO
GO
CREATE TRIGGER TR_CheckInsertionLimitationEvent ON Event
FOR INSERT 
AS
BEGIN
	-- XEM THỬ NGƯỜI TA CHÈN CÁI EVENT GÌ VÀO TABLE???
	SELECT * FROM INSERTED -- TABLE INSERTED ĐC TẠO NGẦM KHI CHƠI VỚI TRIGGER 
	ROLLBACK 
END
GO

EXEC PR_InsertEvent N'Thổi nến và Tài chính 4.0'
SELECT * FROM Event 

DROP TRIGGER TR_CheckInsertionLimitationEvent

-- LƯU Ý KHI CHƠI TRIGGER
-- DB SẼ TỰ TẠO RA 2 TABLE "ẢO" LÚC RUNTIME LIÊN QUAN ĐẾN TRIGGER

-- CÂU LỆNH INSERT VÀO TABLE -> DB E. TẠO RA 1 TABLE ẢO TÊN LÀ INSERTED 
-- CHỨA RECORD VỪA ĐƯA VÀO TỪ CÂU LỆNH INSERT 

-- CÂU LỆNH DELETE FROM TABLE -> DB E. TẠO RA 1 TABLE ẢO TÊN LÀ DELETED
-- CHỨA NHỮNG DÒNG VỪA BỊ XÓA!!!

-- CÂU LỆNH UPDATE EVENT SET NAME = 'ĐỔI TÊN SỰ KIỆN' -> DB E. TẠO 2 TABLE ẢO
-- INSERTED CHỨA VALUE MỚI ĐƯA VÀO
-- DELETED CHỨA VALUE CŨ/BỊ GHI ĐÈ 

GO
CREATE TRIGGER TR_CheckInsertionLimitationEvent ON Event
FOR INSERT 
AS
BEGIN
	-- kiểm tra xem trong table Event ko cho vượt quá 5 sự kiện
	-- if số sự kiện > 5 thì rollback!!! 
	-- phải đếm số sự kiện đang có!!!
	-- lấy đc số sk để if, tức là khai báo biến 
	-- nhớ lệnh count(*) trong SELECT TRẢ VỀ 1 TABLE, HOK TRẢ VỀ 1 BIẾN, TA PHẢI...
	
	DECLARE @noEvents int 
	SELECT @noEvents = COUNT(*) FROM Event
	--PRINT @noEvents
	IF @noEvents > 5
	BEGIN
		PRINT 'To much events. No more 5 events!!!'
		ROLLBACK 
	END
END
GO
-- LIÊN QUAN ĐẾN TABLE, CÓ 2 LOẠI TRIGGER CƠ BẢN:
--		CHẶN TRƯỚC KHI DỮ LIỆU ĐƯA VÀO TABLE, LÚC NÀY DỮ LIỆU MỚI VÀO INSERTED (BEFORE)
--		CHẶN SAU KHI ĐÃ VÀO INSERTED VÀ DỒNG THỜI VÀO LUÔN TABLE RỒI (AFTER)\

SELECT * FROM Event
EXEC PR_InsertEvent N'Làm sao sống sót ở FU.HCM' --ok, vào vì 5 
EXEC PR_InsertEvent N'Thổi nến và Tài chính 4.0' --ko vào, >5


--==========================================
--học lại
go
CREATE TRIGGER TG1 ON Event FOR INSERT -- trigger gắn chặt với table event trên sự kiện insert 
AS PRINT 'inserted '
go --chỉ cần f5 1 lần là nó sẽ chạy khi gọi các hàm khác lquan đến insert 

go
CREATE TRIGGER TG2 ON Event FOR INSERT 
AS	
	BEGIN
			PRINT 'inserted but sorry'
			ROLLBACK --cấm, undo những gì đã xảy ra khi insert 
	END
go

DROP TRIGGER TG2

go
CREATE TRIGGER TG3 ON Event FOR INSERT 
AS 
	BEGIN 
			--XEM THỬ NGƯỜI TA CHÈN CÁI GÌ VÀO TABLE 
			SELECT * FROM INSERTED 
			ROLLBACK 
	END
go

--Kiểm tra không cho insert quá 5 records/evets
--	SQL có thể đếm, nhưng quyết định đếm xong làm gì tiếp -> lập trình -> trigger chặn ko cho vào 
go
CREATE TRIGGER TG4 ON Event FOR INSERT 
AS 
	BEGIN 
			--kiểm tra xem trong table ko cho vượt quá 5 sự kiện
			--if số sự kiện > 5 thì rollback
			--phải đếm số sự kiện đang có 
			--lấy đc số sự kiện ra để if, tức là khai báo biến 
			--do lệnh count(*) trong SELECT trả về 1 table, hok trả về 1 biến, ta phải ...
			DECLARE @noEvents int 
			SELECT @noEvents = COUNT(*) FROM Event
			PRINT @noEvents
			IF @noEvents > 5
				BEGIN 
					PRINT 'To much events. No more 5 events'
					ROLLBACK --vào rồi mới xử lí/ hậu xử lí 
				END 
			ROLLBACK 
	END
go

-- liên quan đến table, có 2 loại trigger cơ bản:
--		chặn trước khi dữ liệu đưa vào table, lúc này dữ liệu mới vào inserted (before)
--		chặn sau khi đã vào inserted và đồng thời vào luôn table rồi 
	











