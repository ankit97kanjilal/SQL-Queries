/*--===========TSQL==================
User-defined functions:-If you are returning some value then use function
Stored Procedures:-If you are not returnning any value then go for stored procedures
Triggers:-
*/
use ITCDB
--define a stored-procedure
create procedure sp_AddNumbers
as
--declare variable
declare @n1 int
declare @n2 int, @result int
--assign data to variables
--by select(used for display purpose and assignment also) or set
select @n1=100
select @n2=200
select @result = @n1 + @n2
--As we assign a value to variable we need to use select
--display variables(only for this management studio)
select @n1 as N1, @n2 as N2, @result as [Sum]
--we can store the variable in database by using TSQL, we can use them in future
--Now how to call or execute stored procedure
exec sp_AddNumbers
/*If you want to update the store procedure..
just alter the sp_AddNumbers........ ====>	Update the logic
and if you want to delete or remove procedure then....
drop procedure sp_AddNumbers.....*/

--create a stored procedure to calculate the bonus of the employee whose ecode is passed into the procedure... 
--Then consider bonus as 10% if salary is greater than 5000 else 20% bonus.
--How to pass parameter

create procedure sp_CalBonus(@ec int)
as
--declare variable
declare @sal int
declare @bonus decimal
--retrive the salary of the employee
select @sal=salary from employee where ecode=@ec
--calculate bonus
if @sal>5000
	select @bonus=@sal*0.1
else
	select @bonus=@sal*0.2
--display the bonus
select @ec as Ecode, @sal as Salary, @bonus as Bonus
--call the procedure
exec sp_CalBonus 101

drop procedure sp_CalBonus
select * from employee

--NOTE:-stored procedure do not return anything, they only perform the task
--User-defined function:-used to do some task and return the result out of the function

/*
create function fn_getbonus(@salary int) returns decimal
as
	begin
	declare @bonus decimal
	if @salary > 500
		select @bonus = 0.1*@salary
	else
		select @bonus = 0.2*@salary

	return @bonus
	end
*/
--here by altering command the function is getting updated
alter function fn_getbonus(@salary int) returns numeric(6,2)
as
	begin
	declare @bonus numeric(6,2)
	if @salary > 500
		select @bonus = 0.1*@salary
	else
		select @bonus = 0.2*@salary

	return @bonus
	end

--in select statement
select ecode,ename,salary,deptid,dbo.fn_getbonus(salary) as bonus from employee
--calling function in another block
declare @salary int, @bonus numeric(6,2)
select @salary=50564
select @bonus=dbo.fn_getbonus(@salary)
select @salary as Salary, @bonus as Bonus

--Table-valued functions : return table type and in this only single select statement is allowed, no variables
--no constructors etc allowed in it(and no begin and end too.......)
create function fn_getemps_by_did(@did int) returns Table
as
	return
		(select * 
		from employee
		where deptid=@did)
--usage
select * from dbo.fn_getemps_by_did(202)

--SQL CLR Offline study............

--==========parameter direction in SP==========
--INPUT:-by default, parametets are passed with INPUT Direction.
--which means they are passed by-value, after coming out of the procedure block
--,it will not retain its updated value rather it will carry its original value.

--OUTPUT:-It is like passing by referrence, any changed made to it inside procedure block
--will be retained after finishing the block in the parent block(SP).
--OUTPUT is used while defining the parameter in SP and while calling the SP also.

alter procedure sp_parent
as
	declare @salary int, @bonus int
	select @salary=7000;
	exec sp_child @salary, @bonus OUTPUT --as dependent upon child.. 
	--now by giving OUTPUT we pass the reference
	select @salary as Salary, @bonus as Bonus

--=================================================
--child first create..... As Parent depends on it

alter procedure sp_child(@salary int, @bonus int OUTPUT)
as
if @salary>5000
	select @bonus=0.1*@salary
else
	select @bonus=0.2*@salary

--call the procedure
exec sp_parent
--(not reflecting the changes made to the bonus).. So we need to pass by reference

--==========================Practice Questions======================================
--Qs.1)Create a stored procedure sp_geteempdetails which accepts ecode as parameter.
--The procedure should return full details of the employee along with name, salary and deptid.
--Create another block to call this procedure and pass ecode value from this and display the
--details of the employee from the procedure.

