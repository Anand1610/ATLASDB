CREATE PROCEDURE [dbo].[delete_Service_render_location] --'5'
	@location_id int

AS
BEGIN
	If((select count(*) from tblcase where location_id = @location_id) = 0)
	begin
		delete MST_Service_Rendered_Location 
		where location_id = @location_id
	end
	
END

