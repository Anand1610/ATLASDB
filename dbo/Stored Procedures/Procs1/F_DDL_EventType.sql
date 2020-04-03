CREATE PROCEDURE [dbo].[F_DDL_EventType]
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as EventTypeId,' ---Select Event Type--- ' as EventTypeName
	UNION
	SELECT EventTypeId,LTRIM(RTRIM(EventTypeName)) FROM tblEventType WHERE EventTypeName not like '%select%' and EventTypeId <> 0  ORDER BY EventTypeName
	
	SET NOCOUNT OFF ;



END

