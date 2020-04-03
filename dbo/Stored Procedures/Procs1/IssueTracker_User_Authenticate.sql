CREATE PROCEDURE [dbo].[IssueTracker_User_Authenticate] 
  @DomainId NVARCHAR(50),
  @Username NVarChar(255),
  @Password NVarChar(255)
AS
Declare @userId as nvarchar(50)
Declare @AutoId as nvarchar(50)
set @userId =(SELECT UserId FROM IssueTracker_Users WHERE Username = @Username AND UserPassword = @Password and IsActive='True' and DomainId=@DomainId)
IF EXISTS( SELECT UserId FROM IssueTracker_Users WHERE Username = @Username AND UserPassword = @Password and IsActive='True'and DomainId=@DomainId)
begin
insert into IssueTracker_Users_LoginTime(UserId,Login_Time, DomainId) values (@userId,getdate(), @DomainId)
set @AutoId=(select top 1 AutoId from IssueTracker_Users_LoginTime WHERE DomainId=@DomainId  order by Login_Time desc)
RETURN @AutoId
End
ELSE
RETURN -1

