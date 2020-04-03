CREATE PROCEDURE [dbo].[LCJ_DDL_ProviderNamesForClientReport]

	(
		@DomainId nvarchar(50),
		@UserType NVARCHAR(10),
		@UserName NVARCHAR(100)
	)

AS
BEGIN

	
IF @UserType ='P'

	BEGIN
	
		select 0 as Provider_Id,'...Select Provider...' as Provider_Name
		union 

		select DISTINCT Provider_Id, Provider_Name + ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','') AS Provider_Name
		from tblProvider  
		where provider_id in (select usertypelogin from IssueTracker_Users  
								where username=@UserName and DomainId=@DomainId)
								and DomainId=@DomainId 
		order by provider_name
	End

ELSE

	BEGIN
		select 0 as Provider_Id,'...Select Provider...' as Provider_Name
		union 
		SELECT   DISTINCT Provider_Id, Provider_Name + ISNULL('[' + PROVIDER_LOCAL_ADDRESS + ']','') + ISNULL(' [Group: '+PROVIDER_GROUPNAME+ ' ]','') AS PROVIDER_NAME  
		FROM tblProvider  
		WHERE DomainId=@DomainId 
		order by provider_name
	
	End

END

