CREATE PROCEDURE [dbo].[F_CaseData_Retrive_By_CaseId]  --[F_CaseData_Retrive_By_CaseId] 'FH11-87652'
  
(
     @s_a_Case_Id nvarchar(100)='FH07-42372'
)  
  
AS    
BEGIN

declare @dt_settlement DATETIME
	declare @dt_paid_full DATETIME
	declare @dt_withdrawn DATETIME
	declare @dt_opened DATETIME
declare @i_case_age INT
declare @Min_DOS_Start DATETIME
    declare @Max_DOS_End DATETIME

set @Min_DOS_Start=(select min(DateOfService_Start)as DOS_Start from tbltreatment where Case_Id = @s_a_Case_Id)  
set @Max_DOS_End=(select max(DateOfService_End)as DOS_End from tbltreatment where Case_Id =  @s_a_Case_Id)  


	set @dt_settlement = (select top 1 settlement_date from tblsettlements where case_id = @s_a_Case_Id)
	set @dt_paid_full = (select top 1 NOTES_DATE from TBLNOTES where case_id = @s_a_Case_Id AND notes_desc like '%to paid-full%' ORDER BY NOTES_DATE DESC)
	set @dt_withdrawn = (select top 1 NOTES_DATE from TBLNOTES where case_id = @s_a_Case_Id AND notes_desc like '%to WITHDRAWN%' ORDER BY NOTES_DATE DESC)
	set @dt_opened = (select date_opened from tblcase where case_id = @s_a_Case_Id)
	
	if(@dt_settlement IS NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())
	END
	else IF(@dt_settlement IS NOT NULL AND @dt_paid_full IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_settlement)
	END
	ELSE IF(@dt_paid_full IS NOT NULL AND @dt_settlement IS NULL AND @dt_withdrawn IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_paid_full)
	END
	ELSE IF(@dt_withdrawn IS NOT NULL AND @dt_paid_full IS NULL AND @dt_settlement IS NULL)
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,@dt_withdrawn)
	END
	ELSE
	BEGIN
		SET @i_case_age = datediff(day,@dt_opened,getdate())	
	END
     select      
          ISNULL(cas.Case_Id,'N/A')Case_Id,
          cas.InjuredParty_FirstName,
          cas.InjuredParty_LastName,
          cas.InsuredParty_FirstName,
          cas.InsuredParty_LastName,  
          ISNULL(CONVERT(VARCHAR,cas.Accident_Date,101),'N/A')Accident_Date,
          ISNULL(cas.Status,'N/A')Status,
          ISNULL(cas.Initial_Status,'N/A')Initial_Status,
          cas.Case_AutoId as file_number,
          ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') AS InjuredParty_Name, 
          ISNULL(cas.InsuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InsuredParty_LastName, N'') AS InsuredParty_Name, 
          ISNULL(convert(nvarchar,cas.Ins_Claim_Number),'N/A')Ins_Claim_Number,
          ISNULL(convert(nvarchar,cas.Policy_Number),'N/A')Policy_Number,
          ISNULL(convert(nvarchar,cas.IndexOrAAA_Number),'N/A')IndexOrAAA_Number,       
          ISNULL(cas.Provider_Caption,'N/A')Provider_Caption,
          ISNULL(cas.Injured_Caption,'N/A')Injured_Caption,
          ISNULL(cas.Attorney_FileNumber,'N/A')Attorney_FileNumber,
          ISNULL(cas.AAA_Decisions,'N/A')AAA_Decisions,
          ISNULL(pro.Provider_Name,'N/A')Provider_Name,
          ISNULL(ins.InsuranceCompany_Name,'N/A')InsuranceCompany_Name,
          ISNULL(Court.Court_Name,'N/A')Court_Name,
          ISNULL(def.Defendant_Name,'N/A')Defendant_Name,
       
          ISNULL(@i_case_age,'N/A')[case_age],
          ISNULL(convert(nvarchar,@Min_DOS_Start,101),'N/A')[DOS_Start],
          ISNULL(convert(nvarchar,@Max_DOS_End,101),'N/A') [DOS_End],         
          ISNULL(convert(nvarchar,trmt.Claim_Amount),'N/A')Claim_Amount,
          ISNULL(convert(nvarchar,trmt.Fee_Schedule),'N/A')Fee_Schedule,
          ISNULL(trmt.Claim_Amount,0) - ISNULL(trmt.Paid_Amount,0) AS Claim_Balance,
          ISNULL(trmt.Fee_Schedule,0) - ISNULL(trmt.Paid_Amount,0) AS Fs_Balance,
          ISNULL(convert(nvarchar,trmt.Paid_Amount),'N/A')Paid_Amount,
          ISNULL(arb.ARBITRATOR_NAME,'N/A')ARBITRATOR_NAME,
          isnull (mst.Location_Address,'N/A') +' '+ isnull (mst.Location_City,'')+' '+isnull (mst.Location_State,'')+' '+isnull (mst.Location_Zip,'') as Location_Address,
          cas.location_id,cas.insurancecompany_id,cas.Provider_Id,cas.Court_Id,cas.Defendant_Id,cas.Arbitrator_ID,ISNULL(convert(nvarchar,cas.Accident_Date,101),'N/A') [Accident_Date],CS.id as Initial_StatusId,stat.Status_Id as CurrentStatusId
         
     from tblcase cas
     INNER JOIN tblProvider pro on cas.provider_id=pro.provider_id 
     INNER JOIN tblInsuranceCompany ins on cas.insurancecompany_id=ins.insurancecompany_id 
     LEFT OUTER JOIN dbo.tblCourt Court ON cas.Court_Id = Court.Court_Id and Court.Court_Name not like '%SELECT%'
     LEFT OUTER JOIN dbo.tblDefendant def ON cas.Defendant_Id = def.Defendant_id and def.Defendant_Name not like '%SELECT%'
     LEFT OUTER JOIN dbo.TblArbitrator arb ON cas.Arbitrator_ID = arb.ARBITRATOR_ID  and arb.ARBITRATOR_NAME not like '%SELECT%'
     LEFT OUTER JOIN dbo.MST_Service_Rendered_Location mst on cas.Location_Id = mst.Location_Id and Location_Address not like '%SELECT%'
     LEFT OUTER JOIN dbo.tblTreatment trmt on cas.Case_Id=trmt.Case_Id 
     inner join tblCaseStatus CS on cas.Initial_Status=CS.name
     inner join tblStatus stat on cas.Status=stat.Status_Type
     WHERE cas.Case_Id = @s_a_Case_Id
          
          
          
   
          --
          --INNER JOIN issuetracker_Users on tblcasedeskhistory.Login_User_Id=issuetracker_Users.UserId
          --INNER JOIN issuetracker_Users issue_To_User on tblcasedeskhistory.To_User_Id=issue_To_User.UserId
   
END

