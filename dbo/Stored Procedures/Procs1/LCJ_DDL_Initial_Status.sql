CREATE PROCEDURE [dbo].[LCJ_DDL_Initial_Status]   --[LCJ_DDL_Initial_Status]
@DomainId NVARCHAR(50)
AS  
begin  

	SET NOCOUNT ON;
	
	SELECT '0' as ID,' ---Select Case Status--- ' as Name, '' As value
	UNION
	SELECT DISTINCT ID, Name,Name as value FROM tblCaseStatus WITH(NOLOCK) WHERE  DomainID = @DomainID ORDER BY Name
	
	SET NOCOUNT OFF ;

end

