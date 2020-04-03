

CREATE PROCEDURE [dbo].[LCJ_FullInventoryByCaseStatus] --'priya','',4088  
(  
@DomainId varchar(50)  
,@Status varchar(50)=null,  
@SZ_USER_ID varchar(50)=''  
)  
as begin  
  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE [user_id] = @SZ_USER_ID  
  
  
  
IF(@Status!='')  
BEGIN  
  
select count(*) as CaseID,  tblcase.Status ,   
'' as CaseDate,   
 '' CaseNumber,  
isnull( sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
From tblcase as tblcase   
WHERE 1=1 and tblcase.DomainId= @DomainId and tblcase.Status =@Status  
group by tblcase.Status    
  
END  
  
ELSE  
BEGIN  
  
select count(*) as CaseID,  tblcase.Status ,  
 '' as CaseDate,   
 '' CaseNumber,  
isnull(sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount into #temp  
From tblcase as tblcase   
WHERE  tblcase.DomainId= @DomainId  
   AND (@ProviderId = 0 or Provider_Id = @ProviderId)  
    AND (@InvestorId=0 or portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
group by tblcase.Status   
  
update #temp set status='OPEN' where status<>'CLOSED'   
  
 SELECT SUM(CaseID) AS 'CaseID', Status  , '' as CaseDate, '' CaseNumber, sum( CaseAmount )CaseAmount  
FROM #temp    
GROUP BY status  
  
  
END  
end  
  
  
