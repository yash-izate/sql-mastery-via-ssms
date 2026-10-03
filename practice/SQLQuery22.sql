USE SalesDB;

CREATE TABLE Sales.EmployeeLogs (
    LogID      INT           IDENTITY (1, 1) PRIMARY KEY,
    EmployeeID INT          ,
    LogMessage VARCHAR (255),
    LogDate    DATE         
);


GO
CREATE TRIGGER trg_AferInsertEmployee
    ON Sales.Employees
    AFTER INSERT
    AS BEGIN
           INSERT INTO Sales.EmployeeLogs (
               EmployeeID,
               LogMessage,
               LogDate
           )
           SELECT EmployeeID,
                  'New Employee Added = ' + CAST (EmployeeID AS VARCHAR),
                  getDAte()
           FROM   Inserted;
       END


GO
SELECT *
FROM   sales.employeeLogs;

-- trying to insert data 
INSERT  INTO sales.Employees
VALUES (7, 'Yashika', 'Sammual', 'Electrical', '2010-07-08', 'M', 35000, 2),
(8, 'Yashisvi', 'Smith', 'AiMl', '1995-07-08', 'F', 25000, 3);