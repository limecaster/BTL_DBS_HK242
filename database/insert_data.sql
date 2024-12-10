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