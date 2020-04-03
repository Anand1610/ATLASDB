CREATE PROCEDURE [dbo].[RPT_PROVIDER_CASES] 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	select count(Case_Id) as Cases,CASE WHEN YEAR(Date_Opened) > 2011  THEN
    CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Q' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
	ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END AS Opend_Year from LCJ_VW_CaseSearchDetails where YEAR(Date_Opened) > 2010
	group by (CASE WHEN YEAR(Date_Opened) > 2011  THEN
    CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Q' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
	ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END )
	order by (CASE WHEN YEAR(Date_Opened) > 2011  THEN
    CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Q' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
	ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END)
END

