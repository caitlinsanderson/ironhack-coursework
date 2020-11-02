USE sakila;

##---Lab SQL Join---##
#List number of films per category.
SELECT category_id, COUNT(film_id)
FROM film_category
GROUP BY category_id
ORDER BY category_id;

#Display the first and last names, as well as the address, of each staff member.
SELECT s.first_name AS first_name, 
		s.last_name AS last_name, 
        a.address AS address, 
        c.city AS city, 
        a.district AS district, 
        a.postal_code AS zip_code
FROM sakila.staff s
LEFT JOIN sakila.address a
	ON s.address_id = a.address_id
JOIN city c
	ON a.city_id = c.city_id;

#Display the total amount rung up by each staff member in August of 2005.
SELECT s.first_name AS first,
	s.last_name AS last,
    FORMAT (SUM(p.amount),2) AS TotalAmount
FROM sakila.staff s
LEFT JOIN sakila.payment p
	ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 8
GROUP BY s.staff_id;

#List each film and the number of actors who are listed for that film.
SELECT f.title, COUNT(fa.actor_id) AS TotalActors
FROM film f
LEFT JOIN film_actor fa
	ON f.film_id = fa.film_id
GROUP BY f.film_id;

#Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
	#List the customers alphabetically by last name.
SELECT c.last_name AS last,
	c.first_name AS first,
    SUM(p.amount)
FROM sakila.customer c
LEFT JOIN sakila.payment p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;