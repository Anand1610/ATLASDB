CREATE PROCEDURE [dbo].[IssueTracker_User_CreateNewUser]
	@DomainId NVARCHAR(50),
	@Username NVarChar(250),
	@RoleName NVarChar(100),
	@Email NVarChar(250),
	@DisplayName NVarChar(250),
	@UserPassword NVarChar(250),
	@UserTypeLogin	NVarChar(100),
	@UserType	NVarChar(10)
AS
IF EXISTS(SELECT UserId FROM IssueTracker_Users  WHERE Username = @Username and DomainId=@DomainId)
	RETURN 0

DECLARE @RoleId INT
SELECT @RoleId = RoleId FROM IssueTracker_Roles  WHERE RoleName = @RoleName and DomainId = @DomainId
--INSERT IssueTracker_Users 
--(
--	Username,
--	RoleId,
--	Email,
--	DisplayName,
--	UserPassword,
--	UserTypeLogin,
--	UserType,
--	DomainId
--) 
--VALUES 
--(
--	@Username,
--	@RoleId,
--	@Email,
--	@DisplayName,
--	@UserPassword,
--	@UserTypeLogin,
--	@UserType,
--	@DomainId
--)

RETURN @@IDENTITY

