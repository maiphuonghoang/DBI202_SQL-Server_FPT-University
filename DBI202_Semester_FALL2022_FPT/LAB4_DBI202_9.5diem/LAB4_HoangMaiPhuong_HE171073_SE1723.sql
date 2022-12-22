CREATE DATABASE LAB4_HE171073_HMP_SE1723
USE LAB4_HE171073_HMP_SE1723

CREATE TABLE Departments (
	DeptID varchar(4) PRIMARY KEY,
	[Name] nvarchar(50) NOT NULL,
	NoOfStudents int
)

CREATE TABLE Students (
	StudentID varchar(4) PRIMARY KEY,
	LastName nvarchar(10),
	FirstName nvarchar(30),
	Sex varchar(1),
	DateOfBirth date,
	PlaceOfBirth nvarchar(30),
	DeptID varchar(4) REFERENCES Departments(DeptID),
	Scholarship float,
	AverageScore numeric(4,2)	
)
ALTER TABLE Students ADD CONSTRAINT CK_Sex CHECK (Sex IN('F','M'))

CREATE TABLE Courses (
	CourseID varchar(4) PRIMARY KEY,
	[Name] nvarchar(35),
	Credits tinyint
)

CREATE TABLE Results(
	StudentID varchar(4) REFERENCES Students(StudentID),
	CourseID varchar(4) REFERENCES Courses(CourseID),
	[Year] int,
	Semester int,
	Mark float(1),
	Grade varchar(6),
	PRIMARY KEY(StudentID, CourseID, [Year], Semester)
)

--DROP TABLE Results
--DROP TABLE Students
--DROP TABLE Courses
--DROP TABLE Departments
---------------------------
INSERT INTO Departments (DeptID, [Name])
VALUES ('IS', 'Information Systems'),
	   ('NC', 'Network and Communication'),
	   ('SE', 'Software Engineering'),
	   ('CE', 'Computer Engineering' ),
	   ('CS', 'Computer Science')

INSERT INTO Students (StudentID, LastName, FirstName, Sex, DateOfBirth, PlaceOfBirth, DeptID, Scholarship)
			   VALUES('S001', N'Lê', N'Kim Lan', 'F','23/02/1990 ', N'Hà Nội', 'IS', 130000),
					 ('S002', N'Trần', N'Minh Chánh', 'M', '24/12/1992 ', N'Bình Định', 'NC', 150000),
					 ('S003', N'Lê', N'An Tuyết', 'F', '21/02/1991' , N'Hải Phòng', 'IS', 170000),
					 ('S004', N'Trần', N'Anh Tuấn', 'M', '20/12/1993 ', N'TpHCM', 'NC', 80000),
					 ('S005', N'Trần', N'Thị Mai', 'F', '12/08/1991', N'TpHCM', 'SE', 0),
					 ('S006', N'Lê', N'Thị Thu Thủy', 'F', '02/01/1991', N'An Giang', 'IS', 0),
					 ('S007', N'Nguyễn', N'Kim Thư', 'F', '02/02/1990 ', N'Hà Nội', 'SE', 180000),
					 ('S008', N'Lê', N'Văn Long', 'M', '08/12/1992 ', N'TpHCM', 'IS', 190000);

INSERT INTO Courses 
VALUES ('DS01', 'Database Systems', 3), 
	   ('AI01', 'Artificial Intelligence', 3),
	   ('CN01', 'Computer Network', 3),
	   ('CG01', 'Computer Graphics', 4 ),
	   ('DSA1', 'Data Structures and Algorithms', 4)

INSERT INTO Results (StudentID, CourseID, [Year], Semester, Mark)
 VALUES ('S001', 'DS01', 2017, 1, 3), ('S001', 'DS01', 2017, 2, 6),
		('S001', 'AI01', 2017, 1, 4.5), ('S001', 'AI01', 2017, 2, 6),
		('S001', 'CN01', 2017, 3, 5), ('S002', 'DS01', 2016, 1, 4.5),
		('S002', 'DS01', 2017, 1, 7), ('S002', 'CN01', 2016, 3, 10),
		('S002', 'DSA1', 2016, 3, 9), ('S003', 'DS01', 2017, 1, 2),
		('S003', 'DS01', 2017, 3, 5), ('S003', 'CN01', 2017, 2, 2.5),
		('S003', 'CN01', 2017, 3, 4), ('S004', 'DS01', 2017, 3, 4.5),
		('S004', 'DSA1', 2018, 1, 10), ('S005', 'DS01', 2017, 2, 7),
		('S005', 'CN01', 2017, 2, 2.5), ('S005', 'CN01', 2018, 1, 5),
		('S006', 'AI01', 2018, 1, 6), ('S006', 'CN01', 2018, 2, 10)
