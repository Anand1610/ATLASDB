
CREATE PROCEDURE [dbo].[USP_GetPortfolioForProvider]    
(
@ProviderId INT,
@DomainId VARCHAR(50)
 ) 
AS    
BEGIN  

  SELECT '0' AS ID,' ---Select Portfolio--- ' AS Name
  UNION
  SELECT   Id,Name 
  FROM     [dbo].[tbl_portfolio] 
  WHERE    Id in (SELECT    PortfolioId 
				  FROM      tblcase 
				  WHERE     Provider_Id = @ProviderId
				  ) 
				  AND DomainId=@DomainId

END
