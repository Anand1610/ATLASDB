CREATE PROCEDURE [dbo].[Available_Program]    
(
@DomainId varchar(50)
	) 
AS    
BEGIN  
  select Id,Name from  [dbo].[tbl_Program] where DomainId=@DomainId
END
