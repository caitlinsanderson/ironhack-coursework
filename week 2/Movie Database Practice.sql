#explore the tables of the database
USE sakila;
SELECT * FROM actor;
SELECT * FROM address;
SELECT * FROM category;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM film_text;
SELECT * FROM inventory;
SELECT * FROM language;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM staff;
SELECT * FROM store;
#select one column from a table; get the film titles
SELECT title FROM film_text;
#select one column from a table and alias it
SELECT rental_duration FROM film AS days_rented ORDER BY rental_duration;
#get languages
SELECT DISTINCT name FROM language;
#how many stores does the company have? 
SELECT COUNT(store_id) FROM store;
#they have 2 stores
#How many employees do they have? 
SELECT COUNT(staff_id) FROM staff;
#they have 2 employees
#what are their names? 
SELECT staff_id, first_name, last_name FROM staff;

##--- lab 2 ---##

USE sakila;
#select all the actors with the first name "Scarlett"
SELECT * FROM actor
WHERE first_name = 'Scarlett';
#select all the actors with the last name "Johansson"
SELECT * FROM actor
WHERE last_name = 'Johansson';
#how many films are available for rent? 
SELECT COUNT(DISTINCT film_id) FROM inventory;
#answer = 958
#how many films have been rented? 
SELECT COUNT(rental_id) FROM rental;
#answer = 16,044
#What is the shortest and longest rental period? 
SELECT rental_duration
FROM film
ORDER BY rental_duration DESC
LIMIT 1;
#shorest = 3 days; longest = 7 days

#what are the shortest an longest movie duration? 
SELECT MIN(length) AS min_duration 
FROM film;
#min_duration = 46 minutes

SELECT MAX(length) AS max_duration
FROM film;
#max_duration = 185 minutes; 

#what is the average movie duration? 
SELECT AVG(length) AS avg_movie_length 
FROM film;
#answser = 115.2720 minutes

#what is the average movie duration expressed in format (hours, minutes)? 
SELECT from_unixtime(avg(length),'%m:%s') AS avg_movie_length
FROM film; 

SELECT CONCAT(floor(AVG(length)/60),'H',floor(AVG(length)%60),'M')
FROM film;

#how many movies are longer than 3 hours? 
SELECT COUNT(film_id) AS long_movies FROM film
WHERE length > 180;

#Get the name and email formatted in the following way: Mary SMITH mary.smith@host.com
SELECT CONCAT(CONCAT(SUBSTRING(first_name, 1, 1), LOWER(SUBSTRING(first_name,2,length(first_name)))),
			' ',last_name) AS Full_Name, 
	lower(email) AS Email
FROM customer;

SELECT CONCAT((LEFT(first_name,1)), LOWER(SUBSTRING(first_name,2,length(first_name))), ' ', last_name) AS Full_Name, 
	lower(email) AS Email
FROM customer;

#what is the length of the longest film title? 
SELECT length(title) AS title_length FROM film
ORDER BY title_length DESC
LIMIT 1;
#answer = 27


##---DAY 2 (27.10.2020) ---##
USE sakila;

SELECT date_format(last_update, '%Y') FROM sakila.actor;

#we can also convert dates and other things:
SELECT CONVERT('2020/10/27 15:32:00', DATE);

#we can calculate the number of days between two DATE, DATETIME, or TIMESTAMP values
#the result will always be expressed in days
SELECT rental_date, return_date, datediff(return_date, rental_date)
From sakila.rental;

SELECT CONVERT('2020/10/27 15:32:00', DATE);
#here the time gets dropped

SELECT CONVERT('2020/10/27 15:32', TIME);
#it will give only the time with the seconds added

#Null values
#there is a function that we can use to get null values:
SELECT last_update, ISNULL(last_update) FROM sakila.rental;
#this asks: is null true? = 1, is null false? = 0

#do you want to know how many null values you have? 
SELECT SUM(ISNULL(last_update)) FROM sakila.rental;

#THE CASE STATEMENT
#this allows us to make categories; it's a bit analogous to an if, elif, else statement in Python
#CASE
	#WHEN condition1 THEN result1
    #WHEN condition2 THEN result2
    #WHEN condition3 THEN result3
#ELSE result
#END;

SELECT title, length, CASE
	WHEN length < 60 THEN 'short film'
    WHEN length > 120 THEN 'long film'
    ELSE 'medium film'
END AS lengthcategory 
FROM sakila.film
ORDER BY length DESC;

##---Lab SQL Queries 3---##
USE sakila;
#How many distinct (different) actors' last names are there?
SELECT COUNT(distinct last_name)
FROM actor;
#answer = 121

#In how many different languages where the films originally produced? 
#(Use the column language_id from the film table)
SELECT COUNT(DISTINCT language_id)
FROM film;
#answer = 1

#How many movies were released with "PG-13" rating?
SELECT COUNT(rating = 'PG-13')
FROM film;
#answer = 1000

#Get 10 the longest movies from 2006
SELECT title
FROM film
WHERE release_year = 2006
ORDER BY length DESC
LIMIT 10;

#How many days has been the company operating (check DATEDIFF() function)? 
SELECT DATEDIFF(max(rental_date), min(rental_date))
FROM rental;
#answer = 266 days

