CREATE PROCEDURE [dbo].[F_DDL_Service_Rendered_Location]
	@DomainId NVARCHAR(50)	
AS
BEGIN

	SET NOCOUNT ON;
	
	
	SELECT '0' as Location_Id,' ---Select Service Rendered Location--- ' as Location_Address
	UNION
	SELECT Location_Id, isnull(Location_Address,'N/A') +' '+ isnull (Location_City,'')+' '+isnull (Location_State,'')+' '+isnull (Location_Zip,'') as Location_Address  
	FROM MST_Service_Rendered_Location WHERE Location_Address not like '%select%' and Location_Id <> 0 and Location_Address <> ''
	and DomainId = @DomainId
	ORDER BY Location_Address

	SET NOCOUNT OFF ; 
	


END

