USE Cartesian

--1. Liệt kê cho tôi các cặp từ điển Anh-Việt 
SELECT * FROM EnDict e, VnDict v
		 WHERE e.Nmbr = v.Nmbr
		 -- CÓ BẰNG CELL THÌ MỚI GHÉP 
SELECT * FROM EnDict e INNER JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
		 -- hãy ghép đi, trên cột này có cell/value này = cell/value bên kia 
SELECT * FROM EnDict e JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
--3 câu tương đương kết quả!!!

--2. Hụt mất của tui từ 4 - Four và 5 Năm k thấy xuất hiện!!!
--3. Tui mún xh lấy tiếng Anh làm chuẩn, tìm các nghĩa TV tương đương 
--	 Nếu ko có tương đương vẫn phải hiện ra 
SELECT * FROM EnDict e LEFT JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
		 -- lấy bên trái làm chuẩn/mốc để ghép 
SELECT * FROM EnDict e LEFT OUTER JOIN VnDict v
		 ON e.Nmbr = v.Nmbr		

--4. Tui mún lấy tiếng Việt làm đầu!!! 
SELECT * FROM VnDict v LEFT OUTER JOIN EnDict e
		 ON e.Nmbr = v.Nmbr

-- Vẫn lấy TV làm đầu, nhưng để TV bên tay phải kìa 
SELECT * FROM EnDict e RIGHT OUTER JOIN VnDict v
		 ON e.Nmbr = v.Nmbr		

--5. Dù chung và riêng của mỗi bên, lấy tất cả, chấp nhận FA ở 1 vế  
SELECT * FROM EnDict e FULL OUTER JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
--đổi thứ tự vẫn ok 
SELECT * FROM VnDict v FULL OUTER JOIN EnDict e
		 ON e.Nmbr = v.Nmbr
--	FULL OUTER JOIN, THỨ TỰ TABLE KO QUAN TRỌNG, VIẾT TRƯỚC VIẾT SAU ĐỀU ĐC 
--	LEFT, RIGHT JOIN THỨ TỰ TABLE LÀ CÓ CHUYỆN KHÁC NHAU 
SELECT * FROM EnDict e LEFT JOIN VnDict v
		 ON e.Nmbr = v.Nmbr		--show 4 NULL 
SELECT * FROM VnDict v LEFT JOIN EnDict e
		 ON e.Nmbr = v.Nmbr		--show 5 năm 

--	OUTER JOIN SINH RA ĐỂ ĐẢM BẢO VIỆC KẾT NỐI GHÉP BẢNG
--	KO BỊ MẤT MÁT DATA!!!
--	DO INNER JOIN, JOIN = CHỈ TÌM CÁI CHUNG 2 BÊN 

-- SAU KHI TÌM RA ĐƯỢC DATA CHUNG RIÊNGM TA CÓ QUYỀN FILTER TRÊN LOẠI
-- CELL NÀO ĐÓ, WHERE NHƯ BÌNH THƯỜNG 

--6. In ra bộ từ điển Anh Việt (Anh làm chuẩn) của những con số 
-- từ 3 trở lên 
SELECT * FROM EnDict e LEFT JOIN VnDict v
		 ON e.Nmbr = v.Nmbr	
		 WHERE e.Nmbr >= 3 
	--3	Three	3	Ba
	--4	Four	NULL	NULL
SELECT * FROM EnDict e LEFT JOIN VnDict v
		 ON e.Nmbr = v.Nmbr	
		 WHERE v.Nmbr >= 3 
	--3	Three	3	Ba

--6. In ra bộ từ điển Anh Việt Việt Anh của những con số 
-- từ 3 trở lên 
SELECT * FROM EnDict e FULL JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
		 WHERE e.Nmbr >= 3 --toang, mất mẹ nó số 5 của VN 

SELECT * FROM EnDict e FULL JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
		 WHERE v.Nmbr >= 3 --có 5 mất 4 

SELECT * FROM EnDict e FULL JOIN VnDict v
		 ON e.Nmbr = v.Nmbr
		 WHERE e.Nmbr >= 3 OR v.Nmbr >=3 --lọc trong quá trình ghép nên where chứ k having 




-------------------------------------------------------------------
--T.Anh làm chuẩn, tìm các nghĩa TV tương ứng, nếu ko có tương đương vẫn phải hiện ra 
SELECT * FROM EnDict e LEFT JOIN VnDict v ON e.Nmbr = v.Nmbr 
SELECT * FROM EnDict e LEFT OUTER JOIN VnDict v ON e.Nmbr = v.Nmbr 

--TV làm chuẩn, tìm các nghĩa TA tương ứng
SELECT * FROM VnDict v LEFT JOIN EnDict e ON e.Nmbr = v.Nmbr 
SELECT * FROM EnDict e RIGHT JOIN VnDict v ON e.Nmbr = v.Nmbr 

--dù hcung và riền ở mỗi bên, lấy tất cả 
SELECT * FROM EnDict e FULL OUTER JOIN VnDict v ON e.Nmbr = v.Nmbr 
SELECT * FROM EnDict e FULL  JOIN      VnDict v ON e.Nmbr = v.Nmbr 



