CREATE PROCEDURE [dbo].[Case_Search_Billing_Packet_OPTV1] -- [Case_Search_Billing_Packet] 'glf'
(
	 @DomainID VARCHAR(50),
	 @s_a_ProviderNameGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_InsuranceGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_CurrentStatusGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_MultipleCase_ID VARCHAR(MAX)	=	'',
	 @s_a_Case_ID	VARCHAR(50)	=	'',
	 @s_a_OldCaseId	VARCHAR(50)	=	'',
	 @s_a_InjuredName	VARCHAR(100)	=	'',
	 @s_a_InsuredName	VARCHAR(100)	=	'',
	 @s_a_PolicyNo	VARCHAR(100)	=	'',
	 @s_a_ClaimNo	VARCHAR(100)	=	'',
	 @s_a_Type VARCHAR(5)		=	'2'	,
	 @s_a_ProviderGroup VARCHAR(100)	=	'',
	 @s_a_InitialStatus VARCHAR(100)	=	'',
	 @i_a_FromStatusAge int = 0,
	 @i_a_ToStatusAge int = 0,
	 @s_a_PortfolioId INT	=	0,
	 @i_a_POMStatusAgeFrom INT = 0,
	 @i_a_POMStatusAgeTo INT = 0
) with recompile
AS
BEGIN	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		
	if(@s_a_Type='2')
	BEGIN

	        DECLARE @TEMP TABLE
			(
			CaseID varchar(50),
			Deductible_Amount numeric(9,2)
			)

		INSERT INTO @TEMP(CaseID,Deductible_Amount)
			SELECT	abpi.Case_Id [CaseID],
					SUM(tre.DeductibleAmount) [Deductible_Amount]
			
			FROM	dbo.Auto_Billing_Packet_Info abpi (NOLOCK)
			JOIN	dbo.tblTreatment tre (NOLOCK) on tre.Case_Id= abpi.Case_Id	
			WHERE	abpi.DomainId = @DomainID
			GROUP	BY	abpi.Case_Id
			--print '1'
			SELECT Auto_Billing_Packet_Info.Case_Id,
					Auto_Billing_Packet_Info.Case_AutoId,
					Auto_Billing_Packet_Info.Case_Code,
					Packeted_Case_ID,
					LTRIM(RTRIM(Auto_Billing_Packet_Info.InjuredParty_LastName)) + ', ' + LTRIM(RTRIM(Auto_Billing_Packet_Info.InjuredParty_FirstName)) as InjuredParty_Name,  
					Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as Provider_Name,  
					InsuranceCompany_Name,
					convert(decimal(38,2),Auto_Billing_Packet_Info.Claim_Amount) AS Claim_Amount,
					convert(decimal(38,2),Auto_Billing_Packet_Info.Claim_Balance) AS Claim_Balance ,
					convert(decimal(38,2),Auto_Billing_Packet_Info.Paid_Amount) AS Paid_Amount ,
					convert(decimal(38,2),Auto_Billing_Packet_Info.Fee_Schedule) AS Fee_Schedule ,
					convert(decimal(38,2),Auto_Billing_Packet_Info.FS_Balance) AS FS_Balance ,
					Auto_Billing_Packet_Info.Status,
					Auto_Billing_Packet_Info.Initial_Status,
					Auto_Billing_Packet_Info.Accident_Date,
					Auto_Billing_Packet_Info.Ins_Claim_Number, 
					Auto_Billing_Packet_Info.Provider_GroupName,
					Auto_Billing_Packet_Info.Status_Age,
					Auto_Billing_Packet_Info.DateOfService_Start, 
					Auto_Billing_Packet_Info.DateOfService_End,
					Auto_Billing_Packet_Info.Date_BillSent AS Date_BillSent,
					Auto_Billing_Packet_Info.DenialReasons_Type as  DenialReasons,
					ServiceType,
					packet_type,
					convert(decimal(38,2),t.Deductible_Amount) AS Deductible_Amount,
					CASE WHEN ISNULL(cas.Date_BillSent,'1900-01-01 00:00:00.000') <> '1900-01-01 00:00:00.000' THEN CONVERT(VARCHAR,DATEDIFF(DD,cas.Date_BillSent,GETDATE()))
						ELSE ''
					END AS [POM_Status_Age]
			FROM	dbo.Auto_Billing_Packet_Info (NOLOCK)
			LEFT	JOIN @TEMP t ON t.CaseID = dbo.Auto_Billing_Packet_Info.Case_Id
			LEFT JOIN tblcase cas ON dbo.Auto_Billing_Packet_Info.Case_Id= cas.Case_Id and  t.CaseID =cas.Case_Id
			WHERE
				Auto_Billing_Packet_Info.DomainId = @DomainID
				AND (@s_a_ProviderNameGroupSel  ='' OR Auto_Billing_Packet_Info.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
				AND (@s_a_InsuranceGroupSel  ='' OR Auto_Billing_Packet_Info.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
				AND (Auto_Billing_Packet_Info.CASE_ID LIKE 'ACT%' OR Auto_Billing_Packet_Info.Initial_Status ='PRE-ARB' OR Auto_Billing_Packet_Info.DomainID ='BT')--and status <> 'IN ARB OR LIT'
				AND (@s_a_CurrentStatusGroupSel ='' OR Auto_Billing_Packet_Info.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
				AND (@s_a_MultipleCase_ID ='' OR Auto_Billing_Packet_Info.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  Auto_Billing_Packet_Info.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
				AND (@s_a_Case_ID ='' OR Auto_Billing_Packet_Info.Case_Id like '%'+ @s_a_Case_ID + '%')
				AND (@s_a_OldCaseId ='' OR Auto_Billing_Packet_Info.Case_Code like '%'+ @s_a_OldCaseId + '%')
				AND (@s_a_InjuredName ='' OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName,'')+' ' +ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName,'') +' ' + ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(Auto_Billing_Packet_Info.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
				AND (@s_a_InsuredName ='' OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName,'')+' ' +ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName,'') +' ' + ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(Auto_Billing_Packet_Info.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
				AND (@s_a_PolicyNo ='' OR Auto_Billing_Packet_Info.Policy_Number like '%'+ @s_a_PolicyNo + '%')
				AND (@s_a_ClaimNo ='' OR Auto_Billing_Packet_Info.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
				AND (@s_a_ProviderGroup  ='' OR Provider_GroupName=@s_a_ProviderGroup )
				AND (@s_a_InitialStatus  ='' OR Auto_Billing_Packet_Info.Initial_Status=@s_a_InitialStatus )
				AND ((@i_a_FromStatusAge = 0 and @i_a_ToStatusAge = 0) OR Status_Age Between @i_a_FromStatusAge and @i_a_ToStatusAge)
	            AND (@s_a_PortfolioId = 0 OR cas.portfolioid=@s_a_PortfolioId)
				AND (@i_a_POMStatusAgeFrom = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) >= @i_a_POMStatusAgeFrom)
				AND (@i_a_POMStatusAgeTo = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) <= @i_a_POMStatusAgeTo)

			
	END
	ELSE
	BEGIN
			
			DECLARE @caseData Table
			(
			[Case_Id] varchar(50)  ,
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
			[Ins_Claim_Number] nvarchar(100) NULL,
			[InsuranceCompany_Id] int NULL,
			[InsuredParty_FirstName] varchar(100) NULL,
			[InsuredParty_LastName] varchar(100) NULL,
			[Paid_Amount] float NULL,
			[Policy_Number] varchar(40) NULL,
			[PortfolioId] int NULL,
			[Provider_Id] int NULL,
			[Status] varchar(50) NULL,
			[WriteOff] float NULL,
			[IsDeleted] bit NULL
			
			

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
				IsDeleted
			)

			SELECT 
				Accident_Date,
				Case_AutoId,
				Case_Code,
				Case_Id,
				Claim_Amount,
				CASE WHEN ISNULL(Date_BillSent,'1900-01-01 00:00:00.000') <> '1900-01-01 00:00:00.000' 
				THEN CONVERT(VARCHAR,DATEDIFF(DD,Date_BillSent,GETDATE()))
						ELSE '' end,
				Date_Opened,
				CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd, date_status_Changed,GETDATE()))) as Status_Age,
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
				IsDeleted
			from tblcase with(nolock) where domainid=@DomainID 
			 
				AND ISNULL(IsDeleted,0) = 0
				AND (@s_a_ProviderNameGroupSel  ='' OR  Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
				AND (@s_a_InsuranceGroupSel  ='' OR InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
				AND (Case_Id LIKE 'ACT%' OR Initial_Status ='PRE-ARB')  --and status <> 'IN ARB OR LIT'
				AND (@s_a_CurrentStatusGroupSel ='' OR Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
				AND (@s_a_MultipleCase_ID ='' OR Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  Case_Id 
				IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
				AND (@s_a_Case_ID ='' OR Case_Id like '%'+ @s_a_Case_ID + '%')
				AND (@s_a_OldCaseId ='' OR Case_Code like '%'+ @s_a_OldCaseId + '%')
				AND (@s_a_InjuredName ='' OR ISNULL(InjuredParty_FirstName,'')+' ' +ISNULL(InjuredParty_LastName,'') 
				like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(InjuredParty_LastName,'') +' ' + ISNULL(InjuredParty_FirstName,'') 
				like '%'+ @s_a_InjuredName + '%'  OR ISNULL(InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  
				OR ISNULL(InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
				AND (@s_a_InsuredName ='' OR ISNULL(InsuredParty_FirstName,'')+' ' +ISNULL(InsuredParty_LastName,'') like '%'+ 
				@s_a_InsuredName + '%'  OR  ISNULL(InsuredParty_LastName,'') +' ' + ISNULL(InsuredParty_FirstName,'') like '%'+ 
				@s_a_InsuredName + '%'  OR ISNULL(InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR 
				ISNULL(InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
				AND (@s_a_PolicyNo ='' OR Policy_Number like '%'+ @s_a_PolicyNo + '%')
				AND (@s_a_ClaimNo ='' OR Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
				
			
				AND (@s_a_InitialStatus  ='' OR Initial_Status=@s_a_InitialStatus)
				AND ((@i_a_FromStatusAge = 0 and @i_a_ToStatusAge = 0) OR 
				CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,date_status_Changed,GETDATE()))) Between @i_a_FromStatusAge and @i_a_ToStatusAge)
			    AND (@s_a_PortfolioId = 0 OR portfolioid=@s_a_PortfolioId)
				AND (@i_a_POMStatusAgeFrom = 0 OR DATEDIFF(DAY,Date_BillSent,GETDATE()) >= @i_a_POMStatusAgeFrom)
				AND (@i_a_POMStatusAgeTo = 0 OR DATEDIFF(DAY,Date_BillSent,GETDATE()) <= @i_a_POMStatusAgeTo)
				print '5'
		   IF EXISTS(Select Case_id from @caseData)
		   BEGIN
			DECLARE @treatmentTbl Table
			(
			[Case_Id] varchar(50) ,
			[Date_BillSent] datetime NULL,
			[DateOfService_End] datetime NULL,
			[DateOfService_Start] datetime NULL,
			[DeductibleAmount] numeric(9,2)
		--	UNIQUE(Case_Id,Date_BillSent,DateOfService_End,DateOfService_Start,DeductibleAmount)
			)

			INSERT INTO @treatmentTbl
			(
			    Case_Id,
				Date_BillSent,
				DateOfService_End,
				DateOfService_Start
				--DeductibleAmount
				)
			    SELECT  tr.Case_Id,
				CONVERT(varchar(10), min(tr.DateOfService_Start), 101) AS DateOfService_Start, 
				CONVERT(varchar(12), min(tr.DateOfService_End), 1) AS DateOfService_End,
				CONVERT(varchar(10), min(tr.Date_BillSent), 101) AS Date_BillSent
				--DeductibleAmount 
				from  Tbltreatment tr with(nolock) 
				INNER JOIN  @caseData cas ON tr.case_id=cas.case_id 
				where tr.domainid=@domainid group by tr.case_id
				

				DECLARE @Provider table
				(
				[Provider_Id] int  INDEX IDX_ProviderID_TV CLUSTERED,
				[Provider_GroupName] nvarchar(100) NULL,
				[packet_type] varchar(100) NULL,
				[Provider_Name] nvarchar(200) NULL


				)


		INSERT INTO @Provider(  packet_type,
								Provider_GroupName,
								Provider_Id,
								Provider_Name)
	        	SELECT packet_type,
				Provider_GroupName,
				Provider_Id,
				Provider_Name FROM tblprovider with(nolock) where domainid=@domainid


				DECLARE @BillingPacket TABLE
				(
				[Case_ID] varchar(50)  INDEX IDX_CaseIdPCK_TV CLUSTERED,
                [Packeted_Case_ID] varchar(50) NULL)


				INSERT INTO @BillingPacket(Case_ID,Packeted_Case_ID)
				select Case_ID, Packeted_Case_ID from dbo.Billing_Packet with(nolock) where domainid=@domainid
				
				declare @TreatmentDedAmt table
				(
				--SUM(ISNULL(tre.DeductibleAmount,0.00)) AS Deductible_Amount,
				case_id varchar(50),
				Deductible_Amount numeric(9,2)
				)
				INSERT INTO @TreatmentDedAmt(case_id, Deductible_Amount)
				Select tr.case_id, SUM(ISNULL(DeductibleAmount,0.00))  from tbltreatment tr with(nolock) 
				INNER JOIN  @caseData cas ON tr.case_id=cas.case_id group by tr.case_id

				declare @TreatmentServiceType table
				(
				--SUM(ISNULL(tre.DeductibleAmount,0.00)) AS Deductible_Amount,
				case_id varchar(50),
				ServiceType varchar(200)
				)

				INSERT INTO @TreatmentServiceType(case_id, ServiceType)
				SELECT tr.case_id,
				STUFF( (SELECT distinct  ',' + Service_Type 
                             FROM  tbltreatment  where case_id= tr.case_id
                             --ORDER BY Service_Type
                             FOR XML PATH('')), 
                            1, 1, '') as ServiceType
							from tbltreatment tr INNER JOIN @caseData cas ON tr.case_id=cas.case_id


			SELECT  DISTINCT 
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code AS Case_Code,
				pck.Packeted_Case_ID as Packeted_Case_ID,
				LTRIM(RTRIM(cas.InjuredParty_LastName)) + ', ' + LTRIM(RTRIM(cas.InjuredParty_FirstName)) as InjuredParty_Name,  
				Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
				ins.InsuranceCompany_Name,  
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount) - 
				ISNULL(cas.WriteOff,0)))) - Deductible_Amount   as Claim_Balance,
				convert(decimal(38,2),cas.Paid_Amount) AS Paid_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as Fee_Schedule,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount) - 
				ISNULL(cas.WriteOff,0)))) as FS_Balance,
				cas.Status,  
				cas.Initial_Status,
				cas.Accident_Date,		
				cas.Ins_Claim_Number, 
				pro.Provider_GroupName,
				cas.date_status_Changed as Status_Age,
				tre.DateOfService_Start AS DateOfService_Start, 
				tre.DateOfService_End AS DateOfService_End,
				tre.Date_BillSent AS Date_BillSent, 
				cas.DenialReasons_Type as  DenialReasons,
				ts.ServiceType,
				pro.packet_type,
				Deductible_Amount,
			    cas.Date_BillSent
					AS [POM_Status_Age]
			FROM @caseData cas  
				INNER JOIN @Provider pro   on cas.provider_id=pro.provider_id 
				INNER JOIN dbo.tblinsurancecompany ins (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
				LEFT OUTER JOIN @treatmentTbl tre   on tre.Case_Id= cas.Case_Id
				LEFT OUTER JOIN @BillingPacket pck   on cas.case_id = pck.Case_ID
				LEFT OUTER JOIN @TreatmentDedAmt tramt on cas.case_id=tramt.case_id
				LEFT OUTER JOIN @TreatmentServiceType ts on cas.case_id=ts.case_id
			WHERE
				cas.DomainId = @DomainID
				AND ISNULL(cas.IsDeleted,0) = 0
				AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
				AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
				AND (cas.Case_Id LIKE 'ACT%' OR Initial_Status ='PRE-ARB')  --and status <> 'IN ARB OR LIT'
				AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
				AND (@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  cas.Case_Id 
				IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
				AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
				AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
				AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+' ' +ISNULL(cas.InjuredParty_LastName,'') 
				like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') +' ' + ISNULL(cas.InjuredParty_FirstName,'') 
				like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  
				OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
				AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+' ' +ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') +' ' + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
				AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
				AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
				AND ((@s_a_Type='0' and ISNULL(pck.case_id,'') ='') OR(@s_a_Type='1' and ISNULL(pck.case_id,'') <> ''))
				AND (@s_a_ProviderGroup  ='' OR pro.Provider_GroupName=@s_a_ProviderGroup )
				AND (@s_a_InitialStatus  ='' OR cas.Initial_Status=@s_a_InitialStatus)
				AND ((@i_a_FromStatusAge = 0 and @i_a_ToStatusAge = 0) OR CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) Between @i_a_FromStatusAge and @i_a_ToStatusAge)
			    AND (@s_a_PortfolioId = 0 OR cas.portfolioid=@s_a_PortfolioId)
				AND (@i_a_POMStatusAgeFrom = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) >= @i_a_POMStatusAgeFrom)
				AND (@i_a_POMStatusAgeTo = 0 OR DATEDIFF(DAY,cas.Date_BillSent,GETDATE()) <= @i_a_POMStatusAgeTo)
			--Group by 	
			--	cas.Case_Id,
			--	cas.Case_AutoId,
			--	cas.Case_Code,
			--	pck.Packeted_Case_ID,
			--	cas.InjuredParty_FirstName,
			--	cas.InjuredParty_LastName,
			--	pro.Provider_Name,
			--	ins.InsuranceCompany_Name,
			--	cas.Claim_Amount,
			--	cas.Fee_Schedule,
			--	cas.Status,
			--	cas.Accident_Date,		
			--	cas.Initial_Status,
			--	pro.Provider_GroupName,
			--	cas.Paid_Amount,
			--	cas.WriteOff,
			--	cas.Ins_Claim_Number,
			--	Cas.Date_Opened,
			--	Cas.Date_Status_Changed,
			--	cas.DenialReasons_Type,
			--	pro.packet_type,
			--	cas.Date_BillSent,
			--	tramt.Deductible_Amount
			--ORDER BY Provider_Name, InjuredParty_Name, 	DateOfService_Start
	END
	END
	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
END


