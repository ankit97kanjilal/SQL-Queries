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