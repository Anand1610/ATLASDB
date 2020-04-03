CREATE PROCEDURE [dbo].[LCJ_ADMIN_GETINSURANCECOMPANY]
@DomainId NVARCHAR(50)

AS

Select InsuranceCompany_Id, LTRIM(RTRIM(UPPER(InsuranceCompany_Name))) AS InsuranceCompany_Name  from tblInsuranceCompany where 1=1 and DomainId=@DomainId

