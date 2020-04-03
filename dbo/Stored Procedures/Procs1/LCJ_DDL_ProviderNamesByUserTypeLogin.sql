CREATE PROCEDURE [dbo].[LCJ_DDL_ProviderNamesByUserTypeLogin] --[LCJ_DDL_ProviderNamesByUserTypeLogin] 'mccollum', 'S','0'

	(
		@DomainId NVARCHAR(50),
		@UserType NVARCHAR(10),
		@UserTypeLogin NVARCHAR(100)
	)

AS
BEGIN

	
	IF @UserType ='P' 
	BEGIN
			select 0 as Provider_Id,' ---Select Provider--- ' as Provider_Name
			union 
			SELECT   DISTINCT Provider_Id, Provider_Name + ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','')  AS Provider_Name
			FROM         tblProvider
			WHERE    Provider_Id  = @UserTypeLogin and DomainId = @DomainId order by Provider_Name
	End
	ELSE
	BEGIN
			select 0 as Provider_Id,' ---Select Provider--- ' as Provider_Name,'2' AS FH_ACTIVE
			union 
			SELECT   Provider_Id,Provider_Name +ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','') + Isnull('    [ '+Provider_GroupName + ' ]','') 
			,FH_ACTIVE
			FROM tblProvider wHERE(1 = 1) and DomainId = @DomainId 
			order by fh_active desc ,provider_name asc
	End

END