create function fn_getempdetails(@id int) returns Table
as
	return
		(select * 
		from employee
		where ecode=@id)

--getting the emp-details from employee
select * from dbo.fn_getempdetails(103)
--another block to get emp-details
declare @ecode int
select @ecode=102
select * from dbo.fn_getempdetails(@ecode)

--updating table values.........
update employee set ename='Ankit' where ecode=102
update employee set ename='Aniket' where ecode=103
update employee set ename='Rankit' where ecode=104
update employee set ename='Roni' where ecode=105
update employee set ename='Raghu' where ecode=106
select * from employee

sp_help employee
--Question answer is something different
alter procedure sp_getempdetails(@ec int,@en varchar(20) OUTPUT,@sal int OUTPUT,@did int OUTPUT)
as
select @en=ename,@sal=salary,@did=deptid from employee where ecode=@ec

--Calling block
declare @ec int, @en varchar(20),@sal int, @did int
select @ec=103
exec sp_getempdetails @ec, @en OUTPUT, @sal OUTPUT, @did OUTPUT
select @ec as Ecode, @en as Ename, @sal as Salary, @did as Dept_ID

select * from employee
--=================Switch case=====================
--CASE statement
--1>Condition 2>Expression

create procedure sp_calc_bonus_by_did(@ec int)
as
	declare @sal int,@bonus int, @did int
	select @sal=salary, @did=deptid from employee where ecode=@ec
	select @bonus=case
						when @did=201 then @sal*0.1
						when @did=202 then @sal*0.2
						when @did=203 then @sal*0.3
						else 0
					end
select @ec as Ecode, @sal as Salary, @did as Deptid , @bonus as Bonus
--call
exec sp_calc_bonus_by_did 102
exec sp_calc_bonus_by_did 103
exec sp_calc_bonus_by_did 110
exec sp_calc_bonus_by_did 105

/*
select @bonus=case
						when @did=201 then @sal*0.1
						when @did=202 then @sal*0.2
						when @did=203 then @sal*0.3
						else 0
					end
It is by condition... One flavor of Switch case
Another one is expression syntax.............

select ecode,ename  
						when @did=201 then @sal*0.1
						when @did=202 then @sal*0.2
						when @did=203 then @sal*0.3
						else 0
					end
*/

--===================another assignment on TSQL===================
/*Ques: create a table "tax" with column ecode and taxamt.
Create a stored procedure which accept ecode as parameter and calculates the tax 
amount of the employee based on the current tax slabs mentioned by the govt.
It should insert the ecode and tax amount in a table "tax" after calculating the tax.

--INCOME SLAB AND TAX RATES FOR F.Y. 2020-21/A.Y 2021-22

--Taxable income						Tax Rate

--Up to Rs. 2,50,000					Nil
--Rs. 2,50,001 to Rs. 5,00,000			5%
--Rs. 5,00,001 to Rs. 10,00,000			20%
--Above Rs. 10,00,000					30%1
*/
create table Tax
(
	ecode int,
	tax_amt int
)
drop table Tax
create procedure sp_getEmp_details_calTax(@ec int)
as
declare @sal int
select @sal=salary from employee where ecode=@ec
declare @annual_income int
select @annual_income=@sal*12
declare @tax int
select @tax=case
				when @annual_income <= 250000 then 0
				when @annual_income > 250000 and @annual_income <500000 then 0.05*@annual_income
				when @annual_income > 500000 and @annual_income <1000000 then 0.2*@annual_income
				when @annual_income > 1000000 then 0.3*@annual_income
			end
insert into Tax values(@ec,@tax)

--calling
exec sp_getEmp_details_calTax 101
exec sp_getEmp_details_calTax 102
exec sp_getEmp_details_calTax 103
exec sp_getEmp_details_calTax 104
exec sp_getEmp_details_calTax 105
exec sp_getEmp_details_calTax 106
exec sp_getEmp_details_calTax 107
exec sp_getEmp_details_calTax 108
exec sp_getEmp_details_calTax 109
exec sp_getEmp_details_calTax 110
exec sp_getEmp_details_calTax 111

