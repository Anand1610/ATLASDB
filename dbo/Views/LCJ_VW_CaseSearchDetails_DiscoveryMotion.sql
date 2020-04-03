
CREATE VIEW [dbo].[LCJ_VW_CaseSearchDetails_DiscoveryMotion]
AS

SELECT DISTINCT 
	dbo.tblProvider.Provider_Name, dbo.tblCourt.Court_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
	ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name, 
	ISNULL(dbo.tblcase.InsuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InsuredParty_LastName, N'') AS InsuredParty_Name, 
	dbo.tblcase.Case_Id,dbo.tblcase.InjuredParty_LastName, 
	dbo.tblcase.Date_Afidavit_Filed,
	dbo.tblcase.InjuredParty_FirstName, dbo.tblcase.InjuredParty_Address, dbo.tblcase.InjuredParty_City, dbo.tblcase.InjuredParty_State, 
	dbo.tblcase.InsuredParty_FirstName, dbo.tblcase.InsuredParty_Address, dbo.tblcase.InsuredParty_City, dbo.tblcase.InsuredParty_State, 
	dbo.tblcase.InsuredParty_Zip, dbo.tblcase.InsuredParty_Misc, dbo.tblcase.Accident_Date, dbo.tblcase.Accident_Address,
	dbo.tblcase.Policy_Number, dbo.tblcase.Ins_Claim_Number, dbo.tblcase.IndexOrAAA_Number, 
	dbo.tblCourt.Court_Venue,
	dbo.tblCourt.Court_Address,
	dbo.tblDefendant.Defendant_Name, dbo.tblDefendant.Defendant_Address, dbo.tblDefendant.Defendant_State, dbo.tblDefendant.Defendant_Zip, 
	dbo.tblDefendant.Defendant_Phone,dbo.tblDefendant.Defendant_City, 
	dbo.tblcase.Motion_Date, dbo.tblCase_Date_Details.Trial_Date, 
	dbo.tblcase.Reply_Date, 
	dbo.tblInsuranceCompany.InsuranceCompany_SuitName,
	dbo.tblProvider.Provider_GroupName,
	isnull(dbo.tblInsuranceCompany.SZ_SHORT_NAME, N'') INSURANCE_SHORT_NAME,
	isnull(dbo.tblprovider.SZ_SHORT_NAME, N'') PROVIDER_SHORT_NAME,
	dbo.tblprovider.PROVIDER_ID,
	dbo.tblInsuranceCompany.insurancecompany_id, tblcase.DomainId
FROM dbo.tblcase LEFT OUTER JOIN
	dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
	dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id LEFT OUTER JOIN
	dbo.tblDefendant ON dbo.tblcase.Defendant_Id = dbo.tblDefendant.Defendant_id LEFT OUTER JOIN
	dbo.tblCourt ON dbo.tblcase.Court_Id = dbo.tblCourt.Court_Id
	LEFT OUTER JOIN dbo.tblCase_Date_Details ON tblcase.Case_Id = dbo.tblCase_Date_Details.Case_Id
