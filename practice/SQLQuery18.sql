USE salesdb;


GO
CREATE VIEW Sales.Monthly_Summary
AS
(SELECT   DATETRUNC(month, orderdate) AS OrderMonth,
          Sum(sales) AS TotalSales,
          Count(orderid) AS TotalOrders,
          Sum(Quantity) AS TotalQuantity
 FROM     sales.Orders
 GROUP BY DATETRUNC(MONTH, ORDERDATE));


GO
SELECT *
FROM   Sales.Monthly_Summary;

DROP VIEW sales.Monthly_Summary;


GO
IF OBJECT_ID('Sales. V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;


GO
CREATE VIEW Sales.V_Monthly_Summary
AS
(SELECT   DATETRUNC(month, OrderDate) AS OrderMonth,
          SUM(Sales) AS TotalSales,
          COUNT(OrderID) AS TotalOrders
 FROM     Sales.Orders
 GROUP BY DATETRUNC(month, OrderDate));


GO
SELECT *
FROM   sales.V_Monthly_Summary;