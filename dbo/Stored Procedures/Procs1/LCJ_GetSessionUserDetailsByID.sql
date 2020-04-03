CREATE PROCEDURE [dbo].[LCJ_GetSessionUserDetailsByID]-- [LCJ_GetSessionUserDetailsByID] '39654'  
(  
 @DomainId NVARCHAR(50),  
 @UserID NVarchar(255)  
)  
AS  
  
SELECT Username, UserTypeLogin, UserType,RoleId,DisplayName,UserPassword from IssueTracker_Users 
where UserId  = @UserID and DomainId=@DomainId  
  
