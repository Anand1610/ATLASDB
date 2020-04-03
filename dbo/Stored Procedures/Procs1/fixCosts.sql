CREATE PROCEDURE [dbo].[fixCosts]
(
@DomainId NVARCHAR(50),
@var varchar(10)
)
as
begin
select distinct provider_name,a.case_id,insurancecompany_name,
(select sum(transactions_amount) from tbltransactions c where transactions_type='exp' and c.case_id=a.case_id and DomainId=@DomainId) as exp,
(select sum(transactions_amount) from tbltransactions c where transactions_type='ffb' and c.case_id=a.case_id and DomainId=@DomainId) as ffb,
(select sum(transactions_amount) from tbltransactions d where transactions_type='ffc' and d.case_id=a.case_id and DomainId=@DomainId) as ffc,
(select sum(transactions_amount) from tbltransactions e where transactions_type='fFrec' and e.case_id=a.case_id and DomainId=@DomainId) as ffrec
from tbltransactions a with(nolock) inner join tblcase b  with(nolock) on a.CASE_id=b.CASE_id
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON b.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON b.Provider_Id = dbo.tblProvider.Provider_Id 
where provider_name like ''+@var + '%' and a.DomainId=@DomainId  AND ISNULL(b.IsDeleted,0) = 0
order by provider_name
end

