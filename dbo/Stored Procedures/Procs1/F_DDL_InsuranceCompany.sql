CREATE PROCEDURE [dbo].[F_DDL_InsuranceCompany]--[F_DDL_InsuranceCompany] 'GLF'
(
	@DomainID VARCHAR(50)
)	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' AS InsuranceCompany_Id,' ---SELECT Insurance Company--- ' AS InsuranceCompany_Name
	UNION
	SELECT InsuranceCompany_Id,InsuranceCompany_Name +'[' + ISNULL(InsuranceCompany_Local_Address,'') + ' ' +ISNULL(InsuranceCompany_Local_City,'')+ ' ' +ISNULL(InsuranceCompany_Local_State,'') +']' + Isnull('    [ '+InsuranceCompany_GroupName + ' ]','') AS InsuranceCompany_Name
	FROM tblInsuranceCompany WHERE InsuranceCompany_Id <> 0 and ActiveStatus = 1 
	AND DomainID = @DomainID ORDER BY InsuranceCompany_Name
	
	SET NOCOUNT OFF ;



END

