

CREATE PROCEDURE [dbo].[LCJ_InventoryByYear]  --'priya','2010'  
(  
@DomainId nvarchar(50)  
,@Year varchar(10)=null,  
@SZ_USER_ID NVARCHAR(50)=''  
)  
as begin  
IF(@Year !='')  
BEGIN  
  
select count(*) as CaseID,  
datepart(yyyy, Accident_Date) as CaseDate,  
''  CaseNumber,  
isnull(sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
From tblcase as tblcase  
WHERE 1=1 and tblcase.DomainId= @DomainId and datepart(yyyy, Accident_Date)=@year  AND CONVERT(DATE, ISNULL(Accident_Date,'')) <> '1900-01-01'
group by datepart(yyyy, Accident_Date) order by CaseDate  
END  
ELSE  
BEGIN  
  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
  
select count(*) as CaseID,   
datepart(yyyy, Accident_Date) as CaseDate,  
''  CaseNumber,  
ISNULL(sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
From tblcase as tblcase   
WHERE tblcase.DomainId= @DomainId  
   AND (@ProviderId = '' or Provider_Id = @ProviderId)  
    AND (@InvestorId = 0   
  OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
	AND CONVERT(DATE, ISNULL(Accident_Date,'')) <> '1900-01-01'
group by datepart(yyyy, Accident_Date) order by CaseDate  
END  
end  
  
  
