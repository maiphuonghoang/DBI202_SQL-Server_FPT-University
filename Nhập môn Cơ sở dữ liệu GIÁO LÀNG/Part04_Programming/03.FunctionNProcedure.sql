
-- HÀM: 1 NHÓM CÂU LỆNH ĐC ĐẶT TÊN, NHÓM LỆNH NÀY LÀM 1 VIỆC GÌ ĐÓ. 
-- HÀM DÙNG ĐỂ RE-USE 
-- VD: hàm căn bậc 2 dùng để lấy căn 

-- TRONG LẬP TRÌNH CÓ 2 LOẠI HÀM:
--		HÀM VOID: KO TRẢ VỀ 1 GIÁ TRỊ NÀO CẢ
--		HÀM CÓ TRẢ VỀ 1 GIÁ TRỊ (CHỈ 1): LỆNH RETURN 

-- R.DBMS (CSDL DỰA TRÊN RELATION/TABLE) TA CÓ 2 LOẠI HÀM Y CHANG 
--		STORED PROCEDURE ~~~~~ VOID 
--		FUNCTION  ~~~~~ RETURN 

--===================
--	Function: hàm trả về giá trị 
--	Store Procedure: hàm void, gọi thì mới chạy
--					 trả giá trị theo kiểu tham số đầu vào 
--					 không trả qua lệnh return mà trả qua ngõ tham số đầu vào và 
--					 có quyền trả nhiều giá trị 
--		Trong C có hàm trả về giá trị nhưng không trả qua ngõ return tên hàm 
--		mà lại trả theo ngõ tham số đầu vào - truyền con trỏ/tham chiếu 
--==================

-- XEM CODE Ở Programmability -> Stored Procedures / Functions 

-- C: void f(int* a, int* b){}
-- gọi hàm f()
-- int x = 10, y = 11;

-- f(&x, &y), khi trong hàm f mà làm gì với x,y, thì x y ở 
-- bên ngoài bị ảnh hưởng luôn -- tác động được nhiều biến 
-- hàm thay đổi 2 giá trị x y ở bên ngoài, void mà lại đưa data 
-- ra ngoài qua con trỏ, truyền tham chiếu, pass by reference 

--	VIẾT HÀM IN RA CÂU CHÀO!!!
--  CREATE PROCEDURE PR_Hello() {... code ...}--//no

CREATE DATABASE DBDESIGN_PROGRAMMING 
USE DBDESIGN_PROGRAMMING 

GO


--hàm void in ra câu hello 
CREATE PROCEDURE PR_Hello_1
AS
	PRINT N'Xin chào - Welcome to my first procedure'

--DROP PROCEDURE PR_Hello
GO

-- DÙNG PROCEDURE 
GO
	-- LÀ HÀM VOID, GỌI TÊN EM LÀ ĐỦ 
PR_Hello_1			--C1
dbo.PR_Hello_1		--C2
	-- TUI MÚN THỰC THI, CHẠY THỦ TỤC/NHÓM LỆNH ĐÃ ĐẶT TÊN 
EXECUTE PR_Hello_1  --C3
EXEC PR_Hello_1		--C4
GO

--DROP PROC PR_Hello_2
CREATE PROC PR_Hello_2
AS
	PRINT N'Xin chào - Welcome to my 2nd procedure'
EXEC PR_Hello_2

-----------------------------------------------------------------

-- HÀM, PHẢI TRẢ VỀ GIÁ TRỊ!!! QUA LỆNH RETURN 
--		ko cho viết tắt giống proc 
--		tên hàm phải có ngoặc
--		bắt buộc có begin end 
--		giá trị trả về là kiểu gì 

GO
--	int f() {... code ...}
CREATE FUNCTION FN_Hello() RETURNS nvarchar(50)
AS
BEGIN
	RETURN N'Xin chào - Welcome to my first function'
END

GO 
-- DROP FUNCTION FN_Hello

-- LƯU Ý -	Y CHANG BÊN LẬP TRÌNH, HÀM TRẢ VỀ GIÁ TRỊ THÌ ĐC QUYỀN DÙNG TRONG 
--			CÁC CÂU LỆNH KHÁC
--			GỌI HÀM MÀ KO KÈM THÊM GÌ KHÁC, ĐỪNG HỎI TẠI SAO MÀN HÌNH KO THẤY GÌ!!!
--			NHIỆM VỤ HÀM LÀ TRẢ VỀ GIÁ TRỊ, IN ÉO LÀ VIỆC CỦA HÀM, VIỆC KHÁC CŨNG THẾ
--			IN XEM HÀM XỬ LÍ RA SAO, THÌ PHẢI KÈM LỆNH IN VÀ LỆNH GỌI HÀM 
--				sqrt(4);		-> ko kết quả khi chạy
--				Math.sqrt(4);	-> ko kết quả khi chạy
--				sout(Math.sqrt(4)) -> có kết quả chạy hàm 

