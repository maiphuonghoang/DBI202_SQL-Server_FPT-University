/*
https://www.youtube.com/watch?v=JZ-LeUA704E&t=1623s
*/
USE PE_DBI202_Su2021

SELECT * FROM customers
SELECT * FROM order_items
SELECT * FROM orders
SELECT * FROM products
SELECT * FROM stocks
SELECT * FROM staffs
SELECT * FROM stores 

--=====================================================================================
--Question 2
SELECT * FROM products WHERE category_name = 'Cyclocross Bicycles'

--======================================================================================
--Question 3
--	Write a query to select product_name, model_year, list_price, brand_name 
--	of all  products of the brand 'Trek' having the model_year = 2018
--	and having the list_price greater than 3000; display the results in ascending 
--	order of list_price
SELECT * FROM products
SELECT product_name, model_year, list_price, brand_name FROM products 
WHERE brand_name = 'Trek' AND model_year = 2018 AND list_price > 3000 ORDER BY list_price 

--=====================================================================================
--Question 4
--	Write a query to display 
--	orders made in January 2016 in the 'Santa Cruz Bikes' store 
SELECT * FROM orders
SELECT * FROM stores 
SELECT * FROM customers
go
SELECT o.order_id, o.order_date, o.customer_id, c.first_name, c.last_name, s.store_name
		FROM orders o JOIN stores s ON o.store_id = s.store_id
					  JOIN customers c ON o.customer_id = c.customer_id
					  WHERE YEAR(o.order_date) = 2016 AND MONTH(o.order_date) = 1
							AND s.store_name = 'Santa Cruz Bikes'
go	--OK 1 

go
SELECT o.order_id, o.order_date, o.customer_id, c.first_name, c.last_name, s.store_name
		FROM orders o, stores s, customers c
		WHERE o.store_id = s.store_id AND o.customer_id = c.customer_id --dùng WHERE thay JOIN cx đc 
			AND o.order_date BETWEEN '2016-1-1' AND '2016-1-31'
			AND s.store_name = 'Santa Cruz Bikes'
go	--OK2 

--=====================================================================================
--Question 5
--	Write a query to display store_id, store_name, NumberOfOrdersIn2018
--	has NumberOfOrdersIn2018 is the numbers of orders made in 2018 in each store 
--	display the results in descending order of NumberOfOrdersIn2018

SELECT * FROM orders
SELECT * FROM stores 
SELECT COUNT(*) FROM orders o JOIN stores s ON o.store_id = s.store_id
	WHERE YEAR(o.order_date) = 2018 GROUP BY s.store_id

go
SELECT s.store_id, s.store_name, COUNT(o.store_id) NumberOfOrdersIn2018
		FROM orders o JOIN stores s ON o.store_id = s.store_id
					  WHERE YEAR(o.order_date) = 2018 
					  GROUP BY s.store_id, s.store_name
					  ORDER BY NumberOfOrdersIn2018 DESC
go

--=====================================================================================
--Question 6
--	Write a query to display product_id, product_name, model_year, TotalStockQuantity 
--	of the products having the maximum TotalStockQuantity where TotalStockQuantity of each product 
--	is the total stock quantity of the products in all the stores 
SELECT * FROM products
SELECT * FROM stocks
SELECT SUM(s.quantity) FROM stocks s GROUP BY s.product_id
SELECT MAX(NoQuantity) FROM (SELECT SUM(s.quantity) AS NoQuantity FROM stocks s GROUP BY s.product_id) AS Temp --tìm đc max = 86 
SELECT top 1 SUM(s.quantity) AS NoQuantity FROM stocks s GROUP BY s.product_id ORDER BY NoQuantity DESC --tìm đc max = 86

go
SELECT s.product_id, p.product_name, p.model_year, SUM(s.quantity) AS TotalStockQuantity 
	 FROM products p JOIN stocks s ON p.product_id = s.product_id	
	 GROUP BY s.product_id,  p.product_name, p.model_year
	 HAVING SUM(s.quantity) = ( --tìm max cách 1 
								SELECT MAX(NoQuantity) FROM (SELECT SUM(s.quantity) AS NoQuantity FROM stocks s GROUP BY s.product_id) AS Temp
							   )		
go --OK 1 
go
SELECT s.product_id, p.product_name, p.model_year, SUM(s.quantity) AS TotalStockQuantity 
	 FROM products p JOIN stocks s ON p.product_id = s.product_id	
	 GROUP BY s.product_id,  p.product_name, p.model_year
	 HAVING SUM(s.quantity) = ( --tìm max cách 2 
								SELECT top 1 SUM(s.quantity) AS NoQuantity FROM stocks s GROUP BY s.product_id ORDER BY NoQuantity DESC
							   )		
