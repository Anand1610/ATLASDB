CREATE PROCEDURE [dbo].[LCJ_GETCLIENTREMITTANCE-fhkp]
AS 
begin
       
select distinct A.provider_id,pro.Provider_Name + ISNULL(N' [Group: ' + pro.Provider_GroupName + N' ]', N'') AS providername_long,        
count(distinct transactions_id) AS COUNTCHECKS,        
(SELECT ISNULL(sum(transactions_Amount),0.00) FROM TBLTRANSACTIONS C   
WHERE C.PROVIDER_ID=A.provider_id 
--AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')   
AND TRANSACTIONS_TYPE IN ('C','I','Prec') AND c.Provider_Id NOT IN (SELECT Provider_Id FROM tblProviderFinancial)  
) AS SUMCHECKS,        
sum(transactions_fee) AS SUMFEES        
from tbltransactions A with(nolock) inner join tblcase  B   with(nolock)         
ON A.Case_Id = B.Case_Id   
 INNER JOIN  dbo.tblInsuranceCompany INS WITH (NOLOCK) ON B.InsuranceCompany_Id =INS.InsuranceCompany_Id 
 INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON B.Provider_Id = pro.Provider_Id 
WHERE ISNULL(B.IsDeleted,0) = 0 and
Transactions_Date >='03/01/2014'
-- (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')        
AND TRANSACTIONS_TYPE IN ('C','I','Prec')        
and invoice_type  = 'E' AND A.provider_id NOT IN (SELECT Provider_Id FROM tblProviderFinancial with(nolock))  
and A.provider_id not in ('1911')  
GROUP BY pro.Provider_Name + ISNULL(N' [Group: ' + pro.Provider_GroupName + N' ]', N''),A.provider_id  
 
UNION  
  
select distinct A.provider_id,pro.Provider_Name + ISNULL(N' [Group: ' + pro.Provider_GroupName + N' ]', N'') AS providername_long,         
count(distinct transactions_id) AS COUNTCHECKS,        
(SELECT ISNULL(sum(transactions_Amount),0.00) FROM TBLTRANSACTIONS C  with(nolock) 
WHERE C.PROVIDER_ID=A.provider_id 
and Transactions_Date >='03/01/2014'
--AND (TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')   
AND TRANSACTIONS_TYPE IN ('C','I','PreC') AND (c.Provider_Id IN (SELECT Provider_Id FROM tblProviderFinancial with(nolock)))  
) AS SUMCHECKS,        
sum(transactions_fee) AS SUMFEES        
from tbltransactions A  with(nolock)  inner join tblcase B    with(nolock)       
ON A.Case_Id = B.Case_Id      
INNER JOIN  dbo.tblInsuranceCompany INS WITH (NOLOCK) ON B.InsuranceCompany_Id =INS.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON B.Provider_Id = pro.Provider_Id 
WHERE ISNULL(B.IsDeleted,0) = 0 and
Transactions_Date >='03/01/2014'
--(TRANSACTIONS_STATUS IS NULL or TRANSACTIONS_STATUS = 'CONFIRMED')        
AND TRANSACTIONS_TYPE IN ('C','I','PreC')        
and invoice_type  = 'E' AND (A.provider_id IN (SELECT Provider_Id FROM tblProviderFinancial))  
and A.provider_id not in ('1911')  
GROUP BY pro.Provider_Name + ISNULL(N' [Group: ' + pro.Provider_GroupName + N' ]', N''),A.provider_id  
ORDER BY pro.Provider_Name + ISNULL(N' [Group: ' + pro.Provider_GroupName + N' ]', N''),A.provider_id          
end

