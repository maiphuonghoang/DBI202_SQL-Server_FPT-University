USE Northwind
-------------------------------------------------------
--	LÝ THUYẾT 
--	DB ENGINE hỗ trợ 1 loạt nhóm hàm dùng thao tác trên nhóm dòng/cột, gom data tính toán 
--	trên đám data gom này - nhóm hàm gom nhóm - AGGREGATE FUNCTIONS, AGGREGATION 
--	COUNT() SUM() MIN() AVG()

--*	CÚ PHÁP CHUẨN 
--	SELECT CỘT..., HÀM GOM NHÓM(),... FROM <TABLE>
--	SELECT CỘT..., HÀM GOM NHÓM(),... FROM <TABLE> WHERE (đang làm thì có where) ... GROUP BY... HAVING (where thứ 2 - làm xong thì where tiếp nữa )
 
-------------------------------------------------------
-- THỰC HÀNH 
--1. Liệt kê danh sách nhân viên 
SELECT * FROM Employees

--2. Năm sinh nào là bé nhất 
SELECT MIN(BirthDate) FROM Employees --1937 
SELECT BirthDate FROM Employees WHERE BirthDate <= ALL (SELECT BirthDate FROM Employees) --1937 

--3. Ai sinh năm bé nhất, in ra info 
SELECT * FROM Employees WHERE BirthDate <= ALL (SELECT BirthDate FROM Employees) -- lôi tập ngày sinh ra, quét qua, thì biết thằng nào bé hơn tất cả 
SELECT * FROM Employees WHERE BirthDate <= ALL (SELECT MIN(BirthDate) FROM Employees) -- k hay  

SELECT * FROM Employees WHERE BirthDate = (
											SELECT MIN(BirthDate) FROM Employees 
										   )

--4.1. Trọng lượng nào là lớn nhất trong các đơn hàng 
SELECT * FROM Orders ORDER BY Freight DESC
SELECT MAX(Freight) FROM Orders

--4.2. Trong các đơn hàng, đơn hàng nào có trọng lượng nặng/nhỏ nhất 
SELECT * FROM Orders WHERE Freight = (SELECT MAX(Freight) FROM Orders)
SELECT * FROM Orders WHERE Freight >= --ALL (TẤT CẢ CÁC TRỌNG LƯỢNG)  
										ALL(SELECT Freight FROM Orders)

--5. Tính tổng khối lượng của các đơn hàng đã vận chuyển 
SELECT SUM(Freight) AS [Freight in total] FROM Orders

--6. Trung bình các đơn hàng nặng bn 
SELECT AVG(Freight) FROM Orders --78.24

--7. Liệt kê các đơn hàng có trọng lượng nặng hơn trọng lượng trung bình của tất cả 
SELECT * FROM Orders WHERE Freight > (SELECT AVG(Freight) FROM Orders) --242 dòng 

--8. Có bn đơn hàng có trọng lượng nặng hơn trọng lượng trung bình của tất cả 
SELECT COUNT(*) FROM Orders 
				WHERE Freight > (
									SELECT AVG(Freight) FROM Orders 
					 -- chỉ những thằng lớn hơn trung bình thì mới đếm, HOK CHIA NHÓM À NHEN 
								) -- 242 only 


SELECT COUNT(*) FROM (
						SELECT * FROM Orders 
								 WHERE Freight > (
													SELECT AVG(Freight) FROM Orders
												  )
					 ) AS [AVG] -- bê nguyên cái bảng liệt kê 7 kia xuống


-- NHẮC LẠI 
-- CỘT XH TRONG SELECT HÀM Ý ĐẾM THEO CỘT NÀY, CỘT PHẢI XH TRONG GROUP BY 
					 
-- TỈNH, <ĐẾM CÁI GÌ ĐÓ CỦA TỈNH> -> RÕ RÀNG PHẢI CHIA THEO TỈNH MÀ ĐẾM 
													   -- GROUP BY TỈNH
-- CHUYÊN NGÀNH, <ĐẾM CỦA CN> -> CHIA THEO CN MÀ ĐẾM
							  -- GROUP BY CN
-- CÓ QUYỀN GROUP BY TRÊN NHIỀU CỘT 

-- MÃ CN, TÊN CN <SL SV> -> GROUP BY MÃ CN, TÊN CN

--ÔN TẬP THÊM
--1. In ra danh sách nhân viên 
SELECT * FROM Employees

--2. Đếm xem mỗi khu vực có bn nhân viên 
SELECT COUNT(*) FROM Employees --9NV 
SELECT Region, COUNT(*) FROM Employees GROUP BY Region --4(NULL)  5(WA)
									   -- 2 nhóm Region, 2 cụm Region: WA, NULL 
	-- ĐÚNG DO ĐẾM DÒNG

SELECT Region, COUNT(Region) FROM Employees GROUP BY Region --0(NULL) 5(WA)
											-- 2 cụm Region: NULL, WA 
-- đếm theo gtri Region, do NULL KO ĐC XEM LÀ VALUE ĐỂ ĐẾM, NHƯNG VẪN LÀ 1 VALUE ĐỂ ĐC CHIA NHÓM 
--															NHÓM KO CÓ GIÁ TRỊ 
	-- SAI DO ĐẾM NULL 

--3. Khảo sát đơn hàng
SELECT * FROM Orders
-- Mỗi quốc gia có bn đơn hàng
SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders GROUP BY ShipCountry

