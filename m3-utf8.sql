--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.
SELECT last_name||' '||first_name as "Фамилия Имя", address as "Адрес", city as "Город", country as "Страна"
FROM customer AS cus
JOIN address AS adr using(address_id) 
join city as cty using(city_id) 
join country as ctry using(country_id) 


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
select str.store_id as "Магазин", count(customer_id) as "Кол-во покупателей"
from customer as cus join store as str using(store_id) 
group by store_id

--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.
select str.store_id as "Магазин", count(customer_id) as "Кол-во покупателей"
from customer as cus 
join store as str using(store_id) 
group by store_id
having count(customer_id)>300


-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.
select str.store_id as "Магазин", count(customer_id) as "Кол-во покупателей", cty.city as "Город магазина",
stf.last_name||' '||stf.first_name as "Фамилия и имя продавца"  
from customer as cus 
join store as str using(store_id)  
join address as adr on str.address_id=adr.address_id
join city as cty using(city_id)
join staff as stf using(store_id) 
group by store_id, stf.last_name, stf.first_name, cty.city
having count(customer_id)>300


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов
select customer_id, first_name||' '||last_name, count(rental_id)
from customer c join rental r using(customer_id)
group by customer_id
order by count(rental_id) desc 
limit 5


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select customer_id "ID заказчика", count(inventory_id) "Кол-во прокатов", round(sum(amount)) "Суммарная стоимость",
min(amount) "Мин. ст-ть заказа", max(amount) "Макс. ст-ть заказа"
from customer c 
join rental r using(customer_id)
join payment p using(customer_id)
group by customer_id

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 

select   c.city "Город № 1",  c1.city "Город № 2"
from city c cross join city as c1 
where c.city <> c1.city


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select customer_id, round(AVG(r.return_date::date-r.rental_date::date), 2) as "кол-во дней"
from rental as r
group by customer_id
order by customer_id
--EXTRACT(
--)
--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select film_id, f.title, count(film_id), sum(p.amount)
from film as f
join inventory as i using(film_id)
join rental as r using(inventory_id)
join payment as p using(rental_id)
group by film_id 
order by film_id

--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.
select film_id as "Film ID", f.title as "Film title", count(film_id) as Rented_times, sum(p.amount) as "Total rental payments"
from film as f
left join inventory as i using(film_id)
left join rental as r using(inventory_id)
left join payment as p using(rental_id)
group by film_id 
having count(film_id)=0

-- RM> Несовпадение с образцом! В базе данных не найдены фильмы которые брали менее 4 раз. 
-- Доработаю запрос после комментариев Вячеслава.

select count(film_id) as Min_rented_times
from film as f
join inventory as i using(film_id)
join rental as r using(inventory_id)
group by film_id 
order by Min_rented_times
limit 1

--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select count(payment.payment_id) as "Количество прокатов", 
case 
	when count(payment.payment_id)>7300 then 'Да'
	else 'НЕТ' 
end as "Премия"
from staff join payment using(staff_id)
group by staff_id



