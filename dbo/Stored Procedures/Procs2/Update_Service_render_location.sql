CREATE PROCEDURE [dbo].[Update_Service_render_location]
(
	@location_id int,
	@Provider_Id int,
	@Loc_Addr varchar(200),
	@Loc_City varchar(100),
	@Loc_State varchar(100),
	@Loc_Zip varchar(10)
)
AS
Begin
	update MST_Service_Rendered_Location
	set	Provider_Id = @Provider_Id,
		Location_Address = @Loc_Addr,
		Location_City = @Loc_City,
		Location_State = @Loc_State,
		Location_Zip = @Loc_Zip
		where location_id = @location_id
End