#Show rental info with additional columns month and weekday. Get 20.
SELECT *, 
	DATE_FORMAT(rental_date, "%M") AS rental_month, 
    date_format(rental_date, "%W") AS rental_day
FROM rental
LIMIT 20;

#Add an additional column day_type with values 'weekend' and 'workday' 
#depending on the rental day of the week.
SELECT *, CASE
	WHEN DATE_FORMAT(rental_date, '%W') = "Sunday" OR 'SATURDAY' THEN 'Weekend'
    ELSE 'workday'
END AS workorweekend 
FROM rental;

#How many rentals were in the last month of activity?
SELECT COUNT(rental_id)
FROM rental
WHERE date_format(rental_date, '%M') = 'February';

SELECT date_format(rental_date, '%M'), COUNT(rental_id)
FROM rental
GROUP BY date_format(rental_date, '%M');

SELECT max(return_date)
FROM rental;

#the IN Clause
#SELECT column
#FROM table
#WHERE column IN (x, x2, x3, x4,...);

SELECT * FROM film_category WHERE category_id IN (5,6);

#the BETWEEN operator
#SELECT column
#FROM table
#WHERE column BEWTEEN value1 AND value2
#it works with numbers
#it works with strings
#the last letter or string is NOT completely inclusive
#it technically is inclusive, but it reads the strings across to if you have:
#BETWEEN 'a' and 'd', it will look for all strings that start with 'a' up to and including
#'d', but any string that is 'da' or beyond is NOT included

#YOU can combine it with NOT
#WHERE column NOT BETWEEN value1 AND value2

SELECT *
FROM film_category
WHERE category_id BETWEEN 5 AND 6;

#BETWEEN doesn't only work for numbers
SELECT *
FROM actor
WHERE first_name BETWEEN 'a' AND 'e'
ORDER BY first_name;

#it works with dates
SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-05-24' AND '2005-05-26'
ORDER BY rental_date;
#here, the default of the timestamp is 00:00:00, so anything after 2005-05-26 00:00:00 is
#NOT included
#you can change the time to include 23:59:59
SELECT *
FROM rental
WHERE rental_date BETWEEN '2005-05-24' AND '2005-05-26 23:59:59'
ORDER BY rental_date;
#OR, you can convert the column we are comparing to a DATE format 
#(which will convert all of the timestamps on the last date to 00:00:00), so they will 
#be included in the last date at 00:00:00
SELECT *
FROM rental
WHERE CONVERT(rental_date, DATE) BETWEEN '2005-05-24' AND '2005-05-26'
ORDER BY rental_date;

#the LIKE OPERATOR
#The LIKE operator is used is a WHERE clause to search for a specified pattern in a column
#SELECT column
#FROM table
#WHERE column LIKE pattern;

#_ = The underscoe represents a single character
#% = this represent zeio, one, or multiple character

SELECT * FROM actor
WHERE first_name LIKE 'a%';

SELECT * FROM actor
WHERE first_name LIKE 'a_';

#I want all actors whose first name starts with 'a' and is 4 characters long
SELECT * FROM actor
WHERE first_name LIKE 'a___';

#REGULAR EXPRESSIONS
# . is used to match any 
SELECT * FROM actor WHERE first_name REGEXP 'atal';
#here is looks for names with "atal" in them

SELECT * FROM actor WHERE first_name REGEXP '[atal]';
#here, however, it looks for names with either an 'a', a 't', or 'l'

SELECT * FROM actor WHERE first_name REGEXP '^[pe]';
#adding the carrot at the beginning tells it to look for any name that starts with 
#either a 'p' or an 'e'

SELECT * FROM actor WHERE first_name REGEXP '^[^pe]';
#this will return every name EXCEPT those that start with 'p' or 'e'

#REGEXP are very useful when cleaning data 

#whenever you use a "GROUP BY clause" you either have to use an aggregation method,
#OR you need to select what you are grouping by

##---Lab SQL Queries 4---##
USE sakila;

#Get film ratings
SELECT DISTINCT rating FROM film;

#Get release years
SELECT DISTINCT release_year FROM film;

#Get all films with ARMAGEDDON in the title
SELECT film_id, title
FROM film
WHERE title LIKE '%ARMAGEDDON%';

#Get all films with APOLLO in the title
SELECT film_id, title
FROM film
WHERE title LIKE '%APOLLO%';

#Get all films which title ends with APOLLO
SELECT film_id, title
FROM film
WHERE title LIKE '%APOLLO';

#Get all films with word DATE in the title.
SELECT film_id, title
FROM film
WHERE title REGEXP 'DATE';

#Get 10 films with the longest title.
SELECT film_id, title
FROM film
ORDER BY length(title) DESC
LIMIT 10;

#Get 10 the longest films.
SELECT film_id, title, length
FROM film
ORDER BY length DESC
LIMIT 10;

#How many films include Behind the Scenes content?
SELECT COUNT(film_id)
FROM film
WHERE special_features REGEXP 'Behind the Scenes';
#answer = 538

#List films ordered by release year and title in alphabetical order.
SELECT release_year, title
FROM film
ORDER BY release_year;