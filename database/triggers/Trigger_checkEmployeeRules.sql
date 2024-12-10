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

drop trigger checkEmployeeRules

select * from Branch
select * from Employee where ETypeID = 'MA'

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('MA1234568', 'John', 'Doe', 1, 5000, 0, 'MA', 'Chi nhánh 1', 1); -- Hợp lệ


INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('CA1234567', 'Jane', 'Smith', 0, 4500, 1, 'MA', 'Chi nhánh 2', 1); -- Vi phạm ràng buộc 1

INSERT INTO Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES ('MA1234567', 'Jane', 'Smith', 0, 4500, 1, 'MA', 'Chi nhánh 2', 1); -- Vi phạm ràng buộc 1

