/* ASSIGNMENT-3
1.	Create the following Tables and insert the shown data ( This table will be used in the subsequent Lab sessions )

Department					

Dept_no	Dept_name	location
d1		Research	Dallas
d2		Accounting	Seattle
d3		Marketing	Dallas

Employee

emp_no	emp_fname	emp_lname	dept_no
25348	Matthew		Smith		d3
10102	Ann			Jones		d3
18316	John		Barrimore	d1
29346	James		James		d2

Project

project_no	project_name	Budget
p1			Apollo			120000
p2			Gemini			95000
p3			Mercury			185600

*/
use MyDb

create table Department
(
	Dept_no	varchar(2),
	Dept_name varchar(15),
	[location] varchar(15)
)
insert into Department values('d1','Research','Dallas')
insert into Department values('d2','Accounting','Seattle')
insert into Department values('d3','Marketing','Dallas')

create table Employee
(
	emp_no numeric(5),
	emp_fname varchar(10),
	emp_lname varchar(10),
	dept_no varchar(2)
)
insert into Employee values(25348,'Matthew','Smith','d3')
insert into Employee values(10102,'Ann','Jones','d3')
insert into Employee values(18316,'John','Barrimore','d1')
insert into Employee values(29346,'James','James','d2')

create table Project
(
	project_no varchar(2),
	project_name varchar(10),
	Budget int
)
insert into Project values('p1','Apollo',120000)
insert into Project values('p2','Gemini',95000)
insert into Project values('p3','Mercury',185600)

create table Works_on
(
	emp_no numeric(5),
	project_no varchar(2),
	job varchar(10),
	enter_date date
)
insert into Works_on values(10102,'p1','Analyst','04-Jan-1998')
insert into Works_on values(10102,'p3','Manager','01-Jan-1999')
insert into Works_on values(25348,'p2','Clerk','15-Feb-1998')
insert into Works_on values(18316,'p2',null,'15-Feb-1998')
insert into Works_on values(29346,'p2',null,'15-Dec-1997')
insert into Works_on values(29346,'p1','Clerk','04-Jan-1998')
insert into Works_on values(10102,'p1','Clerk','01-Jan-1999')

select * from Department
select * from Employee
select * from Project
select * from Works_on

--Simple Queries
--1.	Get the employee numbers for all clerks
select emp_no from Employee

--2.	Get the employee numbers for employees working in project p2, and having employee numbers 
	--smaller than 26000. Solve this problem with two different but equivalent SELECT statements.
select emp_no from Works_on where project_no='p2' and emp_no<26000

--3.	Get the employee numbers for all employees who didn’t enter their project in 1998.
select * from Works_on
select emp_no from Works_on where DATEPART(yyyy,enter_date) != 1998 ---OR
select emp_no from WORKS_ON where enter_date not like '1998%'

--4.	Get the employee numbers for all employees who have a  leading job( i.e., Analyst or Manager) in project p1
select emp_no from Works_on where job in ('Analyst','Manager')

--5.	Get the enter dates for all employees in project p2 whose jobs have not been determined yet.
select * from Works_on
select enter_date from Works_on where job is null

--6.	Get the employee numbers and last names of all employees whose first names contain two letter t’s.
select * from Employee
select emp_no,emp_fname,emp_lname from Employee where emp_fname like '%t%t%'

--7.	Get the employee numbers and first names of all employees whose last names have a letter o or a
	-- as the second character and end with the letters es.
select * from Employee
select emp_no, emp_fname, emp_lname from Employee where emp_lname like '_a%es' or emp_lname like '_o%es'

--8.	Get the employee numbers of all employees whose departments are located in Seattle.
select * from Employee
select * from Department
select emp_no from Employee where dept_no=(select dept_no from Department where [location]='Seattle') 

--9.	Group all departments using their locations.
select [location],COUNT(dept_no) as [No of Dept] from Department group by [location]

--10.	Find the biggest employee number.
select Max(emp_no) from Employee

--11.	Get the jobs that are done by more than two employees.
select * from Works_on
select job from Works_on group by job having COUNT(job)>2

--12.	Find the employee numbers of all employees who are clerks or work for department d3.
select * from Employee
select * from Works_on
select emp_no from Employee where Dept_no='d3' union select emp_no from Works_on where job='clerk'

--Complex Queries
--1.	Get the employee numbers and job titles of all employees working on project Gemini
select * from Department
select * from Employee
select * from Project
select * from Works_on
select emp_no,job from Works_on where project_no = (select project_no from Project where project_name='gemini')

--2.	Get the first and last names of all employees that work for departments Research or Accounting.
select * from Department
select * from Employee
/*
select emp_fname,emp_lname from Employee where
	dept_no=(select dept_no from Department where Dept_name='research' or Dept_name='accounting')
--Subquery returned more than 1 value. This is not permitted when the subquery 
--follows =, !=, <, <= , >, >= or when the subquery is used as an expression.	
--Then use IN operator for multiple values
*/
select emp_fname,emp_lname from Employee where
	dept_no IN (select dept_no from Department where Dept_name='research' or Dept_name='accounting')
	--OR
select emp_fname, emp_lname from Employee e inner join Department d 
	on e.dept_no=d.Dept_no where d.Dept_name='research' or d.Dept_name='accounting'

--3.	Get the enter dates of all clerks that belong to the department d1.
select * from Works_on
select * from Department
select * from Employee
select w.enter_date from Works_on w inner join Employee e on w.emp_no=e.emp_no where e.dept_no='d1' and w.job='clerk'

--4.	Get the names of projects on which two or more clerks are working.
select * from Works_on
select * from Project
select project_name from Project where project_no IN
	(select project_no from Works_on where job='Clerk' group by project_no having COUNT(project_no)>=2)

--5.	Get the first and last names of the employees that are manager and that work on project Mercury.
select * from Works_on
select * from Project
select * from Employee
select emp_fname,emp_lname from Employee where emp_no IN 
	(select emp_no from Works_on where job='Manager' and project_no IN
		(select project_no from Project where project_name='Mercury'))

--6.	Get the first and last names of all employees who entered the project at the same time as at 
	--least one other employee.
select * from Works_on
select * from Employee
select emp_fname,emp_lname from Employee where emp_no IN
	(select distinct emp_no from Works_on where enter_date IN
		(select enter_date from Works_on group by enter_date having COUNT(enter_date)>=2))

--7.	Get the employee numbers of the employees living in the same location and belonging to the same 
	--department as one another.
select * from Employee
select * from Department

--8.	Get the employee numbers of all employees belonging to the Marketing department.
select * from Department
select * from Employee
select emp_no from Employee inner join Department 
	on Department.Dept_no=Employee.dept_no
		where Dept_name='Marketing'