---------------------------
SELECT * FROM Departments
SELECT * FROM Students
SELECT * FROM Courses
SELECT * FROM Results
--======================================================================================
--Question 2.	
--	Update NoOfStudents of each department in Departments table where NoOfStudents is the 
--	total number of students of each departments. Note that for department that has no student, 
--	the NoOfStudents should be 0.
SELECT * FROM Departments
SELECT * FROM Students

--đếm số lượng sinh viên của mỗi phòng ban 
SELECT d.DeptID, COUNT(s.DeptID) AS Number
FROM Departments d LEFT JOIN Students s ON d.DeptID = s.DeptID
GROUP BY d.DeptID

--Answer:
UPDATE Departments SET NoOfStudents = ( SELECT COUNT(DeptID) FROM Students WHERE Students.DeptID = Departments.DeptID)


--======================================================================================
--Question 3.	
--	Update AverageScore for each student so that for each course, we take only his/her 
--	highest Mark and the AverageScore of the student is calculated as the average mark 
--	of all the courses that the student joins.
SELECT * FROM Students
SELECT * FROM Results
--bước 1 
SELECT StudentID, CourseID, MAX(Mark) FROM Results GROUP BY StudentID, CourseID
--Answer:
UPDATE Students SET AverageScore = (
									SELECT AVG(MarkMax) 
										FROM (
												SELECT StudentID, CourseID, MAX(Mark) AS MarkMax FROM Results GROUP BY StudentID, CourseID
											 ) AS MarkList
										WHERE MarkList.StudentID = Students.StudentID
									)
--======================================================================================
--Question 4.	Update Grade in table Results so that:
--•	Grade = ‘Passed’ if 5	<= Mark <= 10
--•	Grade = ‘Failed’ if 0	<= Mark < 5
SELECT * FROM Results

--C1:
UPDATE Results SET Grade = (SELECT IIF (Mark >= 5, 'Passed', 'Failed'))
--C2:
UPDATE Results SET Grade = CASE WHEN Mark >=5 THEN 'Passed'
								ELSE 'Failed'
						   END 

--======================================================================================
--Question 5.	 List (StudentID, Fullname, DateOfBirth, PlaceOfBirth, DeptID, Scholarship) 
--	of all students having Scholarship not greater than 160000, in descending order of Scholarship. 
--	Note that FullName is the concatenation of LastName and FirstName. 
--	For example, if LastName = ‘Lê’ and FirstName = ‘Kim Lan’, then Fullname should be ‘Kim Lan Lê’.
SELECT * FROM Students

--Answer:
SELECT s.StudentID, s.FirstName + ' ' + s.LastName AS FullName, 
	   s.DateOfBirth, s.PlaceOfBirth, s.DeptID, s.Scholarship
FROM Students s WHERE s.Scholarship < 160000 
ORDER BY S.Scholarship DESC 

--======================================================================================
--Question 6.	
--	List (DeptID, DepartmentName, StudentID, LastName, FirstName) of all departments (KHOA) 
--	so that we see also departments which have no students.
SELECT * FROM Departments
SELECT * FROM Students

--Answer:
SELECT d.DeptID, d.Name AS DepartmentName, s.StudentID, s.LastName, s.FirstName
FROM Departments d LEFT JOIN Students s ON d.DeptID = s.DeptID

--======================================================================================	
--Question 7.	
--	List (StudentID, LastName, FirstName, NumberOfCourses) of all students, 
--	show the results in ascending order of NumberOfCourses 
--	where NumberOfCourses is the total number of courses studied by each student.
SELECT * FROM Results
SELECT * FROM Students

--Answer:
SELECT s.StudentID, s.LastName, s.FirstName, COUNT(r.StudentID) AS NumberOfCourses 
	   FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
	   GROUP BY s.StudentID, s.LastName, s.FirstName
	   ORDER BY NumberOfCourses 

--======================================================================================	
--Question 8.	
--	List (DeptID, DepartmentName, NumberOfFemaleStudents, NumberOfMaleStudents) of all departments.
SELECT * FROM Departments
SELECT * FROM Students

--Answer:
SELECT d.DeptID, d.Name AS DepartmentName, 
	   (SELECT COUNT(*) FROM Students s WHERE s.Sex = 'F' AND s.DeptID = d.DeptID) AS NumberOfFemaleStudents,
	   (SELECT COUNT(*) FROM Students s WHERE s.Sex = 'M' AND s.DeptID = d.DeptID) AS NumberOfMaleStudents
FROM Departments d

--======================================================================================	
--Question 9.	
--	Show the list of students which are not in the department ‘Information Systems’ but having 
--	Mark of Database Systems greater than at least one student of department ‘Information Systems’.
SELECT * FROM Results
SELECT * FROM Students
SELECT * FROM Courses
SELECT * FROM Departments

