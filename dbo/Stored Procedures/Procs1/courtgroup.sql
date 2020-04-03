CREATE PROCEDURE [dbo].[courtgroup](
@dt1 varchar(50),
@dt2 varchar(50),
@printtype varchar(100),
@STATUS VARCHAR(50),
@opened_by varchar(100) 
)
as
begin
SET NOCOUNT ON
declare
@st nvarchar(1000)
	set @st = 'select court_name,count(*) as [Count] from lcj_vw_casesearchdetails where 
		CAST(FLOOR(CAST(' + @printtype + ' AS FLOAT))AS DATETIME) >= Replace(''' + @dt1 + ''',''/'',''-'') and
		CAST(FLOOR(CAST('+@printtype+' AS FLOAT))AS DATETIME) <= Replace(''' + @dt2+''',''/'',''-'') '
		if @status <> 'ALL'
		set @st = @st + ' and status = ''' + @status + ''' group by court_NAME order by court_NAME'
		else
		 if @opened_by <> 'ALL'  
		  set @st = @st + ' and opened_by = ''' + @opened_by + '''group by court_NAME order by court_NAME'  
		  else  
		set @st = @st + ' group by court_NAME order by court_NAME'
		print @st
		execute sp_executesql @st
end

