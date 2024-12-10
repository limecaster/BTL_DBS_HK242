use bakery;

----INSERT----
CREATE PROCEDURE InsertCakeHasIngredient
    @CakeID INT,
    @IngredientID INT,
    @Amount INT,
    @Unit VARCHAR(10),
    @Status INT = 1
AS
BEGIN
	IF @Status IS NULL 
		SET @Status = 1;

    -- Validate if CakeID exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if IngredientID exists
    IF NOT EXISTS (SELECT 1 FROM Ingredient WHERE ID = @IngredientID AND Status = 1)
    BEGIN
        RAISERROR ('Invalid IngredientID. Ingredient does not exist.', 16, 1);
        RETURN;
    END;

    -- Check if the relation already exists
    IF EXISTS (SELECT 1 FROM CakeHasIngredient WHERE CakeID = @CakeID AND IngredientID = @IngredientID)
    BEGIN
        RAISERROR ('Relation between Cake and Ingredient already exists.', 16, 1);
        RETURN;
    END;

    -- Insert into CakeHasIngredient
    INSERT INTO CakeHasIngredient (CakeID, IngredientID, Amount, Unit, Status)
    VALUES (@CakeID, @IngredientID, @Amount, @Unit, @Status);
END;
GO

drop procedure InsertCakeHasIngredient
select * from CakeHasIngredient
select * from Ingredient

update CakeHasIngredient
	set Status = 1
	where CakeID = 1 AND IngredientID = 3

EXEC InsertCakeHasIngredient 
	@CakeID = 1,
	@IngredientID = 1,
	@Amount = 200,
	@Unit ='gram'


select C.Name, I.Name, CHI.Amount , CHI.Unit 
from Cake C
inner join CakeHasIngredient CHI on C.ID = CHI.CakeID
inner join Ingredient I on I.ID = CHI.IngredientID
where C.Status = 1 AND CHI.Status = 1 AND I.Status = 1 AND C.ID = 

-- get all ingredient of cake ---
CREATE PROCEDURE GetCakeHasIngredient
	@CakeID INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID. Cake does not exist.', 16, 1);
        RETURN;
    END;
	SELECT C.Name AS Cake, I.Name as Ingredient, CHI.Amount , CHI.Unit , I.ImportPrice
	FROM Cake C
	INNER JOIN CakeHasIngredient CHI on C.ID = CHI.CakeID
	INNER JOIN Ingredient I on I.ID = CHI.IngredientID
	WHERE C.Status = 1 AND CHI.Status = 1 AND I.Status = 1 AND C.ID = @CakeID;
END;

drop procedure GetCakeHasIngredient

EXEC GetCakeHasIngredient @CakeID = 2




---UPDATE---
CREATE PROCEDURE UpdateCakeHasIngredient
    @CakeID INT,
    @IngredientID INT,
    @Amount INT,
    @Unit VARCHAR(10),
    @Status INT
AS
BEGIN
    -- Validate if relation exists
    IF NOT EXISTS (SELECT 1 FROM CakeHasIngredient WHERE CakeID = @CakeID AND IngredientID = @IngredientID AND Status = 1)
    BEGIN
        RAISERROR ('Relation between Cake and Ingredient not found.', 16, 1);
        RETURN;
    END;

    -- Update the record
    UPDATE CakeHasIngredient
    SET Amount = COALESCE(@Amount, Amount),
		Unit = COALESCE(@Unit, UNIT),
		Status = COALESCE(@Status, Status)
    WHERE CakeID = @CakeID AND IngredientID = @IngredientID;
END;
GO


----DELETE---
CREATE PROCEDURE DeleteCakeHasIngredient
@CakeID INT,
@IngredientID INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CakeHasIngredient WHERE CakeID = @CakeID AND IngredientID = @IngredientID AND Status = 1)
	BEGIN
        RAISERROR ('Relation between Cake and Ingredient not found.', 16, 1);
        RETURN;
    END;

	UPDATE CakeHasIngredient
	SET Status = 0
	WHERE CakeID = @CakeID AND IngredientID = @IngredientID;
END;
GO


	 



