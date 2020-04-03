CREATE PROCEDURE [dbo].[GET_ARBITRATION_REPORT] --[GET_ARBITRATION_REPORT] '1'
(
	@DomainId nvarchar(50),
	@type varchar(10)
)
AS
BEGIN
	IF(@type ='0')
	BEGIN
		select Convert(varchar(10),ACCIDENT_DATE,101) as ACCIDENT_DATE,
		CASE WHEN Convert(varchar(50),DENIAL_DATE,101)='01/01/1900' THEN '' ELSE Convert(varchar(50),DENIAL_DATE,101) END as  DENIAL_DATE,
		CONVERT(money, ISNULL(LVC.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(LVC.Paid_Amount, 0)) as  BALANCE_AMOUNT,
		LVC.CASE_ID,
		LVC.CASE_ID AS CASES,
		CLAIM_AMOUNT,
		CONVERT(NVARCHAR(12), CONVERT(DATETIME,     
                      LVC.DateOfService_End), 101) AS DOS_END,
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, LVC.DateOfService_Start), 101) AS DOS_START,
		ISNULL(LVC.InjuredParty_FirstName, N'') + N'  ' + ISNULL(LVC.InjuredParty_LastName, N'')   as INJUREDPARTY_NAME,
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
		ISNULL(LVC.InsuredParty_FirstName, N'') + N'  ' + ISNULL(LVC.InsuredParty_LastName, N'') as INSUREDPARTY_NAME,
		INSUREDPARTY_LASTNAME,
		INSUREDPARTY_FIRSTNAME,
		INSUREDPARTY_STATE,
		INSUREDPARTY_ZIP,
		PAID_AMOUNT,
		POLICY_NUMBER,
		PROVIDER_LOCAL_ADDRESS,
		PROVIDER_LOCAL_CITY,
		PROVIDER_LOCAL_STATE,
		PROVIDER_LOCAL_ZIP,
		PROVIDER_SUITNAME,
		DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(),     
                      107), 9) as TODAY_DATE,
		UPPER(DATENAME(mm, GETDATE())) + ' ' + DATENAME(dd, GETDATE()) + ', ' + DATENAME(yy, GETDATE()) AS TODAYDATE,
		dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_Address, '')) as FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,
		dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_City, '')) as FIRSTCAP_INSCOMPANY_LOCAL_CITY,
		LVC.InsuranceCompany_Initial_Address,
		Representetive,
		Representative_Contact_Number
		--(SELECT count(*)FROM tblImages WHERE DeleteFlag=0 and Case_Id=LVC.Case_Id) AS Images
		from tblcase LVC with(nolock)  
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON LVC.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
	    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON LVC.Provider_Id = dbo.tblProvider.Provider_Id 
		WHERE status in('AAA OPEN','AAA PENDING- RESOLVED','GBB ARB','GBB AWAITING REQUEST RETURNS') and Case_Id in (select case_id from tblArbitrationCases)
		and LVC.DomainId=@DomainId and ISNULL(LVC.IsDeleted,0) = 0
		--and (SELECT count(*)FROM tblImages WHERE DeleteFlag=0 and Case_Id=LVC.Case_Id) >0
	END
	Else
	BEGIN
		select Convert(varchar(10),ACCIDENT_DATE,101) as ACCIDENT_DATE,
		CASE WHEN Convert(varchar(50),DENIAL_DATE,101)='01/01/1900' THEN '' ELSE Convert(varchar(50),DENIAL_DATE,101) END as  DENIAL_DATE,
		CONVERT(money, ISNULL(LVC.Claim_Amount, 0))     
                      - CONVERT(float, ISNULL(LVC.Paid_Amount, 0)) as BALANCE_AMOUNT,
		LVC.CASE_ID,
		LVC.CASE_ID AS CASES,
		CLAIM_AMOUNT,
		CONVERT(NVARCHAR(12), CONVERT(DATETIME,     
                      LVC.DateOfService_End), 101) AS DOS_END,
		CONVERT(NVARCHAR(12), CONVERT(DATETIME, LVC.DateOfService_Start), 101) AS DOS_START,
		ISNULL(LVC.InjuredParty_FirstName, N'') + N'  ' + ISNULL(LVC.InjuredParty_LastName, N'')   as INJUREDPARTY_NAME,
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
		ISNULL(LVC.InsuredParty_FirstName, N'') + N'  ' + ISNULL(LVC.InsuredParty_LastName, N'') as INSUREDPARTY_NAME,
		INSUREDPARTY_LASTNAME,
		INSUREDPARTY_FIRSTNAME,
		INSUREDPARTY_STATE,
		INSUREDPARTY_ZIP,
		PAID_AMOUNT,
		POLICY_NUMBER,
		PROVIDER_LOCAL_ADDRESS,
		PROVIDER_LOCAL_CITY,
		PROVIDER_LOCAL_STATE,
		PROVIDER_LOCAL_ZIP,
		PROVIDER_SUITNAME,
		DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(),     
                      107), 9) as TODAY_DATE,
		UPPER(DATENAME(mm, GETDATE())) + ' ' + DATENAME(dd, GETDATE()) + ', ' + DATENAME(yy, GETDATE()) AS TODAYDATE,
		dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_Address, '')) as FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,
		dbo.ProperCase(ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_City, '')) as FIRSTCAP_INSCOMPANY_LOCAL_CITY,
		LVC.InsuranceCompany_Initial_Address,
		Representetive,
		Representative_Contact_Number
		--(SELECT count(*)FROM tblImages WHERE DeleteFlag=0 and Case_Id=LVC.Case_Id) AS Images
		from tblcase LVC with(nolock) 
		INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON LVC.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
	    INNER JOIN dbo.tblProvider WITH (NOLOCK) ON LVC.Provider_Id = dbo.tblProvider.Provider_Id 
		WHERE status in('AAA OPEN','AAA PENDING- RESOLVED','GBB ARB','GBB AWAITING REQUEST RETURNS') and Case_Id Not in (select case_id from tblArbitrationCases)
		AND LVC.DomainId=@DomainId and ISNULL(LVC.IsDeleted,0) = 0
		--and (SELECT count(*)FROM tblImages WHERE DeleteFlag=0 and Case_Id=LVC.Case_Id) >0
	END
END

