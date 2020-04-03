CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCE] 
@DomainId NVARCHAR(50)       
AS        
 select distinct A.provider_id,C.Provider_Name + ISNULL(N' [Group: ' + C.Provider_GroupName + N' ]', N'')providername_long,        
 count(distinct transactions_id) AS COUNTCHECKS,        
 (SELECT ISNULL(sum(transactions_Amount),0.00) 
  FROM TBLTRANSACTIONS C   
  WHERE C.PROVIDER_ID=A.provider_id 
  and DomainId=@DomainId 
  and (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')   
  AND TRANSACTIONS_TYPE IN ('C','I','Prec') AND c.Provider_Id NOT IN (SELECT Provider_Id FROM tblProviderFinancial)) AS SUMCHECKS,        
 sum(transactions_fee) AS SUMFEES        
 from tbltransactions A inner join tblcase B
 ON A.Case_Id = B.Case_Id   
  inner join tblprovider C         
  on C.Provider_Id=B.Provider_Id
 WHERE (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')        
 AND TRANSACTIONS_TYPE IN ('C','I','Prec')        
 and invoice_type  = 'E' 
 and B.DomainId=@DomainId
 and ISNULL(B.IsDeleted,0) = 0
 --AND A.provider_id NOT IN (SELECT Provider_Id FROM tblProviderFinancial)  
 GROUP BY C.Provider_Name,C.Provider_GroupName,A.provider_id