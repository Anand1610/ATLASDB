CREATE PROCEDURE [dbo].[GetSystemParameters] 
AS  
BEGIN  
 SET NOCOUNT ON;    
 Select * from tblApplicationSettings;  
 select * from tblBasePath 
 --Select * from tblCompanyBasePathMapping 
END
