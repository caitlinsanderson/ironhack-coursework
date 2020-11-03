##---Lab SQL subqueries---###
#1.How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;

SELECT f.title, COUNT(i.inventory_id)
FROM sakila.inventory i
LEFT JOIN sakila.film f 
ON i.film_id = f.film_id
GROUP BY f.title
HAVING f.title = 'Hunchback Impossible';

SELECT COUNT(film_id) AS InventoryCounty FROM sakila.inventory
WHERE film_id = (SELECT film_id FROM sakila.film
WHERE title = 'Hunchback Impossible');

#2.List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film
WHERE length > 
	(SELECT avg(length) FROM sakila.film)
ORDER BY length DESC
LIMIT 25;

#3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(first_name,' ', last_name) AS ActorName FROM sakila.actor
WHERE actor_id IN 
	(SELECT actor_id FROM sakila.film_actor
		WHERE film_id = 
			(SELECT film_id FROM sakila.film
			WHERE TITLE = 'Alone Trip'
            )
	)
    ORDER BY ActorName;

#4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT title FROM sakila.film
WHERE film_id IN 
	(SELECT film_id FROM sakila.film_category
		WHERE category_id = 
			(SELECT category_id FROM sakila.category
			WHERE name = 'Family'
			)
	);

#5.Get name and email from customers from Canada using subqueries. 
#Do the same with joins. Note that to create a join, 
#you will have to identify the correct tables with their primary keys and foreign keys, 
#that will help you get the relevant information.

#subqueries:
SELECT CONCAT(first_name, ' ', last_name) AS CustomerName, email FROM sakila.customer
WHERE address_id IN
	(SELECT address_id FROM sakila.address
	WHERE city_id IN
		(SELECT city_id FROM sakila.city
		WHERE country_id =
			(SELECT country_id FROM sakila.country
			WHERE country = 'Canada'
            )
        )
    );

#with joins:
SELECT CONCAT(c.first_name, ' ', c.last_name) AS CustomerName, c.email 
FROM sakila.customer c
JOIN sakila.address a
	ON c.address_id = a.address_id
JOIN sakila.city cy
	ON a.city_id = cy.city_id
JOIN sakila.country cn
	ON cy.country_id = cn.country_id
WHERE cn.country = 'Canada';

#6.Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title FROM sakila.film
WHERE film_id IN
	(SELECT film_id FROM sakila.film_actor
	WHERE actor_id =
		(SELECT actor_id FROM sakila.film_actor
			GROUP BY actor_id
			ORDER BY COUNT(actor_id) DESC
			LIMIT 1
        )
    );

#7.Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable customer 
#ie the customer that has made the largest sum of payments
SELECT title FROM sakila.film
WHERE film_id IN
	(SELECT film_id FROM sakila.inventory
	WHERE inventory_id IN
		(SELECT inventory_id FROM sakila.rental
		WHERE customer_id = 
			(SELECT customer_id FROM sakila.payment
			GROUP BY customer_id
			ORDER BY SUM(amount) DESC
			LIMIT 1
            )
        )
    )
    ORDER BY title;

#8.Customers who spent more than the average payments.
SELECT first_name, last_name FROM sakila.customer
WHERE customer_id IN
	(SELECT customer_id FROM sakila.payment
	GROUP BY customer_id
	HAVING SUM(amount) >
		(SELECT AVG(amount) FROM sakila.payment
        )
	)
ORDER BY last_name;
 