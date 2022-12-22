USE PE_DBI202_Sp2022

SELECT * FROM SupplierCategories
SELECT * FROM Suppliers
SELECT * FROM Products
SELECT * FROM PurchaseOrderLines
SELECT * FROM PurchaseOrders
SELECT * FROM SupplierTransactions

--======================================================================================
--Question 2 
--	Display SupplierID, SupplierName, SupplierCategoryID, DeliveryMethod, DeliveryCity
--	of all suppliers belonging to the supplier category 2 
SELECT * FROM Suppliers

SELECT SupplierID, SupplierName, SupplierCategoryID, DeliveryMethod, DeliveryCity
		FROM Suppliers WHERE SupplierCategoryID = 2 

--======================================================================================
--Question 3 
--	Write a query to select SupplierTransactionID, SupplierID, 
--							TransactionType, TransactionDate, TransactionAmount
--	of all supplier transactions made from 20 may 2013 to 31 may 2013;
--	display the results by ascending order of Transaction Type then by 
--	descending order of TransactionAmount for transactions of the same type 
SELECT * FROM SupplierTransactions

SELECT SupplierTransactionID, SupplierID, TransactionType, TransactionDate, TransactionAmount
		FROM SupplierTransactions
		WHERE TransactionDate BETWEEN CONVERT(varchar, '2013-05-20', 101) AND CONVERT(varchar, '2013-05-31', 101)
		ORDER BY TransactionType, TransactionAmount DESC --OK 

SELECT SupplierTransactionID, SupplierID, TransactionType, TransactionDate, TransactionAmount
		FROM SupplierTransactions
		WHERE TransactionDate BETWEEN '20-05-2013' AND'31-05-2013'--nếu ko convert thì phải SET DATEFORMAT dmy 
		ORDER BY TransactionType, TransactionAmount DESC 
--anwser đúng nhất 
SELECT SupplierTransactionID, SupplierID, TransactionType, TransactionDate, TransactionAmount
		FROM SupplierTransactions
		WHERE TransactionDate BETWEEN CONVERT(date, '20 may 2013') AND CONVERT(date, '31 may 2013')
		ORDER BY TransactionType, TransactionAmount DESC 
--======================================================================================
--Question 4 
--	Write a query to display ProductID, ProductName, SupplierName, 
--							 TaxRate, UnitPrice, TypicalWeightPerUnit 
--	of all products having the TaxRate = 15, the UnitPrice less than 10 and 
--	the TypicalWeightPerUnit less than 0.5; dipslay the results by 
--	ascending order of SupplierName then by ascending order of ProductName 
--	for products of the same supplier 

SELECT * FROM Suppliers
SELECT * FROM Products

SELECT p.ProductID, p.ProductName, s.SupplierName, p.TaxRate, p.UnitPrice, p.TypicalWeightPerUnit 
FROM Suppliers s, Products p 
	WHERE s.SupplierID = p.SupplierID
	AND p.TaxRate = 15 AND p.UnitPrice < 10 AND p.TypicalWeightPerUnit < 0.5
	ORDER BY s.SupplierName, p.ProductName

--======================================================================================
--Question 5 
--	Write a query to display SupplierID, SupplierName, NumberOfPurchaseOrders, TotalOrderedQuantity
--	corresponding to each supplier where NumberOfPurchaseOrders is the number of purchase orders of the supplier,
--	and TotalOrderedQuantity is the total quantity of all products purchased in all orders of the corresponding supplier;
--	display the results by descending order of NumberOfPurchaseOrders then by ascending order of SupplierName 
--	for suppliers having the same NumberOfPurchaseOrders

SELECT * FROM Suppliers	
SELECT * FROM PurchaseOrders
SELECT * FROM PurchaseOrderLines
									
SELECT  s.SupplierID, s.SupplierName, COUNT(DISTINCT po.PurchaseOrderID), SUM(pol.OrderedQuantity)
FROM Suppliers s LEFT JOIN PurchaseOrders po ON s.SupplierID = po.SupplierID 
				 FULL  JOIN PurchaseOrderLines pol ON pol.PurchaseOrderID = po.PurchaseOrderID
	GROUP BY s.SupplierID, s.SupplierName
	ORDER BY COUNT(pol.PurchaseOrderID) DESC, s.SupplierName ---khác output vì đếm cả po.PurchaseOrderID bị trùng 

	
