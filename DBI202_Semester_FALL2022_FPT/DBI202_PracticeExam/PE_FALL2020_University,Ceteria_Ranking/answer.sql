-- 2. Display all ranking criteria as follows.
select * from ranking_criteria
-- 3. 
select * from ranking_criteria r
where r.ranking_system_id=1 or r.ranking_system_id=2
order by  r.ranking_system_id ASC, r.criteria_name ASC
-- 4.
select u1.university_id, u.university_name, u1.year, u1.num_students, u1.pct_international_students, u.country_id
from university u, university_year u1
where u1.university_id = u.id and u1.year = 2016
and u1.pct_international_students>30
order by u.university_name
-- 5.
select ra.ranking_system_id, r.system_name, count(*) as numberOfCriteria from ranking_criteria ra, ranking_system r
where ra.ranking_system_id = r.id
group by ra.ranking_system_id, r.system_name
order by numberOfCriteria DESC
-- 6.
select u1.university_id, u.university_name, u1.year, u1.student_staff_ratio 
from university u, university_year u1
where u.id = u1.university_id and u1.year = 2015
and u1.student_staff_ratio = (select min(u1.student_staff_ratio) from university_year u1 where u1.year = 2015)
-- 7

select c.university_id, c.university_name, c.ranking_criteria_id, c.criteria_name, c.year, c.score from 
(select ury.university_id, u.university_name, ury.ranking_criteria_id, rc.criteria_name, ury.year, ury.score
from university_ranking_year ury, ranking_criteria rc, university u
where ury.year = 2016 and rc.id = ury.ranking_criteria_id and rc.criteria_name = 'Teaching' and u.id = ury.university_id) as c
join (select * from university_ranking_year ury, ranking_criteria rc
where ury.year = 2016 and rc.id = ury.ranking_criteria_id and rc.criteria_name = 'Teaching') as c1
on c1.score = c.score 
group by c.university_id, c.university_name, c.ranking_criteria_id, c.criteria_name, c.year, c.score
having count(c.university_id) >1
order by c.score DESC
--8
drop trigger proc_university_year
create proc proc_university_year @year int, @pct_international_students int, @nbUniversity int output
as
begin
	declare @count1 int
	select @count1 = count(*) from university_year u where u.year = @year and u.pct_international_students > @pct_international_students
	set @nbUniversity = @count1
end

declare @out int
exec proc_university_year 2011,30, @out output
select @out as NumberOfUniversities
-- 9
drop trigger tr_insert_university_ranking 
create trigger tr_insert_university_ranking
on university_ranking_year instead of insert
as
begin
	select * from inserted
	order by score ASC
end

insert into university_ranking_year(university_id, ranking_criteria_id, year, score)
values (1,1,2020,99),
(12,2,2020,67)

