CREATE PROCEDURE [dbo].[Deleteproviders_of_userid]
(
   @UserName nvarchar(255),
   @UserPassword nvarchar(50)
)
as
declare @userid nvarchar(50)
begin
set @userid=(select UserId from IssueTracker_Users where UserName=@UserName and UserPassword=@UserPassword)
delete from TXN_PROVIDER_LOGIN where user_id=@userid
end

