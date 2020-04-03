

  
  
  
CREATE VIEW [dbo].[LCJ_VW_CaseDetails]  
AS  
SELECT    tblcase.Case_AutoId,tblcase.Case_Id,tblcase.Case_Code,tblcase.Provider_Code,tblcase.InsuranceCompany_Code,   
                     tblcase.Provider_Id,tblcase.InsuranceCompany_Id,tblcase.InjuredParty_LastName,tblcase.InjuredParty_FirstName,   
                     tblcase.InjuredParty_Address,tblcase.InjuredParty_City,tblcase.InjuredParty_State,tblcase.InjuredParty_Zip,   
                     tblcase.InjuredParty_Phone,tblcase.InjuredParty_Misc,tblcase.InsuredParty_LastName,tblcase.InsuredParty_FirstName,   
                     tblcase.InsuredParty_Address,tblcase.InsuredParty_City,tblcase.InsuredParty_State,tblcase.InsuredParty_Zip,   
                     tblcase.InsuredParty_Misc,tblcase.Accident_Date,tblcase.Accident_Address,tblcase.Accident_City,tblcase.Accident_State,   
                     tblcase.Accident_Zip,tblcase.Policy_Number,tblcase.Ins_Claim_Number,tblcase.IndexOrAAA_Number,tblcase.Status,   
                     tblcase.Old_Status,tblcase.Defendant_Id,tblcase.Date_Opened,tblcase.Last_Status,tblcase.Initial_Status,tblcase.Memo,   
                     tblcase.InjuredParty_Type,tblcase.InsuredParty_Type,tblcase.Adjuster_Id,tblcase.DenialReasons_Type,tblcase.Court_Id,   
                     tblcase.Attorney_FileNumber,tblcase.Group_Data,tblcase.Group_Id,tblcase.Date_Status_Changed,   
                     tblCase_Date_Details.Date_Answer_Received,tblcase.Motion_Date,tblCase_Date_Details.Trial_Date,tblcase.Attorney_Id,tblcase.Date_Answer_Expected,   
                     tblcase.Reply_Date,tblcase.Calendar_Part,tblcase.Motion_Type,tblcase.Whose_Motion,tblcase.Defense_Opp_Due,   
                     tblcase.Date_Ext_Of_Time_2,tblcase.XMotion_Type,tblcase.Case_Billing,tblcase.DateOfService_Start,   
                     tblcase.DateOfService_End,tblcase.Claim_Amount,tblcase.Paid_Amount,tblcase.Date_BillSent,tblcase.Caption,   
                     tblcase.Group_ClaimAmt,tblcase.Group_PaidAmt,tblcase.Group_Balance,tblcase.Group_InsClaimNo,tblcase.Group_All,   
                     tblcase.Date_Packeted,tblcase.Group_Accident,tblcase.Group_PolicyNum,tblcase.GROUP_CASE_SEQUENCE,   
                     tblcase.Our_SJ_Motion_Activity,tblcase.Their_SJ_Motion_Activity,tblcase.Our_Discovery_Demands,   
                     tblcase.Our_Discovery_Responses,tblcase.Date_Summons_Printed,tblcase.Plaintiff_Discovery_Due_Date,   
                     tblcase.Defendant_Discovery_Due_Date,tblcase.Date_Bill_Submitted,tblcase.Date_Index_Number_Purchased,   
                     tblcase.Date_Afidavit_Filed,tblcase.Date_Ext_Of_Time,tblcase.Date_Summons_Sent_Court,tblcase.Date_Ext_Of_Time_3,   
                     tblcase.Served_To,tblcase.Served_On_Date,tblcase.Served_On_Time,tblcase.Date_Closed,tblcase.Notary_id,   
                     tblcase.stips_signed_and_returned,tblcase.stips_signed_and_returned_2,tblcase.stips_signed_and_returned_3,   
                     tblcase.Date_Demands_Printed,tblcase.Date_Disc_Conf_Letter_Printed,tblcase.Date_Reply_To_Disc_Conf_Letter_Recd,   
                     tblcase.psid,tblTreatment.Treatment_Id,tblTreatment.Case_Id AS Expr1,tblTreatment.DateOfService_Start AS Expr2,   
                     tblTreatment.DateOfService_End AS Expr3,tblTreatment.Claim_Amount AS Expr4,tblTreatment.Paid_Amount AS Expr5,   
                     tblTreatment.Date_BillSent AS Expr6,tblTreatment.SERVICE_TYPE, '' AS Expr7,   
                     tblTreatment.Settlement_Pctg,tblTreatment.Interest_Pctg,tblTreatment.AttorneyFee,tblTreatment.FilingFeeAmt,   
                     tblTreatment.SettlementInt,tblTreatment.CPT_Id,tblcase.Served_On_Date AS date_summons_Served,  
      tblcase.batchcode AS batchcode,tblcase.location_id as location_id, isnull (mst.Location_Address,'') as Location_Address, isnull (mst.Location_City,'') as Location_City, isnull (mst.Location_State,'') as Location_State, isnull (mst.Location_Zip,'') as Location_Zip,tblcase.DomainId  
	  ,tblcase.PortfolioId, tblcase.AttorneyFirmId	
  
FROM         dbo.tblcase AS tblcase LEFT OUTER JOIN  
                    dbo.tblTreatment As tblTreatment ON tblcase.Case_Id = tblTreatment.Case_Id AND tblcase.DomainId = tblTreatment.DomainId  
LEFT OUTER JOIN  
       dbo.MST_Service_Rendered_Location mst on tblcase.Location_Id = mst.Location_Id and tblcase.DomainId = mst.DomainId
	   LEFT OUTER JOIN dbo.tblCase_Date_Details ON tblcase.Case_Id = dbo.tblCase_Date_Details.Case_Id  
