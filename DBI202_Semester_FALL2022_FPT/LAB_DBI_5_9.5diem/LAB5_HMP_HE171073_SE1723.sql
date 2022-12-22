CREATE DATABASE LAB5_HMP_HE171073_SE1723
USE LAB5_HMP_HE171073_SE1723

CREATE TABLE PHONGBAN 
(
	MaPhg int PRIMARY KEY,
	TenPhg varchar(30),
	TrPhong char(9),
	NgNhanChuc date

)
CREATE TABLE DEAN
(	
	MaDA int PRIMARY KEY,
	TenDA varchar(30),
	DdiemDA varchar(30),
	Phong int REFERENCES PHONGBAN(MaPhg)
)
CREATE TABLE DIADIEM_PHG
(
	MaPhg int REFERENCES PHONGBAN(MaPhg),
	DiaDiem varchar(15),
	PRIMARY KEY (MaPhg, DiaDiem)
)

CREATE TABLE NHANVIEN
(
	MaNV char(9) PRIMARY KEY,
	HoNV varchar(15),
	TenLot varchar(15),
	TenNV varchar(15),
	NgSinh date,
	DChi varchar(50),
	Phai char(3) CONSTRAINT CK_Phai CHECK (Phai IN ('Nam', 'Nu')),
	Luong int,
	MaNQL char(9) REFERENCES NHANVIEN(MaNV),
	Phg int REFERENCES PHONGBAN(MaPhg)
)

CREATE TABLE THANNHAN
(
	MaNVien char(9) REFERENCES NHANVIEN(MaNV),
	TenTN varchar(15),
	Phai char(3) CONSTRAINT CK_PhaiTN CHECK (Phai IN ('Nam', 'Nu')),
	NgSinh date,
	QuanHe varchar(15),
	PRIMARY KEY(MaNVien, TenTN)
)
CREATE TABLE PHANCONG 
(
	MaNVien char(9) REFERENCES NHANVIEN(MaNV),
	SoDA int REFERENCES DEAN(MaDA),
	ThoiGian int,
	PRIMARY KEY (MaNVien, SoDA)
)

SET DATEFORMAT DMY 

INSERT INTO PHONGBAN 
VALUES (5, 'Nghien Cuu', 333445555, '22/05/1978'), 
	   (4, 'Dieu hanh', 987987987, '01/01/1985'),
	   (1, 'Quan ly', 888665555, '19/06/1971')

INSERT INTO DIADIEM_PHG
VALUES (1, 'TP HCM'),
	   (4, 'HA NOI'),
	   (5, 'VUNG TAU'),
	   (5, 'NHA TRANG'),
	   (5, 'TP HCM')

INSERT INTO NHANVIEN (HoNV, TenLot, TenNV, MaNV, NgSinh, DChi, Phai, Luong, MaNQL, Phg)
VALUES ('Dinh', 'Ba', 'Tien', 123456789, '09/01/1955','731 Tran Hung Dao, Q1, TPHCM', 'Nam', 30000, 333445555, 5),
	   ('Nguyen', 'Thanh', 'Tung', 333445555, '08/12/1945', '638 Nguyen Van Cu, Q5, TPHCM', 'Nam', 40000, 888665555, 5),
	   ('Bui', 'Thuy', 'Vu', 999887777, '19/07/1958', '332 Nguyen Thai Hoc, Q1, TPHCM', 'Nam', 25000, 987654321, 4),
	   ('Le', 'Thi', 'Nhan', 987654321, '20/06/1931', '291 Ho Van Hue, QPN, TPHCM', 'Nu', 43000, 888665555, 4),
	   ('Nguyen', 'Manh', 'Hung', 666884444, '15/09/1952', '975 Ba Ria, Vung Tau', 'Nam', 38000, 333445555, 5),
	   ('Tran', 'Thanh', 'Tam', 453453453, '31/07/1962', '543 Mai Thi Luu, Q1, TPHCM', 'Nam', 25000, 333445555, 5),
	   ('Tran', 'Hong', 'Quan', 987987987, '29/03/1959', '980 Le Hong Phong, Q10, TPHCM', 'Nam', 25000, 333445555, 4),
	   ('Vuong', 'Ngoc', 'Quyen', 888665555, '10/10/1927', '450 Trung Vuong, HaNoi', 'Nu', 55000, NULL, 1)

