CREATE DATABASE banking;

CREATE TABLE branch(branch_name varchar(40) PRIMARY KEY,
	branch_city varchar(40) CHECK(branch_city 
		IN('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers')),
	assets MONEY NOT NULL CHECK(assets >= '0.00' :: MONEY)
);


CREATE TABLE customer(cust_ID varchar(40) PRIMARY KEY, 
	customer_name varchar(40) NOT NULL,
	customer_street varchar(40) NOT NULL,
	customer_city varchar(40)
);


CREATE TABLE loan(loan_number varchar(40) PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch(branch_name)
		ON UPDATE CASCADE ON DELETE CASCADE,
	amount MONEY NOT NULL DEFAULT '0.00' :: MONEY 
		CHECK(amount >= '0.00' :: MONEY)
);


CREATE TABLE borrower(
	cust_ID varchar(40) REFERENCES customer(cust_ID)
		ON UPDATE CASCADE ON DELETE CASCADE,
	loan_number varchar(40) REFERENCES loan(loan_number)
		ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (cust_ID, loan_number)
);


CREATE TABLE account(account_number varchar(40) PRIMARY KEY, 
	branch_name varchar(40) REFERENCES branch(branch_name)
		ON UPDATE CASCADE ON DELETE CASCADE, 
	balance MONEY NOT NULL DEFAULT '0.00' :: MONEY 
		CHECK(balance >= '0.00' :: MONEY)
);


CREATE TABLE depositor(
	cust_ID varchar(40) REFERENCES customer(cust_ID)
		ON UPDATE CASCADE ON DELETE CASCADE, 
	account_number varchar(40) REFERENCES account(account_number)
		ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (cust_ID, account_number)
);


SELECT * FROM customer;

					/*Query 1*/
/*Write a query to find all customers who have at least one loan and one deposit 
account. Include the cust_ID, account_number, and loan_number in your results and 
organize the results by cust_id. Note: Some customers may appear multiple times 
due to having multiple loans or deposit accounts and that is ok. Your solution 
must include a JOIN.*/

SELECT customer.cust_ID, depositor.account_number,
borrower.loan_number FROM customer
JOIN depositor ON customer.cust_ID = depositor.cust_ID
JOIN borrower ON customer.cust_ID = borrower.cust_ID
ORDER BY cust_ID;
			
					/*Query 2*/
/*Write a query that identifies all customers who have a deposit account in the 
same city in which they live. The results should include the cust_id, customer_city, 
branch_name, branch_city, and account_number. Note: The city of a deposit account 
is the city where its branch is located. Your solution must use a JOIN.*/

SELECT customer.cust_ID, customer.customer_city,
branch.branch_name, branch.branch_city,
account.account_number FROM customer
JOIN depositor ON customer.cust_ID = depositor.cust_ID
JOIN account ON depositor.account_number = account.account_number
JOIN branch ON account.branch_name = branch.branch_name
WHERE customer.customer_city = branch.branch_city;

					/*Query 3*/
/*Write a query that returns the cust_ID and customer_name of customers who 
hold at least one loan with the bank, but do not have any deposit accounts. 
Organize your output by cust_id. Your solution must use a subquery and a SET 
operator.*/

SELECT customer.cust_ID, customer.customer_name FROM customer
WHERE customer.cust_ID = (SELECT customer.cust_ID FROM borrower
EXCEPT
SELECT depositor.cust_ID FROM depositor)
ORDER BY cust_ID;

					/*Query 4*/
/*Write a query to retrieve a list of branch_names for every branch that has 
at least one customer living in 'Harrison' that has a deposit account with them. 
Branch names should not be duplicated. Organize your results alphabetically. 
Your solution must include a JOIN.*/

SELECT DISTINCT branch.branch_name FROM branch
JOIN account ON branch.branch_name = account.branch_name
JOIN depositor ON account.account_number = depositor.account_number
JOIN customer ON depositor.cust_ID = customer.cust_ID
WHERE customer.customer_city = 'Harrison';

					/*Query 5*/
/*Write a query to obtain the cust_ID and customer_name for all customers 
residing at the same customer_street address and in the same customer_city as 
customer '12345'. Exclude customer '12345' in the results and organize the 
results by cust_id. Avoid hardcoding the address for customer '12345' as their 
information might change. Your solution must include a subquery and SET operator.*/

SELECT cust_ID, customer_name FROM customer
WHERE (customer_street, customer_city) IN
(SELECT customer_street, customer_city
FROM customer WHERE cust_ID = '12345')
EXCEPT
SELECT cust_ID, customer_name FROM customer
WHERE cust_ID = '12345'
ORDER BY cust_ID;