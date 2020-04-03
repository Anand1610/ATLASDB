      
CREATE PROCEDURE [dbo].[GetCasesToDownloadDocuments]      
(      
@LawFirmId LawFirmDetails READONLY      
)      
AS      
BEGIN      
        
  SELECT --top 1   
  c.Case_Id,c.GB_LawFirm_ID,c.domainid,t.BILL_NUMBER,GB_case_ID,GB_Company_id,GB_case_no ,t.DateOfService_Start      
  FROM   tblcase c   WITH(NOLOCK)    
  INNER JOIN  tbltreatment t WITH(NOLOCK) ON t.Case_Id = c.case_id      
  INNER JOIN  @LawFirmId lfrm ON lfrm.LawFirmId = c.GB_LawFirm_ID      
  WHERE t.documentstatus = 'Document Pending' --AND c.GB_LawFirm_ID IN(SELECT LawFirmId FROM @LawFirmId)      
  -- AND T.Case_Id in ('ACT-AF-205609')   
  -- AND t.DomainId = 'BT'      
  --AND t.Bill_number in (select [Bill #] from [dbo].[XN_AF_RESub] )   
  AND t.BILL_NUMBER IS NOT NULL   
  ORDER BY t.Case_Id,t.DateOfService_Start      
       
END      
      
      
      
      
      