##--- Lab - sql advanced queries ---##

#List each pair of actors that have worked together.
SELECT fa1.film_id, CONCAT(a.first_name, ' ' , a.last_name) AS Actor_1, CONCAT(a2.first_name, ' ' , a2.last_name) AS Actor_2
FROM sakila.film_actor AS fa1
JOIN sakila.film_actor AS fa2 ON fa1.film_id = fa2.film_id AND (fa1.actor_id <> fa2.actor_id)
JOIN sakila.actor AS a ON fa1.actor_id = a.actor_id
JOIN sakila.actor AS a2 ON fa2.actor_id = a2.actor_id;

#For each film, list actor that has acted in more films.
WITH cte_actorfilm AS
(
SELECT actor_id, COUNT(film_id) AS num_films
FROM sakila.film_actor
GROUP BY actor_id
)

SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) AS actor_w_most_films
FROM (
	SELECT fa.film_id, cte.actor_id, 
    RANK() OVER (PARTITION BY film_id ORDER BY num_films DESC) AS num_films_rank 
	FROM sakila.film_actor AS fa
	JOIN cte_actorfilm AS cte
		ON cte.actor_id = fa.actor_id
	) AS sub1
JOIN sakila.actor AS a 
	ON sub1.actor_id = a.actor_id
JOIN sakila.film AS f 
	ON sub1.film_id = f.film_id
WHERE num_films_rank = 1;
