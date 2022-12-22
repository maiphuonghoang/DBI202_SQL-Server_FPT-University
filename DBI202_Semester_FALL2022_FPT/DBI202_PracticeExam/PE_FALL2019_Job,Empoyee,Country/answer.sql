-- 2
select * from Locations l
where l.CountryID = 'US' or l.CountryID='CA'
-- 3
select EmployeeID, FirstName, LastName, Salary, Commission_pct, 
HireDate from Employees where Salary between 4000 and 10000
and Commission_pct > 0 and FirstName like '%e%'
order by HireDate DESC
-- 4
select e.EmployeeID, e.FirstName, e.LastName, e.HireDate, 
j.JobID, j.JobTitle,e.DepartmentID
from Jobs j, Employees e
where j.JobID = e.JobID
and j.JobTitle = 'Stock Clerk'
and YEAR(e.HireDate) = '%2005%'
-- 5
select e.JobID, j.JobTitle, count(*) as NumberOfEmployess
from Employees e, Jobs j
where j.JobID = e.JobID
group by e.JobID, j.JobTitle
order by NumberOfEmployess DESC
--6 
Select * from Countries
where CountryID not in 
(Select distinct l.CountryID from Locations l, Departments d 
where l.LocationID = d.LocationID);

-- 7

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

-- 8
create proc proc2 @fromDate date, @toDate date, @count int output
as
begin
	set @count = (select count(*) from Employees where HireDate
	between @fromDate and @toDate)
end

declare @x int
exec proc2 '2002-01-01', '2002-12-31', @x output
select @x as NumberOfEmployees

-- 9
drop trigger Tr2
create trigger Tr2
on Departments for update
as
begin
	select de.DepartmentID, de.DepartmentName, de.ManagerID as OldManagerID, 
	i.ManagerID as NewManagerID from inserted i, deleted de
	group by  de.DepartmentID, de.DepartmentName, de.ManagerID, 
	i.ManagerID
	order by de.DepartmentID DESC
end

update Departments
set ManagerID=200
where DepartmentID in (110,80)

-- 10
delete from Locations
where LocationID in
(select LocationID from Locations where LocationID not in 
(select LocationID from Departments))

select * from Locations