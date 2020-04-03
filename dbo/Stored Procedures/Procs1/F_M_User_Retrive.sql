CREATE PROCEDURE [dbo].[F_M_User_Retrive]  
(  
 @DomainId NVARCHAR(50),  
 @i_a_User_Id INT = 0  
)  
AS          
BEGIN    
  
 IF(@i_a_User_Id = 0)  
 BEGIN  
    SELECT   
   USR.UserId,  
   USR.UserName,  
   USR.UserPassword,  
   USR.first_name,  
   USR.last_name,  
   USR.UserRole,  
   USR.RoleId,  
   USR.UserType,  
   USR.Email,  
   USR.IsActive  
  FROM  
   IssueTracker_Users  USR     
     WHERE  
         ISNULL(USR.UserType,'')<>'P'  
   AND DomainId=@DomainId  
   AND IsActive = 1
  ORDER BY   
   USR.UserName   
    
 END  
   
  
   
END  
  
