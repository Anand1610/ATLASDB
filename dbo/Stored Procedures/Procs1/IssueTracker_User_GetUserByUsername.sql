CREATE PROCEDURE [dbo].[IssueTracker_User_GetUserByUsername]
	@DomainId NVARCHAR(50),
	@Username NVarchar(255)
AS
SELECT 
	UserId, Username, UserPassword, Email, DisplayName, RoleName, UserTypeLogin, UserType
FROM 
	IssueTracker_Users
JOIN
	IssueTracker_Roles
ON 
	IssueTracker_Users.RoleId = IssueTracker_Roles.RoleId and IssueTracker_Users.DomainId = IssueTracker_Roles.DomainId
WHERE 
	Username = @Username
	AND IssueTracker_Users.DomainId=@DomainId

