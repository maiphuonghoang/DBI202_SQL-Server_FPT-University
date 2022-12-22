USE Northwind
-------------------------------------------------------
--	LÝ THUYẾT 
--	DB ENGINE hỗ trợ 1 loạt nhóm hàm dùng thao tác trên nhóm dòng/cột, gom data tính toán 
--	trên đám data gom này - nhóm hàm gom nhóm - AGGREGATE FUNCTIONS, AGGREGATION 
--	COUNT() SUM() MIN() AVG()

--	* CÚ PHÁP CHUẨN 
--	SELECT CỘT..., HÀM GOM NHÓM(),... FROM <TABLE>

--	* CÚ PHÁP MỞ RỘNG 
--	SELECT CỘT, HÀM GOM NHÓM(),... FROM <TABLE>...WHERE...GROUP BY (GOM THEO CỤM CỘT NÀO)

--	SELECT CỘT, HÀM GOM NHÓM(),... FROM <TABLE>...WHERE...GROUP BY (GOM THEO CỤM CỘT NÀO) HAVING...

--	* HÀM COUNT(???) ĐẾM SỐ LẦN XUẤT HIỆN CỦA 1 CÁI GÌ ĐÓ???
--		  COUNT(*): ĐẾM SỐ DÒNG TRONG TABLE, ĐẾM TẤT CẢ CÁC DÒNG KO CARE TIÊU CHUẨN NÀO KHÁC 
--		  COUNT(*) FROM... WHERE ...
--						   CHỌN RA NHỮNG DÒNG THỎA TIÊU CHÍ NÀO ĐÓ TRƯỚC ĐÃ, RỒI MỚI ĐẾM 
--						   FILTER RỒI ĐẾM 

--		  COUNT(CỘT NÀO ĐÓ): 
-------------------------------------------------------

--1. In ra danh sách các nhân viên 
SELECT * FROM Employees

--2. Đếm xem có bao nhiêu nhân viên 
SELECT COUNT(*) FROM Employees
SELECT COUNT(*) AS [Number of Employees] FROM Employees

--3. Có bao nhiêu nv ở London 
SELECT COUNT(*) FROM Employees WHERE City = 'London'
SELECT COUNT(*) AS [No emps in London] FROM Employees WHERE City = 'London'

--4. Có bao nhiêu lượt thành phố xuất hiện - cứ xh tên tp là đếm, ko care lặp lại hay ko 
SELECT COUNT(City) FROM Employees --9

--5. Đếm xem có bao nhiêu Region 
SELECT COUNT(Region) FROM Employees --5
-- PHÁT HIỆN HÀM COUNT(CỘT), NẾU CELL CỦA CỘT CHỨA NULL, KO TÍNH, KO ĐẾM 
-- Đếm sự xuất hiện, null không được xem như là sự xuất hiện 

--6. Đếm xem có bao nhiêu khu vực null, có bao nhiêu dòng region null 
SELECT COUNT(*) FROM Employees WHERE Region IS NULL --4 đếm sự xh dòng chứa Region null 

SELECT COUNT(Region) FROM Employees WHERE Region IS NULL --0 vì null ko đếm đc, ko value 
			-- null là thằng vô diện, k đếm được 
			-- đếm trên giá trị của null thì làm gì có mà đếm 

SELECT * FROM Employees WHERE Region IS NULL --4  
		-- đếm null, đếm trên dòng xuất hiện 

--5. Có bao nhiêu thành phố trong table nv 
SELECT City FROM Employees --9 

SELECT DISTINCT City FROM Employees --5 
-- tui coi kết quả này là table, mất quá trời công sức để lọc ra 5 tp 

--	SUB QUERY MỚI, COI 1 CÂU SELECT LÀ 1 TABLE, BIẾN TABLE NÀY VÀO TRONG MỆNH ĐỀ FROM 
--	NGÁO 
SELECT * FROM 
		(SELECT DISTINCT City FROM Employees) AS Cities

SELECT COUNT(*) FROM 
		(SELECT DISTINCT City FROM Employees) AS Cities --5 City 
		--filter data cho mình trước rồi mới đếm 

SELECT COUNT(*) FROM Employees -- 9 NV 
SELECT COUNT(City) FROM Employees --9 City 
SELECT COUNT(DISTINCT City) FROM Employees --5 City 
		--trong quá tình đếm mới filter 

