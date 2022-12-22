DROP DATABASE ClubManagement

CREATE DATABASE ClubManagement

USE ClubManagement

DROP TABLE Club
CREATE TABLE Club
(
	ClubID char(5) PRIMARY KEY,         -- PK Primary Key - Khóa chính
	ClubName nvarchar(50),
	Hotline varchar(11)
)

INSERT INTO Club VALUES('SiTi', N'Cộng đồng Sinh viên Tình nguyện', '090x')
INSERT INTO Club VALUES('SkllC', N'Skillcetera', '091x')
INSERT INTO Club VALUES('CSG', N'CLB Truyền thông Cóc Sài Gòn', '092x')
INSERT INTO Club VALUES('FEV', N'FPT Event Club', '093x')
INSERT INTO Club VALUES('FCode', N'FPT Code', '094x')

SELECT * FROM Club

DROP TABLE Student
CREATE TABLE Student
(
	StudentID char(8) PRIMARY KEY,          -- PK Primary Key - Khóa chính
	LastName nvarchar(30),
	FirstName nvarchar(10),
	DOB date,
	Address nvarchar(50)	
)

INSERT INTO Student(StudentID, LastName, FirstName) VALUES('SE1', N'Nguyễn', N'Một');
INSERT INTO Student(StudentID, LastName, FirstName) VALUES('SE2', N'Lê', N'Hai');
INSERT INTO Student(StudentID, LastName, FirstName) VALUES('SE3', N'Trần', N'Ba');
INSERT INTO Student(StudentID, LastName, FirstName) VALUES('SE4', N'Phạm', N'Bốn');
INSERT INTO Student(StudentID, LastName, FirstName) VALUES('SE5', N'Lý', N'Năm');

SELECT * FROM Student

DROP TABLE Registration
CREATE TABLE Registration
(
	RegID int IDENTITY(1, 1) PRIMARY KEY,   -- PK Primary Key - Khóa chính - Tăng tự động từ 1	      
	StudentID char(8),
	ClubID char(5),    
	JoinedDate date,
	LeavedDate date
	CONSTRAINT FK_Reg_Club FOREIGN KEY (ClubID) REFERENCES Club(ClubID),                -- FK Foreign Key - Khóa ngoại
	CONSTRAINT FK_Reg_Student FOREIGN KEY (StudentID) REFERENCES Student(StudentID)     -- FK Foreign Key - Khóa ngoại
)


-- SiTi 3, SkllC 2, CSG 2, FEV 0, FCODE 0
-- SE1 3, SE2 3, SE3 1, SE4 0, SE5 0
INSERT INTO Registration(StudentID, ClubID) VALUES('SE1', 'SiTi')
INSERT INTO Registration(StudentID, ClubID) VALUES('SE1', 'SkllC')
INSERT INTO Registration(StudentID, ClubID) VALUES('SE1', 'CSG')


INSERT INTO Registration(StudentID, ClubID) VALUES('SE2', 'SiTi')
INSERT INTO Registration(StudentID, ClubID) VALUES('SE2', 'SkllC')
INSERT INTO Registration(StudentID, ClubID) VALUES('SE2', 'CSG')

INSERT INTO Registration(StudentID, ClubID) VALUES('SE3', 'SiTi')

SELECT * FROM Registration

-- 3 TABLE: STUDENT <StudentID> ---< REGISTRATION (RegID) >-- CLUB <ClubID>
--		1 sv đăng kí quá trời clb							1 clb có quá trời sv đăng kí 

--THỰC HÀNH
--1. Liệt kê thông tin sv đang theo học 
SELECT * FROM Student
SELECT * FROM Club
SELECT * FROM Registration

--2. Liệt kê thông tin sv đang theo học kèm theo CLB mà bạn í tham gia 
--	Output: Mã sv, tên sv, mã clb
SELECT s.StudentID, s.LastName + ' ' + s.FirstName AS FullName, r.ClubID 
			FROM Student AS s JOIN Registration AS r ON s.StudentID = r.StudentID
	--!!! Thiếu mẹ nó 2 sv 4 5 vì JOIN = 