dbo.FN_Hello() -- ko kq
SELECT FN_Hello() --bắt buộc phải có dbo.tên hàm 
SELECT dbo.FN_Hello()
PRINT dbo.FN_Hello()

GETDATE() -- chạy 1 mình báo lỗi liền, phải ghép vào lệnh khác 
SELECT GETDATE()	-- HÀM DÙNG XỬ LÍ TRẢ VỀ KQ, PHẢI DÙNG KQ TRONG LỆNH NÀO ĐÓ 

-----------------------------------------------------------------------------

-- //View tương đương 1 table để select lại 
-- //Proceduer chỉ đơn giản là in ra kết quả, hết, ko làm gì đc với kq đó nữa
--							   chỉ nhìn kq xử lí chứ k tận dụng kq cho việc khác 	
--		Proc cho truyền giá trị đầu vào 
--		~~ void f(int x){}

------------------------------------------------------------------------------

--	VIẾT HÀM - PROC ĐỔI TỪ ĐỘ C -> F, F = C * 1.8 + 32 
--	THAM SỐ/ĐẦU VÀO/ARGUMENT 
GO
CREATE PROC PR_C2F
@CDegree float 
AS
BEGIN
	DECLARE @FDegree float = @CDegree * 1.8 + 32
	PRINT @FDegree
END 

GO 

-- xài, vì có tham số, cần truyền vào 
EXEC PR_C2F @CDegree = 37
EXEC PR_C2F 37

--###############
GO
CREATE FUNCTION FN_C2F(@cDegree float)
RETURNS float
AS
BEGIN
--	DECLARE @fDegree float = @cDegree * 1.8 + 32
--	RETURN @fDegree
	
	RETURN @cDegree * 1.8 + 32
END
GO

-- sử dụng hàm, hàm là phải viết kèm với lệnh khác  
PRINT dbo.FN_C2F (37)
PRINT N'37 độ C là ' + CAST(dbo.FN_C2F (37) AS varchar(10)) + N' độ F'

-- PROCEDURE LÀM ĐC NHIỀU VIỆC 
-- VIẾT 1 PROCEDURE IN RA DANH SÁCH CÁC NHÂN VIÊN QUÊ Ở ĐÂU ĐÓ, ĐÂU ĐÓ ĐƯA VÀO PROC
-- VIEW: IN RA AI Ở LONDON
-- VIEW: IN RA AI Ở KIRKLAND,...
-- MỖI VIEW LÀ 1 SELECT VÀ LÀ 1 TABLE ĐỂ REUSE 
-- PROCEDURE IN RA KẾT QUẢ NHƯ VIEW, KO REUSE LẠI (CHỈ IN RA) NHƯNG LẠI NHẬN ĐC THAM SỐ 

USE Northwind
GO

CREATE PROC PR_EmployeeListByCity
@city nvarchar(30)
AS
	SELECT * FROM Employees WHERE City = @city
GO

SELECT * FROM Employees WHERE City = 'Redmond' -- nếu làm kiểu này thì bao nhiêu view cho vừa 

EXEC PR_EmployeeListByCity 'Redmond'
EXEC PR_EmployeeListByCity 'Seatle'
EXEC PR_EmployeeListByCity 'London'

-----------------------------------------------------------------------------
--	ỨNG DỤNG THÊM CỦA PROCEDURE, VIẾT PROC INSERT DATA 
USE DBDESIGN_PROGRAMMING 
CREATE TABLE [Event]
(
	ID int IDENTITY PRIMARY KEY,
	Name nvarchar(30) NOT NULL 
)

INSERT INTO [Event] VALUES (N'Lời nói dối chân thật')

GO
CREATE PROC PR_InsertEvent
@name nvarchar(30)
AS
	INSERT INTO [Event] VALUES (@name)
GO

EXEC PR_InsertEvent @name = N'Bí quyết dùng source ở FE'
EXEC PR_InsertEvent N'Hồ Sen chờ ai'

SELECT * FROM [Event]


--========================================================
--học lại 

