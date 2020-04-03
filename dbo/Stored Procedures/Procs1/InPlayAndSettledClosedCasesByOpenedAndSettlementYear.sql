


  
CREATE PROCEDURE [dbo].[InPlayAndSettledClosedCasesByOpenedAndSettlementYear]  
(  
@DomainId VARCHAR(50),  
@SZ_USER_ID  NVARCHAR(50)=''  
)  
AS begin  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
  
  
SELECT  Year(c.Date_Opened) as Year_Opened,  
  Year(s.Settlement_Date) as Settlement_Year,  
  count(c.Case_Id) as Case_count,  
  sum(Fee_Schedule) as Fee_Schedule_Amt,  
  sum(cast(s.Settlement_Amount as numeric(18,2))) as Sum_Of_Settlement   
FROM [dbo].[tblcase]  c   
JOIN [dbo].[tblSettlements] s on c.Case_Id =s.Case_Id    
WHERE STATUS IN('CLOSED','AAA - SETTLED - AWAITING PAYMENTS')   
AND  c.DomainId = @DomainId    
AND (@ProviderId = '' or Provider_Id = @ProviderId)  
AND (@InvestorId = 0   
     OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))
AND CONVERT(DATE, ISNULL(s.Settlement_Date, '')) <> '1900-01-01'
GROUP BY YEAR(c.Date_Opened) , YEAR(s.Settlement_Date)   
  
ORDER BY YEAR(Date_Opened);  
  
END  
  


