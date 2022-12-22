
USE GIAI_DE_PE

CREATE TABLE [Routes] 
(	
	RouteNumber int PRIMARY KEY,
	StartTime time,
	EndTime time,
)
CREATE TABLE Buses 
(
	BusNumber varchar(15) PRIMARY KEY,
	totalSeats int,
	Company nvarchar(100),
	RouteNumber int REFERENCES [Routes] (RouteNumber)
)
CREATE TABLE Stations
(
	StationName nvarchar(50) PRIMARY KEY,
	[Address] nvarchar(100)
)
CREATE TABLE Has 
(	
	StationNumber int, 
	StationName nvarchar(50) REFERENCES Stations(StationName), 
	RouteNumber int REFERENCES [Routes](RouteNumber)
	PRIMARY KEY(StationNumber, StationName, RouteNumber)
)
--=================================================================================================

USE PE_DBI202_Su2022_B5

SELECT * FROM offices
SELECT * FROM orderdetails
SELECT * FROM orders
SELECT * FROM payments
SELECT * FROM products
SELECT * FROM employees
SELECT * FROM customers
--=================================================================================================
--Question 2
--	Displaye employeeNumber, lastName, firstName, email, jobTitle of all employees having 
--	'Sales Rep' as his/her jobTitle 

SELECT employeeNumber,lastName, firstName, email, jobTitle 
	FROM employees WHERE jobTitle = 'Sales Rep'
--=================================================================================================
--Question 3 
--	Write a query to select employeeNumber, employeeFullname, jobTitle,	officeCode, officeCity, 
--	officeState, officeCountry corresponding to all employees worked in an ofifice in France or in USA;
--	where employeeFullname is the concateation of the employee's firstName, a whitespace character and 
--	the employee's lastName. Display the results by ascending order of officeCountry, then by ascending 
--	order of officeCity for employees from a same country, finally by ascending order of employeeNumber 
--	for employees from a same city  
SELECT * FROM offices
SELECT * FROM employees

SELECT e.employeeNumber, e.firstName + ' ' + e.lastName AS employeeFullname, e.jobTitle, 
	   o.officeCode, o.city officeCity, o.state officeState, o.country officeCountry
	FROM offices o, employees e 
	WHERE o.officeCode = e.officeCode
		  AND o.country IN ('France', 'USA')
	ORDER BY o.country, o.city, e.employeeNumber
--=================================================================================================
--Question 4:
--	Write a query to display customerNumber, customerName, city, state, country of all the customers 
--	who bought any product of the line 'Classic Cars' in Aprial 2004 or in May 2004  (using orderDate)
--	Display the results by ascending order of country then by ascending order of customerName 
--	for customers from a same country 
SELECT * FROM customers
SELECT * FROM orderdetails
SELECT * FROM orders
SELECT * FROM products

SELECT DISTINCT c.customerNumber, c.customerName, c.city, c.state, c.country 
	FROM customers c JOIN orders o ON c.customerNumber = o.customerNumber
					 JOIN orderdetails od ON od.orderNumber = o.orderNumber
					 JOIN products p ON p.productCode = od.productCode
		WHERE p.productLine = 'Classic Cars'
		      AND YEAR(o.orderDate) = 2004 
		      AND MONTH(o.orderDate) IN (4, 5)
		ORDER BY c.country, c.customerName

--=================================================================================================
--Question 5 
--	Write a query to display customerNumber, customerName, city, state, country, NumberOfOrders, 
--	TotalPaymentAmount corresponding to each customers from the 'CA' or 'NY' states of 'USA';
--	where NumberOfOrders and TotalPaymentAmount are respectively the number of orders and the 
--	total amount of all payments made by each customer. Display the results by ascending order 
--	of state, then by ascending order of CustomerName for customers from a same state 
SELECT * FROM payments
SELECT * FROM customers
SELECT * FROM orders

