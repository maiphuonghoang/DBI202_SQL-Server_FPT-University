USE Northwind
-----------------------------------------------------
--	LÝ THUYẾT 
--	CÚ PHÁP MỞ RỘNG:
--	Trong thực tế có những lúc dữ liệu/info chưa xác định được nó là gì?
--	kí tên danh sách thi, danh sách kí tên có cột điểm, điểm ngay lúc kí tên
--	chưa xác định được. Từ từ sẽ có, sẽ update sau 
--	Hiện tượng dữ liệu chưa xác định, chưa biết, từ từ đưa vào sau, hiện nhìn vào 
--	chưa thấy có data, thì ta gọi giá trị chưa xác định này là NULL
--	NULL ĐẠI DIỆN CHO THỨ CHƯA XĐ, CHƯA XĐ TỨC LÀ KO CÓ GIÁ TRỊ, KO CÓ GIÁ TRỊ 
--	THÌ KO THỂ SO SÁNH > >= < <= = !=
--	CẤM TUYỆT ĐỐI XÀI CÁC TOÁN TỬ SO SÁNH KÈM VỚI GIÁ TRỊ NULL
--	TA DÙNG TOÁN TỬ, IS NULL, IS NOT NULL, NOT (IS NULL) ĐỂ FILTER CELL CÓ 
--	GIÁ TRỊ NULL 
-----------------------------------------------------

-- THỰC HÀNH 
--	1. In ra danh sách nhân viên 
SELECT * FROM Employees

--	2. Ai chưa xác định khu vực ở, region null
SELECT * FROM Employees WHERE Region = 'NULL'  -- 0, vì ko ai ở khu vự tên là NULL
SELECT * FROM Employees WHERE Region = NULL -- NULL K ĐC DÙNG TOÁN TỬ SO SÁNH VÌ NÓ K MANG GÍA TRỊ 
SELECT * FROM Employees WHERE Region IS NULL --4

--	3. Những ai đã xác định đc khu vực cư trú ?
SELECT * FROM Employees WHERE Region IS NOT NULL  --5 -- IS NOT LÀ PHỦ ĐỊNH 
SELECT * FROM Employees WHERE Region NOT IS NULL --sai 
SELECT * FROM Employees WHERE NOT(Region IS NULL) -- NOT PHẢI ĐI KÈM VỚI MỆNH ĐỀ 

--	4. Những nhân viên đại diện kinh doanh và xác định đc nơi cư trú 
SELECT * FROM Employees WHERE Title = 'Sales Representative' AND Region IS NOT NULL --3 

--	5. Liệt kê danh sách khách hàng đến từ Anh Pháp Mỹ, có cả thông tin số fax và region 
SELECT * FROM Customers WHERE Country IN ('UK', 'France', 'USA')
						AND Fax IS NOT NULL AND NOT(Region IS NULL) --9/92 


-------------------------------------------
SELECT * FROM Employees WHERE Region IS NULL
SELECT * FROM Employees WHERE Region IS NOT NULL
SELECT * FROM Employees WHERE NOT (Region IS NULL)
SELECT * FROM Employees WHERE Title = 'Sales Representative' AND NOT(Region IS NULL)
SELECT * FROM Employees WHERE Title = 'Sales Representative' AND Region IS NOT NULL
SELECT * FROM Customers WHERE Country IN ('UK', 'USA') AND Fax IS NOT NULL AND NOT (Region IS NULL) 

