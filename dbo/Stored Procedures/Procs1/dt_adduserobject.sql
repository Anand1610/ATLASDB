/*
**	Add an object to the dtproperties table
*/
CREATE PROCEDURE [dbo].[dt_adduserobject]
as
	set nocount on
	/*
	** ALTER the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity

