CREATE PROCEDURE [dbo].[LCJ_DDL_CPTCode]

	

AS
CREATE TABLE #tmpCPT
	(CPT_Id int, CPT_Code varchar(100))

begin
--insert into #tmpClientNames values(0, Null)
insert into #tmpCPT values(0,'...Select CPT...')
insert into #tmpCPT

	SELECT CPT_Id,CPT_Code  FROM tblCPT
	WHERE     (1 = 1)
--IF @Alpha = 'ALL'
	select CPT_Id, CPT_Code  from #tmpCPT  order by 2
	drop table #tmpCPT
--ELSE
end

