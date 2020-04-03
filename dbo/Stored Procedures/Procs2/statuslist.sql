﻿CREATE PROCEDURE [dbo].[statuslist](
@provider_id varchar(50),
@status varchar(50)
)
as
select cas.case_id, ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'')  as 
injuredparty_name,provider_name,insurancecompany_name,
ins_claim_number,accident_date,dateofservice_start,dateofservice_end,
indexoraaa_number,status,
claim_amount from tblCAse cas with(nolock) 
  INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
  INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 

where cas.provider_id=@provider_id and status=@status AND ISNULL(cas.IsDeleted,0) = 0  

