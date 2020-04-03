CREATE PROCEDURE[dbo].[getSummonsReport](
@dt1 varchar(20),
@dt2 varchar(20),
@startid  varchar(20),
@endid varchar(20),
@excludedids varchar(100)
)
as
begin
	SET NOCOUNT ON
	declare 
		@sql varchar(8000),
		@sid int,
		@eid int
		


	


	set @sql = 'select a.case_id,injuredparty_lastname + ''/'' + injuredparty_firstname as [injuredparty_name],provider_name,insurancecompany_name,accident_date,claim_amount,date_opened
	 from tblcase a inner join tblprovider b on a.provider_id=b.provider_id
	inner join tblinsurancecompany c on a.insurancecompany_id=c.insurancecompany_id
	where GROUP_DATA <= 0 ' 
	

	if (@dt1 is not null and @dt1<>'')
		set @sql = @sql + '   and  cast(floor(cast(date_opened as float)) as datetime) >='  +  @dt1  
	--else
		--set @sql = @sql + '    and    cast(floor(cast(date_opened as float)) as datetime) >='''''
	 
	if (@dt2 is not null and @dt2<>'') 
		set @sql = @sql + '   and  cast(floor(cast(date_opened as float)) as datetime) <='  +  @dt2  
	--else
		--set @sql = @sql + '   and  cast(floor(cast(date_opened as float)) as datetime) <='''''
	



	if (@startid is not null and @startid<>'')  
	begin
		
		select @sid = Case_AutoId from tblcase where case_id = @startid
		set @sql = @sql+ ' and case_autoid>=' + convert(varchar,@sid) + ''
		--set @sql = @sql+ ' and case_id>=''' +@startid+ ''''
	end

	if (@endid is not null and @endid<>'') 
	begin
		select @eid = Case_AutoId from tblcase where case_id = @endid
		set @sql = @sql+ ' and case_autoid<=' + convert(varchar,@eid) + ''

		--set @sql = @sql+ ' and case_id<= ''' +@endid+''''
	end

	if (@excludedids is not null and @excludedids<>'') 
	begin
		set @sql = @sql+ ' and case_id not in ( ''' + replace(@excludedids,',',''',''') +''') '
	end


	set @sql = @sql + '   order by date_opened,a.case_id ' 

	print @sql
	
	exec(@sql)

	--execute sp_executesql @sql


end

