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



------------------------------------------------------------------------
--------------------------------- DEMO ---------------------------------
------------------------------------------------------------------------
-- Insert test employee data
INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES 
('MA0010012', 'John', 'Doe', 'F', 150000, 0, 'MA', 'Branch 2', 1),
('MA0010031', 'Jane', 'Smith', 'M', 180000, 0, 'MA', 'Branch 2', 1);

-- Insert test shifts
INSERT INTO Shift (WeekDay, StartHour, Status)
VALUES 
(2, '08:00:00', 1), -- Monday
(3, '08:00:00', 1), -- Tuesday
(4, '08:00:00', 1), -- Wednesday
(5, '08:00:00', 1), -- Thursday
(6, '08:00:00', 1), -- Friday
(7, '08:00:00', 1), -- Saturday
(8, '08:00:00', 1); -- Sunday

-- Insert test WorksIn records
INSERT INTO WorksIn (EID, WeekDay, StartHour, Date, Status)
VALUES
('MA0010012', 2, '08:00:00', '2024-12-01', 1), -- Monday shift
('MA0010012', 3, '08:00:00', '2024-12-02', 1), -- Tuesday shift
('MA0010012', 7, '08:00:00', '2024-12-07', 1), -- Saturday shift
('MA0010012', 8, '08:00:00', '2024-12-08', 1), -- Sunday shift
('MA0010031', 2, '08:00:00', '2024-12-01', 1), -- Monday shift
('MA0010031', 5, '08:00:00', '2024-12-05', 1), -- Thursday shift
('MA0010031', 7, '08:00:00', '2024-12-07', 1); -- Saturday shift

SELECT * FROM dbo.CalculateEmployeeTotalSalary('MA0010012', '2024-12-01', '2024-12-08', 1.2); -- ok
SELECT * FROM dbo.CalculateEmployeeTotalSalary('MA0010031', '2024-12-01', '2024-12-08', 1.2); -- ok
SELECT * FROM dbo.CalculateEmployeeTotalSalary('MA0013312', '2024-12-01', '2024-12-08', 1.2); -- invalid EID