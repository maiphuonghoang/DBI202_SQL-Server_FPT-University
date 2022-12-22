

USE GIAI_DE_PE --database tự tạo 
--Question 1 

CREATE TABLE Departments
(
	DeptID varchar(20) PRIMARY KEY,
	name nvarchar(200),
	office nvarchar(100)
)

CREATE TABLE Employees 
(
	EmpCode varchar(20) PRIMARY KEY,
	[Name] nvarchar(50),
	BirthDate date,
	DeptID varchar(20) REFERENCES Departments(DeptID)
)

CREATE TABLE Dependants
(
	Number int IDENTITY PRIMARY KEY,
	[Name] nvarchar(50),
	BirthDate Date,
	Rote nvarchar(30),
	EmpCode varchar(20) FOREIGN KEY REFERENCES Employees(EmpCode)
)

--==============================================================================

USE PE_DBI202_FCasang2021 --giống USE PE_DBI202_F2021

SELECT * FROM Location
SELECT * FROM Product
SELECT * FROM ProductCostHistory
SELECT * FROM ProductInventory
SELECT * FROM ProductModel
SELECT * FROM ProductPriceHistory
SELECT * FROM ProductSubcategory

--Question 2
--	Select all product subcategories of the category 'Accessories'
SELECT * FROM ProductSubcategory WHERE Category = 'Accessories'

--==============================================================================
--Question 3
--	Write a query to select ProductID, LocationID, Quantity of all product inventory 
--	corresponding to the location 7 and the quantity greater than 250,
--	display the results in descending order of Quantity 
SELECT * FROM ProductInventory

SELECT ProductID, LocationID, Quantity FROM ProductInventory 
		WHERE LocationID = 7 AND Quantity > 250
		ORDER BY Quantity DESC 

--==============================================================================
--Question 4
--	Write a query to display ProductID, ProductName, Price, ModelName, SubCategoryName, Category
--	corresponding to all products having the price smaller than 100 
--	and having the 'Black' color 
SELECT * FROM Product
SELECT * FROM ProductModel
SELECT * FROM ProductSubcategory

SELECT p.ProductID, p.Name AS ProductName, p.Price, pm.Name AS ModelName, ps.Name AS SubCategoryName, ps.Category
		FROM Product p LEFT JOIN ProductModel pm ON p.ModelID = pm.ModelID
		FULL JOIN  ProductSubcategory ps ON ps.SubcategoryID = p.SubcategoryID
		WHERE p.Price < 100 AND p.Color = 'Black'

--==============================================================================
--Question 5 số 1 
--	Write a query to display SubcategoryID, SubCategoryName, Category, NumberOfProducts
--	corresponding to each subcategory where NumberOfProduct is the count of distinct product 
--	of the corresponding subcategory, display the results in ascending order of Category, 
--	then in ascending of order of NumberOfProducts for rows having of the same Category 
--	and NumberOfProducts 
SELECT * FROM Product
SELECT * FROM ProductSubcategory

SELECT p.SubcategoryID, COUNT(p.ProductID) FROM Product p 
	JOIN  ProductSubcategory ps ON ps.SubcategoryID = p.SubcategoryID
	GROUP BY p.SubcategoryID

SELECT p.SubcategoryID, ps.Name AS SubCategoryName, ps.Category, COUNT(p.ProductID) AS NumberOfProducts
	FROM Product p JOIN  ProductSubcategory ps ON ps.SubcategoryID = p.SubcategoryID 
	GROUP BY p.SubcategoryID, ps.Name, ps.Category
	ORDER BY ps.Category,  NumberOfProducts DESC, ps.Name

------------------------------------------------------------
--Question 5 số 2  
--	Write a query to display ModelID, ModelName, NumberOfProducts
--	corresponding to each product model having the name beginning with 'Mountain' or 'ML Mountain', 
--	where NumberOfProducts is the count of distinct products belonging to each model.
--	Display the results in descending of order of NumberOfProductsthen in ascending order
--	of ModelName for model having the same NumberOfProducts

SELECT * FROM Product
SELECT * FROM ProductModel

