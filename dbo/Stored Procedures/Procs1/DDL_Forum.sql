CREATE PROCEDURE [dbo].[DDL_Forum] -- [DDL_Forum] 'GLF'
(
	@DomainID VARCHAR(50)
)
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as Forums_ID,' ---Select Final Status--- ' as Forum_Name, '' AS Forum_Name_Value
	UNION
	SELECT Forums_ID AS Forums_ID , Forum_Name as Forum_Name, Forum_Name AS Forum_Name_Value
	FROM tbl_Forum 
	WHERE DomainId = @DomainID
	ORDER BY Forum_Name
	
	SET NOCOUNT OFF ; 

END

