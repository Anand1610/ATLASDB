CREATE PROCEDURE [dbo].[LCJ_DDL_DefendantNames_ForCalendarReport]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
--ALTER TABLE #tmpDefendantNames
--	(Defendant_Id nvarchar(100), Defendant_Name varchar(400))

begin
--insert into #tmpClientNames values(Null, Null)
--insert into #tmpDefendantNames values('ALL','...ALL...')
--insert into #tmpDefendantNames

	SELECT    DISTINCT Defendant_Id, Upper(ISNULL(Defendant_DisplayName, '')) AS Defendant_Name
	FROM         tblDefendant
	WHERE     (1 = 1) AND (ACTIVE=1) 
order by defendant_name asc

--select Defendant_Id, Defendant_Name from #tmpDefendantNames order by 2
end

