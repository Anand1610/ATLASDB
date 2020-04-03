
CREATE PROCEDURE [dbo].[LCJ_ResolvedInventoryByYear]-- 'vipul'  --'priya',''  
  
(  
@DomainId nvarchar(50)  
,@Year varchar(10)=null,  
@SZ_USER_ID  NVARCHAR(50)=''  
)  
AS begin  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
IF(@Year !='')  
BEGIN  
select count(*) as CaseID,  
-- C.Status,   
 --datepart(yyyy, Accident_Date) as CaseDate,  
 isnull( convert(varchar(20),datepart(yyyy,date_closed)),0) as ResolvedYear,  
datename(mm,date_closed) Month,   
  ''  CaseNumber,  
 isnull(sum(convert(decimal(18,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
 ,isnull(sum(convert(decimal(18,2),(convert(money,convert(float,S.Settlement_Total))))),0) SettlementAmount  
From tblcase as C  
left join tblsettlements S ON C.Case_Id=S.Case_Id  
WHERE 1=1 and C.DomainId= @DomainId AND datepart(yyyy, date_closed)=@Year  AND ISNULL(Date_Closed, '') <> ''   
group by date_closed  
  
   
  
END  
ELSE  
BEGIN  
  
select count(*) as CaseID,  
-- C.Status,   
 --datepart(yyyy, Accident_Date) as CaseDate,  
 isnull( convert(varchar(20),datepart(yyyy,date_closed)),0) as ResolvedYear,  
datename(mm,date_closed) Month,   
  ''  CaseNumber,  
 isnull(sum(convert(decimal(18,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
 ,isnull(sum(convert(decimal(18,2),(convert(money,convert(float,S.Settlement_Total))))),0) SettlementAmount  
From tblcase as C  
left join tblsettlements S ON C.Case_Id=S.Case_Id  
WHERE 1=1 and C.DomainId= @DomainId  AND ISNULL(Date_Closed, '') <> ''   
      AND (@ProviderId = '' or Provider_Id = @ProviderId)  
     AND (@InvestorId = 0   
     OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
group by date_closed  
order by ResolvedYear  
end  
  
END  



