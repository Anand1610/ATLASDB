CREATE PROCEDURE [dbo].[DDL_Role_For_Funding]
@DomainId NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	SELECT '0' as RoleID, '---Select Role--- ' as RoleName
	
	UNION
	SELECT RoleId,RoleName FROM IssueTracker_Roles WHERE DomainId=@DomainId  ORDER BY RoleName 
	
	
	SET NOCOUNT OFF ;



END
