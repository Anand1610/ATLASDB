CREATE VIEW [dbo].[VW_CaseDetails_For_Arb]
AS
	SELECT 
	dbo.tblcase.CASE_ID,dbo.tblcase.Status ,
	ISNULL(CONVERT(varchar(10), DBO.TBLCASE.Date_Opened, 101),'') AS DATE_OPENED, 
	ISNULL(CONVERT(varchar(10), DBO.TBLCASE.Accident_Date, 101),'') AS ACCIDENT_DATE, 
	CONVERT(float, isnull(dbo.tblcase.Claim_Amount,0)) - CONVERT(float, isnull(dbo.tblcase.Paid_Amount,0)) AS BALANCE_AMOUNT,
	ISNULL(DBO.TBLCASE.CLAIM_AMOUNT,0.00) AS CLAIM_AMOUNT,
	ISNULL(DBO.TBLCASE.PAID_AMOUNT,0.00) AS PAID_AMOUNT, 
	ISNULL(DBO.TBLCASE.POLICY_NUMBER,'') AS POLICY_NUMBER, 
	CONVERT(NVARCHAR(12),(SELECT min(dateofservice_start) from tbltreatment where case_id=tblcase.case_id and Claim_Amount > Paid_Amount), 101) AS DOS_START,
	CONVERT(NVARCHAR(12),(SELECT max(DateOfService_End) from tbltreatment where case_id=tblcase.case_id and Claim_Amount > Paid_Amount), 101) AS  DOS_END,
	ISNULL(DBO.TBLCASE.INS_CLAIM_NUMBER,'') AS INS_CLAIM_NUMBER, 
	[dbo].[funTreateamtTable](dbo.tblcase.CASE_ID) AS Treatment_Table,
	-----Patient Details-----
	UPPER(ISNULL(DBO.TBLCASE.INJUREDPARTY_FIRSTNAME, N'')) + N'  ' + UPPER(ISNULL(DBO.TBLCASE.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME, 
	Case when ISNULL(DBO.TBLCASE.INJUREDPARTY_ADDRESS,'')<> '' 
	Then UPPER(ISNULL(DBO.TBLCASE.INJUREDPARTY_ADDRESS,'') +', '+ISNULL(DBO.TBLCASE.INJUREDPARTY_CITY,'') +', '+ISNULL(DBO.TBLCASE.INJUREDPARTY_STATE,'')+', '+ISNULL(DBO.TBLCASE.INJUREDPARTY_ZIP,''))
	else 'N/A'  End as INJUREDPARTY_ADDRESS,
	----Insurer Details
	UPPER(ISNULL(DBO.TBLCASE.INSUREDPARTY_FIRSTNAME, N'')) + N'  ' + UPPER(ISNULL(DBO.TBLCASE.INSUREDPARTY_LASTNAME, N'')) AS INSUREDPARTY_NAME, 
	Case when ISNULL(DBO.TBLCASE.INSUREDPARTY_ADDRESS,'')<> '' 
	Then UPPER(ISNULL(DBO.TBLCASE.INSUREDPARTY_ADDRESS,'') +', '+ISNULL(DBO.TBLCASE.INSUREDPARTY_CITY,'') +', '+ISNULL(DBO.TBLCASE.INSUREDPARTY_STATE,'')+', '+ISNULL(DBO.TBLCASE.INSUREDPARTY_ZIP,''))
	else 'N/A'  End as INSUREDPARTY_ADDRESS,

	---Insurance Company Details
	UPPER(ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_NAME,'')) AS INSURANCECOMPANY_NAME,
	DBO.PROPERCASE(ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_LOCAL_ADDRESS,'')) AS FIRSTCAP_INSCOMPANY_LOCAL_ADDRESS,
	DBO.PROPERCASE(ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_LOCAL_CITY,'')) AS FIRSTCAP_INSCOMPANY_LOCAL_CITY,
	UPPER(ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_LOCAL_CITY,'')) AS INSURANCECOMPANY_LOCAL_CITY, 
	UPPER(ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_LOCAL_STATE,'')) AS INSURANCECOMPANY_LOCAL_STATE,
	ISNULL(DBO.TBLINSURANCECOMPANY.INSURANCECOMPANY_LOCAL_ZIP,'') AS INSURANCECOMPANY_LOCAL_ZIP,
	
	Case when ISNULL(DBO.tblcase.InsuranceCompany_Initial_Address,'')<> '' 
		Then UPPER(ISNULL(DBO.tblcase.InsuranceCompany_Initial_Address,''))
	else 'N/A'  End as INSURANCECOMPANY_INITIAL_ADDRESS,
	
	CASE WHEN ISNULL(dbo.tblcase.Representetive,'') ='' THEN 'UNKNOWN' ELSE  UPPER(Representetive) END AS REPRESENTATIVE_NAME,
	CASE WHEN ISNULL(dbo.tblcase.REPRESENTATIVE_CONTACT_NUMBER,'') ='' THEN 'N/A' ELSE  UPPER(REPRESENTATIVE_CONTACT_NUMBER) END AS REPRESENTATIVE_CONTACT_NUMBER,		
	
	---Provider Details
	UPPER(ISNULL(DBO.TBLPROVIDER.PROVIDER_LOCAL_ADDRESS,'')) AS PROVIDER_LOCAL_ADDRESS, 
	UPPER(ISNULL(DBO.TBLPROVIDER.PROVIDER_LOCAL_CITY,'')) AS PROVIDER_LOCAL_CITY, 
	UPPER(ISNULL(DBO.TBLPROVIDER.PROVIDER_LOCAL_STATE,'')) AS PROVIDER_LOCAL_STATE,
	ISNULL(DBO.TBLPROVIDER.PROVIDER_LOCAL_ZIP,'') AS PROVIDER_LOCAL_ZIP, 
	UPPER(ISNULL(DBO.TBLPROVIDER.PROVIDER_SUITNAME,'')) AS PROVIDER_SUITNAME, 
	DBO.TBLPROVIDER.Provider_GroupName,
	
	DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(), 107), 9) AS TODAY_DATE,
	convert (varchar(10),GETDATE (),110) AS TODAYDATE,
	Convert(varchar(10),DENIAL_DATE,101) as  DENIAL_DATE, 
	CASE When DENIAL_DATE IS Null Then '  ' WHEN DATEDIFF(DD,DENIAL_DATE,GETDATE()) <= 90 Then 'X' Else '  ' END AS  DENIALBEFORE90DAY,
	CASE When DENIAL_DATE IS Null Then 'X' WHEN DATEDIFF(DD,DENIAL_DATE,GETDATE()) > 90 Then 'X' Else '  ' END AS  DENIALAFTER90DAY,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(13) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS VOT_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(13) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS VOT_NOT_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(11) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS AOB_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(11) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS AOB_NOT_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS DENIAL_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS  DENIAL_NOT_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
				Then (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(45) and DeleteFlag=0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
					THEN (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(465) and DeleteFlag>0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 THEN 'X' ELSE '  ' END) 
					ELSE 'X' END) Else '  ' END AS VR_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
				Then (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(45) and DeleteFlag=0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
					THEN (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(465) and DeleteFlag>0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 THEN '  ' ELSE 'X' END) 
					ELSE '  ' END) Else 'X' END AS VR_NOT_ATTACHED,
	
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(29) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS MR_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(29) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS MR_NOT_ATTACHED,
	

	
	---- You Need Poof of mailing --------
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(12) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS POF_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(12) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS POF_NOT_ATTACHED


	--- You did not need PROOF of mailing if denial exist
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
			Then (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(12) and DeleteFlag=0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 
					THEN 'X' Else '  ' End) Else '  ' END AS POF_ATTACHED,
	CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(14) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
			Then (CASE WHEN 
					(SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(12) and DeleteFlag=0 
					and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') = 0 
					THEN 'X' Else '  ' End) Else 'X' END AS POF_NOT_ATTACHED
	
	
	
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(423,4) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS CHECK_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(423,4) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS CHECK_NOT_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(23) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS EOB_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(23) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS  EOB_NOT_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(27) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS  PAR_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(27) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS PAR_NOT_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(32) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then 'X' Else '  ' END AS PEER_REVIEW_ATTACHED,
	--CASE WHEN (SELECT COUNT(*) FROM tblImages WHERE Case_Id=tblcase.Case_ID and DocumentId IN(32) and DeleteFlag=0 and filename not like '%.pdf' and filename not like '%Select%'and filename <> '') > 0 Then '  ' Else 'X' END AS PEER_REVIEW_NOT_ATTACHED
FROM dbo.tblcase 
INNER JOIN dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
INNER JOIN dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id 
--WHERE status in('AAA OPEN','AAA PENDING- RESOLVED')
