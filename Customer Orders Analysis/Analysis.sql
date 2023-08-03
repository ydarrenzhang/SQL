/*
Darren Z
08/02/23
Notes:
-done in SQLite Studio
-double clicking on order_id we see that there are issues with data
-make note of incorrect data, plan around it
-look at January and Febuary sales
*/

--Take a initial look at the customer database
SELECT * 
FROM BIT_DB.customers;

--Taking another look at customer database planning around issues w/ data
SELECT * 
FROM BIT_DB.customers
WHERE length(order_id) = 6 
AND order_id <> 'Order ID' 
AND order_id <> ''
AND order_id IS NOT NULL;

--Get a count of Jan sales but first look at the data
SELECT * 
FROM BIT_DB.JanSales;

--Count of Jan sales. Note: there is missing data and irrelavant filled rows, work around, filter out issues in table
SELECT COUNT(*) 
FROM BIT_DB.JanSales
WHERE length(orderID) = 6
AND orderID <> 'Order ID' --Note: filtering out 'Order ID' would be redundant given above (line 26) as orderID in this case is expected to always have 6 characters
AND orderID <> ''
AND orderID IS NOT NULL;
--there is 9681 sales

--Look at how many of these orders were for an iPhone
SELECT COUNT(*) 
FROM BIT_DB.JanSales
WHERE Product = "iPhone"
AND length(orderID) = 6
AND orderID <> ''
AND orderID IS NOT NULL;
--379 sales were iPhones

--What is the cheapest sold item in Jan?
SELECT DISTINCT Product, MIN(price) --Note: DISTINCT compares ENTIRE rows, not just individual values of a specific column therefore it comes right after SELECT
FROM BIT_DB.JanSales 
ORDER BY price;
--4-pack AAA Batteries

--Get a total revenue for each product sold in Jan
SELECT ROUND(SUM(Quantity)*price,2) AS total_revenue, Product 
FROM BIT_DB.JanSales
WHERE Product <> ''
AND Product <> 'Product'
GROUP BY Product;

--Let's view all the customer account numbers for orders placed in Feb
SELECT c.acctnum, febsale.orderdate 
FROM BIT_DB.customers c
INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE c.acctnum <> '';

--What was sold at 548 Lincoln Street, Seattle, WA 98101 in Feb? Total Revenue from that?
SELECT Product, Quantity, SUM(Quantity)*price AS total_revenue 
FROM BIT_DB.FebSales
WHERE location = "548 Lincoln St, Seattle, WA 98101"
GROUP BY Product;
--4-pack AA Batteries * 2 = $7.68

--Look into how many customers ordered multiple of an item(2 or more quantity) during Feb 
SELECT COUNT(c.acctnum)
FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity >= 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';
--1175 customers ordered multiple of item

--Look into how much they each spent on avg given they bought 2 or more in quanitity
SELECT c.acctnum, Quantity, (Quantity*price)/Quantity AS avg_spent 
FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity >= 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';

--Now how many customers ordered more than 2 quantity during Feb and how much they all COLLECTIVELY spent on avg?
SELECT COUNT(DISTINCT c.acctnum), ROUND(AVG(Quantity*price),2) AS avg_spent 
FROM BIT_DB.customers c
LEFT INNER JOIN BIT_DB.FebSales febsale ON febsale.orderID = c.order_id
WHERE Quantity > 2
AND Quantity <> 'Quantity Ordered'
AND c.acctnum <> '';

