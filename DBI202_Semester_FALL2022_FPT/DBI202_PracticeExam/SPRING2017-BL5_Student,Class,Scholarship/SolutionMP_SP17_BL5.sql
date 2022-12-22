/*
https://www.youtube.com/watch?v=XwSl7oNUDXM&t=1551s
*/

USE DBI202_SPRING2017_BLOCK5

SELECT * FROM Class 
SELECT * FROM Exam
SELECT * FROM Scholarship
SELECT * FROM Student
SELECT * FROM Student_Class
SELECT * FROM Student_Scholarship
SELECT * FROM [Subject]

--==============================================================
--Question 1
--	Select all male student 
SELECT * FROM Student WHERE studentGender = 1

--==============================================================
--Question 2
--	Select all student with average score of each student 
SELECT * FROM Exam
SELECT * FROM Student
SELECT e.studentID, AVG(e.examScore) FROM Exam e GROUP BY e.studentID

SELECT s.studentFName, s.studentLName, AVG(e.examScore) 
FROM Exam e JOIN Student s ON e.studentID = s.studentID
GROUP BY e.studentID, s.studentFName, s.studentLName

--==============================================================
--Question 3
--	Select all student who have average score between 5 and 6 
--	giống câu trên, chỉ cần thêm điều kiện having sau khi có bảng gom nhóm 

SELECT s.studentFName, s.studentLName, AVG(e.examScore) 
FROM Exam e JOIN Student s ON e.studentID = s.studentID
GROUP BY e.studentID, s.studentFName, s.studentLName
HAVING AVG(e.examScore) BETWEEN 5 AND 6 --OK1

SELECT s.studentFName, s.studentLName, AVG(e.examScore) 
FROM Exam e, Student s WHERE e.studentID = s.studentID --viết thay cho join 
GROUP BY e.studentID, s.studentFName, s.studentLName
HAVING AVG(e.examScore) >= 5 AND AVG(e.examScore) <= 6 --OK2 , viết thay cho between 

--==============================================================
--Question 4
--	Count all student in each class
SELECT * FROM Class 
SELECT * FROM Student_Class

SELECT * FROM Student_Class sc RIGHT JOIN Class c ON sc.classCode = c.classCode

SELECT c.classCode, COUNT(sc.studentID) 
		FROM Student_Class sc RIGHT JOIN Class c ON sc.classCode = c.classCode
		GROUP BY c.classCode

--==============================================================
--Question 5 
--	List all male students who are elder than 20.
SELECT * FROM Student

SELECT * FROM Student s where s.studentGender = 1 
							  AND YEAR(GETDATE()) - YEAR(s.studentDOB) > 20
--==============================================================
--Question 6
--	List all students and their class name.   
SELECT * FROM Class 
SELECT * FROM Student
SELECT * FROM Student_Class

SELECT * FROM Student s JOIN Student_Class sc ON s.studentID = sc.studentID
						JOIN Class c ON c.classCode = sc.classCode

--==============================================================
--Question 7 
-- List all students who win highest scholarship.
SELECT * FROM Student
SELECT * FROM Scholarship
SELECT * FROM Student_Scholarship

SELECT MAX(s.schoGranted) FROM Student_Scholarship ss JOIN Scholarship s ON s.schoName = ss.schoName --tìm đc max 

SELECT st.*, s.* 
	   FROM Student st JOIN Student_Scholarship ss  ON st.studentID = ss.StudentID
					   JOIN Scholarship s ON s.schoName = ss.schoName 
						WHERE s.schoGranted = --max 
											 (
											 SELECT MAX(s.schoGranted) FROM Student_Scholarship ss JOIN Scholarship s ON s.schoName = ss.schoName
											 )

--==============================================================
--Question 8  
-- List the total budget to grant for each types of scholarships.
-- tổng số tiền trả cho mỗi loại học bổng 

SELECT * FROM Scholarship
SELECT * FROM Student_Scholarship

SELECT s.schoName, COUNT(ss.schoName) 
		FROM Scholarship s LEFT JOIN Student_Scholarship ss  ON s.schoName = ss.schoName
		GROUP BY s.schoName  --đếm được số lượng mỗi loại hb 

SELECT s.schoName, COUNT(ss.schoName) * s.schoGranted AS total 
		FROM Scholarship s LEFT JOIN Student_Scholarship ss  ON s.schoName = ss.schoName
		GROUP BY s.schoName, s.schoGranted --OK 1 
