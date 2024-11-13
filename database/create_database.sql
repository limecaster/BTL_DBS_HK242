-- Microsoft SQL Server 2022

-- DROP Database
USE master;
GO
DROP DATABASE bakery;
GO

-- CREATE database
CREATE DATABASE bakery;
GO
USE bakery;
GO


CREATE TABLE Branch (
    Name NVARCHAR(255) PRIMARY KEY,
    Address NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(255) NOT NULL,
    OpenHour TIME,
    CloseHour TIME,
    OpenDate DATE,
	Status INT
);

CREATE TABLE EmployeeType (
    ID NVARCHAR(2) PRIMARY KEY,
    JobName NVARCHAR(50) NOT NULL,
	Status INT
)   

CREATE TABLE EmployeePhone (
    ID INT IDENTITY(1, 1) PRIMARY KEY,
    Phone CHAR(10) NOT NULL,
	Status INT
)

CREATE TABLE Employee (
    ID CHAR(9) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Gender BIT,
    Salary MONEY,
    IsPartTime BIT,
	EPhoneID INT NOT NULL,
	ETypeID NVARCHAR(2) NOT NULL,
	BranchName NVARCHAR(255),
	Status INT,

	CONSTRAINT fk_emp_emp_phone FOREIGN KEY (EPhoneID)		REFERENCES EmployeePhone(ID),
	CONSTRAINT fk_emp_emp_type	FOREIGN KEY (ETypeID)		REFERENCES EmployeeType(ID),
	CONSTRAINT fk_emp_branch	FOREIGN KEY (BranchName)	REFERENCES Branch(Name),
)

CREATE TABLE Membership (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(50),
	Threshold INT,
	DiscountPercent DECIMAL(5, 2),
	Status INT
)

CREATE TABLE CustomerAddress (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	ApartmentNo NVARCHAR(200),
	Street NVARCHAR(200),
	District NVARCHAR(200),
	City NVARCHAR(200),
	Status INT
)

CREATE TABLE Customer (
	Phone CHAR(10) PRIMARY KEY,
	FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
	Gender BIT,
	AddressID INT,
	MembershipPoint INT,
	MembershipID INT,
	Password VARCHAR(255),
	Status INT,

	CONSTRAINT fk_cus_membership	FOREIGN KEY (MembershipID)	REFERENCES Membership(ID),
	CONSTRAINT fk_cus_cus_address	FOREIGN KEY (AddressID)		REFERENCES CustomerAddress(ID),
)

CREATE TABLE Ingredient (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(255),
	ImportPrice Money,
	Status INT
)

CREATE TABLE Cake (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(255),
	Price MONEY,
	IsSalty BIT,
	IsSweet BIT,
	IsOther BIT,
	IsOrder BIT,
	CustomerNote NTEXT,
	Status INT
)

CREATE TABLE Bill (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	ReceiveAddress NVARCHAR(255),
	ReceiveMONEY MONEY,
	Date DATETIME,
	CashierID CHAR(9) NOT NULL,
	CustomerPhone CHAR(10) NOT NULL,
	Status INT,

	CONSTRAINT fk_bill_cus	FOREIGN KEY (CustomerPhone)	REFERENCES	Customer(Phone),
	CONSTRAINT fk_bill_emp	FOREIGN KEY (CashierID)		REFERENCES	Employee(ID)
)

CREATE TABLE TotalBillCoupon (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	CurrentAmount INT,
	InitialAmount INT,
	DiscountPercent DECIMAL(5, 2),
	DiscountMax DECIMAL(5, 2),
	StartDate DATETIME,
	EndDate DATETIME,
	Status INT
)

CREATE TABLE BillApplyTotalBillCoupon (
	BillID INT,
	CouponID INT,
	Status INT,

	PRIMARY KEY (BillID, CouponID),

	CONSTRAINT fk_billapplytotalbillcoupon_bill				FOREIGN KEY (BillID)	REFERENCES Bill(ID),
	CONSTRAINT fk_billapplytotalbillcoupon_totalbillcoupon	FOREIGN KEY (CouponID)	REFERENCES TotalBillCoupon(ID)
)

