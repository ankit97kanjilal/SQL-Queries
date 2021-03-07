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
--4. SQL statement to find the maximum EXAM_SCORE for EXAM_ID=1 which is greater than the average   
	--marks of that EXAM_ID. For e.g. for EXAM_ID=1 available scores are 90,78,95,70 whose average is  
	--(90+78+95+70)/4=83.25. So records selected will be 90 and 95 as both are >83.25. Out of these two 
	--95 is the final score as it is maximum
select Max(Exam_score) from Exam_Results where Exam_id=1 and 
	Exam_score>(select Avg(EXAM_SCORE) from Exam_Results group by(EXAM_ID) having EXAM_ID=1)


--====================== QS.2 of Assignment 6 ==============================
create table USERS	
(	
	userid numeric(2),
	username varchar(20),
	contactnumber char(10)
)
create table VISITORS	
(
	userid numeric(2),
	[date] date,
	task varchar(10)
)

--========================= Qs.3 of Assignment 6 ==============================
--Based on TSQL
/*
Question3:	T-SQL Assignments
Assume a person salary is 50,000. He maintains a table “tbl_expense” to store the daily expense records with 
columns expense_id, amount, date. Whenever he does any expense, a record is added.

1. Create a stored procedure which will accept his expense amount and insert a record in the expense table 
with following details: expense_id, amount, date.

2. Note that the stored procedure should monitor his expenses and reject adding those expenses which make
his total sum of expenses (including the current expense being added) more than 50% of his salary.
*/
use ITCDB
create table Expenses_tab
(
	expense_id int,
	amount int,
	[date] date
)
drop table Expenses_tab
alter procedure sp_expense_tracker(@ec int,@ex_id int,@amt int,@dd date)
as
	declare @sal int,@total_expenses int
	select @sal=salary from employee where ecode=@ec
	insert into Expenses_tab values(@ex_id,@amt,@dd)
	select @total_expenses=Sum(amount) from Expenses_tab
	if @total_expenses < @sal*0.5
		select @sal as Salary, @total_expenses as Total, @amt as Amout,@ex_id as Expend_id
	else
		delete from Expenses_tab where expense_id=@ex_id

--calling
exec sp_expense_tracker 103, 1, 599, '02-MAR-2021'
exec sp_expense_tracker 103, 2, 1000, '02-MAR-2021'
exec sp_expense_tracker 103, 3, 559, '02-MAR-2021'	--========In the limit of 4333/2
exec sp_expense_tracker 103, 4, 100, '09-MAR-2021'	--===Here Expenditure Crosses the 50% of Salary

select * from employee where ecode=103
select * from Expenses_tab
drop procedure sp_expense_tracker