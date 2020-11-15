##--- Activities 3.01 ---##
USE bank;
##--- Activity 3.01.1 ---###
#Get the number of clients by district, returning district name.
SELECT d.A2, COUNT(c.client_id) AS TotalClients
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A2
ORDER BY d.A2;

#Are there districts with no clients? 
	#NO - all districts have some clients
SELECT d.A2, COUNT(c.client_id) AS TotalClients 
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A2
ORDER BY TotalClients ASC;

#Move all clients from Strakonice to a new district with district_id = 100. 
INSERT INTO bank.district (A1, A2)
VALUES ('100', 'district 100');

UPDATE
    bank.client
SET
    district_id = REPLACE(district_id,'20','100')
WHERE
    district_id IS NOT NULL;

	#Check again. Hint: In case you have some doubts, you can check here how to use the update statement.
SELECT d.A2, COUNT(c.client_id) AS TotalClients 
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A2
ORDER BY TotalClients ASC;   
    
#How would you spot clients with wrong or missing district_id?
#You should do a right join with the client table to get any clients that do not have district_ids or incorrect ids

#Return clients to Strakonice.
UPDATE
    bank.client
SET
    district_id = REPLACE(district_id,'100','20')
WHERE
    district_id IS NOT NULL;

DELETE FROM bank.district 
WHERE A1='100';

SELECT d.A2, COUNT(c.client_id) AS TotalClients 
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A2
ORDER BY TotalClients ASC;  


##--- Activity 3.01.2 ---##
#Keep working on the bank database. Identify relationship degrees in our database.
#The Account Table has a one-to-many relationsthip with the Loan, Order, and Transaction tables.  
	#It has a many-to-one relationship with the District and Dispositions tables. 
#The Card Table has a one-to-one relationship with the Disposition Table
#The Client Table has a one-to-many relationship with tables except the District table, with which it has a 
	#many-to-one relationship
#The Disposition Table has a one-to-one relationship with the Client and Card tables. 
	#It has a many-to-one relationship with the Account table. 
#The District Table has a many-to-one relationship with the Client and Account tables. 
#The Loan Table has a many-to-one relationship with the Account Table
#The Order Table has a many-to-one relationship with the Account Table
#The Transaction Table has a many-to-one relationship with the Account Table


##--- Activity 3.01.3 ---##
#Look at the ER diagram and identify PK and FK. (ORDER table)
#PK = order_id
#FK = account_id

##--- Activity 3.01.4 ---##
#Make a list of all the clients together with region and district, ordered by region and district.
SELECT d.A3 AS Region, d.A2 AS District, c.client_id 
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
ORDER BY Region, District;

#Count how many clients do we have per region and district.
SELECT d.A3 AS Region, d.A2 AS District, COUNT(c.client_id) AS TotalClients 
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A3, d.A2
ORDER BY Region, District;

#2.1 How many clients do we have per 10000 inhabitants?
SELECT d.A3 AS Region, d.A2 AS District, COUNT(c.client_id) AS TotalClients, 
(COUNT(c.client_id)/d.A4)*10000 AS ClientsPer10K
FROM bank.district AS d
LEFT JOIN bank.client AS c
	ON c.district_id = d.A1
GROUP BY d.A3, d.A2, d.A4
ORDER BY Region, District;