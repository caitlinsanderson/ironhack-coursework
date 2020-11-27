USE sakila;
#Convert the query into a simple stored procedure. Use the following query:

DROP PROCEDURE IF EXISTS action_rental_customers;
DELIMITER //
CREATE PROCEDURE action_rental_customers()
BEGIN
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
END;
// DELIMITER ;

CALL action_rental_customers();

#Now keep working on the previous stored procedure to make it more dynamic. 
	#Update the stored procedure in a such manner that it can take a string argument for the 
    #category name and return the results for all customers that rented movie of that category/genre. 
    #For eg., it could be action, animation, children, classics, etc.
    ##HINT : insert an IN param2 int into your initial definition of the stored procedure, and a clause into the query 
 #where category_counts > param2
 # before calling the procedure with that param
 
 DROP PROCEDURE IF EXISTS genre_rental_customers;
DELIMITER //
CREATE PROCEDURE genre_rental_customers (IN param1 varchar(50)) 
BEGIN
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param1
  group by first_name, last_name, email;
END;
// DELIMITER ;
 
 call genre_rental_customers('Action');
 
 #Write a query to check the number of movies released in each movie category. 
 #Convert the query in to a stored procedure to filter only those categories that have 
	#movies released greater than a certain number. 
	#Pass that number as an argument in the stored procedure.
 
 DROP PROCEDURE IF EXISTS CatMovies;
 
 DELIMITER //
CREATE PROCEDURE CatMovies (IN param1 INT)
BEGIN
	SELECT c.name, count(*) as Movies 
	FROM film_category AS f
	JOIN category AS c USING(category_id)
	GROUP BY category_id
	HAVING Movies > param1
	ORDER BY 2 ASC;
END;
// DELIMITER ; 

CALL CatMovies(66);
 
 