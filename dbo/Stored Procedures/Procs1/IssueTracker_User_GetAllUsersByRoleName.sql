CREATE PROCEDURE [dbo].[IssueTracker_User_GetAllUsersByRoleName]
	@DomainId NVARCHAR(50),
	@RoleName NVarChar(50) 
AS
DECLARE @RoleLevel Int

SELECT @RoleLevel = RoleLevel FROM IssueTracker_Roles WHERE RoleName = @RoleName and DomainId=@DomainId

SELECT 
	IssueTracker_Users.* 
FROM 
	IssueTracker_Users
	INNER JOIN IssueTracker_Roles ON IssueTracker_Users.RoleId = IssueTracker_Roles.RoleId
WHERE
	RoleLevel <= @RoleLevel

