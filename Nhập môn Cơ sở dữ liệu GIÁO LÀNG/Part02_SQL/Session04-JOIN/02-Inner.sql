USE Cartesian

SELECT * FROM VnDict, EnDict -- Tích Đề-các  
							 -- ĐC DÙNG CHỮ WHERE 

SELECT * FROM VnDict CROSS JOIN EnDict -- Tích Đề-các 
							 -- CROSS KO ĐC DÙNG CHỮ WHERE 

SELECT * FROM VnDict vn, EnDict en	-- Tích Đề-các xong, filter lại 
		 WHERE vn.Nmbr = en.Nmbr	-- THỰC DỤNG 

SELECT * FROM VnDict, EnDict 
		 WHERE VnDict.Nmbr = EnDict.Nmbr	-- nên đặt Alias thì giúp ngắn gọn câu lệnh 

--CHUẨN THẾ GIỚI 
SELECT * FROM VnDict INNER JOIN EnDict		--NHÌN SÂU TABLE RỒI GHÉP, KO GHÉP BỪA BÃI 
					 ON VnDict.Nmbr = EnDict.Nmbr	--GHÉP CÓ TƯƠNG QUAN BÊN TRONG, THEO ĐIỂM CHUNG 
					 --kết nối nhau trên sự tương quan 
					 -- INNER ĐC DÙNG CHỮ WHERE 

SELECT * FROM VnDict JOIN EnDict		
					 ON VnDict.Nmbr = EnDict.Nmbr

-- CÓ THỂ DÙNG THÊM WHERE ĐC HAY KO? KHI XÀI INNER, JOIN 
-- JOIN CHỈ LÀ THÊM DATA ĐỂ TÍNH TOÁN, GỘP DATA LẠI NHIỀU HƠN, SAU ĐÓ ÁP DỤNG TOÀN BỘ 
-- KIẾN THỨC SELECT ĐÃ HỌC 

-- THÍ NGHIỆM THÊM CHO INNER JOIN, GHÉP NGANG CÓ XEM XÉT MÔN ĐĂNG HỘ ĐỐI HAY KO?
SELECT * FROM EnDict
SELECT * FROM VnDict

SELECT * FROM EnDict e, VnDict v
		 WHERE e.EnDesc = v.Nmbr

SELECT * FROM EnDict e, VnDict v
		 WHERE e.Nmbr > v.Nmbr		--GHÉP CÓ CHỌN LỌC, HOK XÀI DẤU =
									--MÀ DÙNG DẤU > >= < <= !=
									--NON-EQUI JOIN
									--VẪN KO LÀ GHÉP BỪA BÃI
SELECT * FROM EnDict e, VnDict v
		 WHERE e.Nmbr != v.Nmbr	--6 

SELECT * FROM EnDict e JOIN VnDict v
		 ON e.Nmbr != v.Nmbr