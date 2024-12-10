-- Sử dụng cơ sở dữ liệu bakery
USE bakery;


GO
-- Chi nhánh
INSERT INTO
    Branch (Name, Address, Phone, OpenHour, CloseHour, OpenDate, NumberOfEmployee, Status)
VALUES
    (
        'Chi nhánh 1',
        '123 Đường Chính, Thành phố A',
        '0912345678',
        '06:00:00',
        '22:00:00',
        '2020-01-01',
        15,
        1
    ),
    (
        'Chi nhánh 2',
        '456 Đường Phụ, Thành phố B',
        '0912345679',
        '05:30:00',
        '21:00:00',
        '2021-01-01',
        20,
        1
    ),
    (
        'Chi nhánh 3',
        '789 Đường Ba, Thành phố C',
        '0912345680',
        '07:00:00',
        '23:00:00',
        '2022-01-01',
        10,
        1
    ),
    (
        'Chi nhánh 4',
        '101 Đường Bốn, Thành phố D',
        '0912345681',
        '06:30:00',
        '20:30:00',
        '2023-01-01',
        25,
        1
    ),
    (
        'Chi nhánh 5',
        '202 Đường Năm, Thành phố E',
        '0912345682',
        '06:00:00',
        '22:30:00',
        '2020-06-15',
        30,
        1
    );


-- Loại nhân viên
INSERT INTO
    EmployeeType (ID, JobName, Status)
VALUES
    ('MA', 'Quản lý', 1),
    ('BA', 'Thợ làm bánh', 1),
    ('WA', 'Phục vụ', 1),
    ('CA', 'Thu ngân', 1),
    ('SH', 'Giao hàng', 1);


-- Nhân viên
INSERT INTO
    Employee (ID, FirstName, LastName, Gender, Salary, IsPartTime, ETypeID, BranchName, Status)
VALUES
    ('MA0010001', 'Nguyễn', 'Văn A', 1, 15000000, 0, 'MA', 'Chi nhánh 1', 1),
    ('BA0010002', 'Lê', 'Thị B', 0, 12000000, 0, 'BA', 'Chi nhánh 1', 1),
    ('WA0010003', 'Phạm', 'Văn C', 1, 70000, 1, 'WA', 'Chi nhánh 2', 1),
    ('CA0010004', 'Hoàng', 'Thị D', 0, 9000000, 0, 'CA', 'Chi nhánh 3', 1),
    ('SH0010005', 'Trần', 'Văn E', 1, 50000, 1, 'SH', 'Chi nhánh 4', 1),
    ('BA0010006', 'Võ', 'Thị F', 0, 11000000, 0, 'BA', 'Chi nhánh 5', 1),
    ('WA0010007', 'Đặng', 'Văn G', 1, 65000, 1, 'WA', 'Chi nhánh 1', 1),
    ('CA0010008', 'Lý', 'Thị H', 0, 8500000, 0, 'CA', 'Chi nhánh 2', 1),
    ('SH0010009', 'Ngô', 'Văn I', 1, 45000, 1, 'SH', 'Chi nhánh 3', 1),
    ('BA0010010', 'Trịnh', 'Thị K', 0, 11500000, 0, 'BA', 'Chi nhánh 4', 1);


-- Điện thoại nhân viên
INSERT INTO
    EmployeePhone (EID, Phone, Status)
VALUES
    ('MA0010001', '0911111111', 1),
    ('BA0010002', '0911111112', 1),
    ('WA0010003', '0911111113', 1),
    ('CA0010004', '0911111114', 1),
    ('SH0010005', '0911111115', 1),
    ('BA0010006', '0911111116', 1),
    ('WA0010007', '0911111117', 1),
    ('CA0010008', '0911111118', 1),
    ('SH0010009', '0911111119', 1),
    ('BA0010010', '0911111120', 1);


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
    ('BA0010006', 5, '13:00:00', 1),
    ('WA0010007', 5, '18:00:00', 1),
    ('CA0010008', 6, '08:00:00', 1),
    ('SH0010009', 6, '13:00:00', 1),
    ('BA0010010', 6, '18:00:00', 1),
    ('MA0010001', 7, '08:00:00', 1),
    ('BA0010002', 7, '13:00:00', 1),
    ('WA0010003', 7, '18:00:00', 1),
    ('CA0010004', 8, '08:00:00', 1),
    ('SH0010005', 8, '13:00:00', 1),
    ('BA0010006', 8, '18:00:00', 1);


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
    ('BA0010006', 5, '13:00:00', '2024-12-04', 1);