SELECT pm.ModelID, pm.Name AS ModelName, COUNT(p.ProductID) AS NumberOfProducts
	FROM Product p RIGHT JOIN ProductModel pm ON p.ModelID = pm.ModelID
	WHERE pm.Name LIKE 'Mountain%' OR pm.Name LIKE 'ML Mountain%'
	GROUP BY pm.ModelID, pm.Name
	ORDER BY NumberOfProducts DESC, pm.Name 

--==============================================================================
--Question 6 
--	Write a query to display LocationID, LocationName, NumberOfProducts 
--	corresponding to the Location having the minimum NumberOfProducts where 
--	NumberOfProducts  is the count of distinct products in each location.
--		For example, there are three products 748, 942 and 944 locate in the location 45
--		so the NumberOfProducts = 3 for the location 45  

SELECT * FROM Location --14
SELECT * FROM ProductInventory
SELECT DISTINCT LocationID FROM ProductInventory--14 Câu này dùng join loại nào cx đc 

SELECT l.LocationID, COUNT(pi.ProductID) 
FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
GROUP BY l.LocationID

SELECT TOP 1 COUNT(pi.ProductID) AS NoPro
FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
GROUP BY l.LocationID
ORDER BY NoPro --tìm min C1 

SELECT MIN(NoPro) FROM 
						(SELECT COUNT(pi.ProductID) AS NoPro
							FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
							GROUP BY l.LocationID) 
					AS table1 --tìm min C2 

go
SELECT l.LocationID, l.Name AS LocationName, COUNT(pi.ProductID) AS NumberOfProducts
FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
GROUP BY l.LocationID, l.Name
HAVING COUNT(pi.ProductID) = --minC1 hoặc minC2 
							(SELECT MIN(NoPro) FROM 
												(SELECT COUNT(pi.ProductID) AS NoPro
												FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
												GROUP BY l.LocationID) 
												AS table1
							)
go --OK1 

go
SELECT TOP 1 table2.LocationID, table2.LocationName, table2.NumberOfProducts
FROM 
	(SELECT l.LocationID, l.Name AS LocationName, COUNT(pi.ProductID) AS NumberOfProducts
			FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
			GROUP BY l.LocationID, l.Name
	) AS table2 
	ORDER BY NumberOfProducts 
go --OK2 

--====================================================================================================
--Question 7 số 1 
--	Write a query to display, for each category, the subcategory having the maximum number of products.
--	Display the result in the forrm of Category, SubCategoryName, NumberOfProducts 
--	where NumberOfProducts  is the count of distinct products belonging to each product subcategory.
SELECT * FROM ProductSubcategory
SELECT * FROM Product

SELECT ps.Category, ps.Name, COUNT(p.ProductID) 
FROM ProductSubcategory ps JOIN Product p ON ps.SubcategoryID = p.SubcategoryID
GROUP BY ps.SubcategoryID, ps.Category, ps.Name 

go
SELECT ps.Category, ps.Name AS SubCategoryName, COUNT(p.ProductID) AS NumberOfProducts
FROM ProductSubcategory ps JOIN Product p ON ps.SubcategoryID = p.SubcategoryID
GROUP BY ps.SubcategoryID, ps.Category, ps.Name 
HAVING COUNT(p.ProductID) IN 
(SELECT table2.MaxList 
		FROM 
			(SELECT table1.Category, MAX(NoPro) AS MaxList 
				FROM 
					(SELECT ps.Category, ps.Name, COUNT(p.ProductID) AS NoPro
						FROM ProductSubcategory ps JOIN Product p ON ps.SubcategoryID = p.SubcategoryID
						GROUP BY ps.SubcategoryID, ps.Category, ps.Name 
				) as table1 
				GROUP BY table1.Category
		) AS table2 
)
go --OK 

------------------------------------------
--Question 7 số 2 
--	Write a query to display, for each location, the information of the products having the highest Quantity.
--	Display the information with the following attributes: LocationID, LocationName, ProductID, ProductName, Quantity
--	where ProductID, ProductName, Quantity is the information of the products having the highest quantity in
--	the given location. Display the result in ascending order of LocationName, then in descending order of 
--	ProductName with the products pff the same location 

SELECT * FROM Location
SELECT * FROM ProductInventory
SELECT * FROM Product

SELECT pi.LocationID, MAX(pi.Quantity) AS MaxList 
FROM ProductInventory pi 
GROUP BY pi.LocationID 

