
CREATE Procedure [dbo].[InsuranceCompanyList] 
@DomainId varchar(40)
as
select InsuranceCompany_Id,InsuranceCompany_Name, InsuranceCompany_SuitName, InsuranceCompany_Local_Address, InsuranceCompany_Local_City,
InsuranceCompany_Local_State,InsuranceCompany_Local_Zip
from tblInsuranceCompany where  domainid=@DomainId

order by InsuranceCompany_Name 
