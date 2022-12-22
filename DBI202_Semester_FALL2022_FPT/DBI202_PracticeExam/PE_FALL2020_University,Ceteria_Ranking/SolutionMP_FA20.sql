USE PE_DBI202_F2020

SELECT * FROM country
SELECT * FROM ranking_criteria
SELECT * FROM ranking_system
SELECT * FROM university
SELECT * FROM university_ranking_year
SELECT * FROM university_year

--=========================================================================
--Question 2
SELECT * FROM ranking_criteria

--=========================================================================
--Question 3
--	Write a query to select ranking_system_id, criteria_name of all ranking 
--	system having ranking_system_id 1 or 2; display the results by ascending 
--	order of ranking_system_id, then by ascending order of criteria of the  
--	same ranking system 

SELECT * FROM ranking_criteria

SELECT ranking_system_id, criteria_name FROM ranking_criteria 
		WHERE ranking_system_id = 1 OR ranking_system_id = 2
		ORDER BY ranking_system_id ASC, criteria_name ASC--OK 1 

SELECT ranking_system_id, criteria_name FROM ranking_criteria 
		WHERE ranking_system_id IN (1, 2)
		ORDER BY ranking_system_id, criteria_name --OK 2 

--===================================================================================
--Question 4
--	Write a query to display the information about the number of students as well as 
--	the percentage of international students in 2016 of the universities having the 
--	percentage of international students (pct_international_students) in 2016 greater than 30%;
--	display the results in the form of university_id, university_name,
--	year, num_students, pct_international_students, country_id
--	in ascending order of university_name 

SELECT * FROM university
SELECT * FROM university_year

SELECT  uy.university_id, u.university_name, uy.[year], uy.num_students, uy.pct_international_students, u.country_id		
		FROM university_year uy JOIN university u ON uy.university_id = u.id
		WHERE uy.[year] = 2016 AND uy.pct_international_students > 30 
		ORDER BY u.university_name 

--======================================================================================
--Question 5
--	Write a query to display system_id, system_name, numberOfCriteria of each ranking system
--	where numberOfCriteria is the number of criteria corresponding to the ranking system 
--	display the results by descending order of numberOfCriteria

SELECT * FROM ranking_criteria
SELECT * FROM ranking_system

SELECT rc.ranking_system_id AS system_id, rs.system_name, COUNT(rc.id) AS numberOfCriteria
		FROM ranking_criteria rc JOIN ranking_system rs ON rc.ranking_system_id = rs.id
		GROUP BY rc.ranking_system_id, rs.system_name
		ORDER BY numberOfCriteria DESC 

--======================================================================================
--Question 6
--	Write a query to display university_id, university_name, year, student_staff_ratio
--	of all universities having the lowest student_staff_ratio in 2015 
SELECT * FROM university
SELECT * FROM university_year

SELECT MIN(uy.student_staff_ratio) FROM university_year uy WHERE uy.year = 2015	--tìm min C1 
SELECT TOP 1 uy.student_staff_ratio FROM university_year uy WHERE uy.year = 2015 ORDER BY uy.student_staff_ratio ASC --tìm min C2 


SELECT  uy.university_id, u.university_name, uy.[year], uy.student_staff_ratio		
		FROM university_year uy JOIN university u ON uy.university_id = u.id
		WHERE uy.year = 2015 
			  AND uy.student_staff_ratio = (SELECT MIN(uy.student_staff_ratio) FROM university_year uy WHERE uy.year = 2015)

--======================================================================================
--Question 7 
--	Write a query to display the score in 2016 based on the 'Teaching' ranking criteria 
--	of all universities which have the same score with at least one other university;
--	display the results in form of 
--	in descending order score  
SELECT * FROM university_ranking_year
SELECT * FROM ranking_criteria
SELECT * FROM university

SELECT * FROM university_ranking_year WHERE ranking_criteria_id = 1 AND year = 2016 

SELECT score, COUNT(*) FROM university_ranking_year WHERE ranking_criteria_id = 1 AND year = 2016 GROUP BY score

SELECT score FROM university_ranking_year WHERE ranking_criteria_id = 1 AND year = 2016 GROUP BY score
		HAVING COUNT(*) > 1

