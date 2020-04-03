


CREATE VIEW [dbo].[LCJ_VW_CaseSearchDetails]    
AS    
		SELECT DISTINCT     
                      dbo.tblProvider.Provider_Name, dbo.tblProvider.Provider_Suitname, dbo.tblCourt.Court_Name,
					  dbo.tblInsuranceCompany.InsuranceCompany_Name,     
                      dbo.tblStatus.Final_Status,dbo.tblStatus.forum, 
					 -- tblcase.fhkp_status, 
					  ISNULL(tblcase.InjuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InjuredParty_LastName, N'')     
                      AS InjuredParty_Name, ISNULL(dbo.tblAttorney.Attorney_FirstName, N'') + N'  ' + ISNULL(dbo.tblAttorney.Attorney_LastName, N'') AS Attorney_Name,     
                      ISNULL(tblcase.InsuredParty_FirstName, N'') + N'  ' + ISNULL(tblcase.InsuredParty_LastName, N'') AS InsuredParty_Name,     
                      ISNULL(dbo.tblAdjusters.Adjuster_FirstName, N'') + N'  ' + ISNULL(dbo.tblAdjusters.Adjuster_LastName, N'') AS Adjuster_Name, tblcase.Case_Id,     
                      tblcase.Caption, tblcase.Provider_Id, tblcase.InsuranceCompany_Id, tblcase.InjuredParty_LastName, tblcase.InjuredParty_FirstName,     
                      tblcase.InjuredParty_Address, tblcase.InjuredParty_City, tblcase.InjuredParty_State, tblcase.InjuredParty_Zip, tblcase.InjuredParty_Phone,     
                      tblcase.InjuredParty_Misc, tblcase.InsuredParty_LastName, tblcase.InsuredParty_FirstName, tblcase.InsuredParty_Address,     
                      tblcase.InsuredParty_City, tblcase.InsuredParty_State, tblcase.InsuredParty_Zip, tblcase.InsuredParty_Misc, tblcase.Accident_Date,     
                      tblcase.Denial_Date, tblcase.Accident_Address, tblcase.Accident_City, tblcase.Accident_State, tblcase.Accident_Zip, tblcase.Policy_Number,     
                      tblcase.Ins_Claim_Number,tblcase.StatusDisposition, tblcase.IndexOrAAA_Number, tblcase.Status, tblcase.Defendant_Id, tblcase.Date_Opened, tblcase.Last_Status,     
                      tblcase.Initial_Status, tblcase.Old_Status, tblcase.Memo, tblcase.InjuredParty_Type, tblcase.InsuredParty_Type, tblcase.Adjuster_Id,     
                      tblcase.DenialReasons_Type, tblcase.Rebuttal_Status, tblcase.Court_Id, tblcase.Group_Data, tblcase.Attorney_FileNumber, tblcase.Attorney_Id, tblcase.Group_Id,     
                      --ISNULL(tblcase.Assigned_Attorney, '') AS Assigned_Attorney,
					  Assigned_Attorney.Assigned_Attorney AS Assigned_Attorney,Assigned_Attorney.Assigned_Attorney_Address AS Assigned_Attorney_Address,
					  Assigned_Attorney.Assigned_Attorney_Phone AS Assigned_Attorney_Phone,
					  Assigned_Attorney.Assigned_Attorney_Fax AS Assigned_Attorney_Fax,Assigned_Attorney.Assigned_Attorney_Email AS Assigned_Attorney_Email,

					   tblcase.Date_Status_Changed, dbo.tblAdjusters.Adjuster_LastName,     
                      dbo.tblAdjusters.Adjuster_FirstName, dbo.tblAdjusters.Adjuster_Phone,dbo.tblAdjusters.Adjuster_Extension,dbo.tblAdjusters.Adjuster_Fax, dbo.tblAdjusters.Adjuster_Email,     
                      dbo.tblProvider.Provider_Type, dbo.tblProvider.Provider_Local_City, dbo.tblProvider.Provider_Local_Address, dbo.tblProvider.Provider_Local_State,     
                      dbo.tblProvider.Provider_Local_Zip, dbo.tblProvider.Provider_Local_Phone, dbo.tblProvider.Provider_Local_Fax, dbo.tblProvider.Provider_Contact,     
                      dbo.tblProvider.Provider_Perm_Address, dbo.tblProvider.Provider_Perm_City, dbo.tblProvider.Provider_Perm_State, dbo.tblProvider.Provider_Perm_Zip,     
                      dbo.tblProvider.Provider_Perm_Phone, dbo.tblProvider.Provider_Perm_Fax, dbo.tblProvider.Provider_Email, 
					  dbo.tblProvider.Provider_Billing, dbo.tblProvider.Settlement_Principal, dbo.tblProvider.Settlement_Interest,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Type, dbo.tblInsuranceCompany.InsuranceCompany_Local_City,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_Address, dbo.tblInsuranceCompany.InsuranceCompany_Local_State,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_Zip, dbo.tblInsuranceCompany.InsuranceCompany_Local_Phone,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Local_Fax, dbo.tblInsuranceCompany.InsuranceCompany_Perm_Address,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Perm_City, dbo.tblInsuranceCompany.InsuranceCompany_Perm_State,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Perm_Zip, dbo.tblInsuranceCompany.InsuranceCompany_Perm_Phone,     
					  dbo.tblInsuranceCompany.InsuranceCompany_Perm_Fax, dbo.tblInsuranceCompany.InsuranceCompany_Contact,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Email, dbo.tblCourt.Court_Venue, dbo.tblCourt.Court_Address, dbo.tblCourt.Court_Basis, dbo.tblCourt.Court_Misc,     
                      dbo.tblAttorney.Attorney_LastName, dbo.tblAttorney.Attorney_FirstName, dbo.tblAttorney.Attorney_Address, dbo.tblAttorney.Attorney_City,     
                      dbo.tblAttorney.Attorney_State, dbo.tblAttorney.Attorney_Zip, dbo.tblAttorney.Attorney_Phone, dbo.tblAttorney.Attorney_Fax, dbo.tblAttorney.Attorney_Email,     
                      dbo.tblDefendant.Defendant_Name, dbo.tblDefendant.Defendant_Address, dbo.tblDefendant.Defendant_State, dbo.tblDefendant.Defendant_Zip,     
                      dbo.tblDefendant.Defendant_Phone, dbo.tblDefendant.Defendant_Fax, dbo.tblDefendant.Defendant_Email, dbo.tblDefendant.Defendant_City,     
                      --tblcase.Date_Answer_Received, 
					  tblcase.Date_Summons_Sent_Court, tblcase.Date_Summons_Printed, tblcase.DateNotice_TrialFiled,     
                      tblcase.DateFile_Trial_DeNovo, tblcase.DateAAA_packagePrinting, tblcase.DateAAA_ResponceRecieved, tblcase.Date_Bill_Submitted,     
                      tblcase.Date_Index_Number_Purchased, tblcase.Date_Afidavit_Filed, tblcase.Date_Ext_Of_Time, tblcase.Plaintiff_Discovery_Due_Date,     
                      tblcase.Defendant_Discovery_Due_Date, tblcase.Motion_Date, 
					  --tblcase.Trial_Date,
					   tblcase.Case_Billing, CONVERT(varchar(12),     
                      tblcase.DateOfService_Start, 1) AS DateOfService_Start, CONVERT(varchar(12), tblcase.DateOfService_End, 1) AS DateOfService_End,     
                      tblcase.Claim_Amount, tblcase.Paid_Amount,
					  (SELECT   SUM(ISNULL(DeductibleAmount,0.00))   
                       FROM		dbo.tblTreatment  WITH(nolock)
                       WHERE    Case_Id = tblcase.Case_Id) AS Deductible_Amount,
					  ISNULL(tblcase.WriteOff,0) AS WriteOff,  tblcase.Date_BillSent, dbo.tblSettlements.Settlement_Id, dbo.tblSettlement_Type.Settlement_Type,     
                      ISNULL(dbo.tblSettlements.Settled_With_Name, N'') AS Settled_With_Name, Settled_Percent, ISNULL(SUBSTRING(dbo.tblSettlements.Settled_With_Name, 0, CHARINDEX(' ',     
                      LTRIM(RTRIM(dbo.tblSettlements.Settled_With_Name)), 0)), N'') AS Settled_With_First_Name, ISNULL(dbo.tblSettlements.Settled_With_Phone, N'')     
                      AS Settled_With_Phone, ISNULL(dbo.tblSettlements.Settled_With_Fax, N'') AS Settled_With_Fax, dbo.tblSettlements.Settlement_Amount,     
                      dbo.tblSettlements.Settlement_Int, dbo.tblSettlements.Settlement_Af, dbo.tblSettlements.Settlement_Ff, dbo.tblSettlements.Settlement_Total, CONVERT(MONEY,     
                      ISNULL(dbo.tblSettlements.Settlement_Amount, 0)) + CONVERT(MONEY, ISNULL(dbo.tblSettlements.Settlement_Int, 0)) AS Settlement_PI, Settled_by,    
                      dbo.tblSettlements.Settlement_Date, dbo.tblSettlements.SettledWith, dbo.tblSettlements.Settlement_Rfund_PR, dbo.tblSettlements.Settlement_Rfund_Int,     
                      dbo.tblSettlements.Settlement_Rfund_Total, dbo.tblSettlements.Settlement_Rfund_date, dbo.tblSettlements.Settlement_Rfund_Batch,     
                      tblcase.Date_Answer_Expected, tblcase.Reply_Date, tblcase.Calendar_Part, tblcase.Motion_Type, tblcase.Whose_Motion,     
                      tblcase.Defense_Opp_Due, tblcase.XMotion_Type, tblcase.Group_ClaimAmt, tblcase.Group_PaidAmt, tblcase.Group_Balance,     
                      tblcase.Group_InsClaimNo, tblcase.Group_All, tblcase.Group_All AS Group_Case, tblcase.Date_Packeted, tblcase.Group_Accident,     
                      tblcase.Group_PolicyNum, tblcase.GROUP_CASE_SEQUENCE, tblcase.Case_Code, tblcase.Provider_Code, tblcase.InsuranceCompany_Code,     
                      tblcase.Our_Discovery_Responses, tblcase.Our_Discovery_Demands, tblcase.Their_SJ_Motion_Activity, tblcase.Our_SJ_Motion_Activity,     
                      tblcase.Date_Ext_Of_Time_2, tblcase.Case_AutoId, dbo.tblInsuranceCompany.InsuranceCompany_SuitName, dbo.tblSettlements.User_Id,     
                      dbo.tblSettlements.Settlement_Notes, tblcase.Date_Ext_Of_Time_3, tblcase.Served_On_Date, 
					  tblcase.Served_On_Time, tblcase.Date_Closed,     
                      tblcase.stips_signed_and_returned_2, tblcase.stips_signed_and_returned_3, dbo.tblProvider.Provider_Contact2, dbo.tblProvider.Provider_IntBilling,     
                      dbo.tblProvider.Invoice_Type, dbo.tblProvider.cost_balance, dbo.tblProvider.Provider_Notes, dbo.tblProvider.Provider_ReferredBy, tblcase.Notary_id,     
                      dbo.NotaryPublic.NotaryPublicID, dbo.NotaryPublic.NPFirstName, dbo.NotaryPublic.NPMiddle, dbo.NotaryPublic.NPLastName, dbo.NotaryPublic.NPCounty,     
                      dbo.NotaryPublic.NPRegistrationNo, dbo.NotaryPublic.NPExpDate, dbo.tblProvider.Provider_TaxID, dbo.tblProvider.Provider_President,     
                      dbo.tblProvider.Billing_Manager, dbo.tblProvider.Provider_FF, dbo.tblProvider.Provider_ReturnFF, dbo.tblProvider.provider_Rfunds,     
                      tblcase.Date_Demands_Printed, tblcase.Date_Disc_Conf_Letter_Printed, tblcase.Date_Reply_To_Disc_Conf_Letter_Recd,     
                      tblcase.stips_signed_and_returned, dbo.tblprocessserver.psid, dbo.tblprocessserver.psfirstname, dbo.tblprocessserver.pslastname,     
                      ISNULL('LIC#: ' + dbo.tblprocessserver.pslicense, N'') AS pslicense, dbo.tblSettlements.Treatment_Id, CONVERT(money, ISNULL(tblcase.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(tblcase.Paid_Amount, 0)) AS Balance_Amount, ISNULL((CONVERT(float, tblcase.Claim_Amount) - CONVERT(float,     
                      tblcase.Paid_Amount)) * 0.8, N'') AS ClaimAmountPercentage, dbo.tblprocessserver.psfirstname + ' ' + dbo.tblprocessserver.pslastname AS Process_Server,     
                      dbo.tblServed.Name AS Served_To_Name, dbo.tblServed.Name AS Served_Name, dbo.tblServed.Age AS Served_Age, dbo.tblServed.Weight AS Served_Weight,     
                      dbo.tblServed.Height AS Served_Height, dbo.tblServed.skin AS Served_Skin, dbo.tblServed.hair AS Served_Hair, dbo.tblServed.sex AS Served_Sex,     
                      ISNULL(dbo.tblProvider.Provider_GroupName, '') AS Provider_GroupName, dbo.tblInsuranceCompany.Active, dbo.tblProvider.Provider_Collection_Agent,     
                      tblcase.Served_To, dbo.tblInsuranceCompany.InsuranceCompany_GroupName, tblcase.INSURANCECOMPANY_INITIAL_ADDRESS,     
                      tblcase.Representetive, tblcase.Representative_Contact_Number,   
					  (select ISNULL(sum(tblTransactions.Transactions_Amount),0) from tblTransactions with(nolock) where tblTransactions.Case_Id=tblcase.Case_Id and tblTransactions.DomainId=tblcase.DomainId and tblTransactions.Transactions_Type in ('PreC','PreCToP'))[Voluntary_Payment],
					  (select ISNULL(sum(tblTransactions.Transactions_Amount),0) from tblTransactions with(nolock) where tblTransactions.Case_Id=tblcase.Case_Id and tblTransactions.DomainId=tblcase.DomainId and tblTransactions.Transactions_Type in ('C','I'))[Collection_Payment],
                      dbo.tblProvider.Provider_Name + ISNULL(N' [Group: ' + dbo.tblProvider.Provider_GroupName + N' ]', N'') AS ProviderName_Long, dbo.tblProvider.Active AS Expr1,     
                      dbo.tblProvider.Provider_SeesFF, dbo.tblProvider.Provider_SeesRFF, dbo.tblProvider.Provider_Code AS Expr2, tblcase.Date_AAA_Arb_Filed,     
                      tblcase.Date_AAA_Concilation_Over, ISNULL(CONVERT(nvarchar(20), tblcase.AAA_Confirmed_Date), N'') AS AAA_Confirmed_Date, tblcase.GB_CASE_ID,     
                      tblcase.GB_CASE_NO, ISNULL(dbo.TblArbitrator.ARBITRATOR_NAME, N'') AS ARBITRATOR_NAME, dbo.tblProvider.Provider_InvoicedFF,     
                      dbo.tblProvider.Provider_attachChecks, ISNULL(dbo.tblProvider.isFromNassau, 0) AS isFromNassau, ISNULL(tblcase.Injured_Caption, '') AS Injured_Caption,     
                      ISNULL(tblcase.Provider_Caption, '') AS Provider_Caption,    
                          (SELECT     Doctor_Name    
                            FROM          dbo.TblReviewingDoctor   with(nolock) 
                            WHERE      (Doctor_id = tblcase.Doctor_id)) AS Doctor_Name, CASE WHEN CONVERT(nvarchar(20), datepart(dd, getdate()))     
                      = '11' THEN '11th' WHEN CONVERT(nvarchar(20), datepart(dd, getdate())) = '12' THEN '12th' WHEN CONVERT(nvarchar(20), datepart(dd, getdate()))     
                      = '13' THEN '13th' WHEN RIGHT(CONVERT(nvarchar(20), datepart(dd, getdate())), 1) = '1' THEN CONVERT(nvarchar(20), datepart(dd, getdate()))     
                      + 'st' WHEN RIGHT(CONVERT(nvarchar(20), datepart(dd, getdate())), 1) = '2' THEN CONVERT(nvarchar(20), datepart(dd, getdate()))     
                      + 'nd' WHEN RIGHT(CONVERT(nvarchar(20), datepart(dd, getdate())), 1) = '3' THEN CONVERT(nvarchar(20), datepart(dd, getdate())) + 'rd' ELSE CONVERT(nvarchar(20),     
                      datepart(dd, getdate())) + 'th' END AS SUMMONS_DAY, DATENAME(mm, GETDATE()) AS SUMMONS_MONTH, DATEPART(yy, GETDATE()) AS SUMMONS_YEAR,     
                      CONVERT(NVARCHAR(12), CONVERT(DATETIME, tblcase.DateOfService_Start), 101) AS DOS_Start, CONVERT(NVARCHAR(12), CONVERT(DATETIME,     
                      tblcase.DateOfService_End), 101) AS DOS_End, ISNULL    
                          ((SELECT     TOP (1) SERVICE_TYPE    
                              FROM         dbo.tblTreatment  with(nolock)  
                              WHERE    tblcase.DomainId = tr.DomainId AND  (Case_Id = cast(tblcase.Case_Id as nvarchar(50)))    
                              ORDER BY DateOfService_Start), N'') AS Service_Type, ISNULL    
                          ((SELECT     TOP (1) DateOfService_Start    
                              FROM         dbo.tblTreatment AS tblTreatment_1 with(nolock)     
                              WHERE     tblcase.DomainId = tr.DomainId AND (Case_Id = cast(tblcase.Case_Id as nvarchar(50)))    
                              ORDER BY DateOfService_Start), N'') AS DateOfServiceStart, CONVERT(decimal(38, 2), ISNULL(CONVERT(float, dbo.tblSettlements.Settlement_Amount)     
                      / (CASE WHEN (CONVERT(float, ISNULL(tblcase.Claim_Amount, 1)) - CONVERT(float, ISNULL(tblcase.Paid_Amount, 1))) = 0 THEN 1 ELSE (CONVERT(float,     
                      ISNULL(tblcase.Claim_Amount, 1)) - CONVERT(float, ISNULL(tblcase.Paid_Amount, 1))) END) * 100, N'')) AS SettlementAmountPercentage,     
                      UPPER(DATENAME(mm, GETDATE())) + ' ' + DATENAME(dd, GETDATE()) + ', ' + DATENAME(yy, GETDATE()) AS todaydate, CASE WHEN RIGHT(CONVERT(nvarchar(20),     
                      datepart(dd, dateadd(dd, 10, getdate()))), 1) = '1' THEN CONVERT(nvarchar(20), datepart(dd, dateadd(dd, 10, getdate()))) + 'st' WHEN RIGHT(CONVERT(nvarchar(20),     
                      datepart(dd, dateadd(dd, 10, getdate()))), 1) = '2' THEN CONVERT(nvarchar(20), datepart(dd, dateadd(dd, 10, getdate()))) + 'nd' WHEN RIGHT(CONVERT(nvarchar(20),     
                      datepart(dd, dateadd(dd, 10, getdate()))), 1) = '3' THEN CONVERT(nvarchar(20), datepart(dd, dateadd(dd, 10, getdate()))) + 'rd' ELSE CONVERT(nvarchar(20), datepart(dd,     
                      dateadd(dd, 10, getdate()))) + 'th' END AS NOT_DAY, DATENAME(mm, DATEADD(dd, 10, GETDATE())) AS NOT_MONTH, DATEPART(yy, DATEADD(dd, 10, GETDATE()))     
                      AS NOT_YEAR, CONVERT(nvarchar(12), DATEADD(dd, 10, GETDATE()), 101) AS NOT_DATE, DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(),     
                      107), 9) AS Today_Date, tblcase.batchcode, tblcase.location_id, ISNULL(mst.Location_Address, '') AS Location_Address, ISNULL(mst.Location_City, '')     
                      AS Location_City, ISNULL(mst.Location_State, '') AS Location_State, ISNULL(mst.Location_Zip, '') AS Location_Zip, (CASE WHEN Date_Ext_Of_Time_3 <> '' OR    
                      Date_Ext_Of_Time_3 IS NOT NULL THEN CONVERT(NVARCHAR(12), Date_Ext_Of_Time_3, 101) WHEN Date_Ext_Of_Time_2 <> '' OR    
                      Date_Ext_Of_Time_2 IS NOT NULL THEN CONVERT(NVARCHAR(12), Date_Ext_Of_Time_2, 101) WHEN Date_Ext_Of_Time <> '' OR    
                      Date_Ext_Of_Time IS NOT NULL THEN CONVERT(NVARCHAR(12), Date_Ext_Of_Time, 101) ELSE '' END) AS Date_Extlate,     
                      dbo.tblInsuranceCompany.InsuranceCompany_Name AS INSURANCE_NAME, tblcase.AAA_Decisions, tblcase.Fee_Schedule,     
                      dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_Address, '')) AS FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,     
                      dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_City, '')) AS FIRSTCAP_INSCOMPANY_LOCAL_CITY,     
                      dbo.udfSplit(tblcase.IndexOrAAA_Number, '/') AS INDEX_YEAR, dbo.udfSplit_First(tblcase.IndexOrAAA_Number, '/') AS INDEX_NO,     
                      tblcase.Date_of_AAA_Awards, --tblcase.Date_Open_Verification_Response_Sent2, 
					   
                      tblcase.Date_NAM_Package_Printed, tblcase.Date_of_NAM_Awards, tblcase.Date_NAM_Response_Received, tblcase.Date_NAM_Confirmed,     
                      tblcase.Date_NAM_ARB_Filed, tblcase.OPENED_BY, tblcase.firm_split_percent,ecmc.Account as ECMC_Account, tblcase.DomainId    
						,tblcase.PortfolioId,tblcase.AttorneyFirmId, PF.NAME 'PortfolioName', AF.Name 'AttorneyFirmName'  
						 --,tblcase.CASE_EVALUATION_DATE
						 ,tblcase.FIRST_PARTY_SUIT_DATE,
						 --tblcase.LITIGATION_PAYMENT_DATE,
						 dbo.tblCase_Date_Details.Date_Open_Verification_Response_Sent1, 
                         dbo.tblCase_Date_Details.Date_Open_Verification_Response_Sent2, dbo.tblCase_Date_Details.CASE_EVALUATION_DATE, dbo.tblCase_Date_Details.LITIGATION_PAYMENT_DATE, dbo.tblCase_Date_Details.Appeal_Date, 
                         dbo.tblCase_Date_Details.Summons_and_Complaint_Date, dbo.tblCase_Date_Details.Date_Summons_Expires, dbo.tblCase_Date_Details.Plaintiff_Disccovery_Request_Package, 
                         dbo.tblCase_Date_Details.Plaintiff_Discovery_Responses_Completed, dbo.tblCase_Date_Details.Date_Case_Purchased, dbo.tblCase_Date_Details.Defense_Discovery_Receipt_Date, 
                         dbo.tblCase_Date_Details.Motion_For_Ext_of_Time_1, dbo.tblCase_Date_Details.Motion_For_Ext_of_Time_2, dbo.tblCase_Date_Details.Pre_Trial_Conf_Date, dbo.tblCase_Date_Details.Case_Evaluation_Summary_Due_Date, 
                         dbo.tblCase_Date_Details.Case_Evaluation_Accept_or_Reject, dbo.tblCase_Date_Details.Settlement_Conference, dbo.tblCase_Date_Details.Facilitation_Date, dbo.tblCase_Date_Details.Witness_and_Exhibit_List_Due_Date, 
                         dbo.tblCase_Date_Details.Trial_Notebook_Due_Date, dbo.tblCase_Date_Details.Dismissal_Date, dbo.tblCase_Date_Details.Date_Answer_Received, dbo.tblCase_Date_Details.Trial_Date,dbo.tblCase_Date_Details.First_Party_Suit_Filed_Date

				FROM  dbo.tblcase AS tblcase WITH (NOLOCK)
					  LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON tblcase.Status = dbo.tblStatus.Status_Abr  and tblcase.DomainId=tblStatus.DomainId
					  LEFT OUTER JOIN   dbo.NotaryPublic WITH (NOLOCK) ON tblcase.Notary_id = dbo.NotaryPublic.NotaryPublicID 
					  LEFT OUTER JOIN  dbo.tblprocessserver WITH (NOLOCK) ON tblcase.psid = dbo.tblprocessserver.psid 
					  INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
					  INNER JOIN dbo.tblProvider WITH (NOLOCK) ON tblcase.Provider_Id = dbo.tblProvider.Provider_Id 
					  LEFT OUTER JOIN dbo.tblServed WITH (NOLOCK) ON tblcase.Served_To = dbo.tblServed.ID 
					  LEFT OUTER JOIN  dbo.tblAttorney WITH (NOLOCK) ON tblcase.Attorney_Id = dbo.tblAttorney.Attorney_Id 
					  LEFT OUTER JOIN  dbo.tblDefendant WITH (NOLOCK) ON tblcase.Defendant_Id = dbo.tblDefendant.Defendant_id 
					  LEFT OUTER JOIN  dbo.tblAdjusters WITH (NOLOCK) ON tblcase.Adjuster_Id = dbo.tblAdjusters.Adjuster_Id 
					  LEFT OUTER JOIN  dbo.tblCourt WITH (NOLOCK) ON tblcase.Court_Id = dbo.tblCourt.Court_Id 
					  LEFT OUTER JOIN  dbo.TblArbitrator WITH (NOLOCK) ON tblcase.Arbitrator_ID = dbo.TblArbitrator.ARBITRATOR_ID 
					  LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON tblcase.Case_Id = dbo.tblSettlements.Case_Id 
					  LEFT OUTER JOIN  dbo.tblSettlement_Type WITH (NOLOCK) ON dbo.tblSettlements.Settled_Type = dbo.tblSettlement_Type.SettlementType_Id 
					  LEFT OUTER JOIN  dbo.MST_Service_Rendered_Location   AS mst WITH (NOLOCK) ON tblcase.location_id = mst.Location_Id 
					  LEFT OUTER JOIN   dbo.ecmc WITH (NOLOCK) on tblcase.Case_id= ecmc.fhkp_case_id    
					  left outer join tbl_portfolio PF WITH (NOLOCK) ON tblcase.PortfolioId=pf.id  
					  left outer join tbl_attorneyFirm AF WITH (NOLOCK) ON tblcase.AttorneyFirmId=af.id
					  LEFT OUTER JOIN dbo.tblCase_Date_Details (NOLOCK) ON tblcase.DomainId = tblCase_Date_Details.DomainId AND tblcase.Case_Id = dbo.tblCase_Date_Details.Case_Id
					  LEFT OUTER JOIN dbo.Assigned_Attorney (NOLOCK) ON tblcase.Assigned_Attorney = dbo.Assigned_Attorney.PK_Assigned_Attorney_ID
					  LEFT OUTER JOIN tblTreatment Tr WITH (NOLOCK) ON tblcase.DomainId = tr.DomainId AND cast(tblcase.Case_Id as nvarchar(50))=Tr.Case_Id
					   
			   Where  ISNULL(tblcase.IsDeleted,0) = 0

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[21] 4[29] 2[29] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[57] 4[29] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -194
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 2
               Left = 261
               Bottom = 205
               Right = 534
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "NotaryPublic"
            Begin Extent = 
               Top = 14
               Left = 455
               Bottom = 122
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblprocessserver"
            Begin Extent = 
               Top = 326
               Left = 486
               Bottom = 434
               Right = 637
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 95
               Left = 0
               Bottom = 203
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 207
               Left = 38
               Bottom = 315
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 40
         End
         Begin Table = "tblServed"
            Begin Extent = 
               Top = 13
               Left = 668
               Bottom = 198
               Right = 857
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "tblAttorney"
            Begin Extent = 
               Top = 222
               Left = 271
               Bottom = 330
               Right = 448
        ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LCJ_VW_CaseSearchDetails';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'    End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblDefendant"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblAdjusters"
            Begin Extent = 
               Top = 330
               Left = 252
               Bottom = 438
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblCourt"
            Begin Extent = 
               Top = 141
               Left = 436
               Bottom = 249
               Right = 588
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TblArbitrator"
            Begin Extent = 
               Top = 440
               Left = 38
               Bottom = 548
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblSettlements"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 9720
         Alias = 2805
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LCJ_VW_CaseSearchDetails';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LCJ_VW_CaseSearchDetails';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'LCJ_VW_CaseSearchDetails';

