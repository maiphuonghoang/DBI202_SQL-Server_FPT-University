CREATE DATABASE DBI202Project_SE1723_HMP_HE171073
USE DBI202Project_SE1723_HMP_HE171073

/*
We are going to design a database for student clubs on campus. 
	Particularly, we will keep track of club memberships, member roles, and club activities. 
	A student can be a member of multiple clubs. Simultaneously, a club can have multiple students.
	A student can take different roles (e.g., regular member, secretary, treasurer) in different clubs. 
	Each club must have a president, a vice-president, a secretary, and a treasurer, and the other members are just regular members.
	A student cannot be the president of multiple clubs, but can take other roles at multiple clubs 
	(e.g., a student can be the president of a club and the vice president of another club at the same time).
	The role of the student in a club can be changed over each semester. 

	About club activities, we will show time, date, and the location of the activity, budget, 
	number of attendees and the club sponsor (organizer) of the activity. 
	A club typically organizes multiple activities during the year, and an activity can be co-organized by multiple clubs.
*/
CREATE TABLE Majors
(
	MajorID char(2) PRIMARY KEY,
	vnMajorName nvarchar(30),
	enMajorName varchar(30)
)
CREATE TABLE Students
(
	StudentID char(8) PRIMARY KEY,
	LastName nvarchar(20) NOT NULL,
	MiddleName nvarchar(20) NOT NULL,
	FirstName nvarchar(20) NOT NULL,
	Gender char(1) NOT NULL,
	DateOfBirth date,
	Phone char(10),
	Email varchar(50),
)
	--khóa ngoại 
	ALTER TABLE Students ADD MajorID char(2) CONSTRAINT FK_Students_Majors_MajorID FOREIGN KEY 
					REFERENCES Majors(MajorID)
    ALTER TABLE Students ADD CONSTRAINT CK_Gender CHECK (Gender IN ('M', 'F'))

CREATE TABLE Clubs 
(
	ClubID varchar(5) PRIMARY KEY,
	ClubName nvarchar(30) NOT NULL,
	[Type] varchar(15),
	CurrentHead char(8),
	Description varchar(50)
)
ALTER TABLE Clubs ADD FOREIGN KEY(CurrentHead) REFERENCES Students(StudentID)

CREATE TABLE Semesters
(
	SemesterID char(4) PRIMARY KEY,
	Name varchar(8) NOT NULL,
	Year int NOT NULL  
)
	ALTER TABLE Semesters ADD CONSTRAINT CK_CurrentYear CHECK (Year <= YEAR(GETDATE()))

CREATE TABLE Roles
(
	RoleID char(3) PRIMARY KEY,
	RoleName varchar(30) NOT NULL 
)
CREATE TABLE Memberships 
(
	StudentID char(8),
	RoleID char(3) REFERENCES Roles(RoleID),
	ClubID varchar(5),
	SemesStart char(4) REFERENCES Semesters(SemesterID),
	SemesEnd char(4) REFERENCES Semesters(SemesterID),
	
    PRIMARY KEY (StudentID, ClubID, SemesStart)
)
	ALTER TABLE Memberships ADD CONSTRAINT FK_Memberships_Students_StudentID
	FOREIGN KEY (StudentID)	REFERENCES Students(StudentID)
	ALTER TABLE Memberships ADD CONSTRAINT FK_Memberships_Clubs_ClubID 
	FOREIGN KEY(ClubID) REFERENCES Clubs(ClubID)
	ALTER TABLE Memberships ADD CONSTRAINT FK_Memberships_Roles_RoleID 
	FOREIGN KEY(RoleID) REFERENCES Roles(RoleID)

