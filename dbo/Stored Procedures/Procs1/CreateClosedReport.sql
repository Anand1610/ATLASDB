--**************** Start of Procedure CreateClosedReport **********************
CREATE PROCEDURE [dbo].[CreateClosedReport]
as
begin
select distinct a.case_id,ISNULL(a.InjuredParty_FirstName, N'') + N'  ' + ISNULL(a.InjuredParty_LastName, N'')  as injuredparty_name,
provider_name,insurancecompany_name,a.status,CONVERT(money, ISNULL(a.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(a.Paid_Amount, 0)) as claim_amount,b.principal,
b.interest,b.filingfee,b.attorneyfee from tblcase a with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON a.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON a.Provider_Id = dbo.tblProvider.Provider_Id 
inner join tobecollected b WITH (NOLOCK) on a.case_id=b.case_id
WHERE ISNULL(a.IsDeleted,0) = 0

end

--**************** End of Procedure CreateClosedReport **********************

