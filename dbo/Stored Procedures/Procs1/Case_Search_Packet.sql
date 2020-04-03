
CREATE PROCEDURE [dbo].[Case_Search_Packet] --[F_Case_Search_Packet] 'sa'
(
	 @DomainID VARCHAR(50),
	 @s_a_ProviderNameGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_InsuranceGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_CaseTypeGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_CourtGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_InitialStatusGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_CurrentStatusGroupSel	VARCHAR(MAX)	=	'',
	 @s_a_MultipleCase_ID VARCHAR(MAX)	=	'',
	 @s_a_Case_ID	VARCHAR(100)	=	'',
	 @s_a_OldCaseId	VARCHAR(100)	=	'',
	 @s_a_PacketID	VARCHAR(100)	=	'',
	 @s_a_InjuredName	VARCHAR(100)	=	'',
	 @s_a_InsuredName	VARCHAR(100)	=	'',
	 @s_a_IndexOrAAANo	VARCHAR(100)	=	'',
	 @s_a_PolicyNo	VARCHAR(100)	=	'',
	 @s_a_ClaimNo	VARCHAR(100)	=	''	,
	 @s_a_ProviderGroup	VARCHAR(100)	=	'',
	 @s_a_FinalStatus	VARCHAR(100)	=	'',
	 @s_a_Forum	VARCHAR(100)	=	''							 
)
AS
BEGIN	
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
	--select Fee_Schedule,* from tblCase
	SELECT distinct
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code AS Case_Code,
		pkt.PacketID AS PacketID,
		cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,  
		Provider_Name + ISNULL(' [ ' + pro.Provider_Groupname + ' ]','') as Provider_Name,  
		ins.InsuranceCompany_Name,  
		cas.Indexoraaa_number,  
		convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount) - convert(float,ISNULL(cas.WriteOff,0))))) as Claim_Amount,
		convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount) - convert(float,ISNULL(cas.WriteOff,0))))) as FS_Balance,
		court.Court_Name,
		cas.Status,  
		cas.Initial_Status,
		cas.Accident_Date,		
		cas.Ins_Claim_Number, 
		pro.Provider_GroupName,
		pkt_typ.CaseType,
		sta.Final_Status,
		sta.forum,
		CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start, 
		CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End,
		CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age
			
	FROM dbo.tblCase cas
	INNER JOIN dbo.tblprovider pro on cas.provider_id=pro.provider_id 
	INNER JOIN dbo.tblinsurancecompany ins on cas.insurancecompany_id=ins.insurancecompany_id
	INNER JOIN dbo.tblStatus sta on cas.Status=sta.Status_Type AND cas.DomainId= sta.DomainId
	LEFT OUTER JOIN dbo.tblTreatment tre on tre.Case_Id= cas.Case_Id
	LEFT OUTER JOIN dbo.tblCourt court on cas.Court_Id = court.Court_Id
	LEFT OUTER JOIN dbo.TXN_CASE_PEER_REVIEW_DOCTOR prdoc on prdoc.TREATMENT_ID = tre.treatment_id
	LEFT OUTER JOIN dbo.TXN_tblTreatment t_tre on t_tre.Treatment_Id = tre.treatment_id
	LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
	LEFT OUTER JOIN dbo.MST_PacketCaseType pkt_typ ON pkt.FK_CaseType_Id = pkt_typ.PK_CaseType_Id

	
	--LEFT OUTER JOIN dbo.tbl_FinalStatus FS ON FS.FinalStatus_Name = pkt.Packet_Auto_ID 
	--LEFT OUTER JOIN dbo.tbl_Forum F ON F.Forum_Name = pkt_typ.PK_CaseType_Id
	
	WHERE
		cas.DomainId = @DomainID
		AND ISNULL(cas.IsDeleted,0) = 0
		AND (@s_a_ProviderNameGroupSel  ='' OR cas.Provider_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_ProviderNameGroupSel,',')))
		AND (@s_a_InsuranceGroupSel  ='' OR cas.InsuranceCompany_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_InsuranceGroupSel,',')))
		AND (@s_a_CaseTypeGroupSel  ='' OR pkt.FK_CaseType_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_CaseTypeGroupSel,',')))
		AND (@s_a_CourtGroupSel  ='' OR cas.Court_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_CourtGroupSel,',')))
		AND (@s_a_InitialStatusGroupSel ='' OR cas.Initial_Status IN (SELECT s FROM dbo.SplitString(@s_a_InitialStatusGroupSel,',')))
		AND (@s_a_CurrentStatusGroupSel ='' OR cas.Status IN (SELECT s FROM dbo.SplitString(@s_a_CurrentStatusGroupSel,',')))
		AND  cas.Case_Id not Like 'ACT%' 
		AND (@s_a_MultipleCase_ID ='' OR cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) OR  cas.Case_Id IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,' ')))
		AND (@s_a_Case_ID ='' OR cas.Case_Id like '%'+ @s_a_Case_ID + '%')
		AND (@s_a_OldCaseId ='' OR cas.Case_Code like '%'+ @s_a_OldCaseId + '%')
		AND (@s_a_PacketID ='' OR pkt.PacketID like '%'+ @s_a_PacketID + '%')
		AND (@s_a_InjuredName ='' OR ISNULL(cas.InjuredParty_FirstName,'')+' ' +ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR  ISNULL(cas.InjuredParty_LastName,'') +' ' + ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_LastName,'') like '%'+ @s_a_InjuredName + '%'  OR ISNULL(cas.InjuredParty_FirstName,'') like '%'+ @s_a_InjuredName + '%')
		AND (@s_a_InsuredName ='' OR ISNULL(cas.InsuredParty_FirstName,'')+' ' +ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR  ISNULL(cas.InsuredParty_LastName,'') +' ' + ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_LastName,'') like '%'+ @s_a_InsuredName + '%'  OR ISNULL(cas.InsuredParty_FirstName,'') like '%'+ @s_a_InsuredName + '%')
		AND (@s_a_IndexOrAAANo ='' OR cas.IndexOrAAA_Number like '%'+ @s_a_IndexOrAAANo + '%')
		AND (@s_a_PolicyNo ='' OR cas.Policy_Number like '%'+ @s_a_PolicyNo + '%')
		AND (@s_a_ClaimNo ='' OR cas.Ins_Claim_Number like '%'+ @s_a_ClaimNo + '%')

		AND (@s_a_ProviderGroup  ='' OR ISNULL (pro.Provider_GroupName,'')= @s_a_ProviderGroup)
		AND (@s_a_FinalStatus  ='' OR  ISNULL (sta.Final_Status,'')= @s_a_FinalStatus )
		AND (@s_a_Forum  ='' OR ISNULL (sta.forum,'')= @s_a_Forum )


	Group by 	
		cas.Case_Id,
		cas.Case_AutoId,
		cas.Case_Code,
		pkt.PacketID,
		cas.InjuredParty_FirstName,
		cas.InjuredParty_LastName,
		pro.Provider_Name,
		ins.InsuranceCompany_Name,
		cas.Indexoraaa_number,
		cas.Claim_Amount,
		cas.Fee_Schedule,
		court.Court_Name,
		cas.Status,
		cas.Accident_Date,		
		cas.Initial_Status,
		pro.Provider_GroupName,
		cas.Paid_Amount,
		cas.WriteOff,
		cas.Ins_Claim_Number,
		pkt_typ.CaseType,
		Cas.Date_Opened,
		Cas.Date_Status_Changed,
		pro.Provider_GroupName,
		sta.Final_Status,
		sta.forum
	ORDER BY Case_AutoId	desc
--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS		
END


