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

-- Test the trigger
INSERT INTO Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES ('Branch 1', '1234 Main St', '123-456-7890', '06:00:00', '22:00:00', '2021-01-01', 0, 1)

INSERT INTO Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES ('Branch 2', '5678 Main St', '098-765-4321', '07:00:00', '23:00:00', '2021-01-01', 0, 1)

INSERT INTO EmployeeType (ID, JobName, Status)
VALUES ('01', 'Manager', 1)

INSERT INTO EmployeeType (ID, JobName, Status)
VALUES ('02', 'Cashier', 1)

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('123456789', 'John', 'Doe', 'M', 50000, 0, '01', 'Branch 1', 1)

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('987654321', 'Jane', 'Doe', 'F', 30000, 1, '02', 'Branch 2', 1)

INSERT INTO EmployeePhone (EID, Phone, Status)
VALUES ('123456789', '1234567890', 1)

INSERT INTO EmployeePhone (EID, Phone, Status)
VALUES ('123456789', '0987654321', 1)

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