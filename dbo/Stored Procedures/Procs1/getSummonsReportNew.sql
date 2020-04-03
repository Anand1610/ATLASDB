CREATE PROCEDURE [dbo].[getSummonsReportNew](
@dt1 varchar(20),
@dt2 varchar(20),
@startid  varchar(20),
@endid varchar(20),
@excludedids varchar(20)
)
as
begin

	declare @sql varchar(8000)

	set @sql = 'select a.case_id,injuredparty_lastname + '''+'/'''' + injuredparty_firstname as [injuredparty_name],provider_name,insurancecompany_name,accident_date,claim_amount,date_opened
	from tblcase a inner join tblprovider b on a.provider_id=b.provider_id
	inner join tblinsurancecompany c on a.insurancecompany_id=c.insurancecompany_id
	where 
	cast(floor(cast(date_opened as float)) as datetime) >='  +  @dt1  +  ' and 
	cast(floor(cast(date_opened as float)) as datetime)<= ' + @dt2  + '  AND GROUP_DATA <= 0  '

	if @startid is not null and @startid<>'' 
	begin
		set @sql = @sql+ ' and case_id>' +@startid
	end

	if @endid is not null and @endid<>'' 
	begin
		set @sql = @sql+ ' and case_id< ' +@endid
	end

	if @excludedids is not null and @excludedids<>'' 
	begin
		set @sql = @sql+ ' and case_id not in ( ' + replace(@excludedids,',',''',''') +') '
	end


	set @sql = @sql + '   order by date_opened,a.case_id ' 

	exec(@sql)
	

end

