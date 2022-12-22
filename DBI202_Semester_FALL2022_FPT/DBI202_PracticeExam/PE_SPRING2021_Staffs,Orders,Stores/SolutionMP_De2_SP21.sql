USE PE_DBI202_Sp2021
--giống hệt database USE PE_DBI202_Su2021


SELECT * FROM customers
SELECT * FROM order_items
SELECT * FROM orders
SELECT * FROM products
SELECT * FROM stocks
SELECT * FROM staffs
SELECT * FROM stores 

--=====================================================================================
--Question 3
--	Write a query to select customer_id, first_name, last_name, city, state
--	of all customer from the 'Bellmore' or 'New York' cities 
--	of the 'NY' state, display the results ascending order of city 
SELECT * FROM customers

SELECT c.customer_id, c.first_name, c.last_name, c.city, c.[state] 
		FROM customers c 
		WHERE c.city IN ('Bellmore', 'New York')
			  AND c.[state] = 'NY'	
		ORDER BY c.city

--=====================================================================================
--Question 4 
--	Write a query to display product_id, product_name, list_price, category_name, store_id, quantity
--	corresponding to all products having the stock quantity in the store 1 (store_id = 1)
--	greater than 25, display the results in ascending order of category_name than by 
--	descending order of list_price for the products of the same category.
SELECT * FROM stocks
SELECT * FROM products

SELECT p.product_id, p.product_name, p.list_price, p.category_name, s.store_id, s.quantity
		FROM stocks s JOIN products p ON s.product_id = p.product_id
		WHERE s.store_id = 1 AND s.quantity > 25 
		ORDER BY p.category_name, p.list_price DESC 

--=====================================================================================
--Question 5  
--	Write a query to display staff_id, first_name, last_name, NumberOfOrders
--	corresponding to each staff where NumberOfOrders is the number of orders made in 2016 
--	(using order_date here) of each staff; display the results by descending order of NumberOfOrders
SELECT * FROM staffs
SELECT * FROM orders
SELECT s.staff_id, o.store_id, COUNT(o.order_id) FROM staffs s JOIN orders o ON o.store_id = s.store_id 
GROUP BY s.staff_id, o.store_id

SELECT s.staff_id, s.first_name, s.last_name, COUNT(o.order_id) AS NumberOfOrders
		FROM staffs s JOIN orders o ON s.staff_id = o.staff_id --join trên staff_id là SAI 
		WHERE YEAR(o.order_date) = 2016
		GROUP BY s.staff_id, s.first_name, s.last_name
		ORDER BY NumberOfOrders DESC 
go
SELECT s.staff_id, s.first_name, s.last_name, COUNT(o.staff_id) AS NumberOfOrders
		FROM staffs s JOIN orders o ON o.store_id = s.store_id 
		WHERE YEAR(o.order_date) = 2016
		GROUP BY s.staff_id, s.first_name, s.last_name
		ORDER BY NumberOfOrders DESC 
go --OK 

--=====================================================================================
--Question 6  
--	Write a query to display product_id, product_name, model_year, store_id, quantity 
--	for all products having the minimum stock quantity in each store

SELECT * FROM products
SELECT * FROM stocks

--bước 1 
SELECT s.store_id, p.product_id, s.quantity 
FROM products p JOIN stocks s ON p.product_id = s.product_id 
GROUP BY s.store_id, p.product_id, s.quantity

--bước 2 
SELECT table1.store_id, MIN(table1.quantity) AS mini FROM --bảng bước 1 
		(SELECT s.store_id, p.product_id, s.quantity FROM products p JOIN stocks s ON p.product_id = s.product_id GROUP BY s.store_id, p.product_id, s.quantity)
AS table1 GROUP BY table1.store_id --tìm được min của các cửa hàng 

--bước 3 
SELECT p.product_id, p.product_name, p.model_year, s.store_id, s.quantity 
FROM products p JOIN stocks s ON p.product_id = s.product_id 
GROUP BY p.product_id, p.product_name, p.model_year, s.store_id, s.quantity 
HAVING s.quantity IN ( --có min trong các giá trị bảng 2 
					SELECT table2.mini FROM 
							(SELECT table1.store_id, MIN(table1.quantity) AS mini FROM 
									(SELECT s.store_id, p.product_id, s.quantity FROM products p JOIN stocks s ON p.product_id = s.product_id GROUP BY s.store_id, p.product_id, s.quantity)
							AS table1 GROUP BY table1.store_id)
					AS table2 )

--=====================================================================================
--Question 7  
--	Write a query to display for each store in each year, the staff, who made the most orders 
--	in the year for the store. Display the results in form of
--  store_name, year, first_name, last_name, NumberOfOrders
--	where first_name, last_name is the information of the staff who made the most orders 
--	in the corresponding year for the corresponding store 

SELECT * FROM orders
SELECT * FROM staffs
SELECT * FROM stores 

