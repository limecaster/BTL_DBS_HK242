use bakery
CREATE PROCEDURE GetTotalImportPriceByCake
    @MinTotalImportPrice MONEY -- Điều kiện HAVING: Tổng giá nhập tối thiểu
AS
BEGIN
    SELECT 
        c.Name AS CakeName,
        SUM(i.ImportPrice * chi.Amount / 100) AS TotalImportPrice
    FROM 
        CakeHasIngredient chi
    INNER JOIN 
        Cake c ON chi.CakeID = c.ID
    INNER JOIN 
        Ingredient i ON chi.IngredientID = i.ID
    GROUP BY 
        c.Name
    HAVING 
        SUM(i.ImportPrice * chi.Amount) >= @MinTotalImportPrice
    ORDER BY 
        TotalImportPrice DESC;
END;

drop procedure GetTotalImportPriceByCake


--TEST--
exec GetTotalImportPriceByCake @MinTotalImportPrice = 2000000