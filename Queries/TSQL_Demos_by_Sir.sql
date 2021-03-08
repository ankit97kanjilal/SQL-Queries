--defining a stored procedure
create procedure sp_AddNumbers
as
--declare a variable
declare @n1 int,@n2 int,@result int
--assign data to variables
select @n1=100
select @n2=200
select @result = @n1 + @n2
--display variables
select @n1 as N1, @n2 as N2 , @result as [Sum]


--how to call or execute stored procedure
exec sp_AddNumbers

--remove procedure
drop procedure sp_addnumbers

--create a stored procedure to calculate the bonus of an employee 
--whose ecode is passed into the procedure. 
--Consider bonus as 10% if salary is greater than 5000 else 20% bonus

create procedure sp_calbonus(@ec int)
as
declare @sal int,@bonus decimal
--retrieve the salary of the employee code
select @sal=salary from employee where ecode=@ec
--calculate bonus
if @sal>5000
	select @bonus=@sal*0.1
else
	select @bonus=@sal*0.2

--display the bonus
select @ec as Ecode,@sal as Salary,@bonus as Bonus


--call the procedure
exec sp_calbonus 101
exec sp_calbonus 102
exec sp_calbonus 105

Note: stored procedure do not return anything, they just perform the task

User-defined functions:- used to do some task and return the result out
of the function.
Types of functions:-
1) Scalar-valued functions:- returns scalar type like int,char.varchar, date etc
2) Table-Valued functions:- returns TABLE type i.e. select statement result

alter function fn_getbonus(@salary int) returns numeric(6,2)
as
	begin
	declare @bonus numeric(6,2)
	if @salary >5000
		select @bonus=0.1*@salary
	else
		select @bonus = 0.2*@salary

	return @bonus
	end


--in select statements
select ecode,ename,salary,deptid,dbo.fn_getbonus(salary) as bonus
from employee 

--calling function in another block
declare @salary int,@bonus numeric(6,2)
select @salary=50000
select @bonus=dbo.fn_getbonus(@salary)
select @salary as Salary,@bonus as Bonus


--Table-valued functions : returns TABLE type and in this only
--single SELECT statement is allowed. no variables, constructs etc 
--allowed in it.
create function fn_getemps_by_did(@did int) returns TABLE
as
	return
		(select *
		from employee
		where deptid=@did)

--usage
select * from dbo.fn_getemps_by_did(203)

select *
from dbo.fn_getemps_by_did(202) e
join department d
on(e.deptid=d.deptid)


--=======parameter directions in SP=============
-INPUT:- by default, parameters are passed with INPUT direction.
which means they are passed by-value, after coming out of the 
procedure block, it will not retain its updated value rather it will
carry its orignal value.
-OUTPUT:-it is like passing by-reference, any changed made to it inside
procedure block will be retained after finishing the block in the parent
block(SP).
OUTPUT is used while defining the parameter in SP and while calling 
the SP also.

alter procedure sp_parent
as
	declare @salary int, @bonus int
	select @salary=7000
	exec sp_child @salary,@bonus OUTPUT
	select @salary as Salary,@bonus as Bonus
--================================================

alter procedure sp_child(@salary int,@bonus int OUTPUT)
as
if @salary>5000
	select @bonus=@salary*0.1
else
	select @bonus=@salary*0.2


--call the procedure
exec sp_parent




Ques: Create a stored procedure "sp_getempdetails" which accepts ecode
as a parameter. The procedure should return full details of the
employee along with name,salary and deptid.
Create another block to call this procedure and pass ecode value from
this and display the details of the employee return from the procedure.

--Sol:
create procedure sp_getempdetails(@ec int,@en varchar(20) output,@sal int output,@did int output)
as
select @en=ename,@sal=salary,@did=deptid 
from employee 
where ecode=@ec



