CREATE PROCEDURE [dbo].[LCJ_ADMIN_USERS]
@DomainId NVARCHAR(50)

AS

Select USERID, LTRIM(RTRIM(UPPER(USERNAME))) AS USERNAME  from IssueTracker_Users where IsActive='True' and DomainId=@DomainId

