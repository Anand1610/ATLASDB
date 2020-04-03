CREATE PROCEDURE [dbo].[USP_GetPortfolio]    
(
@DomainId varchar(50)
 ) 
AS    
BEGIN  
  SELECT '0' as ID,' ---Select Portfolio--- ' as Name
	UNION
  select Id,Name from  [dbo].[tbl_portfolio] where DomainId=@DomainId
END
