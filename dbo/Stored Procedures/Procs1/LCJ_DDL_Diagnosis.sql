CREATE PROCEDURE [dbo].[LCJ_DDL_Diagnosis]

	

AS
CREATE TABLE #tmpDiag
	(Diag_Id nvarchar(100), Diag_Code varchar(50))

begin
--insert into #tmpClientNames values(0, Null)
insert into #tmpDiag values(0,'...Select Diagnosis...')
insert into #tmpDiag

	SELECT Diag_Id,Diag_Code  FROM tblDiagnosis
	WHERE     (1 = 1)
--IF @Alpha = 'ALL'
	select Diag_Id, Diag_Code  from #tmpDiag  order by 2
	drop table #tmpDiag
--ELSE
end

