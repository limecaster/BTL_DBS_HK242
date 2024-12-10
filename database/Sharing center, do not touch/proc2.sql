
Use bakery;
go

-- Microsoft SQL Server 2022
-- DROP Database
USE master;
GO

ALTER DATABASE bakery
SET
	SINGLE_USER
WITH
	ROLLBACK IMMEDIATE;
GO

DROP DATABASE bakery;
GO
-- CREATE database
CREATE DATABASE bakery;
Go

USE bakery;
GO

-- FOR EMPLOYEE
-- Table: Branch
CREATE TABLE Branch
(
	Name NVARCHAR (255) PRIMARY KEY,
	Address NVARCHAR (255) NOT NULL,
	Phone NVARCHAR (255) NOT NULL,
	OpenHour TIME CHECK (OpenHour>='05:30:00'),
	CloseHour TIME CHECK (CloseHour<='23:30:00'),
	OpenDate DATE,
	NumberOfEmployee INT DEFAULT 0,
	Status INT DEFAULT 1
);

-- Table: EmployeeType
CREATE TABLE EmployeeType
(
	ID NVARCHAR (2) PRIMARY KEY DEFAULT 'NA',
	JobName NVARCHAR (50) NOT NULL DEFAULT 'NA',
	Status INT DEFAULT 1
)

-- Table: Employee
CREATE TABLE Employee
(
	ID CHAR(9) PRIMARY KEY,
	FirstName NVARCHAR (100) NOT NULL,
	LastName NVARCHAR (100) NOT NULL,
	Gender NVARCHAR (1) CHECK (Gender IN ('M', 'F')),
	Salary MONEY,
	IsPartTime BIT,
	ETypeID NVARCHAR (2) NOT NULL DEFAULT 'NA',
	BranchName NVARCHAR (255) DEFAULT 'NA',
	Status INT DEFAULT 1,
	CONSTRAINT fk_emp_emp_type FOREIGN KEY (ETypeID) REFERENCES EmployeeType (ID) ON DELETE SET DEFAULT ON UPDATE CASCADE,
	CONSTRAINT fk_emp_branch FOREIGN KEY (BranchName) REFERENCES Branch (Name) ON DELETE SET DEFAULT ON UPDATE CASCADE,
)

