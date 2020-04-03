CREATE PROCEDURE [dbo].[SP_WS_CHECK_LOGIN] -- 'Admin','2pgK3XztV8HY/Vt2KE/rrw=='  
(  
 @SZ_USER_NAME AS NVARCHAR(100),  
 @SZ_PASSWORD AS NVARCHAR(100)  
)  
AS  
BEGIN  
   
 SELECT   top 1 UserId as [SZ_USER_ID],
   UserName [SZ_USER_NAME], '' [BILLING_COMPANY_ID] ,    
   '-' [COMPANY_NAME]  
 FROM IssueTracker_Users   
 WHERE  
  UserName = @SZ_USER_NAME 
--  UserPassword = @SZ_PASSWORD 
  AND IsActive = 1
END

