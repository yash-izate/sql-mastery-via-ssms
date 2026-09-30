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

SELECT orderid,
       productid,
       orderdate,
       sales,
       sum(sales) OVER () AS total_sales,
       sum(sales) OVER (PARTITION BY productid) AS sales_per_product
FROM   sales.Orders;

SELECT orderid,
       productid,
       orderdate,
       sales,
       sum(sales) OVER (PARTITION BY productid) AS sales_per_product,
       sum(sales) OVER () AS total_sales,
       ((sum(sales) OVER (PARTITION BY productid)) * 100.0 / (sum(sales) OVER ())) AS percentage_sales
FROM   sales.Orders;

SELECT orderid,
       productid,
       orderdate,
       sales,
       sum(sales) OVER () AS total_sales,
       concat (
           round (
               CAST (sales AS FLOAT) * 100 / sum (sales) OVER (),
               2
           ),
           '%'
       ) AS percentage_sales
FROM   sales.Orders;

SELECT productid,
       sales,
       avg(sales) OVER (PARTITION BY productid) AS avg_sales_by_products
FROM   sales.Orders;

SELECT orderid,
       orderdate,
       productid,
       sales,
       avg(COALESCE (sales, 0)) OVER () AS total_avg,
       avg(COALESCE (sales, 0)) OVER (PARTITION BY productid) AS avg_by_product
FROM   sales.Orders;

SELECT *
FROM   (SELECT productid,
               sales,
               avg(sales) OVER () AS avg_sales
        FROM   sales.Orders) AS t
WHERE  sales > avg_sales;

SELECT orderid,
       productid,
       orderdate,
       sales,
       max(sales) OVER (PARTITION BY productid) AS HigestSalesByProduct,
       min(sales) OVER (PARTITION BY productid) AS LowestSalesByProduct
FROM   sales.Orders;

SELECT *
FROM   (SELECT employeeid,
               concat(firstname, lastname) AS Name,
               department,
               salary,
               max(salary) OVER () AS HigestSalary
        FROM   sales.Employees) AS t
WHERE  salary = HigestSalary;

SELECT orderid,
       productid,
       orderdate,
       sales,
       max(sales) OVER (PARTITION BY productid) AS HigestSalesByProduct,
       min(sales) OVER (PARTITION BY productid) AS LowestSalesByProduct,
       avg(sales) OVER () AS avg_sales,
       sales - avg(sales) OVER () AS deviation_From_Mean,
       stdev(sales) OVER () AS standard_deviation_fun,
       var(sales) OVER () AS variance
FROM   sales.Orders;

SELECT orderid,
       productid,
       orderdate,
       sales,
       avg(sales) OVER (PARTITION BY productid) AS avg_product,
       avg(sales) OVER (PARTITION BY productid ORDER BY orderdate ASC) AS moving_avg
FROM   sales.Orders;

SELECT orderid,
       productid,
       orderdate,
       sales,
       avg(sales) OVER (PARTITION BY productid) AS avg_product,
       avg(sales) OVER (PARTITION BY productid ORDER BY orderdate ASC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAVG_NextOrderOnly
FROM   sales.Orders;

SELECT orderid,
       productid,
       sales,
       row_number() OVER (ORDER BY sales DESC) AS rank_using_unique_row_number,
       rank() OVER (ORDER BY sales DESC) AS shared_ranks_with_gaps,
       DENSE_RANK() OVER (ORDER BY sales DESC) AS shared_ranks_no_gaps
FROM   sales.orders;

SELECT orderid,
       productid,
       sales,
       rank() OVER (PARTITION BY productid ORDER BY sales DESC) AS RankByProduct
FROM   sales.orders;

SELECT *
FROM   (SELECT orderid,
               productid,
               sales,
               rank() OVER (PARTITION BY productid ORDER BY sales DESC) AS RankByProduct
        FROM   sales.orders) AS t
WHERE  RankByProduct <= 3;

SELECT orderid,
       CustomerID,
       sales,
       sum(sales) OVER (PARTITION BY customerid) AS sales_per_customer
FROM   sales.orders;

SELECT *,
       dense_rank() OVER (ORDER BY sales_per_customer) AS unshared_rank
FROM   (SELECT orderid,
               CustomerID,
               sales,
               sum(sales) OVER (PARTITION BY customerid) AS sales_per_customer
        FROM   sales.orders) AS t;

SELECT DISTINCT *,
                dense_rank() OVER (ORDER BY sales_per_customer) AS unshared_rank
FROM   (SELECT orderid,
               CustomerID,
               sales,
               sum(sales) OVER (PARTITION BY customerid) AS sales_per_customer
        FROM   sales.orders) AS t;

SELECT   customerid,
         sum(sales) AS sales
FROM     sales.Orders
GROUP BY customerid;

SELECT   customerid,
         sum(sales) AS totalSales,
         row_number() OVER (ORDER BY sum(sales)) AS RankCustomers
FROM     sales.Orders
GROUP BY CustomerID;

SELECT *
FROM   (SELECT   customerid,
                 sum(sales) AS totalSales,
                 row_number() OVER (ORDER BY sum(sales)) AS RankCustomers
        FROM     sales.Orders
        GROUP BY CustomerID) AS t
WHERE  rankcustomers <= 2;

SELECT ROW_NUMBER() OVER (PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
       *
FROM   sales.OrdersArchive;

SELECT *
FROM   (SELECT ROW_NUMBER() OVER (PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
               *
        FROM   sales.OrdersArchive) AS t
WHERE  rn = 1;

SELECT *
FROM   (SELECT ROW_NUMBER() OVER (PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
               *
        FROM   sales.OrdersArchive) AS t
WHERE  rn > 1;

SELECT orderid,
       sales,
       ntile(3) OVER (ORDER BY sales DESC) AS category
FROM   sales.orders;

SELECT *,
       CASE 
       WHEN category = 1 THEN 'high' 
       WHEN category = 2 THEN 'medium' 
       WHEN category = 3 THEN 'low' 
       END AS categorylevel
FROM   (SELECT orderid,
               sales,
               ntile(3) OVER (ORDER BY sales DESC) AS category
        FROM   sales.orders) AS t;