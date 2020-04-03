

CREATE Procedure [dbo].[ProviderList] 
@DomainId varchar(40)
as
select Provider_Id, Provider_Name, Provider_Suitname, Provider_Local_Address, Provider_Local_State, Provider_Local_Zip, Funding_Company
from tblprovider where active =1 and domainid=@DomainId

order by Provider_Name 