SELECT  s.SupplierID, s.SupplierName, 
		COUNT(distinct po.PurchaseOrderID) AS NumberOfPurchaseOrders ,--VIP
		SUM(pol.OrderedQuantity) AS TotalOrderedQuantity
FROM Suppliers s LEFT JOIN PurchaseOrders po ON s.SupplierID = po.SupplierID 
				 FULL JOIN PurchaseOrderLines pol ON pol.PurchaseOrderID = po.PurchaseOrderID
	GROUP BY s.SupplierID, s.SupplierName
	ORDER BY COUNT(pol.PurchaseOrderID) DESC, s.SupplierName --OK 
 
--======================================================================================
--Question 6  
--	Write a query to display ProductID, ProductName, NumberOfPurchaseOrders 
--	of the product(s) which have the highest value of NumberOfPurchaseOrders 
--	where NumberOfPurchaseOrders  is the number of purchase orders 	
SELECT * FROM PurchaseOrderLines
SELECT * FROM Products

--bước 1: đến số lượng order của từng product 
SELECT p.ProductID, COUNT(pol.PurchaseOrderID) 
FROM PurchaseOrderLines pol RIGHT JOIN Products p ON pol.ProductID = p.ProductID
GROUP BY p.ProductID

--bước 2: chọn ra số lớn nhất trong những cái vừa đếm 
SELECT TOP 1 COUNT(pol.PurchaseOrderID) 
FROM PurchaseOrderLines pol RIGHT JOIN Products p ON pol.ProductID = p.ProductID
GROUP BY p.ProductID ORDER BY COUNT(pol.PurchaseOrderID) DESC 

--bước 3: hiển thị product có số lượng bằng cái lớn nhất ở b2 
SELECT p.ProductID, p.ProductName, COUNT(pol.PurchaseOrderID) AS NumberOfPurchaseOrders 
	FROM PurchaseOrderLines pol RIGHT JOIN Products p ON pol.ProductID = p.ProductID
	GROUP BY p.ProductID, p.ProductName
	HAVING COUNT(pol.PurchaseOrderID) = (
											SELECT TOP 1 COUNT(pol.PurchaseOrderID) 
											FROM PurchaseOrderLines pol RIGHT JOIN Products p ON pol.ProductID = p.ProductID
											GROUP BY p.ProductID ORDER BY COUNT(pol.PurchaseOrderID) DESC 
										)--OK 

 
--======================================================================================
--Question 7  
--	Write a query to display SupplierID, SupplierName, NumberOfPurchaseOrders, NumberOfProducts
--	and NumberOfTransactions corresponding to each supplier where: 
--	1.	NumberOfPurchaseOrders is the number of purchase orders in January 2013 
--		(calculated based on the OrderDate) of the supplier 
--	2.	NumberOfProducts is the number of distinct products purchased in January 2013
--		(calculated based on the OrderDate) of the supplier 
--	3.	NumberOfTransactions is the number of transactions made in January 2013 
--		(calculated based on the TransactionDate) of the supplier 
--	Display the results by descending order of NumberOfPurchaseOrders then by 
--	asccending order of SupplierName for rows having the same NumberOfPurchaseOrders
SELECT * FROM Suppliers
SELECT * FROM SupplierTransactions
SELECT * FROM Products
SELECT * FROM PurchaseOrders

SELECT * FROM Suppliers s LEFT JOIN SupplierTransactions st ON s.SupplierID = st.SupplierID
				 FULL JOIN Products p ON p.SupplierID = s.SupplierID

go
SELECT s.SupplierID, s.SupplierName,
	   COUNT(DISTINCT st.PurchaseOrderID) NumberOfPurchaseOrders,
	   COUNT(DISTINCT st.SupplierTransactionID) NumberOfTransactions,
	   COUNT(DISTINCT p.ProductID) NumberOfProducts
FROM Suppliers s 
				 LEFT  JOIN Products p ON p.SupplierID = s.SupplierID
				 LEFT JOIN (SELECT * FROM PurchaseOrders WHERE YEAR(OrderDate) = 2013 AND MONTH(OrderDate) = 01)
							po ON po.SupplierID = s.SupplierID	
				 LEFT JOIN (SELECT * FROM SupplierTransactions WHERE YEAR(FinalizationDate) = 2013 AND MONTH(FinalizationDate) = 01 )
							st  ON s.SupplierID = st.SupplierID 
