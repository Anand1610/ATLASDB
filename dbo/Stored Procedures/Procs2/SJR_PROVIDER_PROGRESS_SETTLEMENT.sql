-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SJR_PROVIDER_PROGRESS_SETTLEMENT]
   @START_DATE VARCHAR(50),@END_DATE VARCHAR(50)
	
AS
BEGIN
	
	SET NOCOUNT ON;

SELECT     REPLACE(Provider_Name,'--','#') AS Provider_name,COUNT(Case_Id) AS CASES,  MAX_SETT_DATE,SUM(SETTLEMENT_TOTAL) AS SETTLEMENT_TOTAL
FROM         [SJR-Case_report_Extended]
WHERE     (MAX_SETT_DATE BETWEEN CONVERT(DATETIME,@START_DATE , 102) AND CONVERT(DATETIME,@END_DATE , 102))
GROUP BY REPLACE(Provider_Name, '--', '#'),MAX_SETT_DATE
ORDER BY PROVIDER_NAME DESC


END

