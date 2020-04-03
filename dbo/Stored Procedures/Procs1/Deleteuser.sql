CREATE PROCEDURE [dbo].[Deleteuser]
(
   @UserId nvarchar(55),
   @DomainId varchar(50)
)
as
begin
update IssueTracker_Users
set IsActive='False'
where UserId=@UserId and DomainId = @DomainId
--delete from TXN_PROVIDER_LOGIN where user_id=@UserId
end