INSERT INTO
    Membership (Name, Threshold, DiscountPercent, Status)
VALUES
    (N'Silver', 100, 5.00, 1),
    (N'Gold', 300, 10.00, 1),
    (N'Platinum', 500, 15.00, 1);


-- Adding missing addresses for customers
INSERT INTO
    CustomerAddress (ApartmentNo, Street, District, City, Status)
VALUES
    (N'123A', N'Nguyễn Văn Cừ', N'Quận 5', N'TP.HCM', 1), -- Address for customer with phone '0901234567'
    (N'25D', N'Hồ Tùng Mậu', N'Quận 7', N'TP.HCM', 1), -- Address for customer with phone '0901234568'
    (N'30E', N'Chợ Lớn', N'Quận 8', N'TP.HCM', 1), -- Address for customer with phone '0901234569'
    (N'50F', N'Hoa Lan', N'Quận 9', N'TP.HCM', 1), -- Address for customer with phone '0901234570'
    (N'40G', N'Phan Văn Trị', N'Quận 10', N'TP.HCM', 1) -- Address for customer with phone '0901234571'
;


INSERT INTO
    Customer (Phone, FirstName, LastName, Gender, AddressID, MembershipPoint, MembershipID, Password, Status)
VALUES
    ('0901234567', N'Trần', N'Văn A', 1, 1, 150, 2, 'password123', 1),
    ('0901234568', N'Lê', N'Thị B', 0, 2, 320, 3, 'securepass', 1),
    ('0901234569', N'Nguyễn', N'Văn C', 1, 3, 50, 1, 'abc123', 1),
    ('0901234570', N'Võ', N'Văn D', 1, 4, 120, 2, 'mypassword1', 1),
    ('0901234571', N'Phan', N'Văn E', 0, 5, 230, 3, 'password2024', 1);


INSERT INTO
    Ingredient (Name, ImportPrice, Status)
VALUES
    (N'Bột mì', 20000, 1),
    (N'Đường', 15000, 1),
    (N'Sữa', 25000, 1),
    (N'Bơ', 40000, 1);


INSERT INTO
    Cake (Name, Price, IsSalty, IsSweet, IsOther, IsOrder, CustomerNote, Status)
VALUES
    (N'Bánh mì', 10000, 1, 0, 0, 0, NULL, 1),
    (N'Bánh ngọt', 20000, 0, 1, 0, 0, NULL, 1),
    (N'Bánh mặn', 30000, 1, 0, 0, 0, NULL, 1),
    (N'Bánh đặt 1', 50000, 0, 0, 1, 1, N'Không đường', 1);


INSERT INTO
    ComboCake (CakeID1, CakeID2, Price, Status)
VALUES
    (1, 2, 28000, 1),
    (3, 4, 70000, 1);


INSERT INTO
    CakeHasIngredient (CakeID, IngredientID, Amount, Unit, Status)
VALUES
    (1, 1, 500, N'gram', 1),
    (2, 2, 200, N'gram', 1),
    (3, 3, 300, N'gram', 1),
    (4, 4, 100, N'gram', 1);


INSERT INTO
    Bill (ReceiveAddress, ReceiveMoney, Date, CashierID, CustomerPhone, TotalPrice, [Status])
VALUES
    (N'123 Đường A', 100000, '2024-12-01 10:00:00', 'CA0010004', '0901234567', 400000, 1),
    (N'456 Đường B', 200000, '2024-12-02 15:00:00', 'CA0010004', '0901234568', 50000, 1),
    (N'789 Đường C', 150000, '2024-12-03 17:00:00', 'CA0010008', '0901234569', 95000, 1),
    (N'1010 Đường D', 250000, '2024-12-04 11:00:00', 'CA0010004', '0901234570', 31000, 1),
    (N'1212 Đường E', 500000, '2024-12-05 16:00:00', 'CA0010008', '0901234571', 238000, 1);


INSERT INTO
    TotalBillCoupon (CurrentAmount, InitialAmount, DiscountPercent, DiscountMax, StartDate, EndDate, Status)
