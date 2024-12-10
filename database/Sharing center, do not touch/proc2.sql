Use bakery;
go

CREATE OR ALTER  PROCEDURE InsertCake
    @Name NVARCHAR(255),
    @Price MONEY,
    @IsSalty BIT,
    @IsSweet BIT,
    @IsOther BIT,
    @IsOrder BIT,
    @CustomerNote NTEXT,
    @Status INT = 1
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra dữ liệu hợp lệ
        IF LEN(@Name) = 0 OR @Name IS NULL
            THROW 50001, 'Tên bánh không được để trống.', 1;

        IF @Price IS NULL OR @Price <= 0
            THROW 50002, 'Giá bánh phải lớn hơn 0.', 1;

        -- Kiểm tra các trường boolean (BIT)
        IF @IsSalty NOT IN (0, 1)
            THROW 50003, 'Trường IsSalty chỉ được phép có giá trị 0 hoặc 1.', 1;

        IF @IsSweet NOT IN (0, 1)
            THROW 50004, 'Trường IsSweet chỉ được phép có giá trị 0 hoặc 1.', 1;

        IF @IsOther NOT IN (0, 1)
            THROW 50005, 'Trường IsOther chỉ được phép có giá trị 0 hoặc 1.', 1;

        IF @IsOrder NOT IN (0, 1)
            THROW 50006, 'Trường IsOrder chỉ được phép có giá trị 0 hoặc 1.', 1;

        -- Kiểm tra trạng thái (Status)
        IF @Status IS NULL
            SET @Status = 1

        IF @Status NOT IN (0, 1)
            THROW 50007, 'Trạng thái chỉ được phép là 0 (không hoạt động) hoặc 1 (hoạt động).', 1;

        -- Chèn dữ liệu vào bảng Cake
        INSERT INTO Cake (Name, Price, IsSalty, IsSweet, IsOther, IsOrder, CustomerNote, Status)
        VALUES (@Name, @Price, @IsSalty, @IsSweet, @IsOther, @IsOrder, @CustomerNote, @Status);

        SELECT  'Cake created successfully' AS Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

CREATE OR ALTER   PROCEDURE GetAllCakes
    @Page INT,
    @Limit INT,
    @Search NVARCHAR(255)
AS
BEGIN
    DECLARE @Offset INT;
    SET @Offset = (@Page - 1) * @Limit;

    -- Lấy danh sách các bánh với phân trang và tìm kiếm
    SELECT 
        ID,
        Name,
        Price,
        IsSalty,
        IsSweet,
        IsOther,
        IsOrder,
        CustomerNote,
        Status
    FROM Cake
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1
    ORDER BY ID
    OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;
END
GO

CREATE OR ALTER   PROCEDURE CALCULATEPAGE
	@Search NVARCHAR(255)
AS
BEGIN
	SELECT COUNT(*) AS Total
	FROM Cake
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1;

END
GO

CREATE OR ALTER   PROCEDURE UpdateCake(
    @ID INT,
    @Name NVARCHAR(255) = NULL,
    @Price MONEY = NULL,
    @IsSalty BIT = NULL,
    @IsSweet BIT = NULL,
    @IsOther BIT = NULL,
    @IsOrder BIT = NULL,
    @CustomerNote NVARCHAR(255) = NULL,
    @Status INT = NULL
)
AS
BEGIN
    -- Kiểm tra nếu bánh tồn tại
    IF EXISTS (SELECT 1 FROM Cake WHERE ID = @ID AND Status = 1)
    BEGIN
		BEGIN TRY
			IF LEN(@Name) = 0 AND @Name IS NOT NULL
				THROW 50001, 'Tên bánh không được để trống.', 1;

			IF @Price IS NOT NULL AND @Price <= 0
				THROW 50002, 'Giá bánh phải lớn hơn 0.', 1;

			IF @Status NOT IN (0, 1) AND @Status IS NOT NULL
				THROW 50003, 'Trạng thái chỉ được phép là 0 (không hoạt động) hoặc 1 (hoạt động).', 1;
			-- Cập nhật các trường có giá trị
			UPDATE Cake
			SET
				Name = COALESCE(@Name, Name),
				Price = COALESCE(@Price, Price),
				IsSalty = COALESCE(@IsSalty, IsSalty),
				IsSweet = COALESCE(@IsSweet, IsSweet),
				IsOther = COALESCE(@IsOther, IsOther),
				IsOrder = COALESCE(@IsOrder, IsOrder),
				CustomerNote = COALESCE(@CustomerNote, CustomerNote),
				Status = COALESCE(@Status, Status)
			WHERE ID = @ID;

			SELECT 'Cake updated successfully' AS Message;
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH
    END
    ELSE
    BEGIN
        SELECT 'Cake not found' AS Message;
    END
