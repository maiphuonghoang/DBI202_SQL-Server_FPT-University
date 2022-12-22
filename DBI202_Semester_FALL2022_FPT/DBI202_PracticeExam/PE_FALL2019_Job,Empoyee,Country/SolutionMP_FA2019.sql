
USE PE_DBI202_F2019

SELECT * FROM Countries
SELECT * FROM Departments
SELECT * FROM Employees
SELECT * FROM JobHistory
SELECT * FROM Jobs
SELECT * FROM Locations
SELECT * FROM Regions

--=====================================================================
--Question 2 
--	Select all locations in 'US' or 'CA'
SELECT *  FROM Locations WHERE CountryID IN ('US', 'CA') --OK1
SELECT *  FROM Locations WHERE CountryID = 'US' OR CountryID ='CA' --OK2 

--=====================================================================
--Question 3 
--	Write a query to select EmployeeID, FirstName, LastName,
--	Salary, Commission_pct, HireDate
--	of all employees having Salary between 4000 and 10000,
--	having Commission_pct greater than 0 and their FirstName 
--	contains at least an 'E' or 'e'; display the results by 
--	descending order of HireDate 
SELECT * FROM Employees

SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, e.Commission_pct, e.HireDate
FROM Employees e 
WHERE e.Salary BETWEEN 4000 AND 10000
	  AND e.Commission_pct > 0 
	  AND e.FirstName LIKE '%[Ee]%'
ORDER BY e.HireDate DESC 

--=============================================================================
--Question 4 
--	Write a query to display EmployeeID, FirstName, LastName, 
--	HireDate, JobID, JobTitle, DepartmentID, DepartmentName
--	of all empoyees who were hired in 2005 and who work as 'Stock Clerk'
SELECT * FROM Employees
SELECT * FROM Jobs
SELECT * FROM Departments

SELECT e.EmployeeID, e.FirstName, e.LastName, e.HireDate, e.JobID, j.JobTitle, e.DepartmentID, d.DepartmentName
		FROM Employees e JOIN Jobs j ON e.JobID = j.JobID
						 JOIN Departments d ON d.DepartmentID = e.DepartmentID
						 WHERE YEAR(e.HireDate) = 2005 AND j.JobTitle = 'Stock Clerk'

--==============================================================================
--Question 5 
--	Write a query to display JobID, JobTitle, NumberOfEmployees corresponding to 
--	each job; where NumberOfEmployees is the number of employees doing each job;
--	display the results by descending order of NumberOfEmployees
SELECT * FROM Employees
SELECT * FROM Jobs
SELECT j.JobID, COUNT(e.EmployeeID) FROM Employees e RIGHT JOIN Jobs j ON e.JobID = j.JobID GROUP BY j.JobID

SELECT j.JobID, j.JobTitle, COUNT(e.EmployeeID) AS NumberOfEmployees
	   FROM Employees e RIGHT JOIN Jobs j ON e.JobID = j.JobID 
	   GROUP BY j.JobID, j.JobTitle
	   ORDER BY NumberOfEmployees DESC 

--==============================================================================
--Question 6 
--	Write a query to display of all countries having no department 
SELECT * FROM Countries
SELECT * FROM Departments
SELECT * FROM Locations

--C1 
SELECT * FROM Countries WHERE CountryID NOT IN 
	(SELECT DISTINCT l.CountryID FROM Departments d, Locations l WHERE d.LocationID = l.LocationID) --OK 1 -CÁCH NÀY CÓ THỂ SAI 

--các bước làm C2  

SELECT l.LocationID, c.*, COUNT(d.DepartmentID) FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
							FULL JOIN Countries c ON c.CountryID = l.CountryID
							GROUP BY l.LocationID, c.CountryID, c.CountryName, c.RegionID

SELECT  l.LocationID, c.* FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
							FULL JOIN Countries c ON c.CountryID = l.CountryID
							GROUP BY l.LocationID, c.CountryID, c.CountryName, c.RegionID
							HAVING COUNT(d.DepartmentID) = 0 