--//1. Hàm PROCEDURE 	
 GO
 --~~ public void Tên-hàm  
 --có 1 hàm void mà các hàm của nó tương đương xử lí bên trong là 
 CREATE PROCEDURE V1 AS PRINT 'Hello'
 --nó là hàm void nên khi muốn dùng thì gọi tên là đủ 
		
	EXECUTE V1 --thực thi c1
	EXEC V1

CREATE PROC V2 AS PRINT 'Hi' --cách viết 2 
EXEC V2
 GO

 GO
 --//1. Hàm FUNCTIONAL 
 CREATE FUNCTION R1 
					AS RETURN N'Xin chào'
	--câu này chưa được vì với function bắt buộc phải được viết trong [Begin-end] dù chỉ là 1 câu lệnh 
 CREATE FUNCTION R1 
					AS 
						BEGIN 
								RETURN N'Xin chào' 
						END 
	--nhưng vẫn chưa được vì hàm trả về giá trị thì phải biết giá trị kiểu gì 
	--int f(){}; -- và yêu cầu thêm ngoặc ở tên hàm 
 CREATE FUNCTION R2()
					RETURNS nvarchar(30)
					AS 
						BEGIN 
								RETURN N'Xin chào' 
						END --đã ổn 
--hàm trả về giá trị thì được dùng trong các câu lệnh khác 
--nhiệm vụ duy nhất của hàm là trả về giá trị
--in xem hàm xử lí ra sao thì phải kèm lệnh in và lệnh gọi hàm 

SELECT dbo.R2() --hàm function bắt buộc phải có dbo chấm thì mới chạy 
GO 

/*
	Hàm PROPOCEDURE 
					có tên tắt 
					phải không có ngoặc khi viết, gọi ko có dbo.
					thực thi thì EXECUTE hoặc EXEC 
	Hàm FUNCTION bắt buộc phải có () khi viết 
						  phải RETURN datatype 
						  câu lệnh nằm trong BEGIN END 
						  phải có dbo.
			Hàm đều liên quan đến tạo dựng dàn khhung database, muốn xóa thì DROP 
			DROP PROCEDURE 
			DROP FUNCTION

			DROP TABLE 
			DROP COLUMN 
*/

-- //3. THAM SỐ ĐẦU VÀO 
-- Viết hàm đổi từ độ C sang độ F 
GO
CREATE PROC C_to_F 
				@CDegree float 
AS 
	BEGIN 
			DECLARE @FDegree float = @CDegree * 1.8 + 32
			PRINT @FDegree 
	END 
--gọi hàm thì phải có tham số truyền vào 
EXEC C_to_F		@CDegree = 37 --c1
EXEC C_to_F		 37			  --c2 

		--viết gọn hàm trên 
CREATE PROC C_t_F 
				@CDegree float 
AS 
	PRINT @CDegree * 1.8 + 32
EXEC C_to_F		 37

GO
CREATE FUNCTION C_F (@cDegree float) 
RETURNS float 
AS
	BEGIN 
		DECLARE @fDegree float = @CDegree * 1.8 + 32
		RETURN @fDegree 
	END

PRINT dbo.C_F(@cDegree = 37) --function k cho phép cách này như procedure 
SELECT dbo.C_F(37)
PRINT N'37 độ C là ' + CONVERT( nvarchar(10), dbo.C_F(37)) + N'độ F'
PRINT N'37 độ C là ' + CAST(dbo.C_F(37) AS nvarchar(10)) + N'độ F'
GO

--//4. REUSE OF PROCEDURE 
--	procedure in ra kết quả như view, ko reuse lại (chỉ in ra) nhưng lại nhận được tham số 
go
CREATE PROC List_By_City @city nvarchar(30) 
			AS SELECT * FROM Employees WHERE City = @city
EXEC List_By_City 'London'--4
EXEC List_By_City N'London'--4 Ủa luôn giờ mứi bít 
EXEC List_By_City @city = 'London'--4 

go

--	VIẾT PROC ĐỂ INSERT DATA
go
CREATE PROC InsertEvent @name nvarchar(30)
			AS INSERT INTO [Event] VALUES (@name)
EXECUTE InsertEvent 'hoc lai cho chac' --chưa vào do ở trên có ràng buộc <=5 even 
SELECT * FROM Event
DELETE FROM Event WHERE ID = '8'
EXECUTE InsertEvent 'hoc lai cho chac' --đã vào do mình xóa 1 cái id = 8 