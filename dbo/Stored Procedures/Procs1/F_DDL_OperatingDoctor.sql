CREATE PROCEDURE [dbo].[F_DDL_OperatingDoctor]
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as Doctor_ID,' ---Select Treating Doctor-- ' as Doctor_Name
	UNION
	SELECT Doctor_ID, Doctor_Name as Doctor_Name 
	FROM tblOperatingDoctor WHERE Doctor_Name not like '%select%' and Doctor_ID <> 0 and Doctor_Name <> ''
	ORDER BY Doctor_Name
	
	SET NOCOUNT OFF ; 


END

