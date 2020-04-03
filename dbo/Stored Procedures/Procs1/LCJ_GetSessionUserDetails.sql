CREATE PROCEDURE [dbo].[LCJ_GetSessionUserDetails] --[LCJ_GetSessionUserDetails] 'tech'
(
	@DomainId nvarchar(50),
	@UserName NVarchar(255)
)
AS

SELECT UserId, Username, UserTypeLogin, UserType,U.RoleId,DisplayName,RoleName,ProviderId,U.Email AS Email  from IssueTracker_Users U
INNER JOIN IssueTracker_Roles R ON  R.RoleId=U.RoleId
where UserName = LTRIM(RTRIM(@UserName))
AND U.DomainId=@DomainId
