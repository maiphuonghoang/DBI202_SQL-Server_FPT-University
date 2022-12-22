DROP DATABASE StudentManagement

CREATE DATABASE StudentManagement

USE StudentManagement

CREATE TABLE Major
(
	MajorID char(2) PRIMARY KEY,         -- PK Primary Key - Khóa chính
	MajorName varchar(30),
	Hotline varchar(11)
)

INSERT INTO Major VALUES('SE', 'Software Engineering', '090x')
INSERT INTO Major VALUES('IA', 'Information Assurance', '091x')
INSERT INTO Major VALUES('GD', 'Graphic Design', '092x')
INSERT INTO Major VALUES('JP', 'Japanese', '093x')
INSERT INTO Major VALUES('KR', 'Korean', '094x')

SELECT * FROM Major

DROP TABLE Student
CREATE TABLE Student
(
	StudentID char(8) PRIMARY KEY,          -- PK Primary Key - Khóa chính
	LastName nvarchar(30),
	FirstName nvarchar(10),
	DOB date,
	Address nvarchar(50), 
	MajorID char(2) REFERENCES Major(MajorID)  -- FK Foreign Key - Khóa ngoại
)

INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE1', N'Nguyễn', N'Một', 'SE');
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE2', N'Lê', N'Hai', 'SE');
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE3', N'Trần', N'Ba', 'SE');

INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE4', N'Phạm', N'Bốn', 'IA');
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE5', N'Lý', N'Năm', 'IA');
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('SE6', N'Võ', N'Sáu', 'IA');

INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('GD7', N'Đinh', N'Bảy', 'GD');
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('GD8', N'Huỳnh', N'Tám', 'GD');

INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('JP9', N'Ngô', N'Chín', 'JP');

SELECT * FROM Student

-- TỪ TỪ HÃY THÊM VÀO ĐỂ XEM FULL-OUTER JOIN RA SAO
INSERT INTO Student(StudentID, LastName, FirstName, MajorID) VALUES('UNK', N'Đặng', N'Mười', NULL);


SELECT * FROM Major
SELECT * FROM Student

--1. In ra thông tin chi tiết của SV kèm thông tin chuyên ngành
SELECT * FROM Student  -- info tắt của chuyên ngành
SELECT * FROM Major    -- chỉ có info chuyên ngành, thiếu info sv
-- JOIN cầm chắc rồi, lấy info đang nằm ở bên kia ghép thêm theo chiều ngang
SELECT * FROM Student s, Major m
         WHERE s.MajorID = m.MajorID  -- dư cột MajorID 

SELECT s.*, m.MajorName, m.Hotline
         FROM Student s, Major m
         WHERE s.MajorID = m.MajorID 

SELECT s.*, m.MajorName, m.Hotline
         FROM Student s JOIN Major m
         ON s.MajorID = m.MajorID 

--2. In ra thông tin chi tiết của sv kèm info chuyên ngành. Chỉ quan tâm sv SE và IA
SELECT s.*, m.MajorName, m.Hotline
         FROM Student s JOIN Major m
         ON s.MajorID = m.MajorID 
		 WHERE m.MajorID = 'SE' OR  m.MajorID = 'IA'  -- 6 dòng
--Ghép xong đi đã rồi filter 
SELECT s.*, m.MajorName, m.Hotline
         FROM Student s JOIN Major m
         ON s.MajorID = m.MajorID 
		 WHERE m.MajorID IN ('SE', 'IA')  -- 6 dòng

SELECT s.*, m.MajorID, m.MajorName, m.Hotline
         FROM Student s, Major m
         WHERE s.MajorID = m.MajorID AND m.MajorID IN ('SE', 'IA')  --6 
--filter trong lúc ghép 

--3. In ra thông tin các sinh viên kèm chuyên ngành. Chuyên ngành nào chưa có sv cũng in ra luôn
-- phân tích: căn theo sv mà in, thì HÀN QUỐC tèo ko xuất hiện

SELECT s.*, m.MajorName, m.Hotline
         FROM Student s RIGHT JOIN Major m --CĂN THEO CHUYÊN NGÀNH MÀ QUẤT, K FULL 
         ON s.MajorID = m.MajorID  --10 DÒNG
			--mã chuyên ngành là null do lấy theo student 
SELECT s.*, m.*
         FROM Student s RIGHT JOIN Major m
         ON s.MajorID = m.MajorID  --10 DÒNG

SELECT s.*, m.*
         FROM Major m LEFT JOIN Student s 
         ON s.MajorID = m.MajorID  --10 DÒNG, KOREAN FA NULL

SELECT s.*, m.*
         FROM Student s LEFT JOIN Major m 
         ON s.MajorID = m.MajorID  --9 DÒNG, KOREAN biến mất


--4. Có bao nhiêu chuyên ngành???
SELECT * FROM Major
SELECT * FROM Student

SELECT COUNT(*) FROM Major
select * from major
SELECT COUNT(MajorID) AS [No majors] FROM Major
SELECT count(majorId) aS [No majors] FRoM MajoR

