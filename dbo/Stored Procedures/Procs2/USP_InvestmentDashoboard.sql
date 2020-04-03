CREATE PROCEDURE [dbo].[USP_InvestmentDashoboard]-- 'priya',4088  
(  
@DomainId nvarchar(50),  
@SZ_USER_ID NVARCHAR(50)=''  
)  
AS BEGIN  
  
  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
DECLARE @TotalInvestment NUMERIC(18,2)   
  
select @TotalInvestment=  
isnull(sum(InvestmentAmount),0)   
From tbl_InvestorPortfolio IP  
WHERE IP.DomainId= @DomainId AND  IP.InvestorId =@InvestorId  
  
select portfolioid,P.Name,  
isnull(sum(InvestmentAmount),0) InvestmentAmount,  
(isnull(sum(InvestmentAmount),0)/@TotalInvestment)*100 InvestmentPercntage  
 -- case when @TotalInvestment=0 then 0 else (isnull(sum(InvestmentAmount),0)/@TotalInvestment)*100 end InvestmentPercntage
 
From tbl_InvestorPortfolio IP  
inner join tbl_portfolio P on IP.PortfolioId=P.Id  
WHERE IP.DomainId= @DomainId AND  IP.InvestorId =@InvestorId  
GROUP BY portfolioid ,P.Name  
  
end  
  
  
