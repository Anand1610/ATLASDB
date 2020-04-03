CREATE PROCEDURE [dbo].[SP_LIST_BILLSGRIDFOREXCEL]  
 @CASE_ID NVARCHAR(50)        
AS        
BEGIN      
Select 
ISNULL(convert(nvarchar(20),DateOfService_Start,101),'N/A')[DateOfService_Start],        
ISNULL(convert(nvarchar(20),DateOfService_End,101),'N/A')[DateOfService_End],        
ISNULL(convert(nvarchar(50),Claim_Amount),'0.00')[Claim_Amount],        
ISNULL(convert(nvarchar(50),Paid_Amount),'0.00')[Paid_Amount],
'' as [Remarks]
from tblTreatment         
where Case_Id=@CASE_ID      
order by [DateOfService_Start]    

END

