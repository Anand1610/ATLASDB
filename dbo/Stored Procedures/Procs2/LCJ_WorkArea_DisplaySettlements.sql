CREATE PROCEDURE [dbo].[LCJ_WorkArea_DisplaySettlements] --[LCJ_WorkArea_DisplaySettlements] 'RFA14-170415'  
(    
@DomainId VARCHAR(40),
@Case_Id VARCHAR(40)    
)    
AS    
Select  b.Case_Id, pro.Provider_Name, ISNULL(a.InjuredParty_FirstName, N'') + N'  ' + ISNULL(a.InjuredParty_LastName, N'')     
                      AS InjuredParty_Name, INS.InsuranceCompany_Name,a.IndexOrAAA_Number,  
Claim_Amount, Paid_Amount,((Cast(Claim_Amount as money))-(cast(Paid_Amount as money))) as Balance,a.Status, b.Settlement_Amount, 
b.Settlement_Int,b.Settlement_Af, b.Settlement_Ff, b.Settlement_Total, b.Settlement_Date, b.SettledWith,b.User_id 
from tblcase  a with(nolock) 
 INNER JOIN  dbo.tblInsuranceCompany INS WITH(NOLOCK) ON a.InsuranceCompany_Id = INS.InsuranceCompany_Id 
 INNER JOIN dbo.tblProvider pro WITH(NOLOCK) ON a.Provider_Id = pro.Provider_Id 
inner join tblsettlements b on a.case_id=b.case_id 
WHERE a.Case_Id = + @Case_Id and a.DomainId = @DomainId and ISNULL(a.IsDeleted,0) = 0
 
 --select distinct Case_Id from tblsettlements where Case_Id='RFA14-170415'
 --select Case_Id,* from LCJ_VW_CaseSearchDetails where Case_Id='RFA14-170415'

