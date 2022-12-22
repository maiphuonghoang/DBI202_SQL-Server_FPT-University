
/*
https://www.youtube.com/watch?v=NjgBDl9T-bg&t=346s
*/

USE PE_DBI202_Sp2020
SELECT * FROM ACCOUNT
SELECT * FROM BRANCH
SELECT * FROM BUSINESS
SELECT * FROM CUSTOMER
SELECT * FROM EMPLOYEE
SELECT * FROM INDIVIDUAL
SELECT * FROM PRODUCT

--===================================================================================
--Question 1    
--	1.1 Select all acount which have open_date in March 2001 
SELECT * FROM ACCOUNT WHERE YEAR(OPEN_DATE) = 2001 AND MONTH(OPEN_DATE) = 3

--	1.2 Select all acount which have time between last_activity_date and open_date 
--	equal 4 years 
SELECT ACCOUNT_ID, CUST_ID FROM ACCOUNT WHERE YEAR(LAST_ACTIVITY_DATE) -  YEAR(OPEN_DATE) = 4 

--==================================================================================
--Question 2  
--	2.1 Select all are individual customer 
SELECT * FROM CUSTOMER WHERE CUST_TYPE_CD = 'I'

--	2.2 Count number of all business customer

SELECT COUNT(*) FROM CUSTOMER WHERE CUST_TYPE_CD = 'B' GROUP BY CUST_TYPE_CD --filter trong lúc group 
SELECT COUNT(*) FROM CUSTOMER GROUP BY CUST_TYPE_CD HAVING  CUST_TYPE_CD = 'B'-- filter sau khi group 


--=================================================================================
--Question 3  
--	Select all account which have AVAIL_BALANCE different PENDING_BALANCE

SELECT * FROM ACCOUNT a WHERE a.AVAIL_BALANCE <> a.PENDING_BALANCE
SELECT * FROM ACCOUNT a WHERE a.AVAIL_BALANCE != a.PENDING_BALANCE

--================================================================================
--Question 4   
--	Display name of all customer 
SELECT * FROM CUSTOMER
SELECT * FROM INDIVIDUAL
SELECT * FROM BUSINESS


SELECT c.CUST_ID, c.CUST_TYPE_CD, i.FIRST_NAME + i.LAST_NAME AS [name] 
FROM CUSTOMER c JOIN INDIVIDUAL i ON c.CUST_ID = i.CUST_ID
		UNION 
SELECT c.CUST_ID, c.CUST_TYPE_CD, b.NAME as [name] 
FROM CUSTOMER c JOIN BUSINESS b ON c.CUST_ID = b.CUST_ID


--yêu cầu #1: Sắp xếp bảng trên tăng dần theo tên
go
SELECT c.CUST_ID, c.CUST_TYPE_CD, i.FIRST_NAME + i.LAST_NAME AS [name] 
FROM CUSTOMER c JOIN INDIVIDUAL i ON c.CUST_ID = i.CUST_ID 
		UNION 
SELECT c.CUST_ID, c.CUST_TYPE_CD, b.NAME AS [name] 
FROM CUSTOMER c JOIN BUSINESS b ON c.CUST_ID = b.CUST_ID

ORDER BY [name] 
go

--Yêu cầu #2: tăng dần theo tên nhưng tăng theo từng loại 
go
SELECT c.CUST_ID, c.CUST_TYPE_CD, i.FIRST_NAME + i.LAST_NAME AS [name] 
FROM CUSTOMER c JOIN INDIVIDUAL i ON c.CUST_ID = i.CUST_ID 
		UNION 
SELECT c.CUST_ID, c.CUST_TYPE_CD, b.NAME AS [name] 
FROM CUSTOMER c JOIN BUSINESS b ON c.CUST_ID = b.CUST_ID
ORDER BY CUST_TYPE_CD DESC, [name] ASC
go
		-- nếu type giống nhau thì mới so tên 
--phải sắp theo loại rồi mới sắp theo tên 

--=============================================================================
--Question 5   
--	Count all account of each employee
SELECT * FROM EMPLOYEE
SELECT * FROM ACCOUNT

SELECT COUNT(a.ACCOUNT_ID) FROM EMPLOYEE e LEFT JOIN ACCOUNT a ON e.EMP_ID = a.OPEN_EMP_ID GROUP BY e.EMP_ID

