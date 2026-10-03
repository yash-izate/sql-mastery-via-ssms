USE SalesDB;


GO
-- NOW Dynamic Stored Procedure using Variables and If-Else
CREATE OR ALTER PROCEDURE GetCustomerSummary3
    @Country NVARCHAR (50)
AS
BEGIN
    BEGIN TRY
        DECLARE @TotalCustomers AS INT, @AvgScore AS FLOAT;
        -- prepare & cleanup 
        IF EXISTS (SELECT 1
                   FROM   sales.Customers
                   WHERE  score IS NULL
                          AND country = @Country)
            BEGIN
                PRINT ('Updating null scores to 0');
                UPDATE sales.Customers
                SET    score = 0
                WHERE  score IS NULL
                       AND country = @Country;
            END
        ELSE
            BEGIN
                PRINT ('No null found');
            END
        -- Generating report 1
        SELECT @TotalCustomers = count(*),
               @AvgScore = avg(score)
        FROM   sales.Customers
        WHERE  country = @Country;
        PRINT 'Total Customers from ' + @Country + ': ' + CAST (@TotalCustomers AS NVARCHAR);
        PRINT 'Average Score from ' + @Country + ': ' + CAST (@AvgScore AS NVARCHAR);
        -- Generate Report 2 
        SELECT count(orderID) AS TotalOrders,
               Sum(Sales) AS TotalSales,
               1 / 0
        FROM   sales.Orders AS o
               INNER JOIN
               sales.Customers AS c
               ON o.CustomerID = c.CustomerID;
    END TRY
    BEGIN CATCH
        PRINT ('An error occured.');
        PRINT ('Error Message: ' + ERROR_MESSAGE());
        PRINT ('Error Number: ' + CAST (ERROR_NUMBER() AS NVARCHAR));
        PRINT ('Error Line: ' + CAST (ERROR_LINE() AS NVARCHAR));
        PRINT ('Error Procedure ' + ERROR_PROCEDURE());
    END CATCH
END


GO
-- execute the stored procedure
EXECUTE GetCustomerSummary3 @Country = 'Germany';

EXECUTE GetCustomerSummary3 @Country = 'USA';
