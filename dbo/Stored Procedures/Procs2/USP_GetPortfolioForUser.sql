
CREATE PROCEDURE [dbo].[USP_GetPortfolioForUser]  --  'PRIYA',2007
(
@DomainId varchar(50),
@SZ_USER_ID      NVARCHAR(50)=''
 ) 
AS    
BEGIN  
DECLARE @InvestorId AS INT = 0
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID

DECLARE @ProviderId AS INT = 0
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID


  SELECT '0' as ID,' ---Select Portfolio--- ' as Name
  UNION
  select Id,Name 
  from  [dbo].[tbl_portfolio] 
  where DomainId=@DomainId 
  AND ( @InvestorId = 0 
  OR ID in (SElect portfolioid 
         from tbl_InvestorPortfolio IP 
         WHERE IP.InvestorId =@InvestorId))
  AND (@ProviderId=0 
       OR  ID in (SELECT  Distinct  PortfolioId 
                       FROM      tblcase 
                       WHERE     Provider_Id = @ProviderId))
          
END





