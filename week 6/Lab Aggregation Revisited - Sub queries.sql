USE sakila;
#Select the first name, last name, and email address of all the customers who have rented a movie.
WITH cte_rental_customers AS
	(
    SELECT DISTINCT(customer_id) 
	FROM sakila.rental
    )
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.email
FROM sakila.customer AS c
JOIN cte_rental_customers AS cte USING(customer_id);

#What is the average payment made by each customer 
	#(display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, 
	CONCAT(first_name, ' ', last_name) AS customer_name,
	ROUND(AVG(p.amount),2) AS avg_payment
FROM sakila.payment AS p
JOIN sakila.customer AS c USING(customer_id) 
GROUP BY c.customer_id;

#Select the name and email address of all the customers who have rented the "Action" movies.
	#Write the query using multiple join statements
SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS customer_name,
	c.email
FROM sakila.customer AS c
JOIN sakila.rental AS r
	ON c.customer_id = r.customer_id
JOIN sakila.inventory AS i
	ON r.inventory_id = i.inventory_id
JOIN sakila.film_category AS fc
	ON i.film_id = fc.film_id
WHERE fc.category_id = 1;

	#Write the query using sub queries with multiple WHERE clause and IN condition
SELECT DISTINCT(CONCAT(first_name, ' ', last_name)) AS customer_name,
	email
FROM sakila.customer 
WHERE customer_id IN 
(
	SELECT customer_id
    FROM sakila.rental
    WHERE inventory_id IN
	(
		SELECT inventory_id 
		FROM sakila.inventory
		WHERE film_id IN 
		(
			SELECT film_id
			FROM sakila.film_category
			WHERE category_id = 1
        )
	)
);
    
	#Verify if the above two queries produce the same results or not

#Use the case statement to create a new column classifying existing columns as either or high value transactions 
	#based on the amount of payment. 
    #If the amount is between 0 and 2, label should be low and 
    #if the amount is between 2 and 4, the label should be medium, 
    #and if it is more than 4, then it should be high.
    
SELECT amount, 
	CASE 
    WHEN amount>0 AND amount<=2 THEN "low"
	WHEN amount >2 AND amount<=4 THEN "medium"
	ELSE "high" 
    END AS low_medium_high
FROM payment;