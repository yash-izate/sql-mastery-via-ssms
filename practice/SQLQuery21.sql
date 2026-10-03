
USE SalesDB;
GO

-- =========================================================
-- Stored Procedure: GetCustomerSummary3
-- Purpose:
--   1. Handle NULL customer scores
--   2. Generate a customer summary for a specified country
--   3. Generate an order and sales report
--   4. Handle runtime errors using TRY...CATCH
-- =========================================================

CREATE OR ALTER PROCEDURE dbo.GetCustomerSummary3
    @Country NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        -- =================================================
        -- Section 1: Declare Variables
        -- =================================================

        DECLARE @TotalCustomers INT,
                @AvgScore FLOAT;

        -- =================================================
        -- Section 2: Data Preparation and NULL Handling
        -- Check whether customers in the selected country
        -- have missing scores.
        -- WARNING: This UPDATE permanently changes the data.
        -- =================================================

        IF EXISTS
        (
            SELECT 1
            FROM Sales.Customers
            WHERE Score IS NULL
              AND Country = @Country
        )
        BEGIN
            PRINT 'Updating NULL scores to 0';

            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL
              AND Country = @Country;
        END
        ELSE
        BEGIN
            PRINT 'No NULL scores found for this country';
        END;

        -- =================================================
        -- Section 3: Report 1 - Customer Summary
        -- Calculate the total number of customers and
        -- their average score for the selected country.
        -- =================================================

        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        -- Display the customer summary
        PRINT 'Country: ' + @Country;

        PRINT 'Total Customers: '
            + CAST(@TotalCustomers AS NVARCHAR(20));

        PRINT 'Average Score: '
            + COALESCE(CAST(@AvgScore AS NVARCHAR(30)), 'NULL');

        -- =================================================
        -- Section 4: Report 2 - Order and Sales Summary
        -- Calculate total orders and total sales.
        -- NOTE: The original query reports ALL countries.
        -- Add a country filter if a country-specific report
        -- is required.
        -- =================================================

        SELECT
            COUNT(O.OrderID) AS TotalOrders,
            SUM(O.Sales) AS TotalSales,

            -- Intentional division-by-zero test:
            -- This will cause a runtime error.
            1 / 0 AS ErrorTest

        FROM Sales.Orders AS O
        INNER JOIN Sales.Customers AS C
            ON O.CustomerID = C.CustomerID;

    END TRY

    -- =====================================================
    -- Section 5: Error Handling
    -- Runs when a catchable error occurs in the TRY block.
    -- =====================================================

    BEGIN CATCH

        PRINT 'An error occurred during procedure execution.';

        PRINT 'Error Message: ' + ERROR_MESSAGE();

        PRINT 'Error Number: '
            + CAST(ERROR_NUMBER() AS NVARCHAR(20));

        PRINT 'Error Line: '
            + CAST(ERROR_LINE() AS NVARCHAR(20));

        PRINT 'Error Procedure: '
            + COALESCE(ERROR_PROCEDURE(), 'Ad hoc statement');

    END CATCH;

END;
GO

-- =========================================================
-- Section 6: Execute the Stored Procedure
-- =========================================================

EXEC dbo.GetCustomerSummary3 @Country = N'Germany';
GO

EXEC dbo.GetCustomerSummary3 @Country = N'USA';
GO