END
GO

CREATE OR ALTER  PROCEDURE DeleteCake
	@ID INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Cake WHERE ID = @ID AND Status = 1)
		BEGIN
			UPDATE Cake
			SET Status = 0
			WHERE ID = @ID

			SELECT 'Cake deleted successfully' AS Message;
		END
	ELSE
		BEGIN
			SELECT 'Cake not found' AS Message;
		END
END
GO

CREATE OR ALTER  PROCEDURE InsertIngredient
@Name NVARCHAR(255),
@ImportPrice MONEY,
@Status INT = 1
AS
BEGIN
	BEGIN TRY
		IF LEN(@Name) = 0 OR @Name IS NULL
            THROW 50001, 'Tên nguyen lieu không được để trống.', 1;

		IF @ImportPrice IS NULL OR @ImportPrice <= 0
            THROW 50002, 'Giá nguyen lieu phải lớn hơn 0.', 1

		IF @Status IS NULL
            SET @Status = 1

		IF @Status NOT IN (0, 1)
            THROW 50003, 'Trạng thái chỉ được phép là 0 (không hoạt động) hoặc 1 (hoạt động).', 1;

		INSERT INTO Ingredient (Name, ImportPrice, Status)
			VALUES (@Name, @ImportPrice, @Status)

		SELECT  'Cake created successfully' AS Message;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE OR ALTER  PROCEDURE GetAllIngredient
    @Page INT,
    @Limit INT,
    @Search NVARCHAR(255)
AS
BEGIN
    DECLARE @Offset INT;
    SET @Offset = (@Page - 1) * @Limit;

    SELECT 
        ID,
        Name,
        ImportPrice,
        Status
    FROM Ingredient
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1
    ORDER BY ID
    OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;
END
GO

CREATE OR ALTER PROCEDURE CALCULATEPAGEINGRE
	@Search NVARCHAR(255)
AS
BEGIN
	SELECT COUNT(*) AS Total
	FROM Ingredient
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1;

END
GO

CREATE OR ALTER  PROCEDURE UpdateIngredient
	@ID INT, 
	@Name NVARCHAR(255) = NULL,
	@ImportPrice MONEY = NULL,
	@Status INT = NULL
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Ingredient WHERE @ID = ID AND Status = 1)
	BEGIN 
		BEGIN TRY
			IF LEN(@Name) = 0 AND @Name IS NOT NULL
            THROW 50001, 'Tên nguyen lieu không được để trống.', 1;
	
			IF @ImportPrice IS NOT NULL AND @ImportPrice <= 0
            THROW 50002, 'Giá nguyen lieu phải lớn hơn 0.', 1

			IF @Status NOT IN (0, 1) AND @Status IS NOT NULL
            THROW 50003, 'Trạng thái chỉ được phép là 0 (không hoạt động) hoặc 1 (hoạt động).', 1;

			UPDATE Ingredient
			SET
				Name = COALESCE(@Name, Name),
				ImportPrice = COALESCE(@ImportPrice, ImportPrice),
				Status = COALESCE(@Status, Status)
			Where ID = @ID

			SELECT 'Ingredient updated successfully' AS Message;
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH
	END
	ELSE
	BEGIN
		SELECT 'Ingredient is not found' AS Message;
	END
END
GO
CREATE OR ALTER  PROCEDURE DeleteIngredient
	@ID INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Ingredient WHERE ID = @ID AND Status = 1)
		BEGIN
			UPDATE Ingredient
			SET Status = 0
			WHERE ID = @ID

			SELECT 'Ingredient deleted successfully' AS Message;
		END
	ELSE
		BEGIN
			SELECT 'Ingredient not found' AS Message;
		END
END
GO

CREATE OR ALTER  PROCEDURE InsertCakeHasIngredient
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

CREATE OR ALTER  PROCEDURE GetCakeHasIngredient
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
GO

CREATE OR ALTER  PROCEDURE UpdateCakeHasIngredient
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

CREATE OR ALTER  PROCEDURE DeleteCakeHasIngredient
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

CREATE OR ALTER  PROCEDURE InsertComboCake
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

CREATE OR ALTER  PROCEDURE GetAllCombos
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

CREATE OR ALTER  PROCEDURE GetCombosByCakeID
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

CREATE OR ALTER  PROCEDURE GetComboCake
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
GO

CREATE OR ALTER  PROCEDURE UpdateComboCake
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

CREATE OR ALTER  PROCEDURE DeleteComboCake
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
