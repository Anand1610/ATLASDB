CREATE PROCEDURE [dbo].[F_IssueTracker_User_Authenticate]-- [F_IssueTracker_User_Authenticate] 'tech','lawallies12#$'
  @DomainId NVARCHAR(50),
  @s_a_user_name NVARCHAR(255),
  @s_a_password NVARCHAR(255)
AS
     DECLARE @s_l_userId AS NVARCHAR(50)
     DECLARE @i_l_AutoId AS INT
     
     SET @s_l_userId =(SELECT UserId FROM IssueTracker_Users WHERE Username = @s_a_user_name AND UserPassword = @s_a_password and IsActive='True' and DomainId=@DomainId)
     
     IF EXISTS( SELECT UserId FROM IssueTracker_Users WHERE Username = @s_a_user_name AND UserPassword = @s_a_password and IsActive='True' and DomainId=@DomainId)
     BEGIN
     
          INSERT INTO IssueTracker_Users_Logintime(UserId,Login_Time, DomainId) 
          VALUES (@s_l_userId,getdate(), @DomainId)
          
          SET @i_l_AutoId=(SELECT TOP 1 AutoId FROM IssueTracker_Users_Logintime WHERE DomainId=@DomainId ORDER BY Login_Time DESC)
     
     END
     
     SELECT 
          @i_l_AutoId AS LoginSessionID,
          UserType,
          UserTypeLogin,
          RoleId,
          DisplayName,
          UserName,
          UserId,
          Email
     FROM IssueTracker_Users 
     WHERE Username = @s_a_user_name 
          AND UserPassword = @s_a_password 
          AND IsActive='True'
		  AND DomainId=@DomainId

