--[getNewSettlementReportUser] '04/12/2011','12/12/2011','bmelo',0,'',''
CREATE PROCEDURE [dbo].[getNewSettlementReportUser](
@DomainId NVARCHAR(50),
@dt1 varchar(50),
@dt2 varchar(50),
@u_id varchar(100),
@setdisp int,
@InsurId nvarchar(100),
@provId nvarchar(100)
)
as
begin
SET NOCOUNT ON
declare
@insid int,
@iname varchar(200),
@cnt int,
@bal money,
@setamt money,
@setint money,
@setff money,
@setaf money,
@settot money,
@setper float,
@User_Id nvarchar(100),
@str  varchar(max)
set @cnt = 0 
set @bal = 0
set @setper = 0

create table #temp(
user_id varchar(200),
InsuranceCompany_Id int,
InsuranceCompany_Name varchar(200),
cnt int,
balance money,
sett_amt_total money,
sett_int_total money,
sett_ff_total money,
sett_af_total money,
total money,
setper float
)
set @str='declare
mycur cursor for select
upper(User_id),
insurancecompany_id,
insurancecompany_name,
isnull(sum(settlement_amount),0.00),
isnull(sum(settlement_int),0.00),
isnull(sum(settlement_ff),0.00),
isnull(sum(settlement_af),0.00),
isnull(sum(settlement_total),0.00)
from LCJ_VW_CaseSearchDetails  b where 
CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= '''+@dt1+'''
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= '''+@dt2+'''
and User_id='''+@u_id+'''
and DomainId='''+@DomainId+'''
and settlement_amount > 0 
group by insurancecompany_name,insurancecompany_id,User_id having 1=1 ' 

if(@InsurId<>'')
begin
  set @str=@str+'and insurancecompany_id in ('+ @InsurId +')'
end

if(@provId<>'')
begin
 set @str=@str+'and provider_id  in ('+ @provId +')'
end

set @str=@str+' order by insurancecompany_name'
print @str
exec(@str)

open mycur
fetch next from mycur into @User_Id,@insid,@iname,@setamt,@setint,@setff,@setaf,@settot
while @@fetch_status=0
begin

select @cnt = count(case_id) from tblcase a where case_id  in (select case_id from tblsettlements where 
CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
and User_id=@u_id
and settlement_amount > 0 
) and insurancecompany_id = @insid

select @bal = isnull(sum(convert(money,claim_amount)-convert(money,paid_amount)),0.00) from tblcase a 
where case_id  in (select case_id from tblsettlements where 
CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
and User_id=@u_id
and settlement_amount > 0 
) and insurancecompany_id = @insid

select @setper = CASE 
  WHEN @bal = 0.00 THEN 0
     ELSE (@setamt + @setint) * 100 / isnull(@bal,1.00)
  END

insert into #temp
select @User_Id,@insid,@iname,@cnt,@bal,@setamt,@setint,@setff,@setaf,@settot,@setper

set @cnt = 0
set @bal = 0
set @setper = 0

fetch next from mycur into @User_Id,@insid,@iname,@setamt,@setint,@setff,@setaf,@settot
end
close mycur
deallocate mycur

if @setdisp = 0
select * from #temp  
if @setdisp = 1
select * from #temp where setper <= 0  
if @setdisp = 2
select * from #temp where setper > 0 and setper < 70 
if @setdisp = 3
select * from #temp where setper > 70 
drop table #temp
end

