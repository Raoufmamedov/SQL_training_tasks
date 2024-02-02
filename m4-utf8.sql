--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;


--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create table lng(
lng_id serial primary key,
lng_nm varchar(20) not null unique)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into lng(lng_id, lng_nm)
values (1, 'RU'), (2, 'EN'), (3, 'DE'), (4, 'IT'), (5, 'CN')

select * from lng

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table nats(
nats_id serial primary key,
nats_nm varchar(30) not null unique)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

insert into nats(nats_id, nats_nm)
values (1, 'Slavdom'), (2, 'Anglo-Saxondom'), (3, 'Germans'), (4, 'Italians'), (5, 'Chinese')

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table ctry(
ctry_id serial primary key,
ctry_nm varchar(20) not null unique)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into ctry(ctry_id, ctry_nm)
values (1, 'Russia'), (2, 'UK'), (3, 'Germany'), (4, 'Italy'), (5, 'PRC')

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table lng_nats(
lng_id int2 not null references lng(lng_id),
nats_id int2 not null references nats(nats_id))

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into lng_nats(lng_id, nats_id)
values (1, 1), (2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (3, 3), (3, 4), (4, 4), (4, 1), (4, 2), (5, 5)

--Проверка правильность объединения
select *
from (lng join lng_nats using(lng_id) join nats using(nats_id)) as lngnat

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table ctry_nats(
ctry_id int2 not null references ctry(ctry_id),
nats_id int2 not null references nats(nats_id))

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into ctry_nats(ctry_id, nats_id)
values (1, 1), ( 1, 2 ), ( 1, 3 ),  (2 , 1 ), ( 2, 2 ), (2, 3 ), ( 2, 4 ), (3 , 1 ), ( 3, 2 ), (3 , 4 ), ( 3,  5),
 (4 , 1), (4, 2), (4, 3), (4, 4), (5, 2), (5, 3)
--values (1, 'Russia'), (2, 'UK'), (3, 'Germany'), (4, 'Italy'), (5, 'PRC')
--values (1, 'Slavdom'), (2, 'Anglo-Saxondom'), (3, 'Germans'), (4, 'Italians'), (5, 'Chinese')
 
--Проверка правильность объединения 
select lng_nm, nats_nm, ctry_nm
from lng join lng_nats using(lng_id) join nats using(nats_id) join ctry_nats using(nats_id) join ctry using(ctry_id)


--drop table lng, nats, ctry, ctry_nats, lng_nats
--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

 select * from ctry
--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

 create table film_new(
 film_id serial primary key,
 film_name varchar(255) not null,
 film_year integer check (film_year>0),
 film_rental_rate numeric(4,2) default 0.99,
 film_duration integer not null check (film_duration>0)) 


--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
insert into film_new(film_name, film_year, film_rental_rate, film_duration)
values 
('The Shawshank Redemption', 1994, 2.99, 142),
('The Green Mile',1999,0.99,189), 
('Back to the Future', 1985, 1.99, 116),
('Forrest Gump',1994,2.99,142), 
('Schindlers List',1993, 3.99, 195)


--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41
update film_new
set film_rental_rate = film_rental_rate + 1.41


--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

DELETE FROM film_new
WHERE film_name='Back to the Future'

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме
insert into film_new (film_name, film_year, film_rental_rate, film_duration)
values ('Школьный переполох', 2022, 0.99, 105)

--Проверка вставки
select * from film_new
where film_name='Школьный переполох'

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых
select *, round(film_duration/60.0, 1) as "film_duration in hours" from film_new


--ЗАДАНИЕ №7 
--Удалите таблицу film_new
drop table film_new