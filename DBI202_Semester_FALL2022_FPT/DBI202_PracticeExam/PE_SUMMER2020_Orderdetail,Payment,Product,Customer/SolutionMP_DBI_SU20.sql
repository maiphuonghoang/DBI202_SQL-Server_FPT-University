USE PE_DBI202_Su2020

SELECT * FROM customers
SELECT * FROM employees
SELECT * FROM offices
SELECT * FROM orderdetails
SELECT * FROM orders
SELECT * FROM payments
SELECT * FROM productCategories
SELECT * FROM products

--==============================================================================
--Question 2
--	Select all customers who are 'CA' state of USA 
SELECT * FROM customers WHERE state = 'CA'

--==============================================================================
--Question 3
--	Write a query to select orderNumber, productCode, quantityOrdered, priceEach
--	of all order details in which the product 'S18_1749' was ordered with the quantity 
--	greater than 25; display the results by ascending order of price for each product, 
--	then by descending order of quantityOrdered 
SELECT * FROM orderdetails

SELECT orderNumber, productCode, quantityOrdered, priceEach
		FROM orderdetails 
		WHERE productCode = 'S18_1749' AND quantityOrdered > 25 
		ORDER BY priceEach, quantityOrdered DESC 

--==============================================================================
--Question 4
--	Write a query to display orderNumber, orderDate, requiredDate, shippedDate, 
--	status, customerNumber, customerName, city, country 
--	corresponding to all orders which have not been or have never been shipped of 
--	customer from USA where customerName, city, country are information corresponding 
--	to the customer of the order; display the results by ascending order of customerName 

SELECT * FROM orders
SELECT * FROM customers

SELECT o.orderNumber, o.orderDate, o.requiredDate, o.shippedDate, 
	   o.[status], o.customerNumber, c.customerName, c.city, c.country 
		FROM orders o JOIN customers c ON o.customerNumber = c.customerNumber
		WHERE shippedDate IS NULL AND c.country = 'USA'
		ORDER BY c.customerName 

--==============================================================================
--Question 5 
--	Write a query to display customerNumber, customerName, city, country, totalAmountOfPayments
--	corresponding to each customer from Germany, 
--	where totalAmountOfPayments is the total amount of all payments of each customer; 
--	display the results by ascending order of totalAmountOfPayments.
--	Note that totalAmountOfPayments is NULL for customers who have no payment 

SELECT * FROM payments
SELECT * FROM customers
SELECT * FROM payments p right JOIN customers c ON p.customerNumber = c.customerNumber

SELECT c.customerNumber, SUM(p.amount) FROM payments p RIGHT JOIN customers c ON p.customerNumber = c.customerNumber
				WHERE c.country = 'Germany'
				GROUP BY c.customerNumber

SELECT c.customerNumber, c.customerName, c.city, c.country, SUM(p.amount) AS totalAmountOfPayments
		FROM payments p RIGHT JOIN customers c ON p.customerNumber = c.customerNumber
				WHERE c.country = 'Germany'
				GROUP BY c.customerNumber, c.customerName, c.city, c.country
				ORDER BY totalAmountOfPayments --OK 

--==============================================================================
--Question 6 
--	Write a query to display the information of all employees who are not sales 
--	representative of any customer. Note that in the table customers, salesRepEmployeeNumber 
--	is the employeeNumber of the sales representative for each customer 

SELECT * FROM customers
SELECT * FROM employees

SELECT e.employeeNumber, e.lastName, e.firstName, e.email, e.officeCode, e.reportsTo, e.jobTitle
	FROM customers c RIGHT JOIN  employees e ON c.salesRepEmployeeNumber = e.employeeNumber
		WHERE c.salesRepEmployeeNumber IS NULL --OK 1  

		--cách 2 
SELECT e.employeeNumber FROM customers c JOIN  employees e ON c.salesRepEmployeeNumber = e.employeeNumber --lấy ra những cái chung 

SELECT e.employeeNumber, e.lastName, e.firstName, e.email, e.officeCode, e.reportsTo, e.jobTitle
		FROM employees e
		WHERE e.employeeNumber NOT IN (SELECT e.employeeNumber FROM customers c JOIN  employees e ON c.salesRepEmployeeNumber = e.employeeNumber)
			--OK2 

--==============================================================================
--Question 7  
--	Write a query to display productCode, productName, productCategory, numberOfOrders, 
--	numberOfCustomers, totalQuantityOrdered, totalProfit
--	corresponding to each 'Planes' product where:
--		1. numberOfOrders is the number of orders in which the product was ordered 
--		2. numberOfCustomers is the number of different customers who have already ordered the product 
--		3. totalQuantityOrdered is the total quantity of the corresponding product ordered in all orders 
--		4. totalProfit is the total profit from all orders of the corresponding product.
--		Note that the profit for one item of the product is calculated by the difference between 
--		priceEach (in orderdetails table) and buyPrice (in products table).
--	Display the results in descending order of totalProfit 
SELECT * FROM products 
SELECT * FROM orderdetails 
SELECT * FROM orders 

SELECT COUNT(*) FROM orders o GROUP BY o.customerNumber HAVING COUNT(*)>3

