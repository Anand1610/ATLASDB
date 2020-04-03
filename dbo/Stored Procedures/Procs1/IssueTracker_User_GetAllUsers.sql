CREATE PROCEDURE [dbo].[IssueTracker_User_GetAllUsers] 
@DomainId NVARCHAR(50)
AS
SELECT UserId, Username, UserPassword, DisplayName, Email, RoleName, UserTypeLogin, UserType
FROM 
	IssueTracker_Users
LEFT OUTER JOIN
	IssueTracker_Roles
ON
	IssueTracker_Users.RoleId = IssueTracker_Roles.RoleId
	AND IssueTracker_Users.DomainId = IssueTracker_Roles.DomainId
WHERE IssueTracker_Users.DomainId=@DomainId

