CREATE PROCEDURE [dbo].[LCJ_DeleteRole]
(
@DomainId nvarchar(50),
@RoleId int
)
as
begin

declare @countrole as int
set @Countrole=(select count(roleid) from tblMenu_Access where roleid=1)
if @countrole>1 
begin
delete from tblmenu_access where DomainId = @DomainId and roleid=@roleid and MenuId = 7
delete from IssueTracker_Roles where RoleId= @RoleId AND DomainId = @DomainId
end
end

