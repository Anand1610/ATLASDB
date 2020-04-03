CREATE PROCEDURE [dbo].[LCJ_DDL_InsurerNames]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
--ALTER TABLE #tmpInsurerNames
--	(Insurer_Id nvarchar(100), Insurer_Name varchar(400))

begin
--insert into #tmpClientNames values(Null, Null)
--insert into #tmpInsurerNames values(0,'...Select Insurer...')
--insert into #tmpInsurerNames

	SELECT    DISTINCT Insurer_Id, Upper(ISNULL(Insurer_Name, '')) AS Insurer_Name
	FROM         tblInsurer
	WHERE     (1 = 1) order by Insurer_Name

--select Insurer_Id, Insurer_Name from #tmpInsurerNames order by 2
--drop TABLE #tmpInsurerNames
end

