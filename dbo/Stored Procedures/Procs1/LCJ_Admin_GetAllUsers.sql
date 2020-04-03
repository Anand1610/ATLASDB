CREATE PROCEDURE [dbo].[LCJ_Admin_GetAllUsers] 
@DomainId NVARCHAR(50)
AS
SELECT '' AS DeskInfo, UserId, Username, DisplayName, RoleName,'' as DeleteUser
FROM 
	IssueTracker_Users
LEFT OUTER JOIN
	IssueTracker_Roles
ON
	IssueTracker_Users.RoleId = IssueTracker_Roles.RoleId
WHERE IssueTracker_Users.IsActive='True'
AND IssueTracker_Users.DomainId=@DomainId

