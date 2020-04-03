CREATE PROCEDURE [dbo].[GET_ARBITRATION_REPORT1]
 --[GET_ARBITRATION_REPORT] 'dl','1','qwqw','www,eee,rr','sd,sds,sds','xcxc','dfdf','03/03/2012','07/07/2012','AAA'
 -- [GET_ARBITRATION_REPORT1] 'dl','1','','','','','','','',''
(
	@DomainId nvarchar(50),
	@type varchar(10),
	@s_a_MultipleCase_ID varchar(Max),
    @s_a_ProviderNameGroupSel	VARCHAR(MAX)=''	,
	@s_a_InsuranceGroupSel	VARCHAR(MAX)=''	,
    @s_a_ProviderGroup	VARCHAR(500)=''	,
	@s_a_InsuranceGroup	VARCHAR(500)=''	,
	@s_a_CurrentStatusGroupSel	VARCHAR(MAX)=''	,
	@s_a_date_opened_FROM	VARCHAR(20)=''	,
	@s_a_date_Opened_To	VARCHAR(20)=''
)
AS
BEGIN

--print @Ins_Co

	IF(@type ='0')
	BEGIN
		select TOP 1000
		CASE WHEN Convert(varchar(50),DENIAL_DATE,101)='01/01/1900' THEN '' ELSE Convert(varchar(50),DENIAL_DATE,101) END as  DENIAL_DATE,
		
		cas.CASE_ID,
		cas.CASE_ID AS CASES,
		Convert(varchar(10),ACCIDENT_DATE,101) as ACCIDENT_DATE,
		CONVERT(money, ISNULL(cas.Claim_Amount, 0)) - CONVERT(float, ISNULL(cas.Paid_Amount, 0)) AS Balance_Amount,
		CLAIM_AMOUNT,
		PAID_AMOUNT,
		STATUS,
		
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DateOfService_Start), 101) AS DOS_Start, 
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DateOfService_End), 101) AS DOS_End,
		ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') AS InjuredParty_Name,
		INJUREDPARTY_ADDRESS,
		INJUREDPARTY_CITY,
		INJUREDPARTY_STATE,
		INJUREDPARTY_ZIP,
		INS_CLAIM_NUMBER,
		INSURANCECOMPANY_LOCAL_CITY,
		INSURANCECOMPANY_LOCAL_STATE,
		INSURANCECOMPANY_LOCAL_ZIP,
		INSURANCECOMPANY_NAME,
		INSUREDPARTY_ADDRESS,
		INSUREDPARTY_CITY,
		ISNULL(cas.InsuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InsuredParty_LastName, N'') AS InsuredParty_Name,
		INSUREDPARTY_LASTNAME,
		INSUREDPARTY_FIRSTNAME,
		INSUREDPARTY_STATE,
		INSUREDPARTY_ZIP,
		POLICY_NUMBER,
		PROVIDER_LOCAL_ADDRESS,
		PROVIDER_LOCAL_CITY,
		PROVIDER_LOCAL_STATE,
		PROVIDER_LOCAL_ZIP,
		PROVIDER_SUITNAME,
		--TODAY_DATE,
		--TODAYDATE,
		--FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,
		--FIRSTCAP_INSCOMPANY_LOCAL_CITY,
		cas.InsuranceCompany_Initial_Address,
		cas.Representetive,
		cas. Representative_Contact_Number		
		FROM dbo.tblCase cas
			INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id  
			INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
		WHERE cas.DomainId = @DomainId and cas.Case_Id in (select case_id from tblArbitrationCases)
		      and ISNULL(cas.IsDeleted, 0) = 0
	END
	Else
	BEGIN
		select TOP 1000
		CASE WHEN Convert(varchar(50),DENIAL_DATE,101)='01/01/1900' THEN '' ELSE Convert(varchar(50),DENIAL_DATE,101) END as  DENIAL_DATE,
		cas.CASE_ID,
		cas.CASE_ID AS CASES,
		Convert(varchar(10),ACCIDENT_DATE,101) as ACCIDENT_DATE,
		CONVERT(money, ISNULL(cas.Claim_Amount, 0)) - CONVERT(float, ISNULL(cas.Paid_Amount, 0)) AS Balance_Amount,
		CLAIM_AMOUNT,
		PAID_AMOUNT,
		STATUS,
		
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DateOfService_Start), 101) AS DOS_Start, 
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DateOfService_End), 101) AS DOS_End,
		ISNULL(cas.InjuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InjuredParty_LastName, N'') AS InjuredParty_Name,
		INJUREDPARTY_ADDRESS,
		INJUREDPARTY_CITY,
		INJUREDPARTY_STATE,
		INJUREDPARTY_ZIP,
		INS_CLAIM_NUMBER,
		INSURANCECOMPANY_LOCAL_CITY,
		INSURANCECOMPANY_LOCAL_STATE,
		INSURANCECOMPANY_LOCAL_ZIP,
		INSURANCECOMPANY_NAME,
		INSUREDPARTY_ADDRESS,
		INSUREDPARTY_CITY,
		ISNULL(cas.InsuredParty_FirstName, N'') + N'  ' + ISNULL(cas.InsuredParty_LastName, N'') AS InsuredParty_Name,
		INSUREDPARTY_LASTNAME,
		INSUREDPARTY_FIRSTNAME,
		INSUREDPARTY_STATE,
		INSUREDPARTY_ZIP,
		POLICY_NUMBER,
		PROVIDER_LOCAL_ADDRESS,
		PROVIDER_LOCAL_CITY,
		PROVIDER_LOCAL_STATE,
		PROVIDER_LOCAL_ZIP,
		PROVIDER_SUITNAME,
		--TODAY_DATE,
		--TODAYDATE,
		--FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,
		--FIRSTCAP_INSCOMPANY_LOCAL_CITY,
		cas.InsuranceCompany_Initial_Address,
		cas.Representetive,
		cas. Representative_Contact_Number		
		FROM dbo.tblCase cas
			INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id  
			INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
		WHERE cas.DomainId = @DomainId and cas.Case_Id Not in (select case_id from tblArbitrationCases)  and ISNULL(cas.IsDeleted, 0) = 0
			AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
			AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
			AND (@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
			AND (@s_a_ProviderGroup ='' OR pro.Provider_GroupName like @s_a_ProviderGroup)	
			AND (@s_a_InsuranceGroup ='' OR ins.InsuranceCompany_GroupName like @s_a_InsuranceGroup)
			AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT items FROM dbo.STRING_SPLIT(@s_a_CurrentStatusGroupSel,',')))
			AND (@s_a_date_opened_FROM='' OR (Date_Opened Between CONVERT(datetime,@s_a_date_opened_FROM) And CONVERT(datetime,@s_a_date_Opened_To)))
	END
END
