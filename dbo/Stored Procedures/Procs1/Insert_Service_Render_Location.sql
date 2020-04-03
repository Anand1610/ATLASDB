CREATE PROCEDURE [dbo].[Insert_Service_Render_Location] --78,'','','',''
(
	@DomainId varchar(50),
	@provider_id int,
	@Loc_Addr varchar(200),
	@Loc_City varchar(100),
	@Loc_State varchar(100),
	@Loc_Zip varchar(10)
)
AS
BEGIN
	if(@provider_id =0)	
		set @provider_id= null;
	--if((select count(*) from MST_Service_Rendered_Location where provider_id=@provider_id) = 0) 
	begin
		Insert into MST_Service_Rendered_Location (provider_id,Location_Address,Location_City,Location_State,Location_Zip,DomainId)
		values (@provider_id,@Loc_Addr,@Loc_City,@Loc_State,@Loc_Zip,@DomainId)
	end
	

END

