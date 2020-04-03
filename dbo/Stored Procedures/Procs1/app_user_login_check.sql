
--app_user_login_check 'localhost','admin','lawspades@12'

CREATE PROCEDURE [dbo].[app_user_login_check]
(
	@DomainId	NVARCHAR(50),
	@UserName	NVARCHAR(255),
	@Password	NVarchar(255)
)
AS
BEGIN
	SELECT 
		UserId, 
		Username, 
		UserTypeLogin, 
		UserType,
		U.RoleId,
		DisplayName,
		RoleName,
		ProviderId,
		U.Email AS Email  
	from 
		IssueTracker_Users U
		INNER JOIN IssueTracker_Roles R ON  R.RoleId=U.RoleId
	where 
		UserName		=	LTRIM(RTRIM(@UserName)) AND
		UserPassword	=	LTRIM(RTRIM(@Password)) AND
		U.DomainId		=	@DomainId AND
		U.IsActive		=	1
END
