CREATE PROCEDURE [dbo].[Get_ClientCompany_Type]    
(@DomainId varchar(50)	) 
AS    
BEGIN   
 SELECT CompanyType from [dbo].[tbl_Client]  where DomainId = @DomainId  
END
