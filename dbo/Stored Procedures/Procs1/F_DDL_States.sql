CREATE PROCEDURE [dbo].[F_DDL_States]
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as State_Abr,' ---Select State--- ' as State_Name
	UNION
	SELECT State_Abr,State_Name FROM tblStates WHERE State_Name not like '%select%'  ORDER BY State_Name
	
	SET NOCOUNT OFF ;



END

