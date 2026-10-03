USE SalesDB;


GO
-- stored procedures
CREATE PROCEDURE GetCustomerSummary1
AS
BEGIN
    SELECT count(*) AS TotalCustomers,
           avg(score) AS AvgScore
    FROM   sales.Customers
    WHERE  country = 'USA';
END
-- execute the stored procedure
EXECUTE GetCustomerSummary1 ;


GO
-- stored procedures
CREATE PROCEDURE GetCustomerSummary2
    @Country NVARCHAR (50)
AS
BEGIN
    SELECT count(*) AS TotalCustomers,
           avg(score) AS AvgScore
    FROM   sales.Customers
    WHERE  country = @Country;
END
-- execute the stored procedure
EXECUTE GetCustomerSummary2 @Country = 'Germany';
DROP PROCEDURE GetCustomerSummary1;


GO
-- NOW Dynamic Stored Procedure using Variables and If-Else
CREATE OR ALTER PROCEDURE GetCustomerSummary2
    @Country NVARCHAR (50)
AS
BEGIN
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
    -- Generating reports
    SELECT @TotalCustomers = count(*),
           @AvgScore = avg(score)
    FROM   sales.Customers
    WHERE  country = @Country;
    PRINT 'Total Customers from ' + @Country + ': ' + CAST (@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from ' + @Country + ': ' + CAST (@AvgScore AS NVARCHAR);
END


GO
-- execute the stored procedure
EXECUTE GetCustomerSummary2 @Country = 'Germany';

EXECUTE GetCustomerSummary2 @Country = 'USA';