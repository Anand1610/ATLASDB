CREATE PROCEDURE [dbo].[IssueTracker_User_LogOff] 
   @DomainId NVARCHAR(50),
  @LoginId int
AS
update IssueTracker_Users_LoginTime
set Logout_time=getdate()
where AutoId=@LoginId
and DomainId=@DomainId