--bước 1: có 2 bảng xem dữ liệu 
SELECT s.StudentID, s.DeptID, r.CourseID, r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
WHERE s.DeptID != 'IS'

SELECT s.StudentID, s.DeptID, r.CourseID, r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
WHERE s.DeptID = 'IS'

--bước 2: điểm Database Systems của những sv ‘Information Systems’
SELECT r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
WHERE s.DeptID = 'IS' AND r.CourseID = 'DS01'

--bước 3: sv k học IS có điểm DS > điểm DS của ít nhất 1 sv k học IS 
SELECT s.StudentID, s.DeptID, r.CourseID, r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
WHERE s.DeptID != 'IS' AND r.CourseID = 'DS01' 
AND r.Mark > ANY( --của b2 
				SELECT r.Mark
				FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
				WHERE s.DeptID = 'IS' AND r.CourseID = 'DS01'
				)

--bước 4: đồng nhất với câu hỏi đề bài 
SELECT s.StudentID, s.DeptID, r.CourseID, r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
WHERE s.DeptID != (SELECT d.DeptID FROM Departments d WHERE d.Name = 'Information Systems')
AND r.CourseID = (SELECT c.CourseID FROM Courses c WHERE c.Name = 'Database Systems') 
AND r.Mark > ANY( 
				SELECT r.Mark
				FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
				WHERE s.DeptID = (SELECT d.DeptID FROM Departments d WHERE d.Name = 'Information Systems')
				AND r.CourseID = (SELECT c.CourseID FROM Courses c WHERE c.Name = 'Database Systems')
				)
--Answer 
SELECT s.StudentID, s.LastName + ' ' + s.FirstName AS FullName, d.Name DepartmentName, c.Name CourseName, r.Mark
FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
				JOIN Departments d ON d.DeptID = s.DeptID
				JOIN Courses c ON c.CourseID = r.CourseID
WHERE s.DeptID != (SELECT d.DeptID FROM Departments d WHERE d.Name = 'Information Systems')
	  AND r.CourseID = (SELECT c.CourseID FROM Courses c WHERE c.Name = 'Database Systems') 
	  AND r.Mark > ANY( 
						SELECT r.Mark
						FROM Students s LEFT JOIN Results r ON s.StudentID = r.StudentID
						WHERE s.DeptID = (SELECT d.DeptID FROM Departments d WHERE d.Name = 'Information Systems')
							  AND r.CourseID = (SELECT c.CourseID FROM Courses c WHERE c.Name = 'Database Systems')
					   )
--======================================================================================	
--Question 10.	
--	List (CourseID, CourseName, BestStudentFullName) where BestStudentFullName is the name of 
--	the student who has the highest mark for this course.
SELECT * FROM Results
SELECT * FROM Students
SELECT * FROM Courses

--bước 1: group điểm theo mỗi course 
SELECT r.CourseID, r.StudentID, r.Mark
FROM Results r
GROUP BY r.CourseID, r.StudentID, r.Mark

--bước2: --tìm điểm cao nhất của từng course 
SELECT r.CourseID, MAX(r.Mark)
FROM Results r
GROUP BY r.CourseID

--bước 3: sv có điểm trong list điểm cao nhất đồng thời course cũng phải tương ứng với điểm cao nhất ấy 
SELECT r.CourseID, r.StudentID, r.Mark
FROM Results r
WHERE r.Mark IN (
					SELECT MAX(r.Mark) FROM Results r
					GROUP BY r.CourseID
					)
	 AND r.CourseID IN (
					SELECT table1.CourseID 
						FROM 
							(	SELECT r.CourseID, MAX(r.Mark) as Maxi
								FROM Results r GROUP BY r.CourseID
							) AS table1 
						WHERE table1.Maxi = r.Mark
					)
GROUP BY r.CourseID, r.StudentID, r.Mark

--Answer 
SELECT r.CourseID, c.Name AS CourseName, s.LastName + ' ' + s.FirstName AS BestStudentFullName
FROM Results r JOIN  Courses c ON r.CourseID = c.CourseID
			   JOIN Students s ON r.StudentID = s.StudentID
WHERE r.Mark IN (
					SELECT MAX(r.Mark) FROM Results r
					GROUP BY r.CourseID
					)
	 AND r.CourseID IN (
					SELECT table1.CourseID 
						FROM 
							(	SELECT r.CourseID, MAX(r.Mark) as Maxi
								FROM Results r GROUP BY r.CourseID
							) AS table1 
						WHERE table1.Maxi = r.Mark
					)
GROUP BY r.CourseID, c.Name, s.LastName, s.FirstName