--bước 1 
SELECT sto.store_name, YEAR(o.order_date) AS year, sta.first_name, sta.last_name, COUNT(o.order_id) AS NumberOfOrders 
FROM orders o RIGHT JOIN staffs sta ON o.staff_id = sta.staff_id
					 JOIN stores sto ON sto.store_id = o.store_id
					 GROUP BY sto.store_name,  YEAR(o.order_date), sta.first_name, sta.last_name

--bước 2 
SELECT table2.store_name, table2.year, MAX(table2.max1) AS max2 FROM  --table 1 
(
SELECT sto.store_name, sta.staff_id, YEAR(o.order_date) AS [year], COUNT(o.order_id) AS max1 FROM orders o RIGHT JOIN staffs sta ON o.staff_id = sta.staff_id
					 JOIN stores sto ON sto.store_id = o.store_id
					 GROUP BY sto.store_name, sta.staff_id, YEAR(o.order_date)
)AS table2 
GROUP BY table2.store_name, table2.year

--bước 3 
SELECT sto.store_name, YEAR(o.order_date) AS year, sta.first_name, sta.last_name, COUNT(o.order_id) AS NumberOfOrders 
FROM orders o RIGHT JOIN staffs sta ON o.staff_id = sta.staff_id
					 JOIN stores sto ON sto.store_id = o.store_id
					 GROUP BY sto.store_name,  YEAR(o.order_date), sta.first_name, sta.last_name
HAVING  COUNT(o.order_id) IN 
(SELECT table3.max2 FROM 
	(--table 2 
	SELECT table2.store_name, table2.year, MAX(table2.max1) AS max2 FROM 
	(
	SELECT sto.store_name, sta.staff_id, YEAR(o.order_date) AS [year], COUNT(o.order_id) AS max1 FROM orders o RIGHT JOIN staffs sta ON o.staff_id = sta.staff_id
					 JOIN stores sto ON sto.store_id = o.store_id
					 GROUP BY sto.store_name, sta.staff_id, YEAR(o.order_date)
	)AS table2 
	GROUP BY table2.store_name, table2.year
	)

AS table3 
)

--=====================================================================================
--Question 8   
--	Create a stored procedure name proc2 for calculating the numbers of orders emitted in a 
--	given store; where @store_name varchar(255) is the input parameter and 
--	@numberOfOrders int is the output parameter of the procedure 
SELECT * FROM orders
SELECT * FROM stores

go
CREATE PROC proc2 
@store_name varchar(255), @numberOfOrders int output 
AS
BEGIN
	SELECT @numberOfOrders = COUNT(order_id) FROM orders o, stores s 
	WHERE o.store_id = s.store_id AND s.store_name = @store_name
END

	--test 
	declare @x int 
	exec proc2 'Baldwin Bikes', @x output
	select @x as NumberOfOrders 

DROP PROC proc2 

--=====================================================================================
--Question 9   
--	Create a trigger name trigger_update_orderItems for the update statement on table 
--	order_items so that when we update the quantity or the discount of one or more rows 
--	in the table order_items, the system will display 
--	corresponding to the rows that have been updated
--	where OldAmount and NewAmount are respectively the Amounts 
--	(calculated as list_price*quantity*(1-discount)) of the corresponding rows 
--	before and after updating the information 

SELECT * FROM order_items

go
CREATE TRIGGER trigger_update_orderItems ON order_items 
FOR UPDATE 
AS
BEGIN
	SELECT d.order_id, d.item_id, d.product_id, 
	d.list_price * d.quantity *(1 - d.discount) AS OldAmount, i.list_price * i.quantity *(1 - i.discount) AS NewAmount
	FROM inserted i, deleted d 
	WHERE i.order_id = d.order_id
	--ROLLBACK 
END

		--test 
		update order_items
		set quantity = 2, discount = 0.3
		where order_id = 1 and item_id = 1 

DROP TRIGGER trigger_update_orderItems
go 


--===================================================================================
--Question 10 
--	Write a query to insert a new staff with
--	staff_id = 19, first_name = 'White', last_name = 'Mary', 
--	email = 'white.mary@bikes.shop', active = 1, stored_id = 3, manager_id = 7 

SELECT * FROM staffs

INSERT INTO staffs(staff_id, first_name, last_name, email, active, store_id, manager_id)
			VALUES (19, 'White', 'Mary', 'white.mary@bikes.shop', 1, 3, 7)

--DELETE FROM staffs WHERE staff_id = 19 

--===================================================================================
--Question 1
USE GIAI_DE_PE
CREATE TABLE Customers
(
	SSN varchar(20) PRIMARY KEY, 
	[Name] nvarchar(50),
	[Address] nvarchar(255)
)

CREATE TABLE Loans
(
	LoanNumber varchar(20) PRIMARY KEY,
	Amount float, 
	[Date] Date,
	Branch nvarchar(100),
	SSN varchar(20),
	FOREIGN KEY (SSN) REFERENCES Customers(SSN)
)

CREATE TABLE Payments
(
	PaymentNo varchar(30) PRIMARY KEY,
	Amount float,
	[Date] Date,
	LoanNumber varchar(20) REFERENCES Loans(LoanNumber)
)