go --OK 2

--=========================================================================================
--Question 7
--	Write a query to display, for each store, the information of staff who made the most orders. 
--	Display the information with the following attributes: 
--			store_name, staff_id, first_name, last_name, NumberOfOrders
--	where staff_id, firstname, last_name is the information of the staff in the given store
--	who made the most orders and NumberOfOrders is the number of orders that he/she made.
--		For example, in the 'Baldwin Bikes' store, the staffs 5,6,7 made respectively 
--	0, 349, 353 orders; so, the information of the staff 7 with the highest
--	NumberOfOrders (353) is display for the 'Baldwin Bikes' store


SELECT * FROM orders
SELECT * FROM staffs
SELECT * FROM stores 

SELECT o.store_id, o.staff_id, COUNT(o.order_id) FROM orders o GROUP BY o.store_id, o.staff_id
/*	   store  staff	no
		1		2	106
		2		6	349
		3		8	68
		2		7	353
		1		3	134
*/

go 
SELECT so.store_name, o.staff_id, sf.first_name, sf.last_name, COUNT(o.order_id) AS NumberOfOrders 
			FROM orders o JOIN staffs sf ON o.staff_id = sf.staff_id
			JOIN stores so ON o.store_id = so.store_id
			GROUP BY o.store_id, o.staff_id, so.store_name, sf.first_name, sf.last_name
			HAVING COUNT(o.order_id) = (SELECT MAX(NoOrders) FROM (SELECT COUNT(o.order_id) AS NoOrders FROM orders o WHERE store_id = 1  GROUP BY o.store_id, o.staff_id) AS max1)
				OR COUNT(o.order_id) = (SELECT MAX(NoOrders) FROM (SELECT COUNT(o.order_id) AS NoOrders FROM orders o WHERE store_id = 2  GROUP BY o.store_id, o.staff_id) AS max2)
				OR COUNT(o.order_id) = (SELECT MAX(NoOrders) FROM (SELECT COUNT(o.order_id) AS NoOrders FROM orders o WHERE store_id = 3  GROUP BY o.store_id, o.staff_id) AS max3)
			ORDER BY so.store_name

go -- làm cho biết hoy, k dùng cách này ^_^


go
SELECT so.store_name, o.staff_id, sf.first_name, sf.last_name, COUNT(so.store_name) AS NumberOfOrders 
			FROM orders o JOIN staffs sf ON o.staff_id = sf.staff_id
			JOIN stores so ON o.store_id = so.store_id
			GROUP BY o.store_id, o.staff_id, so.store_name, sf.first_name, sf.last_name
			HAVING COUNT(so.store_name) IN (
								SELECT table2.MaxList 
										FROM 
											(SELECT table1.store_name, MAX(table1.NoOrders) as MaxList 
													FROM (
															SELECT so.store_name, COUNT(*) AS NoOrders 
																	FROM orders o JOIN stores so ON o.store_id = so.store_id
																	GROUP BY o.store_id, o.staff_id, so.store_name
																		/* table0 
																		  store_name		NoOrders
																		Santa Cruz Bikes	106
																		Baldwin Bikes		349
																		Rowlett Bikes		68
																		Baldwin Bikes		353
																		Santa Cruz Bikes	134
																		*/
														  ) AS table1 
													GROUP BY table1.store_name
													/* table 1
														store_name			MaxList
														Baldwin Bikes		53
														Rowlett Bikes		68
														Santa Cruz Bikes	134
													*/
										     ) AS table2
												/*
												353
												68
												134
												*/
								)
			ORDER BY so.store_name
go --OK 

------------------luyện tập lần 1 cho nhớ đây------------------------------

SELECT sto.store_name, o.staff_id, COUNT(*) AS NoOrders 
FROM stores sto JOIN orders o ON sto.store_id = o.store_id 
GROUP BY o.store_id, o.staff_id, sto.store_name

SELECT table1.store_name, MAX(NoOrders) 
FROM 
(
	SELECT sto.store_name, o.staff_id, COUNT(*) AS NoOrders 
	FROM stores sto JOIN orders o ON sto.store_id = o.store_id 
	GROUP BY o.store_id, o.staff_id, sto.store_name
)AS table1 
GROUP BY table1.store_name --ĐỂ TÌM RA TỪNG CÁI LỚN NHẤT CỦA MỖI STORE 

