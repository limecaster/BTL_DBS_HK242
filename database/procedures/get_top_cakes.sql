USE bakery;
GO

CREATE OR ALTER PROCEDURE GetTopCakes
    @StartDate DATETIME,
    @EndDate DATETIME,
    @Top INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CakeID, Name, TotalQuantity
    FROM 
        (
            SELECT TOP (@Top) CakeID, SUM(Amount) AS TotalQuantity
            FROM BillHasCake
            WHERE BillID IN (
                SELECT BillID
                FROM Bill
                WHERE Date BETWEEN @StartDate AND @EndDate
            )
            GROUP BY CakeID
            ORDER BY TotalQuantity DESC
        )
        AS TopCakes 
        JOIN Cake
        ON TopCakes.CakeID = Cake.ID;
    
END;


-- Test the procedure

-- Mock data

INSERT INTO Customer (Phone, FirstName, LastName, Status)
VALUES ('0123456789', 'Customer', '1', 1), ('9876543210', 'Customer', '2', 1);

INSERT INTO Cake (Name, Price, Status)
VALUES ('Cake 1', 10, 1), ('Cake 2', 20, 1), ('Cake 3', 30, 1);

INSERT INTO Bill (Date, ReceiveMoney, CashierID, CustomerPhone, Status)
VALUES ('2021-01-01', 100, 'CA0020004', '0123456789', 1), ('2021-01-02', 200, 'CA0020004', '0123456789', 1), ('2021-01-03', 300, 'CA0020004', '9876543210', 1);

INSERT INTO BillHasCake (BillID, CakeID, Amount, Status)
VALUES (6, 13, 1, 1), (7, 14, 2, 1), (8, 15, 3, 1);

-- Test the procedure
EXEC GetTopCakes '2021-01-01', '2021-01-03', 10;

Select * FROM Employee
Select * FROM Bill
Select * FROM Cake