select * from Tax

select * from employee
insert into employee values(109,'Aamir Khan',100000,204)
insert into employee values(111,'Salman Khan',80000,203)


--===============================================DATE-08-MARCH-2021==================================================
use ITCDB
--=================Looping in TSQL========================
declare @n int, @p int, @i int
select @n=5, @i=1
while @i <= 10
begin
	select @p = @n * @i
	--select @p
	--print @p	--display as character... Print is only used for character
	--print @n + 'X' + @i + '=' + @p	--Can't be converted to varchar
	print convert(varchar(5),@n) + 'X' + convert(varchar(5),@i) + '=' + convert(varchar(5),@p)
	select @i = @i + 1
end

--Break:-is used to conditionally come out of the loop
--Continue:-is used to skip the remaining task by incrementing the value of counter

/*
Two types of table-values functions:
1) Inline table-valued functions:-only one return statement with TABLE result is allowed
2) Multiline-Statement Table-Values functions(MSTVFs):-


a)Declare the TABLE structure as variable as variable of TABLE type
b)The variable is populated with multiple DML statements
c) The final TABLE type variable is returned

syntax=>
--old staffs
--new staffs

create a function and return all those staffs based on category like old or new staff */

create table old_staffs
(
	staffid varchar(10),
	staffname varchar(20),
	doj date,
	category varchar(20)
)

create table new_staffs
(
	staffid varchar(10),
	staffname varchar(20),
	doj date,
	category varchar(20)
)

insert into old_staffs values('s1','Ravi','26-MAR-2018','Clerk')
insert into old_staffs values('s2','Ramcharan','25-MAR-2018','Analyst')
insert into old_staffs values('s3','Ram','22-MAR-2018','Manager')
insert into old_staffs values('s4','Raghu','20-MAR-2018','Clerk')

insert into new_staffs values('s5','Raaaja','16-MAR-2018','Clerk')
insert into new_staffs values('s6','Rashmi','15-MAR-2018','Analyst')
insert into new_staffs values('s7','Rashford','12-MAR-2018','Manager')
insert into new_staffs values('s8','R.Bir','10-MAR-2018','Clerk')


alter function fn_staffs_mstvf(@category varchar(20))
returns @output TABLE
(
	staffid varchar(10),
	staffname varchar(20),
	doj date,
	category varchar(20)
)
as
begin
insert into @output select staffid,staffname,doj,category from old_staffs where category=@category
insert into @output select staffid,staffname,doj,category from new_staffs where category=@category
UPDATE @output SET staffname=UPPER(staffname)
return
end

select * from fn_staffs_mstvf('Clerk')

--======By using begin and end we can use the thing like a block========

--=========CTE(Common Table Expression)==============
------------------Intermediate Result(By using CTE--Then some more query and get result)-------------
--selec statement----gives result---some more query on this result
--Example
select deptid,COUNT(deptid),SUM(salary) from employee
group by deptid having sum(salary)>1000

--how many departments have their salary by deptid > 1000
with c1(did)--should match column no here
as(select deptid --here how many columns we use
from employee
group by deptid 
having sum(salary)>1000
)
select COUNT(did) as [No of Dept] from c1--using CTE we are simplyfying the query

/*with c0(did,totalsal)
as(
	with c1(did,totalsal)
	as(
		select deptid,sum(salary)										--Look at this later
		from employee
		group by deptid
	)
	select did,totalsal from c1 where totalsal>1000
)
select * from c0*/

--==================================TRIGGERS==============================================
--Triggers: These are TSQL block of statements which gets triggered or fired whenever the action on
--the darabase or table is perfomred on which the trigger is defined.
--Usage:-
--1)To control some unwanted data manipulations by revarting it back, hence used as data-security.
--2)To perform some automatic calculation on some operations without doing manually.
/*	types of triggers:
1. DDL Triggers:-defined for DDL statement, hence also called database triggers
2. DML triggers:-defined on tables for INSERT, DELETE, UPDATE operations
*/
alter trigger no_delete_table_trig on database
for DROP_TABLE
as
	--statements to be fired when triggers is called
	rollback tran --when we try to 
	print 'Trigger fired'
	print 'U cannot drop table in this database, contact ur admin'

