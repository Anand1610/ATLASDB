CREATE PROCEDURE [dbo].[get_Provider] -- 'FH10-73690'
 (  
	@DomainId nvarchar(50),
	@case_id NVarChar(50) 
 )  
AS  
  
begin  
  
 SELECT provider_id from tblcase  where case_id=@case_id and DomainId=@DomainId
  
end