--sau insert bảng nhân viên bảng mới tạo được ràng buộc TrPhong cho bảng phòng ban 
ALTER TABLE PHONGBAN ADD CONSTRAINT FK_PB_TrPhong FOREIGN KEY(TrPhong)  REFERENCES NHANVIEN(MaNV)

INSERT INTO THANNHAN 
VALUES  (333445555, 'Quang', 'Nu', '05/04/1976', 'Con gai'),
		(333445555, 'Khang', 'Nam', '25/10/1973', 'Con trai'),
		(333445555, 'Duong', 'Nu', '03/05/1948', 'Vo chong'),
		(987654321, 'Dang', 'Nam', '29/02/1932', 'Vo chong'),
		(123456789, 'Duy', 'Nam', '01/01/1978', 'Con trai'),
		(123456789, 'Chau', 'Nu', '31/12/1978', 'Con gai')

INSERT INTO DEAN (TenDA, MaDA, DdiemDA, Phong)
VALUES  ('San pham X', 1, 'VUNG TAU', 5),
		('San pham Y', 2, 'NHA TRANG', 5),
		('San pham Z', 3, 'TP HCM', 5),
		('Tin hoc hoa', 10, 'HA NOI', 4),
		('Cap quang', 20, 'TP HCM', 1),
		('Dao tao', 30, 'HA NOI', 4)

INSERT INTO PHANCONG 
VALUES  (123456789, 1, 32.5),
		(123456789, 2, 7.5),
		(666884444, 3, 40.0),
		(453453453, 1, 20.0),
		(453453453, 2, 20.0),
		(333445555, 3, 10.0),
		(333445555, 10, 10.0),
		(333445555, 20, 10.0),
		(999887777, 30,30.0),
		(999887777, 10, 10.0),
		(987987987, 10, 35.0),
		(987987987, 30, 5.0),
		(987654321, 30, 20.0),
		(987654321, 20, 15.0),
		(888665555, 20, NULL)

/*
--thứ tự xóa bảng 
DROP TABLE THANNHAN
DROP TABLE DIADIEM_PHG
DROP TABLE PHANCONG
DROP TABLE DEAN
ALTER TABLE PHONGBAN DROP CONSTRAINT FK_PB_TrPhong
DROP TABLE NHANVIEN
DROP TABLE PHONGBAN
*/

---======================
SELECT * FROM PHONGBAN
SELECT * FROM DIADIEM_PHG
SELECT * FROM NHANVIEN
SELECT * FROM DEAN
SELECT * FROM PHANCONG
SELECT * FROM THANNHAN

---===============================================================================
--1. List all information of employees (code, name, entered date, supervisor’s id, supervisor’s name) 
--	that were employed from s to f. S and f are date value that were been input parameters

go
CREATE PROC SP_1 @s date, @f date
AS
BEGIN 
	SELECT n.MaNV AS code, n.HoNV + ' ' + n.TenLot + ' ' + n.TenNV AS name, 
		   p.NgNhanChuc AS enteredDate, n.MaNQL AS supervisorId,	
		   n2.HoNV + ' ' + n2.TenLot + ' ' + n2.TenNV AS supervisorName 										
	FROM PHONGBAN p RIGHT JOIN NHANVIEN n ON p.TrPhong = n.MaNV
				    LEFT JOIN NHANVIEN n2 ON n2.MaNV = n.MaNQL
	WHERE p.NgNhanChuc BETWEEN @s AND @f
