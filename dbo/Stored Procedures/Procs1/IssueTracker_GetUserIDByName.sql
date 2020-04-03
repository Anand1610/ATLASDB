CREATE PROCEDURE [dbo].[IssueTracker_GetUserIDByName]
	@DomainId NVARCHAR(50),
	@UserName varchar(50)
AS
SELECT MAX(UserId) as UserId  from IssueTracker_Users 
WHERE  UserName = @UserName
and DomainId=@DomainId

