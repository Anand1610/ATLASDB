
CREATE PROCEDURE [dbo].[LCJ_DDL_InsuranceCompanyNames]
@DomainId NVARCHAR(50)
AS

	SELECT '0' AS InsuranceCompany_Id, ' --- Select Insurance Company --- ' AS InsuranceCompany_Name
	UNION 
	SELECT    DISTINCT InsuranceCompany_Id, Upper(ISNULL(InsuranceCompany_Name, '')) AS InsuranceCompany_Name FROM tblInsuranceCompany WITH(NOLOCK)
	WHERE     (1 = 1) AND DomainId=@DomainId --and active = 2 
	and ActiveStatus <> 0 order by InsuranceCompany_Name asc

