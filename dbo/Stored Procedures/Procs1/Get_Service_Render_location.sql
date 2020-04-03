CREATE PROCEDURE [dbo].[Get_Service_Render_location] 
--(
	--@provider_name varchar(100)
	@DomainId nvarchar(50)
--)
  
AS  
BEGIN
	SELECT tp.Provider_Name,tp.provider_id,location_id, Location_Address,Location_City,Location_State,Location_Zip
	FROM MST_Service_Rendered_Location  AS  MST_Service_Rendered_Location
	LEFT OUTER JOIN  tblProvider  tp on  MST_Service_Rendered_Location.provider_id = tp.provider_id
	where Location_Address not in ('Select Location') AND MST_Service_Rendered_Location.DomainId = @DomainId
End

