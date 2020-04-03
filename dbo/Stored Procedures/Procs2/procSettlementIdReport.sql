CREATE PROCEDURE [dbo].[procSettlementIdReport]
(
@pid varchar(50),
@setyear int,
@setmonth int
)
as
begin
declare
@cnt int,
@cid varchar(50)
set @cnt = 0

SET NOCOUNT ON
create table #temp (case_id varchar(50),claimamt money,paidamt money )
declare mycur cursor local for
select distinct cas.case_id from Tblcase cas with(nolock) 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id 
LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON cas.Case_Id = dbo.tblSettlements.Case_Id   
where  ISNULL(cas.IsDeleted,0) = 0  AND cas.provider_id=@pid and settlement_amount > 0 
and year(settlement_date)=@setyear and month(settlement_date)=@setmonth
open mycur
fetch next from mycur into @cid
while @@fetch_status=0
begin


select @cnt = count(*) from tbltreatment where case_id=@cid
if @cnt > 0
begin
insert into #temp
select case_id,sum(claim_amount),sum(paid_Amount) from tbltreatment where case_id=@cid group by case_id
end
else
begin
insert into #temp
select case_id,claim_amount,paid_Amount from tblcase where case_id=@cid
end

set @cnt = 0

fetch next from mycur into @cid
end 


select s.case_id,SUM(Settlement_Amount) as Settlement_Amount,
SUM(Settlement_Int) as Settlement_Int,SUM(Settlement_FF) as Settlement_FF,SUM(Settlement_AF) as Settlement_AF,
SUM(Settlement_Total) as Settlement_Total,

(select top 1 ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'')  AS InjuredParty_Name from tblcase with(nolock)

where case_id=s.case_id AND  ISNULL(tblcase.IsDeleted,0) = 0 ) as InjuredParty_Name,

(select top 1 Provider_Name from tblcase with(nolock) 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id
where case_id=s.case_id AND ISNULL(tblcase.IsDeleted,0) = 0) as Provider_Name,

(select top 1 InsuranceCompany_Name from tblcase with(nolock)  INNER JOIN  dbo.tblInsuranceCompany
WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
where case_id=s.case_id AND ISNULL(tblcase.IsDeleted,0) = 0) as InsuranceCompany_Name,

(select c.claimamt - c.paidamt from #temp c where c.case_id=s.case_id) as Claim_Amount,

(select top 1 User_Id from  tblcase  with(nolock)  LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id   
where tblcase.case_id=s.case_id AND ISNULL(tblcase.IsDeleted,0) = 0) as User_Id,


(select top 1 Settlement_Date from tblcase with(nolock)  LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id
where tblcase.case_id=s.case_id AND ISNULL(tblcase.IsDeleted,0) = 0) as Settlement_Date,

(select top 1 Settlement_Notes from tblcase with(nolock)  LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id
where tblcase.case_id=s.case_id  AND ISNULL(tblcase.IsDeleted,0) = 0) as 
Settlement_Notes  

from tblcase s with(nolock) 
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON s.Provider_Id = dbo.tblProvider.Provider_Id   
LEFT OUTER JOIN  dbo.tblSettlements Sett WITH (NOLOCK) ON s.Case_Id = Sett.Case_Id   
where   ISNULL(s.IsDeleted,0) = 0 AND s.provider_id=@pid and settlement_amount > 0 
and year(settlement_date)=@setyear and month(settlement_date)=@setmonth group by s.case_id order by settlement_date asc

drop table #temp

end