CREATE TABLE [Events] 
(
	EventID varchar(10) PRIMARY KEY,
	EventName nvarchar(55),
	StartDate date,
	EndDate date,
	Place nvarchar(30),
	AttendenceNumber int, 
	Budget float,
	Sponsors varchar(50)
)
CREATE TABLE Organize 
(
	EventID varchar(10) REFERENCES [Events](EventID),
	ClubID varchar(5) REFERENCES Clubs(ClubID)
	PRIMARY KEY(EventID, ClubID)
)
/*
DROP TABLE Organize 
DROP TABLE Events 
DROP TABLE Memberships
DROP TABLE Clubs 
DROP TABLE Students 
DROP TABLE Semesters
DROP TABLE Roles 
DROP TABLE Majors 
*/
INSERT INTO Majors VALUES ('GD', N'Thiết kế đồ họa', 'Graphic Design')
INSERT INTO Majors VALUES ('IA', N'An toàn thông tin', 'Information Assurance')
INSERT INTO Majors VALUES ('JP', N'Ngôn ngữ Nhật', 'Japanese')
INSERT INTO Majors VALUES ('KR', N'Ngôn ngữ Hàn', 'Korean')
INSERT INTO Majors VALUES ('SE', N'Kỹ thuật phần mềm', 'Software Engineering')
INSERT INTO Majors VALUES ('EN', N'Ngôn ngữ Anh', 'English')


INSERT INTO Roles VALUES('P', 'President')
INSERT INTO Roles VALUES('V', 'Vice-President')
INSERT INTO Roles VALUES('S', 'Secretary')
INSERT INTO Roles VALUES('T', 'Treasurer')
INSERT INTO Roles VALUES('M', 'Member')


INSERT INTO Semesters VALUES ('FA21', 'Fall', '2021')
INSERT INTO Semesters VALUES ('SP22', 'Spring', '2022')
INSERT INTO Semesters VALUES ('SU22', 'Summer', '2022')
INSERT INTO Semesters VALUES ('FA22', 'Fall', '2022')


INSERT INTO Students VALUES ('HE130479', N'Nguyễn', N'Hữu', N'Tuấn', 'M', '1/20/2003', '0508478794', 'TuanNHHE130479@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE140647', N'Vũ', N'Lập', N'Bang', 'M', '2/4/2003', '0888368820', 'BangVLHE140647@fpt.edu.vn', 'GD')
INSERT INTO Students VALUES ('HE141057', N'Nguyễn', N'Phúc', N'Tiến', 'M', '2/27/2003', '0744170283', 'TienNPHE141057@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE151333', N'Nguyễn', N'Đức', N'Anh', 'M', '3/3/2003', '0719250111', 'AnhNDHE151333@fpt.edu.vn', 'JP')
INSERT INTO Students VALUES ('HE160682', N'Tống', N'Văn', N'Vinh', 'M', '3/5/2003', '0932159453', 'VinhTVHE160682@fpt.edu.vn', 'KR')
INSERT INTO Students VALUES ('HE160776', N'Đoàn', N'Đắc', N'Hậu', 'M', '3/13/2003', '0501073826', 'HauDDHE160776@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE161861', N'Tống', N'Quang', N'Hùng', 'M', '3/17/2003', '0549504874', 'HungTQHE161861@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE161875', N'Vũ', N'Danh', N'Huy', 'M', '3/24/2003', '0383921761', 'HuyVDHE161875@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE163522', N'Vũ', N'Đức', N'Anh', 'M', '4/17/2003', '0982071898', 'AnhVDHE163522@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE163877', N'Nguyễn', N'Minh', N'Đức', 'M', '5/26/2003', '0399592163', 'DucNMHE163877@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE170051', N'Vũ', N'Minh', N'Tâm', 'M', '5/28/2003', '0485151205', 'TamVMHE170051@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE170245', N'Bùi', N'Hoàng', N'Long', 'M', '6/2/2003', '0958774418', 'LongBHHE170245@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE170422', N'Vũ', N'Duy', N'Phúc', 'M', '6/20/2003', '0295159861', 'PhucVDHE170422@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE170428', N'Trần', N'Quang', N'Huy', 'M', '6/30/2003', '0160062285', 'HuyTQHE170428@fpt.edu.vn', 'KR')
INSERT INTO Students VALUES ('HE170788', N'Phạm', N'Viết', N'Long', 'M', '7/11/2003', '0956891616', 'LongPVHE170788@fpt.edu.vn', 'EN')
INSERT INTO Students VALUES ('HE170842', N'Nguyễn', N'Thanh', N'Hậu', 'F', '8/13/2003', '0496001935', 'HauNTHE170842@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE170863', N'Nguyễn', N'Thị Khánh', N'Huyền', 'F', '8/15/2003', '0693627517', 'HuyenNTKHE170863@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE170907', N'Phạm', N'Trường', N'Giang', 'M', '8/22/2003', '0375959216', 'GiangPTHE170907@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE170996', N'Khiếu', N'Minh', N'Đức', 'M', '9/1/2003', '0941515496', 'DucKMHE170996@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE171071', N'Vũ', N'Ngọc', N'Nhất', 'M', '9/23/2003', '0870871522', 'NhatVNHE171071@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE171073', N'Hoàng', N'Mai', N'Phương', 'F', '10/7/2003', '0480538343', 'PhuongHMHE171073@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE171162', N'Bùi', N'Tiến', N'Dũng', 'M', '10/16/2003', '0696586764', 'DungBTHE171162@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE171442', N'Văn', N'Công Quang', N'Minh', 'M', '10/27/2003', '0994642437', 'MinhVCQHE171442@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE171687', N'Doãn', N'Lâm', N'Phúc', 'M', '11/17/2003', '0599920912', 'PhucDLHE171687@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE172579', N'Nguyễn', N'Đình', N'Nghĩa', 'M', '12/4/2003', '0523861948', 'NghiaNDHE172579@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE176160', N'Triệu', N'Thạch', N' Ân', 'M', '5/1/2003', '0357683012', 'AnTTHE176160@fpt.edu.vn', 'SE')
INSERT INTO Students VALUES ('HE176182', N'Phan', N'Việt', N'Anh', 'M', '5/21/2003', '0440969384', 'AnhPVHE176182@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE176586', N'Đinh', N'Nhật', N'Hoàng', 'M', '5/23/2003', '0960501122', 'HoangDNHE176586@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE176697', N'Nguyễn', N'Thị Cẩm', N'Tú', 'F', '5/29/2003', '0702197864', 'TuNTCHE176697@fpt.edu.vn', 'IA')
INSERT INTO Students VALUES ('HE176751', N'Nguyễn', N'Quốc', N'Đạt', 'M', '6/16/2003', '0402435402', 'DatNQHE176751@fpt.edu.vn', 'SE')


