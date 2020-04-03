CREATE PROCEDURE [dbo].[F_DDL_USER_FOR_EVENT]
@DomainId NVARCHAR(50)	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT 0 as UserId, '' as Email,' ---Select User--- ' as UserName
	UNION
	SELECT UserId, Email,UserName
	FROM IssueTracker_Users WHERE IsActive = 1 
	 AND ISNULL(UserType,'') not in ('OSS','P') 
	 and DomainId=@DomainId
	ORDER BY UserName
	
	SET NOCOUNT OFF ; 


END

