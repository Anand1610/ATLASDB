CREATE PROCEDURE [dbo].[procCLIENTREPORTsettlementtreatment] (
@PROVIDER_ID varchar(20),
@dt varchar(20)
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
		Claim_Amount money,
		Paid_Amount money,
		Settlement_Amount money,
		Settlement_Int money,
		Settlement_Date datetime)

declare mycur cursor local for
select distinct  case_id from LCJ_VW_CaseSearchDetails 
where provider_id=@provider_id and 
datediff(m,settlement_date,getdate())<= @dt
and settlement_amount > 0  
order by case_id
open mycur
fetch next from mycur into @caseid
while @@fetch_status=0
begin


select @cnt = count(*) from tbltreatment where case_id=@caseid

if @cnt > 0
begin
insert into #temp 
select a.case_id,b.fee_schedule,b.paid_amount,
a.settlement_amount,a.settlement_int,
a.settlement_date
from lcj_vw_Casesearchdetails a inner join tbltreatment b on a.treatment_id=b.treatment_id
where a.case_id =@caseid

end
else
begin
insert into #temp 
select a.case_id,convert(money,a.Fee_Schedule),convert(money,a.paid_amount),a.settlement_amount,a.settlement_int,
a.settlement_date
from LCJ_VW_CaseSearchDetails a 
where case_id =@caseid 
end
fetch next from mycur into @caseid
end
deallocate mycur
select year(settlement_date) as [Year],month(settlement_date) as [Month],
count(distinct case_id) as 'Count_Cases',sum(cast(fee_Schedule as money))as 'Sum_Claim_Amount',
sum(cast(fee_Schedule as money)-cast(paid_amount as money)) as 'Sum_Balance',
sum(cast(settlement_amount as money))as 'Sum_Settlement_Amount',
sum(cast(settlement_Int as money))as 'Sum_Settlement_Int' from 
#temp group by year(settlement_date),Month(settlement_date) 
order by year(settlement_date) desc, month(settlement_Date) desc
drop table #temp
end

