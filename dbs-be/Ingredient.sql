use bakery;
---INSERT-----
CREATE PROCEDURE InsertIngredient
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

drop procedure InsertIngredient;

select * from Ingredient

EXEC InsertIngredient
	@Name = 'Chocolate',
	@ImportPrice = 30000

----GET ALL------
CREATE PROCEDURE GetAllIngredient
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

CREATE PROCEDURE CALCULATEPAGEINGRE
	@Search NVARCHAR(255)
AS
BEGIN
	SELECT COUNT(*) AS Total
	FROM Ingredient
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1;

END

EXEC GetAllIngredient @Page = 1, @Limit = 10, @Search = ''

EXEC CALCULATEPAGEINGRE 
@Search =''


----Update----
CREATE PROCEDURE UpdateIngredient
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

drop procedure UpdateIngredient

select * from Ingredient

EXEC UpdateIngredient
	@ID = 6,
	@ImportPrice = 25000


---DELETE---
CREATE PROCEDURE DeleteIngredient
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

drop procedure DeleteIngredient
select * from Ingredient where ID = 3 and status = 1
EXEC DeleteIngredient @ID = 6
			
			
	


			
		
	
