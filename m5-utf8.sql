--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим 
--так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.

--1.1
select  
row_number() over (order by payment_date) as payment_que_id,
payment_id, payment_date, customer_id       
from payment 

--1.2
select customer_id,
	dense_rank() OVER (PARTITION BY customer_id ORDER by payment_date) AS que_for_customer,
    row_number() over (order by payment_date) as payment_que_id, payment_id, payment_date
from payment 
order by customer_id, payment_date

--1.3.1
select customer_id,
	dense_rank() OVER (PARTITION BY customer_id ORDER by payment_date) AS que_for_customer,
    row_number() over (order by payment_date) as payment_que_id,
    sum(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS total_pmnt_by_cust, 
    payment_id, payment_date
from payment 
order by customer_id, payment_date

--1.3.2
select customer_id,  
       dense_rank() OVER (PARTITION BY customer_id ORDER by payment_date) AS que_for_customer,
       row_number() over (order by payment_date) as payment_que_id,
       sum(amount) over (partition by customer_id order by payment_date, amount) as incr_pmnt_by_cust,
       payment_id, payment_date
from payment 
order by customer_id

--1.4
select customer_id,  
       dense_rank() OVER (PARTITION BY customer_id ORDER by payment_date) AS que_for_customer,
       row_number() over (order by payment_date) as payment_que_id, amount,
       sum(amount) over (partition by customer_id order by payment_date, amount) as total_pmnt_by_cust,
       rank() OVER (PARTITION BY customer_id ORDER by amount desc) AS payment_rank,
       payment_id, payment_date     
from payment 
order by customer_id, payment_rank


--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.
select customer_id, payment_id, payment_date, amount,
lag(amount,1,0) over (partition by customer_id order by payment_date) AS prev_amount
from payment
order by customer_id


--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.
select customer_id, payment_id, payment_date, amount-lag(amount,1,0) 
over (partition by customer_id order by payment_date) AS act_prev_deviation
from payment
order by customer_id



--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.
select customer_id, payment_id, payment_date, last_value
from(
	select customer_id, payment_id, payment_date,
	last_value(amount) over (partition by customer_id order by payment_date desc),
	row_number() over (partition by customer_id order by payment_date DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
	from payment) lv  
where row_number = 1




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.

WITH cte_1 AS (
select staff_id, payment_date::date, sum(amount) as "sum_amount"
from payment 
where payment_date::date between '2005-08-01' and '2005-09-01'
group by staff_id, payment_date::date)
--
select payment_date::date, staff_id, "sum_amount",
sum(sum_amount) over (partition by staff_id order by payment_date)
from cte_1
ORDER BY payment_date::date DESC


--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку
WITH cte AS (
select customer_id, payment_id, payment_date,
row_number() over (order by payment_date) AS cust_num
from payment
where payment_date::date = '2005-08-20')
--
select * from cte WHERE cust_num%100=0


--ЗАДАНИЕ №3
--Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм

	