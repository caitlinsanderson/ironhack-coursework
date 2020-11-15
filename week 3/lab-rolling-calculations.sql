##---Lab Rolling Calculations---##
#1. Get number of monthly active customers.
#count the number of customers who rented a movie in a given month
USE sakila;

CREATE OR REPLACE VIEW monthly_active_users AS
WITH cte_monthlyrentals AS
(
SELECT DATE_FORMAT(rental_date, '%Y') as Rental_Year, 
DATE_FORMAT(rental_date, '%m') as Rental_Month,
customer_id
FROM sakila.rental
)
SELECT Rental_Year, Rental_Month, COUNT(DISTINCT customer_id) AS Active_Customers
FROM cte_monthlyrentals
GROUP BY Rental_Year, Rental_Month
ORDER BY Rental_Year, Rental_Month;

SELECT * FROM monthly_active_users;

#2. Active users in the previous month.
CREATE OR REPLACE VIEW compare_active_users AS
WITH cte_monthlyactivity AS
(
SELECT Rental_Year, Rental_Month, Active_Customers, 
LAG (Active_Customers, 1) OVER (PARTITION BY Rental_Year) AS Previous_Month
FROM monthly_active_users
)
SELECT * FROM cte_monthlyactivity
WHERE Previous_Month IS NOT NULL;

SELECT * FROM compare_active_users;

#3. Percentage change in the number of active customers.
SELECT *, ((Active_Customers - Previous_Month)/Active_Customers)*100 AS Perct_Change
FROM compare_active_users;

#4. Retained customers every month.
CREATE VIEW retained_customers AS
WITH cte_retained_customers AS
(
SELECT DATE_FORMAT(r.rental_date, '%Y') AS Rental_Year, 
DATE_FORMAT(r.rental_date, '%m') AS Rental_Month, 
c.customer_id AS Active_Customer
FROM sakila.customer AS c
LEFT JOIN sakila.rental AS r USING(customer_id)
)
SELECT * FROM cte_retained_customers;

SELECT rc1.Rental_Year, rc1.Rental_Month, COUNT(DISTINCT(rc1.Active_Customer)) AS Retained_Customer
FROM retained_customers AS rc1
JOIN retained_customers AS rc2
	ON rc1.Active_Customer = rc2.Active_Customer AND rc1.Rental_Month = rc2.Rental_Month + 1
GROUP BY rc1.Rental_Year, rc1.Rental_Month;
