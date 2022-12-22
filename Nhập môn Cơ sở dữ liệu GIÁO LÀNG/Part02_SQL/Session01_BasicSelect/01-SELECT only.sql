USE Northwind -- Chọn để chơi với thùng chứa data nào đó
			  -- tại 1 thời điểm chơi với 1 thùng chứa data

SELECT * FROM Customers

-----------------------------------------------------------
-- LÍ THUYẾT 
-- 1. DBE cung cấp câu lệnh SELECT dùng để
--	  in ra màn hình 1 cái gì đó ~~~ printf() sout()
--	  in ra dữ liệu có trong table (hàng/cột) !!!!!!
--    dùng cho mục đích nào thì kết quả hiển thị luôn là 1 table 

-----------------------------------------------------------

--  1. Hôm nay ngày bao nhiêu?
SELECT GETDATE()

SELECT GETDATE() AS [Hôm nay là ngày]

--	2. Bây giờ tháng mấy hỡi em?
SELECT YEAR(GETDATE()) 

SELECT MONTH(GETDATE()) AS [Bây giờ là tháng mấy?]

--	3. Trị tuyệt đối của -5 là mấy?
SELECT ABS(-5) AS [Trị tuyệt đối của -5 là]

--	4. 5 + 5 là mấy 
SELECT 5 + 5 AS [5 + 5 là]

--	5. In ra tên của mình 
SELECT N'Hoàng Ngọc Trinh' AS [My fullname is]
--		N'' để in chuỗi tiếng việt 

SELECT N'Hoàng' + N'Ngọc Trinh' AS [My fullname is]

--	6. Tính tuổi 
SELECT YEAR(GETDATE()) - 2003 
SELECT N'Hoàng Ngọc Trinh' + (YEAR(GETDATE()) - 2003) + ' years old' 
						-- số ghép với chữ nên hơi bị hẫng tí, ko đồng nhất về dữ liệu 
						-- phải convert từ số thành chuỗi thì mới ghép được 
SELECT N'Hoàng Ngọc Trinh' + CONVERT(VARCHAR, YEAR(GETDATE()) - 2003) + ' years old' 

SELECT N'Hoàng Ngọc Trinh' + CAST(YEAR(GETDATE()) - 2003 AS varchar) + ' years old' AS [My profile]
																						-- dấu ngoặc vuông dùng trong trường hợp có dấu cách 
SELECT N'Hoàng Ngọc Trinh' + CAST(YEAR(GETDATE()) - 2003 AS varchar) + ' years old' AS MyProfile
