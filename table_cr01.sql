CREATE table newtable(
ID serial primary key,
username varchar(10) unique not null,
status varchar(10),
--case when status=0 or status=1
belong_to varchar(15) not null,
description varchar (255)
)

--select * from newtable
--insert into newtable(id, username)
--values (NULL,  'noname5')

--delete from newtable 
--where id=2

--insert to newtable 
drop table newtable
