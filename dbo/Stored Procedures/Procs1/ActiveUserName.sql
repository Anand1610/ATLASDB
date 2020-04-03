CREATE PROCEDURE [dbo].[ActiveUserName]
(
   @UserName varchar(255)
)
as
begin
update IssueTracker_Users 
set IsActive='True'
where UserName=@UserName
end

