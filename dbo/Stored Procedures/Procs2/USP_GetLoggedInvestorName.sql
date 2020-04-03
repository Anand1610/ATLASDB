
CREATE PROCEDURE [dbo].[USP_GetLoggedInvestorName] --'localhost','raphael99'
	@DomainId varchar(50),
@UserName varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @userid int
	DECLARE @portfolioIds VARCHAR(8000) 
	set @userid=(select UserId from IssueTracker_Users where UserName=@UserName)
	select  @portfolioIds= COALESCE(@portfolioIds + ',','')+ Convert(varchar(50),p.PortfolioId) from tbl_Investor i inner join tbl_InvestorPortfolio p on  i.InvestorId=p.InvestorId  where i.UserId=@userid and i.DomainId =@DomainId
       select i.InvestorId,i.Name,@portfolioIds as PortFolio_Ids,i.UserId from tbl_Investor i where i.UserId=@userid and i.DomainId =@DomainId
END
