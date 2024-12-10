USE bakery
GO

CREATE OR ALTER FUNCTION GetTotalMoneyPaidByCustomer
(
    @CustomerPhone CHAR(10), 
    @StartDate DATETIME = NULL, 
    @EndDate DATETIME = NULL
)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalMoney MONEY = 0;

    -- check valid phone number
    IF NOT EXISTS (SELECT 1 FROM Customer WHERE Phone = @CustomerPhone)
    BEGIN
        RETURN -1;
    END

    -- check date range validity
    IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND @StartDate > @EndDate
    BEGIN
        RETURN -1;
    END

    -- Iterate through bills to calculate total
    DECLARE BillCursor CURSOR FOR 
    SELECT TotalPrice
    FROM Bill
    WHERE CustomerPhone = @CustomerPhone
    AND (@StartDate IS NULL OR Date >= @StartDate)
    AND (@EndDate IS NULL OR Date <= @EndDate);

    DECLARE @CurrentBillTotal MONEY;

    OPEN BillCursor;
    FETCH NEXT FROM BillCursor INTO @CurrentBillTotal;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @TotalMoney = @TotalMoney + @CurrentBillTotal;
        FETCH NEXT FROM BillCursor INTO @CurrentBillTotal;
    END;

    CLOSE BillCursor;
    DEALLOCATE BillCursor;

    RETURN @TotalMoney;
END;
GO

------------------------------------------------------------------------
--------------------------------- DEMO ---------------------------------
------------------------------------------------------------------------
SELECT dbo.GetTotalMoneyPaidByCustomer('2222222222', '2024-01-01', '2024-12-31') AS TotalPaid; -- user not exist
SELECT dbo.GetTotalMoneyPaidByCustomer('0901234567', '2024-01-01', '2024-12-31') AS TotalPaid; -- user exist
SELECT dbo.GetTotalMoneyPaidByCustomer('0901234567', '2024-12-31', '2024-01-01') AS TotalPaid; -- invalid date range
SELECT dbo.GetTotalMoneyPaidByCustomer('0901234567', NULL, NULL) AS TotalPaid; -- no date range

-- insert new customer
INSERT INTO
    Customer (Phone, FirstName, LastName, Gender, AddressID, MembershipPoint, MembershipID, Password, Status)
VALUES
    ('0915855146', N'Linh', N'Thinh Tran Khanh', 1, 1, 0, 2, 'password123', 1),

SELECT dbo.GetTotalMoneyPaidByCustomer('0915855146', '2024-01-01', '2024-12-31') AS TotalPaid; -- user exist but has no bill


