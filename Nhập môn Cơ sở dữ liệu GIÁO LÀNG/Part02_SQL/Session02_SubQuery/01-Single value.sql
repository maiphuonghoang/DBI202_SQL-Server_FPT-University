USE Northwind
-------------------------------------------------------
--	LÝ THUYẾT 
--	Cú pháp chuẩn của lệnh SELECT 
--	WHERE CỘT = VALUE NÀO ĐÓ 
--	WHERE CỘT LIKE PATTERN NÀO ĐÓ e.g. '____'
--	WHERE CỘT BETWEEN RANGE 
--	WHERE CỘT IN (TẬP HỢP GIÁ TRỊ ĐƯỢC LIỆT KÊ)

-- MỘT CÂU SELECT TÙY CÁCH VIẾT CÓ THỂ TRẢ VỀ ĐÚNG 1 VALUE/CELL
-- MỘT CÂU SELECT TÙY CÁCH VIẾT CÓ THỂ TRẢ VỀ ĐÚNG 1 TẬP GIÁ TRỊ/CELL
-- TẬP KẾT QUẢ NÀY ĐỒNG NHẤT (CÁC GIÁ TRỊ KHÁC NHAU CỦA 1 BIẾN)

--*****
-- WHERE CỘT = VALUE NÀO ĐÓ - đã học, e.g YEAR(DOB) = 2003
--			 = THAY VALUE NÀY = 1 CÂU SQL KHÁC MIỄN TRẢ VỀ 1 CELL 
-- KĨ THUẬT VIẾT CÂU SQL THEO KIỂU HỎI GIÁN TIẾP, LỒNG NHAU, 
-- TRONG CÂU SQL CHỨA CÂU SQL KHÁC 
-------------------------------------------------------
--THỰC HÀNH 
--1. In ra danh sách nhân viên 
SELECT * FROM Employees 
SELECT FirstName FROM Employees WHERE EmployeeID = 1 --1 cell/value 
SELECT FirstName FROM Employees --1 tập các giá trị/1 cột/phép chiếu 

--2. Liệt kê các nhân viên ở London
SELECT * FROM Employees WHERE City = 'London'--4

--3. Liệt kê các nhân viên cùng quê với King Robert 
SELECT City FROM Employees WHERE FirstName = 'Robert'
SELECT * FROM Employees WHERE City = City quê của Robert  
SELECT * FROM Employees WHERE City = 'London' - thay London = Robert 
SELECT * FROM Employees 
						WHERE City = (
										SELECT City FROM Employees WHERE FirstName = 'Robert'
										-- thằng Robert nó sang Paris éo phải London nữa, ở đây có sự linh hoạt, tương thích 
									 )
									 --4
-- Câu này 9.9 điểm, trong kq còn Robert bị dư, tìm cùng quê R
-- ko cần nói lại Robert 
SELECT * FROM Employees WHERE City = (
										SELECT City FROM Employees WHERE FirstName = 'Robert'
										-- thằng Robert nó sang Paris éo phải London nữa, ở đây có sự linh hoạt, tương thích 
									 )
									 --4
							  AND FirstName <> 'Robert' --3

--4. Liệt kê tất cả các đơn hàng 
SELECT * FROM Orders ORDER BY Freight DESC 

--4.1 Liệt kê tất cả các đơn hàng có trọng lượng lớn hơn 252 kg 
SELECT * FROM Orders WHERE Freight >= 252 --47

--4.2 Liệt kê tất cả các đơn hàng có trọng lượng lớn hơn trọng lương đơn hàng 10555 
SELECT * FROM Orders WHERE Freight >= ??? CỦA ĐƠN HÀNG 10555 
SELECT * FROM Orders 
		 WHERE Freight >= (
							SELECT Freight FROM Orders 
										   WHERE OrderID = '10555'
						  )--47 xuất hiện luôn cả 10555 
			   AND OrderID != '10555' --46 

--1. Liệt kê danh sách các công ty vận chuyển hàng
SELECT * FROM Shippers --4

--2. Liệt kê danh sách các đơn hàng đc vẩn chuyển bởi công ty giao vận 
--	 có mã số là 1
SELECT * FROM Orders WHERE ShipVia = 1

--3. Liệt kê danh sách các đơn hàng đc vận chuyển bởi cty giao vận 
-- có tên là Speedy Express 
SELECT * FROM Orders 
		 WHERE ShipVia = (
							SELECT ShipperID FROM Shippers 
											 WHERE CompanyName = 'Speedy Express'
						  )  --3

--4. Liệt kê danh sách các đơn hàng đc vận chuyển bởi cty giao vânh 
-- có tên là Speedy Express và có trọng lượng từ 50-100
SELECT * FROM Orders 
		 WHERE ShipVia = (
							SELECT ShipperID FROM Shippers 
											 WHERE CompanyName = 'Speedy Express'
						  ) 
		 AND Freight BETWEEN 50 AND 100

SELECT * FROM Orders WHERE ShipVia = (
										SELECT ShipperID FROM Shippers 
											 WHERE CompanyName = 'Speedy Express'
									 ) 
					 AND Freight >= 50 AND Freight <= 100

SELECT * FROM Orders WHERE ShipVia = (
										SELECT ShipperID FROM Shippers 
											 WHERE CompanyName = 'Speedy Express'
									 ) 
					 AND Freight IN (50,100) -- SAI, IN LÀ SO SÁNH =, THAY CHO 1 ĐỐNG OR 

--5. Liệt kê các mặt hàng cùng chủng loại với mặt hàng Filo Mix
--	Chủng loại của Filo Mix 
--	Filo Mix là sp/mặt hàng, thuộc nhóm gì mình chưa biết 
SELECT * FROM Products WHERE CategoryID = (
											SELECT CategoryID FROM Products 
															  WHERE ProductName = 'Filo Mix'
										  ) --7

--6. Liệt kê các nhân viên trẻ tuổi hơn nhân viên Janet 
--	TRẺ HƠN TỨC LÀ NĂM SINH > JANET 
SELECT * FROM Employees WHERE BirthDate > (SELECT BirthDate FROM Employees WHERE FirstName = 'Janet') --1






----------------------------------------------------------------------------------------
 SELECT * FROM Employees WHERE City = ('London')
 SELECT * FROM Employees WHERE City = (SELECT City FROM Employees WHERE FirstName = 'Robert')
	--chưa loại thằng robert đi 
SELECT * FROM Employees WHERE City = (SELECT City FROM Employees WHERE FirstName = 'Robert')
							  AND FirstName <> 'Robert'
SELECT * FROM Orders WHERE Freight >= 252
SELECT * FROM Orders WHERE Freight >= (SELECT Freight FROM Orders WHERE OrderID = 10555)
						   AND OrderID != 10555   --vì ở đây là >= nên có cả 10555 

SELECT * FROM Shippers
SELECT * FROM Orders WHERE ShipVia = 1
SELECT * FROM Orders WHERE ShipVia = (SELECT ShipperID FROM Shippers WHERE CompanyName = 'Speedy Express')
SELECT * FROM Orders WHERE ShipVia = (SELECT ShipperID FROM Shippers WHERE CompanyName = 'Speedy Express')
						   AND Freight BETWEEN 50 AND 100
						   AND Freight >= 50 AND Freight <= 100 
SELECT * FROM Products WHERE CategoryID = (SELECT CategoryID FROM Products WHERE ProductName = 'Filo Mix')
							 AND ProductName <> 'Filo Mix'
SELECT * FROM Employees WHERE YEAR(BirthDate) > (SELECT YEAR(BirthDate) FROM Employees WHERE FirstName = 'Janet')






