USE SalesDB;


GO
-- stored procedures
CREATE PROCEDURE GetCustomerSummary1
AS
BEGIN
    SELECT count(*) AS TotalCustomers,
           avg(score) AS AvgScore
    FROM   sales.Customers
    WHERE  country = 'USA'
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
    WHERE  country = @Country
END
-- execute the stored procedure
EXECUTE GetCustomerSummary2 @Country = 'Germany';


drop procedure GetCustomerSummary1;