---calling
declare @ec int,@en varchar(20),@sal int,@did int
select @ec=103
exec sp_getempdetails @ec,@en output,@sal output,@did output
select @ec as Ecode,@en as Ename,@sal as Salary,@did as Deptid


--CASE statement
1) condition
2) expression

create  procedure sp_calc_bonus_by_did(@ec int)
as
	declare @sal int,@bonus int,@did int
	select @sal=salary,@did=deptid from employee where ecode=@ec
	--condition based CASE syntax
	select @bonus=case
						when @did=201 then @sal*0.1
						when @did=202 then @sal*0.2
						when @did=203 then @sal*0.3
						else 0
				   end
	select @ec as Ecode,@sal as Salary,@did as Deptid,@bonus as Bonus


	--calling
	exec sp_calc_bonus_by_did 101
	exec sp_calc_bonus_by_did 102
	exec sp_calc_bonus_by_did 104






--Looping in TSQL
declare @n int,@p int,@i int 
select @n=5,@i=1
while  @i<=10
begin
	if @i=5
	break
	select @p=@n * @i
	print convert(varchar(5),@n) + 'X' + convert(varchar(2),@i) + '=' + convert(varchar(5),@p)
	select @i=@i + 1
end

--BREAK :- is used to conditionally come out of a loop
--CONTINUE :- is used to skip the remaining statement of the current iteration of the loop and 
--execute the next iteration


Two types of table-values functions:
1) Inline table-valued functions:- only one return statement with a TABLE result is allowed
2) Multiline-Statement Table-Valued Functions(MSTVFs):- these functions can have more than one 
statements and can have begin and end block. It returns a TABLE result which will be populated
by more than one statements.
a) Declare the TABLE structure as variable of TABLE type
b) The variable is populated with multiple DML statements 
c) The final TABLE type variable is returned

syntax=>
--old staffs
--new staffs

create a function and return all those staffs based on category like old or new staff

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
delete from old_staffs
insert into old_staffs values('s1','Ravi','25-MAR-2018','Clerk')
insert into old_staffs values('s2','Ramesh','20-MAR-2018','Analyst')
insert into old_staffs values('s3','Rahul','21-MAR-2018','Manager')
insert into old_staffs values('s4','Raghu','22-MAR-2018','Clerk')


insert into new_staffs values('s5','Suresh','25-MAR-2018','Clerk')
insert into new_staffs values('s6','Santosh','20-MAR-2018','Analyst')
insert into new_staffs values('s7','Suman','21-MAR-2018','Manager')
insert into new_staffs values('s8','Surendra','22-MAR-2018','Clerk')

select * from old_staffs
select * from new_staffs




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


--CTE (Common-Table-Expression)

--select statement----gives result-----some more query on this result

how many departments have their total salary by deptid >1000

with c1(did)
as
(
select deptid
from employee
group by deptid
having sum(salary)>1000
)
select count(did) from c1

go

with c1(did,totalsal)
as
(
	select deptid, sum(salary) as totalsal
	from employee  
	group by deptid
)
select did,totalsal 
from c1 
where totalsal>1000
 


select deptid,sum(salary)
from employee
group by deptid
having sum(salary)>1000





while cond
begin
---statements
continue
---statements
end

--comes out when break is encountered

--Triggers:- These are TSQL block of statements which gets triggered or fired whenever the action
on the database or table is performed on which the trigger is defined.
Usage:-
1) to control some unwanted data manipulations by reverting it back, hence used as data-security
2) to perform some automatic calculation on some operations without doing manually.

Types of triggers:-
1) DDL triggers:- defined for DDL statement, hence also called DATABASE TRIGGERS
2) DML triggers:- define on tables for INSERT,DELETE,UPDATE operations

alter trigger no_delete_table_trig on database
for DROP_TABLE
as
	--statements to be fired when trigger is called
	rollback tran
	print 'trigger fired'
	print 'u cannot drop table in this database,contact ur admin'


	go
