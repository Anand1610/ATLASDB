






/***************** Start of View LCJ_VW_CaseDetailsForClientReport **********************
**************** End of View LCJ_VW_CaseDetailsForClientReport ***********************/
CREATE VIEW [dbo].[LCJ_VW_CaseDetailsForClientReport]
AS
SELECT DISTINCT 
                      dbo.tblProvider.Provider_Name, dbo.tblCourt.Court_Name, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      ISNULL(dbo.tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InjuredParty_LastName, N'') AS InjuredParty_Name, 
                      ISNULL(dbo.tblAttorney.Attorney_FirstName, N'') + N'  ' + ISNULL(dbo.tblAttorney.Attorney_LastName, N'') AS Attorney_Name, 
                      ISNULL(dbo.tblcase.InsuredParty_FirstName, N'') + N'  ' + ISNULL(dbo.tblcase.InsuredParty_LastName, N'') AS InsuredParty_Name, 
                      ISNULL(dbo.tblAdjusters.Adjuster_FirstName, N'') + N'  ' + ISNULL(dbo.tblAdjusters.Adjuster_LastName, N'') AS Adjuster_Name, dbo.tblcase.Case_Id, 
                      dbo.tblcase.Caption, dbo.tblcase.Provider_Id, dbo.tblcase.InsuranceCompany_Id, dbo.tblcase.InjuredParty_LastName, 
                      dbo.tblcase.InjuredParty_FirstName, dbo.tblcase.InjuredParty_Address, dbo.tblcase.InjuredParty_City, dbo.tblcase.InjuredParty_State, 
                      dbo.tblcase.InjuredParty_Zip, dbo.tblcase.InjuredParty_Phone, dbo.tblcase.InjuredParty_Misc, dbo.tblcase.InsuredParty_LastName, 
                      dbo.tblcase.InsuredParty_FirstName, dbo.tblcase.InsuredParty_Address, dbo.tblcase.InsuredParty_City, dbo.tblcase.InsuredParty_State, 
                      dbo.tblcase.InsuredParty_Zip, dbo.tblcase.InsuredParty_Misc, dbo.tblcase.Accident_Date, dbo.tblcase.Accident_Address, dbo.tblcase.Accident_City, 
                      dbo.tblcase.Accident_State, dbo.tblcase.Accident_Zip, dbo.tblcase.Policy_Number, dbo.tblcase.Ins_Claim_Number, dbo.tblcase.IndexOrAAA_Number, 
                      dbo.tblcase.Status, dbo.tblcase.Defendant_Id, dbo.tblcase.Date_Opened, dbo.tblcase.Last_Status, dbo.tblcase.Initial_Status, dbo.tblcase.Memo, 
                      dbo.tblcase.InjuredParty_Type, dbo.tblcase.InsuredParty_Type, dbo.tblcase.Adjuster_Id, dbo.tblcase.DenialReasons_Type, dbo.tblcase.Court_Id, 
                      dbo.tblcase.Group_Data, dbo.tblcase.Attorney_FileNumber, dbo.tblcase.Attorney_Id, dbo.tblcase.Group_Id, dbo.tblcase.Date_Status_Changed, 
                      dbo.tblAdjusters.Adjuster_LastName, dbo.tblAdjusters.Adjuster_FirstName, dbo.tblAdjusters.Adjuster_Phone, dbo.tblAdjusters.Adjuster_Fax, 
                      dbo.tblAdjusters.Adjuster_Email, dbo.tblProvider.Provider_Type, dbo.tblProvider.Provider_Local_City, dbo.tblProvider.Provider_Local_Address, 
                      dbo.tblProvider.Provider_Local_State, dbo.tblProvider.Provider_Local_Zip, dbo.tblProvider.Provider_Local_Phone, 
                      dbo.tblProvider.Provider_Local_Fax, dbo.tblProvider.Provider_Contact, dbo.tblProvider.Provider_Perm_Address, dbo.tblProvider.Provider_Perm_City, 
                      dbo.tblProvider.Provider_Perm_State, dbo.tblProvider.Provider_Perm_Zip, dbo.tblProvider.Provider_Perm_Phone, dbo.tblProvider.Provider_Perm_Fax, 
                      dbo.tblProvider.Provider_Email, dbo.tblProvider.Provider_Billing, dbo.tblInsuranceCompany.InsuranceCompany_Type, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_City, dbo.tblInsuranceCompany.InsuranceCompany_Local_Address, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_State, dbo.tblInsuranceCompany.InsuranceCompany_Local_Zip, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_Phone, dbo.tblInsuranceCompany.InsuranceCompany_Local_Fax, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Perm_Address, dbo.tblInsuranceCompany.InsuranceCompany_Perm_City, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Perm_State, dbo.tblInsuranceCompany.InsuranceCompany_Perm_Zip, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Perm_Phone, dbo.tblInsuranceCompany.InsuranceCompany_Perm_Fax, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Contact, dbo.tblInsuranceCompany.InsuranceCompany_Email, dbo.tblCourt.Court_Venue, 
                      dbo.tblCourt.Court_Address, dbo.tblCourt.Court_Basis, dbo.tblCourt.Court_Misc, dbo.tblAttorney.Attorney_LastName, 
                      dbo.tblAttorney.Attorney_FirstName, dbo.tblAttorney.Attorney_Address, dbo.tblAttorney.Attorney_City, dbo.tblAttorney.Attorney_State, 
                      dbo.tblAttorney.Attorney_Zip, dbo.tblAttorney.Attorney_Phone, dbo.tblAttorney.Attorney_Fax, dbo.tblAttorney.Attorney_Email, 
                      dbo.tblDefendant.Defendant_Name, dbo.tblDefendant.Defendant_Address, dbo.tblDefendant.Defendant_State, dbo.tblDefendant.Defendant_Zip, 
                      dbo.tblDefendant.Defendant_Phone, dbo.tblDefendant.Defendant_Fax, dbo.tblDefendant.Defendant_Email, dbo.tblDefendant.Defendant_City, 
                      dbo.tblCase_Date_Details.Date_Answer_Received, dbo.tblcase.Date_Summons_Sent_Court, dbo.tblcase.Date_Summons_Printed, dbo.tblcase.Date_Bill_Submitted, 
                      dbo.tblcase.Date_Index_Number_Purchased, dbo.tblcase.Date_Afidavit_Filed, dbo.tblcase.Date_Ext_Of_Time, 
                      dbo.tblcase.Plaintiff_Discovery_Due_Date, dbo.tblcase.Defendant_Discovery_Due_Date, dbo.tblcase.Motion_Date, dbo.tblCase_Date_Details.Trial_Date, 
                      dbo.tblcase.Case_Billing, dbo.tblcase.DateOfService_Start, dbo.tblcase.DateOfService_End,
					  CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR(10),dbo.tblcase.DateOfService_End,101) AS DOS_Range,
					  dbo.tblcase.Claim_Amount, dbo.tblcase.Paid_Amount, 
					  (select top 1 Notes_Desc from tblNotes where Notes_Type in ('Delay','DELAY ARB') and DomainId=dbo.tblcase.DomainId and Case_Id=dbo.tblcase.Case_Id order by Notes_Date desc)[delay_notes],
                      dbo.tblcase.Date_BillSent, dbo.tblcase.Date_Answer_Expected, dbo.tblcase.Reply_Date, dbo.tblcase.Calendar_Part, dbo.tblcase.Motion_Type, 
                      dbo.tblcase.Whose_Motion, dbo.tblcase.Defense_Opp_Due, dbo.tblcase.XMotion_Type, dbo.tblcase.Group_ClaimAmt, dbo.tblcase.Group_PaidAmt, 
                      dbo.tblcase.Group_Balance, dbo.tblcase.Group_InsClaimNo, dbo.tblcase.Group_All, dbo.tblcase.Group_All AS Group_Case, dbo.tblcase.Date_Packeted,
                       dbo.tblcase.Group_Accident, dbo.tblcase.Group_PolicyNum, dbo.tblcase.GROUP_CASE_SEQUENCE, dbo.tblcase.Case_Code, 
                      dbo.tblcase.Provider_Code, dbo.tblcase.InsuranceCompany_Code, dbo.tblcase.Our_Discovery_Responses, dbo.tblcase.Our_Discovery_Demands, 
                      dbo.tblcase.Their_SJ_Motion_Activity, dbo.tblcase.Our_SJ_Motion_Activity, dbo.tblcase.Date_Ext_Of_Time_2, dbo.tblcase.Case_AutoId, 
                      dbo.tblInsuranceCompany.InsuranceCompany_SuitName, dbo.tblcase.Date_Ext_Of_Time_3, dbo.tblcase.Served_To, dbo.tblcase.Served_On_Date, 
                      dbo.tblcase.Served_On_Time, dbo.tblcase.Date_Closed, dbo.tblcase.stips_signed_and_returned_2, dbo.tblcase.stips_signed_and_returned_3, 
                      dbo.tblProvider.Provider_Contact2, dbo.tblProvider.Provider_IntBilling, dbo.tblProvider.Invoice_Type, dbo.tblProvider.cost_balance, 
                      dbo.tblProvider.Provider_Notes, dbo.tblProvider.Provider_ReferredBy, dbo.tblcase.Notary_id, dbo.NotaryPublic.NotaryPublicID, 
                      dbo.NotaryPublic.NPFirstName, dbo.NotaryPublic.NPMiddle, dbo.NotaryPublic.NPLastName, dbo.NotaryPublic.NPCounty, 
                      dbo.NotaryPublic.NPRegistrationNo, dbo.NotaryPublic.NPExpDate, dbo.tblProvider.Provider_TaxID, dbo.tblProvider.Provider_President, 
                      dbo.tblProvider.Provider_FF, dbo.tblProvider.Provider_ReturnFF, dbo.tblProvider.provider_Rfunds, dbo.tblcase.Date_Demands_Printed, 
                      dbo.tblcase.Date_Disc_Conf_Letter_Printed, dbo.tblcase.Date_Reply_To_Disc_Conf_Letter_Recd, dbo.tblcase.stips_signed_and_returned, 
                      dbo.tblprocessserver.psid, dbo.tblprocessserver.psfirstname, dbo.tblprocessserver.pslastname, dbo.tblprocessserver.pslicense, 
                      ISNULL(CONVERT(float, dbo.tblcase.Claim_Amount) - CONVERT(float, dbo.tblcase.Paid_Amount), 0) AS Balance_Amount,
					  ISNULL(CONVERT(float, dbo.tblcase.Fee_Schedule) - CONVERT(float, dbo.tblcase.Paid_Amount), 0) AS FS_Balance_Amount,
					  ISNULL(dbo.tblSettlements.Settlement_Amount,0.00) AS Settlement_Amount,
					  ISNULL(dbo.tblSettlements.Settlement_Amount,0.00) + ISNULL(dbo.tblSettlements.Settlement_Int,0.00) AS Settlement_PI,
					  CONVERT (VARCHAR(10),(select MAX(Event_Date) from tblEvent E inner join tblEventType T on E.EventTypeId = T.EventTypeId inner join tblEventStatus S on E.EventStatusId = S.EventStatusId WHERE Case_id =dbo.tblcase.Case_Id and (EventStatusName like '%HEARING%' OR EventStatusName like '%Trial%')),101) AS Event_Date,tblcase.DomainId
FROM         dbo.tblcase LEFT OUTER JOIN
                      dbo.NotaryPublic ON dbo.tblcase.Notary_id = dbo.NotaryPublic.NotaryPublicID LEFT OUTER JOIN
                      dbo.tblprocessserver ON dbo.tblcase.psid = dbo.tblprocessserver.psid INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id LEFT OUTER JOIN
                      dbo.tblAttorney ON dbo.tblcase.Attorney_Id = dbo.tblAttorney.Attorney_Id LEFT OUTER JOIN
                      dbo.tblDefendant ON dbo.tblcase.Defendant_Id = dbo.tblDefendant.Defendant_id LEFT OUTER JOIN
                      dbo.tblAdjusters ON dbo.tblcase.Adjuster_Id = dbo.tblAdjusters.Adjuster_Id LEFT OUTER JOIN
                      dbo.tblCourt ON dbo.tblcase.Court_Id = dbo.tblCourt.Court_Id LEFT OUTER JOIN
					  dbo.tblSettlements ON dbo.tblcase.Case_Id=dbo.tblSettlements.Case_Id
					  LEFT OUTER JOIN dbo.tblCase_Date_Details ON tblcase.Case_Id = dbo.tblCase_Date_Details.Case_Id
