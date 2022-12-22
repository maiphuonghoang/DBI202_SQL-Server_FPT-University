/*
https://www.youtube.com/watch?v=ov5_eYtGMNE
*/

USE PE_DBI202_Sp2021_B5

SELECT * FROM Countries
SELECT * FROM Departments
SELECT * FROM Employees
SELECT * FROM Jobs
SELECT * FROM Locations
SELECT * FROM Regions
ItemId int references item(iID)--C1

ItemId int,
FOREIGN KEY(ItemId) references item(iID)
--==========================================================================
--Question 2
--	Select all employees having Salary greater than 9000
SELECT * FROM Employees WHERE Salary > 9000

--===========================================================================
--Question 3
--	Write a query to select JobID, JobTitle, min_salary of all 'Manager' jobs 
--	having the min_salary greater than 5000; display the results in descending 
--	order of min_salary then in ascending order of Job Title for the jobs having 
--	the same min_salary. Node that a job is called 'Manager' job if there is 
--	the word 'Manager' in its JobTitle.
SELECT * FROM Jobs

SELECT j.JobID, j.JobTitle, j.min_salary FROM Jobs j 
WHERE j.min_salary > 5000 AND j.JobTitle LIKE '%Manager%'
ORDER BY j.min_salary DESC, j.JobTitle


--==================================================================================
--Question 4
--	Write a query to display :
--	EmployeeID, FirstName, LastName, Salary, DepartmentName, StateProvince, CountryID
--	of all employees having the Salary greater than 3000 and who currently work 
--	for departments in the 'Washington' state of the 'US' country
SELECT * FROM Employees
SELECT * FROM Locations
SELECT * FROM Departments

SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, d.DepartmentName, l.StateProvince, l.CountryID
FROM Employees e JOIN Departments d ON e.DepartmentID = d.DepartmentID
				 JOIN Locations l ON l.LocationID = d.LocationID
WHERE e.Salary > 3000 AND l.StateProvince = 'Washington' AND l.CountryID = 'US'

--==================================================================================
--Question 5
--	Write a query to display :
--	where NumberOfDepartments is the number of departments in each location;
--	display the results in descending order of NumberOfDepartments then in ascending 
--	order of LocationID for locations having the same value of NumberOfDepartments

SELECT * FROM Departments
SELECT * FROM Locations

SELECT l.LocationID, l.StreetAddress, l.City, l.StateProvince, 
	   l.CountryID, COUNT(d.DepartmentID) AS NumberOfDepartments
FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
GROUP BY l.LocationID, l.StreetAddress, l.City, l.StateProvince, l.CountryID
ORDER BY NumberOfDepartments DESC, l.LocationID ASC

--==================================================================================
--Question 6
--	Write a query to display JobID, JobTitle, NumberOfEmployees of the jobs having 
--	the maximum number of employees (NumberOfEmployees)
SELECT * FROM Jobs
SELECT * FROM Employees 
SELECT COUNT(*) FROM Employees e JOIN Jobs j ON e.JobID = j.JobID GROUP BY e.JobID
SELECT MAX(NoJobs) FROM (SELECT COUNT(*) AS NoJobs FROM Employees e JOIN Jobs j ON e.JobID = j.JobID GROUP BY e.JobID) AS Tem

go
SELECT j.JobID, j.JobTitle, COUNT(e.JobID) AS NumberOfEmployees 
FROM Employees e JOIN Jobs j ON e.JobID = j.JobID 
GROUP BY j.JobID, j.JobTitle
HAVING COUNT(e.JobID) = (	--tìm max cách 1 
					SELECT MAX(NoJobs) FROM (SELECT COUNT(e.JobID) AS NoJobs FROM Employees e JOIN Jobs j ON e.JobID = j.JobID GROUP BY e.JobID) AS Tem
				   )
go --OK1 
go
SELECT j.JobID, j.JobTitle, COUNT(e.JobID) AS NumberOfEmployees 
FROM Employees e JOIN Jobs j ON e.JobID = j.JobID 
GROUP BY j.JobID, j.JobTitle
HAVING COUNT(e.JobID) = (	--tìm max cách 2 
					SELECT top 1 COUNT(e.JobID)  
						FROM Employees e JOIN Jobs j ON e.JobID = j.JobID 
						GROUP BY e.JobID ORDER BY COUNT(e.JobID) DESC										 
				   )
go --OK2 

go
SELECT j.JobID, j.JobTitle, COUNT(e.JobID) AS NumberOfEmployees 
FROM Employees e JOIN Jobs j ON e.JobID = j.JobID 
GROUP BY j.JobID, j.JobTitle
HAVING COUNT(e.JobID) >= ALL (
							SELECT COUNT(e.JobID) FROM Employees e JOIN Jobs j ON e.JobID = j.JobID GROUP BY e.JobID
						)
go   --OK3  

--========================================================================================
--Question 7				
--	Write a query to display , NumberOfSubordinates of each employee who manages at least 
--	one other employee or who has the Salary greater than 10000 where NumberOfSubordinates
--	is the number of employees that he/she manager 
--	Display the results in descending order of NumberOfSubordinates then 
--	in ascending order of LastName for employees having the same NumberOfSubordinates

SELECT * FROM Departments
SELECT * FROM Employees
-------------------------------------------------Cách 1  
SELECT e.ManagerID, COUNT(e.EmployeeID)
FROM Employees e
WHERE ManagerID IS NOT NULL 
GROUP BY e.ManagerID

