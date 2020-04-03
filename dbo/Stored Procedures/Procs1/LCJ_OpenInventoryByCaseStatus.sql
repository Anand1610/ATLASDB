
  
--LCJ_OpenInventoryByCaseStatus 'priya',NULL  
  
CREATE PROCEDURE [dbo].[LCJ_OpenInventoryByCaseStatus] --'priya',''  
  
(  
@DomainId nvarchar(50)  
,@Status nvarchar(50)=null,  
@SZ_USER_ID      NVARCHAR(50)=''  
)  
as begin  
  
IF(@Status!='')  
BEGIN  
  
select top 10 count(*) as CaseID,   
tblcase.Status ,   
'' as CaseDate,   
'' CaseNumber,  
ISNULL(sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
From tblcase as tblcase  
WHERE 1=1 and tblcase.DomainId= @DomainId and tblcase.Status =@Status  AND  tblcase.Status not in ('closed','withdrown')   
  
group by tblcase.Status    
  
END  
  
ELSE  
BEGIN  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
  
select top 10 count(*) as CaseID,  tblcase.Status ,  
 '' as CaseDate,   
 '' CaseNumber,  
 iSNULL(sum(convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount))))),0) CaseAmount  
From tblcase as tblcase  
WHERE 1=1 and tblcase.DomainId= @DomainId AND  tblcase.Status not in ('closed','withdrown')  
     AND (@ProviderId = '' or Provider_Id = @ProviderId)  
   AND (@InvestorId = 0   
  OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
group by tblcase.Status  
END  
end  


