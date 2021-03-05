--===============SQL is all about practice queries:D=============================
--new assignment... On key contraints
--===========Practice session-1==============
create table dept
(
	id numeric(4),
	name varchar(25)
)

insert into dept values(1001,'Prithivi')
insert into dept values(1002,'Agni')
insert into dept values(1003,'Tejas')
insert into dept values(1004,'Trishul')

alter table dept alter column id int not null
alter table dept add constraint pki primary key(id)

alter table dept add location varchar(15)

update dept set location='bangalore' where id=1001
update dept set location='hyderabad' where id=1003
update dept set location='chennai' where id=1002
update dept set location='delhi' where id=1004

--sp_rename 'customer.Cname','custname'
sp_rename 'dept.location','place'
sp_rename 'dept','itpl'


select * from itpl
alter table itpl drop constraint pki
drop table itpl

--===========Practice session-2==============
create table it_tab
(
	id numeric(2),
	name varchar(25)
)
drop table it_tab

insert into it_tab values(null,'TCS')
insert into it_tab values(5001,'HP')
insert into it_tab values(5001,'INFI')

alter table it_tab alter column id numeric(4)
select * from it_tab

--try to add a primary key to id
update it_tab set id=5000 where name='TCS'
update it_tab set id=5002 where name='INFI'
alter table it_tab alter column id int not null
alter table it_tab add constraint pk2 primary key(id)

--try to add a unique constraint for column id
alter table it_tab add constraint u_id unique(id)
--delete row
delete from it_tab where name = 'INFI'

select * from it_tab

--================Practice session-3====================
create table demo
(
	d_id int,
	d_name varchar(10) check(d_name=upper(d_name) collate latin1_general_cs_as)
)
drop table demo
insert into demo values(100,'ravi')
insert into demo values(100,'RAVI')
select * from demo

--predefined functions
select LOG10(10)
select SIN(90), COS(90), TAN(90), ATAN(90)
select ROUND(125.46,0)
select FLOOR(12.66)
select CEILING(12.66)

st='welcome'
select concat(UPPER(left('hello',1)),right('hello',len('hello')-1))

--date function
select GETDATE()
select CONVERT(date,'25-MAR-2021',110)
select YEAR(getdate()),MONTH(getdate()),DAY(getdate())

--but no inbuilt func for hours
select DATEPART(YYYY,getdate())
,DATEPART(MM,getdate())
,DATEPART(DD,getdate())
,DATEPART(HH,getdate())
,DATEPART(MI,getdate())
,DATEPART(SS,getdate())

--adding date parts
select DATEADD(yyyy,2,getdate())--- use -1 for previous years month etc
,DATEADD(MM,2,getdate())
,DATEADD(DD,2,getdate())
,DATEADD(HH,2,getdate())
,DATEADD(MI,2,getdate())
,DATEADD(SS,2,getdate())

--subtracting two dates
select DATEDIFF(YYYY,getdate(),'25-MAR-2025')
select DATEDIFF(MM,getdate(),'25-MAR-2025')
select DATEDIFF(DD,getdate(),'25-MAR-2025')
select DATEDIFF(HH,getdate(),'25-MAR-2025')