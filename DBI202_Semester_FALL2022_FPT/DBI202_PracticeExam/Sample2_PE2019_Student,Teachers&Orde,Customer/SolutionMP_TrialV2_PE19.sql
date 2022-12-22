USE PE_Demo_S2019

SELECT * FROM Category 
SELECT * FROM Customer
SELECT * FROM OrderDetails
SELECT * FROM Orders
SELECT * FROM Product 
SELECT * FROM SubCategory 

--Question 2:
--	Write a query to display all SubCategories in category 3 as follows:
SELECT ID, SubCategoryName, CategoryID FROM SubCategory WHERE CategoryID = 3

--===============================================================================================
--Question 3:
--	Write a query to display the ID, CustomerName, City, State of all customers who placed 
--	orders from 05 December 2017 to 10 December 2017 and their orders are shipped less than 3 days. 
--	Display the result by ascending order of State and then by descending order of City.

	-- VD: giao hàng trong khoảng 3 ngày 
	--Hàm DATEDIFF(d/m/h..., OrderDate, ShipDate ) = num --khoảng chênh lệnh 

SELECT * FROM Customer 
SELECT * FROM Orders

SET DATEFORMAT dmy
SELECT c.ID, c.CustomerName, c.City, c.State 
	FROM Customer c JOIN Orders o ON c.ID = o.CustomerID
	WHERE o.OrderDate BETWEEN '05-12-2017' AND '10-12-2017'
		  AND DATEDIFF(d, o.OrderDate, o.ShipDate) IN(0,1,2)
	ORDER BY c.State, c.City DESC --OK1 

SELECT c.ID, c.CustomerName, c.City, c.State 
	FROM Customer c JOIN Orders o ON c.ID = o.CustomerID
	WHERE o.OrderDate BETWEEN '05-12-2017' AND '10-12-2017'
		  AND ABS(CONVERT(float,o.OrderDate) - CONVERT(float,o.ShipDate)) < 3
	ORDER BY c.State, c.City DESC --OK2 

--===============================================================================================
--Question 4:
--	The Amount of each product in an order is calculated by Quantity*SalePrice*(1-Discount). 
--	The TotalAmount of each order is the sum of the Amount of all product in the order. 
--	Write a query to display OrderID, OrderDate, TotalAmount of all orders having 
--	TotalAmount greater than 8000, by descending order of TotalAmount 

SELECT * FROM OrderDetails
SELECT * FROM Orders

--bước 1 
SELECT od.OrderID, od.ProductID, od.Quantity * od.SalePrice * (1-od.Discount) AS Amount 
FROM OrderDetails od 

--bước 2
SELECT od.OrderID, SUM(od.Quantity * od.SalePrice * (1-od.Discount)) AS Amount 
			FROM OrderDetails od 
GROUP BY od.OrderID

--bước 3  
SELECT t.OrderID, t.TotalAmount 
	FROM 
		(SELECT od.OrderID, SUM(od.Quantity * od.SalePrice * (1-od.Discount)) AS TotalAmount 
			FROM OrderDetails od 
			GROUP BY od.OrderID
		) AS t 
WHERE t.TotalAmount  > 8000 
ORDER BY t.TotalAmount DESC 

--C1
SELECT t.OrderID, o.OrderDate, t.TotalAmount 
	FROM 
		(SELECT od.OrderID, SUM(od.Quantity * od.SalePrice * (1-od.Discount)) AS TotalAmount 
			FROM OrderDetails od 
			GROUP BY od.OrderID
		) AS t 
	JOIN Orders o ON t.OrderID = o.ID
WHERE t.TotalAmount  > 8000 
ORDER BY t.TotalAmount DESC 
--C2 
SELECT t.OrderID, t.OrderDate, SUM(t.Amount) AS TotalAmount 
FROM 
	(SELECT od.OrderID, o.OrderDate, od.Quantity * od.SalePrice * (1-od.Discount) AS Amount 
			FROM OrderDetails od, Orders o WHERE od.OrderID = o.ID
	) AS t
GROUP BY t.OrderID, t.OrderDate
HAVING SUM(t.Amount) > 8000 
ORDER BY SUM(t.Amount) DESC 

--===============================================================================================
--Question 5:
--	Find all orders that were ordered on the same day as the latest order as follows:
SELECT * FROM Orders

SELECT MAX(o.OrderDate) FROM Orders o -- C1 tìm đc latest order
SELECT TOP 1 o.OrderDate FROM Orders o ORDER BY o.OrderDate DESC -- C2 tìm đc latest order

SELECT o.ID, o.OrderDate, o.ShipDate, o.ShipMode, o.CustomerID 
	FROM Orders o
	WHERE o.OrderDate = --latest order vừa tìm đc 
						(
						SELECT MAX(o.OrderDate) FROM Orders o
						)

--===============================================================================================
--Question 6:
--	Find all the products which appeared in the smallest number of orders, order by ProductID. 
--	The results should be displayed in the form of ProductID, ProductName, NumberOfOrders.
--	Note that the following figure show only 22 first rows of the results. 
--	In fact, the query should return 90 rows.
SELECT * FROM OrderDetails
SELECT * FROM Product 

