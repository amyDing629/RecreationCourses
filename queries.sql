 -- queries for question 1
-- drop view from the query
drop view if exists all_comb, submain, rst cascade;

-- all combinations of ward and sections
create view all_comb as
select distinct ward, section
from wards, programs;

-- get to know the density of courses for each section in wards
create view submain as
select distinct locations.ward, section, count(distinct Course_Barcode)/area as density
from courses natural join locations natural join programs, wards
where locations.ward = wards.ward
group by locations.ward, area, section;

-- if a ward does not have courses of a section, then shows 0
create view rst as
select ward, section, coalesce(density, 0) as density
from all_comb natural left join submain;

-- output data
select * from rst;

-- more queries related to question 1
 -- 1.1 report highest density section of a ward
drop view if exists highest cascade;
create view highest as
select ward, section, density from rst
where (ward, section, density) not in
(select r1.ward, r1.section, r1.density
from rst as r1, rst as r2
where r1.density < r2.density);
select * from highest;

-- 1.2 report all the courses, location of the above section in the ward
drop view if exists highest_courses cascade;
create view highest_courses as
select ward, section, courses
from courses natural join locations natural join programs natural join highest;
select * from highest_courses;

-- 1.3 report the number of missing ward for each section
drop view if exists missing cascade;
create view missing as select section, count(ward) from rst where density = 0 group by section;
select * from missing;

-- 1.4 report sections that all wards have courses about
select distinct section from programs where section not in (select section from missing);

-- 1.5 report sections that only one ward is missing
drop view if exists one cascade;
create view one as select section from rst where density = 0 group by section having count(ward) = 1;
select ward, section from one natural join (select section, ward from rst where density = 0) a;


-- query for question 2
-- drop view from the query
drop view if exists a, b cascade;

-- find courses that are located in Agincourt Recreation Centre, start in April, hold one day a week and allow people with age 82 to participate.
create view a as
select distinct Course_Barcode, name, Days_of_the_week, start_hour, section
from Courses natural join limits natural join locations natural join times natural join programs
where Max_age >= 82 and min_age <= 82 and location = 'Agincourt Recreation Centre' and
startmonth = 'Apr' and length(days_of_the_week) <= 2 ;
select * from a;

-- more queries related to question 2
-- query for 2.1
-- find the combination of courses that meet the requirement of the problem
create view b as
select a1.course_barcode as a1, a1.name as name1, a1.days_of_the_week as day1, a1.start_hour as time1,
a2.course_barcode as a2, a2.name as name2, a2.days_of_the_week as day2, a2.start_hour as time2
from a as a1, a as a2
where a1.section = 'Swimming' and a1.days_of_the_week = 'Su' and a2.section != 'Swimming' and a2.days_of_the_week != 'Su';

-- output data
select * from b;

-- 2.2 Marry wants to find private swim lessons in the afternoon(time > 12). 
select * from b where time1 > 12 and name1 = 'Private Swim Lessons';


-- queries for question 3

-- drop view before the query

drop view if exists timecheck cascade;
drop view if exists coursetime cascade;
drop view if exists reqcourses cascade;

-- create a view to find all courses that in summer, weekend and total course hour is 2 -10 hours inclusive. 

create view timecheck as (select * from times where Reg_session = 'Fall' and course_hours>=2 and course_hours <= 10 and (days_of_the_week = 'Sa' or days_of_the_week = 'Su') or days_of_the_week = 'Su  Sa');

-- find the courses that have the above schedule
create view coursetime as (select course_barcode,location, program, Days_of_the_week, Startmonth, Startday, start_hour from timecheck, courses where courses.timeID= timecheck.timeID);


-- find the Skating courses that in Scarborough East for Adults 
create view reqcourses as (select course_barcode, coursetime.location as location, coursetime.program as program, Days_of_the_week, Startmonth, Startday, start_hour from coursetime, locations, wards, programs where coursetime.location=locations.location and coursetime.program = programs.program and locations.ward = wards.ward and section = 'Swimming' and wards.name ='Scarborough East' and (subsection = 'Adult' or subsection = 'Youth/Adult'));

select * from reqcourses;


-- queries related to question 3
-- 3.1 check if she can register the course she want or not
select courses.course_barcode, max_reg- course_reg as space from reqcourses, courses, limits where reqcourses.course_barcode=courses.course_barcode and courses.limitid = limits.limitid and courses.course_barcode = 2760451 and 25>=min_age and 25<=max_age and max_reg - course_reg>0;