--5. Mỗi chuyên ngành có bao nhiêu sinh viên???
--output 0: số lượng sv đang theo học của từng chuyên ngành 
--output 1: mã cn | số lượng sv đang theo học
--phân tích: hỏi sv, bao nhiêu sv, đếm sv sure!!!
--           gặp thêm từ mỗi!!!!!!!
--           mỗi cn có 1 con số đếm, đếm theo chuyên ngành, chia nhóm chuyên ngành mà đếm

SELECT COUNT(*) FROM STUDENT GROUP BY MajorID --ÉO BIẾT CN NÀO BAO NHIÊU SV, ĐẾM ĐÚNG

SELECT MajorID, COUNT(*) AS [No students] FROM STUDENT GROUP BY MajorID

SELECT MajorID, COUNT(MajorID) AS [No students] FROM STUDENT GROUP BY MajorID

--6. Chuyên ngành nào có từ 3 sv trở lên???
--phân tích: chia chặng rồi
--           đầu tiên phải đếm chuyên ngành đã, quét qua bảng 1 lần để đếm ra sv
--           đếm xong, dợt lại kết quả, lọc thêm cái từ 3 sv trở lên
--           phải đếm xong từng ngành rồi mới tính tiếp
--           ???
SELECT MajorID, COUNT(MajorID) AS [No students] 
          FROM STUDENT GROUP BY MajorID
		  HAVING COUNT(MajorID) >= 3  -- SE và IA sure

--7. CHUYÊN NGÀNH NÀO CÓ ÍT SV NHẤT

SELECT MajorID, COUNT(MajorID) AS [No students] 
          FROM STUDENT GROUP BY MajorID
		  HAVING COUNT(MajorID) = 1  -- ĂN ĐÒN

SELECT MajorID, COUNT(MajorID) AS [No students] 
          FROM STUDENT GROUP BY MajorID
		  HAVING COUNT(MajorID) <= ALL(
		                                 SELECT COUNT(MajorID) AS [No students] 
                                         FROM STUDENT GROUP BY MajorID
		                              )
SELECT MajorID, COUNT(*) FROM Student 
						GROUP BY MajorID
						HAVING COUNT(*) = (
											SELECT MIN(no) FROM (SELECT MajorID, COUNT(*) AS [no] FROM Student 
																								  GROUP BY MajorID
																) AS MINXI
										  )

--8. Đếm số sv của chuyên ngành SE
--phân tích: câu này éo hỏi đếm các chuyên ngành
-- CỨ TÌM SE MÀ ĐẾM HOY
SELECT COUNT(*) FROM Student 
               WHERE MajorID = 'SE'   -- CÂU NÀY CHẠY NHANH

SELECT MajorID, COUNT(*) FROM Student 
               WHERE MajorID = 'SE'	 --chỉ count những thằng SE, rồi gom chúng lại thành 1 cái nhóm 
			   GROUP BY MajorID      --CHỈ CÒN LẠI 1 NHÓM
			   --thêm hiển thị nên group by thôi 

SELECT MajorID, COUNT(*) FROM Student GROUP BY MajorID
                         HAVING MajorID = 'SE'   -- CÂU NÀY CHẠY CHẬM
		--chia nhóm đếm rồi bắt đầu lọc lại 
		
--9. ĐẾM SỐ SV CỦA MỖI CN
--output: mã chuyên ngành, tên cn, số lượng sv
--phân tích: đáp án cần có info của 2 table
--           đếm trên 2 table
--           đếm trong Major hok có info sv
--           đếm trong SV chỉ có đc mã cn
--           mún có mã cn, tên cn, số lượng sv -> JOIN 2 BẢNG RỒI MỚI ĐẾM

SELECT MajorID, COUNT(MajorID) AS [No students] FROM STUDENT GROUP BY MajorID
SELECT * FROM Student

SELECT s.StudentID, s.FirstName, m.MajorID, m.MajorName
          FROM Student s INNER JOIN Major m
          ON s.MajorID = m.MajorID   

SELECT m.MajorID, m.MajorName, COUNT(*) AS [No students]
          FROM Student s INNER JOIN Major m
          ON s.MajorID = m.MajorID   
		  GROUP BY m.MajorID, m.MajorName

--viết dài, kia gộp bảng có sẵn rồi 
SELECT MajorID, MajorName, COUNT(MajorID) FROM (SELECT s.StudentID, s.FirstName, m.MajorID, m.MajorName 
			  FROM Student s INNER JOIN Major m
			  ON s.MajorID = m.MajorID) AS [dem] 
			  GROUP BY MajorID, MajorName
--10. câu 10 điểm nè...
--THẾ CÒN TRÒ CHƠI CON MỰC THÌ SAO??????????????????
--CHUYÊN NGÀNH HQ CỦA EM ĐÂU RỒI????????????????????
SELECT s.StudentID, s.FirstName, m.MajorID, m.MajorName
          FROM Student s RIGHT JOIN Major m
          ON s.MajorID = m.MajorID  
		  