SELECT table2.MaxList FROM 
(
	SELECT table1.store_name, MAX(NoOrders) AS MaxList 
		  FROM 
			(
				SELECT sto.store_name, o.staff_id, COUNT(*) AS NoOrders 
				FROM stores sto JOIN orders o ON sto.store_id = o.store_id 
				GROUP BY o.store_id, o.staff_id, sto.store_name
			 )AS table1 
		  GROUP BY table1.store_name
) AS table2 --đã được danh sách max của từng của hàng 

--giờ thì gộp ra bảng cuối cùng có max IN [list MaxList] là được 

SELECT sto.store_name, o.staff_id, sta.first_name, sta.last_name, COUNT(*) AS NumberOfOrders 
FROM stores sto JOIN orders o ON sto.store_id = o.store_id 
				JOIN staffs sta ON o.staff_id = sta.staff_id
GROUP BY sto.store_name, o.staff_id, sta.first_name, sta.last_name
HAVING COUNT(*) IN 
(
	SELECT table2.MaxList FROM 
	(
		SELECT table1.store_name, MAX(NoOrders) AS MaxList 
		  FROM 
			(
				SELECT sto.store_name, o.staff_id, COUNT(*) AS NoOrders 
				FROM stores sto JOIN orders o ON sto.store_id = o.store_id 
				GROUP BY o.store_id, o.staff_id, sto.store_name
			 )AS table1 
		  GROUP BY table1.store_name
	) AS table2
) 
ORDER BY sto.store_name 

--=========================================================================================
--Question 8
--	Create a stored procedure named pr1 to calculate the number of staffs in a given store 
--	where	@store_id int			is an input parameter 
--  and		@numberOfStaffs int		is an output parameter 
--	of the procedure.

SELECT * FROM staffs
SELECT store_id, COUNT(*) FROM staffs GROUP BY store_id

go
CREATE PROC prt1V1 @store_id int, @numberOfStaffs int output 
AS
	SELECT @numberOfStaffs = COUNT(s.store_id) FROM staffs s WHERE s.store_id = @store_id
	--SET @numberOfStaffs = (SELECT COUNT(s.store_id) FROM staffs s WHERE s.store_id = @store_id)

go
			--test 
			declare @x int 
			exec prt1V1 3, @x output 
			select @x as NumberOfStaffs
--=========================================================================================
--Question 9
--	Create a trigger named Tr2 for the delete statement on table stocks so that 
--	when we delete one or more rows from the tables stocks, the system will display the 
--
--	corresponding to the rows that have been deleted.
SELECT * FROM stocks
SELECT * FROM stores 
SELECT * FROM products

go
CREATE TRIGGER Tr2V1 ON stocks 
FOR DELETE 
AS
BEGIN
	SELECT d.product_id, p.product_name, d.store_id, s.store_name, d.quantity
	FROM deleted d, stores s, products p
	WHERE d.product_id = p.product_id AND d.store_id = s.store_id
	--ROLLBACK TRANSACTION --để khi test database ko ảnh hưởng 
END 
go
		--test 
		delete from stocks where store_id = 1 and product_id in (10,11,12)
--=========================================================================================
--Question 10
--	Write a query to update the stock quantity = 30 for all products of the category 
--	'Cruisers Bicycles' in the store with store_id = 1. 

SELECT * FROM stocks
SELECT * FROM products

UPDATE stocks SET quantity = 10 WHERE store_id = 1 
AND product_id IN 
	(SELECT p.product_id FROM stocks s, products p WHERE s.product_id = p.product_id
			AND s.store_id = 1 AND p.category_name = 'Cruisers Bicycles'
	)

--=========================================================================================
--Question 1
USE GIAI_DE_PE
 
CREATE TABLE Locations 
(
	LocationID varchar(20) PRIMARY KEY,
	[Name] nvarchar(100),
	[Address] nvarchar(255)
)
CREATE TABLE [Events] 
(
	eventID int PRIMARY KEY,
	[name] nvarchar(255),
	StartTime datetime,
	EndTime datetime,
	LocationID varchar(20) REFERENCES Locations(LocationID)
)
CREATE TABLE Staffs 
(
	staffID int PRIMARY KEY,
	[Name] nvarchar(255),
	Phone varchar(15), 
)
CREATE TABLE WorkforV
(
	[role] nvarchar(30) PRIMARY KEY,
	eventID int REFERENCES [Events] (eventID),
	staffID int REFERENCES Staffs (staffID)
)

--nếu muốn xóa bảng thì phải xóa theo thứ tự này 
DROP TABLE WorkforV  
DROP TABLE [Events] 
DROP TABLE Staffs
DROP TABLE Locations 