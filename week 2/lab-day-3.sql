##---DAY 3 (28.10.2020) ---##
#---Lab SQL Queries 5---##

USE sakila;

#Drop column picture from staff.
ALTER TABLE staff DROP COLUMN picture;

#A new person is hired to help Jon. 
#Her name is TAMMY SANDERS, and she is a customer. 
#Update the database accordingly
INSERT INTO staff VALUES (3,'Tammy','Sanders',79,'Tammy.Sanders@sakilacustomer.org',2,1,'Tammy',NULL,'2006-02-15 03:57:16');

#Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.
INSERT INTO rental VALUES (16050,'2020-10-28 14:46:31',3,130,NULL,1,'2020-10-28 14:46:31');

DROP TABLE IF EXISTS deleted_users;
#Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date the user was deleted.
CREATE TABLE IF NOT EXISTS deleted_users(
deleted_users_id INT UNIQUE NOT NULL AUTO_INCREMENT,
customer_id INT UNIQUE NOT NULL,
email VARCHAR(50),
date_deleted TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT PRIMARY KEY (deleted_users_id)
);

INSERT INTO deleted_users (customer_id, email)
	SELECT customer_id, email
    FROM customer
    WHERE active = 0;
    
DELETE FROM customer WHERE active = 0;

Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`payment`, CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE)

create table deleted_user2
select customer_id, email,create_date from customer where active=0;



