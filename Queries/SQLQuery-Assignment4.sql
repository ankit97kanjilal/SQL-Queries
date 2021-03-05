--================NEW ASSIGNMENT==================
--=================Assignment-4===================
--SQL Assignments on Nested query and Joins:-

--==========Student and Teacher problem============
use MyDb
create table Student
(
	fname varchar(20),
	lname varchar(20),
	age int
)
create table Teacher
(
	fname varchar(20),
	lname varchar(20),
	age int
)
insert into Student values('Susan','Yao',18)
insert into Student values('Ramesh','Arvind',20)
insert into Student values('Joseph','Antony',19)
insert into Student values('Jennifer','Amy',30)
insert into Student values('Andy','Perumal',21)

insert into Teacher values('Jennifer','Amy',30)
insert into Teacher values('Nanda','Sham',40)
insert into Teacher values('Ramesh','Arvind',20)

select * from Student
select * from Teacher

--a)find the fname and lname of people who are teachers as well as students
select fname,lname from Student where Student.age in (select age from Teacher)

--b)find the students who are not teachers
select * from Student where 
	Student.fname not in (select fname from Teacher) 
		and Student.lname not in (select lname from Teacher)

--c)find the teachers who are not students
select * from Teacher where
	Teacher.fname not in (select fname from Student) 
		and Teacher.lname not in (select lname from Student)

--===================Purchase Record================
create table Purchases
(
	cust_id int,
	amount int
)
create table Customer
(
	cust_id int,
	cname varchar(10)
)
insert into Purchases values(1,100)
insert into Purchases values(3,50)
insert into Purchases values(1,200)
insert into Purchases values(1,500)
insert into Purchases values(3,20)

insert into Customer values(1,'Adam')
insert into Customer values(2,'Bob')
insert into Customer values(3,'Cathy')

select * from Purchases
select * from Customer

create table [Query Result]
(
	cust_id int,
	total_amount int
)
drop table [Query Result]

--Answer:-
select c.cust_id,ISNULL(sum(amount), 0 ) as Total_Amount from customer c left outer join purchases p
	on (c.cust_id=p.cust_id) group by c.cust_id order by Total_Amount