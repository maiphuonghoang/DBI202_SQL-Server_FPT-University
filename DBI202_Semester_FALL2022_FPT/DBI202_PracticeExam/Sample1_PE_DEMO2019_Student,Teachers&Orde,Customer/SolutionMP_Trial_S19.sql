/*
https://www.youtube.com/watch?v=3yweJZy-HBs --alias 

https://www.youtube.com/watch?v=uC5AFxlhtIs&t=2660s 

*/
--NOTE: KO DÙNG USE HAY GO LÚC NỘP BÀI 

CREATE DATABASE GIAI_DE_PE
USE GIAI_DE_PE

--Question 1 
CREATE TABLE Teachers
(
	TeacherID int PRIMARY KEY,
	[Name] nvarchar(50),
	Gender char(1),
	[Address] nvarchar(200)
)
CREATE TABLE Classes 
(
	ClassID int PRIMARY KEY,
	NoCredits int,
	CourseID char(6),
	GroupID char(6), 
	Semester char(10),
	[Year] int, 
	TeacherID int REFERENCES Teachers(TeacherID)
)
CREATE TABLE Students 
(
	StudentID int PRIMARY KEY, 
	[Name] nvarchar(50),
	Gender char(1),
	[Address] nvarchar(200),
)
CREATE TABLE Attend
(
	[Date] date, 
	Slot int, 
	Attend bit, 
	StudentID int REFERENCES Students(StudentID),
	ClassID int REFERENCES Classes(ClassID),
	PRIMARY KEY (StudentID, ClassID, [Date], Slot)
)

--THÊM YÊU CẦU 
--Slot <= 8
--Gender M or F
ALTER TABLE Students ADD CONSTRAINT CheckGender CHECK (Gender = 'M' OR Gender = 'F')
ALTER TABLE Attend ADD CONSTRAINT CheckSlot CHECK (Slot >= 8)

--================================================================
USE PE_Demo_S2019

SELECT * FROM Category 
SELECT * FROM Customer
SELECT * FROM OrderDetails
SELECT * FROM Orders
SELECT * FROM Product 
SELECT * FROM SubCategory 

--Question 2
-- Write a query to display all customers who are 'Consumer' and are from Arlington city 
SELECT * FROM Customer WHERE Segment = N'Consumer' AND City = N'Arlington'--15 

--===============================================================================================
--Question 3
-- Write a query to display all customers having CustomerName starting with B and placed orders 
-- in December 2017. Display the result by descending order of Segment and then by 
-- ascending order of CustomerName 
SELECT * FROM Customer
SELECT * FROM Orders
SELECT c.* FROM Customer c JOIN Orders o ON c.ID = O.CustomerID
WHERE c.CustomerName LIKE 'B%' AND MONTH(o.OrderDate) = 12 AND YEAR (o.OrderDate) = 2017
ORDER BY c.Segment DESC, c.CustomerName ASC  --16 

--================================================================================================
--Question 4
-- Write a query to display SubCategoryID, SubCategoryName and the corresponding of products (NumberOfProducts)
-- in each sub-category having the number of products greater than 100, 
-- by DESC order of NumberOfProducts
SELECT * FROM SubCategory
SELECT * FROM Product 
	--B1: đếm theo từng loại Sub có bn Product 




SELECT  COUNT(*) AS NumberOfProducts FROM Product  p  GROUP BY p.SubCategoryID
SELECT p.SubCategoryID,  COUNT(*) AS NumberOfProducts FROM Product  p  GROUP BY p.SubCategoryID
SELECT p.SubCategoryID, p.ProductName,  COUNT(*) AS NumberOfProducts FROM Product  p  GROUP BY p.SubCategoryID

										

SELECT p.SubCategoryID, COUNT(p.ID) AS NumberOfProducts FROM SubCategory  s JOIN Product p
										ON s.ID = p.SubCategoryID GROUP BY p.SubCategoryID
										HAVING COUNT(p.ID) > 100
	--cho thêm cái name ở bảng sub vào 
SELECT p.SubCategoryID, s.SubCategoryName, COUNT(p.ID) AS NumberOfProducts FROM SubCategory  s JOIN Product p
										ON s.ID = p.SubCategoryID  GROUP BY p.SubCategoryID, s.SubCategoryName
										HAVING COUNT(p.ID) > 100
										ORDER BY COUNT(p.ID) DESC  --OK1 
SELECT * FROM (
				SELECT p.SubCategoryID, s.SubCategoryName, COUNT(p.ID) AS NumberOfProducts FROM SubCategory  s JOIN Product p
				ON s.ID = p.SubCategoryID  GROUP BY p.SubCategoryID, s.SubCategoryName 
			  ) AS Temporary 
								WHERE NumberOfProducts > 100
								ORDER BY NumberOfProducts DESC --OK2
	
	--viết sau khi học lệnh VIEW, đi thi k dùng view vì yêu cầu là Write a query
GO
CREATE VIEW Table_Group
AS
	SELECT p.SubCategoryID, s.SubCategoryName, COUNT(p.ID) AS NumberOfProducts
			FROM SubCategory  s JOIN Product p ON s.ID = p.SubCategoryID  
										GROUP BY p.SubCategoryID, s.SubCategoryName
										HAVING COUNT(p.ID) > 100

SELECT * FROM Table_Group ORDER BY NumberOfProducts DESC	-- câu ORDER BY KHÔNG CHO VÀO TRONG VIEW ĐƯỢC nên cho ra ngoài này 
GO  

--================================================================
--Question 5
-- Write a query to display ProductID, ProductName, Quantity of 
-- all products which have the highest Quantity in one order 
SELECT * FROM Product 
SELECT * FROM OrderDetails

