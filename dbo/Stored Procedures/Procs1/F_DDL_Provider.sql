CREATE PROCEDURE [dbo].[F_DDL_Provider] --[F_DDL_Provider] 'mccollum'
(
	@DomainID VARCHAR(50)
)	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as Provider_Id,' ---Select Provider--- ' as Provider_Name
	UNION
	SELECT Provider_Id,Provider_Name +ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','') + Isnull('    [ '+Provider_GroupName + ' ]','')  FROM tblProvider WHERE isnuLL(Provider_name,'') not like '%select%' and Provider_Id <> 0 and active = 1 
	and DomainID =@DomainID
	ORDER BY Provider_Name
	
	SET NOCOUNT OFF ;



END

