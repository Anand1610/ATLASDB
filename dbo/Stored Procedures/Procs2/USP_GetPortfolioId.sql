CREATE PROCEDURE [dbo].[USP_GetPortfolioId]   
-- USP_GetPortfolioId 'KIDWELL 001','priya'  
(  
  @Name VARCHAR(100),  
  @DomainId VARCHAR(100)  
)  
AS BEGIN  
  
--select ID from tbl_portfolio where Name='KIDWELL 001'  
  
DECLARE @PortfolioId INT=0  
  
SELECT  @PortfolioId = PF.ID   
FROM  tbl_portfolio PF  
left  JOIN tbl_program P ON p.id=pf.ProgramId  
WHERE  PF.Name=@Name   
AND   PF.domainId=@DomainId  
  
SELECT @PortfolioId  
  
END  
  