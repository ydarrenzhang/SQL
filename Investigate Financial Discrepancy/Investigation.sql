/*
Created by Darren Z. used SQLite
07/22/23
INTRO
Issue of missing funds. Manager of WSDA Music, has been unable to 
account for a discrepancy during the period 2011 to 2012 in his company’s financials
Analyzing WSDA Music’s Data to obtain a list of suspects, then narrow that list, then pinpoint the most suspect suspect(s)
Financial discrepancy, think about how and where money circulates in the data. What tables tables will likely contain info about people? 
Where in the database contains transactional records, what tables?
*/
----------------

/*
Look at how many transactions took place between 2011 and 2012.
Within this period how much money was made?
*/
--Note: found 167 transactions took place between 2011 and 2012(CORRECT)
SELECT
 InvoiceDate,
 BillingAddress,
 BillingCity,
 total
FROM
 Invoice
WHERE
 DATE(InvoiceDate) BETWEEN '2011-00-00' AND '2013-00-00'
ORDER BY
 InvoiceDate
 --Note: Below is instructors example of my attempt, 167 transactions using count() function
SELECT
 count(*)
FROM
 Invoice
WHERE
 InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'

 --Note: found WSDA Music made $1947.97 between 2011 and 2012(CORRECT)
SELECT
 SUM(total)
FROM
 Invoice
WHERE
 DATE(InvoiceDate) BETWEEN '2011-00-00' AND '2013-00-00'
--Instructor QUERY, same answer, slightly different methodolgy
SELECT
	sum(Total)
FROM
	Invoice
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'

----------------
/*
Now get a list of the customers who made purchases between 2011 and 2012.
Get a list of customers, sales supports/employees, and total transaction amounts for each customer between 2011 and 2012.
So how many are above the average transaction amount during this time?
Looking at the whole picture, what is the average transaction amount for each year?
*/

--Note: list of customer between 2011 and 2012
SELECT
	InvoiceId,
	InvoiceDate,
	Customer.CustomerId AS 'Customer ID',
	Customer.FirstName,
	Customer.LastName,
	total
FROM
	Invoice
INNER JOIN
	Customer
ON
	Invoice.CustomerId = Customer.CustomerId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY
	Customer.CustomerId
	
--Note: list of customers, sales supports/employees, 167 total transactions 2011-2012
SELECT
	InvoiceId,
	InvoiceDate,
	Customer.SupportRepId,
	Employee.FirstName||' '||Employee.LastName AS 'Sales Rep Full Name',
	Customer.CustomerId AS 'Customer ID',
	Customer.FirstName,
	Customer.LastName,
	Invoice.total
FROM
	Invoice
INNER JOIN
	Customer
ON
	Invoice.CustomerId = Customer.CustomerId
INNER JOIN
	Employee
ON
	Customer.SupportRepId = Employee.EmployeeId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
ORDER BY
	Customer.CustomerId
	

	
	
--Note: count that there were 26 transactions greater than average transaction amount
SELECT
	count(*)
FROM
	Invoice
WHERE
	total >
(SELECT
	avg(total)
FROM
	Invoice
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31')
AND
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
	
	
--Note: average transaction amount for each year (2009,2010,2011,2012,2013) = (5.42,5.80,17.51,5.75,5.63)
SELECT
	strftime('%Y',InvoiceDate),
	round(avg(total),2) AS 'Avg transaction'
FROM
	Invoice
GROUP BY
	strftime('%Y',InvoiceDate)
	
----------------
/*
Get list of employees exceeding average transaction based off sales generated during 2011 and 2012
Create a column to see each employee’s commission(15% of the sales transaction)
Who made highest commision? Look at their record
The corresponding customer/s?
What customer made the highest purchase?
Look at customer record
Likely suspect/s?
*/

--Note: list of employees whose sales exceed average transaction (2011-12)
SELECT
	Employee.FirstName,
	Employee.LastName,
	sum(total)
FROM
	Invoice
INNER JOIN
	Customer
ON
	Customer.CustomerId = Invoice.CustomerId
INNER JOIN
	Employee
ON
	Employee.EmployeeId = Customer.SupportRepId
WHERE
	total >
(SELECT
	avg(total)
FROM
	Invoice
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31')
AND
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
GROUP BY
	Employee.FirstName,
	Employee.LastName
ORDER BY
	Invoice.total DESC

--Note: column that displays each employee’s commission based on 15% of the sales transaction amount
SELECT
	Employee.FirstName,
	Employee.LastName,
	sum(total),
	round(sum(total)*0.15,2) AS '15% Commission'
FROM
	Invoice
INNER JOIN
	Customer
ON
	Customer.CustomerId = Invoice.CustomerId
INNER JOIN
	Employee
ON
	Employee.EmployeeId = Customer.SupportRepId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
GROUP BY
	Employee.FirstName,
	Employee.LastName
ORDER BY
	Invoice.total DESC

--Note: Jane Peacock made the highest commission
SELECT
	Customer.FirstName AS 'Customer FN',
	Customer.LastName AS 'Customer LN',
	Employee.FirstName,
	Employee.LastName,
	sum(total),
	round(sum(total)*0.15,2) AS '15% Commission'
FROM
	Invoice
INNER JOIN
	Customer
ON
	Customer.CustomerId = Invoice.CustomerId
INNER JOIN
	Employee
ON
	Employee.EmployeeId = Customer.SupportRepId
WHERE
	InvoiceDate >= '2011-01-01' AND InvoiceDate <= '2012-12-31'
AND
	Employee.FirstName = 'Jane' AND Employee.LastName = 'Peacock'
GROUP BY
	Customer.FirstName,
	Customer.LastName,
	Employee.FirstName,
	Employee.LastName
ORDER BY
	sum(total) DESC

--Note: John Doeein made highest purchase(corresponding customer)

--Note: There is no info logged for John Doeein
SELECT
	*
FROM
	Customer
WHERE
	Customer.FirstName = 'John' AND Customer.LastName = 'Doeein'

--Note: Looking at who was the sales rep for John Doeein, we see that it is Jane Peacock, therefore Jane is our primary person of interest