SELECT  c.* FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
							FULL JOIN Countries c ON c.CountryID = l.CountryID
							GROUP BY l.LocationID, c.CountryID, c.CountryName, c.RegionID
							HAVING COUNT(d.DepartmentID) = 0 --27 row 

SELECT DISTINCT c.* FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
							FULL JOIN Countries c ON c.CountryID = l.CountryID
							GROUP BY c.CountryID, c.CountryName, c.RegionID
							HAVING COUNT(d.DepartmentID) = 0 --21 row --OK2  

--==============================================================================
--Question 7 
--	Write a query to display EmployeeID, FirstName, LastName, NumberOfSubordinates 
--	of each employee who manages at least one other employee or who is in the 
--	'IT' department where NumberOfSubordinates is the number of employees that 
--	he/she manages  

SELECT * FROM Departments
SELECT * FROM Employees

---Cách 1 
SELECT e.EmployeeID as id FROM Employees e, Departments d 
WHERE e.DepartmentID = d.DepartmentID AND d.DepartmentName = 'IT'
 
SELECT e.ManagerID as id, COUNT(e.EmployeeID) 
FROM Employees e 
GROUP BY e.ManagerID

SELECT * FROM
(SELECT e.EmployeeID as id FROM Employees e, Departments d 
WHERE e.DepartmentID = d.DepartmentID AND d.DepartmentName = 'IT'
UNION 
SELECT e.ManagerID as id
FROM Employees e 
GROUP BY e.ManagerID
HAVING COUNT(e.EmployeeID) > 0) AS a 

go
SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentID, d.DepartmentName, COUNT(a.ManagerID) AS NumberOfSubordinates
FROM Departments d JOIN Employees e ON d.DepartmentID = e.DepartmentID
				   LEFT JOIN Employees a ON e.EmployeeID = a.ManagerID
WHERE e.EmployeeID IN 
	(SELECT * FROM
	(SELECT e.EmployeeID as id FROM Employees e, Departments d 
	WHERE e.DepartmentID = d.DepartmentID AND d.DepartmentName = 'IT'
	UNION 
	SELECT e.ManagerID as id FROM Employees e 
	GROUP BY e.ManagerID
	HAVING COUNT(e.EmployeeID) > 0) AS a )
GROUP BY e.EmployeeID, e.FirstName, e.LastName, d.DepartmentID, d.DepartmentName
ORDER BY NumberOfSubordinates DESC
go-- OK1 

--Cách 2 
go
SELECT b.EmployeeID ,b.FirstName ,b.LastName,b.DepartmentID,c.DepartmentName,COUNT(a.EmployeeID) AS NumberOfSubordinates
FROM  Employees a
RIGHT JOIN Employees b ON b.EmployeeID = a.ManagerID
INNER JOIN Departments c ON c.DepartmentID = b.DepartmentID
WHERE  b.EmployeeID in (Select EmployeeID from 
((Select e.EmployeeID from Employees e, Departments d where e.DepartmentID = d.DepartmentID and d.DepartmentName = 'IT')
Union
(Select e.EmployeeID
from Employees e , Employees e1, Departments d
where (e.DepartmentID = d.DepartmentID and e.EmployeeID = e1.ManagerID))) as A)
GROUP BY b.EmployeeID, b.FirstName,b.LastName,b.DepartmentID,c.DepartmentName
ORDER BY NumberOfSubordinates DESC
go --OK2 

--Cách 3 
go
SELECT  b.EmployeeID ,
        b.FirstName ,
        b.LastName ,
        b.DepartmentID ,
        c.DepartmentName ,
        COUNT(a.EmployeeID) AS NumberOfSubordinates
FROM    dbo.Employees AS a
        RIGHT JOIN dbo.Employees AS b ON b.EmployeeID = a.ManagerID
        INNER JOIN dbo.Departments AS c ON c.DepartmentID = b.DepartmentID
