USE SalesDB;

-- CTAS : create table as select
IF Object_id('sales.montlyorders', 'U') IS NOT NULL
    DROP TABLE sales.monthlyorders;


GO
SELECT   DATENAME(month, orderdate) AS OrderMonth,
         count(OrderId) AS TotalOrders
INTO     sales.MonthlyOrders
FROM     sales.orders
GROUP BY datename(month, orderdate);


GO
SELECT *
FROM   sales.MonthlyOrders;


GO
-- Temporary Tables (INTO #table_name)
SELECT *
INTO   #temp_orders
FROM   sales.orders;

DELETE #temp_orders
WHERE  OrderStatus = 'delivered';

SELECT *
FROM   #temp_orders;