SELECT e.EMP_ID, e.FIRST_NAME + e.LAST_NAME AS [name], COUNT(a.ACCOUNT_ID) AS number 
FROM EMPLOYEE e LEFT JOIN ACCOUNT a ON e.EMP_ID = a.OPEN_EMP_ID 
GROUP BY e.EMP_ID, e.FIRST_NAME, e.LAST_NAME

--=============================================================================
--Question 6   
--	List all Customer_id which have one account
SELECT * FROM ACCOUNT

SELECT a.CUST_ID, COUNT(a.ACCOUNT_ID) FROM ACCOUNT a GROUP BY a.CUST_ID --đếm được số account của mỗi kh 

SELECT a.CUST_ID FROM ACCOUNT a GROUP BY a.CUST_ID HAVING COUNT(a.ACCOUNT_ID) = 1 

--=============================================================================
--Question 7   
--	List account which have min or max avail_balance, but min avai_balance not equal 0 

SELECT	MAX(AVAIL_BALANCE) FROM ACCOUNT--tìm max cách 1 
SELECT TOP 1 AVAIL_BALANCE FROM ACCOUNT ORDER BY AVAIL_BALANCE DESC--tìm max cách 2  

SELECT	MIN(AVAIL_BALANCE) FROM --tìm min cách 1.1 
				(SELECT AVAIL_BALANCE FROM ACCOUNT WHERE AVAIL_BALANCE <>0 ) AS mini  

SELECT	MIN(AVAIL_BALANCE)  --tìm min cách 1 
					FROM ACCOUNT WHERE AVAIL_BALANCE <>0 

SELECT TOP 1 AVAIL_BALANCE  --tìm min cách 2 
							FROM ACCOUNT WHERE AVAIL_BALANCE <>0 
							ORDER BY AVAIL_BALANCE
go
SELECT ACCOUNT_ID, AVAIL_BALANCE FROM ACCOUNT
WHERE 
	 AVAIL_BALANCE = (SELECT MIN(AVAIL_BALANCE) FROM  ACCOUNT WHERE AVAIL_BALANCE <>0 )
	 OR AVAIL_BALANCE = (SELECT	MAX(AVAIL_BALANCE) FROM ACCOUNT)
ORDER BY AVAIL_BALANCE DESC  --OK1
go

go
SELECT ACCOUNT_ID, AVAIL_BALANCE FROM ACCOUNT
WHERE AVAIL_BALANCE = (SELECT MAX(AVAIL_BALANCE) FROM ACCOUNT)
			UNION 
SELECT ACCOUNT_ID, AVAIL_BALANCE FROM ACCOUNT 
WHERE AVAIL_BALANCE = (SELECT MIN(AVAIL_BALANCE) FROM  ACCOUNT WHERE AVAIL_BALANCE <>0 )
ORDER BY AVAIL_BALANCE DESC  --OK2 
go
--=========================
--CÂU ERD 
USE GIAI_DE_PE 
CREATE TABLE Department 
(
	ID int PRIMARY KEY,
	[Name] nvarchar(50)
)
--NOTE: tạo bảng Department trước khi tạo Employee  vì ID của nó được tham chiếu từ Employee 
CREATE TABLE Employee 
(
	ID int PRIMARY KEY,
	[Name] nvarchar(50),
	[Address] nvarchar(200),
	Sex char(10),
	id_de int REFERENCES Department(ID)
)
CREATE TABLE Project 
(
	Code int PRIMARY KEY,
	StartDate datetime,
	FinishRequiredDate datetime,
	FinisdedDate datetime,
	id_de int REFERENCES Department(ID)
)
--NOTE: tạo bảng Project trước khi tạo Join (bảng trung gian giữa Project & Employee )
CREATE TABLE [Join]
(
	JoinedDate datetime,
	FinishedDate datetime,
	Salary int, 
	id_pro int REFERENCES Project(Code),
	id_em int REFERENCES Employee(ID),
	PRIMARY KEY(id_pro, id_em)
)
--c. ADD CONSTRAINT: Projects must have FinishedRequiredDate, StartDate be later than StartDate 
ALTER TABLE Project ADD CONSTRAINT Check_Date  CHECK (FinishRequiredDate > StartDate AND FinishedDate > StartDate)
