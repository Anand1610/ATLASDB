CREATE PROCEDURE [dbo].[LCJ_DDL_FirmNames]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
AS
--ALTER TABLE #tmpFirmNames
--	(Firm_Id nvarchar(100), Firm_Name varchar(400))

begin
--insert into #tmpClientNames values(Null, Null)
--insert into #tmpFirmNames values(0,'...Select Firm...')
--insert into #tmpFirmNames

	SELECT    DISTINCT Firm_Id, Upper(ISNULL(Firm_Name, '')) AS Firm_Name
	FROM         tblFirms
	WHERE     (1 = 1) order by Firm_Name

--select Firm_Id, Firm_Name from #tmpFirmNames order by 2
--drop TABLE #tmpFirmNames
end

