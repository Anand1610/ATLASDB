CREATE PROCEDURE [dbo].[LCJ_CreateCaption](
@cid varchar(50),
@gpid int
)
as
begin
declare
@gid int,
@pname nvarchar(240),
@iname nvarchar(240),
@capt nvarchar(1000),
@pcnt int,
@icnt int,
@iname2 varchar(100),
@caseid varchar(50),
@cname2 varchar(100),
@gids1 varchar(200),
@gids2 varchar(200)
 

if @gpid = 0
begin

select @gid = group_id from tblcase where case_id=@cid

if @gid = 0
begin
select @pname = provider_name,@iname = injuredparty_name,@gids1=case_id from lcj_vw_casesearchdetails where case_id=@cid
set @capt = @iname
update tblcase set caption = @capt,group_all=@gids1 where case_id=@cid 
end

if @gid > 0
begin
set @iname = ''
set @gids1 = ''
create table #temp(cid varchar(50),pname varchar(100),iname varchar(100))
insert into #temp
select distinct case_id,provider_name,injuredparty_name from lcj_vw_casesearchdetails where group_id=@gid order by case_id
declare
mycur cursor local for
select * from #temp
fetch next from mycur into @caseid,@cname2,@iname2
while @@fetch_status=0
begin
set @iname = @iname + ',' + @iname2
set @gids1 = @gids1 + ',' + @cid
set @pname = @cname2
fetch next from mycur into @caseid,@cname2,@iname2
end
close mycur
deallocate mycur
drop table #temp
if left(@iname,1) = ','
begin
	set @capt = right(@iname,len(@iname)+1)
end
else
	set @capt = @iname
if left(@gids1,1) = ','
begin
	set @gids2 = right(@gids1,len(@gids1)+1)
end
else
	set @gids2 = @gids1

update tblcase set caption = @capt,group_all=@gids2 where group_id=@gid 
end

end

if @gpid <> 0
begin

set @gid = @gpid

if @gid > 0
begin
set @iname = ''
set @gids1 = ''
create table #temp2(cid varchar(50),pname varchar(100),iname varchar(100))
insert into #temp2
select distinct case_id,provider_name,injuredparty_name from lcj_vw_casesearchdetails where group_id=@gid order by case_id
declare
mycur cursor local for
select * from #temp2
open mycur
fetch next from mycur into @caseid,@cname2,@iname2
while @@fetch_status=0
begin
set @iname = @iname + ',' + @iname2
set @gids1 = @gids1 + ',' + @cid
set @pname = @cname2
fetch next from mycur into @caseid,@cname2,@iname2
end
close mycur
deallocate mycur
drop table #temp2
set @capt =left(@iname,len(@iname)-1)
set @gids2 =left(@gids1,len(@gids1)-1)
update tblcase set caption = @capt,group_all=@gids2 where group_id=@gid 
end

end




end

