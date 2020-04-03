CREATE PROCEDURE [dbo].[LCJ_DDL_Status_ForCalendarReport]

	

AS
CREATE TABLE #tmpStatus
	(Status_Abr nvarchar(100), Status_Type varchar(100))

begin
--insert into #tmpClientNames values(0, Null)
insert into #tmpStatus values('ALL','...ALL...')
insert into #tmpStatus

	SELECT   DISTINCT Status_Abr, Upper(ISNULL(Status_Type, '')) AS Status_Type
	FROM         tblStatus
	WHERE     (1 = 1)
--IF @Alpha = 'ALL'
	select Status_Abr, Status_Type  from #tmpStatus  order by 2
	drop table #tmpStatus
--ELSE
	--select Client_ID, Client_Name  from #tmpClientNames where Client_Name LIKE @Alpha + '%' order by 2
end

