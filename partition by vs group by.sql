select f.title, a.last_name, count(f.film_id)
from film f join film_actor fa using(film_id)
join actor a using(actor_id)
group by a.last_name, f.title
limit 20

UNION ALL
--
select f.title, a.last_name, count(f.film_id) over (partition by a.actor_id)
from film f join film_actor fa using(film_id)
join actor a using(actor_id)
order by 3

-- Видимая разница в том, что при группировке count по актёру для каждого фильма равен единице,
--в то время как оконная функция для каждого фильма указывает сумму всех фильиов в которых 
--снимался задействованный в нём актёр.

