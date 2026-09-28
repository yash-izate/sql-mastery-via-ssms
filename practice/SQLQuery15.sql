USE SalesDB;

SELECT *
FROM   sales.Products;

SELECT p.productid,
       p.Category,
       p.product,
       count(p.category) OVER (PARTITION BY p.category) AS category_count
FROM   sales.Products AS p;

SELECT *
FROM   sales.Orders;

SELECT orderid,
       productid,
       quantity,
       sales
FROM   sales.Orders;

SELECT orderid,
       productid,
       quantity,
       sales,
       sum(sales) OVER (PARTITION BY productid) AS order_count
FROM   sales.Orders;

SELECT customerid,
       orderid,
       orderdate,
       quantity,
       sales,
       count(orderid) OVER (PARTITION BY customerid)
FROM   sales.Orders;

SELECT customerid,
       firstname,
       lastname,
       country,
       score,
       count(*) OVER () AS total_customer,
       count(score) OVER () AS total_scores,
       count(country) OVER () AS total_country
FROM   sales.Customers;