--bước 1
SELECT p.ID, COUNT(od.OrderID) 
	FROM OrderDetails od LEFT JOIN Product p ON od.ProductID = p.ID
	GROUP BY p.ID
--bước 2: tìm smallest number of orders
	SELECT MIN(t.NoOrders) as mini 
		FROM 
			(SELECT COUNT(od.OrderID) AS NoOrders 
			FROM OrderDetails od LEFT JOIN Product p ON od.ProductID = p.ID
			GROUP BY p.ID
		) AS t 
--bước 3:
SELECT od.ProductID, p.ProductName, COUNT(od.OrderID) AS NumberOfOrders
	FROM OrderDetails od LEFT JOIN Product p ON od.ProductID = p.ID
	GROUP BY od.ProductID, p.ProductName
	HAVING COUNT(od.OrderID) = --min vừa tìm đc 
								(
									SELECT MIN(t.NoOrders) as mini 
									FROM 
										(SELECT COUNT(od.OrderID) AS NoOrders 
										FROM OrderDetails od LEFT JOIN Product p ON od.ProductID = p.ID
										GROUP BY p.ID
										) AS t 
								)

--===============================================================================================
--Question 7:
--	Write a query to display 5 sub-categories having the highest numbers of different products 
--	and the 5 sub-categories having the smallest numbers of different products, 
--	by descending order of number of different products 
SELECT * FROM Product

SELECT * FROM(
	SELECT TOP 5 p.SubCategoryID, COUNT(p.ID) AS NumberOfProducts 
	FROM Product p GROUP BY p.SubCategoryID 
	ORDER BY COUNT(p.ID) DESC 
	) AS t1 
UNION 
SELECT * FROM(
	SELECT TOP 5 p.SubCategoryID, COUNT(p.ID) AS NumberOfProducts 
	FROM Product p GROUP BY p.SubCategoryID 
	ORDER BY COUNT(p.ID) 
	) AS t2 
ORDER BY t1.NumberOfProducts DESC 

--===============================================================================================
--Question 8:
--	Write a stored procedure named TotalAmount to calculate the total amount of an order with 
--	OrderID (nvarchar(255)) is its input parameter and the TotalAmount (float) is the output parameter. 
--	Note that the Amount of each product in an order is calculate as SalePrice*Quantity*(1-Discount) 
--	and the TotalAmount of each order is the sum of all the Amounts of all products in the order.

SELECT Quantity * SalePrice * (1-Discount) AS Amount 
		FROM OrderDetails WHERE OrderID = 'CA-2014-100090'
SELECT SUM(Quantity * SalePrice * (1-Discount)) 
		FROM OrderDetails WHERE OrderID = 'CA-2014-100090' --699.192 

GO
CREATE PROC TotalAMount 
@OrderID nvarchar(255), @TotalAmount float output 
AS 
BEGIN 
	SELECT @TotalAmount = SUM(Quantity * SalePrice * (1- Discount)) 
			FROM OrderDetails WHERE OrderID = @OrderID
END 
GO 
		--test 
		declare @t float
		exec TotalAMount 'CA-2014-100006', @t output 
		print @t
		
		declare @t float
		exec TotalAMount 'CA-2014-100090', @t output 
		print @t --699.192 
DROP PROC TotalAMount 
--===============================================================================================
--Question 9:
--	Create a trigger InsertSubCategory which will be activated by an insert statement into the SubCategory table. 
--	The trigger will display the SubCategoryName and the CategoryName of the sub-categories 
--	which have just been inserted by the insert statement.
SELECT * FROM SubCategory 
SELECT * FROM Category

GO
CREATE TRIGGER InsertSubCategory ON SubCategory
FOR INSERT 
AS 
BEGIN 
	SELECT i.SubCategoryName, c.CategoryName
	FROM inserted i, Category c WHERE i.CategoryID = c.ID
	--ROLLBACK 
END 
GO 
	--test 
	insert into SubCategory(SubCategoryName, CategoryID)
	values ('Beds',2)

DROP TRIGGER InsertSubCategory

--=================================================================================
--Question 10 
--	Insert the following information:
--		- A category named 'Sports' into table Category
--		- A subcategory named 'Tennis' and a subcategory named 'Football' into table SubCategory, 
--		  both these two subcategories are subcategories of Category 'Sports'
SELECT * FROM Category 
SELECT * FROM SubCategory 

INSERT INTO Category (CategoryName) VALUES ('Sports')
INSERT INTO SubCategory (SubCategoryName, CategoryID) 
				 VALUES ('Tennis',   (SELECT ID FROM Category WHERE CategoryName = 'Sports')),
					    ('Football', (SELECT ID FROM Category WHERE CategoryName = 'Sports'))


--Trả lại database ban đầu 
DELETE FROM SubCategory WHERE CategoryID = 4 
DELETE FROM Category WHERE CategoryName = 'Sports'