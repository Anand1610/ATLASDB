CREATE PROCEDURE [dbo].[IssueTracker_Role_GetAllRoles]
@DomainId NVARCHAR(50)
AS
SELECT RoleId, RoleName FROM IssueTracker_Roles WHERE DomainId=@DomainId

