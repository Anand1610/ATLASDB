CREATE PROCEDURE [dbo].[GET_ACTIVE_PROVIDER]
(
@DomainId nvarchar(50)
)
AS
BEGIN
select provider_id, provider_name, Provider_Local_Address from tblProvider where active = 0 AND DomainId = @DomainId
order by 2
	--select provider_id, provider_name, Provider_Local_Address+ ' ' + Provider_Local_City+ ' ' +Provider_Local_State+ ' ' +Provider_Local_Zip as Provider_Local_Address from tblprovider where active = 0
END