INSERT INTO Clubs VALUES ('MLD', N'CLB Melody', 'Van Hoa', 'HE171071', 'https://www.facebook.com/fptu.melody.club/')
INSERT INTO Clubs VALUES ('IGO', N'CLB Tình nguyện vì cộng đồng', 'Xa Hoi', 'HE161875', 'https://www.facebook.com/iGoClub')
INSERT INTO Clubs VALUES ('JS', N'CLB Kỹ sư phần mềm Nhật Bản', 'Hoc Thuat', 'HE170996', 'https://www.facebook.com/fu.jsclub/')
INSERT INTO Clubs VALUES ('SWC', N'CLB Street Workout', 'The Thao', 'HE171442', 'https://www.facebook.com/FuStreetWorkout/')
INSERT INTO Clubs VALUES ('NS', N'CLB No Shy', 'Xa Hoi', 'HE171687', 'https://www.facebook.com/noshyclub/')
INSERT INTO Clubs VALUES ('VVN', N'CLB Vovinam', 'The Thao', 'HE172579', 'https://www.facebook.com/fvchn/')
INSERT INTO Clubs VALUES ('MM', N'CLB Mây Mưa', 'Van Hoa', 'HE176160', 'https://www.facebook.com/maymuaclub/')
INSERT INTO Clubs VALUES ('GHC', N'CLB Go Home', 'Van Hoa', 'HE170422', NULL)
INSERT INTO Clubs VALUES ('NC', N'CLB NO CLUB', 'Hoc Thuat', NULL, NULL)


