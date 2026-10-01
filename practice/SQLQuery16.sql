USE salesdb;

SELECT productid,
       price
FROM   sales.Products;

SELECT avg(price) AS avg_price
FROM   sales.Products;

SELECT *
FROM   (SELECT productid,
               price
        FROM   sales.Products) AS t1, (SELECT avg(price) AS avg_price
                                       FROM   sales.Products) AS t2
WHERE  price > avg_price;

SELECT *
FROM   sales.Products
WHERE  price > (SELECT avg(price)
                FROM   sales.Products);

SELECT *
FROM   sales.orders;

SELECT customerid,
       sales,
       sum(sales) OVER (PARTITION BY customerid) AS total_sales
FROM   sales.Orders;

SELECT *,
       dense_rank() OVER (ORDER BY total_sales) AS ranks
FROM   (SELECT customerid,
               sales,
               sum(sales) OVER (PARTITION BY customerid) AS total_sales
        FROM   sales.Orders) AS t;

SELECT   customerid,
         sum(sales) AS total_sales
FROM     sales.Orders
GROUP BY CustomerID;

SELECT *,
       dense_rank() OVER (ORDER BY total_sales) AS ranking
FROM   (SELECT   customerid,
                 sum(sales) AS total_sales
        FROM     sales.Orders
        GROUP BY CustomerID) AS t;