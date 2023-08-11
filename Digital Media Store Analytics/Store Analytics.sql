/*
Darren Zhang
Here I analyze data working w/ a database called chinook, chinook represents a digital media store
*/

--Let's take a look at customers who are not from Canada or the USA
SELECT *
FROM chinook.customers
WHERE Country != 'Canada' --Note: can also alternatively use <> 
AND Country != 'USA';

--Now let's look at only customers from Brazil
SELECT * 
FROM chinook.customers
WHERE Country = 'Brazil';

--From these Brazil customers find their invoices w/ full name, customer id, invoice date, and billing country
SELECT CustomerId, FirstName, LastName, InvoiceDate, BillingCountry
FROM chinook.customers cust
INNER JOIN chinook.invoices inv
ON cust.CustomerId = inv.CustomerId
WHERE Country = 'Brazil';

--Now show all employees who are sales agents, and their respective info
SELECT *
FROM chinook.employees
WHERE Title = 'Sales Support Agent';

--Going back to the invoice table, let's see a distinct list of the billing countries
SELECT DISTINCT BillingCountry
FROM chinook.invoices;

--Now I'll query to show the invoices associated w/ each sales agent(full name) with corresponding customers(full name), country and the invoice total
SELECT e.EmployeeId, e.FirstName||' '||e.LastName AS 'Sales Agent', c.FirstName||' '||c.LastName AS 'Customer', i.BillingCountry, i.Total AS 'Invoice Total'
FROM chinook.employees e
LEFT INNER JOIN chinook.customers c
ON c.SupportRepId = e.EmployeeId
LEFT INNER JOIN chinook.invoices i
ON i.CustomerId = c.CustomerId
WHERE e.Title = 'Sales Support Agent';

--How many invoices were there in 2009?
SELECT COUNT(*)
FROM chinook.invoices
WHERE InvoiceDate LIKE '2009-%-%';

--Total sales for 2009?
SELECT ROUND(SUM(Total), 2)
FROM chinook.invoices
WHERE InvoiceDate LIKE '2009-%-%';

--Now let's query for purchased tracks(their name) and their invoice id
SELECT Title, InvoiceId
FROM chinook.albums album
INNER JOIN chinook.invoice_items ii
ON ii.TrackId = album.AlbumId;

--Now let's query to examine total sales of each sales agent
SELECT e.FirstName, e.LastName, round(SUM(i.Total), 2) AS total_sales
FROM chinook.employees e
INNER JOIN chinook.customers c
ON c.SupportRepId = e.EmployeeId
INNER JOIN chinook.invoices i
ON i.CustomerId = c.CustomerId
GROUP BY e.FirstName;

--Now look at the total sales for each agent in 2009 to see who made the most
SELECT e.FirstName, e.LastName, round(SUM(i.Total), 2) AS total_sales_2019
FROM chinook.employees e
INNER JOIN chinook.customers c
ON c.SupportRepId = e.EmployeeId
INNER JOIN chinook.invoices i
ON i.CustomerId = c.CustomerId
WHERE InvoiceDate LIKE '2009-%-%%'
GROUP BY e.FirstName
ORDER BY total_sales_2019 DESC;
