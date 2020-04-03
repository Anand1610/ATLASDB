


  
CREATE PROCEDURE [dbo].[Cases_by_Carrier]  
(  
@DomainId VARCHAR(50),  
@Status VARCHAR(50)=NULL,  
@SZ_USER_ID  NVARCHAR(50)='' ,
@ProviderId int = 0 ,  
@DenialReasonID int = 0   
)  
AS begin  
--DECLARE @InvestorId AS INT = 0  
--SELECT @InvestorId=InvestorId FROM Tbl_Investor WHERE UserId = @SZ_USER_ID  
  
--SET @ProviderId AS INT = 0  
--SELECT @ProviderId=Provider_id FROM TXN_PROVIDER_LOGIN WHERE user_id = @SZ_USER_ID  
  
IF @Status IS NOT null   
  SELECT Top 10  InsuranceCompany_Name,   
    count(c.Case_Id) as Case_count,  
    sum(c.Fee_Schedule) as Fee_Schedule_Amt   
  FROM [dbo].[tblcase] c   
  join [dbo].[tblInsuranceCompany] i on c.InsuranceCompany_Id = i.InsuranceCompany_Id  and (C.Provider_Id= @ProviderId OR @ProviderId=0)  
  WHERE c.Status=@Status and  c.DomainId=@DomainId  GROUP BY i.InsuranceCompany_Name   
  ORDER BY i.InsuranceCompany_Name  
ELSE  
BEGIN  
  SELECT  Top 10  InsuranceCompany_Name,   
     COUNT(c.Case_Id) AS Case_count,  
     SUM(c.Fee_Schedule) as Fee_Schedule_Amt   
  FROM  [dbo].[tblcase] c   
  JOIN  [dbo].[tblInsuranceCompany] i ON c.InsuranceCompany_Id = i.InsuranceCompany_Id      
  WHERE  c.DomainId=@DomainId  
   AND (@ProviderId = 0 or Provider_Id = @ProviderId)  and (@DenialReasonID=0 or MainDenialReasonsId like '%' + cast(@DenialReasonID as varchar) +'%')   
              -- AND (@ProviderId = '' or Provider_Id = @ProviderId)  
       --AND (@InvestorId = 0   
       --              OR portfolioid in (SElect portfolioid   
       --  from tbl_InvestorPortfolio IP   
       --  WHERE IP.InvestorId =@InvestorId))  
  Group By i.InsuranceCompany_Name ORDER BY i.InsuranceCompany_Name;  
END  
  
END  
  