INSERT INTO Memberships VALUES('HE170051', 'M', 'MLD', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE170245', 'M', 'MLD', 'FA21', 'SP22')
INSERT INTO Memberships VALUES('HE170245', 'T', 'MLD', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE170245', 'S', 'NS', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE170422', 'P', 'GHC', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE170428', 'S', 'GHC', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE170788', 'M', 'MLD', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE170842', 'M', 'IGO', 'FA22', 'SU22')
INSERT INTO Memberships VALUES('HE170842', 'S', 'IGO', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE170863', 'M', 'JS', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE170907', 'M', 'JS', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE171162', 'M', 'NS', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE171071', 'P', 'MLD', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE161875', 'P', 'IGO', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE170996', 'P', 'JS', 'FA22', NULL)
INSERT INTO Memberships VALUES('HE171442', 'P', 'SWC', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE171687', 'P', 'NS', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE172579', 'P', 'VVN', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE176160', 'P', 'MM', 'FA22', NULL)
INSERT INTO Memberships VALUES('HE176182', 'M', 'SWC', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE176586', 'M', 'SWC', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE176697', 'M', 'SWC', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE176751', 'M', 'NS', 'FA22', NULL)
INSERT INTO Memberships VALUES('HE130479', 'V', 'GHC', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE140647', 'S', 'MLD', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE141057', 'V', 'IGO', 'SU22', NULL)
INSERT INTO Memberships VALUES('HE151333', 'V', 'JS', 'FA22', NULL)
INSERT INTO Memberships VALUES('HE160682', 'V', 'SWC', 'FA21', NULL)
INSERT INTO Memberships VALUES('HE160776', 'V', 'NS', 'SP22', NULL)
INSERT INTO Memberships VALUES('HE160776', 'M', 'MLD', 'SP22', 'FA22')
INSERT INTO Memberships VALUES('HE161861', 'V', 'MLD', 'FA22', NULL)



INSERT INTO [Events] VALUES('ID', N'International day ', '12/21/2020', '12/21/2020', N'Sân trường', '6000', '10875000', 'FPT HL')
INSERT INTO [Events] VALUES('HD', N'Halloween ', '7/14/2021', '7/14/2021', N'Đồi thông', '500', '3654000', 'NONE')
INSERT INTO [Events] VALUES('VV', N'Võ Việt tranh hùng đoạt Cóc Vương ', '5/18/2022', '5/18/2022', N'Sân tập ', '37000000', '25000000', 'Liên đoàn Võ')
INSERT INTO [Events] VALUES('HK', N'Hackathon', '10/31/2022', '10/31/2022', N'Delta', '156', '133000000', 'ĐH FPT HL, HCM, ĐN, CT')
INSERT INTO [Events] VALUES('FC', N'FCamp', '12/2/2022', '12/2/2022', N'Alpha', '9000', '11300000', 'Gakkusei')


INSERT INTO Organize VALUES('ID', 'MLD')
INSERT INTO Organize VALUES('ID', 'NS')
INSERT INTO Organize VALUES('ID', 'IGO')
INSERT INTO Organize VALUES('HK', 'JS')
INSERT INTO Organize VALUES('HK', 'MM')
INSERT INTO Organize VALUES('VV', 'VVN')
INSERT INTO Organize VALUES('ID', 'JS')


--=============================================================
SELECT * FROM Majors
SELECT * FROM Roles
SELECT * FROM Semesters
SELECT * FROM Students
SELECT * FROM Clubs
SELECT * FROM Memberships
SELECT * FROM [Events]
SELECT * FROM Organize

/*
Write some at least 1 query for each of the following requirements. All queries should be saved in the queries.sql file.
	Query using inner join.
	Query using outer join.
	Using subquery in where.
	Using subquery in from.
	Query using group by and aggregate functions.
Write at least one transaction using rollback and save into the transaction.sql file.
Write at least one trigger and save into trigger.sql file.
Write at least one procedure and save into procedure.sql file.

*/
--CÂU 7  
--a. Query using inner join.
	--	Hiển thị thông tin của những sinh viên đã tham gia câu lạc bộ và vai trò hiện tại trong CLB đó 
SELECT s.StudentID, s.LastName + ' ' + s.MiddleName + ' ' + s.FirstName AS FullName, 
	   m.MajorID, c.ClubID, c.ClubName, r.RoleName
FROM Students s, Majors m , Clubs c, Memberships ms, Roles r
WHERE s.StudentID = ms.StudentID AND ms.ClubID = c.ClubID
	  AND s.MajorID = m.MajorID AND ms.RoleID = r.RoleID
	  AND ms.SemesEnd IS NULL 

	--Hiển thị tất cả vai trò của các thành viên trong CLB Melody 
SELECT s.StudentID, s.LastName + ' ' + s.MiddleName + ' ' + s.FirstName AS FullName, 
	   m.MajorID, r.RoleName, ms.SemesStart
FROM Students s, Majors m , Clubs c, Memberships ms, Roles r
WHERE s.StudentID = ms.StudentID AND ms.ClubID = c.ClubID
	  AND s.MajorID = m.MajorID AND ms.RoleID = r.RoleID
	  AND c.ClubName = 'CLB Melody'
	
--b. Query using outer join
	-- Đếm số lượng CLB mà mỗi sinh viên tham gia 
SELECT s.StudentID, s.LastName + ' ' + s.MiddleName + ' ' + s.FirstName AS FullName, COUNT(DISTINCT m.ClubID) NoClubs 
	FROM Students s LEFT JOIN Memberships m ON s.StudentID = m.StudentID
	GROUP BY s.StudentID, s.FirstName, s.LastName, s.MiddleName

--c. Using subquery in where.
	--Hiển thị các thành viên là nữ trong CLB Kỹ sư phần mềm Nhật Bản  
	SELECT s.* FROM Memberships m JOIN Students s ON m.StudentID = s.StudentID
	WHERE m.ClubID = (SELECT ClubID FROM Clubs WHERE ClubName LIKE N'%Kỹ sư phần mềm Nhật Bản%')
	AND s.Gender = 'F' 

--d. Using subquery in from.	
 -- 2 sự kiện có chi phí lớn nhất và 2 sự kiện có chi phí nhỏ nhất 
 SELECT * FROM (SELECT TOP 2 e.EventName, e.Budget FROM [Events] e ORDER BY e.Budget DESC
				UNION SELECT TOP 2 e.EventName, e.Budget FROM [Events] e ORDER BY e.Budget)
				AS a 

--e. Query using group by and aggregate functions.
--	CLB có số thành viên nhỏ hơn số thành viên của CLB nhiều thành viên nhất 
--	 và đã tham gia ít nhất 1 sự kiện  
SELECT c.ClubID, c.ClubName, COUNT(DISTINCT m.StudentID) NoMembers, COUNT(DISTINCT o.EventID) NoEvents 
	FROM Clubs c LEFT JOIN Memberships m ON c.ClubID = m.ClubID
				 LEFT JOIN Organize o ON o.ClubID = c.ClubID
	GROUP BY c.ClubID, c.ClubName
	HAVING COUNT(DISTINCT m.StudentID) < (SELECT MAX(Numbers) FROM (SELECT COUNT(DISTINCT m.StudentID) as Numbers 
										FROM Clubs c LEFT JOIN Memberships m ON c.ClubID = m.ClubID
										GROUP BY c.ClubID, c.ClubName ) AS tableA)
	 AND COUNT(DISTINCT o.EventID) >= 1 

--CÂU 8  
-- Write at least one transaction using rollback and save into the transaction.sql file.
--	Viết transaction:
--	chèn vào bảng Students 1 sinh viên mới có mã HE160000, tên là Nguyễn Thanh An, giới tính nữ, ngày sinh 16/9/2002...
--	chèn 1 dòng vào bảng Memberships HE160000, 'M', 'FF', 'FA21'
									--mã sv, chức vụ, mã CLB, Kì bắt đầu 
--=> đây là 1 giao dịch chèn nội dung vào cả 2 bảng, ta phát hiện rằng khi chèn dòng 2 nó bị gây lỗi 
--	 vì mã CLB FF không tồn tại 
-- 	 khi mã mã CLB không tồn tại thì lệnh chèn 1 sinh viên phải được phục hồi 
--	=>mục đích: đây là tác vụ làm thay đổi dữ liệu của cả 2 bảng nhưng nếu chèn vào bảng thứ 2 có lỗi 
--	   thì tác vụ trên cần phải rollback 
--khi dùng transaction nếu 1 lệnh gây lỗi thì tất cả lệnh trước đó bị hủy bỏ 

go
BEGIN TRANSACTION 
	INSERT INTO Students VALUES ('HE160000', N'Nguyễn', N'Thanh', N'An', 'F', '1/1/2002', '0345695863', 'AnTNHE160000@fpt.edu.vn', 'SE')
	INSERT INTO Memberships VALUES ('HE160000','M', 'FF', 'FA21', NULL)
	IF @@error <> 0 
		BEGIN 
			ROLLBACK TRANSACTION 	
			PRINT N'Thông tin thêm vào không hợp lệ' 
		END 
	ELSE
		PRINT N'Đã thêm thành công vào 2 bảng'
COMMIT TRANSACTION

go

--CÂU 9 
-- Write at least one trigger and save into trigger.sql file.
	--Viết trigger trên bảng Memberships
	--	khi thêm 1 thành viên mới vào CLB thì role của thành viên mới phải khác present 
	--	khi xóa 1 thành viên: 
	--		nếu thành viên bị xóa đó có role khác president thì xóa được 
	--		nếu thành viên bị xóa đó là president thì cho hội phó lên thay
				--và cập nhật president mới cho table Clubs 
	-- khi update role cho 1 thành viên: 
	--		nếu update thành viên không là president thành president trong CLB đã có president thì ko update được 
	--		nếu up date các role khác president trong CLB đã có president thì update role mới cho thành viên đó được 

--DROP TRIGGER CHECK_HEAD
CREATE TRIGGER CHECK_HEAD
ON Memberships 
FOR INSERT, UPDATE, DELETE  
AS
BEGIN
	DECLARE @DELETED INT, @UPDATED INT,
			@Deleted_CLB_ID varchar(5),@Inserted_CLB_ID varchar(5), 
			@CountHead INT, @ViceID char(8), @CurrentHeadID char(8)

	SELECT @DELETED = COUNT(*) FROM [deleted]
	SELECT @UPDATED = COUNT(*) FROM [inserted]

		IF @UPDATED > 0
			BEGIN
				SELECT @Inserted_CLB_ID = [ClubID] FROM [inserted] 
				SELECT @CountHead = COUNT(*) FROM Memberships WHERE RoleID='P' AND ClubID = @Inserted_CLB_ID

				IF @CountHead > 1
					BEGIN
						PRINT 'Club '+@Inserted_CLB_ID+' already have President'
						ROLLBACK TRANSACTION
					END
			END
	--------------------------------
	 IF @DELETED > 0
		BEGIN
			SELECT @Deleted_CLB_ID = [ClubID] FROM [deleted] 
			SELECT @ViceID = StudentID FROM Memberships WHERE RoleID='V' AND ClubID = @Deleted_CLB_ID
			SELECT @CountHead = COUNT(*) FROM Memberships WHERE RoleID='P' AND ClubID = @Deleted_CLB_ID
		
			IF @CountHead = 0
				BEGIN
				UPDATE Memberships SET RoleID = 'P' WHERE StudentID = @ViceID
				UPDATE Clubs SET CurrentHead = @ViceID WHERE ClubID = @Deleted_CLB_ID
				END

		END
END

--Dùng bảng các thành viên trong CLB Melody để test trigger 
go
CREATE VIEW MelodyClub AS
(SELECT s.StudentID, s.LastName + ' ' + s.MiddleName + ' ' + s.FirstName AS FullName, 
	   m.MajorID, r.RoleName, ms.SemesStart
FROM Students s, Majors m , Clubs c, Memberships ms, Roles r
WHERE s.StudentID = ms.StudentID AND ms.ClubID = c.ClubID
	  AND s.MajorID = m.MajorID AND ms.RoleID = r.RoleID
	  AND c.ClubName = 'CLB Melody')
go

SELECT * FROM MelodyClub
SELECT * FROM Clubs
INSERT INTO Memberships VALUES('HE161875', 'P', 'MLD', 'SP22', NULL) --ko insert được vì là insert head 
DELETE FROM Memberships WHERE StudentID='HE171071' -- HE161861 Vice -> President 61 –xóa head đang có mã 171071 -> đưa phó có mã  HE161861 lên làm head 
DELETE FROM Memberships WHERE StudentID='HE140647'--xóa đc vì k là president 
UPDATE Memberships SET RoleID = 'P' WHERE StudentID = 'HE170788' --ko update đc 
UPDATE Memberships SET RoleID = 'S' WHERE StudentID = 'HE160776' --update đc vì k phải update thành head 


--Câu 10:
--Write at least one procedure and save into procedure.sql file.
--	tạo stored procedure nhập vào tên CLB hiển thị số lượng thành viên CLB đó  

GO
CREATE PROC ShowNumberOfMember @CName varchar(100)
AS 
	SELECT M.ClubID, C.ClubName, NumberOfMember = COUNT(DISTINCT m.StudentID) FROM Memberships M, Clubs C WHERE M.ClubID=C.ClubID
	AND C.ClubName LIKE '%'+@CName+'%'
	GROUP BY M.ClubID, C.ClubName

	EXEC ShowNumberOfMember 'M'
GO
--DROP PROC ShowNumberOfMember 

