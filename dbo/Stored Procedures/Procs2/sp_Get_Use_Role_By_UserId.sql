CREATE PROCEDURE [dbo].[sp_Get_Use_Role_By_UserId]   --'tech'
       @UserId      NVARCHAR(500)=1  
AS  
BEGIN  
print @UserId
    DECLARE @username AS NVARCHAR(MAX)
    SELECT RoleName from dbo.IssueTracker_Roles where RoleId =(SELECT RoleId  from dbo.IssueTracker_Users where UserName =@UserId)   
  END