-- Table: EmployeePhone
CREATE TABLE EmployeePhone
(
	EID CHAR(9),
	Phone CHAR(10) NOT NULL,
	Status INT DEFAULT 1,
	PRIMARY KEY (EID, Phone),
	CONSTRAINT fk_empphone_emp_id FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- Table: WorkDay
CREATE TABLE WorkDay
(
	WeekDay INT PRIMARY KEY,
	Status INT DEFAULT 1,
)

-- Table: Shift
CREATE TABLE Shift
(
	WeekDay INT,
	StartHour TIME,
	Status INT DEFAULT 1,
	PRIMARY KEY (WeekDay, StartHour),
	CONSTRAINT fk_shift_workday FOREIGN KEY (WeekDay) REFERENCES WorkDay (WeekDay) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- Table: ShiftEmployee
CREATE TABLE Register
(
	EID CHAR(9) NOT NULL,
	WeekDay INT,
	StartHour TIME,
	Status INT DEFAULT 1,
	PRIMARY KEY (EID, WeekDay, StartHour),
	CONSTRAINT fk_register_emp FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_register_shift FOREIGN KEY (WeekDay, StartHour) REFERENCES Shift (WeekDay, StartHour) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- Table: WorksIn
CREATE TABLE WorksIn
(
	EID CHAR(9) NOT NULL,
	WeekDay INT,
	StartHour TIME,
	Date DATE,
	Status INT DEFAULT 1,
	PRIMARY KEY (EID, WeekDay, StartHour, Date),
	CONSTRAINT fk_worksin_emp FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_worksin_shift FOREIGN KEY (WeekDay, StartHour) REFERENCES Shift (WeekDay, StartHour) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- FOR CUSTOMER
-- Table: Membership
CREATE TABLE Membership
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	Name NVARCHAR (50),
	Threshold INT,
	DiscountPercent DECIMAL(5, 2),
	Status INT DEFAULT 1
)

-- Table: Customer
CREATE TABLE Customer
(
	Phone CHAR(10) PRIMARY KEY,
	FirstName NVARCHAR (100) NOT NULL,
	LastName NVARCHAR (100) NOT NULL,
	Gender NVARCHAR (1) CHECK (Gender IN ('M', 'F')),
	MembershipPoint INT DEFAULT 0,
	MembershipID INT DEFAULT 1,
	Password VARCHAR(255),
	Status INT DEFAULT 1,
	CONSTRAINT fk_cus_membership FOREIGN KEY (MembershipID) REFERENCES Membership (ID) ON DELETE SET DEFAULT ON UPDATE CASCADE,
)

-- Table: CustomerAddress
CREATE TABLE CustomerAddress
(
	CusPhone CHAR(10),
	ApartmentNo NVARCHAR (200) NOT NULL,
	Street NVARCHAR (200) NOT NULL,
	District NVARCHAR (200) NOT NULL,
	City NVARCHAR (200) NOT NULL,
	Status INT DEFAULT 1,
	PRIMARY KEY (CusPhone, ApartmentNo, Street, District, City),
	CONSTRAINT fk_cusaddress_cus FOREIGN KEY (CusPhone) REFERENCES Customer (Phone) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- FOR CAKE
-- Table: Ingredient
CREATE TABLE Ingredient
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	Name NVARCHAR (255),
	ImportPrice Money,
	Status INT DEFAULT 1
)

-- Table: Cake
CREATE TABLE Cake
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	Name NVARCHAR (255),
	Price MONEY,
	IsSalty BIT,
	IsSweet BIT,
	IsOther BIT,
	IsOrder BIT,
	CustomerNote NTEXT,
	Status INT DEFAULT 1
)

-- Table: ComboCake
CREATE TABLE ComboCake
(
	CakeID1 INT,
	CakeID2 INT,
	Price Money,
	Status INT DEFAULT 1,
	PRIMARY KEY (CakeID1, CakeID2),
	CONSTRAINT fk_combocake_cake1 FOREIGN KEY (CakeID1) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_combocake_cake2 FOREIGN KEY (CakeID2) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
)

-- Table: CakeHasIngredient
CREATE TABLE CakeHasIngredient
(
	CakeID INT NOT NULL,
	IngredientID INT NOT NULL,
	Amount INT,
	Unit VARCHAR(10),
	Status INT DEFAULT 1,
	PRIMARY KEY (CakeID, IngredientID),
	CONSTRAINT fk_cakehasingredient_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_cakehasingredient_ingredient FOREIGN KEY (IngredientID) REFERENCES Ingredient (ID) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- FOR BILL AND COUPON
-- Table: Bill
CREATE TABLE Bill
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	ReceiveAddress NVARCHAR (255), -- ko tham chiếu vì có thể khách hàng ko có tài khoản
	ReceiveMoney MONEY,
	Date DATETIME,
	CashierID CHAR(9),
	CustomerPhone CHAR(10),
	TotalPrice MONEY,
	Status INT DEFAULT 1,
	CONSTRAINT fk_bill_cus FOREIGN KEY (CustomerPhone) REFERENCES Customer (Phone) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_bill_emp FOREIGN KEY (CashierID) REFERENCES Employee (ID) ON DELETE SET NULL ON UPDATE CASCADE,
)

-- Table: TotalBillCoupon
CREATE TABLE TotalBillCoupon
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	CurrentAmount INT,
	InitialAmount INT,
	DiscountPercent DECIMAL(5, 2),
	-- SỐ tiền giảm tối đa
	DiscountMax NUMERIC,
	StartDate DATETIME,
	EndDate DATETIME,
	Status INT DEFAULT 1
)

-- Table: BillApplyTotalBillCoupon
CREATE TABLE BillApplyTotalBillCoupon
(
	BillID INT,
	CouponID INT,
	Status INT DEFAULT 1,
	PRIMARY KEY (BillID, CouponID),
	CONSTRAINT fk_billapplytotalbillcoupon_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_billapplytotalbillcoupon_totalbillcoupon FOREIGN KEY (CouponID) REFERENCES TotalBillCoupon (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

-- Table: PerProductCoupon
CREATE TABLE PerProductCoupon
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	DiscountAmount MONEY,
	StartDate DATETIME,
	EndDate DATETIME,
	CakeID INT NOT NULL,
	Status INT DEFAULT 1,
	CONSTRAINT fk_perproductcoupon_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE CASCADE ON UPDATE CASCADE,
)

-- Table: BillApplyPerProductCoupon
CREATE TABLE BillApplyPerProductCoupon
(
	BillID INT,
	CouponID INT,
	Status INT DEFAULT 1,
	PRIMARY KEY (BillID, CouponID),
	CONSTRAINT fk_billapplyperproductcoupon_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_billapplyperproductcoupon_perproductcoupon FOREIGN KEY (CouponID) REFERENCES PerProductCoupon (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

-- Table: Decoration
CREATE TABLE Decoration
(
	ID INT IDENTITY (1, 1) PRIMARY KEY,
	Name NVARCHAR (255),
	Price MONEY,
	Status INT DEFAULT 1
)

-- Table: BillBonusDecoration
CREATE TABLE BillBonusDecoration
(
	BillID INT,
	DecorationID INT,
	Amount INT,
	Status INT DEFAULT 1,
	PRIMARY KEY (BillID, DecorationID),
	CONSTRAINT fk_billbonusdecoration_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_billbonusdecoration_decoration FOREIGN KEY (DecorationID) REFERENCES Decoration (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
)

-- Table: BillHasCake
CREATE TABLE BillHasCake
(
	BillID INT,
	CakeID INT,
	Amount INT,
	Status INT DEFAULT 1,
	PRIMARY KEY (BillID, CakeID),
	CONSTRAINT fk_billhascake_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT fk_billhascake_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
)
GO


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

use bakery
go

CREATE OR ALTER TRIGGER TriggerUpdateNoEmp
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables to store branch names
    DECLARE @BranchName NVARCHAR(255);

    -- Increase the NumberOfEmployee of the branch by 1 if Inserted
    IF EXISTS (SELECT 1 FROM inserted WHERE Status = 1 AND BranchName NOT IN (SELECT BranchName FROM deleted))
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee + 1
        WHERE Name IN (SELECT BranchName FROM inserted WHERE Status = 1 AND BranchName NOT IN (SELECT BranchName FROM deleted));

        SELECT @BranchName = BranchName 
        FROM inserted 
        WHERE Status = 1 AND BranchName NOT IN (SELECT BranchName FROM deleted);

        PRINT('Number of employees in the branch ' + @BranchName + ' has been increased by 1');
    END

	-- Decrease the NumberOfEmployee of the branch by 1 if Update status to 0
    IF EXISTS (SELECT 1 FROM inserted WHERE Status = 0)
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee - 1
        WHERE Name IN (SELECT BranchName FROM inserted WHERE Status = 0);

        SELECT @BranchName = BranchName 
        FROM inserted 
        WHERE Status = 0;

        PRINT('Number of employees in the branch ' + @BranchName + ' has been decreased by 1');
    END

	    -- Update NumberOfEmployee if employee moved to another branch
    IF EXISTS (SELECT 1 FROM inserted INNER JOIN deleted ON inserted.ID = deleted.ID WHERE inserted.BranchName <> deleted.BranchName)
    BEGIN
        -- Decrease employee count from the old branch
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee - 1
        WHERE Name IN (
            SELECT d.BranchName
            FROM deleted d
            JOIN inserted i ON d.ID = i.ID
            WHERE d.BranchName <> i.BranchName
        );

        SELECT @BranchName = BranchName 
        FROM deleted 
        WHERE BranchName IN (SELECT BranchName FROM deleted EXCEPT SELECT BranchName FROM inserted);

        PRINT('Number of employees in the branch ' + @BranchName + ' has been decreased by 1');
    END

END;
GO

-- trigger kiem tra etype va employeeID co 2 chu cai dau co khop nhau hay khong va neu etype la 'MA' thi khong duoc lam parttime

CREATE TRIGGER checkEmployeeRules
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra ràng buộc 1: EmployeeID phải bắt đầu với cùng hai chữ cái như ETypeID
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE LEFT(i.ID, 2) != i.ETypeID
    )
    BEGIN
        RAISERROR('EmployeeID must start with the same two letters as ETypeID.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Kiểm tra ràng buộc 2: Nếu EmployeeID bắt đầu bằng 'MA', thì IsPartTime phải bằng 0
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE LEFT(i.ID, 2) = 'MA' AND i.IsPartTime != 0
    )
    BEGIN
        RAISERROR('Managers cannot be part-time employees.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

use bakery
-- Trigger Tu dong cap nhat membershipID khi update membershipPoint
GO

use bakery
-- Trigger Tu dong cap nhat membershipID khi update membershipPoint
GO

create or alter trigger UpdateMembership
on Customer
after update
as
begin 
	if UPDATE(MembershipPoint)
	begin
		declare @MembershipPoint int;
		declare @CustomerPhone char(10);
		declare @NewMembershipID int;
		
		select @MembershipPoint = MembershipPoint, @CustomerPhone = Phone
		from inserted;

		select TOP 1 @NewMembershipID = Membership.ID
		from Membership
		where @MembershipPoint >= Threshold
		order by Threshold desc

		update Customer
		set MembershipID = @NewMembershipID
		where Phone = @CustomerPhone
	end
end;
GO

-- Sử dụng cơ sở dữ liệu bakery
USE bakery;
GO

-- Branch
INSERT INTO
    Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES
    ('Branch 1', 'Street A', '0900111222', '08:00:00', '22:00:00', '2020-01-01', 6, 1),
    ('Branch 2', 'Street B', '0900111333', '08:00:00', '22:00:00', '2021-04-01', 6, 1),
    ('Branch 3', 'Street C', '0900111444', '08:00:00', '22:00:00', '2022-03-21', 6, 1),
    ('Branch 4', 'Street D', '0900111555', '08:00:00', '22:00:00', '2022-03-21', 5, 1),
    ('Branch 5', 'Street E', '0900111666', '08:00:00', '22:00:00', '2024-08-31', 0, 1);
SELECT * FROM Branch


-- EmployeeType
INSERT INTO
    EmployeeType (ID, JobName, Status)
VALUES
    ('MA', 'Manager', 1),
    ('BA', 'Baker', 1),
    ('WA', 'Waiter', 1),
    ('CA', 'Cashier', 1),
    ('SH', 'Shipper', 1);
SELECT * FROM EmployeeType

-- Employee
INSERT INTO
    Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES
    ('MA0010001', 'Linh', 'Thinh Tran Khanh', 'F', 500000, 0, 'MA', 'Branch 1', 1),
    ('BA0010002', 'Thao', 'Nguyen Thi', 'F', 400000, 0, 'BA', 'Branch 1', 1),
    ('WA0010003', 'Hoa', 'Tran Thi', 'F', 300000, 0, 'WA', 'Branch 1', 1),
    ('CA0010004', 'Huy', 'Nguyen Van', 'M', 300000, 0, 'CA', 'Branch 1', 1),
    ('SH0010005', 'Tuan', 'Le Van', 'M', 250000, 0, 'SH', 'Branch 1', 1),
    ('SH0010006', 'Tuan', 'Vu Manh', 'M', 200000, 1, 'SH', 'Branch 1', 1),

    ('MA0020001', 'Linh', 'Duong Thuy', 'F', 500000, 0, 'MA', 'Branch 2', 1),
    ('BA0020002', 'Thao', 'Tran Thi Phuong', 'F', 400000, 0, 'BA', 'Branch 2', 1),
    ('WA0020003', 'Hoa', 'Bui Quynh', 'F', 300000, 0, 'WA', 'Branch 2', 1),
    ('CA0020004', 'Nhan', 'Nguyen Thien', 'M', 300000, 0, 'CA', 'Branch 2', 1),
    ('SH0020005', 'Minh', 'Le Hong', 'M', 250000, 0, 'SH', 'Branch 2', 1),
    ('SH0020006', 'Khang', 'Vu Manh', 'M', 200000, 1, 'SH', 'Branch 2', 1),

    ('MA0030001', 'Chau', 'Nguyen Thi', 'F', 500000, 0, 'MA', 'Branch 3', 1),
    ('BA0030002', 'Thu', 'Le Anh', 'F', 400000, 0, 'BA', 'Branch 3', 1),
    ('WA0030003', 'Yen', 'Liu Ngoc', 'F', 300000, 0, 'WA', 'Branch 3', 1),
    ('CA0030004', 'Minh', 'Pham Quang', 'M', 300000, 0, 'CA', 'Branch 3', 1),
    ('SH0030005', 'Ben', 'Jamin', 'M', 250000, 0, 'SH', 'Branch 3', 1),
    ('SH0030006', 'Phuc', 'Vu Manh', 'M', 200000, 1, 'SH', 'Branch 3', 1),

    ('MA0040001', 'Tai', 'Huynh Tan', 'M', 500000, 0, 'MA', 'Branch 4', 1),
    ('BA0040002', 'Ngoc', 'Nguyen Hong', 'F', 400000, 0, 'BA', 'Branch 4', 1),
    ('WA0040003', 'Anh', 'Le Nhat', 'M', 300000, 0, 'WA', 'Branch 4', 1),
    ('CA0040004', 'Vu', 'Hoang Anh', 'M', 300000, 0, 'CA', 'Branch 4', 1),
    ('SH0040005', 'Nam', 'Pham Nguyen', 'M', 250000, 0, 'SH', 'Branch 4', 1);
SELECT * FROM Employee

-- Điện thoại nhân viên
INSERT INTO
    EmployeePhone (EID, Phone, Status)
VALUES
    ('MA0010001', '0900111221', 1),
    ('MA0010001', '0910111221', 1),
    ('BA0010002', '0900111222', 1),
    ('WA0010003', '0900111223', 1),
    ('CA0010004', '0900111224', 1),
    ('SH0010005', '0900111225', 1),
    ('SH0010006', '0900111226', 1),

    ('MA0020001', '0900111331', 1),
    ('BA0020002', '0900111332', 1),
    ('BA0020002', '0910111332', 1),
    ('WA0020003', '0900111333', 1),
    ('CA0020004', '0900111334', 1),
    ('SH0020005', '0900111335', 1),
    ('SH0020006', '0900111336', 1),

    ('MA0030001', '0900111441', 1),
    ('BA0030002', '0900111442', 1),
    ('WA0030003', '0900111443', 1),
    ('WA0030003', '0910111443', 1),
    ('SH0030005', '0900111445', 1),
    ('SH0030006', '0900111446', 1),

    ('MA0040001', '0900111551', 1),
    ('BA0040002', '0900111552', 1),
    ('WA0040003', '0900111553', 1),
    ('CA0040004', '0900111554', 1),
    ('CA0040004', '0910111554', 1),
    ('CA0040004', '0920111554', 1);
SELECT * FROM EmployeePhone

-- Ngày làm việc
INSERT INTO
    WorkDay (WeekDay, Status)
VALUES
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1);
SELECT * FROM WorkDay

-- Ca làm việc
INSERT INTO
    Shift (WeekDay, StartHour, Status)
VALUES
    (2, '08:00:00', 1),
    (2, '13:00:00', 1),
    (2, '18:00:00', 1),

    (3, '08:00:00', 1),
    (3, '13:00:00', 1),
    (3, '18:00:00', 1),

    (4, '08:00:00', 1),
    (4, '13:00:00', 1),
    (4, '18:00:00', 1),

    (5, '08:00:00', 1),
    (5, '13:00:00', 1),
    (5, '18:00:00', 1),
    
    (6, '08:00:00', 1),
    (6, '13:00:00', 1),
    (6, '18:00:00', 1),
    
    (7, '08:00:00', 1),
    (7, '13:00:00', 1),
    (7, '18:00:00', 1),
    
    (8, '08:00:00', 1),
    (8, '13:00:00', 1),
    (8, '18:00:00', 1);
SELECT * FROM Shift

-- Đăng ký ca làm việc
INSERT INTO
    Register (EID, WeekDay, StartHour, Status)
VALUES
    ('MA0010001', 2, '08:00:00', 1),
    ('BA0010002', 2, '13:00:00', 1),
    ('WA0010003', 2, '18:00:00', 1),
    ('CA0010004', 3, '08:00:00', 1),
    ('SH0010005', 3, '13:00:00', 1),
    ('BA0010002', 4, '08:00:00', 1),
    ('WA0010003', 4, '13:00:00', 1),
    ('CA0010004', 4, '18:00:00', 1),
    ('SH0010005', 5, '08:00:00', 1),
    ('SH0030005', 5, '13:00:00', 1),
    ('SH0010006', 5, '18:00:00', 1),
    ('SH0010006', 6, '08:00:00', 1),
    ('SH0010006', 6, '13:00:00', 1),
    ('CA0020004', 6, '18:00:00', 1),
    ('WA0030003', 7, '08:00:00', 1),
    ('WA0040003', 7, '13:00:00', 1),
    ('SH0040005', 7, '18:00:00', 1),
    ('SH0040005', 8, '08:00:00', 1),
    ('BA0010002', 8, '13:00:00', 1),
    ('WA0020003', 8, '18:00:00', 1);
SELECT * FROM Register


INSERT INTO
    WorksIn (EID, WeekDay, StartHour, Date, Status)
VALUES
    ('MA0010001', 2, '08:00:00', '2024-12-01', 1),
    ('BA0010002', 2, '13:00:00', '2024-12-01', 1),
    ('WA0010003', 2, '18:00:00', '2024-12-01', 1),
    ('CA0010004', 3, '08:00:00', '2024-12-02', 1),
    ('SH0010005', 3, '13:00:00', '2024-12-02', 1),
    ('BA0010002', 4, '08:00:00', '2024-12-03', 1),
    ('WA0010003', 4, '13:00:00', '2024-12-03', 1),
    ('CA0010004', 4, '18:00:00', '2024-12-03', 1),
    ('SH0010005', 5, '08:00:00', '2024-12-04', 1),
    ('SH0030005', 5, '13:00:00', '2024-12-04', 1),
    ('SH0010006', 5, '18:00:00', '2024-12-04', 1),
    ('SH0010006', 6, '08:00:00', '2024-12-05', 1),
    ('SH0010006', 6, '13:00:00', '2024-12-05', 1),
    ('CA0020004', 6, '18:00:00', '2024-12-05', 1),
    ('WA0030003', 7, '08:00:00', '2024-12-06', 1),
    ('WA0040003', 7, '13:00:00', '2024-12-06', 1),
    ('SH0040005', 7, '18:00:00', '2024-12-06', 1),
    ('SH0040005', 8, '08:00:00', '2024-12-07', 1),
    ('BA0010002', 8, '13:00:00', '2024-12-07', 1),
    ('WA0020003', 8, '18:00:00', '2024-12-07', 1);
SELECT * FROM WorksIn

INSERT INTO
    Membership (Name, Threshold, DiscountPercent, Status)
VALUES
    ('Default', 0, 0, 1),
    ('Bronze', 100, 0.05, 1),
    ('Silver', 300, 0.1, 1),
    ('Gold', 500, 0.15, 1);
SELECT * FROM Membership


INSERT INTO
    Customer (Phone, FirstName, LastName, Gender, MembershipPoint, MembershipID, Password, Status)
VALUES
    ('0842000111', 'Hoan', 'Vu Khai', 'M', 100, 2, '123456', 1),
    ('0842000222', 'Khanh', 'Tran Quoc', 'F', 300, 3, '123456', 1),
    ('0842000333', 'Khoi', 'Duong Hoang', 'M', 500, 4, '123456', 1),
    ('0842000444', 'Lam', 'Tran Thanh', 'F', 75, 1, '123456', 1),
    ('0842000555', 'Tin', 'Nguyen Trung', 'M', 900, 4, '123456', 1),
    ('0842000666', 'Ha', 'Tran Thi', 'F', 1100, 4, '123456', 1),
    ('0842000777', 'Gio', 'Nguyen Van', 'M', 300, 3, '123456', 1),
    ('0842000888', 'Huong', 'Tran Thu', 'F', 0, 1, '123456', 1),
    ('0842000999', 'Y', 'Nguyen', 'M', 0, 1, '123456', 1),
    ('0842001010', 'Kien', 'Tran Ngoc', 'F', 50, 1, '123456', 1);
SELECT * FROM Customer

INSERT INTO
    CustomerAddress (CusPhone, ApartmentNo, Street, District, City, Status)
VALUES
    ('0842000111', '123', 'A', '1', 'Ho Chi Minh', 1),
    ('0842000111', '123', 'B', '2', 'Ho Chi Minh', 1),
    ('0842000555', '123', 'C', '3', 'Ho Chi Minh', 1),
    ('0842000777', '123', 'D', '4', 'Can Tho', 1),
    ('0842000777', '123', 'E', '5', 'Can Tho', 1),
    ('0842000777', '123', 'F', '6', 'Can Tho', 1),
    ('0842000999', '123', 'G', '7', 'Da Nang', 1),
    ('0842001010', '123', 'H', '8', 'Da Nang', 1),
    ('0842001010', '123', 'I', '9', 'Da Nang', 1);
SELECT * FROM CustomerAddress

INSERT INTO
    Ingredient (Name, ImportPrice, Status) -- Price per kilogram
VALUES
    ('Bot Mi', 50000, 1),
    ('Duong', 20000, 1),
    ('Muoi', 30000, 1),
    ('Socola', 100000, 1),
    ('Vani', 120000, 1),
    ('Matcha', 100000, 1);
SELECT * FROM Ingredient

INSERT INTO
    Cake (Name, Price, IsSalty, IsSweet, IsOther, IsOrder, CustomerNote, Status)
VALUES
    ('Salty Cake A', 50000, 1, 0, 0, 0, NULL, 1),
    ('Sweet Cake B', 20000, 0, 1, 0, 0, NULL, 1),
    ('Salty Cake C', 30000, 1, 0, 0, 0, NULL, 1),
    ('Other Cake D', 100000, 0, 0, 1, 0, NULL, 1),
    ('Other Cake E', 120000, 0, 0, 1, 0, NULL, 1),
    ('Sweet Cake F', 100000, 0, 1, 0, 0, NULL, 1),
    ('Birthday Cake', 500000, 0, 0, 0, 1, '3 tang, 6 nen', 1),
    ('Sweet Cake H', 20000, 0, 0, 0, 1, 'giao som', 1),
    ('Salty Cake I', 30000, 1, 0, 0, 0, NULL, 1),
    ('Other Cake J', 100000, 0, 0, 1, 0, NULL, 1),
    ('Aniversay Cake', 400000, 0, 0, 0, 1, 'full hong', 1),
    ('Sweet Cake L', 100000, 0, 1, 0, 0, NULL, 1);
SELECT * FROM Cake

INSERT INTO
    ComboCake (CakeID1, CakeID2, Price, Status)
VALUES
    (1, 2, 65000, 1),
    (3, 4, 120000, 1),
    (5, 9, 130000, 1);
SELECT * FROM ComboCake

INSERT INTO
    CakeHasIngredient (CakeID, IngredientID, Amount, Unit, Status)
VALUES
    (1, 1, 500, 'gram', 1),
    (1, 2, 20, 'kg', 1),
    (2, 2, 200, 'gram', 1),
    (2, 3, 300, 'ml', 1),
    (4, 1, 100, 'ml', 1);
SELECT * FROM CakeHasIngredient

INSERT INTO
    Bill (ReceiveAddress, ReceiveMoney, Date, CashierID, CustomerPhone, TotalPrice, [Status])
VALUES
    (N'123 Đường A', 400000, '2024-12-01 10:00:00', 'CA0010004', '0842000111', 400000, 1),
    (N'456 Đường B', 200000, '2024-12-02 15:00:00', 'CA0020004', '0842000222', 50000, 1),
    (N'789 Đường C', 100000, '2024-12-03 17:00:00', 'CA0020004', '0842000444', 95000, 1),
    (N'1010 Đường D', 32000, '2024-12-04 11:00:00', 'CA0030004', '0842000555', 31000, 1),
    (N'1212 Đường E', 250000, '2024-12-05 16:00:00', 'CA0030004', '0842000777', 238000, 1);
SELECT * FROM Bill

INSERT INTO
    TotalBillCoupon (CurrentAmount, InitialAmount, DiscountPercent, DiscountMax, StartDate, EndDate, Status)
VALUES
    (48, 50, 0.05, 10000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 5%, tối đa 10,000 VND
    (98, 100, 0.05, 20000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 5%, tối đa 20,000 VND
    (149, 150, 0.1, 30000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 10%, tối đa 30,000 VND
    (250, 250, 0.1, 50000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 10%, tối đa 50,000 VND
    (375, 375, 0.15, 75000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 15%, tối đa 75,000 VND
    (500, 500, 0.15, 100000, '2024-01-01', '2024-12-31', 1); -- Giảm giá 15%, tối đa 100,000 VND
SELECT * FROM TotalBillCoupon


-- Adding missing references for BillApplyTotalBillCoupon
INSERT INTO
    BillApplyTotalBillCoupon (BillID, CouponID, Status)
VALUES
    (1, 1, 1), -- BillID 1 applies CouponID 1 (TotalBillCoupon)
    (2, 2, 1), -- BillID 2 applies CouponID 2 (TotalBillCoupon)
    (3, 4, 1); -- BillID 3 applies CouponID 4 (TotalBillCoupon)
SELECT * FROM BillApplyTotalBillCoupon

-- BillID 5 applies CouponID 5 (TotalBillCoupon)
INSERT INTO
    PerProductCoupon (DiscountAmount, StartDate, EndDate, CakeID, Status)
VALUES
    (5000, '2024-01-01', '2024-01-30', 1, 1),
    (3000, '2024-01-01', '2024-03-31', 2, 1),
    (10000, '2024-03-01', '2024-03-31', 3, 1),
    (7000, '2023-04-01', '2023-04-30', 4, 1),
    (2000, '2024-02-01', '2024-02-28', 4, 1);
SELECT * FROM PerProductCoupon

-- Adding missing references for BillApplyPerProductCoupon
INSERT INTO
    BillApplyPerProductCoupon (BillID, CouponID, Status)
VALUES
    (1, 1, 1), -- BillID 1 applies CouponID 1 (PerProductCoupon)
    (2, 2, 1), -- BillID 2 applies CouponID 2 (PerProductCoupon)
    (3, 3, 1), -- BillID 3 applies CouponID 3 (PerProductCoupon)
    (4, 4, 1), -- BillID 4 applies CouponID 4 (PerProductCoupon)
    (5, 5, 1);
SELECT * FROM BillApplyPerProductCoupon

-- BillID 5 applies CouponID 5 (PerProductCoupon)
INSERT INTO
    Decoration (Name, Price, Status)
VALUES
    (N'Nen', 15000, 1),
    (N'Hop qua', 50000, 1),
    (N'Ruy bang', 15000, 1),
    (N'Khung anh', 100000, 1),
    (N'Ken giay', 20000, 1);
SELECT * FROM Decoration

-- Adding missing references for BillBonusDecoration
INSERT INTO
    BillBonusDecoration (BillID, DecorationID, Amount, Status)
VALUES
    (1, 1, 5, 1);
SELECT * FROM BillBonusDecoration

INSERT INTO
    BillHasCake (BillID, CakeID, Amount, Status)
VALUES
    (1, 1, 2, 1), -- BillID 1 includes CakeID 1
    (2, 4, 2, 1), -- BillID 2 includes CakeID 4
    (3, 4, 3, 1), -- BillID 3 includes CakeID 5
    (3, 1, 1, 1), -- BillID 3 includes CakeID 1
    (4, 2, 4, 1), -- BillID 4 includes CakeID 2
    (4, 3, 2, 1), -- BillID 4 includes CakeID 3
    (5, 4, 1, 1); -- BillID 5 includes CakeID 4
SELECT * FROM BillHasCake

USE [bakery]
GO

-- Remove the user from all roles
ALTER ROLE [db_accessadmin] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_datareader] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_datawriter] DROP MEMBER [dbs_admin]
GO
ALTER ROLE [db_owner] DROP MEMBER [dbs_admin]
GO

-- Drop the user
DROP USER [dbs_admin]
GO

CREATE USER [dbs_admin] FOR LOGIN [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [dbs_admin]
GO
USE [bakery]
GO
ALTER ROLE [db_owner] ADD MEMBER [dbs_admin]
GO

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

USE bakery
GO

-- delete function if exists
-- IF OBJECT_ID('dbo.CalculateEmployeeTotalSalary', 'FN') IS NOT NULL
--     DROP FUNCTION dbo.CalculateEmployeeTotalSalary;

CREATE OR ALTER FUNCTION dbo.CalculateEmployeeTotalSalary
(
    @EID CHAR(9),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @BonusRate DECIMAL(5,2)
)
RETURNS @ResultTable TABLE
(
    TotalSalary MONEY,
    WeekDayShifts INT,
    WeekendShifts INT
)
AS
BEGIN
    DECLARE @TotalSalary MONEY = 0;
    DECLARE @WeekDayShifts INT;
    DECLARE @WeekendShifts INT;
    DECLARE @BaseSalary MONEY;
    DECLARE @TotalWorkedShifts INT;
    DECLARE @TotalAvailableShifts INT;
    DECLARE @Bonus MONEY;

    -- Validate EID
    IF NOT EXISTS (SELECT 1 FROM Employee WHERE ID = @EID)
    BEGIN
        RETURN;
    END

    -- Validate start and end date
    IF @StartDate > @EndDate
    BEGIN
        RETURN;
    END

    -- set bonus rate to 1 if null
    IF @BonusRate IS NULL
        SET @BonusRate = 1;

    -- Get the base salary
    SELECT @BaseSalary = Salary
    FROM Employee
    WHERE ID = @EID;

    -- Get the number of shifts worked Monday to Friday
    SET @WeekDayShifts = (
        SELECT COUNT(*)
        FROM WorksIn wi
        JOIN Shift s ON wi.WeekDay = s.WeekDay AND wi.StartHour = s.StartHour
        WHERE wi.EID = @EID
            AND wi.Date BETWEEN @StartDate AND @EndDate
            AND s.WeekDay BETWEEN 2 AND 6
    );

    -- Calculate number of shifts worked on Saturday and Sunday
    SET @WeekendShifts = (
        SELECT COUNT(*)
        FROM WorksIn wi
        JOIN Shift s ON wi.WeekDay = s.WeekDay AND wi.StartHour = s.StartHour
        WHERE wi.EID = @EID
            AND wi.Date BETWEEN @StartDate AND @EndDate
            AND s.WeekDay IN (7, 8)
    );

    -- Calculate total worked shifts
    SET @TotalWorkedShifts = @WeekDayShifts + @WeekendShifts;

    -- Calculate total shifts available in the period
    SET @TotalAvailableShifts = DATEDIFF(DAY, @StartDate, @EndDate) * 3; -- 3 shifts per day

    -- Check if employee worked more than 90% of available shifts
    IF @TotalWorkedShifts >= @TotalAvailableShifts * 0.9
        SET @Bonus = 200000; -- 200,000 VND bonus
    ELSE
        SET @Bonus = 0;

    -- Calculate total salary
    SET @TotalSalary = 
        (@WeekDayShifts * @BaseSalary) +
        (@WeekendShifts * @BaseSalary * @BonusRate) +
        @Bonus;

    -- Insert result into the table variable
    INSERT INTO @ResultTable (TotalSalary, WeekDayShifts, WeekendShifts)
    VALUES (@TotalSalary, @WeekDayShifts, @WeekendShifts);

    RETURN;
END;
GO

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

