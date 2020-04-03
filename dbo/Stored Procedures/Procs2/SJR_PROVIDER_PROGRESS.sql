-- =============================================
-- Author:		Name
-- ALTER date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SJR_PROVIDER_PROGRESS]
   @START_DATE VARCHAR(50),@END_DATE VARCHAR(50)
	
AS
BEGIN
	
	SET NOCOUNT ON;

SELECT     REPLACE(Provider_Name,'--','#') AS Provider_name,InsuranceCompany_name as Insurance, COUNT(Case_Id) AS CASES, SUM(Balance) AS AMOUNT,DATE_OPENED AS DATE, MAX_SETT_DATE,SETTLEMENT_TOTAL
FROM         [SJR-Case_report_Extended]
WHERE     (Date_Opened BETWEEN CONVERT(DATETIME,@START_DATE , 102) AND CONVERT(DATETIME,@END_DATE , 102))
GROUP BY REPLACE(Provider_Name, '--', '#'),InsuranceCompany_name,DATE_OPENED,SETTLEMENT_TOTAL,MAX_SETT_DATE
ORDER BY PROVIDER_NAME DESC


END

