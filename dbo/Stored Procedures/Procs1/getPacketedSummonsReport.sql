CREATE PROCEDURE [dbo].[getPacketedSummonsReport](
@dt1 varchar(20),
@dt2 varchar(20)
)
as
begin
declare
@gid int,
@cid nvarchar(100)	
create table #temp3(case_id varchar(50))
declare
mycur cursor local for
select distinct a.group_id from lcj_vw_casesearchdetails a where cast(floor(cast(date_packeted as float)) as datetime) >=@dt1 and cast(floor(cast(date_packeted as float)) as datetime)<=@dt2 AND GROUP_DATA > 0 AND DATE_PACKETED IS NOT NULL order by group_id
open mycur
fetch next from mycur into @gid
while @@fetch_status=0
begin
insert into #temp3
select top 1 case_id from tblcase where group_id in (@gid)
fetch next from mycur into @gid
end
close mycur
deallocate mycur	
select * from lcj_vw_casesearchdetails where case_id in (select case_id from #temp3) order by date_packeted,group_id
drop table #temp3
end

