CREATE PROCEDURE [dbo].[providerinslist](  
@provider_id varchar(50)  
)  
as  
select insurancecompany_name,cas.insurancecompany_id,count(*) as [count] from 
TblCase cas with(nolock)  
INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON cas.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
INNER JOIN dbo.tblProvider WITH (NOLOCK) ON cas.Provider_Id = dbo.tblProvider.Provider_Id   
where ISNULL(cas.IsDeleted,0) = 0    AND cas.provider_id = @provider_id 

group by insurancecompany_name,cas.insurancecompany_id order by insurancecompany_name  
  