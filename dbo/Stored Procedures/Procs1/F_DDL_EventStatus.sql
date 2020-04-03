CREATE PROCEDURE [dbo].[F_DDL_EventStatus]
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as EventStatusId,' ---Select Event Status--- ' as EventStatusName
	UNION
	SELECT EventStatusId,LTRIM(RTRIM(EventStatusName)) FROM tblEventStatus WHERE EventStatusName not like '%select%' and EventStatusId <> 0  ORDER BY EventStatusName
	
	SET NOCOUNT OFF ;



END

