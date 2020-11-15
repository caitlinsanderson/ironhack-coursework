##--- Lab - SQL self and cross join ---##
USE sakila;

#Get all pairs of actors that worked together.
SELECT fa1.film_id, CONCAT(a.first_name, ' ' , a.last_name) AS Actor_1, CONCAT(a2.first_name, ' ' , a2.last_name) AS Actor_2
FROM sakila.film_actor AS fa1
JOIN sakila.film_actor AS fa2 ON fa1.film_id = fa2.film_id AND (fa1.actor_id <> fa2.actor_id)
JOIN sakila.actor AS a ON fa1.actor_id = a.actor_id
JOIN sakila.actor AS a2 ON fa2.actor_id = a2.actor_id;

#Get all pairs of customers that have rented the same film more than 3 times.
SELECT f.title, r1.customer_id,  r2.customer_id
FROM sakila.film AS f
JOIN sakila.inventory AS i USING(film_id) 
JOIN sakila.rental AS r1 USING(inventory_id)
JOIN sakila.rental AS r2 ON r1.rental_id = r2.rental_id
;

#answer from solutions, need to examine more b/c I don't understand all the joins
select c1.customer_id, c2.customer_id, count(*) as num_films
from sakila.customer c1
inner join rental r1 on r1.customer_id = c1.customer_id
inner join inventory i1 on r1.inventory_id = i1.inventory_id
inner join film f1 on i1.film_id = f1.film_id
inner join inventory i2 on i2.film_id = f1.film_id
inner join rental r2 on r2.inventory_id = i2.inventory_id
inner join customer c2 on r2.customer_id = c2.customer_id
where c1.customer_id <> c2.customer_id
group by c1.customer_id, c2.customer_id
having count(*) > 3
order by num_films desc;

#Get all possible pairs of actors and films.
