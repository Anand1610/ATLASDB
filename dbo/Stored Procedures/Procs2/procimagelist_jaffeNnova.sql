CREATE PROCEDURE [dbo].[procimagelist_jaffeNnova]
(
@case_id varchar(50)
)
as
begin
create table #temp(fileName varchar(100))
insert into #temp
select 'exhibits\a.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (13) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\b.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (14) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\c.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (29) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\d.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (11) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\e.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (45) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\f.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (12) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\g.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (26) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\h.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (27) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\i.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (49) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\j.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (25) and case_id = @case_id order by documentid asc,imageid asc
insert into #temp
select 'exhibits\k.tif'
insert into #temp
select Replace(imagepath,'/','\') + '\' + filename from tblimages where documentid in (47) and case_id = @case_id order by documentid asc,imageid asc

select * from #temp
drop table #temp
end

