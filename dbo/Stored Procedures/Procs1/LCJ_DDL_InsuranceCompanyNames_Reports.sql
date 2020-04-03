CREATE PROCEDURE [dbo].[LCJ_DDL_InsuranceCompanyNames_Reports]--'S','tech'
(

@UserType Nvarchar(10),
@UserTypeLogin Nvarchar(100)
)

AS
begin

IF @UserType = 'I'
BEGIN		
	SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
	FROM         tblInsuranceCompany
	WHERE    InsuranceCompany_Id = @UserTypeLogin and active <> 0 
and ActiveStatus <> 0 order by InsuranceCompany_Name

END
Else
BEGIN
	select CONVERT(VARCHAR,0) as InsuranceCompany_Id,'...Select Insurance Company...' as InsuranceCompany_Name
	union
	SELECT    DISTINCT convert(varchar,InsuranceCompany_Id) as InsuranceCompany_Id, InsuranceCompany_Name
	FROM         tblInsuranceCompany where active <> 0   and ActiveStatus <> 0 
	order by 2

END
end

