USE Northwind

-----------------------------------------------------
--	LÝ THUYẾT 
--	CÚ PHÁP MỞ RỘNG:
--	MỆNH ĐỀ WHERE: DÙNG LÀM BỘ LỌC/FILTER/NHẶT RA NHỮNG DỮ LIỆU TA CẦN THEO 1 TIÊU CHÍ NÀO ĐÓ 
--	VÍ DỤ: Lọc ra những sv có quê ở Bình Dương 
--		   Lọc ra những sv có quê ở Tiền Giang và điểm tb >= 8

--	CÚ PHÁP DÙNG BỘ LỌC
--	SELECT * (cột bạn muốn in ra) FROM <TÊN-TABLE> WHERE <ĐIỀU KIỆN LỌC>
--	* ĐIỀU KIỆN LỌC: TÌM TỪNG DONG, VỚI CÁI-CỘT CÓ GIÁ TRỊ CẦN LỌC
--					 LỌC THEO TÊN CỘT VỚI VALUE THẾ NÀO, LẤY TÊN CỘT, XEM VALUE TRONG CELL
--					 CÓ THỎA ĐIỀU KIỆN LỌC HAY KO?
--	ĐỂ VIẾT ĐK LỌC TA CẦN 
--		tên cột
--		value của cột (cell)
--		toán tử (operators) > >= < <= = (một dấu = hoy, ko giống C Java ==), !=, <> (not bằng hoặc khác cùng ý nghĩa ) 
--		nhiều đk lọc đi kèm, dùng thêm logic operators, AND, OR, NOT (~~~ J, C: && || !)
--	VÍ DỤ: WHERE City = N'Bình Dương'
--		   WHERE City = N'Tiền Giang' AND Gpa >= 8 

--	LỌC LIÊN QUAN ĐẾN GIÁ TRỊ/VALUE/CELL CHỨA GÌ, TA PHẢI QUAN TÂM ĐẾN DATA TYPES
--	Số: nguyên/thực, ghi số ra như truyền thống 5, 10, 3.14, 9.8
--	Chuỗi/kí tự: 'A', 'Ahihi'
--	Ngày tháng: '2003-01-01'

-----------------------------------------------------
-- THỰC HÀNH
--	1. In ra danh sách các khách hàng 
SELECT * FROM Customers

--	2. In ra ds kh đến từ Ý 
SELECT * FROM Customers WHERE Country = 'Italy'  --3/92

--	3. In ra ds kh đến từ Mỹ 
SELECT * FROM Customers WHERE Country = 'USA'  -- 13/92 

--	4. In ra những k/h đến từ Mỹ, Ý
--	đời thường có thể nói: những k/h đến từ Ý và Mỹ, Ý hoặc Mỹ 
SELECT * FROM Customers WHERE Country = 'Italy' OR Country = 'USA' -- 16/92
SELECT * FROM Customers WHERE Country = 'Italy' AND Country = 'USA'  -- 0/92 

-- sort theo Ý, Mỹ để gom cùng cụm cho dễ theo dõi 
SELECT * FROM Customers WHERE Country = 'Italy' OR Country = 'USA' ORDER BY Country

--	5. In ra k/h đến từ thủ đô nước Đức
SELECT * FROM Customers WHERE Country = 'Germany' AND City = 'Berlin'
		-- bôi đen đoạn đức 11/92				 bôi đen cả đoạn sau 1/11/92 

--	6. In ra thông tin của nhân viên
SELECT * FROM Employees

--	7. In ra thông tin của nhân viên có năm sinh từ 1960 trở lại gần đây/đổ lại
SELECT * FROM Employees WHERE YEAR(BirthDate) >= 1960  -- 4/9

--	8. In ra thông tin nhân viên có tuổi từ 60 trở lên 
SELECT YEAR(GETDATE()) - YEAR(BirthDate) AS Age, *   -- mún cột age lên đầu cho dễ nhìn 
			FROM Employees WHERE YEAR(GETDATE()) - YEAR(BirthDate) >= 60  -- 6/9

--	9. Những nv nào ở Luân Đôn
SELECT * FROM Employees WHERE City = 'London'  -- 4/9

--	10. Những nv nào ko ở London
SELECT * FROM Employees WHERE City != 'London'  -- 5/9
SELECT * FROM Employees WHERE City <> 'London'  -- 5/9
-- vi diệu
-- ĐẢO MỆNH ĐỀ !!!!   NOT + MĐ
SELECT * FROM Employees WHERE NOT(City = 'London')
SELECT * FROM Employees WHERE !(City = 'London')  -- SAI CÚ PHÁP, ĐẢO MỆNH ĐỀ/PHÉP SS THÌ DÙNG NOT 

