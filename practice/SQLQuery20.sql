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
-- NOW Stored Procedure using Variables
CREATE OR ALTER PROCEDURE GetCustomerSummary2
    @Country NVARCHAR (50)
AS
BEGIN
    DECLARE @TotalCustomers AS INT, @AvgScore AS FLOAT;
    SELECT @TotalCustomers = count(*),
           @AvgScore = avg(score)
    FROM   sales.Customers
    WHERE  country = @Country;
    PRINT 'Total Customers from ' + @Country + ': ' + CAST (@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from ' + @Country + ': ' + CAST (@AvgScore AS NVARCHAR);
END
-- execute the stored procedure
EXECUTE GetCustomerSummary2 @Country = 'Germany';
EXECUTE GetCustomerSummary2 @Country = 'USA';