﻿USE Northwind
-------------------------------------------------------
--	LÝ THUYẾT 
--	Cú pháp chuẩn của lệnh SELECT 
--	SELECT * FROM <TABLE> WHERE...
--	WHERE CỘT TOÁN-TỬ-SO-SÁNH VỚI-VALUE-CẦN-LỌC
--		  CỘT > >= < <= = !=  VALUE
--							  DÙNG CÂU SUB-QUERY TÙY NGỮ CẢNH 
--		  CỘT			   = (SUB CHỈ CÓ 1 VALUE)
--		  CỘT			   IN (SUB CHỈ CÓ 1 CỘT NHƯNG NHIỀU VALUE) 

--		  CỘT			   > >= < <= ALL (1 CÂU SUB 1 CỘT NHIỀU VALUE) 
--									 ANY (1 CÂU SUB 1 CỘT NHIỀU VALUE) 
-------------------------------------------------------

--THỰC HÀNH 
-- tạo 1 table có cột tên là Numbr ,chỉ chứa 1 đống dòng các số nguyên 
CREATE TABLE Num
(
	Numbr int 
) --phải bôi đen F5 thì nó mới tạo ra table Num cho 
SELECT * FROM Num 
INSERT INTO Num values(1)
INSERT INTO Num values(1)
INSERT INTO Num values(2)
INSERT INTO Num values(9)
INSERT INTO Num values(100)
INSERT INTO Num values(101)

--1. In ra những số > 5
SELECT * FROM Num WHERE Numbr > 5

--2. In ra số lớn nhất trong các số đã nhập 

-- SỐ LỚN NHẤT TRONG 1 ĐÁM ĐC ĐỊNH NGHĨA LÀ LỚN HƠN HẾT CẢ ĐÁM ĐÓ, VÀ MÀY BẰNG CHÍNH MÌNH
-- lớn hơn tất cả ngoại trừ chính mình -> mình là MAX CỦA ĐÁM 

SELECT * FROM Num WHERE Numbr = 101 -- lầy lội
SELECT * FROM Num WHERE Numbr >= ALL (SELECT * FROM Num)
--										1, 1, 2, 9, 5, 100, 101
SELECT * FROM Num WHERE Numbr > ALL (SELECT * FROM Num)  -- RỖNG, vì k có thằng nào vượt lên cả đám 

--3. Số nhỏ nhất là số nào?
SELECT DISTINCT * FROM Num WHERE Numbr <= ALL (SELECT * FROM Num)

--4. Nhân viên nào lớn tuổi nhất 
SELECT * FROM Employees WHERE BirthDate <= ALL(SELECT BirthDate FROM Employees)

--5. Đơn hàng nào có trọng lượng nặng nhất 
SELECT * FROM Orders WHERE Freight >= ALL (SELECT Freight FROM Orders)