GROUP BY s.SupplierID, s.SupplierName
ORDER BY NumberOfPurchaseOrders DESC, s.SupplierName
go --OK câu này khó quá ~^~ 

--NOTE: nếu làm cách này thì nó sẽ filter trước rồi đếm nên bị thiếu 
SELECT s.SupplierID, s.SupplierName,
	   COUNT(DISTINCT st.PurchaseOrderID) NumberOfPurchaseOrders,
	   COUNT(DISTINCT st.SupplierTransactionID) NumberOfTransactions,
	   COUNT(DISTINCT p.ProductID) NumberOfProducts
FROM Suppliers s 
				 LEFT  JOIN Products p ON p.SupplierID = s.SupplierID
				 LEFT JOIN  PurchaseOrders po 
							 ON po.SupplierID = s.SupplierID	
				 LEFT JOIN SupplierTransactions  
							st  ON s.SupplierID = st.SupplierID
				WHERE YEAR(OrderDate) = 2013 AND MONTH(OrderDate) = 01
				AND YEAR(FinalizationDate) = 2013 AND MONTH(FinalizationDate) = 01
GROUP BY s.SupplierID, s.SupplierName
ORDER BY NumberOfPurchaseOrders DESC, s.SupplierName


--======================================================================================
--Question 8  
--	Create a stored procedure named Proc2 for calculating the amount of a given purchase order 
--	where purchaseOrderID int is the input parameter of the procedure and 
--	totalAmount decimal(18,2) is the output parameter of the procedure.
--	Note that the amount for a product in an order is calculated as UnitPrice*OrderedQuantity 
SELECT * FROM Products
SELECT * FROM PurchaseOrderLines

SELECT pol.PurchaseOrderID,p.UnitPrice, pol.OrderedQuantity, p.UnitPrice * pol.OrderedQuantity AS Amount 
	FROM PurchaseOrderLines pol, Products p 
	WHERE pol.ProductID = p.ProductID 

SELECT pol.PurchaseOrderID, SUM(p.UnitPrice * pol.OrderedQuantity) AS Total  
	FROM PurchaseOrderLines pol, Products p 
	WHERE pol.ProductID = p.ProductID 	
	GROUP BY pol.PurchaseOrderID

go
CREATE PROC Proc2 
@purchaseOrderID int, @totalAmount decimal(18,2) output 
AS 
BEGIN 
	SELECT @totalAmount = SUM(p.UnitPrice * pol.OrderedQuantity)
	FROM PurchaseOrderLines pol, Products p 
	WHERE pol.ProductID = p.ProductID 
		  AND pol.PurchaseOrderID = @purchaseOrderID
END 
go 
		--test 
		declare @x decimal(18,2)
		execute Proc2 1, @x output 
		select @x as TotalOrderedQuantity 

--======================================================================================
--Question 9  
--	Create a trigger named deleteSupplier for the delete statement on table Suppliers 
--	so that when we delete one or more suppliers from the table Suppilers, the system 
--	will display 
--	corresponding to the suppliers that have been deleted 

SELECT * FROM SupplierCategories
SELECT * FROM Suppliers

go
CREATE TRIGGER deleteSupplier ON Suppliers
FOR DELETE 
AS
BEGIN
	SELECT d.SupplierID, d.SupplierName, sc.SupplierCategoryID, sc.SupplierCategoryName
	FROM deleted d, SupplierCategories sc 
	WHERE d.SupplierCategoryID = sc.SupplierCategoryID
END
go 
		--test 
		delete from Suppliers where SupplierID = 3 
DROP TRIGGER deleteSupplier

--======================================================================================
--Question 10  
--	Write a query to insert a new supplier having 
--	SupplierID = 14, SupplierName = 'ABC company', SupplierCategoryID = 3, 
--	DeliveryMethod = 'Courier', DeliverCity = 'NewYork' and SupplierReference = 'ABC123456'.
--	The other attributes of this new supplier have to be null 
SELECT * FROM Suppliers

	INSERT INTO Suppliers(SupplierID, SupplierName, SupplierCategoryID, DeliveryMethod, DeliveryCity, SupplierReference ) 
				   VALUES(		14,	  'ABC company',	3,				'Courier',		'NewYork',		'ABC123456')
	
--DELETE FROM Suppliers WHERE SupplierID = 14 
				  