--8. Đếm xem MỖI thành phố có bao nhiêu nhân viên 
--	KHI CÂU HỎI CÓ TÍNH TOÁN GOM DATA (HÀM AGGREGATE) MÀ LẠI CHỨA TỪ KHÓA MỖI...
--	GẶP TỪ "MỖI", CHÍNH LÀ CHIA ĐỂ TRỊ, CHIA CỤM ĐỂ GOM ĐẾM 
SELECT * FROM Employees

--Seattle 2 | Tacoma 1 | Kirland 1 | Readmon 1 | London 4
-- Đếm theo sự xh của nhóm, count++ trong nhóm thoy, sau đó reset ở nhóm mới 
SELECT COUNT(City) FROM Employees GROUP BY City -- ĐẾM VALUE CỦA CITY, NHƯNG ĐẾM THEO NHÓM 
												-- CHIA CITY THÀNH NHÓM, RỒI ĐẾM TRONG NHÓM 

SELECT City, COUNT(City) AS [No employees] FROM Employees GROUP BY City

SELECT EmployeeID, City, COUNT(City) AS [No employees] FROM Employees GROUP BY City
						-- count city của tất cả các ông nhân viên hay count city của ông nhân viên đó 
						-- hay count city của những ông nv tùng với thành phố đó
						--câu này AMBIGOUS, mơ hồ, éo chạy đc  
SELECT EmployeeID, City, COUNT(City) AS [No employees] FROM Employees GROUP BY City, EmployeeID
-- IN RA MÃ NV 
--	1 London  1
--	2 Seattle 1 
--	3         1
--	4		  1 
-- muốn in mã nv và city thì bắt buộc phải đếm theo city của nv đó thôi chứ nv khác làm sao đc 

--CHỐT HẠ: KHI XÀI HÀM GOM NHÓM, BẠN CÓ QUYỀN LIỆT KÊ TÊN CỘT LẺ Ở SELECT 
--		   NHƯNG CỘT LẺ ĐÓ BẮT BUỘC PHẢI XUẤT HIỆN TRONG MỆNH ĐỀ GROUP BY 
--		   ĐỂ ĐẢM BẢO LOGIC: CỘT HIỂN THỊ | SỐ LƯỢNG ĐI KÈM, ĐẾM GOM THEO CỘT HIỂN THỊ MỚI LOGIC
--	CỨ THEO CỘT CITY MÀ GOM, CỘT CITY NẰM Ở SELECT HỢP LÍ 
--	MUỐN HIỂN THỊ SỐ LƯỢNG CỦA AI ĐÓ, GÌ ĐÓ, GOM NHÓM THEO CÁI GÌ ĐÓ  

--	NẾU BẠN GOM NHÓM THEO KEY/PK, VÔ NGHĨA HENG, VÌ KEY HOK TRÙNG, MỖI THẰNG 1 NHÓM, ĐẾM CÁI GÌ???

-- MÃ SỐ SV --- ĐẾM CÁI GÌ??? VÔ NGHĨA 
-- MÃ CHUYÊN NGÀNH -- ĐẾM SỐ SV CHUYÊN NGÀNH!!!
-- MÃ QUỐC GIA --- ĐẾM SỐ ĐƠN HÀNG 
-- ĐIỂM THI -- ĐẾM SỐ LƯỢNG SV ĐẠT ĐC ĐIỂM ĐÓ 
-- CÓ CỘT ĐỂ GOM NHÓM, CỘT ĐÓ SẼ DÙNG ĐỂ HIỂN THỊ SỐ LƯỢNG KẾT QUẢ 

--9. Hãy cho tui biết thành phố nào có từ 2 nv trở lên 
--	2 chặng làm
--	9.1 Các tp có bao nhiêu nhân viên 
SELECT	City, COUNT(City) AS [No employees] FROM Employees GROUP BY City --đếm City  
SELECT	City, COUNT(*) AS [No employees] FROM Employees GROUP BY City --đếm dòng 
--	9.2 Đếm xong mỗi tp, ta bắt đầu lọc lại kết quả sau đếm 
--	FILTER SAU ĐẾM, WHERE SAU ĐẾM, WHERE SAU KHI ĐÃ GOM NHÓM, AGGREGATE THÌ GỌI LÀ HAVING 
SELECT	City, COUNT(*) AS [No employees] FROM Employees GROUP BY City 
														HAVING COUNT(*) >= 2