SELECT m.MajorID, m.MajorName, COUNT(*)
          FROM Student s RIGHT JOIN Major m
          ON s.MajorID = m.MajorID   
		  GROUP BY m.MajorID, m.MajorName  -- SAI VÌ CÓ 1 DÒNG HQ FA, NULL VẾ SV
		                                   --COUNT(*) ĐẾM THEO DÒNG, CÓ 1 DÒNG FA, HQ CÓ 1 SV SAI
SELECT m.MajorID, m.MajorName, COUNT(StudentID)
          FROM Student s RIGHT JOIN Major m
          ON s.MajorID = m.MajorID   
		  GROUP BY m.MajorID, m.MajorName   --COUNT NULL LẠI ĐÚNG TRONG TRƯỜNG HỢP NÀY
		                                    --VÌ MÃ SV NULL ỨNG VỚI CHUYÊN NGÀNH HQ
											--COUNT(*) CHỈ CẦN CÓ DÒNG LÀ RA SỐ 1
											--CHẤP DÒNG CÓ NHIỀU NULL HAY KO

											--ĐẾM CELL CELL NULL -> 0 
		  --DASH BOARD MÀN HÌNH THỐNG KÊ CỦA ADMIN WEBSITE TUYỂN SINH



-----------------------------------------------------------------------------------------------------------------
SELECT * FROM Major
SELECT * FROM Student
SELECT * FROM Student s, Major m WHERE m.MajorID = s.MajorID; 
SELECT s.*, m.MajorName, m.Hotline FROM Student s JOIN Major m ON m.MajorID = s.MajorID 

SELECT s.*, m.MajorName, m.Hotline FROM Student s, Major m WHERE m.MajorID = s.MajorID
															AND s.MajorID IN ('SE', 'IA') --ghép xong rồi filter 
SELECT s.*, m.MajorName, m.Hotline FROM Student s JOIN Major m ON m.MajorID = s.MajorID
															WHERE s.MajorID = 'SE' OR s.MajorID ='IA' 

SELECT * FROM Student s RIGHT JOIN Major m ON m.MajorID = s.MajorID

SELECT COUNT(*) FROM Major
SELECT COUNT(MajorID) AS [No majors] FROM Major

--mỗi chuyên ngành có bao nhiêu sinh viên 
SELECT m.MajorID, COUNT(*) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID -- COUNT * SAI DO CÓ NULL 
SELECT m.MajorID, COUNT(m.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID -- SAI NẾU ĐẾM TRÊN CỘT MAJOR THÌ KR VẪN CÓ GIÁ TRỊ 
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID --ĐÚNG, PHẢI ĐẾM TRÊN CỘT MAJOR CỦA SUTUDENT LÚC NÀY MỚI CÓ GTRI NULL 
					--hỏi sinh viên thì phải đếm trên sv 
SELECT m.MajorID, COUNT(StudentID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID --ĐÚNG, ĐẾM TRÊN MÃ SV OK HƠN  

--chuyên ngành nào có từ 3 sv trở lên 
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID 
		HAVING COUNT(s.MajorID) >= 3

--chuyên ngành nào có ít sv nhất
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID 
		HAVING COUNT(s.MajorID) <= ALL(SELECT COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID )
SELECT  MIN([No students]) FROM 
								(SELECT m.MajorID, COUNT(s.MajorID) AS [No students] FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID ) 
								AS MinTable --tìm đc nhỏ nhất, CHO NHỎ NHẤT VÀO CHỖ BẰNG  
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID 
		HAVING COUNT(s.MajorID) =  (SELECT  MIN([No students]) FROM 
																	(SELECT m.MajorID, COUNT(s.MajorID) AS [No students] FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID ) 
														          AS MinTable )
--đếm số sv của chuyên ngành SE	- dùng 2 bảng 
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID  
			HAVING m.MajorID = 'SE'
SELECT m.MajorID, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID 
			WHERE m.MajorID = 'SE' GROUP BY m.MajorID  
	
SELECT COUNT(*) FROM Student WHERE MajorID = 'SE' 
SELECT MajorID, COUNT(*) FROM Student GROUP BY MajorID HAVING MajorID = 'SE' --dùng 1 bảng 
													  --chạy chậm, đếm tất cả các nhóm rồi mới chọn SE 
													  --cứ chia nhóm mà đếm 
SELECT MajorID, COUNT(*) FROM Student WHERE MajorID = 'SE' GROUP BY MajorID 
													  -- chạy nhanh, chọn rồi đếm luôn 
											  --chỉ còn lại 1 nhóm 

-- đếm sô sv của mỗi chuyên ngành	
-- output: mã cn, tên cn, số lượng sv 
SELECT m.MajorID, m.MajorName, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.MajorID, m.MajorName
SELECT m.*, COUNT(s.MajorID) FROM Major m LEFT JOIN Student s ON m.MajorID = s.MajorID GROUP BY m.* --k đc in kiểu.*, nếu muốn in hết thì nhập hết cột ra 




			

