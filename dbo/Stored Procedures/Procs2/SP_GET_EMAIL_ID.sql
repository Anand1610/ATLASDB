CREATE PROCEDURE [dbo].[SP_GET_EMAIL_ID] -- 'vinay'
(
	@DomainId AS NVARCHAR(50),
	@SZ_USER_NAME AS NVARCHAR(50)
)
AS
BEGIN
	SELECT Email [MailID] FROM IssueTracker_Users  where UserName = @SZ_USER_NAME and DomainId=@DomainId
END

