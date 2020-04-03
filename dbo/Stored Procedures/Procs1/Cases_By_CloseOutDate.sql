


CREATE PROCEDURE [dbo].[Cases_By_CloseOutDate]  
(  
@DomainId NVARCHAR(50),  
@SZ_USER_ID  NVARCHAR(50)=''  
)  
AS begin  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
  
SELECT LEFT(DATENAME(MONTH,Date_Closed),3) as CloseOutMonth,  
   sum(Fee_Schedule) as Fee_Schedule_Amt   
FROM [dbo].[tblcase]    
where  Year(Date_Closed) =YEAR(getdate())   
AND  STATUS IN('CLOSED','AAA - SETTLED - AWAITING PAYMENTS')   
AND  DomainId = @DomainId    
AND  (@ProviderId = '' or Provider_Id = @ProviderId)  
AND (@InvestorId = 0   
     OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
		 AND CONVERT(date,ISNULL(Date_Closed,'')) <> '1900-01-01'
Group By  DATENAME(MONTH,Date_Closed)  order by DATENAME(MONTH,Date_Closed);  
  
END  
  
