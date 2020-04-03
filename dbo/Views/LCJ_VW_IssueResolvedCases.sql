
CREATE VIEW [dbo].[LCJ_VW_IssueResolvedCases]
AS
select case_id, 
  Provider_Id,
  ISNULL(dbo.tblcase.InjuredParty_FirstName, '') +'  '+  ISNULL(dbo.tblcase.InjuredParty_LastName, '') AS InjuredParty_Name,
  ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Name ,'')as Insurance_Company,
  convert(varchar,date_opened,101)  date_opened,
  DATEDIFF(dd,date_opened,getdate()) [DATEDIF OPENED], 
  status, 
  Old_Status,
  convert(varchar,Date_Status_Changed,101) Date_Status_Changed,
  DATEDIFF(dd,date_status_changed,getdate()) as [DATEDIFF Status Changed], tblcase.DomainId
from tblcase left join tblInsuranceCompany on tblcase .InsuranceCompany_Id = tblInsuranceCompany .InsuranceCompany_Id 
     
where Status ='AAA ISSUE RESOLVED'
