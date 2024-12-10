USE bakery;
GO

CREATE OR ALTER TRIGGER TriggerUpdateNoEmp
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @BranchName NVARCHAR(255);
    
	-- Increase the NumberOfEmployee of the branch by 1 if Inserted
    IF EXISTS (SELECT * FROM inserted WHERE Status = 1) 
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee + 1
        WHERE Name IN (SELECT BranchName FROM inserted)

        SELECT @BranchName = BranchName FROM inserted;
        PRINT('Number of employees in the branch ' + @BranchName + ' has been increased by 1')
    END

    -- Decrease the NumberOfEmployee of the branch by 1 if Update status to 0
    ELSE IF EXISTS (SELECT * FROM inserted WHERE Status = 0)
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee - 1
        WHERE Name IN (SELECT BranchName FROM inserted)
        
        SELECT @BranchName = BranchName FROM inserted;
        PRINT('Number of employees in the branch ' + @BranchName + ' has been decreased by 1')
    END

    -- Update NumberOfEmployee if employee moved to another branch
    ELSE IF EXISTS (SELECT * FROM inserted WHERE Status = 1 AND BranchName IN (SELECT BranchName FROM deleted))
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee + 1
        WHERE Name IN (SELECT BranchName FROM inserted)

        SELECT @BranchName = BranchName FROM inserted;
        PRINT('Number of employees in the branch ' + @BranchName + ' has been increased by 1')
    END

    ELSE IF EXISTS (SELECT * FROM inserted WHERE Status = 0 AND BranchName IN (SELECT BranchName FROM deleted))
    BEGIN
        UPDATE Branch
        SET NumberOfEmployee = NumberOfEmployee - 1
        WHERE Name IN (SELECT BranchName FROM inserted)

        SELECT @BranchName = BranchName FROM inserted;
        PRINT('Number of employees in the branch ' + @BranchName + ' has been decreased by 1')
    END

END

-- Test the trigger
INSERT INTO Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES ('Branch 1', '1234 Main St', '123-456-7890', '06:00:00', '22:00:00', '2021-01-01', 0, 1)

INSERT INTO Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES ('Branch 2', '5678 Main St', '098-765-4321', '07:00:00', '23:00:00', '2021-01-01', 0, 1)

INSERT INTO EmployeeType (ID, JobName, Status)
VALUES ('01', 'Manager', 1)

INSERT INTO EmployeeType (ID, JobName, Status)
VALUES ('02', 'Cashier', 1)

INSERT INTO EmployeePhone (Phone, Status)
VALUES ('1234567890', 1)

INSERT INTO EmployeePhone (Phone, Status)
VALUES ('0987654321', 1)

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('123456789', 'John', 'Doe', 1, 50000, 0, '01', 'Branch 1', 1)

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('987654321', 'Jane', 'Doe', 0, 30000, 1, '02', 'Branch 2', 1)

UPDATE Employee
SET BranchName = 'Branch 2'
WHERE ID = '123456789'

UPDATE Employee
SET Status = 0
WHERE ID = '123456789'

UPDATE Employee
SET BranchName = 'Branch 1'
WHERE ID = '987654321'

UPDATE Employee
SET Status = 0
WHERE ID = '987654321'
