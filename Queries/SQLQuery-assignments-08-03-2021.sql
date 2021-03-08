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

create procedure sp_expense_tracker_t1(@ex_id int,@amt int,@dd date)
as
	declare @total_expenses int,@sal int
	select @sal=50000
	insert into Expenses_tab values(@ex_id,@amt,@dd)
	select @total_expenses=Sum(amount) from Expenses_tab
	if @total_expenses <= @sal*0.5
	begin
		select @sal as Salary, @total_expenses as Total, @amt as Amout,@ex_id as Expend_id
		print 'All the expenditure is inserted into the table'
	end
	else
	begin
		delete from Expenses_tab where expense_id=@ex_id
		print 'Expenditure exceeds the half of salary.. So the record is deleted'
	end

--calling the procedure
exec sp_expense_tracker_t1 1, 10000, '02-MAR-2021'
exec sp_expense_tracker_t1 2, 10000, '02-MAR-2021'
exec sp_expense_tracker_t1 3, 2500, '02-MAR-2021'	
exec sp_expense_tracker_t1 4, 2500, '09-MAR-2021'	--========In the limit upto this exp
exec sp_expense_tracker_t1 5, 100, '09-MAR-2021'	--===Here Expenditure Crosses the 50% of Salary

select * from employee where ecode=103
select * from Expenses_tab
drop procedure sp_expense_tracker_t1



--=================================Assignment 2======================================
/*
SQL Assignments on Triggers:-
Q1. There is a table "project" having followingcolumns: 
    projectno, budget'
Create another table audit_budget( project no,user name, time, budget old, budget new), 
which has to store all modifications of the budget column of the "project" table. Create a 
trigger called "modify budget", which should record all the modifications of the budget 
column.
For e.g. if the current record of a project is: 1001, 250000 and if this project budget is updated 
with 350000 then trigger should record this changes in audit budget table as:
projectno	username	time	budget old		budget new
1001		'ravi'		«time»   250000			350000


Q2.Create a trigger called "total...budget", which should test every modification of the budgets 
and execute only such UPDATE statements where the modification does not increase the sum 
of all budgets by more than 50%. Otherwise the UPDATE statement should be rolled back using 
the ROLLBACK TRANSACTION statement.
*/

--Qs.1 Answer===============>
create table project
(
	project_no int,
	budget int
)
select * from project
insert into project values(101,150000)
insert into project values(102,250000)
insert into project values(103,350000)
insert into project values(104,450000)
insert into project values(105,550000)
insert into project values(106,650000)

create table audit_budget
(	project_no int,
	username varchar(20),
	[Date & time] datetime, 
	budget_old int,
	budget_new int
)

--first trigger
create trigger modify_budget
on project
for update
as
	declare @pn int, @budget_old int, @budget_new int,@username varchar(20)
	select @pn=project_no,@budget_old=budget from deleted
	select @budget_new=budget from inserted
	select @username=SYSTEM_USER
	--insert the updated records into audit table
	insert into audit_budget values(@pn,@username,getdate(),@budget_old,@budget_new)
	print 'record updated and logged into audit budget table'

--another trigger
create trigger total_budget
on project
for update
as
	declare @old_sum numeric(10,2),@new_sum numeric(10,2)
	select @new_sum=sum(budget) from Project
	declare @ins numeric(10,2),@del numeric(10,2)
	select @ins=budget from inserted
	select @del=budget from deleted
	select @old_sum = ( @new_sum + @del - @ins )
	if( @new_sum - @old_sum ) > ( 0.5 * @old_sum )
	begin
		print'Threshold value exceeded.Cannot update budget'
		rollback tran
	end
	else
		print 'Updation Successful'

----------------------------------------------------
update project set budget=500000 where project_no=104
update project set budget=450000 where project_no=103

select * from project
select * from audit_budget

drop table audit_budget
drop table project

drop trigger modify_budget
select SYSTEM_USER
select ORIGINAL_LOGIN()

--===========================Last Assignment of SQL========================================
/*T-SQL Practice Question
Consider the following 3 tables in database for employees leave management:
 
•	EMPLOYEE table stores records of employees
•	LEAVES table stores available leaves of the employees
•	LEAVESAPPLIED table stored the record of leave request done by the employee
Tasks to be done:
 1) Insert employee code and number of leaves requested in the table LEAVESAPPLIED. It should check whether number of leaves applied by the employee is available or not from the table LEAVES. 
2) If it is more than the available leaves in database, it should be rejected otherwise it should be approved. 
3) Once it is approved it should automatically deduct the no of leaves applied from the LEAVES table for the employee. 
4) Status column in the table LEAVESAPPLIED should also be updated as ‘APPROVED’ or ‘REJECTED’ accordingly.
[Hint: use trigger for this operations]
*/
use master

create table Employee
(
	Ecode int primary key,
	Ename varchar,
	Salary int,
	Deptid int
)

create table Leaves
(
	Ecode int Foreign key references Employee(Ecode),
	Available_leaves int
)

create table LeavesApplied
(
	Ecode int Foreign key to Employee(Ecode),
	NoOfLeavesApplied int,
	[Status] varchar(10) CHECK constraints with acceptable values 'APPROVED' or 'REJECTED' 
)