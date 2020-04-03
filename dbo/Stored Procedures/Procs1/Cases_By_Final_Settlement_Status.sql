



  
CREATE PROCEDURE [dbo].[Cases_By_Final_Settlement_Status]  
@DomainId VARCHAR(50),  
@SZ_USER_ID  NVARCHAR(50)=''  
  
AS begin  
DECLARE @InvestorId AS INT = 0  
SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
DECLARE @ProviderId AS INT = 0  
SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
  
SELECT TOP 10  Status, count(c.Case_Id) as Case_count,  
    sum(c.Fee_Schedule) as Fee_Schedule_Amt,  
    sum(cast(s.Settlement_Amount as numeric(18,2))) as Sum_Of_Settlement   
  FROM    [dbo].[tblcase] c join [dbo].[tblSettlements] s on c.Case_Id =s.Case_Id     
  where   c.DomainId = @DomainId  
          AND (@ProviderId = '' or Provider_Id = @ProviderId)  
    AND (@InvestorId = 0   
     OR portfolioid in (SElect portfolioid   
         from tbl_InvestorPortfolio IP   
         WHERE IP.InvestorId =@InvestorId))  
  Group By Status order by Status;  
  
END  
  




