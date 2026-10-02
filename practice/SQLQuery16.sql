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
       dense_rank() OVER (ORDER BY total_sales DESC) AS ranking
FROM   (SELECT   customerid,
                 sum(sales) AS total_sales
        FROM     sales.Orders
        GROUP BY CustomerID) AS t1;

SELECT t1.customerid,
       t2.names,
       t1.total_sales,
       dense_rank() OVER (ORDER BY total_sales DESC) AS ranking
FROM   (SELECT   customerid,
                 sum(sales) AS total_sales
        FROM     sales.Orders
        GROUP BY CustomerID) AS t1
       INNER JOIN
       (SELECT *,
               concat(firstname, ' ', lastname) AS names
        FROM   sales.Customers) AS t2
       ON t1.CustomerID = t2.customerid;

SELECT *
FROM   sales.Orders
WHERE  customerid IN (SELECT customerid
                      FROM   sales.Customers
                      WHERE  country = 'germany');

SELECT *
FROM   sales.Orders
WHERE  customerid IN (SELECT customerid
                      FROM   sales.Customers
                      WHERE  country != 'germany');

SELECT *
FROM   sales.Orders
WHERE  customerid NOT IN (SELECT customerid
                          FROM   sales.Customers
                          WHERE  country = 'germany');