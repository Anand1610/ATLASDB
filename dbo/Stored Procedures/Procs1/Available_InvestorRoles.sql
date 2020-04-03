CREATE PROCEDURE [dbo].[Available_InvestorRoles]  --  'priya'    
(    
@DomainId varchar(50)    
 )     
AS        
BEGIN      
   SELECT '0' as Id,' ---Select Investor Role--- ' as RoleName    
 UNION        
    select RoleId as Id ,RoleName from  [dbo].IssueTracker_Roles where DomainId=@DomainId and  RoleType='I'  
END  
