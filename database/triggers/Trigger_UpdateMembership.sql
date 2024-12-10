use bakery
-- Trigger Tu dong cap nhat membershipID khi update membershipPoint

create trigger UpdateMembership
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

	if @MembershipPoint >= 500
		set @NewMembershipID = 3; -- Plantinum
	else if @MembershipPoint >= 300
		set @NewMembershipID = 2; -- Gold
	else if @MembershipPoint >= 100
		set @NewMembershipID = 1; -- Silver
	else
		set @NewMembershipID = null;

	update Customer
	set MembershipID = @NewMembershipID
	where Phone = @CustomerPhone
	end
end;


--TEST--
UPDATE Customer
SET MembershipPoint = 600
WHERE Phone = '0901234567';
