CREATE PROCEDURE [dbo].[LCJ_DDL_Court_ForCalendarReport]

	--(
		--@parameter1 datatype = default value,
		--@parameter2 datatype OUTPUT
		--@Alpha VARCHAR(5)
	--)

AS
--ALTER TABLE #tmpCourt
--	(Court_ID nvarchar(100), Court_Name varchar(100))

begin
--insert into #tmpClientNames values(0, Null)
--insert into #tmpCourt values(0,'...Select Court/Venue...')
--insert into #tmpCourt

	SELECT   DISTINCT Court_ID, Upper(ISNULL(Court_Name, '')) AS Court_Name
	FROM         tblCourt
	WHERE     (1 = 1) order by court_name
--IF @Alpha = 'ALL'
--	select Court_ID, Court_Name  from #tmpCourt  order by 2
--	drop table #tmpCourt
--ELSE
	--select Client_ID, Client_Name  from #tmpClientNames where Client_Name LIKE @Alpha + '%' order by 2
end

