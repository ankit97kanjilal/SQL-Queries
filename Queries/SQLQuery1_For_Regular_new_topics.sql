create database ITCDB
--single line comment
/*
Multiple line
*/
use ITCDB
--creating table
create table customer
(
	--custid numeric(5,2)
	custid int,
	--custnam char(10) means fixed number of character.. if variable size data then varchar
	custname varchar(25),
	city varchar(20)
)

create table employee
(
	ecode int primary key,
	ename varchar(20),
	salary int,
	deptid int
)

--inserting record into the table
insert into customer values(1001, 'Ankit', 'Delhi')
insert into customer values(1001, 'Aman', 'Kolkata')
insert into customer values(1001, 'Amartya', 'Patna')
insert into customer values(1001, 'Akhil', 'Goa')
insert into customer values(1001, 'Ankita', 'Dehradoon')
insert into customer values(1001, 'Animesh', 'Arunachal')

--insert record with random column sequence
insert into customer(custid,city,custname) values(1006, 'Jaipur', 'Raman')

--see your record
select * from customer

--inserting into fewer column
insert into customer(custid,custname) values(1007, 'Rimo')
insert into customer values(1008, 'Ritesh', null)

--Query
--select the entire table from table table
select * from customer

--fewer column
select custid, custname from customer

--fewer records based on some conditions
select * from customer where custid=1001

select * from customer where custid>1003

insert into employee values(101,'Ravi',1111,201)
insert into employee values(102,'Ravi',2222,202)
insert into employee values(110,'Raasas',2758,202)
insert into employee values(103,'Ravi',3333,203)
insert into employee values(104,'Ravi',4444,204)
insert into employee values(105,'Ravi',5555,205)
insert into employee values(106,'Ram',5555,205)
insert into employee values(107,'Ramisss',null,205)


--displaying calculated columns or expression(No column name)
select *,0.1*salary from employee

--giving alias for the columns
select *,0.1*salary as Bonus from employee
select * from employee
--alias
select ecode as Empcode from employee

--where space should be accepted
select ecode "Emp Code", ename as [Emp Name] from employee

--and or conditions are there

--Null is always used with IS
--selecting records based on null value
select * from customer where city is null

select * from employee order by deptid desc, ecode
select * from employee order by salary desc

--grouping of records
select deptid, sum(salary) as TotalSalary,-------2
MAX(salary) as MaxSalary,
MIN(salary) as MinSalary,
AVG(isnull(salary,0)) as AvgSalary,----whenever salary is null is to be treated as zero salary
COUNT(isnull(salary,0)) as TotalEmp
from employee
group by deptid-----1
having sum(salary)>3000------3
order by SUM(salary) desc----------4

--Group by----->Having---->Order by

--deleting record
--delete from employee  ----->delete all records by this command
update employee set salary = salary + 1000 --multiple rows update
update employee set salary=1111, deptid=202 where ecode=101

---=========================Altering Table Structure===========================-------
/*create table customer ------------Error already have this table
(
	custid int,
	custname varchar(15),
	city varchar(10),
	phno char(10)
)
*/

alter table customer add phno char(10)
alter table customer drop column phno

select count(*),Max(salary) from employee

alter table customer add phno char(10)
--==increase the size of a column
alter table customer alter column phno char(12)

select * from employee
select * from customer
--rename the column
sp_rename 'customer.custname','Cname'
sp_rename 'customer.Cname','custname'

--to see the structure of the table
sp_help customer

--how to add/remove constraint when table already existing
create table test
(
	ecode int,
	ename varchar(20),
	salary int,
	deptid int
)

--add primary key in the existing table
alter table test alter column ecode int not null
alter table test add constraint pk1 primary key(ecode) --first we need to add not null

--add foreign key constraint on existing table
alter table test add constraint fk1 foreign key(deptid) references employee(deptid)

--remove constraints from the table
alter table test drop constraint pk1

--disable the enable/disable constraint



--=================================Nested Queries======================
select * from employee
select * from employee where deptid=202

--Find the employee details working in the dept of the employee having ecode = 101
select * from employee where deptid=(select deptid from employee where ecode=101)

--Find the employee details working in the dept of the employee having ecode = 101 or 104 or 105
select * from employee where deptid IN (select deptid from employee where ecode=101 or ecode=104 or ecode=105)

--IN:- to compare either from the set
--<ALL:- less than the minimum from the set
-->ALL:- greater than the maximum from the set
--<ANY:- less than the maximum from the set
-->ANY:- greater than the minimum

--QS. Employees whose salary is greater than avg salary
select * from employee where
	salary > (select avg(salary) from employee)

--======================Corelated Query===========================
--QS. Employees whose salary is greater than avg salary of all employees of his dept
select * from employee
select * from employee e1 where e1.salary >ALL (select avg(e2.salary) from employee e2 where e2.deptid = e1.deptid)

--===========================JOINS=================================
--Joins are used to consolidate all the data or information which are scattered across multiple tables due to 
--normalization process to avoid redundancy.
/* types:
1>Inner Join:-matching records from the table based on condition
2>Outer Join:-matched as well as unmatched records also
a>Left Outer Join:-
b>Right Outer Join:-
c>Full Outer Join:-
*/
create table department
(
	deptid int primary key,
	dname varchar(20),
	dhead int
)
insert into department values(202,'Account',107)
insert into department values(203,'Sales',105)
insert into department values(205,'Finance',104)
insert into department values(210,'Management',110)

select * from department
select * from employee

select * from employee join department
	on employee.deptid=department.deptid

--Left part is employee table... So rest additional info about employee will be reflected
select * from employee left outer join department
	on employee.deptid=department.deptid

--Inner join
select * from employee inner join department
	on employee.deptid=department.deptid

--Right part is department table... So if any additional info in department.. that will be reflected
select * from employee right outer join department
	on employee.deptid=department.deptid

--Full outer join.. From both side additional info is reflected
select * from employee full outer join department
	on employee.deptid=department.deptid

--Self Join:-a special case of inner join when a table is joined with itself
--String pattern comparison.... =====Like operator... '%s%s%es' -- contains two ss, and end with es

select * from employee

create view emp_v1 as
	select ecode,ename
	from employee

select * from emp_v1

--DML thru views
insert into emp_v1 values(108,'Ramnath')
select * from employee

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
1)deleted:-
2)inserted:-*/
select * from employee
delete from employee where ecode=106
select * from log_table
delete from employee where deptid=202--more than one record deleted but one record is inserted