--4. Quốc gia nào có từ 50 đơn hàng trở lên 
SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders 
											GROUP BY ShipCountry
											HAVING COUNT(*) >= 50
--4. Quốc gia nào nhiều đơn hàng nhất 
SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders 
											GROUP BY ShipCountry
											HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM Orders 
																					GROUP BY ShipCountry)

-- coi 3 là 1 table 
SELECT MAX([No Orders]) FROM (
	SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders GROUP BY ShipCountry
) AS Country 
--lấy đc max rồi 

SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders 
											GROUP BY ShipCountry
											HAVING COUNT(*) = max 

SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders 
											GROUP BY ShipCountry
											HAVING COUNT(*) = --bê nguyên cái max vừa tìm xuống 
																(SELECT MAX([No Orders]) FROM (
																								SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders GROUP BY ShipCountry
																							   ) AS Country 
														        )

--6. Liệt kê các đơn hàng của k/h Vinet
SELECT * FROM Orders WHERE CustomerID = 'VINET'

--7. K/h VINET đã mua bn lần 
SELECT  CustomerID, COUNT(*) FROM Orders WHERE CustomerID = 'VINET' --ERROR 
		--C1 
SELECT  CustomerID, COUNT(*) FROM Orders 
							 WHERE CustomerID = 'VINET' -- CHIA THEO MÃ KH MÀ ĐẾM, CHIA NHÓM, ĐÚNG VINET MỚI ĐẾM, ĐỨA KHÁC K QUAN TÂM  
							 GROUP BY CustomerID 
							 -- LÚC THỰC THI, ĐÚNG VINET MỚI ĐẾM 
							 --nhanh hơn 		 

SELECT  CustomerID, COUNT(*) FROM Orders --NẾU K CÓ ĐK THÌ NÓ ĐẾM HẾT, KO CHIA THEO MÃ KH MÀ ĐẾM 
										 GROUP BY CustomerID 
		--C2
SELECT  CustomerID, COUNT(*) FROM Orders  
							 GROUP BY CustomerID 
							 HAVING CustomerID = 'VINET'
							 -- ĐẾM XONG, LOẠI ĐI CÁI THẰNG KO LÀ VINET - ĐẾM LẠI LẦN NỮA 
							 -- chậm hơn 

SELECT COUNT(*) FROM Orders WHERE CustomerID = 'VINET'




-----------------------------------------------------------------------------------------------
SELECT MIN(BirthDate) FROM Employees 
SELECT * FROM Employees WHERE BirthDate = --MIN
SELECT * FROM Employees WHERE BirthDate = (SELECT MIN(BirthDate) FROM Employees )
SELECT * FROM Employees WHERE BirthDate <= ALL(SELECT BirthDate FROM Employees)
SELECT * FROM Orders ORDER BY Freight DESC
SELECT * FROM Orders WHERE Freight = (SELECT MAX(Freight) FROM Orders)
SELECT SUM(Freight) AS [Freight in total] FROM Orders
SELECT AVG(Freight) AS [AVG freight] FROM Orders
SELECT * FROM Orders WHERE Freight >= (SELECT AVG(Freight) AS [AVG freight] FROM Orders)
SELECT COUNT(*) FROM Orders WHERE Freight >= (SELECT AVG(Freight) AS [AVG freight] FROM Orders)
SELECT COUNT(*) FROM (SELECT * FROM Orders WHERE Freight >= (SELECT AVG(Freight) AS [AVG freight] FROM Orders)) AS LonHonAvgTable 

SELECT Region, COUNT(Region) FROM Employees GROUP BY Region -- 0 & 5 --SAI DO ĐẾM TRÊN NULL  
SELECT Region, COUNT(*) FROM Employees GROUP BY Region --4(NULL) & 5(WA) --ĐÚNG DO ĐẾM DÒNG
SELECT ShipCountry, COUNT(*) FROM Orders GROUP BY ShipCountry
SELECT ShipCountry, COUNT(*) FROM Orders GROUP BY ShipCountry HAVING COUNT(*) >= 50

SELECT ShipCountry, COUNT(*) FROM Orders GROUP BY ShipCountry HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM Orders GROUP BY ShipCountry) 
SELECT MAX([No Orders]) FROM (SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders GROUP BY ShipCountry) AS MaxOrders --TÌM ĐC MAX 
SELECT ShipCountry, COUNT(*) FROM Orders GROUP BY ShipCountry HAVING COUNT(*) = (SELECT MAX([No Orders]) FROM (SELECT ShipCountry, COUNT(*) AS [No Orders] FROM Orders GROUP BY ShipCountry) AS MaxOrders )

SELECT * FROM Orders WHERE CustomerID = 'VINET'
SELECT CustomerID, COUNT(*) FROM Orders WHERE CustomerID = 'VINET' --LỖI 
		--Column 'Orders.CustomerID' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
SELECT CustomerID, COUNT(*) FROM Orders WHERE CustomerID = 'VINET' GROUP BY CustomerID
	--Muốn hiển thị Customer với số lượng kế bên thì phải chia theo customer mà đếm 
					--đúng vinet mới đếm, xong group by thì chỉ có mỗi vinet ~ lọc rồi đếm, nhanh hơn 
	
SELECT CustomerID, COUNT(*) FROM Orders GROUP BY CustomerID HAVING CustomerID = 'VINET'--đếm xong loại cái thằng ko là vinet 
					--đếm hết rồi mới lọc chậm hơn 