--10. Đếm số nhân viên của 2 thành phố Seattle và London 
SELECT COUNT(*)  FROM Employees WHERE City IN ('London', 'Seattle')  --6, k chia nhóm, 6 đứa 
SELECT COUNT(*)  FROM Employees WHERE City IN ('London', 'Seattle') GROUP BY City -- 4,2 
SELECT City, COUNT(*)  FROM Employees WHERE City IN ('London', 'Seattle') GROUP BY City

--11. Trong 2 thành phố Seattle và London, tp nào có nhiều hơn 3 nv 
SELECT City, COUNT(*)  FROM Employees 
						WHERE City IN ('London', 'Seattle') 
						GROUP BY City 
						HAVING COUNT(*) >3 


-- Thành phố nào có nhiều nhân viên nhất 

--12. Đếm xem có bn đơn hàng đã bán ra 
SELECT * FROM Orders
SELECT COUNT(*) AS [No Orders] FROM Orders --830

SELECT COUNT(OrderID) AS [No Orders] FROM Orders --830
--primary key
--830 mã đơn khác nhau, đếm mã đơn, hay đếm cả cái đơn là như nhau 
--nếu cột có value NULL ăn hành!!!

--12.1. Nước Mỹ có bn đơn hàng 
-- đi tìm Mỹ mà đếm, lọc Mỹ rồi tính tiếp, WHERE Mỹ 
-- KO PHẢI LÀ CÂU GOM CHIA NHÓM, HOK CÓ MỖI QUỐC GIA BAO NHIÊU ĐƠN, 
-- MỖI QUỐC GIA CÓ BN ĐƠN, COUNT THEO QUỐC GIA, GROUP BY THEO QUỐC GIA 
SELECT COUNT(*) AS [No USA Orders] FROM Orders WHERE ShipCountry = 'USA'

--12.2. Mỹ Anh Pháp chiếm tổng cộng bao nhiêu đơn hàng
SELECT COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France')--255
SELECT COUNT(*) FROM Orders WHERE ShipCountry = 'USA' OR ShipCountry = 'UK' OR ShipCountry = 'France'--255

--12.3. Mỹ, Anh, Pháp, mỗi quốc gia có bao nhiêu đơn hàng 
SELECT ShipCountry, COUNT(*) FROM Orders 
							 WHERE ShipCountry IN ('USA', 'UK', 'France') 
							 GROUP BY ShipCountry --77, 56, 122 = 255

--12.4 Trong 3 quốc gia  Mỹ Anh Pháp, qgia nào có từ 100 đơn hàng trở lên 
SELECT ShipCountry, COUNT(*) FROM Orders 
							 WHERE ShipCountry IN ('USA', 'UK', 'France') 
							 GROUP BY ShipCountry 
							 HAVING COUNT(*) >= 100

--12.5 Trong 3 quốc gia  Mỹ Anh Pháp, qgia nào có nhiều đơn hàng nhất 
SELECT ShipCountry, COUNT(*) AS [Max Order] FROM Orders 
							 WHERE ShipCountry IN ('USA', 'UK', 'France') 
							 GROUP BY ShipCountry 
							 HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM Orders 
																	 WHERE ShipCountry IN ('USA', 'UK', 'France') 
																	 GROUP BY ShipCountry
													 )		--USA, 122
SELECT ShipCountry FROM Orders 
							 WHERE ShipCountry IN ('USA', 'UK', 'France') 
							 GROUP BY ShipCountry 
							 HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM Orders 
																	 WHERE ShipCountry IN ('USA', 'UK', 'France') 
																	 GROUP BY ShipCountry
													 )		--USA
													 -- Chuẩn 
SELECT * FROM				 (SELECT ShipCountry FROM Orders 
							 WHERE ShipCountry IN ('USA', 'UK', 'France') 
							 GROUP BY ShipCountry 
							 HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM Orders 
																	 WHERE ShipCountry IN ('USA', 'UK', 'France') 
																	 GROUP BY ShipCountry
													 )) AS MAXI



