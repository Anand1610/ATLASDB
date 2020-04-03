CREATE PROCEDURE [dbo].[IssueTracker_User_GetUserById]
	@DomainId NVARCHAR(50),
	@UserId Int
AS
SELECT 
	UserId, Username, UserPassword, Email, DisplayName, RoleName, UserTypeLogin, UserType
FROM 
	IssueTracker_Users
JOIN
	IssueTracker_Roles
ON 
	IssueTracker_Users.RoleId = IssueTracker_Roles.RoleId AND 
	IssueTracker_Users.DomainID = IssueTracker_Roles.DomainId
WHERE 
	UserId = @UserId
	and IssueTracker_Users.DomainId=@DomainId