SELECT MAX(Quantity) FROM OrderDetails -- tìm đc max = 14
SELECT TOP 1 * FROM OrderDetails ORDER BY Quantity DESC 
SELECT TOP 1 Quantity FROM OrderDetails ORDER BY Quantity DESC --14

SELECT * FROM OrderDetails ORDER BY Quantity DESC 


SELECT o.ProductID, p.ProductName, o.Quantity 
	  FROM Product p JOIN OrderDetails o ON p.ID = o.ProductID
	  WHERE o.Quantity = 
	  (SELECT TOP 1 Quantity FROM OrderDetails ORDER BY Quantity DESC)
						(SELECT MAX(Quantity) FROM OrderDetails) --OK1

SELECT o.ProductID, p.ProductName, o.Quantity 
	  FROM Product p JOIN OrderDetails o ON p.ID = o.ProductID
	  WHERE o.Quantity >= ALL(SELECT DISTINCT  Quantity FROM OrderDetails) --OK2 

--==================================================================================
--Question 6 
-- Write a query to display CustomerID, CustomerName and the number of orders (NumberOfOrders) 
-- of customers who have the highest number of orders 

SELECT * FROM Customer
SELECT * FROM Orders -- 5003
SELECT DISTINCT CustomerID FROM Orders --4905 

SELECT COUNT(o.ID) FROM Orders o GROUP BY o.CustomerID
SELECT MAX(maxi) FROM (SELECT COUNT(o.ID) as maxi  FROM Orders o GROUP BY o.CustomerID) AS Table1 


SELECT MAX(NoOder) FROM (
					SELECT COUNT(o.ID) AS NoOder FROM Orders o GROUP BY o.CustomerID					
					) AS FindMax --tìm được số lượng đơn hàng nhiều nhất là 3 

SELECT o.CustomerID, c.CustomerName, COUNT(o.ID) AS NumberOfOrders 
		FROM Customer c JOIN Orders o ON c.ID = o.CustomerID
		GROUP BY o.CustomerID, c.CustomerName
		HAVING COUNT(o.ID) = --max vừa tìm đc  
							(SELECT MAX(NoOder) FROM (
														SELECT COUNT(ID) AS NoOder FROM Orders GROUP BY CustomerID					
													) AS FindMax 
							) --OK 1 

--====================================================================
--Question 7
--	Write a query to display 5 products with the highest unit prices 
--	and 5 products with the smallest unit prices 
SELECT * FROM Product 
SELECT TOP 5 * FROM Product ORDER BY UnitPrice DESC 
UNION	--không dùng được UNION giữa 2 câu sql này  
SELECT TOP 5 * FROM Product ORDER BY UnitPrice 

	--cách fix 
SELECT * FROM (
				SELECT TOP 5 * FROM Product ORDER BY UnitPrice DESC 
				UNION 
				SELECT TOP 5 * FROM Product ORDER BY UnitPrice 
				) AS Uni 
		ORDER BY Uni.UnitPrice DESC --OK1 

SELECT * FROM (	SELECT TOP 5 * FROM Product ORDER BY UnitPrice DESC ) as table1 
UNION 
SELECT * FROM (	SELECT TOP 5 * FROM Product ORDER BY UnitPrice ) as table2
		ORDER BY table1.UnitPrice DESC --OK2 

select * from (
    select 
        t.*,
        rank() over(order by UnitPrice desc) r_low,
        rank() over(order by UnitPrice asc) r_high
    from product t
) t
where r_high <= 5 or r_low <= 5
order by r_high desc, r_low desc	--OK3 

--=================================================================================
--Question 8 
--	Write a stored procedure named CountProduct to calculate the number of 
--	different products in an order with OrderID (nvarchar(255)) is input parameter 
--	and the NbProducts (int) is the output parameter of the procedure.

SELECT * FROM OrderDetails 
SELECT OrderID, COUNT(*) FROM OrderDetails GROUP BY OrderID
SELECT * FROM OrderDetails WHERE OrderID = 'CA-2014-100391'
SELECT * FROM OrderDetails WHERE OrderID = 'CA-2014-100363'

go
CREATE PROC CountProductV1 @OrderID nvarchar(255), @NbProducts int output
AS
	SELECT @NbProducts = COUNT(o.OrderID) FROM OrderDetails o WHERE o.OrderID =  @OrderID --OK 1 
 
			--test 
			declare @t int
			exec CountProductV1 'CA-2014-100391', @t output 
			print @t

DROP PROC CountProductV1
go

go
CREATE PROC CountProductV2 @OrderID nvarchar(255), @NbProducts int output
AS
	SET @NbProducts = (SELECT COUNT(o.OrderID) FROM OrderDetails o WHERE o.OrderID =  @OrderID) --OK 2  
 
			--test 
			declare @t int
			exec CountProductV2 'CA-2014-100363', @t output 
			print @t
go

--=================================================================================
--Question 9
--	Create a trigger InsertProduct which will be activated by an insert statement into the Product table. 
--	The trigger will display the ProductName and the SubCategoryName of the products which have just been inserted 
--	by the insert statement.

SELECT * FROM Product 
SELECT * FROM SubCategory

go
CREATE TRIGGER InsertProduct ON Product 
FOR INSERT									--muốn ktra thì dùng instead of 
AS
BEGIN
	SELECT i.ProductName, s.SubCategoryName
	FROM inserted i , SubCategory s 
	WHERE i.SubCategoryID = s.ID
END

go

	--test 
insert into Product(ProductName, UnitPrice, SubCategoryID)
values ('Craft paper', 0.5, 3)

DROP TRIGGER InsertProduct

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
