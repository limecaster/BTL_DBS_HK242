use bakery
--INSERT--
CREATE PROCEDURE InsertCake
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


drop procedure InsertCake;


--TEST--
EXEC InsertCake 
    @Name = 'Bánh Mì 123', 
    @Price = 40000, 
    @IsSalty = 1, 
    @IsSweet = 0, 
    @IsOther = 0, 
    @IsOrder = 1, 
    @CustomerNote = 'Giòn ngon';

select * from Cake;
-----------------------

--GET ALL----------
CREATE PROCEDURE GetAllCakes
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


CREATE PROCEDURE CALCULATEPAGE
	@Search NVARCHAR(255)
AS
BEGIN
	SELECT COUNT(*) AS Total
	FROM Cake
    WHERE Name LIKE '%' + @Search + '%' AND Status = 1;

END

--TEST--
DROP PROCEDURE GetAllCakes;
DROP PROCEDURE CALCULATEPAGE;
EXEC GetAllCakes @Page = 1, @Limit = 10, @Search = '';
EXEC CALCULATEPAGE @Search = '';
---------------------------------------------------


--Update--
CREATE PROCEDURE UpdateCake(
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

--TEST
DROP PROCEDURE UpdateCake
EXEC UpdateCake 
	@ID = 1,
	@Name = 'Bánh Mì 2',
	@Price = -16000



--DELETE
CREATE PROCEDURE DeleteCake
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

EXEC DeleteCake @ID = 1


