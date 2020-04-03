CREATE PROCEDURE [dbo].[InsuranceCompanyGroup_DDL]  -- [InsuranceCompanyGroup_DDL] 'localhost'
( 
	@DomainID VARCHAR(50)
)
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT '0' as InsuranceCompanyGroup_ID,' ---Select Group--- ' as InsuranceCompanyGroup_Name, '' AS InsuranceCompanyGroup_Name_Value
	UNION
	SELECT InsuranceCompanyGroup_ID AS InsuranceCompanyGroup_ID , InsuranceCompanyGroup_Name as InsuranceCompanyGroup_Name ,InsuranceCompanyGroup_Name AS InsuranceCompanyGroup_Name_Value
	FROM tblInsuranceCompanyGroup  --DESCRIPTION not like '%select%' and DESCRIPTION <> '' and
	WHERE DomainID = @DomainID
	ORDER BY InsuranceCompanyGroup_Name
	
	SET NOCOUNT OFF ; 

END

