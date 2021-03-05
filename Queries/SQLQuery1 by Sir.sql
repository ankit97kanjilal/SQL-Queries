create database ITCDB
use ITCDB

--creating table
create table customer
(
	custid int,
	custname varchar(10),
	city varchar(20)
)

drop table employee

create table employee
(
ecode int primary key,
ename varchar(20),
salary int,
deptid int,
enter_date date
)

create table test
(
enterdare date
)

insert into test values('25-MAR-2021')
select * from test

insert into employee values(101,'Ravi',1111,201,'25-MAR-2021')
insert into employee values(102,'Raman',2222,202)
insert into employee values(103,'Suresh',3333,202)
insert into employee values(104,'Rahul',4444,203)
insert into employee values(105,'Rohit',5555,201)



--inserting record into table
insert into customer values(1001,'Ravi','Delhi')

insert into customer values(1002,'Raman','HYD')
insert into customer values(1003,'Suresh','MYSORE')
insert into customer values(1004,'Rahul','Bangalore')
insert into customer values(1005,'Rohit','Chennai')

--insert record with random column sequence
insert into customer(custid,city,custname) 
			values(1008,'Jaipur','Raghu')

--inserting into fewer columns
insert into customer(custid,custname) values(1007,'Ritesh')
insert into customer values(1008,'Ritesh',null)

select * from customer

--selecting fewer columns
select custid,custname from customer

--select fewer records based on some condition
select * from customer where custid>1003 and city='Bangalore'

--displaying calculated columns or expression
select *,0.1*salary from employee

--giving alias for the columns
select ecode EmpCode,ename as [Emp Name],salary,deptid,0.1*salary as Bonus 
from employee

--selecting records based on NULL values
select * from customer where city is null 

--select distinct records
select distinct custid from customer

--sort the records
select * from employee order by deptid desc,ecode desc


--group results
select sum(salary) as TotalSalary,
MAX(salary) as MaxSalary,
Min(salary) as MinSalary,
Avg(salary) as AvgSalary,
COUNT(salary) as TotalNoOfEmps 
from employee

--grouping of records
select deptid, sum(salary) as TotalSalary, ------2
MAX(salary) as MaxSalary,
Min(salary) as MinSalary,
Avg(isnull(salary,0)) as AvgSalary,
COUNT(isnull(salary,0)) as TotalNoOfEmps 
from employee
group by deptid---------1
--having avg(salary)>3000-------3
order by avg(isnull(salary,0))-------4

--null is not empty string not 0.....it is just that there is no data

--deleting all records 
delete from employee 

--conditional delete
delete from employee where ecode=105

--update the records unconditional
update employee set salary = salary + 1000 

--conditional update
update employee 
set salary = salary + 1000, deptid=202
where ecode = 101

select * from employee


--===================Altering table structure============
--1) add new column to an existing table
alter table customer add phno char(10)

--2) remove an existing column
alter table customer drop column phno

--3) increase the size of a column
alter table customer alter column custname varchar(10)

--4) rename a column
sp_rename 'customer.Cname','custname'


--to see structure of a table
sp_help employee


select * from customer

=================Contraints=======================
Rules and restrictions on data in database is done by these constraints so that correct data will be present in database at any point of time.
Types of constraints:-
1) PRIMARY KEY:- this is to make the record unique in the table
--it does not accept duplicate value
--it does not accept null value
--there can be only one primary key per table

2) CHECK constraint:- domain value contraints. Only acceptable values are allowed
in the column.
drop table test
create table test
(
ecode int primary key,
ename varchar(20),
salary int check(salary between 1000 and 20000),
city varchar(10) check(city IN ('BLR','HYD','DLI')),
gender char(1) check(gender in ('M','F')),
doj date default convert(date,'01-02-2020',110)
)

3) DEFAULT constraint:- this is specify some default value to the column if not provided

insert into test values(101,'AAA',15000,'BLR','M',default)
insert into test values(102,'BBB',16000,'HYD','M','25-JAN-2020')
insert into test(ecode,ename,salary,city,gender) values(103,'CCC',15000,'BLR','M')
select * from test

4) UNIQUE constraint:- this is used for making a column value unique.
--it accepts one NULL value
--it can be more than one per table
drop table test

