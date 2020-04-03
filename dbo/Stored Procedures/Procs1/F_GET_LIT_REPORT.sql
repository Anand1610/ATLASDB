CREATE PROCEDURE [dbo].[F_GET_LIT_REPORT]    --F_GET_LIT_REPORT   'FH06-33689,FH06-33690'

(
	@Case_Id VARCHAR(max)
)
	
AS
Declare @Cases varchar(MAX)
set @Cases=REPLACE (''''+@Case_Id+'''',',',''',''')
declare @query varchar(MAX)
BEGIN

	SET NOCOUNT ON;
		SET @query='SELECT distinct C.case_id,case_code,injuredparty_name,Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as  provider_name,
		Provider_GroupName,InsuranceCompany_Name,
		InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip AS InsuranceCompany_Local_Address,
		Court_Name,
		(dateofservice_Start+''-''+dateofservice_End) AS [DOS_Range],
		convert(VARCHAR,DateNotice_TrialFiled,101) AS DateNotice_TrialFiled,
		convert(VARCHAR,DateFile_Trial_DeNovo,101) AS DateFile_Trial_DeNovo,
		 convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Balance,
		Status,
		Initial_Status,
		convert(VARCHAR,Date_Opened,101) AS Date_Opened,
		Opened_By,
		Ins_Claim_Number,
		convert(VARCHAR,Accident_Date,101) AS Accident_Date,
		IndexOrAAA_Number,
		Last_Status,
		CASE WHEN date_status_changed is null then  datediff(dd,Date_Opened,GETDATE())  ELSE datediff(dd,date_status_changed,GETDATE()) END AS [Status_Age],
		(Select top 1 a.Case_Id FROM  tblCase_TEMO as a WHERE a.DomainId=c.DomainId and a.Provider_Id =c.Provider_Id  and a.InjuredParty_LastName =c.InjuredParty_LastName
		and a.InjuredParty_FirstName = c.InjuredParty_FirstName and  a.Accident_Date =c.Accident_Date  
		 and a.Case_Id <> c.case_id) AS Similar_To_Case_ID,
		Assigned_Attorney,
		(SELECT SUM(Transactions_Amount) FROM tblTransactions  WHERE DomainId=c.DomainId and Case_Id=c.Case_Id AND Transactions_Type= ''FFB'') AS [Filing_fee_billed] ,
		convert(VARCHAR,Date_Summons_Printed,101) AS Date_Summons_Printed,
		convert(VARCHAR,Date_Summons_Sent_Court,101) AS Date_Summons_Sent_Court,
		convert(VARCHAR,Date_Index_Number_Purchased,101) AS Date_Index_Number_Purchased,
		convert(VARCHAR,Date_Afidavit_Filed,101) AS Date_Afidavit_Filed,
		convert(VARCHAR,Served_On_Date,101) AS Served_On_Date,
		convert(VARCHAR,Date_Ext_Of_Time,101) AS Date_Ext_Of_Time,
		Stips_Signed_and_Returned,
		convert(VARCHAR,Date_Ext_Of_Time_2,101) AS Date_Ext_Of_Time_2,
		stips_signed_and_returned_2,
		convert(VARCHAR,Date_Ext_Of_Time_3,101) AS Date_Ext_Of_Time_3,
		stips_signed_and_returned_3,
		convert(VARCHAR,Date_Answer_Received,101) AS Date_Answer_Received,
		Defendant_Name,
		Defendant_address +'' ''+Defendant_City+'' ''+Defendant_State+'' ''+Defendant_Zip AS Defendant_address
		FROM LCJ_VW_CaseSearchDetails  c 
		WHERE  C.Case_Id in ('+@Cases+') and C.DomainId = '+@Cases+''



   exec(@query)
   PRINT(@query)
END

