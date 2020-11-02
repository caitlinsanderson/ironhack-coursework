##---Lab-sql-Joins on multiple tables---##
#Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS StoreID, 
        a.address AS address, 
        c.city AS city, 
        a.district AS district, 
        a.postal_code AS zip_code
FROM sakila.store s
LEFT JOIN sakila.address a
	ON s.address_id = a.address_id
JOIN city c
	ON a.city_id = c.city_id;
    
#Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id AS StoreID,
	FORMAT(SUM(p.amount),2) AS TotalSales
FROM sakila.store s 
LEFT JOIN sakila.staff ss
ON s.store_id = ss.staff_id
LEFT JOIN sakila.payment p
ON ss.staff_id = p.staff_id
GROUP BY s.store_ID;

#Which film categories are longest?
SELECT c.name AS filmcategory, 
	AVG(f.length) AS AvgLength
FROM sakila.category c
LEFT JOIN sakila.film_category fc
ON c.category_id = fc.category_id
LEFT JOIN sakila.film f
ON fc.film_id = f.film_id
GROUP BY c.category_id
ORDER BY AvgLength DESC;

#Display the most frequently rented movies in descending order.
SELECT f.title AS FilmTitle,
	COUNT(r.rental_id) AS TotalRentals
FROM sakila.film f
LEFT JOIN sakila.inventory i
	ON f.film_id = i.film_id
LEFT JOIN sakila.rental r
	ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY TotalRentals DESC;

#List the top five genres in gross revenue in descending order.
SELECT c.name AS FilmGenre,
	FORMAT(SUM(p.amount),2) AS GrossRevenue
FROM sakila.category c
LEFT JOIN sakila.film_category fc
	ON c.category_id = fc.category_id
LEFT JOIN sakila.inventory i
	ON fc.film_id = i.film_id
LEFT JOIN sakila.rental r
	ON i.inventory_id = r.inventory_id
LEFT JOIN sakila.payment p
	ON r.rental_id = p.rental_id
GROUP BY c.category_id
ORDER BY GrossRevenue
LIMIT 5;

#Is "Academy Dinosaur" available for rent from Store 1?
SELECT CASE
	WHEN r.return_date <> null THEN 'available'
    ELSE 'unavailable'
END
FROM sakila.film f
JOIN sakila.inventory i
	ON f.film_id = i.film_id
JOIN sakila.rental r
	ON i.inventory_id = r.inventory_id
WHERE f.title = "Academy Dinosaur" AND i.inventory_id = 1;
