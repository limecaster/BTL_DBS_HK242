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



--TEST--
UPDATE Customer
SET MembershipPoint = 600
WHERE Phone = '0842000111';

SELECT *
FROM [bakery].[dbo].[Customer]
WHERE Phone = '0842000111'

SELECT *
FROM Membership