SELECT  ury.university_id, u.university_name, ury.ranking_criteria_id, rc.criteria_name, ury.[year], ury.score
		FROM university_ranking_year ury JOIN university u ON ury.university_id = u.id
										 JOIN ranking_criteria rc ON ury.ranking_criteria_id = rc.id
		WHERE ranking_criteria_id = 1 AND year = 2016
			  AND ury.score IN 
							(SELECT score FROM university_ranking_year WHERE ranking_criteria_id = 1 AND year = 2016 GROUP BY score
							HAVING COUNT(*) > 1 )
		ORDER BY ury.score DESC --đúng nhưng khác thứ tự <>_<>
								-- sửa bằng cách cho group by trước khi filter 
----------
go
SELECT  ury.university_id, u.university_name, ury.ranking_criteria_id, rc.criteria_name, ury.[year], ury.score
		FROM university_ranking_year ury JOIN university u ON ury.university_id = u.id
										 JOIN ranking_criteria rc ON ury.ranking_criteria_id = rc.id
		WHERE rc.criteria_name = 'Teaching' AND year = 2016
		GROUP BY ury.university_id, u.university_name, ury.ranking_criteria_id, rc.criteria_name, ury.[year], ury.score
			  HAVING ury.score IN 
							(SELECT score FROM university_ranking_year ury,  ranking_criteria rc
							 WHERE rc.id = ury.ranking_criteria_id and rc.criteria_name = 'Teaching' AND ury.year = 2016 
							 GROUP BY score
							 HAVING COUNT(*) > 1 )
		ORDER BY ury.score DESC --OK 1 
go

go
select c.university_id, c.university_name, c.ranking_criteria_id, c.criteria_name, c.year, c.score from 
(select ury.university_id, u.university_name, ury.ranking_criteria_id, rc.criteria_name, ury.year, ury.score
from university_ranking_year ury, ranking_criteria rc, university u
where ury.year = 2016 and rc.id = ury.ranking_criteria_id and rc.criteria_name = 'Teaching' and u.id = ury.university_id) as c
join (select * from university_ranking_year ury, ranking_criteria rc
where ury.year = 2016 and rc.id = ury.ranking_criteria_id and rc.criteria_name = 'Teaching') as c1
on c1.score = c.score 
group by c.university_id, c.university_name, c.ranking_criteria_id, c.criteria_name, c.year, c.score
having count(c.university_id) >1
order by c.score DESC  --OK 2, tham khảo thêm  
go 


--========================================================================================================
--Question 8 
--	Create a stored procedure name proc_university_year for calculating the total number of universities  
--	having the percentage of international students greater than a given number ̣(input parameter @pct_international_students int)
--	in a given year (input parameter @year int). The @nbUniversity int is the output parameter of the procedure.

SELECT * FROM university_year

go
CREATE PROC proc_university_year
@year int, @pct_international_students int, @nbUniversity int output 
AS 
BEGIN
	 SELECT @nbUniversity = COUNT(university_id) FROM university_year 
	 WHERE year = @year AND pct_international_students > @pct_international_students
END

	--test 
		declare @out int
		exec proc_university_year 2011,30, @out output
		select @out as NumberOfUniversities

DROP PROC proc_university_year
go

--===================================================================================
--Question 9 
--	Create a trigger name tr_insert_university_ranking for the insert statement on table 
--	university_ranking_year so that when we insert one or more rows in this table, 
--	the system will display 
--	corresponding to the rows that have been inserted 
SELECT * FROM university_ranking_year
SELECT * FROM ranking_criteria
SELECT * FROM university

go
CREATE TRIGGER tr_insert_university_ranking ON university_ranking_year
FOR INSERT 
AS
BEGIN 
	SELECT i.university_id, u.university_name, i.ranking_criteria_id, rc.criteria_name, i.year, i.score
	FROM inserted i 
	JOIN university u ON i.university_id = u.id
	JOIN ranking_criteria rc ON i.ranking_criteria_id = rc.id	
	--ROLLBACK 
END
	
		--test 
			insert into university_ranking_year(university_id, ranking_criteria_id, year, score)
										values (1,1,2020,99),
											   (12,2,2020,67)

DROP TRIGGER tr_insert_university_ranking
go

--===================================================================================
--Question 10 
--	Write queries to insert a new ranking system with id = 4 and system_name = 'QS World University Rankings'
--	and to insert two new ranking criteria for this ranking system. The id and criteria_name of these 
--	two new criteria are (22, 'Academic Reputation') and (23, 'Citations per faculty')

SELECT * FROM ranking_system
SELECT * FROM ranking_criteria

INSERT INTO ranking_system VALUES (4, 'QS World University Rankings')
INSERT INTO ranking_criteria VALUES(22, 4, 'Academic Reputation'), (23, 4,'Citations per faculty')