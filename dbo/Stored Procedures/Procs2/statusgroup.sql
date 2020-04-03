CREATE PROCEDURE [dbo].[statusgroup](     -- statusGroup @dt1='03/01/2014',@dt2='03/10/2014',@printtype='Date_Opened',@status='ALL',@opened_by='mferreira' 
@dt1 varchar(50),
@dt2 varchar(50),
@printtype varchar(100),
@status varchar(50),
@opened_by varchar(100)
)
as
begin
SET NOCOUNT ON
declare
@st nvarchar(1000)
		set @st = 'select status,count(*) as [Count] from lcj_vw_casesearchdetails where 
		CAST(FLOOR(CAST(' + @printtype + ' AS FLOAT))AS DATETIME) >= Replace(''' + @dt1 + ''',''/'',''-'') and
		CAST(FLOOR(CAST('+@printtype+' AS FLOAT))AS DATETIME) <= Replace(''' + @dt2+''',''/'',''-'') '
		if @status <> 'ALL'
		set @st = @st + ' and status = ''' + @status + ''' group by status order by status'
		else
		 if @opened_by <> 'ALL'  
		  set @st = @st + ' and opened_by = ''' + @opened_by + ''' group by status order by status'  
		  else  
		set @st = @st + ' group by status order by status'
		print @st
		execute sp_executesql @st
end