drop table employee

create trigger no_create_table_trig on database
for CREATE_TABLE
as
	--statements to be fired when triggers is called
	rollback tran --when we try to 
	print 'Trigger fired'
	print 'U cannot create table in this database, contact ur admin'

drop table employee--The transaction ended in the trigger. The batch has been aborted.
create table xyz
(
	id int,
	roll int		--The transaction ended in the trigger. The batch has been aborted.
)

--dropping the trigger
drop trigger no_create_table_trig on database
drop trigger no_delete_table_trig on database

create table xyz
(
	id int,
	roll int		--Now can be created
)
drop table xyz --Now can be dropped

--==2.DML triggers:
alter trigger trig1_emp
on employee
for delete,insert
as
	rollback
	print 'U cannot delete/insert records from this table'

select * from employee where ecode=101
delete from employee where ecode=101
select * from employee
insert into employee values(115,'Ravicharan',1050,206)
drop trigger trig1_emp

--Qs..

create table log_table
(
	ecode int,
	ename varchar(20),
	salary int,
	deptid int,
	dot datetime
)

create trigger trig_del_emp
on employee
for delete
as
--trigger context block
	declare @ec int, @en varchar(20), @sal int, @did int
	select @ec=ecode,@en=ename,@sal=salary,@did=deptid from deleted
	--insert the deleted records into log table
	insert into log_table values(@ec,@en,@sal,@did,getdate())
	print 'record deleted and logged into log table'
--context block ends here	

/*magical or virtual table in the trigger context block:-
1)deleted:- will hold the deleted records
2)inserted:- will hold the inserted records */

select * from employee
delete from employee where ecode=106
select * from log_table
delete from employee where deptid=202--more than one record deleted but one record is inserted

--for storing multiple values we need cursors...
--Temporary memory variable
--======================Cursors========================
--Cursor:-These are temporary memory variables which can hold result of a query.
--Records from the cursor can be fetched one by one for processing.
/*steps:
1) define a cursor with the result of a query it will store
2) Open the cursor
3) Fetch records one by one from the cursor into a local variables
4) Process the local variables
5) repeat the step 3 till all the records are not fetched
6) close the cursor 
7) deallocate the cursor */

create trigger trig_del_emp_using_cursor
on employee
for delete
as
	 --1) Cursor declaration
	declare @ec int, @en varchar(20), @sal int, @did int
	declare empcur CURSOR
	for select ecode,ename,salary,deptid 
	from deleted
	--2) Open the cursor
	open empcur
	--3) Fetch records one by one from the cursor into a local variables
	fetch empcur into @ec,@en,@sal,@did

	while @@FETCH_STATUS=0 --means records has been fetched successfully, if unsuccessful then return -1
	begin
		--4) Process the local variables
		insert into log_table values(@ec,@en,@sal,@did,getdate())
		--5) repeat the step 3 till all the records are not fetched
		fetch next from empcur into @ec,@en,@sal,@did
	end
	--6) close the cursor 
	close empcur
	--7) deallocate the cursor 
	deallocate empcur
	print 'record deleted and logged into log table'

select * from employee
select * from log_table
select * from employee where deptid=202
delete from employee where deptid=202

--=========Inserted table come into picture during update==============
/*
on DELETE trigger, only deleted table is available inside trigger block
on INSERT trigger, only inserted table is available inside trigger block
on UPDATE trigger, both deleted and inserted tables are available inside trigger block
deleted table will hold old value records and inserted table will hold new values of the record. 
Don't use unnecessary triggers...
triggers should be used intelligently NOT blindly else it may go into recursive triggers and server may hang
*/
select * from department
select * from employee
insert into employee values(112,'Arpita',1512,210)
alter view join_view
as
select e.ecode,e.ename,e.salary,e.deptid,d.dname,d.dhead 
from employee e 
join department d 
on (e.deptid=d.deptid)

select * from join_view


--EXISTS operator---->for corelated query
--operator is just to check query has result or not
select * from employee o where exists(select * from employee i where i.ecode=o.ecode)
select * from employee where exists(select * from department where deptid=203)
select * from employee where exists(select * from department where deptid=2038)
select * from employee where exists (null)