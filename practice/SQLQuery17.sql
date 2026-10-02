
USE SalesDB;


GO
WITH     CustomerTotalSales
AS       (-- Calculate total sales for each customer
          SELECT   CustomerID,
                   SUM(Sales) AS TotalSales
          FROM     Sales.Orders
          GROUP BY CustomerID),
         CustomerLastOrder
AS       (-- Find the most recent order date for each customer
          SELECT   CustomerID,
                   MAX(OrderDate) AS LastOrderDate
          FROM     Sales.Orders
          GROUP BY CustomerID),
         CustomerSalesRanking
AS       (-- Rank customers by total sales, highest first
          SELECT CustomerID,
                 TotalSales,
                 RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
          FROM   CustomerTotalSales),
         CustomerSalesSegmentation
AS       (-- Segementation by total sales
          SELECT customerid,
                 TotalSales,
                 CASE WHEN totalsales > 100 THEN 'High' WHEN totalsales > 50 THEN 'Medium' ELSE 'Low' END AS Category
          FROM   CustomerTotalSales)
SELECT   C.CustomerID,
         CONCAT(C.FirstName, ' ', C.LastName) AS FullName,
         CTS.TotalSales,
         CLO.LastOrderDate,
         CSR.SalesRank,
         CSS.Category
FROM     Sales.Customers AS C
         LEFT OUTER JOIN
         CustomerTotalSales AS CTS
         ON C.CustomerID = CTS.CustomerID
         LEFT OUTER JOIN
         CustomerLastOrder AS CLO
         ON C.CustomerID = CLO.CustomerID
         LEFT OUTER JOIN
         CustomerSalesRanking AS CSR
         ON C.CustomerID = CSR.CustomerID
         LEFT OUTER JOIN
         CustomerSalesSegmentation AS CSS
         ON C.CustomerID = CSS.CustomerID
ORDER BY CTS.TotalSales DESC;

-- recursive query
WITH   NumberSeries
AS     (-- 1. Anchor member: starting point
        SELECT 1 AS Number
        UNION ALL
        -- 2. Recursive member: generates the next number
        SELECT Number + 1
        FROM   NumberSeries
        WHERE  Number < 10)
SELECT Number
FROM   NumberSeries
OPTION (
    MAXRECURSION 10
);