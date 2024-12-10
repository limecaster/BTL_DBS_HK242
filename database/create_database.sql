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
-- Employee
CREATE TABLE
	Branch (
		Name NVARCHAR (255) PRIMARY KEY,
		Address NVARCHAR (255) NOT NULL,
		Phone NVARCHAR (255) NOT NULL,
		OpenHour TIME CHECK (OpenHour>='05:30:00'),
		CloseHour TIME CHECK (CloseHour<='23:30:00'),
		OpenDate DATE,
		NumberOfEmployee INT DEFAULT 0,
		Status INT DEFAULT 1
	);


CREATE TABLE
	EmployeeType (ID NVARCHAR (2) PRIMARY KEY DEFAULT 'NA', JobName NVARCHAR (50) NOT NULL DEFAULT 'NA', Status INT DEFAULT 1)
CREATE TABLE
	Employee (
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
CREATE TABLE
	EmployeePhone (
		EID CHAR(9),
		Phone CHAR(10) NOT NULL,
		Status INT DEFAULT 1,
		PRIMARY KEY (EID, Phone),
		CONSTRAINT fk_empphone_emp_id FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	)
CREATE TABLE
	WorkDay (WeekDay INT PRIMARY KEY, Status INT DEFAULT 1,)
CREATE TABLE
	Shift (
		WeekDay INT,
		StartHour TIME,
		Status INT DEFAULT 1,
		PRIMARY KEY (WeekDay, StartHour),
		CONSTRAINT fk_shift_workday FOREIGN KEY (WeekDay) REFERENCES WorkDay (WeekDay) ON DELETE CASCADE ON UPDATE CASCADE,
	)
CREATE TABLE
	Register (
		EID CHAR(9) NOT NULL,
		WeekDay INT,
		StartHour TIME,
		Status INT DEFAULT 1,
		PRIMARY KEY (EID, WeekDay, StartHour),
		CONSTRAINT fk_register_emp FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_register_shift FOREIGN KEY (WeekDay, StartHour) REFERENCES Shift (WeekDay, StartHour) ON DELETE CASCADE ON UPDATE CASCADE,
	)
CREATE TABLE
	WorksIn (
		EID CHAR(9) NOT NULL,
		WeekDay INT,
		StartHour TIME,
		Date DATETIME,
		Status INT DEFAULT 1,
		PRIMARY KEY (EID, WeekDay, StartHour, Date),
		CONSTRAINT fk_worksin_emp FOREIGN KEY (EID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_worksin_shift FOREIGN KEY (WeekDay, StartHour) REFERENCES Shift (WeekDay, StartHour) ON DELETE CASCADE ON UPDATE CASCADE,
	)
	-- Customer
CREATE TABLE
	Membership (
		ID INT IDENTITY (1, 1) PRIMARY KEY,
		Name NVARCHAR (50),
		Threshold INT,
		DiscountPercent DECIMAL(5, 2),
		Status INT DEFAULT 1
	)
CREATE TABLE
	CustomerAddress (
		ID INT IDENTITY (1, 1) PRIMARY KEY,
		ApartmentNo NVARCHAR (200) NOT NULL,
		Street NVARCHAR (200) NOT NULL,
		District NVARCHAR (200) NOT NULL,
		City NVARCHAR (200) NOT NULL,
		Status INT DEFAULT 1
	)
CREATE TABLE
	Customer (
		Phone CHAR(10) PRIMARY KEY,
		FirstName NVARCHAR (100) NOT NULL,
		LastName NVARCHAR (100) NOT NULL,
		Gender NVARCHAR (1) CHECK (Gender IN ('M', 'F')),
		AddressID INT DEFAULT 0,
		MembershipPoint INT DEFAULT 0,
		MembershipID INT DEFAULT 0,
		Password VARCHAR(255),
		Status INT DEFAULT 1,
		CONSTRAINT fk_cus_membership FOREIGN KEY (MembershipID) REFERENCES Membership (ID) ON DELETE SET DEFAULT ON UPDATE CASCADE,
		CONSTRAINT fk_cus_cus_address FOREIGN KEY (AddressID) REFERENCES CustomerAddress (ID) ON DELETE SET DEFAULT ON UPDATE CASCADE,
	)
	-- Cake
CREATE TABLE
	Ingredient (ID INT IDENTITY (1, 1) PRIMARY KEY, Name NVARCHAR (255), ImportPrice Money, Status INT DEFAULT 1)
CREATE TABLE
	Cake (
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
CREATE TABLE
	ComboCake (
		CakeID1 INT,
		CakeID2 INT,
		Price Money,
		Status INT DEFAULT 1,
		PRIMARY KEY (CakeID1, CakeID2),
		CONSTRAINT fk_combocake_cake1 FOREIGN KEY (CakeID1) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
		CONSTRAINT fk_combocake_cake2 FOREIGN KEY (CakeID2) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	)
CREATE TABLE
	CakeHasIngredient (
		CakeID INT NOT NULL,
		IngredientID INT NOT NULL,
		Amount INT,
		Unit VARCHAR(10),
		Status INT DEFAULT 1,
		CONSTRAINT fk_cakehasingredient_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_cakehasingredient_ingredient FOREIGN KEY (IngredientID) REFERENCES Ingredient (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	)
	-- Bill & Coupons
CREATE TABLE
	Bill (
		ID INT IDENTITY (1, 1) PRIMARY KEY,
		ReceiveAddress NVARCHAR (255),
		ReceiveMoney MONEY,
		Date DATETIME,
		CashierID CHAR(9),
		CustomerPhone CHAR(10),
		TotalPrice MONEY,
		Status INT DEFAULT 1,
		CONSTRAINT fk_bill_cus FOREIGN KEY (CustomerPhone) REFERENCES Customer (Phone) ON DELETE SET NULL ON UPDATE CASCADE,
		CONSTRAINT fk_bill_emp FOREIGN KEY (CashierID) REFERENCES Employee (ID) ON DELETE SET NULL ON UPDATE CASCADE,
	)
CREATE TABLE
	TotalBillCoupon (
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
CREATE TABLE
	BillApplyTotalBillCoupon (
		BillID INT,
		CouponID INT,
		Status INT DEFAULT 1,
		PRIMARY KEY (BillID, CouponID),
		CONSTRAINT fk_billapplytotalbillcoupon_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_billapplytotalbillcoupon_totalbillcoupon FOREIGN KEY (CouponID) REFERENCES TotalBillCoupon (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
	)
CREATE TABLE
	PerProductCoupon (
		ID INT IDENTITY (1, 1) PRIMARY KEY,
		DiscountAmount MONEY,
		StartDate DATETIME,
		EndDate DATETIME,
		CakeID INT NOT NULL,
		Status INT DEFAULT 1,
		CONSTRAINT fk_perproductcoupon_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	)
CREATE TABLE
	BillApplyPerProductCoupon (
		BillID INT,
		CouponID INT,
		Status INT DEFAULT 1,
		PRIMARY KEY (BillID, CouponID),
		CONSTRAINT fk_billapplyperproductcoupon_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_billapplyperproductcoupon_perproductcoupon FOREIGN KEY (CouponID) REFERENCES PerProductCoupon (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
	)
CREATE TABLE
	Decoration (ID INT IDENTITY (1, 1) PRIMARY KEY, Name NVARCHAR (255), Price MONEY, Status INT DEFAULT 1)
CREATE TABLE
	BillBonusDecoration (
		BillID INT,
		DecorationID INT,
		Amount INT,
		Status INT DEFAULT 1,
		PRIMARY KEY (BillID, DecorationID),
		CONSTRAINT fk_billbonusdecoration_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_billbonusdecoration_decoration FOREIGN KEY (DecorationID) REFERENCES Decoration (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
	)
CREATE TABLE
	BillHasCake (
		BillID INT,
		CakeID INT,
		Amount INT,
		Status INT DEFAULT 1,
		PRIMARY KEY (BillID, CakeID),
		CONSTRAINT fk_billhascake_cake FOREIGN KEY (CakeID) REFERENCES Cake (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
		CONSTRAINT fk_billhascake_bill FOREIGN KEY (BillID) REFERENCES Bill (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	)