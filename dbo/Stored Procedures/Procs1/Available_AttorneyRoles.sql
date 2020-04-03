CREATE PROCEDURE [dbo].[Available_AttorneyRoles]    
(
@DomainId varchar(50)
	) 
AS    
BEGIN  
   SELECT '0' as Id,' ---Select Attorney Role--- ' as RoleName
	UNION    
    select Id,RoleName from  [dbo].[tbl_AttorneyRoles] where DomainId=@DomainId
END