create trigger no_create_table_trig on database
for CREATE_TABLE
as
	--statements to be fired when trigger is called
	rollback tran
	print 'trigger fired'
	print 'u cannot create table in this database,contact ur admin'


drop table employee

create table xyz
(
ecode int
)

drop trigger no_create_table_trig on database

drop trigger no_delete_table_trig on database

--2) DML triggers:- for INSERT,DELETE and UPDATE on tables
go
alter trigger trig1_emp
on employee
for delete,insert
as
	rollback
	print 'u cannot delete/insert records from this table'


drop trigger trig1_emp

--Q. Create a trigger which should track the deleted records and it shud
--insert the deleted records in some log table along with when it and who
--deleted it.

create table log_table
(
ecode int,
ename varchar(20),
salary int,
deptid int,
dot datetime
)

alter trigger trig_del_emp
on employee
for delete 
as
	declare @ec int,@en varchar(20),@sal int,@did int
	--1) define a cursor with the result of a query it will store
	declare empcur CURSOR
	for 
	select ecode,ename,salary,deptid 
	from deleted	
	--2) open the cursor
	open empcur
	--3) fetch records one by one from the cursor into local variables
	fetch next from empcur into @ec,@en,@sal,@did
	while @@FETCH_STATUS=0
	begin
		--4) process the local variables
		insert into log_table values(@ec,@en,@sal,@did,getdate())
		--5) repeat the step 3 till all the records are not fetched
		fetch next from empcur into @ec,@en,@sal,@did
	end
	--6) close the cursor
	close empcur
	--7) deallocate the cursor
	deallocate empcur
	print 'records deleted and logged into log table'



--=====================INSTEAD OF TRIGGER===================

create view join_view
as
select e.ecode,e.ename,e.salary,e.deptid,d.dname,d.dhead
from employee e
join department d
on (e.deptid=d.deptid)



create trigger jv_del_trig
on join_view
instead of delete
as
declare @did int

select @did=deptid 
from deleted

delete from employee where deptid=@did
delete from department where deptid=@did



delete from join_view where deptid=202


select * from join_view

select * from employee
select * from department




	insert into employee select ecode,ename,salary,deptid from log_table



	--insert the deleted records into log table
	insert into log_table values(@ec,@en,@sal,@did,getdate())
	print 'records deleted and logged into log table'




	delete from employee where deptid=202

	select * from employee
	select * from log_table

magical or virtual tables in the trigger context block:-
1) deleted:- this table will hold the deleted records
2) inserted:- this table will hold the inserted records

on DELETE trigger, only deleted table is available inside trigger block
on INSERT trigger, only inserted table is available inside trigger block
on UPDATE trigger, both deleted and inserted tables are available; deleted 
table will hold old values of the records and inserted table will hold new 
values of the records.

Triggers should be used intelligently NOT blindly else it may go into recursive
triggers and server may hang or terminate the process.
1) Direct recursive trigger
2) Indirect recursive trigger










Cursor:- These are tempory memory variables which can hold result of a query.
Records from the cursor can be fetched one by one for processing.
Steps:-
1) define a cursor with the result of a query it will store
2) open the cursor
3) fetch records one by one from the cursor into local variables
4) process the local variables
5) repeat the step 3 till all the records are not fetched
6) close the cursor
7) deallocate the cursor


--EXISTS operator is just to check whether a query has result or not
select * 
from employee o
where exists(select * 
			from emp2 i 
			where i.ecode=o.ecode)


select * 
from employee
where exists(select dhead from department where deptid=201)

select * from department
insert into department values(201,'Account',null)


	select * from employee

	delete from employee where deptid=202

	insert into employee values(107,'ggf',7777,201)





User-defined functions:-
Stored Procedures:-
Triggers:-
Cursor:-

--expression based CASE syntax
select ecode,ename,salary,deptid, case deptid
										when 201 then salary*0.1
										when 202 then salary*0.2
										when 203 then salary*0.3
										else 0
								end
from employee



