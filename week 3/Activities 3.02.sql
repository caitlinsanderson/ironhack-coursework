##--- Activities 3.02 ---##

##--- Activity 3.02.1 ---##
#Use the below query and list district_name, client_id and account_id for those clients who are owner of the account. 
	#Order the results by district_name:

select da.A2 AS District, c.client_id, d.account_id 
from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.district da
on da.A1 = c.district_id
WHERE d.type = 'OWNER'
ORDER BY da.A2;

##--- Activity 3.02.2 ---##
#List districts together with total amount borrowed and average loan amount.

SELECT d.A2 AS District, FORMAT(SUM(l.amount),2) AS TotalBorrowed, FORMAT(ROUND(AVG(l.amount),2),2) AS AvgLoan
FROM bank.district AS d
LEFT JOIN bank.account AS a 
	ON d.A1 = a.district_id
LEFT JOIN bank.loan AS l USING(account_id)
GROUP BY d.A2;

##--- Activity 3.02.3 ---##
#Create a temporary table district_overview in the bank database which lists districts together with total amount borrowed 
	#and average loan amount.

DROP TEMPORARY TABLE district_overview;

CREATE TEMPORARY TABLE district_overview
(
	district_name VARCHAR(50),
	total_borrowed int,
	avg_borrowed int

);

INSERT INTO district_overview
SELECT d.A2 AS District, SUM(l.amount) AS TotalBorrowed, AVG(l.amount) AS AvgLoan
FROM bank.district AS d
LEFT JOIN bank.account AS a 
	ON d.A1 = a.district_id
LEFT JOIN bank.loan AS l USING(account_id)
GROUP BY d.A2;

##--- Activity 3.02.4 ---##
#list the clients with no credit card
SELECT c.client_id, ca.card_id
FROM bank.client as C
LEFT JOIN bank.disp as D USING(client_id)
LEFT JOIN bank.card as CA USING(disp_id)
WHERE ca.card_id IS NULL;