SELECT e.EmployeeID as id FROM Departments d JOIN  Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 10000	

SELECT * FROM 
(SELECT e.EmployeeID as id FROM Departments d JOIN  Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 10000	
UNION 
SELECT e.ManagerID as id 
FROM Employees e
WHERE ManagerID IS NOT NULL 
GROUP BY e.ManagerID HAVING COUNT(*) > 0
) AS a 

go
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, e.DepartmentID, d.DepartmentName, COUNT(a.ManagerID) AS NumberOfSubordinates
FROM Departments d  JOIN  Employees e ON d.DepartmentID = e.DepartmentID 
				    LEFT JOIN Employees a ON e.EmployeeID = a.ManagerID 
WHERE e.EmployeeID IN 
(SELECT * FROM 
(SELECT e.EmployeeID as id FROM Departments d JOIN  Employees e ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 10000	
UNION 
SELECT e.ManagerID as id 
FROM Employees e
GROUP BY e.ManagerID HAVING COUNT(*) > 0
) AS idList )
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Salary, e.DepartmentID, d.DepartmentName
ORDER BY NumberOfSubordinates DESC, e.LastName
go --OK 1 
-------------------------------------------------Cách 2 
SELECT * FROM (
select a1.EmployeeID,a1.FirstName, a1.LastName, a1.Salary, a1.DepartmentID, a1.DepartmentName, count(a1.EmployeeID) as NumberOfSubordinates from
(select e.EmployeeID, e.FirstName, e.LastName, e.Salary,d.DepartmentID, d.DepartmentName from Employees e, Departments d where d.DepartmentID = e.DepartmentID) as a1
inner join Employees e
on a1.EmployeeID = e.ManagerID 
group by a1.EmployeeID,a1.FirstName, a1.LastName, a1.Salary, a1.DepartmentID, a1.DepartmentName
union
select a1.EmployeeID,a1.FirstName, a1.LastName, a1.Salary, a1.DepartmentID, a1.DepartmentName, count(e.ManagerID) as NumberOfSubordinates from
(select e.EmployeeID, e.FirstName, e.LastName, e.Salary,d.DepartmentID, d.DepartmentName 
	from Employees e, Departments d where d.DepartmentID = e.DepartmentID and e.Salary>10000) as a1
left join Employees e on a1.EmployeeID = e.ManagerID 
group by a1.EmployeeID,a1.FirstName, a1.LastName, a1.Salary, a1.DepartmentID, a1.DepartmentName
) AS v --xem video để hiểu
ORDER BY NumberOfSubordinates DESC, LastName


--===================================================================================
--Question 8 
--	Create a stored procedure name pr1 to calculate the number of departments in a given 
--	country where @countryID varchar(10) is the input parameter and @numberOfDepartment int 
--	is an output parameter of the procedure.

SELECT * FROM Employees
SELECT * FROM Locations
SELECT l.CountryID, COUNT(d.DepartmentID) 
FROM Departments d RIGHT JOIN Locations l ON d.LocationID = l.LocationID
GROUP BY l.CountryID

go
CREATE PROC pr1
@countryID varchar(10), @numberOfDepartment int output 
AS 
BEGIN
	SELECT @numberOfDepartment =  COUNT(d.DepartmentID) 
	FROM Departments d, Locations l
	WHERE d.LocationID = l.LocationID
	AND l.CountryID = @countryID
END

	--test 
		declare @x int
		exec pr1 'US', @x output 
		SELECT @x as NumberOfDepartments

DROP PROC pr1 
go

--===================================================================================
--Question 9 
--	Create a trigger name Tr1 for the insert statement on table Employees 
--	so that when we insert one or more employees into the table Employees 
--	the system will display EmployeeID, FirstName, LastName, DepartmentID, DepartmentName
--	of the employees that have been inserted 

SELECT * FROM Employees
SELECT * FROM Departments

go
CREATE TRIGGER Tr1 ON Employees
FOR INSERT 
AS
BEGIN
	/*SELECT i.EmployeeID, i.FirstName, i.LastName, i.DepartmentID, d.DepartmentName
	FROM inserted i, Departments d WHERE i.DepartmentID = d.DepartmentID 
	*/--Nếu dùng where thì sẽ bị mất 1 dòng ở inserted khi test do DepartmentID ở 2 bảng ko có null 
	SELECT i.EmployeeID, i.FirstName, i.LastName, i.DepartmentID, d.DepartmentName
	FROM inserted i LEFT JOIN Departments d ON i.DepartmentID = d.DepartmentID 
	--ROLLBACK --dùng khi test 
END

	--test
	insert into Employees(EmployeeID, FirstName, LastName, Email, JobID, DepartmentID)
				  values (1003, 'Alain', 'Boucher', 'alain.boucher@gmail.com', 'SH_CLERK', 50),
						 (1004, 'Muriel', 'Visani', 'muriel.visani@gmail.com','SA_REP', null)

DROP TRIGGER Tr1
go

--===================================================================================
--Question 10 
--	Write a query to remove from table Departments all department which has no employees 
SELECT * FROM Departments
SELECT * FROM Employees

DELETE FROM Departments WHERE DepartmentID NOT IN (SELECT DISTINCT DepartmentID FROM Employees)

