--=====================New Assignment======================
--====================Assignment 6 SQL=====================
/*
Question1 (EXAM_RESULTS table)							
STUDENT_ID	FIRST_NAME	LAST_NAME	EXAM_ID	EXAM_SCORE
10			LAURA		LYNCH			1		90
10			LAURA		LYNCH			2		85
11			GRACE		BROWN			1		78
11			GRACE		BROWN			2		72
12			JAY			JACKSON			1		95
12			JAY			JACKSON			2		92
13			WILLIAM		BISHOP			1		70
13			WILLIAM		BISHOP			2		100
14			CHARLES		PRADA			2		85
Write the SQL queries for the following statements:
1. SQL statement to find the average exam score for EXAM_ID = 1?
2. SQL statement to find out number of students attended each exam?	
3. SQL statement to find the maximum score of EXAM_ID=1 and FIRST_NAME has the letter “E”.

*/
use MyDb
create table Exam_Results
(
	STUDENT_ID numeric(2),
	FIRST_NAME varchar(20),
	LAST_NAME varchar(20),
	EXAM_ID	numeric(1),
	EXAM_SCORE int
)
insert into Exam_Results values(10,'LAURA','LYNCH',1,90)
insert into Exam_Results values(10,'LAURA','LYNCH',2,85)
insert into Exam_Results values(11,'GRACE','BROWN',1,78)
insert into Exam_Results values(11,'GRACE','BROWN',2,72)
insert into Exam_Results values(12,'JAY','JACKSON',1,95)
insert into Exam_Results values(12,'JAY','JACKSON',2,92)
insert into Exam_Results values(13,'WILLIAM','BISHOP',1,70)
insert into Exam_Results values(13,'WILLIAM','BISHOP',2,100)
insert into Exam_Results values(14,'CHARLES','PRADA',2,85)

select * from Exam_Results
--1. SQL statement to find the average exam score for EXAM_ID = 1?
select avg(Exam_score) from Exam_Results group by(EXAM_ID) having EXAM_ID=1
--2. SQL statement to find out number of students attended each exam?
select count(STUDENT_ID) as [Number of Students],EXAM_ID from Exam_Results group by(EXAM_ID)
--3. SQL statement to find the maximum score of EXAM_ID=1 and FIRST_NAME has the letter “E”.
select Min(Exam_score) from Exam_Results where FIRST_NAME like '%E%' group by(EXAM_ID) having EXAM_ID=1