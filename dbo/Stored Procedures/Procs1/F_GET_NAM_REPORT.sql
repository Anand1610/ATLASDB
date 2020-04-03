CREATE PROCEDURE [dbo].[F_GET_NAM_REPORT]    --F_GET_NAM_REPORT   'FH14-169241'

(
	@DomainId nvarchar(50),
	@Case_Id VARCHAR(max)
)
	
AS
Declare @Cases varchar(MAX)
set @Cases=REPLACE (''''+@Case_Id+'''',',',''',''')
declare @query varchar(MAX)
BEGIN

	SET NOCOUNT ON;
		SET @query='SELECT distinct C.case_id,case_code,injuredparty_name,Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as  provider_name,
		Provider_GroupName,
		 Provider_Local_Address + '' '' +Provider_Local_City+'' ''+Provider_Local_State +'' ''+Provider_Local_Zip AS Provider_Local_Address,
		InsuranceCompany_Name,
		InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip AS InsuranceCompany_Local_Address,
		InsuredParty_FirstName + '' ''+InsuredParty_LastName AS Insured_Party,
		Court_Name,
		(dateofservice_Start+''-''+dateofservice_End) AS [DOS_Range],
		IndexOrAAA_Number,
		Status,
		Initial_Status,
		Paid_Amount,
		 convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Balance,
		convert(VARCHAR,Date_Opened,101) AS Date_Opened,
		Opened_By,
		Policy_Number,
		Ins_Claim_Number,
		convert(VARCHAR,Accident_Date,101) AS Accident_Date,
		Last_Status,
		CASE WHEN date_status_changed is null then  datediff(dd,Date_Opened,GETDATE())  ELSE datediff(dd,date_status_changed,GETDATE()) END AS [Status_Age],
		(Select top 1 a.Case_Id FROM  tblCase  a WHERE a.DomainId =c.DomainId and a.Provider_Id =c.Provider_Id  and a.InjuredParty_LastName =c.InjuredParty_LastName
		and a.InjuredParty_FirstName = c.InjuredParty_FirstName and  a.Accident_Date =c.Accident_Date  
		 and a.Case_Id <> c.case_id) AS Similar_To_Case_ID,
		 convert(varchar,Date_NAM_Package_Printed,101) as Date_NAM_Package_Printed,
		 convert(varchar,Date_NAM_ARB_Filed,101) as Date_NAM_ARB_Filed,
		 convert(varchar,Date_NAM_Confirmed,101) as Date_NAM_Confirmed,
		 convert(varchar,Date_NAM_Response_Received,101) as Date_NAM_Response_Received,
		 convert(varchar,Date_of_NAM_Awards,101) as Date_of_NAM_Awards,	
		Defendant_Name,
		Defendant_address +'' ''+Defendant_City+'' ''+Defendant_State+'' ''+Defendant_Zip AS Defendant_address
		FROM LCJ_VW_CaseSearchDetails  c 
		WHERE 1=1 and  C.Case_Id in ('+@Cases+') and C.DomainId = '+@Cases+'' 


   exec(@query)
   PRINT(@query)
END

