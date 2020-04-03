      
CREATE PROCEDURE [dbo].[LCJ_WorkArea_CaseInfo]-- LCJ_WorkArea_CaseInfo @DomainId = 'JL', @strCaseId = 'JL19-101086'       
(          
 @DomainId VARCHAR(40),      
 @strCaseId VARCHAR(40)          
)          
AS              
BEGIN      
 SET NOCOUNT ON      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
       
  DECLARE @dt_SETtlement DATETIME      
  DECLARE @dt_paid_full DATETIME      
  DECLARE @dt_withdrawn DATETIME      
  DECLARE @dt_opened DATETIME      
  DECLARE @Min_DOS_Start DATETIME      
  DECLARE @Max_DOS_End DATETIME     
  DECLARE @i_case_age INT

     
 SET @dt_SETtlement = (SELECT TOP 1 SETtlement_date FROM tblSETtlements (NOLOCK) WHERE case_id = @strCaseId and DomainId=@DomainId)      
 SET @dt_paid_full = (SELECT TOP 1 NOTES_DATE FROM tblNotes (NOLOCK) WHERE case_id = cast(@strCaseId as varchar(50)) and DomainId=cast(@DomainId as varchar(50)) AND notes_desc like '%to paid-full%' ORDER BY NOTES_DATE DESC)      
 SET @dt_withdrawn = (SELECT TOP 1 NOTES_DATE FROM tblNotes (NOLOCK) WHERE case_id = cast(@strCaseId as varchar(50))  and DomainId=cast(@DomainId as varchar(50)) and notes_desc like '%to WITHDRAWN%' ORDER BY NOTES_DATE DESC)      
 SET @dt_opened = (SELECT date_opened FROM tblcase (NOLOCK) WHERE case_id = cast(@strCaseId as varchar(50)) and DomainId=cast(@DomainId  as varchar(50)))        
 SET @Min_DOS_Start=(SELECT min(DateOfService_Start)as DOS_Start FROM tblTreatment (NOLOCK) WHERE Case_Id = @strCaseId  and DomainId=@DomainId )        
 SET @Max_DOS_End=(SELECT max(DateOfService_End)as DOS_End FROM tblTreatment (NOLOCK) WHERE Case_Id =  @strCaseId  and DomainId=@DomainId )      
        
       
 SET @i_case_age = CASE WHEN @DomainId = 'amt' THEN CASE WHEN @dt_SETtlement IS NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL THEN DATEDIFF(day,@Max_DOS_End,GETDATE())       
      WHEN @dt_SETtlement IS NOT NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL THEN  DATEDIFF(day,@Max_DOS_End,@dt_SETtlement)      
      WHEN @dt_paid_full IS NOT NULL AND @dt_SETtlement IS NULL AND @dt_withdrawn IS NULL THEN DATEDIFF(day,@Max_DOS_End,@dt_paid_full)      
      WHEN @dt_withdrawn IS NOT NULL AND @dt_paid_full IS NULL AND @dt_SETtlement IS NULL THEN DATEDIFF(day,@Max_DOS_End,@dt_withdrawn)      
      ELSE DATEDIFF(day,@Max_DOS_End,GETDATE()) END ELSE CASE WHEN @dt_SETtlement IS NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL THEN        
      DATEDIFF(DAY,@dt_opened,GETDATE()) WHEN @dt_SETtlement IS NOT NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL THEN      
      DATEDIFF(DAY,@dt_opened,@dt_SETtlement) WHEN @dt_paid_full IS NOT NULL AND @dt_SETtlement IS NULL AND @dt_withdrawn IS NULL THEN      
      DATEDIFF(day,@dt_opened,@dt_paid_full) WHEN @dt_withdrawn IS NOT NULL AND @dt_paid_full IS NULL AND @dt_SETtlement IS NULL       
      THEN DATEDIFF(day,@dt_opened,@dt_withdrawn) ELSE DATEDIFF(day,@dt_opened,GETDATE()) END END      
       
        
 SELECT   
	Date_Answer_Received
	, PF.Name as PortfolioName
	, Date_Opened
	, Date_Summons_Printed
	, DateNotice_TrialFiled
	, DateAAA_packagePrinting
	, Plaintiff_Discovery_Due_Date
	, Defendant_Discovery_Due_Date
	, Date_Bill_Submitted
	, Date_Afidavit_Filed
	, Date_Summons_Sent_Court
	, Date_Index_Number_Purchased
	, Date_Ext_Of_Time
	, Date_Ext_Of_Time_2
	, Date_Ext_Of_Time_3
	, Date_Status_Changed
	, Served_On_Date
	, Served_To
	, Served_On_Time
	, dbo.tblServed.Name AS Served_To_Name
	, Date_Closed
	, Date_Demands_Printed
	, Date_Disc_Conf_Letter_Printed
	, Date_Reply_To_Disc_Conf_Letter_Recd
	, Date_AAA_Arb_Filed
	, Date_AAA_Concilation_Over
	, AAA_Confirmed_Date
	, Provider_President
	, Billing_Manager
	, Date_of_AAA_Awards
	, Date_NAM_ARB_Filed
	, Date_NAM_Confirmed
	, Date_NAM_Response_Received
	, Date_of_NAM_Awards
	, Date_NAM_Package_Printed
	, stips_signed_and_returned
	, stips_signed_and_returned_2
	, stips_signed_and_returned_3
	, FIRST_PARTY_SUIT_DATE
	, DateAAA_ResponceRecieved
	, dbo.tblProvider.Provider_Name + ISNULL(N' [Group: ' + dbo.tblProvider.Provider_GroupName + N' ]', N'') as ProviderName_long
	, ab.Provider_id
	, Memo
	, ISNULL(ab.InjuredParty_FirstName, N'') + N'  ' + ISNULL(ab.InjuredParty_LastName, N'')   as InjuredParty_Name
	, InjuredParty_FirstName 
	, InjuredParty_LastName 
	, ISNULL(ab.InsuredParty_FirstName, N'') + N'  ' + ISNULL(ab.InsuredParty_LastName, N'') as InsuredParty_Name
	, InsuranceCompany_Name
	, Status
	, Case_Code
	, Initial_Status
	, Ins_Claim_Number
	, StatusDisposition 
	, Policy_Number
	, IndexOrAAA_Number
	, Court_Name
	, ISNULL(dbo.tblAdjusters.Adjuster_FirstName, N'') + N'  ' + ISNULL(dbo.tblAdjusters.Adjuster_LastName, N'') AS Adjuster_Name
	, Adjuster_Phone
	, Adjuster_Extension
	, Adjuster_Fax
	, Adjuster_Email
	, Defendant_Name      
    , Defendant_Phone
	, Defendant_Fax
	, Defendant_Email
	, Attorney_FileNumber
	, forum
	--, tblSettlements.Settlement_Date
	,Settlement_Date= case when convert(varchar, ISNULL(tblSettlements.Settlement_Date,''),101) ='01/01/1900' then NULL
    else tblSettlements.Settlement_Date end 
	, Settled_by
	, User_Id
	, Arbitrator_Name  
	, af.Name as AttorneyFirmName 
	, CONVERT(money, ISNULL(ab.Claim_Amount, 0)) - CONVERT(float, ISNULL(ab.Paid_Amount, 0)) AS Balance_Amount
	, Accident_Date
	, old_Status
	, batchcode
	, AAA_Decisions
	, ISNULL(Location_Address,'') AS Location_Address
	, ab.location_id
	, Location_City
	, Location_State
	, Location_Zip
	, Assigned_Attorney.Assigned_Attorney
	, ab.DenialReasons_Type 
	, Rebuttal_Status
	, Injured_Caption
	, Provider_Caption 
	, ISNULL(ab.WriteOff,0) AS WriteOff
	, ab.Paid_Amount
	, (select ISNULL(sum(tblTransactions.Transactions_Amount),0) from tblTransactions with(nolock) where tblTransactions.DomainId=ab.DomainId and tblTransactions.Case_Id=ab.Case_Id and tblTransactions.Transactions_Type in ('C','I')) AS Collection_Payment      
    , Assigned_Attorney_Address
	, Assigned_Attorney_Phone
	, Assigned_Attorney_Fax
	, Assigned_Attorney_Email
	, tblSettlements.Settlement_Date
	, ab.Claim_Amount
	, @i_case_age [case_age]
	, DATEDIFF(dd,Date_Status_Changed,GETDATE()) AS Status_Change_Age
	, CONVERT(NVARCHAR,@Min_DOS_Start,101) [DOS_Start]
	, CONVERT(NVARCHAR,@Max_DOS_End,101) [DOS_End]
	
	, (SELECT COALESCE(CAST(DenialReason AS VARCHAR(MAX))+' , ','') FROM   tbl_Case_Denial (NOLOCK)      
	 INNER JOIN  MST_DenialReasons  (NOLOCK)       
	 ON    MST_DenialReasons .PK_Denial_ID=tbl_Case_Denial .FK_Denial_ID       
	 WHERE   tbl_Case_Denial.DomainId= ab.DomainId and Case_Id = ab.Case_Id FOR XML PATH('')) AS DenialReasons_Type1
	, our_discovery_demands AS Our_Discovery_Demands
	, ISNULL( (SELECT SUM(Transactions_Amount) FROM tblTransactions  (NOLOCK) WHERE case_id = ab.Case_ID and DomainId = ab.DomainId and Transactions_Type IN('LF','NLC','CF')),0) TotalLitigationAmount
	, CONVERT(NVARCHAR,@dt_SETtlement,101)[Settlement_Date]
	, cast(isnull((SELECT TOP 1 isnull(Settlement_Amount,0) FROM tblSettlements (NOLOCK) WHERE case_id = ab.Case_ID and DomainId = ab.DomainId) ,0) as decimal(10,2) )[Settlement_Amount]
	, (select isnull(convert(varchar(20),max(Event_Date),101),'')  from  tblevent t  (nolock)    
	 join tblEventStatus t2 (nolock)  on t.EventStatusId=t2.EventStatusId      
	 where t.case_id = ab.Case_ID       
		   --and t2.EventStatusName like'%Hearing%'       
	 and t.DomainId= ab.DomainID)  AS HearingDate
	 , (SELECT COALESCE(CAST(DenialReasons_Type AS VARCHAR(MAX))+' | ','')         
		 FROM   tblDenialReasons (NOLOCK)       
		 WHERE   tblDenialReasons.DomainId=ab.DomainID and tblDenialReasons.DenialReasons_Id in(SELECT items FROM dbo.SplitStringInt(MainDenialReasonsId,',')) FOR XML PATH('')) AS  [Maindenialreason_type]
	 , CASE WHEN ISNULL(ab.Date_BillSent,'') <> '' THEN CAST(DATEDIFF(DAY,ab.Date_BillSent,GETDATE()) AS varchar(10)) 
		ELSE '' END [POMStatusAge]
 FROM        
    dbo.tblcase   AS ab  (NOLOCK)      
 LEFT OUTER JOIN  dbo.tblStatus WITH (NOLOCK) ON ab.Status = dbo.tblStatus.Status_Abr  and ab.DomainId=tblStatus.DomainId      
 INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON ab.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id       
 INNER JOIN dbo.tblProvider WITH (NOLOCK) ON ab.Provider_Id = dbo.tblProvider.Provider_Id      
 LEFT OUTER JOIN  dbo.tblDefendant WITH (NOLOCK) ON ab.Defendant_Id = dbo.tblDefendant.Defendant_id    
 LEFT OUTER JOIN  dbo.tblAdjusters WITH (NOLOCK) ON ab.Adjuster_Id = dbo.tblAdjusters.Adjuster_Id      
 LEFT OUTER JOIN  dbo.tblCourt WITH (NOLOCK) ON ab.Court_Id = dbo.tblCourt.Court_Id       
 LEFT OUTER JOIN  dbo.TblArbitrator WITH (NOLOCK) ON ab.Arbitrator_ID = dbo.TblArbitrator.ARBITRATOR_ID    
 LEFT OUTER JOIN  dbo.tblSettlements WITH (NOLOCK) ON ab.Case_Id = dbo.tblSettlements.Case_Id    
 LEFT OUTER JOIN dbo.tblServed WITH (NOLOCK) ON ab.Served_To = dbo.tblServed.ID 
 LEFT OUTER JOIN  dbo.MST_Service_Rendered_Location   AS mst WITH (NOLOCK) ON ab.location_id = mst.Location_Id       
 LEFT OUTER JOIN  tbl_portfolio PF WITH (NOLOCK) ON ab.PortfolioId=pf.id    
 LEFT OUTER JOIN  tbl_attorneyFirm AF WITH (NOLOCK) ON ab.AttorneyFirmId=af.id      
 LEFT OUTER JOIN  dbo.Assigned_Attorney (NOLOCK) ON ab.Assigned_Attorney = dbo.Assigned_Attorney.PK_Assigned_Attorney_ID      
 LEFT OUTER JOIN  dbo.tblCase_Date_Details (NOLOCK) ON ab.DomainId = tblCase_Date_Details.DomainId AND ab.Case_Id = dbo.tblCase_Date_Details.Case_Id 
 WHERE ab.DomainId = @DomainId and ab.Case_Id = @strCaseId   
 AND ISNULL(ab.IsDeleted,0) = 0      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it off  
END      
      
      
      
      
      