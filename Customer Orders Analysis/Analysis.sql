--initial look at customer database
SELECT * FROM BIT_DB.customers;
/*
Darren Z
08/02/23
double clicking on order_id we see that there are issues with data
make note of incorrect data, plan around it
look at January and Febuary sales
*/
-----
SELECT * FROM BIT_DB.customers
WHERE length(order_id) = 6 
AND order_id <> 'Order ID' 
AND order_id <> ''
AND order_id IS NOT NULL;

--Wont to get count of January Sales but first look at the data
SELECT * FROM BIT_DB.JanSales;
--Note: there is missing data and irrelavant filled rows, work around, filter out issues in table
SELECT COUNT(*) FROM BIT_DB.JanSales
WHERE length(orderID) = 6
AND orderID <> 'Order ID' -- Note: in this instance it is redundant b/c length('Order ID') > 6
AND orderID <> ''
AND orderID IS NOT NULL;
--there is 9681 sales

--Now look at how many of these orders were for an iPhone
SELECT COUNT(*) FROM BIT_DB.JanSales
WHERE Product = "iPhone"
AND length(orderID) = 6
AND orderID <> 'Order ID' -- Note: in this instance it is redundant b/c length('Order ID') > 6
AND orderID <> ''
AND orderID IS NOT NULL;
--379 sales were iPhones

--What is the cheapest sold item in Jan?
SELECT DISTINCT Product, MIN(price) FROM BIT_DB.JanSales --Note: DISTINCT compares the ENTIRE rows, not just the individual values of a specific column therefore it comes right after SELECT
ORDER BY price;
--4-pack AAA Batteries

--Total revenue for each product sold in Jan
SELECT ROUND(SUM(Quantity)*price,2) AS total_revenue, Product FROM BIT_DB.JanSales
WHERE Product <> ''
AND Product <> 'Product'
GROUP BY Product;

--Let's select all the customer accounts numbers for orders placed in Feb
SELECT c.acctnum,febsale.orderdate FROM BIT_DB.customers c
INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE c.acctnum <> '';
--WHERE DATE(orderdate) BETWEEN "01/31/19" AND "03/01/19";

--What was sold at 548 Lincoln Street, Seattle, WA 98101 in Feb? Total Revenue?
SELECT Product, Quantity, SUM(Quantity)*price AS total_revenue FROM BIT_DB.FebSales
WHERE location = "548 Lincoln St, Seattle, WA 98101"
GROUP BY Product;
--4-pack AA Batteries * 2 = $7.68

--look into how many customers ordered multiple of an item(2 or more quantity) during Feb and how much they each spent on avg (*examine the quantity)
SELECT COUNT(c.acctnum)FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity >= 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';
--1175 customers ordered multiple of item

SELECT c.acctnum, Quantity, (Quantity*price)/Quantity AS avg_spent FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity >= 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';
--how much each customer spent on avg given they bought multiple quantities

--look into how many customers ordered more that 2 quantity during Feb and how much they COLLECTIVELY spent on avg (WRONG)
SELECT COUNT(DISTINCT c.acctnum), ROUND(AVG(Quantity*price),2) AS avg_spent FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity > 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';

