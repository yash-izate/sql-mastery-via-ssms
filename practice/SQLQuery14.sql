-- CREATE DATABASE TrySQL;
--USE trysql;
--CREATE TABLE Orders2 (
--    OrderID INT,
--    Customer VARCHAR (20),
--    OrderDate DATE,
--    Sales INT
--);
--INSERT  INTO Orders2
--VALUES (1, 'A', '2026-01-01', 1000),
--(2, 'A', '2026-01-05', 200),
--(3, 'A', '2026-01-10', 300),
--(4, 'B', '2026-01-02', 1500),
--(5, 'B', '2026-01-08', 400);
--SELECT *
--FROM   Orders2;
--SELECT *
--FROM TrySQL.dbo.Orders2;
SELECT OrderID,
       Customer,
       Sales,
       SUM(Sales) OVER () AS Total_Sales
FROM   Orders2;

SELECT OrderID,
       Customer,
       Sales,
       SUM(Sales) OVER (PARTITION BY customer) AS Sales_Per_Customer
FROM   Orders2;

SELECT OrderID,
       Customer,
       Sales,
       SUM(Sales) OVER (partition by customer order by orderid) AS Sales_Per_Customer
FROM   Orders2;


SELECT OrderID,
       Customer,
       Sales,
       Rank() OVER (order by sales) AS Sales_Rank
FROM   Orders2;


SELECT OrderID,
       Customer,
       Sales,
       row_number() OVER (PARTITION BY customer order by sales desc) AS Sales_Per_Customer
FROM   Orders2;

SELECT OrderID,
       Customer,
       Sales,
       row_number() OVER (PARTITION BY customer order by sales desc) AS row_number
FROM   Orders2;