SELECT c.customerNumber, COUNT(DISTINCT o.orderNumber), SUM(p.amount)
	FROM customers c LEFT JOIN orders o ON c.customerNumber = o.customerNumber
					 LEFT JOIN payments p ON p.customerNumber = c.customerNumber
	WHERE c.country = 'USA' AND c.state IN ('NY', 'CA')
	GROUP BY c.customerNumber

SELECT c.customerNumber, c.customerName, c.city, c.state, c.country,
 COUNT(DISTINCT o.orderNumber) AS NumberOfOrders, SUM(p.amount) TotalPaymentAmount
	FROM customers c LEFT JOIN orders o ON c.customerNumber = o.customerNumber
					 LEFT JOIN payments p ON p.customerNumber = c.customerNumber
	WHERE c.country = 'USA' AND c.state IN ('NY', 'CA')
	GROUP BY c.customerNumber, c.customerName, c.city, c.country, c.state
	ORDER BY c.state, c.customerName
--======================================================================================
--Question 6 
--	Write a query to display employeeNumber, lastName, firstName, NumberOfCustomers 
--	corresponding to the 'Sales Rep' employee(s) having the smallest and the highest 
--	NumberOfCustomers where NumberOfCustomers of an employee is the number of customers 
--	to whom the corresponding employee is 'Sales Rep'
SELECT * FROM employees
SELECT * FROM customers

--bước 1: đếm số lượng kh của từng nhân viên làm Sales Rep 
SELECT e.employeeNumber, COUNT(c.customerNumber) 
	FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	WHERE e.jobTitle = 'Sales Rep'
	GROUP BY e.employeeNumber

--bước 2: tìm max, min trong bảng b1 
SELECT MAX(NoCustomers) AS maxi, MIN(NoCustomers) AS mini
FROM 	
	(SELECT COUNT(c.customerNumber) AS NoCustomers
	FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	WHERE e.jobTitle = 'Sales Rep'
	GROUP BY e.employeeNumber
	)
AS table1 

--bước 3: tìm nv có số lượng khách hàng = max/min vừa tìm ở b2 
SELECT e.employeeNumber, COUNT(c.customerNumber) AS NumberOfCustomers
	FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	WHERE e.jobTitle = 'Sales Rep'
	GROUP BY e.employeeNumber
	HAVING COUNT(c.customerNumber) =
									(
										SELECT MAX(NoCustomers) FROM 	
											(SELECT COUNT(c.customerNumber) AS NoCustomers
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
										)
										AS tableMax  
									) 
		OR COUNT(c.customerNumber) =
									(
										SELECT MIN(NoCustomers) FROM 	
											(SELECT COUNT(c.customerNumber) AS NoCustomers
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
										)
										AS tableMin   
									) 

--Answer
	--C1 
go
SELECT e.employeeNumber, e.lastName, e.firstName, COUNT(c.customerNumber) AS NumberOfCustomers
	FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	WHERE e.jobTitle = 'Sales Rep'
	GROUP BY e.employeeNumber, e.lastName, e.firstName
	HAVING COUNT(c.customerNumber) =
									(
										SELECT MAX(NoCustomers) FROM 	
											(SELECT COUNT(c.customerNumber) AS NoCustomers
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
										)
										AS tableMax  
									) 
		OR COUNT(c.customerNumber) =
									(
										SELECT MIN(NoCustomers) FROM 	
											(SELECT COUNT(c.customerNumber) AS NoCustomers
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
										)
										AS tableMin   
									) --OK 1 
go

	--C2
