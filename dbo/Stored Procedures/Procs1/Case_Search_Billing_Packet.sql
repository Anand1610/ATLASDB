-- changes for LSS-500 done on 27 APRIL 2020  By Tushar Chandgude 
CREATE PROCEDURE [dbo].[Case_Search_Billing_Packet] -- [Case_Search_Billing_Packet] 'glf'
	(
	@DomainID VARCHAR(50)
	,@s_a_ProviderNameGroupSel VARCHAR(MAX) = ''
	,@s_a_InsuranceGroupSel VARCHAR(MAX) = ''
	,@s_a_CurrentStatusGroupSel VARCHAR(MAX) = ''
	,@s_a_MultipleCase_ID VARCHAR(MAX) = ''
	,@s_a_Case_ID VARCHAR(50) = ''
	,@s_a_OldCaseId VARCHAR(50) = ''
	,@s_a_InjuredName VARCHAR(100) = ''
	,@s_a_InsuredName VARCHAR(100) = ''
	,@s_a_PolicyNo VARCHAR(100) = ''
	,@s_a_ClaimNo VARCHAR(100) = ''
	,@s_a_Type VARCHAR(5) = '2'
	,@s_a_ProviderGroup VARCHAR(100) = ''
	,@s_a_InitialStatus VARCHAR(100) = ''
	,@i_a_FromStatusAge INT = 0
	,@i_a_ToStatusAge INT = 0
	,@s_a_PortfolioId INT = 0
	,@i_a_POMStatusAgeFrom INT = 0
	,@i_a_POMStatusAgeTo INT = 0
	)WITH RECOMPILE
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	IF (@s_a_Type = '2')
	BEGIN
		SELECT abpi.Case_Id [CaseID]
			,SUM(tre.DeductibleAmount) [Deductible_Amount]
		INTO #TEMP
		FROM dbo.Auto_Billing_Packet_Info abpi(NOLOCK)
		JOIN dbo.tblTreatment tre(NOLOCK) ON tre.Case_Id = abpi.Case_Id
		WHERE abpi.DomainId = @DomainID
		GROUP BY abpi.Case_Id

		--print '1'
		SELECT Auto_Billing_Packet_Info.Case_Id
			,Auto_Billing_Packet_Info.Case_AutoId
			,Auto_Billing_Packet_Info.Case_Code
			,Packeted_Case_ID
			,LTRIM(RTRIM(Auto_Billing_Packet_Info.InjuredParty_LastName)) + ', ' + LTRIM(RTRIM(Auto_Billing_Packet_Info.InjuredParty_FirstName)) AS InjuredParty_Name
			,Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]', '') AS Provider_Name
			,InsuranceCompany_Name
			,convert(DECIMAL(38, 2), Auto_Billing_Packet_Info.Claim_Amount) AS Claim_Amount
			,convert(DECIMAL(38, 2), Auto_Billing_Packet_Info.Claim_Balance) AS Claim_Balance
			,convert(DECIMAL(38, 2), Auto_Billing_Packet_Info.Paid_Amount) AS Paid_Amount
			,convert(DECIMAL(38, 2), Auto_Billing_Packet_Info.Fee_Schedule) AS Fee_Schedule
			,convert(DECIMAL(38, 2), Auto_Billing_Packet_Info.FS_Balance) AS FS_Balance
			,Auto_Billing_Packet_Info.STATUS
			,Auto_Billing_Packet_Info.Initial_Status
			,Auto_Billing_Packet_Info.Accident_Date
			,Auto_Billing_Packet_Info.Ins_Claim_Number
			,Auto_Billing_Packet_Info.Provider_GroupName
			,Auto_Billing_Packet_Info.Status_Age
			,Auto_Billing_Packet_Info.DateOfService_Start
			,Auto_Billing_Packet_Info.DateOfService_End
			,Auto_Billing_Packet_Info.Date_BillSent AS Date_BillSent
			,Auto_Billing_Packet_Info.DenialReasons_Type AS DenialReasons
			,ServiceType
			,packet_type
			,convert(DECIMAL(38, 2), t.Deductible_Amount) AS Deductible_Amount
			,CASE 
				WHEN ISNULL(cas.Date_BillSent, '1900-01-01 00:00:00.000') <> '1900-01-01 00:00:00.000'
					THEN CONVERT(VARCHAR, DATEDIFF(DD, cas.Date_BillSent, GETDATE()))
				ELSE ''
				END AS [POM_Status_Age]
		FROM dbo.Auto_Billing_Packet_Info(NOLOCK)
		LEFT JOIN #TEMP t ON t.CaseID = dbo.Auto_Billing_Packet_Info.Case_Id
		LEFT JOIN tblcase cas WITH(NOLOCK) ON dbo.Auto_Billing_Packet_Info.Case_Id = cas.Case_Id
			AND t.CaseID = cas.Case_Id
		WHERE Auto_Billing_Packet_Info.DomainId = @DomainID
			AND (
				@s_a_ProviderNameGroupSel = ''
				OR Auto_Billing_Packet_Info.Provider_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel, ',')
					)
				)
			AND (
				@s_a_InsuranceGroupSel = ''
				OR Auto_Billing_Packet_Info.InsuranceCompany_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel, ',')
					)
				)
			AND (
				     Auto_Billing_Packet_Info.CASE_ID LIKE 'ACT%'
				  ---Start of  changes for LSS-500 done on 27 APRIL 2020  By Tushar Chandgude 
				  --OR Auto_Billing_Packet_Info.Initial_Status = 'PRE-ARB'
				  --OR Auto_Billing_Packet_Info.DomainID = 'BT'
				  OR (Auto_Billing_Packet_Info.Initial_Status = 'PRE-ARB' and cas.status not in   ('BILLING SENT','BILLING VR ANSWERED'))
				  OR (Auto_Billing_Packet_Info.Initial_Status in ('ARB','PRE-ARB')   
                  AND @DomainId='BT' AND cas.Status in ('BILLING SENT','BILLING VR ANSWERED') AND 
				  CONVERT(INT, CONVERT(VARCHAR, DATEDIFF(dd, cas.date_status_Changed, GETDATE())))>=90)  
				  OR (Auto_Billing_Packet_Info.DomainID = 'BT'  and cas.status not in   ('BILLING SENT','BILLING VR ANSWERED'))
				  ---End   of  changes for LSS-500 done on 27 APRIL 2020  By Tushar Chandgude  
				) --and status <> 'IN ARB OR LIT'
			AND (
				@s_a_CurrentStatusGroupSel = ''
				OR Auto_Billing_Packet_Info.STATUS IN (
					SELECT s
					FROM dbo.SplitString(@s_a_CurrentStatusGroupSel, ',')
					)
				)
			AND (
				@s_a_MultipleCase_ID = ''
				OR Auto_Billing_Packet_Info.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ',')
					)
				OR Auto_Billing_Packet_Info.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ' ')
					)
				)
			AND (
				@s_a_Case_ID = ''
				OR Auto_Billing_Packet_Info.Case_Id LIKE '%' + @s_a_Case_ID + '%'
				)
			AND (
				@s_a_OldCaseId = ''
				OR Auto_Billing_Packet_Info.Case_Code LIKE '%' + @s_a_OldCaseId + '%'
				)
			AND (
				@s_a_InjuredName = ''
				OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName, '') + ' ' + ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName, '') + ' ' + ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName, '') LIKE '%' + @s_a_InjuredName + '%'
				)
			AND (
				@s_a_InsuredName = ''
				OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName, '') + ' ' + ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName, '') + ' ' + ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName, '') LIKE '%' + @s_a_InsuredName + '%'
				)
			AND (
				@s_a_PolicyNo = ''
				OR Auto_Billing_Packet_Info.Policy_Number LIKE '%' + @s_a_PolicyNo + '%'
				)
			AND (
				@s_a_ClaimNo = ''
				OR Auto_Billing_Packet_Info.Ins_Claim_Number LIKE '%' + @s_a_ClaimNo + '%'
				)
			AND (
				@s_a_ProviderGroup = ''
				OR Provider_GroupName = @s_a_ProviderGroup
				)
			AND (
				@s_a_InitialStatus = ''
				OR Auto_Billing_Packet_Info.Initial_Status = @s_a_InitialStatus
				)
			AND (
				(
					@i_a_FromStatusAge = 0
					AND @i_a_ToStatusAge = 0
					)
				OR Status_Age BETWEEN @i_a_FromStatusAge
					AND @i_a_ToStatusAge
				)
			AND (
				@s_a_PortfolioId = 0
				OR cas.portfolioid = @s_a_PortfolioId
				)
				AND (
				@i_a_POMStatusAgeFrom = 0
				OR DATEDIFF(DAY, cas.Date_BillSent, GETDATE()) >= @i_a_POMStatusAgeFrom
				)
			AND (
				@i_a_POMStatusAgeTo = 0
				OR DATEDIFF(DAY, cas.Date_BillSent, GETDATE()) <= @i_a_POMStatusAgeTo
				)

	END
	ELSE
	BEGIN

	DECLARE @caseData Table
			(
			[Case_Id] varchar(50) index IDX_CLUST Clustered,
		    [Accident_Date] datetime NULL,
			[Case_AutoId] int,
			[Case_Code] varchar(100) NULL,
			[Claim_Amount] float NULL,
			[Date_BillSent] varchar(50),
			[Date_Opened] datetime NULL,
			[Date_Status_Changed] datetime NULL,
			[DenialReasons_Type] varchar(2000) NULL,
			[DomainId] varchar(50) NULL,
			[Fee_Schedule] float NULL,
			[Initial_Status] varchar(50) NULL,
			[InjuredParty_FirstName] varchar(100) NULL,
			[InjuredParty_LastName] varchar(100) NULL,
			[Ins_Claim_Number] varchar(100) NULL,
			[InsuranceCompany_Id] int NULL,
			[InsuredParty_FirstName] varchar(100) NULL,
			[InsuredParty_LastName] varchar(100) NULL,
			[Paid_Amount] float NULL,
			[Policy_Number] varchar(40) NULL,
			[PortfolioId] int NULL,
			[Provider_Id] int NULL,
			[Status] varchar(50) NULL,
			[WriteOff] float NULL,
			[IsDeleted] bit NULL,
			[InsuranceCompany_Name] varchar(250) NULL,
			[Provider_Name] varchar(200),
		    [Provider_GroupName] varchar(100),
			[packet_type] varchar(100)
			)

			INSERT INTO @caseData
			(   
			    Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				Date_BillSent,
				Date_Opened,
				Date_Status_Changed,
				DenialReasons_Type,
				DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				Ins_Claim_Number,
				InsuranceCompany_Id,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				Policy_Number,
				PortfolioId,
				Provider_Id,
				Status,
				WriteOff,
				IsDeleted,
				InsuranceCompany_Name,
				Provider_Name,
				Provider_GroupName,
				packet_type
			)

			SELECT 
				Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				Date_BillSent,
				Date_Opened,
				date_status_Changed,
				DenialReasons_Type,
				cas.DomainId,
				Fee_Schedule,
				Initial_Status,
				InjuredParty_FirstName,
				InjuredParty_LastName,
				Ins_Claim_Number,
				ins.InsuranceCompany_Id,
				InsuredParty_FirstName,
				InsuredParty_LastName,
				Paid_Amount,
				Policy_Number,
				PortfolioId,
				cas.Provider_Id,
				Status,
				WriteOff,
				IsDeleted,
				ins.InsuranceCompany_Name,
				Provider_Name,
				Provider_GroupName,
				packet_type
			from tblcase cas with(nolock) 
			INNER JOIN dbo.tblprovider pro(NOLOCK) ON cas.provider_id = pro.provider_id
			INNER JOIN dbo.tblinsurancecompany ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			where cas.domainid=@DomainID 
			AND ISNULL(cas.IsDeleted, 0) = 0
			AND (
				@s_a_ProviderNameGroupSel = ''
				OR cas.Provider_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel, ',')
					)
				)
			AND (
				@s_a_InsuranceGroupSel = ''
				OR cas.InsuranceCompany_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel, ',')
					)
				)
			AND (
				cas.Case_Id LIKE 'ACT%'
				OR Initial_Status = 'PRE-ARB'  
				---Start of  changes for LSS-490 done on 9 APRIL 2020  By Tushar Chandgude 
				oR (Initial_Status = 'ARB' AND @DomainId='BT' AND Status='ARB PREP - STANDBY')
				 ---End   of  changes for LSS-490 done on 9 APRIL 2020  By Tushar Chandgude 
				) --and status <> 'IN ARB OR LIT'
			AND (
				@s_a_CurrentStatusGroupSel = ''
				OR cas.STATUS IN (
					SELECT s
					FROM dbo.SplitString(@s_a_CurrentStatusGroupSel, ',')
					)
				)
			AND (
				@s_a_MultipleCase_ID = ''
				OR cas.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ',')
					)
				OR cas.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ' ')
					)
				)
			AND (
				@s_a_Case_ID = ''
				OR cas.Case_Id LIKE '%' + @s_a_Case_ID + '%'
				)
			AND (
				@s_a_OldCaseId = ''
				OR cas.Case_Code LIKE '%' + @s_a_OldCaseId + '%'
				)
			AND (
				@s_a_InjuredName = ''
				OR ISNULL(cas.InjuredParty_FirstName, '') + ' ' + ISNULL(cas.InjuredParty_LastName, '') LIKE '%'
				+ @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_LastName, '') + ' ' + ISNULL(cas.InjuredParty_FirstName, '') LIKE '%' 
				+ @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_LastName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_FirstName, '') LIKE '%' + @s_a_InjuredName + '%'
				)
			AND (
				@s_a_InsuredName = ''
				OR ISNULL(cas.InsuredParty_FirstName, '') + ' ' + ISNULL(cas.InsuredParty_LastName, '') LIKE '%' 
				+ @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_LastName, '') + ' ' + ISNULL(cas.InsuredParty_FirstName, '') LIKE '%' 
				+ @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_LastName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_FirstName, '') LIKE '%' + @s_a_InsuredName + '%'
				)
			AND (
				@s_a_PolicyNo = ''
				OR cas.Policy_Number LIKE '%' + @s_a_PolicyNo + '%'
				)
			AND (
				@s_a_ClaimNo = ''
				OR cas.Ins_Claim_Number LIKE '%' + @s_a_ClaimNo + '%'
				)
			
			AND (
				@s_a_InitialStatus = ''
				OR cas.Initial_Status = @s_a_InitialStatus
				)
			AND (
				(
					@i_a_FromStatusAge = 0
					AND @i_a_ToStatusAge = 0
					)
				OR CONVERT(INT, CONVERT(VARCHAR, DATEDIFF(dd, cas.date_status_Changed, GETDATE()))) BETWEEN @i_a_FromStatusAge
					AND @i_a_ToStatusAge
				)
			AND (
				@s_a_PortfolioId = 0
				OR cas.portfolioid = @s_a_PortfolioId
				)
				AND (
				@s_a_ProviderGroup = ''
				OR pro.Provider_GroupName = @s_a_ProviderGroup
				)


				AND (@i_a_POMStatusAgeFrom = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) >= @i_a_POMStatusAgeFrom)
				AND (@i_a_POMStatusAgeTo = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) <= @i_a_POMStatusAgeTo) 

		    DECLARE @treatmentTbl Table
			(
			[Case_Id] varchar(50) index IDX_CLUSTtbl Clustered,
			[Date_BillSent] datetime NULL,
			[DateOfService_End] datetime NULL,
			[DateOfService_Start] datetime NULL,
			[DeductibleAmount] numeric(9,2)
			)

			INSERT INTO @treatmentTbl
			(
			    Case_Id,
				Date_BillSent,
				DateOfService_End,
				DateOfService_Start,
				DeductibleAmount
				)
			    SELECT  tr.Case_Id,
				CONVERT(varchar(10), tr.DateOfService_Start, 101) AS DateOfService_Start, 
				CONVERT(varchar(12), tr.DateOfService_End, 1) AS DateOfService_End,
				CONVERT(varchar(10), tr.Date_BillSent, 101) AS Date_BillSent,
				DeductibleAmount 
				from  Tbltreatment tr with(nolock) 
				INNER JOIN  @caseData cas ON tr.case_id=cas.case_id 
				where tr.domainid=@domainid  

				DECLARE @BillingPacket TABLE
				(
				[Case_ID] varchar(50)  INDEX IDX_CaseIdPCK_TV CLUSTERED,
                [Packeted_Case_ID] varchar(50) NULL)


				INSERT INTO @BillingPacket(Case_ID,Packeted_Case_ID)
				select Case_ID, Packeted_Case_ID from dbo.Billing_Packet with(nolock) where domainid=@domainid



		SELECT DISTINCT cas.Case_Id
			,cas.Case_AutoId
			,cas.Case_Code AS Case_Code
			,pck.Packeted_Case_ID AS Packeted_Case_ID
			,LTRIM(RTRIM(cas.InjuredParty_LastName)) + ', ' + LTRIM(RTRIM(cas.InjuredParty_FirstName)) AS InjuredParty_Name
			,cas.Provider_Name + ISNULL(' [ ' + cas.Provider_Groupname + ' ]', '') AS Provider_Name
			,cas.InsuranceCompany_Name
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, cas.Claim_Amount)))) AS Claim_Amount
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, cas.Claim_Amount) - convert(FLOAT, cas.Paid_Amount) - ISNULL(cas.WriteOff, 0)))) - SUM(ISNULL(tre.DeductibleAmount, 0.00)) AS Claim_Balance
			,convert(DECIMAL(38, 2), cas.Paid_Amount) AS Paid_Amount
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, cas.Fee_Schedule)))) AS Fee_Schedule
			,convert(DECIMAL(38, 2), (convert(MONEY, convert(FLOAT, cas.Fee_Schedule) - convert(FLOAT, cas.Paid_Amount) - ISNULL(cas.WriteOff, 0)))) AS FS_Balance
			,cas.STATUS
			,cas.Initial_Status
			,cas.Accident_Date
			,cas.Ins_Claim_Number
			,cas.Provider_GroupName
			,CONVERT(INT, CONVERT(VARCHAR, DATEDIFF(dd, cas.date_status_Changed, GETDATE()))) AS Status_Age
			,CONVERT(VARCHAR(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start
			,CONVERT(VARCHAR(12), min(tre.DateOfService_End), 1) AS DateOfService_End
			,CONVERT(VARCHAR(10), min(tre.Date_BillSent), 101) AS Date_BillSent
			,cas.DenialReasons_Type AS DenialReasons
			,STUFF((
					SELECT DISTINCT ',' + Service_Type
					FROM tbltreatment
					WHERE case_id = cas.Case_Id
					--ORDER BY Service_Type
					FOR XML PATH('')
					), 1, 1, '') AS ServiceType
			,cas.packet_type
			,SUM(ISNULL(tre.DeductibleAmount, 0.00)) AS Deductible_Amount,
			CASE 
				WHEN ISNULL(cas.Date_BillSent, '1900-01-01 00:00:00.000') <> '1900-01-01 00:00:00.000'
					THEN CONVERT(VARCHAR, DATEDIFF(DD, cas.Date_BillSent, GETDATE()))
				ELSE ''
				END AS [POM_Status_Age]
		FROM @CaseData cas 
		--INNER JOIN dbo.tblprovider pro(NOLOCK) ON cas.provider_id = pro.provider_id
		--INNER JOIN dbo.tblinsurancecompany ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
		LEFT OUTER JOIN @treatmentTbl tre  ON tre.Case_Id = cas.Case_Id
		LEFT OUTER JOIN @BillingPacket pck  ON cas.case_id = pck.Case_ID
		WHERE cas.DomainId = @DomainID
			AND ISNULL(cas.IsDeleted, 0) = 0
			AND (
				@s_a_ProviderNameGroupSel = ''
				OR cas.Provider_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel, ',')
					)
				)
			AND (
				@s_a_InsuranceGroupSel = ''
				OR cas.InsuranceCompany_Id IN (
					SELECT items
					FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel, ',')
					)
				)
			AND (
				cas.Case_Id LIKE 'ACT%'

				OR Initial_Status = 'PRE-ARB' 
				---Start of  changes for LSS-490 done on 9 APRIL 2020  By Tushar Chandgude 
				
				oR (Initial_Status = 'ARB' AND @DomainId='BT' AND Status='ARB PREP - STANDBY')
				 ---End   of  changes for LSS-490 done on 9 APRIL 2020  By Tushar Chandgude  

				) --and status <> 'IN ARB OR LIT'
			AND (
				@s_a_CurrentStatusGroupSel = ''
				OR cas.STATUS IN (
					SELECT s
					FROM dbo.SplitString(@s_a_CurrentStatusGroupSel, ',')
					)
				)
			AND (
				@s_a_MultipleCase_ID = ''
				OR cas.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ',')
					)
				OR cas.Case_Id IN (
					SELECT s
					FROM dbo.SplitString(@s_a_MultipleCase_ID, ' ')
					)
				)
			AND (
				@s_a_Case_ID = ''
				OR cas.Case_Id LIKE '%' + @s_a_Case_ID + '%'
				)
			AND (
				@s_a_OldCaseId = ''
				OR cas.Case_Code LIKE '%' + @s_a_OldCaseId + '%'
				)
			AND (
				@s_a_InjuredName = ''
				OR ISNULL(cas.InjuredParty_FirstName, '') + ' ' + ISNULL(cas.InjuredParty_LastName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_LastName, '') + ' ' + ISNULL(cas.InjuredParty_FirstName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_LastName, '') LIKE '%' + @s_a_InjuredName + '%'
				OR ISNULL(cas.InjuredParty_FirstName, '') LIKE '%' + @s_a_InjuredName + '%'
				)
			AND (
				@s_a_InsuredName = ''
				OR ISNULL(cas.InsuredParty_FirstName, '') + ' ' + ISNULL(cas.InsuredParty_LastName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_LastName, '') + ' ' + ISNULL(cas.InsuredParty_FirstName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_LastName, '') LIKE '%' + @s_a_InsuredName + '%'
				OR ISNULL(cas.InsuredParty_FirstName, '') LIKE '%' + @s_a_InsuredName + '%'
				)
			AND (
				@s_a_PolicyNo = ''
				OR cas.Policy_Number LIKE '%' + @s_a_PolicyNo + '%'
				)
			AND (
				@s_a_ClaimNo = ''
				OR cas.Ins_Claim_Number LIKE '%' + @s_a_ClaimNo + '%'
				)
			AND (
				(
					@s_a_Type = '0'
					AND ISNULL(pck.case_id, '') = ''
					)
				OR (
					@s_a_Type = '1'
					AND ISNULL(pck.case_id, '') <> ''
					)
				)
			AND (
				@s_a_ProviderGroup = ''
				OR cas.Provider_GroupName = @s_a_ProviderGroup
				)
			AND (
				@s_a_InitialStatus = ''
				OR cas.Initial_Status = @s_a_InitialStatus
				)
			AND (
				(
					@i_a_FromStatusAge = 0
					AND @i_a_ToStatusAge = 0
					)
				OR CONVERT(INT, CONVERT(VARCHAR, DATEDIFF(dd, cas.date_status_Changed, GETDATE()))) BETWEEN @i_a_FromStatusAge
					AND @i_a_ToStatusAge
				)
			AND (
				@s_a_PortfolioId = 0
				OR cas.portfolioid = @s_a_PortfolioId
				)

					AND (
				@i_a_POMStatusAgeFrom = 0
				OR DATEDIFF(DAY, cas.Date_BillSent, GETDATE()) >= @i_a_POMStatusAgeFrom
				)
			AND (
				@i_a_POMStatusAgeTo = 0
				OR DATEDIFF(DAY, cas.Date_BillSent, GETDATE()) <= @i_a_POMStatusAgeTo
				)

		GROUP BY cas.Case_Id
			,cas.Case_AutoId
			,cas.Case_Code
			,pck.Packeted_Case_ID
			,cas.InjuredParty_FirstName
			,cas.InjuredParty_LastName
			,cas.Provider_Name
			,cas.InsuranceCompany_Name
			,cas.Claim_Amount
			,cas.Fee_Schedule
			,cas.STATUS
			,cas.Accident_Date
			,cas.Initial_Status
			,cas.Provider_GroupName
			,cas.Paid_Amount
			,cas.WriteOff
			,cas.Ins_Claim_Number
			,Cas.Date_Opened
			,Cas.Date_Status_Changed
			,cas.DenialReasons_Type
			,cas.packet_type
			,cas.Date_BillSent
		ORDER BY Provider_Name
			,InjuredParty_Name
			,DateOfService_Start
			
	END
	SET NOCOUNT OFF;
			--DBCC FREEPROCCACHE
			--DBCC DROPCLEANBUFFERS		
END