END
go 
	--test 
	EXEC SP_1 @s = '01/01/1970', @f = '01/01/1984'
	EXEC SP_1 '01/01/1970', '01/01/2000'

---===============================================================================
--2. List all employees (code, name, salary) whose salary more than 
--	 the average salary of the department that they work in.

go
CREATE PROC SP_2 
AS
BEGIN 
	SELECT n.MaNV AS code, n.HoNV + ' ' + n.TenLot + ' ' + n.TenNV AS name, 
		   n.Luong AS salary 		   										
	FROM NHANVIEN n
	WHERE n.Luong > (SELECT AVG(Luong) FROM NHANVIEN n2 WHERE n.Phg = n2.Phg)
END
go 

	--test 
	SELECT Phg, AVG(Luong) FROM NHANVIEN GROUP BY Phg
	EXEC SP_2

---===============================================================================
--3. List N employees that have the highest salary. 
--	N is the input parameter.

go
CREATE PROC SP_3 @N int 
AS
	SELECT TOP(@N) * FROM NHANVIEN ORDER BY Luong DESC
go 
	--test 
	EXEC SP_3 5

--4. Increase 10% for salary of all employees in the city A. 
--	 A is the input parameter.
SELECT * FROM NHANVIEN

go
CREATE PROC SP_4 @A varchar(30)
AS
	UPDATE NHANVIEN SET Luong = Luong * 1.1 WHERE DChi LIKE '%A%'
go 
	--test
	EXEC SP_4 'TPHCM' 
	
	/*
	để đảm bảo lương không đổi cho bài 2 sau khi test procedure này ta khôi phục database như ban đầu 
	UPDATE NHANVIEN SET Luong = 30000 WHERE MaNV = 123456789
	UPDATE NHANVIEN SET Luong = 40000 WHERE MaNV = 333445555
	UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 999887777
	UPDATE NHANVIEN SET Luong = 43000 WHERE MaNV = 987654321
	UPDATE NHANVIEN SET Luong = 38000 WHERE MaNV = 666884444
	UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 453453453
	UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 987987987
	UPDATE NHANVIEN SET Luong = 55000 WHERE MaNV = 888665555
	*/


---===============================================================================
--5. Delete all no personnel departments. 

go
CREATE PROC SP_5_C1
AS
	DELETE PHONGBAN WHERE MaPhg NOT IN (SELECT DISTINCT Phg FROM NHANVIEN) 

	--test: thêm 1 phòng ban chưa có nhân viên vào bảng Phòng ban 
	--		và 1 nhân viên chưa có phòng ban vào bảng Nhân viên 
	--		để xem có xóa đc phòng ban này ko 
	INSERT INTO PHONGBAN VALUES(0, 'No Employee', NULL, NULL)
	INSERT INTO NHANVIEN (MaNV) VALUES (999999999)
	SELECT * FROM PHONGBAN
	SELECT * FROM NHANVIEN
	EXEC SP_5_C1--(0 rows affected) --cách này sai khi test case của nv có Phòng NULL, 
				delete NHANVIEN where MANV = 999999999 --(1 row affected) chỉ đúng khi các gtri phòng trong bảng nv không có NULL 
go 
	
	------Answer-------

/*khi insert 2 gtri này vào thì lúc đếm ta có bảng như kết quả 
	INSERT INTO PHONGBAN VALUES(0, 'No Employee', NULL, NULL)
	INSERT INTO NHANVIEN (MaNV) VALUES (999999999)
		SELECT p.MaPhg, COUNT(n.MaNV) FROM NHANVIEN n FULL JOIN PHONGBAN p ON n.Phg = p.MaPhg GROUP BY p.MaPhg
				NULL	1
				0		0
				1		1
				4		3
				5		4
*/
go
CREATE PROC SP_5
AS
	BEGIN 
		DELETE PHONGBAN WHERE MaPhg IN (
										SELECT p.MaPhg FROM NHANVIEN n FULL JOIN PHONGBAN p ON n.Phg = p.MaPhg 
										   GROUP BY p.MaPhg
										   HAVING COUNT(n.MaNV) = 0
										) 
						--không dùng cách khác là NOT IN ( HAVING COUNT(n.MaNV) > 0) vì như thế sẽ bị lỗi giống C1 
	END 
	--test 
