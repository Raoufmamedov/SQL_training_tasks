--
insert into newtable (username, status, belong_to, description)
values('Slon-68', 'W', 'Nobody', 'stray thing')

alter table newtable add column "Oooups!" varchar(15) 
select * from newtable

alter table newtable drop column "Oooups!"

update newtable 
set id=6
where status='L'

select * from newtable


update newtable 
set "belong_to"='Jack Back', "description"='Something  good', "Oooups!"=7
where status='L' and belong_to='Andy Boor' and username='Slon-49'

insert into newtable (username, status, belong_to, description)
values('Slon-44', 'L', 'Somebody', 'good thing')
where id<6

insert into newtable (username, status, belong_to, description)
values('Slon-44', 'L', 'Somebody', 'good thing')
where id<6
