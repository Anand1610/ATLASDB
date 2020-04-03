CREATE PROCEDURE [dbo].[Available_AttorneyNamesForFirm]    
(
@AttorneyFirmId int,
@DomainId varchar(50)
	) 
AS    
BEGIN      
    select UserId as Id,Name from  [dbo].[tbl_AttorneyUser] where AttorneyFirmId=@AttorneyFirmId and DomainId=@DomainId
END