go
SELECT e.employeeNumber, e.lastName, e.firstName, COUNT(c.customerNumber) AS NumberOfCustomers
	FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	WHERE e.jobTitle = 'Sales Rep'
	GROUP BY e.employeeNumber, e.lastName, e.firstName
	HAVING COUNT(c.customerNumber) = 
									(
										SELECT TOP 1 COUNT(c.customerNumber) --tìm max C2 
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
											ORDER BY COUNT(c.customerNumber) DESC 
									)
		OR COUNT(c.customerNumber) =
									(
									SELECT TOP 1 COUNT(c.customerNumber) --tìm min C2 
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
											WHERE e.jobTitle = 'Sales Rep'
											GROUP BY e.employeeNumber
											ORDER BY COUNT(c.customerNumber)
									) --OK2 
go
--=================================================================================================
--Question 7
--	Write a query to display the 'Sales Rep' employee(s) having the smallest number of customers 
--	of each office. Display the results with officeCode, city, state, country, 
--	employeeNumber, lastName, firstName, jobtitle, NumberOfCustomers
--	where officeCode, city, state, country is the information of the office 
--	and employeeNumber, lastName, firstName, jobtitle, NumberOfCustomers is the information of 
--	the 'Sales Rep' employee(s) having the smallest number of customers of the corresponding office 
--	Display the results  by ascending order of oficeCode, then by ascending order of 
--	employeeNumber for employees of the same office 
SELECT * FROM employees
SELECT * FROM customers
SELECT * FROM offices
--bước 1: tìm số lượng kh của từng nhân viên theo mỗi cửa hàng  
SELECT o.officeCode, e.employeeNumber, COUNT(c.customerNumber) 
FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	JOIN offices o ON  o.officeCode = e.officeCode
WHERE e.jobTitle = 'Sales Rep'
GROUP BY e.employeeNumber, o.officeCode


--bước 2: tìm số lượng kh min của mỗi office 
SELECT table1.officeCode, MIN(NoCustomer) FROM 
(
SELECT o.officeCode, COUNT(c.customerNumber) AS NoCustomer 
FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
	JOIN offices o ON  o.officeCode = e.officeCode
WHERE e.jobTitle = 'Sales Rep'
GROUP BY e.employeeNumber, o.officeCode
) table1 
GROUP BY table1.officeCode

--bước 3: có số nv trong bảng min vừa tìm ở b2 đồng thời office phải là office có min đấy 
SELECT o.officeCode, e.employeeNumber, COUNT(c.customerNumber) AS NumberOfCustomers
FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
				 JOIN offices o ON  o.officeCode = e.officeCode
WHERE e.jobTitle = 'Sales Rep'
GROUP BY e.employeeNumber, o.officeCode
HAVING COUNT(c.customerNumber) IN (
									SELECT MIN(NoCustomer) as mini 
										FROM (
										SELECT o.officeCode, COUNT(c.customerNumber) AS NoCustomer 
										FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
														 JOIN offices o ON  o.officeCode = e.officeCode
										WHERE e.jobTitle = 'Sales Rep'
										GROUP BY e.employeeNumber, o.officeCode
										) table1 
										GROUP BY table1.officeCode	
									) 
		AND o.officeCode IN (
								SELECT table2.officeCode 
								FROM (
										SELECT table1.officeCode, MIN(NoCustomer) as mini 
										FROM (
											SELECT o.officeCode, COUNT(c.customerNumber) AS NoCustomer 
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
															 JOIN offices o ON  o.officeCode = e.officeCode
												WHERE e.jobTitle = 'Sales Rep'
												GROUP BY e.employeeNumber, o.officeCode
										) table1 
										GROUP BY table1.officeCode	
								)table2 
								WHERE table2.mini = COUNT(c.customerNumber) 
							)
ORDER BY o.officeCode, NumberOfCustomers

--Answer: hiển thị đủ các cột theo yêu cầu đề bài 
SELECT o.officeCode, o.city, o.state, o.country,
	   e.employeeNumber, e.lastName, e.firstName, e.jobTitle, COUNT(c.customerNumber) AS NumberOfCustomers
FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
				 JOIN offices o ON  o.officeCode = e.officeCode
