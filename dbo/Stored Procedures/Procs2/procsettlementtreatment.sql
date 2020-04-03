CREATE PROCEDURE [dbo].[procsettlementtreatment] (
@insid varchar(20),
@dt1 varchar(20),
@dt2 varchar(20),
@userid varchar(100)
)
as
begin
SET NOCOUNT ON
declare
@cnt int,
@caseid varchar(20)

set @cnt = 0
create table #temp(
		case_id varchar(50),
		InjuredParty_Name varchar(100),
		Provider_Name varchar(100),
		InsuranceCompany_Name varchar(100),
		Claim_Amount money,
		user_id varchar(50),
		Settlement_Amount money,
		Settlement_Int money,
		Settlement_AF money,
		Settlement_FF money,
		Settlement_Date datetime)

declare mycur cursor local for
select distinct  cas.case_id from tblCase cas with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON cas.Case_Id = dbo.tblSettlements.Case_Id
where cas.InsuranceCompany_id=@insid 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2 
and User_id=@userid AND ISNULL(cas.IsDeleted,0) = 0  
order by cas.case_id
open mycur
fetch next from mycur into @caseid
while @@fetch_status=0
begin


select @cnt = count(*) from tbltreatment where case_id=@caseid

if @cnt > 0
begin
insert into #temp 
select a.case_id,ISNULL(a.InjuredParty_FirstName, N'') + N'  ' + ISNULL(a.InjuredParty_LastName, N'') AS 
injuredparty_name,provider_name,insurancecompany_name,
(b.claim_amount-b.paid_amount) as claimamount,@userid,
settlement_amount,settlement_int,
settlement_af,settlement_ff,settlement_date
from tblCAse a with(nolock) 
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON a.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON a.Provider_Id = dbo.tblProvider.Provider_Id 
LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON a.Case_Id = dbo.tblSettlements.Case_Id
INNER JOIN  tbltreatment b on a.Case_Id=b.Case_Id
where ISNULL(a.IsDeleted,0) = 0  AND a.InsuranceCompany_id=@insid and b.treatment_id > 0 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2 
and User_id=@userid 

end
else
begin
insert into #temp 
select a.case_id,ISNULL(a.InjuredParty_FirstName, N'') + N'  ' + ISNULL(a.InjuredParty_LastName, N'') AS  injuredparty_name,provider_name,insurancecompany_name,
(convert(money,a.claim_amount)-convert(money,a.paid_amount)) as claimamount,@userid,
settlement_amount,settlement_int,
settlement_af,settlement_ff,settlement_date
from tblCAse a with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON a.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON a.Provider_Id = dbo.tblProvider.Provider_Id 
LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON a.Case_Id = dbo.tblSettlements.Case_Id
where ISNULL(a.IsDeleted,0) = 0  AND a.InsuranceCompany_id=@insid 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2 
and User_id=@userid 
end
fetch next from mycur into @caseid
end
deallocate mycur
select distinct * from #temp where claim_amount > 0 order by case_id
drop table #temp
end

