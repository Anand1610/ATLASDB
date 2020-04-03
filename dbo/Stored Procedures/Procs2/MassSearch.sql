Create PROCEDURE [dbo].[MassSearch]
@DomainId NVARCHAR(50),
@Cases CaseSearch readonly
as
begin
	select 
	t1.Case_Id,
	t1.InsuredParty_FirstName +' '+t1.InsuredParty_LastName [InsuredParty],
	t1.Status [Status], 
	t1.Initial_Status [InitialStatus],
	t1.IndexOrAAA_Number [IndexOrAAANumber],
	isnull(t2.Court_Name,'') [CourtName],
	isnull(t3.Defendant_Name,'')[DefendantName],
	isnull(t4.Provider_Name,'')[ProviderName],
	isnull(t5.InsuranceCompany_Name,'')[InsuranceCompanyName],
	isnull(t6.Name,'')[Portfolio]
	from tblcase t1(nolock)
	left join  tblCourt t2 on t1.Court_Id=t2.Court_Id
	left join tblDefendant t3 on t3.Defendant_id=t1.Defendant_Id
	left join tblProvider t4 on t4.Provider_Id=t1.Provider_Id
	left join tblInsuranceCompany t5 on t5.InsuranceCompany_Id=t1.InsuranceCompany_Id
	left join tbl_Portfolio t6 on t6.Id=t1.PortfolioId
	join  @Cases t7 on t7.CaseId=t1.Case_Id
	where t1.DomainId=@DomainId
end