SELECT s.StudentID, s.LastName + ' ' + s.FirstName AS FullName, r.ClubID 
			FROM Student s LEFT JOIN Registration r ON s.StudentID = r.StudentID
	
--3. In ra thông tin tham gia clb của các sv
--	Output: mã sv, tên sv, mã clb, tên clb, joineddate 
SELECT * FROM Student s JOIN Registration r ON s.StudentID = r.StudentID
											JOIN Club c ON R.ClubID = C.ClubID --7 thiếu 
	--C1
		--3 bảng nhập lại với nhau rồi thì lấy bên nào cũng được 
SELECT s.StudentID, s.FirstName, c.ClubID, c.ClubName, r.JoinedDate 
									FROM Student s 
													JOIN Registration r ON s.StudentID = r.StudentID
																		JOIN Club c ON r.ClubID = c.ClubID 
	--C2 
SELECT s.StudentID, s.FirstName, c.ClubID, c.ClubName, r.JoinedDate 
									FROM Student s,  Registration r, Club c 
									WHERE s.StudentID = r.StudentID AND r.ClubID = c.ClubID

	-- vấn đề lớn C1 & C2: mất mẹ nó 2 sv 4, 5; mất MẸ luôn cả clb FCODE FEV 
	-- viết kiểu C2 tao đố mày lấy đc phần hụt, vì nó chỉ đi tìm đám bằng nhau common field 
	-- ghép và in ra, thằng nào ko bằng, hụt, kệ mẹ mày 

	-- JOIN SẼ GIÚP VÌ NÓ NHÌN LUÔN PHẦN CHUNG VÀ PHẦN HỤT 

SELECT s.StudentID, s.FirstName, c.ClubID, c.ClubName, r.JoinedDate 
FROM Student s 
FULL JOIN Registration r ON s.StudentID = r.StudentID
FULL JOIN Club c ON R.ClubID = C.ClubID					--11 đủ 


SELECT * FROM Registration
SELECT * FROM Student
SELECT * FROM Club
---BTVN
--1. Đếm số clb mà mỗi sv đã tham gia 
--	Output: mã sv, tên sv, số clb tham gia 
SELECT s.StudentID, s.FirstName, COUNT(r.ClubID) AS [No clubs] FROM Student s FULL JOIN Registration r ON s.StudentID = r.StudentID
					  FULL JOIN Club c ON  r.ClubID = c.ClubID 	GROUP BY s.StudentID, s.FirstName
SELECT s.StudentID, s.FirstName, COUNT(s.StudentID) AS [No clubs] FROM Student s FULL JOIN Registration r ON s.StudentID = r.StudentID
					  FULL JOIN Club c ON  r.ClubID = c.ClubID 	GROUP BY s.StudentID, s.FirstName --SAI nếu đếm clb trên msv 
					 
--2. Sv SE1 tham gia mấy clb
--	Output: mã sv, tên sv, số clb tham gia 
SELECT s.StudentID, COUNT(*) FROM Student s, Registration r WHERE s.StudentID = r.StudentID GROUP BY s.StudentID HAVING s.StudentID = 'SE1'
SELECT s.StudentID, COUNT(*) FROM Student s, Registration r WHERE s.StudentID = r.StudentID AND s.StudentID = 'SE1' GROUP BY s.StudentID 

--3. Sv nào tham gia nhiều clb nhất
SELECT s.StudentID, COUNT(*) FROM Student s LEFT JOIN Registration r ON s.StudentID = r.StudentID GROUP BY s.StudentID HAVING s.StudentID = 'SE1'

--4. CLB Cộng đồng sinh viên tình nghuyện có những sv nào tham gia (gián tiếp) 
	--câu này ko dùng sub cũng okie, nhớ là tui hok có hỏi SiTi à nhen 
	--dùng sub cũng okie 
--5. Mỗi clb có bao nhiêu thành viên 
--	Output: mã sv, tên sv, số thành viên 
--6. CLB nào đông member nhất 
--	Output: mã sv, tên sv, số thành viên 
--7. CLB SiTi và CSG có bn member. Đếm riêng tằng clb 
--	Output: mã sv, tên sv, số thành viên (2 dòng) 
--8. Có tổng cộng bn lượt sv tham gia clb 
