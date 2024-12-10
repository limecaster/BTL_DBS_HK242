use bakery
--ComboCake

---Insert---
CREATE PROCEDURE InsertComboCake
    @CakeID1 INT,
    @CakeID2 INT,
    @Price MONEY,
    @Status INT = 1
AS
BEGIN
    -- Default Status if NULL
    IF @Status IS NULL 
        SET @Status = 1;

    -- Validate if CakeID1 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID1 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID1. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID2 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID2. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID1 and CakeID2 are not the same
    IF @CakeID1 = @CakeID2
    BEGIN
        RAISERROR ('CakeID1 and CakeID2 cannot be the same.', 16, 1);
        RETURN;
    END;

    -- Check if the combination already exists
    IF EXISTS (SELECT 1 FROM ComboCake WHERE CakeID1 = @CakeID1 AND CakeID2 = @CakeID2)
    BEGIN
        RAISERROR ('Combination of CakeID1 and CakeID2 already exists.', 16, 1);
        RETURN;
    END;

    -- Insert into ComboCake
    INSERT INTO ComboCake (CakeID1, CakeID2, Price, Status)
    VALUES (@CakeID1, @CakeID2, @Price, @Status);
END;
GO

drop procedure InsertComboCake
select * from ComboCake



select C1.ID AS ID1,  C2.ID AS ID2, C1.Name AS Cake1 , C2.Name AS Cake2, CB.Price
FROM Cake C1
INNER JOIN ComboCake CB ON CB.CakeID1 = C1.ID
INNER JOIN Cake C2 ON CB.CakeID2 = C2.ID
WHERE CB.Status = 1




--GETCOMBO--

CREATE PROCEDURE GetAllCombos
AS
BEGIN
    SELECT 
        C1.ID AS ID1, 
        C2.ID AS ID2, 
        C1.Name AS Cake1, 
        C2.Name AS Cake2, 
        CB.Price
    FROM 
        Cake C1
    INNER JOIN 
        ComboCake CB ON CB.CakeID1 = C1.ID
    INNER JOIN 
        Cake C2 ON CB.CakeID2 = C2.ID
    WHERE 
        CB.Status = 1;
END;
GO


CREATE PROCEDURE GetCombosByCakeID
    @CakeID INT
AS
BEGIN
    -- Validate if the CakeID exists in the database
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID. Cake does not exist or is inactive.', 16, 1);
        RETURN;
    END;

    
    SELECT 
        C1.ID AS ID1, 
        C2.ID AS ID2, 
        C1.Name AS Cake1, 
        C2.Name AS Cake2, 
        CB.Price
    FROM 
        Cake C1
    INNER JOIN 
        ComboCake CB ON CB.CakeID1 = C1.ID
    INNER JOIN 
        Cake C2 ON CB.CakeID2 = C2.ID
    WHERE 
        CB.Status = 1 
        AND (@CakeID = CB.CakeID1 OR @CakeID = CB.CakeID2);
END;
GO

CREATE PROCEDURE GetComboCake
    @CakeID1 INT,
    @CakeID2 INT
AS
BEGIN
	 -- Validate if CakeID1 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID1 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID1. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID2 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID2. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID1 and CakeID2 are not the same
    IF @CakeID1 = @CakeID2
    BEGIN
        RAISERROR ('CakeID1 and CakeID2 cannot be the same.', 16, 1);
        RETURN;
    END;

    SELECT C1.ID AS ID1, 
        C2.ID AS ID2, 
        C1.Name AS Cake1, 
        C2.Name AS Cake2, 
        CB.Price
    FROM ComboCake CB
	INNER JOIN Cake C1 ON C1.ID = CB.CakeID1
	INNER JOIN Cake C2 ON C2.ID = CB.CakeID2
    WHERE CakeID1 = @CakeID1 AND CakeID2 = @CakeID2 AND CB.Status = 1;
END 


drop procedure GetComboCake

EXEC GetAllCombos
EXEC GetCombosByCakeID @CakeID = 1

---UPDATE---
CREATE PROCEDURE UpdateComboCake
    @CakeID1 INT,
    @CakeID2 INT,
    @Price MONEY = NULL,
    @Status INT = NULL
AS
BEGIN
	-- Validate if CakeID1 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID1 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID1. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID2 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID2. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate that the combination exists
    IF NOT EXISTS (SELECT 1 FROM ComboCake WHERE CakeID1 = @CakeID1 AND CakeID2 = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Combination of CakeID1 and CakeID2 not found.', 16, 1);
        RETURN;
    END;

    -- Update the combo with new data
    UPDATE ComboCake
    SET 
        Price = COALESCE(@Price, Price),
        Status = COALESCE(@Status, Status)
    WHERE 
        CakeID1 = @CakeID1 AND CakeID2 = @CakeID2;

    PRINT 'ComboCake updated successfully.';
END;
GO

EXEC UpdateComboCake
	@CakeID1 = 1,
	@CakeID2 = 2,
	@Price = 30000

--DELETE
CREATE PROCEDURE DeleteComboCake
    @CakeID1 INT,
    @CakeID2 INT
AS
BEGIN
	-- Validate if CakeID1 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID1 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID1. Cake does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate if CakeID2 exists
    IF NOT EXISTS (SELECT 1 FROM Cake WHERE ID = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Invalid CakeID2. Cake does not exist.', 16, 1);
        RETURN;
    END;
    -- Validate that the combination exists
    IF NOT EXISTS (SELECT 1 FROM ComboCake WHERE CakeID1 = @CakeID1 AND CakeID2 = @CakeID2 AND Status = 1)
    BEGIN
        RAISERROR ('Combination of CakeID1 and CakeID2 not found.', 16, 1);
        RETURN;
    END;

    -- Delete the combo
    UPDATE  ComboCake
	SET Status = 0
    WHERE CakeID1 = @CakeID1 AND CakeID2 = @CakeID2;

    PRINT 'ComboCake deleted successfully.';
END;
GO