EXEC SP_5 --đã xóa đc và khắc phục đc lỗi C1 
go 

--***********
delete NHANVIEN where MANV = 999999999 --khôi phục data để làm Bài 2 
	SELECT * FROM PHONGBAN --3 rows 
	SELECT * FROM NHANVIEN --8 rows 
--***********
--II.	Write triggers to ensure
--1. The average salary of each department must be fewer than 50000.
	--nghĩa là khi làm bất cứ thao tác gì trên dữ liệu (thêm, sửa) đều phải đảm bảo lương trung bình của phòng ban đó < 50000
go
CREATE TRIGGER TR_AverageSalary ON NHANVIEN 
AFTER INSERT, UPDATE 
AS
BEGIN
	DECLARE @MaPB int, @AvgAfter float
	SELECT @MaPB = i.Phg FROM inserted i
	SELECT @AvgAfter = AVG(Luong) FROM NHANVIEN WHERE Phg = @MaPB
	
	IF @AvgAfter > 50000
		BEGIN 
			PRINT 'no insert/update, because the average salary of each department must be fewer than 50000'
			ROLLBACK TRANSACTION 
		END 
END

	--test 
	INSERT INTO NHANVIEN(MaNV, Luong, Phg) VALUES (999999999, 99999, 1)--k insert đc 
	UPDATE NHANVIEN SET Luong = 20000 WHERE MaNV = 999887777 --update đc 
	UPDATE NHANVIEN SET Luong = 200000 WHERE MaNV = 999887777 --ko update đc 
go

--khôi phục database cho câu sau 
UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 999887777 
DROP TRIGGER TR_AverageSalary
---===============================================================================
--2. The salary of the head of each department must be greater than or equal 
--	 to salary of all employees in this department.
go

CREATE TRIGGER TR_HeadSalary ON NHANVIEN 
AFTER INSERT, UPDATE 
AS
BEGIN
	DECLARE @headSalary int, @MaPB int, @insertNV char(9), @insertLuong int, @MaHead char(9)

	SELECT @MaPB = i.Phg, @insertLuong = i.Luong, @insertNV = i.MaNV FROM inserted i
	SELECT @headSalary = n.Luong, @MaHead = p.TrPhong FROM NHANVIEN n, PHONGBAN p 
		   WHERE n.Phg = @MaPB AND p.TrPhong = n.MaNV
		  
	IF @MaHead <> @insertNV
	BEGIN 
		IF @headSalary < @insertLuong
		BEGIN 
			PRINT 'no insert/update, the salary must be fewer than head'
			ROLLBACK TRANSACTION 
		END 
	END
END
 
 select * from NHANVIEN
	--test 
	INSERT INTO NHANVIEN(MaNV, Luong, Phg) VALUES (999999999, 99999, 1)--k insert đc do lương head phòng 1 = 55000
	INSERT INTO NHANVIEN(MaNV, Luong, Phg) VALUES (999999999, 9999, 1)--insert đc 
	UPDATE NHANVIEN SET Luong = 30000 WHERE MaNV = 999887777 --ko update đc do lương head phòng 4 = 25000
	UPDATE NHANVIEN SET Luong = 10000 WHERE MaNV = 999887777 --update đc vì <= lương head phòng 4 = 25000
	UPDATE NHANVIEN SET Luong = 45000 WHERE MaNV = 987987987 -- update đc vì đây là update lương của head dù lương head phòng 4 = 25000 < 45000
go

