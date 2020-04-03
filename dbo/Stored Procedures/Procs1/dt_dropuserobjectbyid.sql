/*
**	Drop an object from the dbo.dtproperties table
*/
CREATE PROCEDURE [dbo].[dt_dropuserobjectbyid]
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id

