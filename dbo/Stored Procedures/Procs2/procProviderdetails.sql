CREATE PROCEDURE [dbo].[procProviderdetails] (
@clid nvarchar(100)
)
as
select * from tblprovider where provider_id=@clid