go
SELECT l.LocationID, l.Name AS LocationName, pi.ProductID, p.Name AS ProductName, pi.Quantity 
FROM ProductInventory pi JOIN  Product p ON pi.ProductID = p.ProductID
						 JOIN Location l ON l.LocationID = pi.LocationID
WHERE pi.Quantity IN 
				(
					SELECT table1.MaxList
					FROM (
							SELECT pi.LocationID, MAX(pi.Quantity) AS MaxList 
							FROM ProductInventory pi 
							GROUP BY pi.LocationID 
					)AS table1 
				)
		AND pi.LocationID IN (--nếu k có đk này sẽ là 46 rows, 
							 -- vì max của locatin này có thể ko là max của location khác nhưng nó vẫn xh trong list 
							 --<câu 7 số 1 chắc chắn thì thêm đk 2 vào - ko cần lắm>
						SELECT table1.LocationID
							FROM (
							SELECT pi.LocationID, MAX(pi.Quantity) AS MaxList 
							FROM ProductInventory pi 
							GROUP BY pi.LocationID 
						)AS table1 
						WHERE table1.MaxList= pi.Quantity --phải thêm đk này nữa mới đủ 
							)
ORDER BY l.Name, p.Name DESC 

go --17 rows OK 


--===================================================================================
--Question 8 
--	Create a stored procedure name proc_product_model to calculate the count of distinct products
--	belonging to a given model where @modelID int is an input parameter and @numberOfProduct int
--	is an output parameter of the procedure.
SELECT * FROM Product
SELECT ModelID, COUNT(ProductID) FROM Product GROUP BY ModelID

go
CREATE PROC proc_product_model
@modelID int, @numberOfProduct int output 
AS
BEGIN
	SELECT @numberOfProduct = COUNT(ProductID) FROM Product 
	WHERE ModelID = @modelID

END 
	--test 
		declare @x int
		exec proc_product_model 9, @x output 
		SELECT @x as NumberOfProduct

DROP PROC proc_product_model
go 

--===================================================================================
--Question 9 số 1 
--	Create a trigger name tr_insert_Product_Subcategory for the insert statement 
--	on table Product so that when we insert one or more rows into the table Products, 
--	the system will display the ProductID, ProductName, SubcategoryID, SubcategoryName, Category
--	corresponding to the rows that have been inserted 
SELECT * FROM Product
SELECT * FROM ProductSubcategory

go
CREATE TRIGGER tr_insert_Product_Subcategory ON Product
FOR INSERT 
AS
BEGIN 
	SELECT i.ProductID, i.Name AS ProductName, i.SubcategoryID, ps.Name AS SubcategoryName, ps.Category
	FROM inserted i, ProductSubcategory ps
	WHERE i.SubcategoryID = ps.SubcategoryID
	--ROLLBACK TRANSACTION 
END
	
		--test 
		insert into Product(ProductID, Name, Cost, Price, SubcategoryID, SellStartDate)
		values(1005,'Product Test', 12 ,15, 1,'2021-10-25')

DROP TRIGGER tr_insert_Product_Subcategory
go


----------------------------------------
--Question 9 số 2 
--	Create a trigger name tr_insert_Productfor the insert statement 
--	on table Product so that when we insert one or more rows into the table Products, 
--	the system will display the ProductID, ProductName, ModelID, ModelName 
--	corresponding to the rows that have been inserted 

SELECT * FROM Product
SELECT * FROM ProductModel

go
CREATE TRIGGER tr_insert_Product ON Product
FOR INSERT 
AS
BEGIN 
	SELECT i.ProductID, i.Name AS ProductName, pm.ModelID, pm.Name AS ModelName 
	FROM inserted i, ProductModel pm
	WHERE i.ModelID = pm.ModelID
	ROLLBACK TRANSACTION 
END
	
		--test 
		insert into Product(ProductID, Name, Cost, Price, ModelID, SellStartDate)
		values(1000,'Product Test', 12.5 ,15.5, 1,'2021-10-25')

DROP TRIGGER tr_insert_Product
go

--===================================================================================
--Question 10 
--	Write a query to delete from the ProductInventory table all rows corresponding to   
--	products belonging to the model having ModelID = 33 
SELECT * FROM ProductInventory
SELECT * FROM Product

DELETE FROM ProductInventory 
WHERE ProductID IN (SELECT ProductID FROM Product WHERE ModelID = 33)