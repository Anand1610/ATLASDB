CREATE PROCEDURE [dbo].[LCJ_DDL_UserName]  
(
@DomainId NVARCHAR(50)
)
    
As  
   
Begin  
 select '...Select user to assign...' [userid], '' [userName]  
 union  
 select username [userid],userName from IssueTracker_Users
 WHERE @DomainId = DomainId  
end

