CREATE PROCEDURE [dbo].[F_IssueTracker_User_LogOff] 
  @DomainId NVARCHAR(50),
  @i_a_LoginSessionID int
AS
BEGIN
     IF(@i_a_LoginSessionID <> 0)
     BEGIN
          UPDATE IssueTracker_Users_LoginTime
          SET Logout_time=getdate()
          WHERE AutoId=@i_a_LoginSessionID
		  AND DomainId=@DomainId
     END
END

