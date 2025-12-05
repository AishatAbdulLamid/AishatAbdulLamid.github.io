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
SELECT customer.cust_ID, depositor.account_number,
borrower.loan_number FROM customer
JOIN depositor ON customer.cust_ID = depositor.cust_ID
JOIN borrower ON customer.cust_ID = borrower.cust_ID
ORDER BY cust_ID;
			
					/*Query 2*/
SELECT customer.cust_ID, customer.customer_city,
branch.branch_name, branch.branch_city,
account.account_number FROM customer
JOIN depositor ON customer.cust_ID = depositor.cust_ID
JOIN account ON depositor.account_number = account.account_number
JOIN branch ON account.branch_name = branch.branch_name
WHERE customer.customer_city = branch.branch_city;

					/*Query 3*/
SELECT customer.cust_ID, customer.customer_name FROM customer
WHERE customer.cust_ID = (SELECT customer.cust_ID FROM borrower
EXCEPT
SELECT depositor.cust_ID FROM depositor)
ORDER BY cust_ID;


SELECT DISTINCT branch.branch_name FROM branch
JOIN account ON branch.branch_name = account.branch_name
JOIN depositor ON account.account_number = depositor.account_number
JOIN customer ON depositor.cust_ID = customer.cust_ID
WHERE customer.customer_city = 'Harrison';

SELECT cust_ID, customer_name FROM customer
WHERE (customer_street, customer_city) IN
(SELECT customer_street, customer_city
FROM customer WHERE cust_ID = '12345')
EXCEPT
SELECT cust_ID, customer_name FROM customer
WHERE cust_ID = '12345'
ORDER BY cust_ID;
