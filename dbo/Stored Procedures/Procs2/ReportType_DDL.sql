
CREATE PROCEDURE [dbo].[ReportType_DDL]
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT ' ---Select--- ' AS Report_Type,'' as Report_Type_Value
	UNION
	SELECT   DISTINCT Report_Type as Report_Type, 
					Report_Type as Report_Type_Value
	FROM         tblTransactionType 
END
