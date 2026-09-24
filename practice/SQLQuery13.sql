USE SalesDB;

SELECT orderid,
       orderdate,
       orderstatus,
       sales,
       sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate DESC) AS totalsales
FROM   sales.Orders;

SELECT orderid,
       customerid,
       sales,
       sum(sales) OVER (PARTITION BY customerid) AS customer_total,
       avg(sales) OVER (PARTITION BY customerid) AS customer_avg,
       max(sales) OVER (PARTITION BY customerid) AS customer_max
FROM   sales.Orders;

SELECT orderid,
       sales,
       sum(sales) OVER (ORDER BY orderid ROWS UNBOUNDED PRECEDING) as total_sales
FROM   sales.Orders;