WHERE   b.EmployeeID IN (
        SELECT  b.EmployeeID
        FROM    dbo.Employees AS a
                RIGHT JOIN dbo.Employees AS b ON b.EmployeeID = a.ManagerID
                INNER JOIN dbo.Departments AS c ON c.DepartmentID = b.DepartmentID
        GROUP BY b.EmployeeID
        HAVING  COUNT(a.EmployeeID) > 0 )
        OR c.DepartmentName = 'IT'
GROUP BY b.EmployeeID ,
        b.FirstName ,
        b.LastName ,
        b.DepartmentID ,
        c.DepartmentName
ORDER BY NumberOfSubordinates DESC
go --OK 3 
--===================================================================================
--Question 8 
--	Create a stored procedure name proc2 for calculating the number of employees who 
--	were hired between @fromDate and @toDate,
--	where @fromDate and @toDate are the input parameters and @numberOfEmployees int 
--	is an output parameter of the procedure.

SELECT * FROM Employees

go
CREATE PROC proc2 
@fromDate date, @toDate date, @numberOfEmployees int output 
AS 
BEGIN
	SELECT @numberOfEmployees =  COUNT(EmployeeID) 
	FROM Employees WHERE HireDate BETWEEN @fromDate AND @toDate
END

	--test 
		declare @x int
		exec proc2 '2002-01-01', '2002-12-31', @x output
		select @x as NumberOfEmployees

DROP PROC proc2 
go

--===================================================================================
--Question 9 
--	Create a trigger name Tr2 for the update statement on table Departments 
--	so that when we update the ManagerID of one or more Departments,
--	the system will display DepartmentID, DepartmentName,  OldManagerID, NewManagerID
--	of the departments that have been updated; where OldManagerID is the ManagerID 
--	before updated and NewManagerID is the ManagerID after updated 

SELECT * FROM Departments

go
CREATE TRIGGER Tr2 ON Departments 
FOR UPDATE  
AS
BEGIN
	SELECT i.DepartmentID, i.DepartmentName, d.ManagerID AS OldManagerID, i.ManagerID AS NewManagerID
	FROM inserted i, deleted d WHERE i.DepartmentID = d.DepartmentID
	ORDER BY i.DepartmentID DESC
	--ROLLBACK --dùng khi test 
END

	--test
		update Departments set ManagerID = 100
		where DepartmentID in (110,80)

DROP TRIGGER Tr2
go

--===================================================================================
--Question 10 
--	Write a query to remove from table Locations all location which has no departments.
SELECT * FROM Departments
SELECT * FROM Locations

DELETE FROM Locations WHERE LocationID NOT IN 
(SELECT LocationID FROM Departments)

DELETE FROM Locations WHERE LocationID IN
(SELECT LocationID FROM Locations 
EXCEPT SELECT LocationID FROM Departments)

--===================================================================================
--Question 1
USE GIAI_DE_PE
-- Đối với những ERD không ghi rõ 1 – N thì tạo bảng được trỏ đến theo chiều mũi tên
-- Thứ tự tạo bảng: Departments – Offices - Employees

CREATE TABLE DepartmentsV
(
	DeptID varchar(15) PRIMARY KEY,
	Name nvarchar(60)
)

CREATE TABLE Offices
(
	OfficeNumber int IDENTITY PRIMARY KEY,
	Address nvarchar(30),
	Phone varchar(15),
	DeptID varchar(15) FOREIGN KEY REFERENCES DepartmentsV(DeptID)
)

CREATE TABLE EmployeesV
(
	EmployeeID int IDENTITY PRIMARY KEY,
	FullName nvarchar(50),
	OfficeNumber int FOREIGN KEY REFERENCES Offices(OfficeNumber)
)

-- Đối với những relasionship có các thuộc tính riêng(hình thoi), ta cần tạo thêm bảng 
--có tên là nội dung bên trong hình thoi và nó được tạo sau các bảng được nối với nó
CREATE TABLE WorkFor
(
	[From] date PRIMARY KEY ,
	Salary float ,
	[To] date,
	PRIMARY KEY([From],EmployeeID, DeptID),
	EmployeeID int REFERENCES EmployeesV(EmployeeID),
	DeptID varchar(15) REFERENCES DepartmentsV(DeptID)
)