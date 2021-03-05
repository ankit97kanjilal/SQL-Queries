--===============PFT_SQL_ASSIGNMENT====================
--1st day Assignments
use ITCDB
create table Supplier
(
	Sno varchar(2),
	Sname varchar(15),
	[Status] numeric(2),
	city varchar(10)
)

create table Part
(
	Pno varchar(2),
	Pname varchar(15),
	Color varchar(10),
	[Weight] numeric(2),
	City varchar(10)
)

create table Supp_Part
(
	Sno varchar(2),
	Pno varchar(2),
	Qty int
)

insert into Supplier values('s1','Smith',20,'London')
insert into Supplier values('s2','Jones',10,'Paris')
insert into Supplier values('s3','Blakes',30,'Paris')
insert into Supplier values('s4','Clark',20,'London')
insert into Supplier values('s5','Adams',30,'Athens')
insert into Supplier values('s6','Oh',null,'Seattle')
insert into Supplier values('s7','Fidel',null,'Seattle')
insert into Supplier values('s8','Carlyle',null,'Seattle')

select * from Supplier

insert into Part values('p1','Nut','Red',12,'London')
insert into Part values('p2','Bolt','Green',17,'Paris')
insert into Part values('p3','Screw','Blue',17,'Rome')
insert into Part values('p4','Screw','Red',14,'London')
insert into Part values('p5','Cam','Blue',12,'Paris')
insert into Part values('p6','Cog','Red',19,'London')

select * from Part

insert into Supp_Part values('s1','p1',300)
insert into Supp_Part values('s1','p2',200)
insert into Supp_Part values('s1','p3',400)
insert into Supp_Part values('s1','p4',200)
insert into Supp_Part values('s1','p5',100)
insert into Supp_Part values('s1','p6',100)
insert into Supp_Part values('s2','p1',300)
insert into Supp_Part values('s2','p2',400)
insert into Supp_Part values('s3','p2',200)
insert into Supp_Part values('s4','p2',200)
insert into Supp_Part values('s4','p4',300)
insert into Supp_Part values('s4','p5',400)

select * from Supp_Part

--Assignment Questions...............

--Qs-1
select Sno, [status] from Supplier where city='Paris'
--Qs-2
select Pno from Supp_Part
--Qs-3
select distinct Pno from Supp_Part
--Qs-4
select * from Supplier
--Qs-5
select Pno, 454*[weight] as [Weight in gms] from Part
--Qs-6
select Sno from Supplier where city='Paris' and [status]>20
--Qs-7
select Sno, [status] from Supplier where city='Paris' order by Sno desc
--Qs-8
select sno from Supplier where [status] is null
--Qs-9
select * from Supplier
select * from Part
select * from Supplier s join Part p on s.city=p.city
--Qs-10
select * from Supplier s join Part p on s.city=p.city where [Status]!=20
--Qs-13
select COUNT(*)as [Total no of suppliers] from Supplier
--Qs-14
select * from Supp_Part
select count(*) as CountOfPno from Supp_Part group by Pno having Pno='p2'
--Qs-15
select * from Supp_Part
select SUM(Qty) from Supp_Part group by pno having Pno='p2'
--Qs-16
select Pno, SUM(Qty) from Supp_Part group by Pno
--Qs-17
select Pno from Supp_Part group by pno having Count(sno)>1
--Qs-18
select * from Part
select Pname from Part where Pname like 'C%'


