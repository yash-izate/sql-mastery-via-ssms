USE SalesDB;

SELECT *
FROM   sales.Orders;

SELECT   orderid,
         sales,
         CASE WHEN sales > 50 THEN 'High' WHEN sales > 20 THEN 'Medium' ELSE 'low' END AS sales_category
FROM     sales.Orders
ORDER BY sales;

SELECT   category,
         sum(sales) AS total_sales
FROM     (SELECT orderid,
                 sales,
                 CASE WHEN sales > 50 THEN 'High' WHEN sales > 20 THEN 'Medium' ELSE 'low' END AS category
          FROM   sales.Orders) AS t
GROUP BY category
ORDER BY total_sales DESC;