------------------------------------------------------------------
SELECT COUNT(*) AS [No employees]  FROM Employees
SELECT COUNT(*) AS [No London employees]FROM Employees WHERE City = 'London'
SELECT * FROM Employees
SELECT COUNT(*) FROM Employees WHERE City IS NOT NULL
SELECT COUNT(City) FROM Employees --9
SELECT COUNT(DISTINCT City) FROM Employees --5
SELECT COUNT(Region) FROM Employees --5
SELECT COUNT(Region) FROM Employees WHERE Region IS NULL --0 
		--đếm trên value cột thì làm gì có gì để đếm, null ko có gtri, k đếm đc 
SELECT COUNT(*) FROM Employees WHERE Region IS NULL --4 
SELECT DISTINCT City FROM Employees
	--coi kết quả là 1 table 
SELECT * FROM (SELECT DISTINCT City FROM Employees) As Cities
SELECT City, COUNT(City) FROM Employees GROUP BY City
										--chia city thành nhóm, rồi đếm value trong nhóm 
SELECT Region, COUNT(*) FROM Employees GROUP BY Region--4/5
SELECT Region, COUNT(Region) FROM Employees GROUP BY Region--0/5

SELECT City, COUNT(City) AS [No employees] FROM Employees GROUP BY City 
--TP NÀO CÓ TỪ 2 NV TRỞ LÊN
--2 chặng làm
--	1.Các tp có bao nhiêu nhân viên/ đếm số nhân viên của mỗi thành phố 
--	2. Đếm xong mỗi thành phố, ta bắt đầu lọc lại kết quả sau đếm
--	   FILTER SAU ĐẾM, WHERE SAU ĐẾM, WHERE SAU KHI ĐÃ GOM NHÓM, AGGREGATE THÌ GỌI LÀ HAVING 
SELECT City, COUNT(City) AS [No employees] FROM Employees GROUP BY City HAVING COUNT(*) >= 2

-- ĐẾM SỐ NHÂN VIÊN CỦA 2 TP 
SELECT City, COUNT(City) AS [No employees] FROM Employees WHERE City IN ('LONDON', 'Seattle' ) GROUP BY City
SELECT City, COUNT(City) AS [No employees] FROM Employees GROUP BY City HAVING City IN ('LONDON', 'Seattle' )
SELECT * FROM Employees WHERE City IN ('LONDON', 'Seattle' )
SELECT City, COUNT(*) FROM (SELECT * FROM Employees WHERE City IN ('LONDON', 'Seattle' )) AS twoTP GROUP BY City 

--TRONG 2 TP ĐÓ, TP NÀO CÓ NHIỀU HƠN 3 NV
SELECT City, COUNT(City) AS [No employees] FROM Employees WHERE City IN ('LONDON', 'Seattle' ) GROUP BY City HAVING COUNT(*) > 2
SELECT City, COUNT(City) AS [No employees] FROM Employees GROUP BY City HAVING City IN ('LONDON', 'Seattle' ) AND COUNT(*) >2
SELECT City, COUNT(*) FROM (SELECT * FROM Employees WHERE City IN ('LONDON', 'Seattle' )) AS twoTP GROUP BY City HAVING COUNT(*) >2

--CÓ BAO NHIÊU ĐƠN HÀNG ĐÃ BÁN RA 
SELECT COUNT(*) FROM Orders
SELECT COUNT(OrderID) FROM Orders
		--830 mã đơn khác nhau, đếm mã đơn, hay đếm cả đơn là như nhau
		--phải đếm theo ID-PK vì nếu cột có value NULL ăn hành 
SELECT COUNT(*) FROM Orders WHERE ShipCountry = 'USA'
SELECT ShipCountry, COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry
SELECT ShipCountry, COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry HAVING COUNT(*) > 100
SELECT ShipCountry, COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry 
			HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry)

SELECT ShipCountry, COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry --SAI 
			HAVING COUNT(*) = (SELECT MAX(COUNT(*))FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry)
							--Cannot perform an aggregate function on an expression containing an aggregate or a subquery.
							--KO THỂ DÙNG MAX TRONG GOM NHÓM VÌ NÓ BIẾT ĐẾM THEO CÁI GÌ, GROUP BY KÌA 
SELECT ShipCountry, COUNT(*) FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry --ĐÚNG 
			HAVING COUNT(*) = (SELECT MAX(Maxi) FROM (SELECT ShipCountry, COUNT(*) AS Maxi 
													   FROM Orders WHERE ShipCountry IN ('USA', 'UK', 'France') GROUP BY ShipCountry
													 ) AS MaxTable)