--	11. In ra hồ sơ nhân viên có mã số là 1 
--	đi vào ngân hàng giao dịch, hoặc đưa số tk, kèm cmnd, filter theo cmnd 
SELECT * FROM Employees WHERE EmployeeID = 1 -- KIỂU SỐ, HOK CÓ '', chơi như lập trình 
-- WHERE TRÊN KEY CHỈ RA 1 MÀ THÔI 
-- SELECT MÀ CÓ WHERE KEY CHỈ 1 DÒNG TRẢ VỀ, DISTINCT LÀ VÔ NGHĨA 
SELECT DISTINCT EmployeeID, City FROM Employees WHERE EmployeeID = 1 
SELECT DISTINCT * FROM Employees WHERE EmployeeID = 1 -- BỊ KHỰNG ĐOẠN * 
													  -- do có kiểu dữ liệu nhị phân ở bức ảnh 
													  -- vì nó k distinct được, so 2 file nhị phân là có vấn đề 
-- CÔNG THỨC FULL KO CHE CỦA SELECT 
-- SELECT ...		FROM ...	WHERE ... GROUP BY ... HAVING ... ORDER BY ...
--		 DISTINCT		 1, N TABLE
--			HÀM()
--			NESTED QUERY/SUB QUERY 

--	12. Xem thông tin bên Đơn hàng
SELECT * FROM Orders  -- 830 

--	13. Xem thông tin bên Đơn hàng sắp xếp giảm dần theo trọng lượng 
SELECT * FROM Orders ORDER BY Freight DESC

--	14. In thông tin bên Đơn hàng sắp xếp giảm dần theo trọng lượng, trọng lượng >= 500kg 
SELECT * FROM Orders WHERE Freight >= 500 ORDER BY Freight DESC  --13

--	15. In thông tin bên Đơn hàng sắp xếp giảm dần theo trọng lượng, trọng lượng 
--	nằm trong khoảng từ 100 đến 500
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 500 ORDER BY Freight DESC  --174 
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 500 ORDER BY ShipVia

--	16. In thông tin bên Đơn hàng sắp xếp giảm dần theo trọng lượng, trọng lượng 
--	nằm trong khoảng từ 100 đến 500 và ship bởi công ty giao vận số 1 
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 500 AND ShipVia = 1 ORDER BY Freight DESC --52

--	17. In thông tin bên Đơn hàng trọng lượng nằm trong khoảng từ 100 đến 500 
--	và ship bởi công ty giao vận số 1 và k ship tới London
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 500 AND ShipVia = 1 AND ShipCity <> 'London'    --50 
SELECT * FROM Orders WHERE Freight >= 100 AND Freight <= 500 AND ShipVia = 1 AND NOT(ShipCity = 'London')--50 

--	RẤT CẨN THẬN KHI TRONG MỆNH ĐỀ WHERE LẠI CÓ AND OR TRỘN VỚI NHAU, TA PHẢI XÀI THÊM ()
--	ĐỂ PHÂN TÁCH THỨ TỰ FILTER... (SS AND OR KHÁC NỮA) AND (SS KHÁC)

--	18. Liệt kê k/h đến từ Mỹ hoặc Mexico
SELECT * FROM Customers WHERE Country = 'USA' AND Country = 'Mexico' -- 0 
									-- 1 cell không thể chứa 2  value 
SELECT * FROM Customers WHERE Country = 'USA' OR Country = 'Mexico' -- 18 

--	19. Liệt kê k/h KO đến từ Mỹ hoặc Mexico
SELECT * FROM Customers WHERE NOT(Country = 'USA' OR Country = 'Mexico') -- 73 
SELECT * FROM Customers WHERE Country <> 'USA' AND Country != 'Mexico' -- 73

--	20. Liệt kê các nhân viên sinh ra trong đoạn [1960-1970]
SELECT * FROM Employees WHERE YEAR(BirthDate) >= 1960 AND YEAR(BirthDate) <= 1970 ORDER BY BirthDate --4 








------------------------------------------------------------------------------------------------

SELECT * FROM Customers WHERE Country = 'ITALY'
SELECT * FROM Customers WHERE Country = 'USA'
SELECT * FROM Customers WHERE Country = 'USA' OR Country = 'Italy'
SELECT * FROM Customers WHERE Country = 'USA' OR Country = 'Italy' ORDER BY Country 
SELECT * FROM Customers WHERE Country = 'GERMANY' AND City = 'BERLIN'
SELECT * FROM Employees WHERE YEAR(BirthDate) >= 1960
SELECT *, (YEAR(GETDATE()) - YEAR(BirthDate)) AS AGE FROM Employees WHERE  YEAR(GETDATE()) - YEAR(BirthDate) >= 60
SELECT * FROM Employees WHERE City <> 'London'
SELECT * FROM Employees WHERE City != 'London'
--đảo mệnh đề NOT + MĐ
SELECT * FROM Employees WHERE NOT(City = 'London')
SELECT * FROM Employees WHERE EmployeeID = '1'
SELECT * FROM Orders
SELECT * FROM Orders ORDER BY Freight DESC
SELECT * FROM Orders WHERE Freight >= 500 ORDER BY Freight DESC
SELECT * FROM Orders WHERE Freight >= 100 AND Freight < 500 AND ShipVia = 1 ORDER BY Freight DESC
SELECT * FROM Orders WHERE Freight >= 100 AND Freight < 500 AND ShipVia = 1 AND NOT(ShipCity = 'LONDON')