WHERE e.jobTitle = 'Sales Rep'
GROUP BY e.employeeNumber, o.officeCode, o.city, o.state, o.country, e.lastName, e.firstName, e.jobTitle
HAVING COUNT(c.customerNumber) IN (
									SELECT MIN(NoCustomer) as mini 
										FROM (
										SELECT o.officeCode, COUNT(c.customerNumber) AS NoCustomer 
										FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
														 JOIN offices o ON  o.officeCode = e.officeCode
										WHERE e.jobTitle = 'Sales Rep'
										GROUP BY e.employeeNumber, o.officeCode
										) table1 
										GROUP BY table1.officeCode	
										--HAVING table1.officeCode = o.officeCode C2 luôn hay wa 
									) 
		AND o.officeCode IN (
								SELECT table2.officeCode 
								FROM (
										SELECT table1.officeCode, MIN(NoCustomer) as mini 
										FROM (
											SELECT o.officeCode, COUNT(c.customerNumber) AS NoCustomer 
											FROM employees e LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
															 JOIN offices o ON  o.officeCode = e.officeCode
												WHERE e.jobTitle = 'Sales Rep'
												GROUP BY e.employeeNumber, o.officeCode
										) table1 
										GROUP BY table1.officeCode	
								)table2 
								WHERE table2.mini = COUNT(c.customerNumber) 
							)
ORDER BY o.officeCode, NumberOfCustomers --OK 

--=================================================================================================
--Question 8 
--	Create a stored procedure named Proc1 to calculate the number of orders of a given customer
--	where customerNumber int is the input parameters and numberOfOrders int is an output parameter 
--	of the procedure 
SELECT * FROM orders
SELECT * FROM customers

SELECT c.customerNumber, COUNT(o.customerNumber) 
	FROM customers c LEFT JOIN orders o ON c.customerNumber = o.customerNumber
	GROUP BY c.customerNumber

go
CREATE PROC Proc1 @customerNumber int, @numberOfOrders int output 
AS
BEGIN 
	SELECT @numberOfOrders = COUNT(o.customerNumber) 
	FROM customers c LEFT JOIN orders o ON c.customerNumber = o.customerNumber
	WHERE c.customerNumber = @customerNumber
END 
go

		--test 
		declare @x int
		execute Proc1 114, @x output 
		select @x as NumberOfOrders 

--=================================================================================================
--Question 9 
--	Create a trigger name Tr1 for the delete statement on table orderdetails so that when we delete 
--	one or more rows from the table orderdetails, the system will display 
--  productCode, productName, orderNumber, orderDate, quantityOrdered, priceEach 
--	corresonding to the rows that have been deleted 
SELECT * FROM orderdetails
SELECT * FROM orders
SELECT * FROM products
go
CREATE TRIGGER Tr1 ON orderdetails
FOR DELETE 
AS
BEGIN
	SELECT p.productCode, p.productName, o.orderNumber, o.orderDate, d.quantityOrdered, d.priceEach 
	FROM deleted d JOIN products p ON d.productCode = p.productCode
	JOIN orders o ON d.orderNumber = o.orderNumber
	--ROLLBACK 
END 
go
drop trigger  Tr1
		--test 
		delete from orderdetails where orderNumber = 10100
		delete from orderdetails where orderNumber = 10118 

--=================================================================================================
--Question 10 
--	Write a query to insert an order having orderNumber = 10900, orderDate on 12 august 2022,
--	requiredDate on 17 august 2022, shippedDate on 16 august 2022, status = 'Shipped',
--	customerNumber = 450, the other information is null 
SELECT * FROM orders
SELECT CONVERT (date, '12 august 2022') 
DELETE FROM orders WHERE orderNumber = 10900

INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber)
			VALUES (10900, CONVERT (date, '12 august 2022'), CONVERT(date, '17 august 2022'), 
					CONVERT(date, '16 august 2022'), 'Shipped', 450)
					

				