create table test
(
ecode int primary key,
ename varchar(20) not null,
salary int,
emailid varchar(25) unique,
phno char(10) unique
)

insert into test values(101,null,1111,'abc@gmail','9986017462')
select * from test


5) FOREIGN KEY constraint:- Referential integrity constraint: 
It accepts the value only if it''s key value is present somewhere else in 
some other table or same table.
Parent table must have the column as a primary key which is referred as as foreign key
in the child table.
create table parent
(
	deptid int primary key,
	dname varchar(20),
	dhead int
)
create table child
(
	ecode int primary key,
	ename varchar(20),
	salary int,
	deptid int 	
	constraint fk1 foreign key(deptid) 
			references parent(deptid) on delete cascade
)

drop table child

--INSERT rule:- we cannot insert the value in child table if no key value is present 
--DELETE rule:- we cannot delete from parent table if its child records are present

6) NOT NULL/NULL:- it is used to specify mandatory or optional value for the column

		ename varchar(20) not null


--How to add/remove constraint when table already existing
drop table test

create table test
(
ecode int,
ename varchar(20),
salary int,
deptid int
)

--add primary key on existing table
alter table test alter column ecode int not null
alter table test add constraint pk1 primary key(ecode)

--add foreign key on existing table
alter table child 
		add constraint fk1 foreign key(deptid) 
								references parent(deptid)

--remove constraints from the table
alter table test drop constraint pk1

--disable the enable/disable constraint
--This action applies only to foreign key and check constraints.
alter table child nocheck constraint fk1  


create table student
(
classid int,
rollno int,
sname varchar(20)
constraint pk_stud primary key(classid,rollno)
)
create table test
(
	ecode int primary key,
	ename varchar(20)
)

pre-defined functions:
1) numeric
2) character functions
3) date functions
4) group functions: avg,sum,max,min,count

select LOG10(10)
select SIN(90),cos(90),tan(90),ATAN

select round(12.66,0) as [round]
select FLOOR(12.23) as [floor] --not more than the number while rounding
select CEILING(12.23) as [ceiling] --not lesser than the number while rounding

select upper('eee'), lower('Welcome')
select LEN('welcome')
select left('welcome',3),right('welcome',3),SUBSTRING('welcome',3,2)

select CONCAT('hello ','world')

--convert the first character of a string into capital letter
welcome----->hello

select concat(upper(left('welcome',1)),right('welcome',len('welcome')-1))

date functions:-
select getdate()
select convert(date,'25-MAR-2021',110)
select year(getdate()),month(getdate()),DAY(getdate())
--select date parts
select DATEPART(YYYY,getdate()),DATEPART(MM,getdate()),DATEPART(DD,getdate()),DATEPART(HH,getdate())
,DATEPART(MI,getdate()),DATEPART(SS,getdate())

--adding date parts
select DATEADD(dd,2,getdate())

--subtracting two dates
select DATEDIFF(MM,getdate(),'25-MAR-2025')















drop table test



select * from test


create table student
(
classid int,
rollno int,
sname varchar(20)
constraint pk_stud primary key(classid,rollno)
)
insert into student values(1,101,'aaa')
insert into student values(1,102,'bbb')
insert into student values(2,102,'ddd')

select * from student





select convert(varchar(20),getdate(),100) as "100"
select convert(varchar(20),getdate(),101) as "101"
select convert(varchar(20),getdate(),102) as "102"
select convert(varchar(20),getdate(),103) as "103"
select convert(varchar(20),getdate(),104) as "104"
select convert(varchar(20),getdate(),105) as "105"
select convert(varchar(20),getdate(),106) as "106"
select convert(varchar(20),getdate(),107) as "107"
select convert(varchar(20),getdate(),108) as "108"
select convert(varchar(20),getdate(),109) as "109"
select convert(varchar(20),getdate(),110) as "110"
select convert(varchar(20),getdate(),111) as "111"
select convert(varchar(20),getdate(),112) as "112"
select convert(varchar(20),getdate(),113) as "113"
select convert(varchar(20),getdate(),114) as "114"

select UPPER('aaa'),LOWER('AAA')

drop table test

create table test
(
ename varchar(20) check(ename =upper(ename) collate latin1_general_cs_as)
)

insert into test values('ravi')

select * from test