VALUES
    (48, 50, 0.05, 10000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 5%, tối đa 10,000 VND
    (98, 100, 0.05, 20000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 5%, tối đa 20,000 VND
    (149, 150, 0.1, 30000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 10%, tối đa 30,000 VND
    (250, 250, 0.1, 50000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 10%, tối đa 50,000 VND
    (375, 375, 0.15, 75000, '2024-01-01', '2024-12-31', 1), -- Giảm giá 15%, tối đa 75,000 VND
    (500, 500, 0.15, 100000, '2024-01-01', '2024-12-31', 1) -- Giảm giá 15%, tối đa 100,000 VND
;


-- Adding missing references for BillApplyTotalBillCoupon
INSERT INTO
    BillApplyTotalBillCoupon (BillID, CouponID, Status)
VALUES
    (1, 1, 1), -- BillID 1 applies CouponID 1 (TotalBillCoupon)
    (2, 2, 1), -- BillID 2 applies CouponID 2 (TotalBillCoupon)
    (3, 3, 1), -- BillID 3 applies CouponID 3 (TotalBillCoupon)
    (4, 4, 1), -- BillID 4 applies CouponID 4 (TotalBillCoupon)
    (5, 5, 1);


-- BillID 5 applies CouponID 5 (TotalBillCoupon)
INSERT INTO
    PerProductCoupon (DiscountAmount, StartDate, EndDate, CakeID, Status)
VALUES
    (5000, '2024-01-01', '2024-06-30', 1, 1),
    (3000, '2024-01-01', '2024-12-31', 2, 1),
    (10000, '2024-03-01', '2024-12-31', 3, 1),
    (7000, '2024-04-01', '2024-12-31', 4, 1),
    (2000, '2024-02-01', '2024-12-31', 4, 1);


-- Adding missing references for BillApplyPerProductCoupon
INSERT INTO
    BillApplyPerProductCoupon (BillID, CouponID, Status)
VALUES
    (1, 1, 1), -- BillID 1 applies CouponID 1 (PerProductCoupon)
    (2, 2, 1), -- BillID 2 applies CouponID 2 (PerProductCoupon)
    (3, 3, 1), -- BillID 3 applies CouponID 3 (PerProductCoupon)
    (4, 4, 1), -- BillID 4 applies CouponID 4 (PerProductCoupon)
    (5, 5, 1);


-- BillID 5 applies CouponID 5 (PerProductCoupon)
INSERT INTO
    Decoration (Name, Price, Status)
VALUES
    (N'Nến sinh nhật', 20000, 1),
    (N'Hộp quà', 50000, 1),
    (N'Dây ruy băng', 15000, 1),
    (N'Khung ảnh', 80000, 1),
    (N'Đèn LED trang trí', 120000, 1);


-- Adding missing references for BillBonusDecoration
INSERT INTO
    BillBonusDecoration (BillID, DecorationID, Amount, Status)
VALUES
    (1, 1, 2, 1), -- BillID 1 applies DecorationID 1 (Nến sinh nhật)
    (2, 2, 1, 1), -- BillID 2 applies DecorationID 2 (Hộp quà)
    (3, 3, 3, 1), -- BillID 3 applies DecorationID 3 (Dây ruy băng)
    (4, 4, 1, 1), -- BillID 4 applies DecorationID 4 (Khung ảnh)
    (5, 5, 2, 1);


-- BillID 5 applies DecorationID 5 (Đèn LED trang trí)
-- Adding missing references for BillHasCake
INSERT INTO
    BillHasCake (BillID, CakeID, Amount, Status)
VALUES
    (1, 1, 2, 1), -- BillID 1 includes CakeID 1 (Bánh mì)
    (1, 2, 1, 1), -- BillID 1 includes CakeID 2 (Bánh ngọt)
    (2, 3, 1, 1), -- BillID 2 includes CakeID 3 (Bánh mặn)
    (2, 4, 2, 1), -- BillID 2 includes CakeID 4 (Bánh khác)
    (3, 4, 3, 1), -- BillID 3 includes CakeID 5 (Bánh khác)
    (3, 1, 1, 1), -- BillID 3 includes CakeID 1 (Bánh mì)
    (4, 2, 4, 1), -- BillID 4 includes CakeID 2 (Bánh ngọt)
    (4, 3, 2, 1), -- BillID 4 includes CakeID 3 (Bánh mặn)
    (5, 4, 1, 1);


-- BillID 5 includes CakeID 4 (Bánh khác)