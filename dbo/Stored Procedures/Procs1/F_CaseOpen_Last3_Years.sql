CREATE PROCEDURE [dbo].[F_CaseOpen_Last3_Years] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select CASE WHEN YEAR(Date_Opened) > 2011 THEN
            CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Quarter ' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
        ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END AS Opend_Year,
        COUNT(Case_ID) AS Cases,
       sum(ISNULL(Fee_Schedule,0))  AS [Fee_Schedule]
FROM tblcase where provider_id is not null and InsuranceCompany_Id is not null and YEAR(Date_Opened) >2010
GROUP BY
      CASE WHEN YEAR(Date_Opened) > 2011  THEN
            CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Quarter ' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
      ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END
ORDER BY 
      CASE WHEN YEAR(Date_Opened) > 2011  THEN
            CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ' Quarter ' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
      ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END

END

