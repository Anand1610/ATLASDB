CREATE PROCEDURE [dbo].[USP_GetAttorneyFirm]    
(
@DomainId varchar(50)
 ) 
AS    
BEGIN  
 SELECT '0' as ID,' ---Select AttorneyFirm--- ' as Name
	UNION
  select Id,Name from  [dbo].[tbl_AttorneyFirm] where DomainId=@DomainId
END
