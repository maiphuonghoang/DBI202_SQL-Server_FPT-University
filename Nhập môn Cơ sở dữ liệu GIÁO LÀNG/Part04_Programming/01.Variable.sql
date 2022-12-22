--Nhập môn Cơ sở dữ liệu quan hệ (RDBMS): Bài 29 - Database Design | Programming (Phần 15)

--	LẬP TRÌNH TRONG DB ENGINE 

/*	=>	Lập trình trong CSDL + 
					Tên thương hiệu
					Tên 1 loại engine của phần mềm CSDL 
		PL/SQL		(Oracle)
		T-SQL		(SQLServer)
		PL/pgSQL	(PostgreSQL)
		SQL			(MySQL)
 
*/
--	T-SQL là ngôn ngữ SQL mà microsoft độ lại câu SQL gốc liên quan đến lập trình 
--	Học T-SQL tức là học SQL + phần mở rộng lập trình của SQLServer 


-- Kiểu dữ liệu - data type là cách ta lưu loại dữ liệu nào đó: 
-- số (nguyên, thực), chữ, câu/đoạn văn, ngày tháng, tiền ($...)
-- 1 NNLT sẽ hỗ trợ nhiều loại dữ liệu khác nhau - data types 

-- Khi lập trình trong SQL Server, vì câu lệnh sẽ nằm trên nhiều dòng...
-- mình cần nhắc Tool này 1 câu: đừng nhìn lệnh riêng lẻ (nhiều dòng) 
-- mà hãy nhìn nguyên cụm lệnh mới có ý nghĩa (BATCH)
-- ta dùng lệnh GO để gom 1 cụm lệnh lập trình lại thành 1 đơn vị có ý nghĩa


--	KHAI BÁO BIẾN 
GO

DECLARE @msg1 AS nvarchar(30)

DECLARE @msg nvarchar(30) = N'Xin chào - Welcome to T-SQL'

-- IN BIẾN CÓ 2 LỆNH 
PRINT @msg	-- IN RA KẾT QUẢ BÊN CỬA SỔ CONSOLE GIỐNG LẬP TRÌNH 

SELECT @msg	-- IN RA KẾT QUẢ DƯỚI DẠNG TABLE 

DECLARE @yob int -- = 2003

-- GÁN GIÁ TRỊ CHO BIẾN 
SET @yob = 2003
SELECT @yob = 2004 -- SELECT DÙNG 2 CÁCH: GÁN GIÁ TRỊ CHO BIẾN, IN GIÁ TRỊ CỦA BIẾN 

PRINT @YOB

				--begin end nếu có nhiều lệnh 
IF @yob > 2003
	BEGIN --{
		PRINT 'HEY, BOY/GIRL'
		PRINT 'HELLO, GEN Z'
	END --}
ELSE 
	PRINT 'HELLO LADY & GENTLEMENT'

GO

----------------------------------------------------------------
--học lại 

GO
	--khai báo biến 
DECLARE @msg1 AS nvarchar(30) --khai báo chưa gán value 
DECLARE @msg AS nvarchar(30) = N'Hello'
	--in biến có 2 câu lệnh 
PRINT @msg  --> Messages	In ra kết quả bên cửa sổ console giống lập trình 
SELECT @msg --> Result		In ra kết quả dưới dạng table 
GO

DECLARE @yob int 
	--gán giá trị cho biến 
	--c1:
	SET @yob = 2003
	SELECT @yob = 2003 --có = khi select thì hiểu là gán, ko = thì là in 

	PRINT @yob

	IF @yob > 2003 
		PRINT '>2003'
	ELSE
		PRINT '<=2003'
GO




