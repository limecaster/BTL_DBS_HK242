USE bakery
GO

CREATE OR ALTER FUNCTION dbo.CalculateDiscountedCakePrice
(
    @CakeID INT
)
RETURNS MONEY
AS
BEGIN
    -- Validate CakeID
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID)
    BEGIN
        RETURN -1;
    END

    DECLARE @Price MONEY;
    DECLARE @DiscountAmount MONEY;
    DECLARE @DiscountedPrice MONEY;

    -- Get cake price
    SELECT @Price = Price
    FROM Cake
    WHERE ID = @CakeID;

    -- Get highest discount amount from per product coupon if exists
    SELECT TOP 1 @DiscountAmount = DiscountAmount
    FROM PerProductCoupon
    WHERE CakeID = @CakeID AND GETDATE() BETWEEN StartDate AND EndDate AND Status = 1
    ORDER BY DiscountAmount DESC;

    -- If no discount amount, return original price
    IF @DiscountAmount IS NULL
        SET @DiscountedPrice = @Price;
    ELSE
        SET @DiscountedPrice = @Price - @DiscountAmount;

    -- Ensure price is not negative
    IF @DiscountedPrice < 0
        SET @DiscountedPrice = 0;

    RETURN @DiscountedPrice;
END;
GO

------------------------------------------------------------------------
--------------------------------- DEMO ---------------------------------
------------------------------------------------------------------------
INSERT INTO
    Cake (Name, Price, IsSalty, IsSweet, IsOther, IsOrder, CustomerNote, Status)
VALUES
    (N'Chocolate cake', 40000, 0, 1, 0, 0, NULL, 1), -- 5
    (N'Red velvet', 45000, 0, 1, 0, 0, NULL, 1), -- 6
    (N'Cheese cake', 35000, 0, 1, 0, 0, NULL, 1), -- 7
    (N'Matcha cupcake', 35000, 0, 1, 0, 0, NULL, 1); -- 8
GO

INSERT INTO
    PerProductCoupon (DiscountAmount, StartDate, EndDate, CakeID, Status)
VALUES
    (5000, '2024-12-06', '2024-12-25', 13, 1), -- valid
    (6000, '2024-12-09', '2024-12-26', 13, 1), -- valid with higher discount
    (10000, '2024-11-09', '2024-11-10', 13, 1), -- highest discount but expired
    (4000, '2024-11-09', '2024-11-10', 14, 1), -- expired
    (12000, '2024-12-09', '2024-12-25', 14, 0), -- valid but inactive
    (30000, '2024-12-09', '2024-12-25', 15, 0), -- valid but inactive
    (40000, '2024-12-09', '2024-12-25', 15, 1); -- valid and free
GO

SELECT *
FROM Cake
GO

SELECT *
FROM PerProductCoupon
GO

SELECT
    dbo.CalculateDiscountedCakePrice(13) AS 'Chocolate cake',
    dbo.CalculateDiscountedCakePrice(14) AS 'Red velvet',
    dbo.CalculateDiscountedCakePrice(15) AS 'Cheese cake',
    dbo.CalculateDiscountedCakePrice(16) AS 'Matcha cupcake',
    dbo.CalculateDiscountedCakePrice(17) AS 'Non-existent cake'; -- non-existent cake
