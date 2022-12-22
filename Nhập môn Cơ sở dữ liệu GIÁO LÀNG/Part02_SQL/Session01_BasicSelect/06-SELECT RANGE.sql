USE Northwind
-----------------------------------------------------
--	LÝ THUYẾT 
--	CÚ PHÁP MỞ RỘNG LỆNH SELECT
--	KHI CẦN LỌC DỮ LIỆU TRONG 1 ĐOẠN CHO TRƯỚC, THAY VÌ DÙNG >= ... AND <= ..., 
--	TA CÓ THỂ THAY THẾ BẰNG MỆNH ĐỀ BETWEEN, IN 
--	* Cú pháp: CỘT BETWEEN VALUE1 AND VALUE2
--						   >>>>>> BETWEEN THAY THẾ CHO 2 MỆNH ĐỀ >= <= AND 
--							THAY THẾ CHO AND CỦA 1 KHOẢNG 
--
--	* Cú pháp CỘT IN (1 tập các giá trị đc liệt kê cách nhau dấu phẩy)
--					  >>>>>> IN THAY THẾ CHO 1 LOẠT OR 
-----------------------------------------------------

--	1. Liệt kê danh sách nhân viên sinh trong năm 1960...1970
SELECT * FROM Employees WHERE YEAR(BirthDate) >= 1960 AND YEAR(BirthDate) <= 1970 --4
SELECT * FROM Employees WHERE YEAR(BirthDate) BETWEEN 1960 AND 1970 --4

--	2. Liệt kê các đơn hàng có trọng lượng từ 100...500 
SELECT * FROM Orders WHERE Freight BETWEEN 100 AND 500 -- 174 

--	3. Liệt kê đơn hàng gửi tới Anh, Pháp, Mỹ 
SELECT * FROM Orders WHERE ShipCountry = 'UK' OR ShipCountry = 'France' OR ShipCountry = 'USA' --255
SELECT * FROM Orders WHERE ShipCountry IN ('UK', 'France', 'USA')  --255

--	4. Liệt kê đơn hàng KO gửi tới Anh, Pháp, Mỹ 
SELECT * FROM Orders WHERE NOT(ShipCountry = 'UK' OR ShipCountry = 'France' OR ShipCountry = 'USA') --575
SELECT * FROM Orders WHERE ShipCountry NOT IN ('UK', 'France', 'USA')  --575 

--	5. Liệt kê các đơn hàng trong năm 1996 ngoại trừ các tháng 6 7 8 9  
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1996 AND MONTH(OrderDate) NOT IN(6, 7, 8, 9) --82
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1996 AND NOT(MONTH(OrderDate) BETWEEN 6 AND 9) --82

--	LƯU Ý: CHỈ KHI TA LIỆT KÊ ĐC TẬP GIÁ TRỊ THÌ MỚI CHƠI IN 
--	KHOẢNG SỐ THỰC THÌ KO LÀM ĐƯỢC 
--	6. Liệt kê các đơn hàng có trọng lượng từ 100...110
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 110 ORDER BY Freight DESC --14
SELECT * FROM Orders WHERE Freight BETWEEN 100 AND 110 ORDER BY Freight DESC --14 

SELECT * FROM Orders WHERE Freight IN() -- 100...110 VỐ SỐ GIÁ TRỊ THỰC 
--IN CHỈ DÙNG CHO TẬP HỢP RỜI RẠC ĐƯỢC LIỆT KÊ HOY 








----------------------------------------------------------
SELECT * FROM Employees WHERE YEAR(BirthDate) BETWEEN 1960 AND 1970 
						ORDER BY BirthDate DESC
SELECT * FROM Orders WHERE Freight BETWEEN 100 AND 500 ORDER BY Freight
SELECT * FROM Orders WHERE ShipCountry = 'USA' OR ShipCountry = 'FRANCE'OR ShipCountry = 'UK'
SELECT * FROM Orders WHERE ShipCountry IN ('USA', 'FRANCE', 'UK')
SELECT * FROM Orders WHERE NOT(ShipCountry = 'USA' OR ShipCountry = 'FRANCE'OR ShipCountry = 'UK')
SELECT * FROM Orders WHERE ShipCountry NOT IN ('USA', 'FRANCE', 'UK')
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1996 AND MONTH(OrderDate) NOT IN (6,7,8,9)