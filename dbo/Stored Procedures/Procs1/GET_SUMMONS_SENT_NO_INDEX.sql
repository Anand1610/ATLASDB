CREATE PROCEDURE [dbo].[GET_SUMMONS_SENT_NO_INDEX]
AS
BEGIN

select 
	case_id,
	case_code,
	ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')   AS injuredparty_name,
	provider_name,
	insurancecompany_name,
	indexoraaa_number,
	Date_SUMMONS_printed,
	date_summons_Sent_court,
	CONVERT(money, ISNULL(cas.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(cas.Paid_Amount, 0)) as claim_amount,
	status 
from tblcase cas with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
where 
	case_id in (select case_id from tblnotes with(nolock) where notes_desc like '%to SUMMONS-SENT-TO-COURT%' and datediff(d,notes_date,getdate()) >=30)
	AND status = 'SUMMONS-SENT-TO-COURT' 
	AND IndexOrAAA_Number IS NULL AND  ISNULL(cas.IsDeleted,0) = 0
order by case_id

END

