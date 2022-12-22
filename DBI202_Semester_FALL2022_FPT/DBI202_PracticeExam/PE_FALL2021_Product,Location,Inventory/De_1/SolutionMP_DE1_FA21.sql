/*
https://www.youtube.com/watch?v=iCXWa-798lM&t=1656s
*/

USE PE_DBI202_F2021

SELECT * FROM Location
SELECT * FROM Product
SELECT * FROM ProductCostHistory
SELECT * FROM ProductInventory
SELECT * FROM ProductModel
SELECT * FROM ProductPriceHistory
SELECT * FROM ProductSubcategory

--==============================================================================
--Question 2
--	Select all locations having the CostRate greater than 0 
SELECT * FROM Location
SELECT * FROM Location l WHERE l.CostRate > 0

--==============================================================================
--Question 3
--	Select ProductID, Price, StartDate, EndDate of all product price histories
--	having the EndDate in 2003 and having the price smaller than 100;
--  display the results in desc order of price 

SELECT * FROM ProductPriceHistory
SELECT pph.ProductID, pph.Price, pph.StartDate, pph.EndDate FROM ProductPriceHistory pph 
		WHERE YEAR(pph.EndDate) = 2003 
			  AND pph.Price < 100
		ORDER BY pph.Price DESC

--===================================================================================
--Question 4
--	Display the history cost of all products having the 'Black' color and having 
--	the name beginning with 'HL'. Display the results with the following attributes: 
--	ProductID, ProductName, Color, SubCategoryName, Category, StartDate, EndDate, 
--	HistoryCost where StartDate, EndDate and HistoryCost contain information about 
--	the historycost of the product 
SELECT * FROM Product
SELECT * FROM ProductCostHistory
SELECT * FROM ProductSubcategory

SELECT p.ProductID, p.Name AS ProductName, p.Color, p.SubcategoryID, 
	   ps.Category, pch.StartDate, pch.EndDate, pch.Cost AS HistoryCost
			FROM Product p 
						   LEFT JOIN ProductSubcategory ps ON p.SubcategoryID = ps.SubcategoryID
						   FULL JOIN ProductCostHistory pch ON p.ProductID = pch.ProductID
						   WHERE p.Color = N'Black' AND p.Name LIKE 'HL%' --26, có những sp chưa có chủng loại
--===================================================================================
--Question 5
--	Display LocationID, LocationName, NumberOfProducts corresponding to each location 
--	where NumberOfProducts is the count of distinct products in each location.
--	For example, there are three products 748, 942 and 944 located in the location 45 
--	so the NumberOfProducts = 3 for the location 45.
--	Display the result in descending order of NumberOfProducts then in ascending order 
--	of LocationName for locations having the same NumberOfProducts as follow 
SELECT * FROM ProductInventory
SELECT * FROM Location

SELECT pi.LocationID, l.Name AS LocationName, COUNT(pi.ProductID) AS NumberOfProducts 
		FROM Location l JOIN ProductInventory pi ON l.LocationID = pi.LocationID
		GROUP BY pi.LocationID, l.Name
		ORDER BY NumberOfProducts DESC, l.Name 

--===================================================================================
--Question 6
--	chưa có câu hỏi ^_^
--===================================================================================
--Question 7
--	Write a query to display, for each product model having the name beginning with 
--	'HL Mountain', the information of the products which are stored in most locations.
--	Display the informations with the following attributes:  
--	ModelID, ModelName, ProductID, ProductName, NumberOfLocations; 
--	where NumberOfLocations is the number of distinct locations where we found the 
--	corresponding product of the given model. 
--	For example, among difference products of the model 'HL Mountain Frame', 
--	two products which are stored in the most number of locations are product 747 & 748 

SELECT * FROM ProductModel
SELECT * FROM Product
SELECT * FROM ProductInventory

SELECT	pm.ModelID, pm.Name AS ModelName, p.ProductID, p.Name AS ProductName, COUNT(p.ProductID) AS NumberOfLocations
		FROM ProductInventory pi												--đếm pi cũng đc vì giống nhau = ấy hoy 
					   LEFT JOIN Product p on p.ProductID = pi.ProductID
					   RIGHT JOIN ProductModel pm ON p.ModelID = pm.ModelID --FULL cũng đc, LEFT thì ra 8 (theo model thì sẽ bỏ NULL)
					   WHERE pm.Name LIKE 'HL Mountain%'
					   GROUP BY pm.ModelID, pm.Name, p.ProductID, p.Name --9 OK 

--===================================================================================
--Question 8 
--	Create a stored procedure name proc_product_subcategory for calculating the number of
--	distinct products of a given subcategory, where @subcategoryID int is the input parameter
--	of the procedure and @numberOfProduct int is an output parameter of the procedure.

SELECT * FROM Product
SELECT * FROM ProductSubcategory

SELECT p.SubcategoryID, COUNT(p.ProductID) 
FROM Product p LEFT JOIN ProductSubcategory ps ON p.SubcategoryID = ps.SubcategoryID
GROUP BY p.SubcategoryID

go
CREATE PROC proc_product_subcategory
@subcategoryID int, @numberOfProduct int output 
AS 
BEGIN
	SELECT @numberOfProduct = COUNT(p.ProductID)
	FROM Product p, ProductSubcategory ps 
	WHERE p.SubcategoryID = ps.SubcategoryID
	AND ps.SubcategoryID =  @subcategoryID
END
DROP PROC proc_product_subcategory
	--test 
		declare @x int
		exec proc_product_subcategory 1, @x output 
		SELECT @x as NumberOfProduct

DROP PROC proc_product_subcategoryV1
go

--===================================================================================
--Question 9 
--	Create a trigger name tr_delete_productInventory_location for the delete statement 
--	on table ProductInventory so that when we delete one or more rows from table ProductInventory,
--	the system will display the ProductID, LocationID, LocationName, Shelf, Bin, Quantity
--	corresponding to the rows that have been deleted 
go
CREATE TRIGGER tr_delete_productInventory_location ON ProductInventory
FOR DELETE 
AS
BEGIN
	SELECT d.ProductID, d.LocationID, l.Name AS LocationName, d.Shelf, d.Bin, d.Quantity
	FROM deleted d, Location l  WHERE d.LocationID = l.LocationID
	--ROLLBACK 
END

	--test
		delete from ProductInventory where ProductID = 1 and LocationID = 1 

DROP TRIGGER tr_delete_productInventory_location
go
--===================================================================================
--Question 10 
--	Write a query to update the productInventory table to set the quantity = 2000 
--	for all products belonging to the model having ModelID = 33 
SELECT * FROM ProductInventory
SELECT * FROM Product

UPDATE ProductInventory SET Quantity = 2000 
WHERE ProductID IN (SELECT ProductID FROM Product WHERE ModelID = 33)