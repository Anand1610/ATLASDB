CREATE PROCEDURE [dbo].[Case_Search_GLF_Packet] -- [Case_Search_GLF_Packet] 'localhost'
(
	 @DomainID VARCHAR(50),
	 @s_a_ProviderNameGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_InsuranceGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_CurrentStatusGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_MultipleCase_ID VARCHAR(MAX)	=	'',
	 @s_a_Case_ID	VARCHAR(100)	=	'',
	 @s_a_OldCaseId	VARCHAR(100)	=	'',
	 @s_a_InjuredName	VARCHAR(100)	=	'',
	 @s_a_InsuredName	VARCHAR(100)	=	'',
	 @s_a_PolicyNo	VARCHAR(100)	=	'',
	 @s_a_ClaimNo	VARCHAR(100)	=	'',
	 @s_a_Type VARCHAR(5)		=	'2'	,
	 @s_a_ProviderGroup VARCHAR(100)	=	'',
	 @s_a_InitialStatus VARCHAR(100)	=	'',
	 @i_a_FromStatusAge int = 0,
	 @i_a_ToStatusAge int = 0
)
AS
BEGIN	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
	if(@s_a_Type='2')
	BEGIN
			print '1'
			SELECT Case_Id,
					Case_AutoId,
					Case_Code,
					PacketID,
					InjuredParty_LastName + ', ' + InjuredParty_FirstName as InjuredParty_Name,  
					Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as Provider_Name,  
					InsuranceCompany_Name,
					convert(decimal(38,2),Claim_Amount) AS Claim_Amount,
					convert(decimal(38,2),Claim_Balance) AS Claim_Balance ,
					convert(decimal(38,2),Paid_Amount) AS Paid_Amount ,
					convert(decimal(38,2),Fee_Schedule) AS Fee_Schedule ,
					convert(decimal(38,2),FS_Balance) AS FS_Balance ,
					Status,
					Initial_Status,
					Accident_Date,
					Ins_Claim_Number, 
					Provider_GroupName,
					Status_Age,
					DateOfService_Start, 
					DateOfService_End,
					Date_BillSent AS Date_BillSent,
					DenialReasons_Type as  DenialReasons,
					ServiceType,
					packet_type

			FROM dbo.Auto_Packet_Info 
			WHERE
				DomainId = @DomainID
				AND (@s_a_ProviderNameGroupSel  ='' OR Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
				AND (@s_a_InsuranceGroupSel  ='' OR InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
				AND  CASE_ID NOT LIKE 'ACT%' --and status <> 'IN ARB OR LIT'
				AND (@s_a_CurrentStatusGroupSel ='' OR Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
				AND (@s_a_MultipleCase_ID ='' OR Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
				AND (@s_a_Case_ID ='' OR Case_Id like '%'+ @s_a_Case_ID + '%')
				AND (@s_a_OldCaseId ='' OR Case_Code like '%'+ @s_a_OldCaseId + '%')
				AND (@s_a_InjuredName ='' OR ISNULL(InjuredParty_FirstName,'')+' ' +ISNULL(InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(InjuredParty_LastName,'') +' ' + ISNULL(InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
				AND (@s_a_InsuredName ='' OR ISNULL(InsuredParty_FirstName,'')+' ' +ISNULL(InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(InsuredParty_LastName,'') +' ' + ISNULL(InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
				AND (@s_a_PolicyNo ='' OR Policy_Number like '%'+ @s_a_PolicyNo + '%')
				AND (@s_a_ClaimNo ='' OR Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
				AND (@s_a_ProviderGroup  ='' OR Provider_GroupName=@s_a_ProviderGroup )
				AND (@s_a_InitialStatus  ='' OR Initial_Status=@s_a_InitialStatus )
				AND ((@i_a_FromStatusAge = 0 and @i_a_ToStatusAge = 0) OR Status_Age Between @i_a_FromStatusAge and @i_a_ToStatusAge)
			--Group by 	
			--	Case_Id,
			--	Case_AutoId,
			--	Case_Code,
			--	Packeted_Case_ID,
			--	InjuredParty_FirstName,
			--	InjuredParty_LastName,
			--	Provider_Name,
			--	InsuranceCompany_Name,
			--	Claim_Amount,
			--	Status,
			--	Accident_Date,		
			--	Initial_Status,
			--	Provider_GroupName,
			--	Paid_Amount,
			--	Ins_Claim_Number,
			--	Date_Opened,
			--	Date_Status_Changed,
			--	DenialReasons_Type
			--ORDER BY Provider_Name, InjuredParty_Name,	DateOfService_Start


	END
	ELSE
	BEGIN
			SELECT distinct
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code AS Case_Code,
				pkt.PacketID as PacketID,
				cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
				Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
				ins.InsuranceCompany_Name,  
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)- convert(float,ISNULL(cas.WriteOff,0))))) as Claim_Balance,
				convert(decimal(38,2),cas.Paid_Amount) AS Paid_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as Fee_Schedule,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)- convert(float,ISNULL(cas.WriteOff,0))))) as FS_Balance,
				cas.Status,  
				cas.Initial_Status,
				cas.Accident_Date,		
				cas.Ins_Claim_Number, 
				pro.Provider_GroupName,
				CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age,
				CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start, 
				CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End,
				CONVERT(varchar(10), min(tre.Date_BillSent), 101) AS Date_BillSent, 
				cas.DenialReasons_Type as  DenialReasons,
				--dbo.fncGetDenialReasons(cas.Case_Id) AS DenialReasons,
				dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
				pro.packet_type
			FROM dbo.tblCase cas
				INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id 
				INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
				LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id
				LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID
			WHERE
				cas.DomainId = @DomainID
				AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
				AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
				AND cas.CASE_ID NOT LIKE 'ACT%'  --and status <> 'IN ARB OR LIT'
				AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
				AND (@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
				AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
				AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
				AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+' ' +ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') +' ' + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
				AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+' ' +ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') +' ' + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
				AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
				AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')
				AND ((@s_a_Type='0' and ISNULL(pkt.PacketID,'') ='') OR(@s_a_Type='1' and ISNULL(pkt.PacketID,'') <> ''))
				AND (@s_a_ProviderGroup  ='' OR pro.Provider_GroupName=@s_a_ProviderGroup )
				AND (@s_a_InitialStatus  ='' OR cas.Initial_Status=@s_a_InitialStatus)
				AND ((@i_a_FromStatusAge = 0 and @i_a_ToStatusAge = 0) OR CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) Between @i_a_FromStatusAge and @i_a_ToStatusAge)
			Group by 	
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code,
				pkt.PacketID,
				cas.InjuredParty_FirstName,
				cas.InjuredParty_LastName,
				pro.Provider_Name,
				ins.InsuranceCompany_Name,
				cas.Claim_Amount,
				cas.Fee_Schedule,
				cas.Status,
				cas.Accident_Date,		
				cas.Initial_Status,
				pro.Provider_GroupName,
				cas.Paid_Amount,
				cas.WriteOff,
				cas.Ins_Claim_Number,
				Cas.Date_Opened,
				Cas.Date_Status_Changed,
				cas.DenialReasons_Type,
				pro.packet_type
			ORDER BY Provider_Name, InjuredParty_Name, 	DateOfService_Start
	END
	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
END


