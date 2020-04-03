CREATE PROCEDURE [dbo].[LCJ_DDL_Our_SJ_Motion_Activity]
AS
CREATE TABLE #tmpDDL_Our_SJ_Motion_Activity (DDL_Our_SJ_Motion_Activity varchar(100))
BEGIN
insert into #tmpDDL_Our_SJ_Motion_Activity values('No Activity')
insert into #tmpDDL_Our_SJ_Motion_Activity
SELECT DISTINCT(Our_SJ_Motion_Activity) FROM TBLCASE WHERE Our_SJ_Motion_Activity IS NOT NULL
ORDER BY Our_SJ_Motion_Activity ASC

select * from  #tmpDDL_Our_SJ_Motion_Activity
drop table #tmpDDL_Our_SJ_Motion_Activity

END

--execute LCJ_DDL_Our_SJ_Motion_Activity