CREATE TABLE PerProductCoupon (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	DiscountAmount MONEY,
	StartDate DATETIME,
	EndDate DATETIME,
	CakeID INT NOT NULL,
	Status INT,

	CONSTRAINT fk_perproductcoupon_cake FOREIGN KEY (CakeID) REFERENCES Cake(ID)
)

CREATE TABLE BillApplyPerProductCoupon (
	BillID INT,
	CouponID INT,
	Status INT,

	PRIMARY KEY (BillID, CouponID),

	CONSTRAINT fk_billapplyperproductcoupon_bill				FOREIGN KEY (BillID)	REFERENCES Bill(ID),
	CONSTRAINT fk_billapplyperproductcoupon_perproductcoupon	FOREIGN KEY (CouponID)	REFERENCES PerProductCoupon(ID)
)

CREATE TABLE Decoration (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(255),
	Price MONEY,
	Status INT
)

CREATE TABLE BillBonusDecoration (
	BillID INT,
	DecorationID INT,
	Amount INT,
	Status INT,

	PRIMARY KEY (BillID, DecorationID),

	CONSTRAINT fk_billbonusdecoration_decoration	FOREIGN KEY (DecorationID)	REFERENCES Decoration(ID),
	CONSTRAINT fk_billbonusdecoration_bill			FOREIGN KEY (BillID)		REFERENCES Bill(ID)
)

CREATE TABLE BillHasCake (
	BillID INT,
	CakeID INT,
	Amount INT,
	Status INT,

	PRIMARY KEY (BillID, CakeID),

	CONSTRAINT fk_billhascake_cake FOREIGN KEY (CakeID) REFERENCES Cake(ID),
	CONSTRAINT fk_billhascake_bill FOREIGN KEY (BillID) REFERENCES Bill(ID)
)

CREATE TABLE ComboCake (
	CakeID1 INT,
	CakeID2 INT,
	Price Money,
	Status INT,

	PRIMARY KEY (CakeID1, CakeID2),

	CONSTRAINT fk_combocake_cake1 FOREIGN KEY (CakeID1) REFERENCES Cake(ID),
	CONSTRAINT fk_combocake_cake2 FOREIGN KEY (CakeID2) REFERENCES Cake(ID),
)

CREATE TABLE CakeHasIngredient (
	CakeID INT NOT NULL,
	IngredientID INT NOT NULL,
	Amount INT,
	Unit VARCHAR(10),
	Status INT,

	CONSTRAINT fk_cakehasingredient_cake		FOREIGN KEY (CakeID)		REFERENCES Cake(ID),
	CONSTRAINT fk_cakehasingredient_ingredient	FOREIGN KEY (IngredientID)	REFERENCES Ingredient(ID)
)

CREATE TABLE WorkDay (
	WeekDay INT PRIMARY KEY,
	Status INT,
)

CREATE TABLE Shift (
	WeekDay INT,
	StartHour DATETIME,
	Status INT,

	PRIMARY KEY (WeekDay, StartHour),

	CONSTRAINT fk_shift_workday FOREIGN KEY (WeekDay) REFERENCES WorkDay(WeekDay),
)

CREATE TABLE Register (
	EID CHAR(9) NOT NULL,
	WeekDay INT,
	StartHour DATETIME,
	Status INT,

	PRIMARY KEY (EID, WeekDay, StartHour),

	CONSTRAINT fk_register_emp		FOREIGN KEY (EID)					REFERENCES	Employee(ID),
	CONSTRAINT fk_register_shift	FOREIGN KEY (WeekDay, StartHour)	REFERENCES	Shift(WeekDay, StartHour)
)

CREATE TABLE WorksIn (
	EID CHAR(9) NOT NULL,
	WeekDay INT,
	StartHour DATETIME,
	Date DATETIME,
	Status INT,

	PRIMARY KEY (EID, WeekDay, StartHour, Date),

	CONSTRAINT fk_worksin_emp		FOREIGN KEY (EID)					REFERENCES	Employee(ID),
	CONSTRAINT fk_worksin_shift		FOREIGN KEY (WeekDay, StartHour)	REFERENCES	Shift(WeekDay, StartHour)
)