--//CỘT numberOfOrders
SELECT p.productCode, COUNT(d.orderNumber) 
		FROM orderdetails d RIGHT JOIN products p ON d.productCode = p.productCode
		GROUP BY p.productCode

--//CỘT numberOfCustomers
SELECT COUNT(*) FROM orderdetails d JOIN orders o ON d.orderNumber = o.orderNumber GROUP BY o.customerNumber

--//CỘT totalQuantityOrdered
SELECT SUM(quantityOrdered) FROM orderdetails GROUP BY productCode

--//CỘT totalProfit
SELECT * FROM orderdetails WHERE productCode = 'S72_1253'
SELECT SUM(quantityOrdered* priceEach) FROM orderdetails WHERE productCode = 'S72_1253' 
--Tính total cho 'S72_1253' = 33487.15 - 32.77 * 748 
--							tổng (số lượng từng loại * giá từng loại) - giá bán*số lượng đã bán 

SELECT d.productCode, SUM(d.quantityOrdered * d.priceEach) FROM orderdetails d GROUP BY d.productCode --giá gốc 
SELECT  d.productCode, SUM(d.quantityOrdered) * p.buyPrice FROM orderdetails d JOIN products p ON d.productCode = p.productCode
		GROUP BY d.productCode, p.buyPrice --giá bán 
	
	--profit 
SELECT d.productCode, SUM(d.quantityOrdered * d.priceEach) - SUM(d.quantityOrdered) * p.buyPrice 
FROM orderdetails d JOIN products p ON d.productCode = p.productCode
		GROUP BY d.productCode, p.buyPrice 
go
SELECT p.productCode, p.productName, p.productCategory,
	   COUNT(d.orderNumber) AS numberOfOrders,
	   COUNT(*) AS numberOfCustomers,
	   SUM(d.quantityOrdered) AS totalQuantityOrdered,
	   (SUM(d.quantityOrdered * d.priceEach) - SUM(d.quantityOrdered) * p.buyPrice) AS totalProfit 
			FROM orderdetails d JOIN products p ON d.productCode = p.productCode
								JOIN orders o ON d.orderNumber = o.orderNumber
			WHERE p.productCategory = 'Planes'
			GROUP BY p.productCode,p.productName,p.productCategory, p.buyPrice
			ORDER BY totalProfit DESC	
go --OK 


--===================================================================================
--Question 8 
--	Create a stored procedure name proc_numberOfOrders to calculate the number of orders 
--	made by a given customer where @customerNumber int is an input parameter
--	and @numberOfOrders int is an output parameter of the procedure.
SELECT * FROM orders

go
CREATE PROC proc_numberOfOrders
@customerNumber int, @numberOfOrders int output 
AS
BEGIN
	SELECT @numberOfOrders = COUNT(orderNumber) FROM orders WHERE customerNumber = @customerNumber 
END

	--test 
		declare @x int
		exec proc_numberOfOrders 103, @x output 
		SELECT @x as NumberOfProduct

DROP PROC proc_numberOfOrders
go

--===================================================================================
--Question 9 
--	Create a trigger name tr_insertPayment for the insert statement  payments so that 
--	when we insert one or more payments in the table payments, the system will display 
--	customerNumber, customerName, checkNumber, paymentDate, amount corresponding to the 
--	payments that have been inserted 
SELECT * FROM payments
SELECT * FROM customers
go
CREATE TRIGGER tr_insertPayment ON payments 
FOR INSERT
AS
BEGIN
	SELECT i.customerNumber, c.customerName, i.checkNumber, i.paymentDate, i.amount
	FROM inserted i , customers c 
	WHERE i.customerNumber = c.customerNumber
	--ROLLBACK 
END
DROP TRIGGER tr_insertPayment
		--test
		insert into payments(customerNumber, checkNumber, paymentDate, amount)
					values (103, 'HQ336364', '2004-10-29', 1000),
							(112, 'QM789234', '2005-10-30', 200)
go 

--===================================================================================
--Question 10 
--	Write a query to delete from table products all products that 
--	have never been sold in any order 

SELECT * FROM orderdetails
SELECT * FROM products

DELETE FROM products WHERE productCode NOT IN (SELECT productCode FROM orderdetails)


--===================================================================================
USE GIAI_DE_PE
--Question 1
CREATE TABLE Genres
(
	Genre varchar(50) PRIMARY KEY,
	[Description] nvarchar(200)
)
CREATE TABLE Movies
(
	MovieNumber int IDENTITY PRIMARY KEY,
	Title nvarchar(200),
	[Year] int,
	Genre varchar(50),
	FOREIGN KEY (Genre) REFERENCES Genres(Genre)
)

CREATE TABLE Persons 
(
	PersonID int IDENTITY(1,1) PRIMARY KEY, 
	FullName nvarchar(200),
	Gender nvarchar(10)
)

CREATE TABLE Rate
(
	[Time] DateTime,
	Comment text,
	NumericRating float,
	PRIMARY KEY (MovieNumber,PersonID),
	MovieNumber int REFERENCES Movies(MovieNumber),
	PersonID int REFERENCES Persons(PersonID)
)
