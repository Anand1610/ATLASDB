CREATE PROCEDURE [dbo].[Available_AttorneyFirm]    
(
@DomainId varchar(50)
	) 
AS    
BEGIN  
    SELECT '0' as Id,' ---Select Attorney Firm--- ' as Name
	UNION
    select Id,Name from  [dbo].[tbl_AttorneyFirm] where DomainId=@DomainId
END
