CREATE PROCEDURE [dbo].[selectAlluserName]
@DomainId NVARCHAR(50)
as
begin
select distinct UserName,IsActive from IssueTracker_Users WHERE DomainId=@DomainId
end