--khôi phục database cho câu sau 
DROP TRIGGER TR_HeadSalary
DELETE NHANVIEN WHERE MaNV = 999999999
UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 999887777 
UPDATE NHANVIEN SET Luong = 25000 WHERE MaNV = 987987987 

---===============================================================================
--3. The different between average salary of employees in HCM and HN must fewer than 10000.
go
CREATE TRIGGER TR_DifferSalary ON NHANVIEN 
AFTER INSERT, UPDATE, DELETE  
AS
BEGIN
	DECLARE @AvgHN int, @AvgHCM int, @flag int = 0  

	IF EXISTS(SELECT * FROM inserted i WHERE i.DChi LIKE '%TPHCM%' OR i.DChi LIKE '%HaNoi%')--trong TH INSERT & UPDATE 
		SET @flag = 1 
	IF EXISTS(SELECT * FROM deleted d WHERE d.DChi LIKE '%TPHCM%' OR d.DChi LIKE '%HaNoi%')--trong TH DELETE  
		SET @flag = 1 
	
	IF(@flag = 1)
	BEGIN 
		SELECT @AvgHN = AVG(Luong) FROM NHANVIEN WHERE DChi LIKE '%HaNoi%' 
		SELECT @AvgHCM = AVG(Luong) FROM NHANVIEN WHERE DChi LIKE '%TPHCM%'

		IF ABS(@AvgHN - @AvgHCM) > 10000
			BEGIN
				PRINT 'no insert/update/delete. Different between average salary of employees in HCM and HN must fewer than 10000'
				ROLLBACK 
			END
	END
END 
go 
DROP TRIGGER 	TR_DifferSalary
---===============================================================================
--4. There is not group that have more than five employees that are in the same family.
go
CREATE TRIGGER TR_CheckLimitEmployee ON NHANVIEN 
FOR INSERT 
AS
BEGIN	
	DECLARE @SoNV int, @MaPB int 
	SELECT @MaPB = i.Phg FROM inserted i
	SELECT @SoNV = COUNT(*) FROM NHANVIEN WHERE Phg = @MaPB

	IF @SoNV > 5
	BEGIN
		PRINT 'No more 5 employees in a department!'
		ROLLBACK 
	END
END

		--test 
		--số nv của phòng 5 trong database lúc này là 4, thử thêm 2 nv cho phòng 5 nữa 
		INSERT INTO NHANVIEN(MaNV, Phg) VALUES (10000,5)-- insert đc vì mới là nv thứ 5 của phòng 5 
		INSERT INTO NHANVIEN(MaNV, Phg) VALUES (10006,5)-- ko insert đc vì là nv thứ 6 của phòng 5 
		SELECT * FROM NHANVIEN
GO

--khôi phục database cho câu sau 
	DELETE NHANVIEN WHERE MaNV = 10000
	DROP TRIGGER TR_CheckLimitEmployee

---===============================================================================
--5. The different between number of male and female employees must fewer than 10%.
go
CREATE TRIGGER TR_DifferSex ON NHANVIEN 
AFTER INSERT, UPDATE, DELETE  
AS
BEGIN
	DECLARE @female int, @male int, @tong int, @differ float 
	SELECT @tong = COUNT(*) FROM NHANVIEN
	SELECT @female = COUNT(*) FROM NHANVIEN WHERE Phai = 'Nu'
	SELECT @male = COUNT(*) FROM NHANVIEN WHERE Phai = 'Nam'
	SET @differ = ABS((CONVERT (float, @female) - CONVERT (float, @male))/ @tong*100) 	

	IF @differ > 10 
		BEGIN
			PRINT 'differ = ' +  CONVERT(varchar(10),@differ) + '%'
			PRINT 'no insert/update/delete. The different between number of male and female employees must fewer than 10%.'
			ROLLBACK 
		END	
END 
go 
	--test 
	INSERT INTO NHANVIEN (MaNV, PHAI) VALUES ('1111111', 'Nam')
DROP TRIGGER TR_DifferSex
