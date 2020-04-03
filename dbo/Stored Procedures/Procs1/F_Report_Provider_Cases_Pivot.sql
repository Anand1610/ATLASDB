CREATE PROCEDURE [dbo].[F_Report_Provider_Cases_Pivot]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @cols NVARCHAR(max)
	DECLARE @CureentQuarter VARCHAR(10)
	DECLARE @query VARCHAR(MAX)

	SET @CureentQuarter = (SELECT CONVERT(VARCHAR(4), YEAR(GETDATE())) + '-Q' + CONVERT(VARCHAR(1),DATENAME(Quarter,GETDATE())))

	  
	IF Not EXISTS(SELECT * FROM tblquarter WHERE Quarter_Name=@CureentQuarter)
	BEGIN
		INSERT INTO tblquarter(Quarter_Name)
		VALUES (@CureentQuarter)
	END

	SELECT @cols =stuff((SELECT Distinct  ',[' + Quarter_Name +']' 	FROM tblquarter  FOR XML PATH('')),1,1,'')
    
	Print @cols
	
	set @query = 'SELECT *
	FROM (
	    SELECT 
		   CASE WHEN YEAR(Date_Opened) > 2011	THEN
			CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ''-Q'' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
		   ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END as [month], 
			COUNT(case_id) AS Case_Count	
	    FROM LCJ_VW_CaseSearchDetails WHERE YEar(date_opened)>2010 
	    GROUP BY Date_Opened
	) as s
	PIVOT
	(
	    SUM(Case_Count)
	    FOR [month] IN ('+@cols+'))AS pivot1'

	execute(@query)
		 
	set @query = 'SELECT *
	FROM (
	    SELECT 
		   Provider_GroupName as [Provider GroupName],
		   CASE WHEN YEAR(Date_Opened) > 2011	THEN
			CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ''-Q'' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
		   ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END as [month], 
			COUNT(case_id) AS Case_Count	
	    FROM LCJ_VW_CaseSearchDetails WHERE YEar(date_opened)>2010 
	    GROUP BY Provider_GroupName,Date_Opened
	) as s
	PIVOT
	(
	    SUM(Case_Count)
	    FOR [month] IN ('+@cols+'))AS pivot1'

	execute(@query)
	
	
	set @query = 'SELECT *
	FROM (
	    SELECT 
		   Provider_Name as [Provider Name],
		   CASE WHEN YEAR(Date_Opened) > 2011	THEN
			CONVERT(VARCHAR(4), YEAR(Date_Opened)) + ''-Q'' + CONVERT(VARCHAR(1),DATENAME(Quarter,Date_Opened)) 
		   ELSE CONVERT(VARCHAR(4),YEAR(Date_Opened)) END as [month], 
			COUNT(case_id) AS Case_Count	
	    FROM LCJ_VW_CaseSearchDetails WHERE YEar(date_opened)>2010 
	    GROUP BY Provider_Name,Date_Opened
	) as s
	PIVOT
	(
	    SUM(Case_Count)
	    FOR [month] IN ('+@cols+'))AS pivot1'

	execute(@query)

END

