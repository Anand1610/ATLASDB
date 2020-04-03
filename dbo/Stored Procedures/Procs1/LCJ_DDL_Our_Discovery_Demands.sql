CREATE PROCEDURE [dbo].[LCJ_DDL_Our_Discovery_Demands]
AS
CREATE TABLE #tmpDDL_Our_Discovery_Demands(DDL_Our_Discovery_Demands varchar(100))
BEGIN
insert into #tmpDDL_Our_Discovery_Demands values('No Activity')
insert into #tmpDDL_Our_Discovery_Demands
SELECT DISTINCT(Our_Discovery_Demands) FROM TBLCASE WHERE Our_Discovery_Demands IS NOT NULL
ORDER BY Our_Discovery_Demands ASC

select * from  #tmpDDL_Our_Discovery_Demands
drop table #tmpDDL_Our_Discovery_Demands

END

--execute LCJ_DDL_Our_Discovery_Demands

