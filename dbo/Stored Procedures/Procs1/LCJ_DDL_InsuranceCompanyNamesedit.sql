/*Previously called LCJ_DDL_InsurerNames */
CREATE PROCEDURE [dbo].[LCJ_DDL_InsuranceCompanyNamesedit]
/*
	(
		@parameter1 datatype = default value,
		@parameter2 datatype OUTPUT
	)
*/
@DomainId NVARCHAR(50)
AS
SELECT    DISTINCT InsuranceCompany_Id, Upper(ISNULL(InsuranceCompany_Name, '')) AS InsuranceCompany_Name FROM tblInsuranceCompany WHERE     (1 = 1)  and DomainId=@DomainId
 order by InsuranceCompany_Name asc
--and ActiveStatus <> 0

