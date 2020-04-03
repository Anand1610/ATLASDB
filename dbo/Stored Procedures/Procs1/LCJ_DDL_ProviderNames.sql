
CREATE PROCEDURE [dbo].[LCJ_DDL_ProviderNames]
@DomainId NVARCHAR(50)
AS
	SELECT '0' AS Provider_Id, ' --- Select Provider --- ' AS Provider_Name
	UNION
	SELECT   Provider_Id, CASE WHEN FH_ACTIVE=1 THEN tblProvider.Provider_Name +ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','') + Isnull('    [ '+tblProvider.Provider_GroupName + ' ]','') 
	ELSE  tblProvider.Provider_Name + 'ZZZ### INACTIVE ###' END as Provider_Name
	FROM tblProvider WITH(NOLOCK) wHERE(1 = 1) and DomainId=@DomainId and active =1
	Order BY Provider_Name asc

